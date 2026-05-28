<!---
    /PaymentGateway/paymentReturn.cfm — Return URL after e-wallet / card redirect.
--->
<cfinclude template="/application.cfm">
<cfinclude template="/latest/customer/inc_emenu_order.cfm">
<cfinclude template="/latest/customer/inc_xendit_pay.cfm">
<cfsetting showdebugoutput="false">

<cfif structKeyExists(url, "failed")>
    <cflocation url="/PaymentGateway/payment.cfm?err=xendit_failed" addtoken="false">
</cfif>

<cfset paymentId = structKeyExists(SESSION, "emenu_payment_id") ? val(SESSION.emenu_payment_id) : 0>
<cfset orderId = val(SESSION.emenu_order_id)>
<cfif paymentId lte 0 OR orderId lte 0>
    <cflocation url="/PaymentGateway/payment.cfm" addtoken="false">
</cfif>

<cfquery name="qPay" datasource="#dts#">
    SELECT payment_method, gateway_transaction_id, status
    FROM app_payments
    WHERE payment_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#paymentId#">
      AND order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">
    LIMIT 1
</cfquery>

<cfif qPay.recordCount AND lCase(qPay.status) eq "success">
    <cflocation url="/PaymentGateway/payment_done.cfm?method=#urlEncodedFormat(qPay.payment_method)#" addtoken="false">
</cfif>

<cfset pgProf = emenuPgProfile(dts)>
<cfif qPay.recordCount AND len(trim(qPay.gateway_transaction_id)) AND REQUEST.xendit.isActive>
    <cfset forUserId = "">
    <cfif len(trim(pgProf.xendit_account_id))>
        <cfset forUserId = trim(pgProf.xendit_account_id)>
    </cfif>
    <cfset chk = pgGetPaymentRequest(forUserId, trim(qPay.gateway_transaction_id))>
    <cfif chk.isPaid>
        <cfset emenuFinalizeOnlinePayment(dts, orderId, paymentId)>
        <cflocation url="/PaymentGateway/payment_done.cfm?method=#urlEncodedFormat(qPay.payment_method)#" addtoken="false">
    </cfif>
</cfif>

<cflocation url="/PaymentGateway/paymentCheckout.cfm?payment_id=#paymentId#" addtoken="false">
