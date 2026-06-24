<!---
    /latest/customer/xenditWebhook.cfm
    Receives Xendit payment status callbacks.
    Verifies x-callback-token, marks order paid, awards loyalty points.
    Configure in Xendit dashboard: POST https://yourdomain.com/latest/customer/xenditWebhook.cfm
--->
<cfprocessingdirective pageencoding="UTF-8">
<cfinclude template="../../application.cfm">
<cfinclude template="inc_emenu_order.cfm">
<cfsetting showdebugoutput="false">
<cfcontent type="application/json" reset="true">

<cfif CGI.REQUEST_METHOD neq "POST">
    <cfheader statuscode="405" statustext="Method Not Allowed">
    <cfoutput>{"error":"method_not_allowed"}</cfoutput>
    <cfabort>
</cfif>

<cfset reqData       = getHttpRequestData()>
<cfset callbackToken = structKeyExists(reqData.headers, "x-callback-token") ? trim(reqData.headers["x-callback-token"]) : "">
<cfset rawBody       = toString(reqData.content)>

<!--- Parse JSON body first — we need dts from payload before we can query the DB --->
<cftry>
    <cfset payload = deserializeJSON(rawBody)>
    <cfcatch type="any">
        <cfheader statuscode="400" statustext="Bad Request">
        <cfoutput>{"error":"invalid_json"}</cfoutput>
        <cfabort>
    </cfcatch>
</cftry>

<cfif NOT structKeyExists(payload, "id") OR NOT structKeyExists(payload, "status")>
    <cfheader statuscode="400" statustext="Bad Request">
    <cfoutput>{"error":"missing_fields"}</cfoutput>
    <cfabort>
</cfif>

<cfset xenditInvoiceId = trim(payload.id)>
<cfset xenditStatus    = uCase(trim(payload.status))>

<!--- Resolve dts — try three sources in priority order:
     1. main.xendit_invoice_dts lookup table (most reliable)
     2. payload.metadata.dts (new invoice format)
     3. external_id prefix with __ separator (legacy format) --->
<cfset resolvedDts = "">

<!--- 1. Lookup table via any known datasource — use pos_i as the gateway to main schema --->
<cftry>
    <cfquery name="qInvDts" datasource="pos_i">
        SELECT dts FROM main.xendit_invoice_dts
        WHERE  xendit_invoice_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#xenditInvoiceId#">
        LIMIT  1
    </cfquery>
    <cfif qInvDts.recordCount AND len(trim(qInvDts.dts))>
        <cfset resolvedDts = trim(qInvDts.dts)>
    </cfif>
<cfcatch type="any"><!--- table not yet created, fall through --->
</cfcatch>
</cftry>

<!--- 2. metadata.dts --->
<cfif NOT len(resolvedDts) AND structKeyExists(payload, "metadata") AND isStruct(payload.metadata) AND structKeyExists(payload.metadata, "dts") AND len(trim(payload.metadata.dts))>
    <cfset resolvedDts = trim(payload.metadata.dts)>
</cfif>

<!--- 3. legacy external_id prefix --->
<cfif NOT len(resolvedDts) AND structKeyExists(payload, "external_id") AND find("__", payload.external_id)>
    <cfset resolvedDts = listFirst(trim(payload.external_id), "__")>
</cfif>

<cfif NOT len(resolvedDts)>
    <cfheader statuscode="400" statustext="Bad Request">
    <cfoutput>{"error":"cannot_resolve_tenant"}</cfoutput>
    <cfabort>
</cfif>

<cfset dts = resolvedDts>

<!--- Now verify token against DB using the resolved dts --->
<cfquery name="qGateway" datasource="#dts#">
    SELECT webhook_token
    FROM   main.master_api
    WHERE  provider  = <cfqueryparam cfsqltype="cf_sql_varchar" value="Xendit">
      AND  is_active = <cfqueryparam cfsqltype="cf_sql_varchar" value="Y">
    LIMIT  1
</cfquery>

<cfif qGateway.recordCount eq 0 OR callbackToken neq trim(qGateway.webhook_token)>
    <cfheader statuscode="401" statustext="Unauthorized">
    <cfoutput>{"error":"unauthorized"}</cfoutput>
    <cfabort>
</cfif>

<cfif listFindNoCase("PAID,SETTLED", xenditStatus)>
    <cftry>
        <cfquery name="qPay" datasource="#dts#">
            SELECT p.payment_id, p.order_id, p.status AS pay_status,
                   o.status AS ord_status, o.order_number, o.custno, o.total_amount
            FROM   app_payments p
            JOIN   app_orders   o ON o.order_id = p.order_id
            WHERE  p.gateway_invoice_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#xenditInvoiceId#">
            LIMIT  1
        </cfquery>

        <cfif qPay.recordCount AND qPay.pay_status neq "success">
            <cfquery datasource="#dts#">
                UPDATE app_payments
                SET    status  = <cfqueryparam cfsqltype="cf_sql_varchar"   value="success">,
                       paid_at = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                WHERE  gateway_invoice_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#xenditInvoiceId#">
            </cfquery>
            <cfquery datasource="#dts#">
                UPDATE app_orders
                SET    status       = <cfqueryparam cfsqltype="cf_sql_varchar"   value="paid">,
                       completed_at = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(qPay.order_id)#">
                  AND  status NOT IN ('paid','completed','cancelled')
            </cfquery>
            <cfset custno = trim(qPay.custno)>
            <cfif len(custno) AND custno neq "-">
                <cfset emenuAwardLoyaltyPoints(dts, custno, qPay.order_number, val(qPay.total_amount))>
            </cfif>

            <!--- Record pending disbursement — client withdraws manually via Payout Withdrawal page --->
            <cftry>
                <cfquery name="qAcct" datasource="#dts#">
                    SELECT platform_fee_pct
                    FROM   main.client_payment_accounts
                    WHERE  dts       = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#">
                      AND  is_active = 1
                      AND  is_default = 1
                    LIMIT  1
                </cfquery>
                <cfset grossAmt = val(qPay.total_amount)>
                <cfset feePct   = (qAcct.recordCount ? val(qAcct.platform_fee_pct) : 0)>
                <cfset platFee  = round(grossAmt * feePct / 100)>
                <cfset disbAmt  = grossAmt - platFee>
                <cfquery datasource="#dts#">
                    INSERT INTO main.disbursements
                        (dts, order_id, gross_amount, platform_fee, xendit_fee, disburse_amount, status)
                    VALUES (
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#val(qPay.order_id)#">,
                        <cfqueryparam cfsqltype="cf_sql_decimal" value="#grossAmt#" scale="2">,
                        <cfqueryparam cfsqltype="cf_sql_decimal" value="#platFee#"  scale="2">,
                        <cfqueryparam cfsqltype="cf_sql_decimal" value="0"          scale="2">,
                        <cfqueryparam cfsqltype="cf_sql_decimal" value="#disbAmt#"  scale="2">,
                        'pending'
                    )
                </cfquery>
            <cfcatch type="any">
                <cflog file="xendit_error" type="warning"
                       text="Failed to record disbursement for order #val(qPay.order_id)#: #cfcatch.message#">
            </cfcatch>
            </cftry>
        </cfif>
        <cfcatch type="any"><!--- swallow — always return 200 so Xendit doesn't retry --->
        </cfcatch>
    </cftry>
</cfif>

<cfheader statuscode="200" statustext="OK">
<cfoutput>{"status":"ok"}</cfoutput>
