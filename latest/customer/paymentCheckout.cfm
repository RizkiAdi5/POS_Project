<!---
    /latest/customer/paymentCheckout.cfm — Show QR / VA / wait for payment.
--->
<cfinclude template="../../application.cfm">
<cfinclude template="inc_emenu_order.cfm">
<cfinclude template="inc_xendit_pay.cfm">
<cfsetting showdebugoutput="false">

<cfparam name="url.payment_id" default="0">
<cfset paymentId = val(url.payment_id)>
<cfif paymentId lte 0 AND structKeyExists(SESSION, "emenu_payment_id")>
    <cfset paymentId = val(SESSION.emenu_payment_id)>
</cfif>
<cfif paymentId lte 0>
    <cflocation url="/latest/customer/payment.cfm" addtoken="false">
</cfif>

<cfset orderId = val(SESSION.emenu_order_id)>
<cfquery name="qPay" datasource="#dts#">
    SELECT p.*, o.order_number, o.status AS order_status
    FROM app_payments p
    INNER JOIN app_orders o ON o.order_id = p.order_id
    WHERE p.payment_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#paymentId#">
      AND p.order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">
    LIMIT 1
</cfquery>
<cfif qPay.recordCount eq 0>
    <cflocation url="/latest/customer/payment.cfm" addtoken="false">
</cfif>
<cfif emenuOrderIsPaid(dts, orderId, qPay.order_status) OR lCase(qPay.status) eq "success">
    <cflocation url="/latest/customer/payment_done.cfm?method=#urlEncodedFormat(qPay.payment_method)#" addtoken="false">
</cfif>

<cfset pgProf = emenuPgProfile(dts)>
<cfset payData = structNew()>
<cfset actions = {qrString="", vaNumber="", redirectUrl=""}>
<cftry>
    <cfif len(trim(qPay.gateway_response))>
        <cfset payData = deserializeJSON(qPay.gateway_response)>
        <cfset actions = pgParsePayActions(payData)>
    </cfif>
    <cfcatch type="any"></cfcatch>
</cftry>

<cfset methodLabel = uCase(qPay.payment_method)>
<cfset emenuCurrSym = REQUEST.emenu_currency_symbol>
<cfset emenuPriceFmt = REQUEST.emenu_currency_decimals eq 0 ? "9" : "9.00">
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1">
    <title>Complete Payment</title>
    <style>
        *{box-sizing:border-box;margin:0;padding:0;}
        body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;background:#f3f4f6;min-height:100vh;padding:20px 16px 40px;}
        .card{background:#fff;border-radius:20px;padding:24px 20px;max-width:420px;margin:0 auto;text-align:center;border:1px solid #f0f0f0;}
        h1{font-size:20px;color:#111;margin-bottom:6px;}
        .amt{font-size:28px;font-weight:800;color:#F54900;margin:12px 0;}
        .meta{font-size:13px;color:#6b7280;margin-bottom:16px;}
        .qr img{max-width:240px;width:100%;border:1px solid #eee;border-radius:12px;}
        .va-box{background:#f9fafb;border:1px solid #e5e7eb;border-radius:12px;padding:16px;margin:12px 0;}
        .va-num{font-size:22px;font-weight:800;letter-spacing:1px;color:#111;word-break:break-all;}
        .hint{font-size:13px;color:#6b7280;line-height:1.5;margin-top:12px;}
        .status{margin-top:16px;font-size:14px;color:#374151;}
        .spinner{display:inline-block;width:18px;height:18px;border:3px solid #fde8d8;border-top-color:#F54900;border-radius:50%;animation:spin .8s linear infinite;vertical-align:middle;margin-right:6px;}
        @keyframes spin{to{transform:rotate(360deg);}}
        .btn{display:inline-block;margin-top:16px;padding:12px 20px;border-radius:12px;background:#F54900;color:#fff;text-decoration:none;font-weight:700;font-size:14px;}
    </style>
</head>
<body>
<cfoutput>
<div class="card">
    <h1>Complete #HTMLEditFormat(methodLabel)# Payment</h1>
    <div class="meta">Order #HTMLEditFormat(qPay.order_number)#</div>
    <div class="amt">#emenuCurrSym# #numberFormat(val(qPay.amount), emenuPriceFmt)#</div>

    <cfif len(actions.qrString)>
        <div class="qr">
            <img src="https://api.qrserver.com/v1/create-qr-code/?size=260x260&amp;data=#urlEncodedFormat(actions.qrString)#" alt="QRIS">
        </div>
        <p class="hint">Scan this QR code with your banking or e-wallet app, then wait for confirmation.</p>
    <cfelseif len(actions.vaNumber)>
        <div class="va-box">
            <div style="font-size:12px;color:#6b7280;margin-bottom:6px;">Virtual Account Number</div>
            <div class="va-num">#HTMLEditFormat(actions.vaNumber)#</div>
        </div>
        <p class="hint">Transfer the exact amount to this virtual account. Payment is confirmed automatically.</p>
    <cfelse>
        <p class="hint">Complete payment in the window that opened. If nothing opened, go back and try again.</p>
    </cfif>

    <div class="status" id="payStatus"><span class="spinner"></span> Waiting for payment&hellip;</div>
    <a href="/latest/customer/order_status.cfm" class="btn" style="background:#6b7280;">Back to order</a>
</div>
</cfoutput>
<script>
(function () {
    var paymentId = <cfoutput>#paymentId#</cfoutput>;
    var poll = function () {
        fetch('/latest/customer/paymentStatus.cfm?payment_id=' + paymentId, { credentials: 'same-origin' })
            .then(function (r) { return r.json(); })
            .then(function (d) {
                if (d.paid) {
                    location.href = '/latest/customer/payment_done.cfm?method=' + encodeURIComponent(d.method || 'online');
                    return;
                }
                if (d.failed) {
                    document.getElementById('payStatus').textContent = 'Payment failed. Please try again.';
                    return;
                }
                setTimeout(poll, 4000);
            })
            .catch(function () { setTimeout(poll, 6000); });
    };
    poll();
})();
</script>
</body>
</html>
