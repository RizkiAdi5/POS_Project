<!---
    /latest/customer/paymentProcess.cfm
    Xendit online payment or pay-at-cashier request.
--->
<cfinclude template="../../application.cfm">
<cfinclude template="inc_emenu_order.cfm">

<cfif NOT len(trim(SESSION.emenu_table_id)) OR val(SESSION.emenu_order_id) lte 0>
    <cflocation url="/latest/customer/qr_error.cfm" addtoken="false">
</cfif>
<cfif CGI.REQUEST_METHOD neq "POST" OR NOT structKeyExists(FORM, "pay_action")>
    <cflocation url="/latest/customer/payment.cfm" addtoken="false">
</cfif>

<cfset orderId   = val(SESSION.emenu_order_id)>
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

<cfquery name="qItemCnt" datasource="#dts#">
    SELECT COUNT(*) AS row_count FROM app_order_items
    WHERE order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">
</cfquery>
<cfif val(qItemCnt.row_count) eq 0>
    <cflocation url="/latest/customer/menu.cfm?msg=no_items" addtoken="false">
</cfif>

<cfset totals      = emenuRecalculateOrderTotals(dts, orderId)>
<cfset payAmount   = val(totals.total_amount)>
<cfif payAmount lte 0><cfset payAmount = val(qOrd.total_amount)></cfif>
<cfset orderNumber = trim(qOrd.order_number)>

<!--- Loyalty points redemption --->
<cfset pointsRedeemed = 0>
<cfset custno = trim(qOrd.custno)>
<cfif structKeyExists(FORM, "points_to_redeem") AND val(FORM.points_to_redeem) gt 0
      AND len(custno) AND custno neq "-">
    <cfset ptsRequested = int(val(FORM.points_to_redeem))>
    <!--- Cap at bill total to never produce a negative payAmount --->
    <cfset ptsCapped = min(ptsRequested, int(payAmount))>
    <cfif ptsCapped gt 0>
        <cfset pointsRedeemed = emenuRedeemLoyaltyPoints(dts, custno, orderNumber, ptsCapped)>
        <cfset payAmount = max(0, payAmount - pointsRedeemed)>
    </cfif>
</cfif>

<!--- AI_SHARED_SECRET must match WEB-INF/ai/.env --->
<cfset AI_SHARED_SECRET = "cleRkQqi7ogrKX5mAn6xr8LXmz9MobDlzcnKAYYHYCIqDnBy2c5bfuWRyrXDTcVw">

<cftry>
    <cfif payAction eq "online">
        <cfset xScheme  = (CGI.HTTPS eq "on" OR CGI.SERVER_PORT eq "443") ? "https" : "http">
        <cfset baseUrl  = xScheme & "://" & CGI.SERVER_NAME>
        <cfif (xScheme eq "http" AND CGI.SERVER_PORT neq "80") OR (xScheme eq "https" AND CGI.SERVER_PORT neq "443")>
            <cfset baseUrl = baseUrl & ":" & CGI.SERVER_PORT>
        </cfif>

        <!--- Resolve currency from tenant's country code --->
        <cfset xCurrency = "IDR">
        <cftry>
            <cfquery name="qDtsCtry" datasource="#dts#">
                SELECT userCty FROM main.users
                WHERE  userDept = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#">
                  AND  userCty IS NOT NULL AND userCty <> ''
                LIMIT  1
            </cfquery>
            <cfif qDtsCtry.recordCount AND len(trim(qDtsCtry.userCty))>
                <cfset ctryCode = uCase(trim(qDtsCtry.userCty))>
                <cfset currencyMap = {"ID"="IDR","MY"="MYR","PH"="PHP","TH"="THB","VN"="VND"}>
                <cfif structKeyExists(currencyMap, ctryCode)>
                    <cfset xCurrency = currencyMap[ctryCode]>
                </cfif>
            </cfif>
        <cfcatch type="any"><!--- fall back to IDR --->
        </cfcatch>
        </cftry>

        <cfset xPayload = structNew()>
        <cfset xPayload.dts                  = dts>
        <cfset xPayload.external_id          = orderNumber>
        <cfset xPayload.metadata             = {"dts" = dts}>
        <cfset xPayload.amount               = javaCast("int", round(payAmount))>
        <cfset xPayload.description          = "Order " & orderNumber>
        <cfset xPayload.currency             = xCurrency>
        <cfset xPayload.success_redirect_url = baseUrl & "/latest/customer/payment_done.cfm?method=xendit">
        <cfset xPayload.failure_redirect_url = baseUrl & "/latest/customer/payment.cfm?err=xendit_failed">

        <!--- Read client's enabled payment methods (empty = show all) --->
        <cftry>
            <cfquery name="qEnabledMethods" datasource="#dts#">
                SELECT method_code FROM payment_method_config
                WHERE  is_enabled = 1
            </cfquery>
            <cfif qEnabledMethods.recordCount gt 0>
                <cfset methodArray = []>
                <cfloop query="qEnabledMethods">
                    <cfset arrayAppend(methodArray, trim(qEnabledMethods.method_code))>
                </cfloop>
                <cfset xPayload.payment_methods = methodArray>
            </cfif>
        <cfcatch type="any"><!--- table not yet created — no restriction applied --->
        </cfcatch>
        </cftry>

        <!--- Route through Node.js sidecar so TLS 1.2 is handled by Node, not CF10's JVM --->
        <cfhttp url="http://127.0.0.1:8088/xendit/invoice" method="POST"
                result="xenditResp" timeout="30">
            <cfhttpparam type="header" name="Content-Type"  value="application/json">
            <cfhttpparam type="header" name="x-ai-secret"  value="#AI_SHARED_SECRET#">
            <cfhttpparam type="body"   value="#serializeJSON(xPayload)#">
        </cfhttp>

        <cfset xenditData = deserializeJSON(xenditResp.fileContent)>
        <cfif NOT structKeyExists(xenditData, "invoice_url")>
            <cflog file="xendit_error" type="error"
                   text="Xendit bad response (#xenditResp.statusCode#): #xenditResp.fileContent#">
            <cfthrow message="Xendit did not return invoice_url">
        </cfif>

        <cfquery datasource="#dts#">
            INSERT INTO app_payments
                (order_id, payment_method, amount, status, gateway_name,
                 gateway_invoice_id, gateway_invoice_url)
            VALUES (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="online">,
                <cfqueryparam cfsqltype="cf_sql_decimal" value="#payAmount#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="pending">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="xendit">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#xenditData.id#">,
                <cfqueryparam cfsqltype="cf_sql_clob"    value="#xenditData.invoice_url#">
            )
        </cfquery>

<cflocation url="#xenditData.invoice_url#" addtoken="false">

    <cfelseif payAction eq "cashier">
        <cfquery datasource="#dts#">
            INSERT INTO app_payments
                (order_id, payment_method, amount, status)
            VALUES (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="cash">,
                <cfqueryparam cfsqltype="cf_sql_decimal" value="#payAmount#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="pending">
            )
        </cfquery>
        <cflocation url="/latest/customer/payment_done.cfm?method=cashier" addtoken="false">

    <cfelse>
        <cflocation url="/latest/customer/payment.cfm?err=invalid_action" addtoken="false">
    </cfif>
    <cfcatch type="any">
        <cflog file="xendit_error" type="error"
               text="paymentProcess error: #cfcatch.message# | #cfcatch.detail#">
        <cflocation url="/latest/customer/payment.cfm?err=payment_failed" addtoken="false">
    </cfcatch>
</cftry>
