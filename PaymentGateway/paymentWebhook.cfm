<!---
    /PaymentGateway/paymentWebhook.cfm — Xendit webhook endpoint.
--->
<cfinclude template="/application.cfm">
<cfinclude template="/latest/customer/inc_emenu_order.cfm">
<cfinclude template="/latest/customer/inc_xendit_pay.cfm">
<cfsetting showdebugoutput="false">
<cfcontent type="application/json; charset=utf-8" reset="true">

<cfset reqData = GetHttpRequestData()>
<cfset token = "">
<cfif isStruct(reqData) AND structKeyExists(reqData, "headers") AND isStruct(reqData.headers)>
    <cfif structKeyExists(reqData.headers, "x-callback-token")><cfset token = reqData.headers["x-callback-token"]>
    <cfelseif structKeyExists(reqData.headers, "X-Callback-Token")><cfset token = reqData.headers["X-Callback-Token"]>
    </cfif>
</cfif>
<cfif len(REQUEST.xendit.webhookToken) AND NOT pgValidateWebhookToken(REQUEST.xendit.webhookToken, token)>
    <cfheader statuscode="401" statustext="Unauthorized">
    <cfoutput>{"ok":false}</cfoutput>
    <cfabort>
</cfif>

<cfset raw = toString(GetHttpRequestData().content)>
<cfset evt = structNew()>
<cftry>
    <cfset evt = deserializeJSON(raw)>
    <cfcatch type="any">
        <cfoutput>{"ok":true}</cfoutput>
        <cfabort>
    </cfcatch>
</cftry>

<cfset eventName = "">
<cfif structKeyExists(evt, "event")><cfset eventName = evt.event></cfif>
<cfset data = structKeyExists(evt, "data") ? evt.data : evt>
<cfset refId = "">
<cfset prId = "">
<cfset payStatus = "">

<cfif isStruct(data)>
    <cfif structKeyExists(data, "reference_id")><cfset refId = data.reference_id></cfif>
    <cfif structKeyExists(data, "payment_request_id")><cfset prId = data.payment_request_id></cfif>
    <cfif structKeyExists(data, "status")><cfset payStatus = data.status></cfif>
    <cfif structKeyExists(data, "payment_id") AND NOT len(prId)><cfset prId = data.payment_id></cfif>
</cfif>

<cfset isPaidEvent = findNoCase("paid", eventName) OR findNoCase("succeed", eventName) OR uCase(payStatus) eq "SUCCEEDED">
<cfif isPaidEvent AND (len(refId) OR len(prId))>
    <cftry>
        <cfset foundDsn = "">
        <cfset foundPaymentId = 0>
        <cfset foundOrderId = 0>
        <cfset payIdFromRef = 0>
        <cfif len(refId) AND left(refId, 6) eq "emenu-">
            <cfset payIdFromRef = val(listGetAt(refId, 3, "-"))>
        </cfif>
        <cfquery name="qPay" datasource="#dts#">
            SELECT payment_id, order_id, status FROM app_payments
            WHERE gateway_name = <cfqueryparam value="xendit" cfsqltype="cf_sql_varchar">
            <cfif len(prId)>
              AND gateway_transaction_id = <cfqueryparam value="#prId#" cfsqltype="cf_sql_varchar">
            <cfelseif payIdFromRef gt 0>
              AND payment_id = <cfqueryparam value="#payIdFromRef#" cfsqltype="cf_sql_integer">
            </cfif>
            ORDER BY payment_id DESC LIMIT 1
        </cfquery>
        <cfif qPay.recordCount>
            <cfset foundDsn = dts>
            <cfset foundPaymentId = val(qPay.payment_id)>
            <cfset foundOrderId = val(qPay.order_id)>
        <cfelse>
            <!--- Multi-tenant fallback: resolve datasource by transaction id / payment id --->
            <cfquery name="qTenants" datasource="main">
                SELECT DISTINCT userdept
                FROM users
                WHERE userdept IS NOT NULL
                  AND TRIM(userdept) <> ''
                ORDER BY userdept
            </cfquery>
            <cfloop query="qTenants">
                <cfset tenantDsn = trim(qTenants.userdept)>
                <cfif NOT len(tenantDsn)><cfcontinue></cfif>
                <cftry>
                    <cfquery name="qPayTenant" datasource="#tenantDsn#">
                        SELECT payment_id, order_id, status
                        FROM app_payments
                        WHERE gateway_name = <cfqueryparam value="xendit" cfsqltype="cf_sql_varchar">
                        <cfif len(prId)>
                          AND gateway_transaction_id = <cfqueryparam value="#prId#" cfsqltype="cf_sql_varchar">
                        <cfelseif payIdFromRef gt 0>
                          AND payment_id = <cfqueryparam value="#payIdFromRef#" cfsqltype="cf_sql_integer">
                        </cfif>
                        ORDER BY payment_id DESC LIMIT 1
                    </cfquery>
                    <cfif qPayTenant.recordCount>
                        <cfset foundDsn = tenantDsn>
                        <cfset foundPaymentId = val(qPayTenant.payment_id)>
                        <cfset foundOrderId = val(qPayTenant.order_id)>
                        <cfbreak>
                    </cfif>
                    <cfcatch type="any"></cfcatch>
                </cftry>
            </cfloop>
        </cfif>
        <cfif foundOrderId gt 0 AND foundPaymentId gt 0>
            <cfset emenuFinalizeOnlinePayment(foundDsn, foundOrderId, foundPaymentId)>
        </cfif>
        <cfcatch type="any"></cfcatch>
    </cftry>
</cfif>

<cfoutput>{"ok":true}</cfoutput>
