<!---
    /latest/customer/paymentProcess.cfm
    Online payment (sandbox) or pay-at-cashier request.
--->
<cfinclude template="../../application.cfm">
<cfinclude template="inc_emenu_order.cfm">

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

<cfquery name="qItemCnt" datasource="#dts#">
    SELECT COUNT(*) AS row_count FROM app_order_items
    WHERE order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">
</cfquery>
<cfif val(qItemCnt.row_count) eq 0>
    <cflocation url="/latest/customer/menu.cfm?msg=no_items" addtoken="false">
</cfif>

<cfset totals = emenuRecalculateOrderTotals(dts, orderId)>
<cfset payAmount = val(totals.total_amount)>
<cfif payAmount lte 0><cfset payAmount = val(qOrd.total_amount)></cfif>
<cfset orderNumber = trim(qOrd.order_number)>

<cftry>
    <cfif payAction eq "online">
        <cfquery datasource="#dts#">
            INSERT INTO app_payments
                (order_id, payment_method, amount, status, paid_at, gateway_name)
            VALUES (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="online">,
                <cfqueryparam cfsqltype="cf_sql_decimal" value="#payAmount#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="success">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="sandbox">
            )
        </cfquery>
        <cfquery datasource="#dts#">
            UPDATE app_orders
            SET status = <cfqueryparam cfsqltype="cf_sql_varchar" value="paid">,
                completed_at = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            WHERE order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">
        </cfquery>
        <cfset SESSION.emenu_cart_locked = true>
        <cfset isLoyalty = (SESSION.emenu_loggedin eq "Yes" AND len(trim(SESSION.emenu_custno)))>
        <cfif isLoyalty>
            <cfset SESSION.emenu_points_earned = emenuAwardLoyaltyPoints(dts, trim(SESSION.emenu_custno), orderNumber, payAmount)>
        </cfif>
        <cflocation url="/latest/customer/payment_done.cfm?method=online" addtoken="false">

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
        <cflocation url="/latest/customer/payment.cfm?err=payment_failed" addtoken="false">
    </cfcatch>
</cftry>
