<!---
    /latest/customer/paymentWebhook.cfm — Xendit webhook (configure URL in Xendit Dashboard).
    Set webhook URL: https://YOUR-DOMAIN/latest/customer/paymentWebhook.cfm
--->
<cfinclude template="../../application.cfm">
<cfinclude template="inc_emenu_order.cfm">
<cfinclude template="inc_xendit_pay.cfm">
<cfsetting showdebugoutput="false">
<cfcontent type="application/json; charset=utf-8" reset="true">

<cfset reqData = GetHttpRequestData()>
<cfset token = "">
<cfif isStruct(reqData) AND structKeyExists(reqData, "headers") AND isStruct(reqData.headers)>
    <cfif structKeyExists(reqData.headers, "x-callback-token")><cfset token = reqData.headers["x-callback-token"]>
    <cfelseif structKeyExists(reqData.headers, "X-Callback-Token")><cfset token = reqData.headers["X-Callback-Token"]>
    </cfif>
</cfif>
<cfif len(REQUEST.xendit.webhookToken) AND token NEQ REQUEST.xendit.webhookToken>
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
        <cfquery name="qPay" datasource="#dts#">
            SELECT payment_id, order_id, status FROM app_payments
            WHERE gateway_name = <cfqueryparam value="xendit" cfsqltype="cf_sql_varchar">
            <cfif len(prId)>
              AND gateway_transaction_id = <cfqueryparam value="#prId#" cfsqltype="cf_sql_varchar">
            <cfelseif len(refId) AND left(refId, 6) eq "emenu-">
              AND payment_id = <cfqueryparam value="#listGetAt(refId, 3, '-')#" cfsqltype="cf_sql_integer">
            </cfif>
            ORDER BY payment_id DESC LIMIT 1
        </cfquery>
        <cfif qPay.recordCount AND lCase(qPay.status) neq "success">
            <cfset emenuFinalizeOnlinePayment(dts, val(qPay.order_id), val(qPay.payment_id))>
        </cfif>
        <cfcatch type="any"></cfcatch>
    </cftry>
</cfif>

<cfoutput>{"ok":true}</cfoutput>
