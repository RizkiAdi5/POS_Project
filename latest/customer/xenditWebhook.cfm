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

<!--- Resolve dts — try two sources in priority order:
     1. payload.metadata.dts (set on every invoice we create)
     2. external_id prefix with __ separator (legacy format) --->
<cfset resolvedDts = "">

<!--- 1. metadata.dts --->
<cfif structKeyExists(payload, "metadata") AND isStruct(payload.metadata) AND structKeyExists(payload.metadata, "dts") AND len(trim(payload.metadata.dts))>
    <cfset resolvedDts = trim(payload.metadata.dts)>
</cfif>

<!--- 2. legacy external_id prefix --->
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
    FROM   master_api
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
        </cfif>
        <cfcatch type="any"><!--- swallow — always return 200 so Xendit doesn't retry --->
        </cfcatch>
    </cftry>
</cfif>

<cfheader statuscode="200" statustext="OK">
<cfoutput>{"status":"ok"}</cfoutput>
