<!---
    /latest/customer/payment_done.cfm
    Confirmation after online or cashier payment request.
--->
<cfinclude template="../../application.cfm">
<cfsetting showdebugoutput="false">

<cfparam name="url.method" default="online">
<cfset method       = lCase(trim(url.method))>
<cfset tableDisplay = len(trim(SESSION.emenu_table_number)) ? "Table " & SESSION.emenu_table_number : "Your Table">
<cfset orderNum     = len(trim(SESSION.emenu_order_number)) ? SESSION.emenu_order_number : "">

<!--- For Xendit: check DB to see if webhook already confirmed payment --->
<cfset xenditConfirmed = false>
<cfif method eq "xendit" AND val(SESSION.emenu_order_id) gt 0>
    <cfquery name="qXenditCheck" datasource="#dts#">
        SELECT o.status
        FROM   app_orders o
        JOIN   app_payments p ON p.order_id = o.order_id
        WHERE  o.order_id    = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(SESSION.emenu_order_id)#">
          AND  p.gateway_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="xendit">
        ORDER  BY p.payment_id DESC
        LIMIT  1
    </cfquery>
    <cfif qXenditCheck.recordCount AND qXenditCheck.status eq "paid">
        <cfset xenditConfirmed = true>
        <cfset SESSION.emenu_cart_locked = true>
    </cfif>
</cfif>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1">
    <title>Payment</title>
    <style>
        *{box-sizing:border-box;margin:0;padding:0;}
        body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;background:#f3f4f6;min-height:100vh;padding:24px 16px;}
        .card{background:#fff;border-radius:24px;padding:28px 20px;text-align:center;max-width:400px;margin:40px auto;border:1px solid #f0f0f0;}
        .icon{font-size:48px;margin-bottom:12px;}
        h1{font-size:22px;color:#111;margin-bottom:8px;}
        p{font-size:14px;color:#6b7280;line-height:1.5;margin-bottom:20px;}
        .btn{display:block;width:100%;padding:14px;border-radius:14px;background:#F54900;color:#fff;text-decoration:none;font-weight:700;font-size:15px;}
    </style>
</head>
<body>
<cfoutput>
<div class="card">
    <cfif method eq "cashier">
        <div class="icon">&#128179;</div>
        <h1>Pay at the counter</h1>
        <p>Please visit the cashier for <strong>#HTMLEditFormat(tableDisplay)#</strong>
        <cfif len(orderNum)> (order #HTMLEditFormat(orderNum)#)</cfif>.
        Staff will confirm your payment on the waiter dashboard.</p>
    <cfelseif method eq "xendit" AND xenditConfirmed>
        <div class="icon">&#9989;</div>
        <h1>Payment confirmed!</h1>
        <p>Your Xendit payment for <strong>#HTMLEditFormat(tableDisplay)#</strong> has been received.
        Thank you!</p>
    <cfelseif method eq "xendit">
        <div class="icon">&#9203;</div>
        <h1>Payment processing&hellip;</h1>
        <p>Your payment is being confirmed by Xendit. This usually takes a few seconds.
        Check your order status below &mdash; it will update once confirmed.</p>
    <cfelse>
        <div class="icon">&#9989;</div>
        <h1>Payment successful</h1>
        <p>Thank you! Your payment for <strong>#HTMLEditFormat(tableDisplay)#</strong> is complete.</p>
    </cfif>
    <a href="/latest/customer/order_status.cfm" class="btn">View order status</a>
</div>
</cfoutput>
</body>
</html>
