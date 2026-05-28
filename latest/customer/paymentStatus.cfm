<!---
    /latest/customer/paymentStatus.cfm — JSON poll for checkout page.
--->
<cfinclude template="../../application.cfm">
<cfinclude template="inc_emenu_order.cfm">
<cfinclude template="inc_xendit_pay.cfm">
<cfsetting showdebugoutput="false">
<cfcontent type="application/json; charset=utf-8" reset="true">

<cfparam name="url.payment_id" default="0">
<cfset paymentId = val(url.payment_id)>
<cfset out = { paid=false, failed=false, status="pending", method="" }>

<cfif paymentId lte 0 OR val(SESSION.emenu_order_id) lte 0>
    <cfoutput>#serializeJSON(out)#</cfoutput>
    <cfabort>
</cfif>

<cfset orderId = val(SESSION.emenu_order_id)>
<cfquery name="qPay" datasource="#dts#">
    SELECT payment_id, order_id, payment_method, status, gateway_transaction_id
    FROM app_payments
    WHERE payment_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#paymentId#">
      AND order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">
    LIMIT 1
</cfquery>

<cfif qPay.recordCount>
    <cfset out.method = lCase(trim(qPay.payment_method))>
    <cfset out.status = lCase(trim(qPay.status))>
    <cfif out.status eq "success">
        <cfset out.paid = true>
    <cfelseif out.status eq "failed">
        <cfset out.failed = true>
    <cfelseif len(trim(qPay.gateway_transaction_id)) AND REQUEST.xendit.isActive>
        <cfset pgProf = emenuPgProfile(dts)>
        <cfif pgProf.xendit_ready>
            <cfset chk = pgGetPaymentRequest(pgProf.xendit_account_id, trim(qPay.gateway_transaction_id))>
            <cfif chk.isPaid>
                <cfset emenuFinalizeOnlinePayment(dts, orderId, paymentId)>
                <cfset out.paid = true>
                <cfset out.status = "success">
            <cfelseif uCase(chk.status) eq "FAILED">
                <cfset out.failed = true>
                <cfset out.status = "failed">
            </cfif>
        </cfif>
    </cfif>
</cfif>

<cfquery name="qOrd" datasource="#dts#">
    SELECT status FROM app_orders WHERE order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#"> LIMIT 1
</cfquery>
<cfif qOrd.recordCount AND emenuOrderIsPaid(dts, orderId, qOrd.status)>
    <cfset out.paid = true>
</cfif>

<cfoutput>#serializeJSON(out)#</cfoutput>
