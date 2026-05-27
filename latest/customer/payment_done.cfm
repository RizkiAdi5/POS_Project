<!---
    /latest/customer/payment_done.cfm
    Confirmation after online or cashier payment request.
--->
<cfinclude template="../../application.cfm">
<cfsetting showdebugoutput="false">

<cfparam name="url.method" default="online">
<cfset method = lCase(trim(url.method))>
<cfset tableDisplay = len(trim(SESSION.emenu_table_number)) ? "Table " & SESSION.emenu_table_number : "Your Table">
<cfset orderNum = len(trim(SESSION.emenu_order_number)) ? SESSION.emenu_order_number : "">
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
    <cfelse>
        <div class="icon">&#9989;</div>
        <h1>Payment successful</h1>
        <p>Thank you! Your online payment for <strong>#HTMLEditFormat(tableDisplay)#</strong> is complete.
        Staff can clear the table and start a new QR session for the next guests.</p>
    </cfif>
    <a href="/latest/customer/order_status.cfm" class="btn">View order status</a>
</div>
</cfoutput>
</body>
</html>
