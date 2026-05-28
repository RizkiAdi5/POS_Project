<!---
    /latest/customer/paymentProcess.cfm — Start Xendit payment or cashier request.
--->
<cfinclude template="../../application.cfm">
<cfinclude template="inc_emenu_order.cfm">
<cfinclude template="inc_xendit_pay.cfm">

<cfif NOT len(trim(SESSION.emenu_table_id)) OR val(SESSION.emenu_order_id) lte 0>
    <cflocation url="/latest/customer/qr_error.cfm" addtoken="false">
</cfif>
<cfif CGI.REQUEST_METHOD neq "POST" OR NOT structKeyExists(FORM, "pay_action")>
    <cflocation url="/latest/customer/payment.cfm" addtoken="false">
</cfif>

<cfset orderId = val(SESSION.emenu_order_id)>
<cfset payAction = lCase(trim(FORM.pay_action))>

<cfquery name="qOrd" datasource="#dts#">
    SELECT order_id, order_number, status, total_amount, custno
    FROM   app_orders
    WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">
      AND  table_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(SESSION.emenu_table_id)#">
    LIMIT  1
</cfquery>

<cfif qOrd.recordCount eq 0>
    <cflocation url="/latest/customer/payment.cfm?err=order_not_found" addtoken="false">
</cfif>
<cfif emenuOrderIsPaid(dts, orderId, qOrd.status)>
    <cflocation url="/latest/customer/order_status.cfm?msg=already_paid" addtoken="false">
</cfif>

<cfset totals = emenuRecalculateOrderTotals(dts, orderId)>
<cfset payAmount = val(totals.total_amount)>
<cfif payAmount lte 0><cfset payAmount = val(qOrd.total_amount)></cfif>
<cfset orderNumber = trim(qOrd.order_number)>

<cftry>
    <cfif payAction eq "cashier">
        <cfquery datasource="#dts#">
            INSERT INTO app_payments (order_id, payment_method, amount, status)
            VALUES (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="cash">,
                <cfqueryparam cfsqltype="cf_sql_decimal" value="#payAmount#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="pending">
            )
        </cfquery>
        <cflocation url="/latest/customer/payment_done.cfm?method=cashier" addtoken="false">
    </cfif>

    <cfset pgProf = emenuPgProfile(dts)>
    <cfif NOT REQUEST.xendit.isActive OR NOT pgProf.ready OR NOT pgProf.xendit_ready>
        <cflocation url="/latest/customer/payment.cfm?err=xendit_not_ready" addtoken="false">
    </cfif>

    <cfset payMethod = payAction>
    <cfif NOT listFindNoCase("qris,ewallet,va,card", payMethod)>
        <cflocation url="/latest/customer/payment.cfm?err=invalid_action" addtoken="false">
    </cfif>
    <cfif payMethod eq "qris" AND pgProf.enable_qris NEQ "Y"><cflocation url="/latest/customer/payment.cfm?err=invalid_action" addtoken="false"></cfif>
    <cfif payMethod eq "ewallet" AND pgProf.enable_ewallet NEQ "Y"><cflocation url="/latest/customer/payment.cfm?err=invalid_action" addtoken="false"></cfif>
    <cfif payMethod eq "va" AND pgProf.enable_va NEQ "Y"><cflocation url="/latest/customer/payment.cfm?err=invalid_action" addtoken="false"></cfif>
    <cfif payMethod eq "card" AND pgProf.enable_card NEQ "Y"><cflocation url="/latest/customer/payment.cfm?err=invalid_action" addtoken="false"></cfif>

    <cfset ewChannel = structKeyExists(FORM, "ewallet_channel") ? trim(FORM.ewallet_channel) : "">
    <cfif payMethod eq "ewallet" AND NOT len(ewChannel)>
        <cflocation url="/latest/customer/payment.cfm?err=invalid_action" addtoken="false">
    </cfif>

    <cfset baseUrl = emenuPayBaseUrl()>
    <cfset returnUrl = baseUrl & "/latest/customer/paymentReturn.cfm">
    <cfset custName = len(trim(SESSION.emenu_name)) ? trim(SESSION.emenu_name) : "Guest">
    <cfset currency = pgCountryCurrency(pgProf.country_code, "IDR")>
    <cfset vaBank = pgVaBankCode(pgProf.payout_channel_code)>
    <cfif NOT len(vaBank)><cfset vaBank = "BCA"></cfif>

    <cfquery datasource="#dts#" result="insPay">
        INSERT INTO app_payments (order_id, payment_method, amount, status, gateway_name)
        VALUES (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#payMethod#">,
            <cfqueryparam cfsqltype="cf_sql_decimal" value="#payAmount#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="pending">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="xendit">
        )
    </cfquery>
    <cfset paymentId = 0>
    <cfif structKeyExists(insPay, "generatedKey") AND val(insPay.generatedKey)><cfset paymentId = val(insPay.generatedKey)>
    <cfelseif structKeyExists(insPay, "GENERATEDKEY") AND val(insPay.GENERATEDKEY)><cfset paymentId = val(insPay.GENERATEDKEY)>
    </cfif>
    <cfif paymentId lte 0>
        <cfquery name="qLastPay" datasource="#dts#">
            SELECT MAX(payment_id) AS pid FROM app_payments
            WHERE order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">
        </cfquery>
        <cfset paymentId = val(qLastPay.pid)>
    </cfif>
    <cfset refId = "emenu-" & orderId & "-" & paymentId>

    <cfset xPay = pgCreatePaymentRequest(
        pgProf.xendit_account_id,
        payAmount,
        currency,
        pgProf.country_code,
        payMethod,
        refId,
        returnUrl,
        returnUrl & "?failed=1",
        custName,
        ewChannel,
        vaBank
    )>

    <cfif NOT xPay.ok>
        <cfquery datasource="#dts#">
            UPDATE app_payments SET status = <cfqueryparam value="failed" cfsqltype="cf_sql_varchar">,
                failure_reason = <cfqueryparam value="#left(xPay.message, 500)#" cfsqltype="cf_sql_varchar">
            WHERE payment_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#paymentId#">
        </cfquery>
        <cflocation url="/latest/customer/payment.cfm?err=xendit_failed" addtoken="false">
    </cfif>

    <cfquery datasource="#dts#">
        UPDATE app_payments SET
            status = <cfqueryparam cfsqltype="cf_sql_varchar" value="processing">,
            gateway_transaction_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#xPay.paymentRequestId#" null="#NOT len(xPay.paymentRequestId)#">,
            gateway_response = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#serializeJSON(xPay.data)#">
        WHERE payment_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#paymentId#">
    </cfquery>

    <cfset SESSION.emenu_payment_id = paymentId>
    <cfset SESSION.emenu_pay_method = payMethod>

    <cfif len(xPay.actions.redirectUrl) OR len(xPay.actions.deeplink)>
        <cfset jumpUrl = len(xPay.actions.redirectUrl) ? xPay.actions.redirectUrl : xPay.actions.deeplink>
        <cflocation url="#jumpUrl#" addtoken="false">
    </cfif>

    <cflocation url="/latest/customer/paymentCheckout.cfm?payment_id=#paymentId#" addtoken="false">

    <cfcatch type="any">
        <cflocation url="/latest/customer/payment.cfm?err=payment_failed" addtoken="false">
    </cfcatch>
</cftry>
