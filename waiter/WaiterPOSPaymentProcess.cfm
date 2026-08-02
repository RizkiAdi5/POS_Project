<!---
    /latest/Waiter/WaiterPOSPaymentProcess.cfm
    Cash: record payment + flip app_orders.status='paid' immediately (there is
    no webhook for cash, so unlike Xendit this file must set it explicitly —
    otherwise the order would never show up in Waiter/Orders.cfm, which only
    lists status='paid').
    Online: create a Xendit invoice (same payload shape as
    latest/customer/paymentProcess.cfm) and redirect the browser straight to
    Xendit's hosted invoice page — same behavior as customer/payment.cfm.
    xenditWebhook.cfm needs no changes since it resolves the tenant purely
    from payload.metadata.dts.
--->
<cfprocessingdirective pageencoding="UTF-8">
<cfinclude template="/application.cfm">
<cfinclude template="/latest/customer/inc_emenu_order.cfm">
<cfsetting showdebugoutput="false">

<cfparam name="SESSION.wpos_order_id"     default="">
<cfparam name="SESSION.wpos_order_number" default="">
<cfparam name="SESSION.wpos_table_id"     default="">
<cfparam name="SESSION.wpos_table_number" default="">
<cfparam name="SESSION.wpos_is_takeaway"  default="No">

<cfif val(SESSION.wpos_order_id) lte 0>
    <cflocation url="WaiterPOS.cfm" addtoken="false">
</cfif>
<cfif CGI.REQUEST_METHOD neq "POST" OR NOT structKeyExists(FORM, "pay_action")>
    <cflocation url="WaiterPOSPayment.cfm" addtoken="false">
</cfif>

<cfset orderId   = val(SESSION.wpos_order_id)>
<cfset payAction = lCase(trim(FORM.pay_action))>

<cfquery name="qOrd" datasource="#dts#">
    SELECT order_id, order_number, status, total_amount
    FROM   app_orders
    WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">
    LIMIT  1
</cfquery>
<cfif qOrd.recordCount eq 0>
    <cflocation url="WaiterPOS.cfm?cancel=1" addtoken="false">
</cfif>
<cfif emenuOrderIsPaid(dts, orderId, qOrd.status)>
    <cflocation url="WaiterPOSPayment.cfm" addtoken="false">
</cfif>

<cfset totals    = emenuRecalculateOrderTotals(dts, orderId)>
<cfset payAmount = val(totals.total_amount)>
<cfif payAmount lte 0><cfset payAmount = val(qOrd.total_amount)></cfif>
<cfset orderNumber = trim(qOrd.order_number)>

<!--- Must match AI/.env AI_SHARED_SECRET (same constant used in customer/paymentProcess.cfm) --->
<cfset AI_SHARED_SECRET = "cleRkQqi7ogrKX5mAn6xr8LXmz9MobDlzcnKAYYHYCIqDnBy2c5bfuWRyrXDTcVw">

<cftry>
    <cfif payAction eq "cash">

        <cfquery datasource="#dts#">
            INSERT INTO app_payments
                (order_id, payment_method, amount, status, paid_at)
            VALUES (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="cash">,
                <cfqueryparam cfsqltype="cf_sql_decimal" value="#payAmount#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="success">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            )
        </cfquery>
        <cfquery datasource="#dts#">
            UPDATE app_orders
            SET    status       = <cfqueryparam cfsqltype="cf_sql_varchar"   value="paid">,
                   completed_at = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">
              AND  status NOT IN ('paid','completed','cancelled')
        </cfquery>

        <cflocation url="WaiterPOSPayment.cfm" addtoken="false">

    <cfelseif payAction eq "online">

        <cfset xScheme  = (CGI.HTTPS eq "on" OR CGI.SERVER_PORT eq "443") ? "https" : "http">
        <cfset baseUrl  = xScheme & "://" & CGI.SERVER_NAME>
        <cfif (xScheme eq "http" AND CGI.SERVER_PORT neq "80") OR (xScheme eq "https" AND CGI.SERVER_PORT neq "443")>
            <cfset baseUrl = baseUrl & ":" & CGI.SERVER_PORT>
        </cfif>

        <!--- Resolve currency from tenant's country code (same lookup as customer/paymentProcess.cfm) --->
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
            <cfcatch type="any"></cfcatch>
        </cftry>

        <cfset xPayload = structNew()>
        <cfset xPayload.dts                  = dts>
        <cfset xPayload.external_id          = orderNumber>
        <cfset xPayload.metadata             = {"dts" = dts}>
        <cfset xPayload.amount               = javaCast("int", round(payAmount))>
        <cfset xPayload.description          = "Order " & orderNumber>
        <cfset xPayload.currency             = xCurrency>
        <cfset xPayload.success_redirect_url = baseUrl & "/Waiter/WaiterPOSPayment.cfm?from=xendit">
        <cfset xPayload.failure_redirect_url = baseUrl & "/Waiter/WaiterPOSPayment.cfm?err=xendit_failed">

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
            <cfcatch type="any"></cfcatch>
        </cftry>

        <cfhttp url="http://127.0.0.1:8088/xendit/invoice" method="POST"
                result="xenditResp" timeout="30">
            <cfhttpparam type="header" name="Content-Type"  value="application/json">
            <cfhttpparam type="header" name="x-ai-secret"  value="#AI_SHARED_SECRET#">
            <cfhttpparam type="body"   value="#serializeJSON(xPayload)#">
        </cfhttp>

        <cfset xenditData = deserializeJSON(xenditResp.fileContent)>
        <cfif NOT structKeyExists(xenditData, "invoice_url")>
            <cflog file="xendit_error" type="error"
                   text="WaiterPOS Xendit bad response (#xenditResp.statusCode#): #xenditResp.fileContent#">
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

    <cfelse>
        <cflocation url="WaiterPOSPayment.cfm?err=invalid_action" addtoken="false">
    </cfif>

    <cfcatch type="any">
        <cflog file="xendit_error" type="error"
               text="WaiterPOSPaymentProcess error: #cfcatch.message# | #cfcatch.detail#">
        <cflocation url="WaiterPOSPayment.cfm?err=payment_failed" addtoken="false">
    </cfcatch>
</cftry>
