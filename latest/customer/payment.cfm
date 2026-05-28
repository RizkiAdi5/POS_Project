<!---
    /latest/customer/payment.cfm — Pay bill (Xendit online + cashier).
--->
<cfinclude template="../../application.cfm">
<cfinclude template="inc_emenu_order.cfm">
<cfinclude template="inc_xendit_pay.cfm">
<cfset emenuCurrSym = REQUEST.emenu_currency_symbol>
<cfset emenuPriceFmt = REQUEST.emenu_currency_decimals eq 0 ? "9" : "9.00">
<cfsetting showdebugoutput="false">

<cfif NOT len(trim(SESSION.emenu_table_id)) OR val(SESSION.emenu_order_id) lte 0>
    <cflocation url="/latest/customer/qr_error.cfm" addtoken="false">
</cfif>

<cfset orderId = val(SESSION.emenu_order_id)>
<cfquery name="qOrd" datasource="#dts#">
    SELECT order_number, status, subtotal, tax_amount, total_amount
    FROM   app_orders
    WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">
    LIMIT  1
</cfquery>

<cfif qOrd.recordCount eq 0>
    <cflocation url="/latest/customer/menu.cfm" addtoken="false">
</cfif>
<cfif emenuOrderIsPaid(dts, orderId, qOrd.status)>
    <cflocation url="/latest/customer/order_status.cfm?msg=already_paid" addtoken="false">
</cfif>

<cfquery name="qItems" datasource="#dts#">
    SELECT quantity, subtotal, COALESCE(item_name, item_code) AS item_name
    FROM   app_order_items
    WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">
    ORDER  BY item_id ASC
</cfquery>
<cfif qItems.recordCount eq 0>
    <cflocation url="/latest/customer/menu.cfm?msg=add_items_first" addtoken="false">
</cfif>

<cfset totals = emenuRecalculateOrderTotals(dts, orderId)>
<cfset tableDisplay = len(trim(SESSION.emenu_table_number)) ? "Table " & SESSION.emenu_table_number : "Your Table">
<cfset payErr = structKeyExists(url, "err") ? trim(url.err) : "">
<cfset pgProf = emenuPgProfile(dts)>
<cfset xenditOn = REQUEST.xendit.isActive AND pgProf.ready AND pgProf.xendit_ready>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1">
    <title>Pay Bill</title>
    <style>
        *{box-sizing:border-box;margin:0;padding:0;}
        body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;background:#f3f4f6;min-height:100vh;padding-bottom:32px;}
        .top{background:#F54900;color:#fff;padding:16px 20px;display:flex;align-items:center;gap:12px;}
        .top a{color:#fff;text-decoration:none;font-size:14px;font-weight:600;}
        .top h1{font-size:18px;font-weight:700;flex:1;text-align:center;margin-right:40px;}
        .body{padding:16px;}
        .card{background:#fff;border-radius:20px;padding:20px;margin-bottom:14px;border:1px solid #f0f0f0;box-shadow:0 1px 4px rgba(0,0,0,.05);}
        .meta{font-size:13px;color:#6b7280;margin-bottom:4px;}
        .ord{font-size:16px;font-weight:800;color:#111;margin-bottom:16px;}
        .row{display:flex;justify-content:space-between;font-size:14px;color:#374151;margin-bottom:8px;}
        .row.grand{font-size:17px;font-weight:800;color:#111;padding-top:12px;border-top:1px solid #eee;margin-top:8px;}
        .item{display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid #f9fafb;font-size:14px;}
        .item:last-child{border-bottom:none;}
        .err{background:#fef2f2;border:1px solid #fecaca;color:#b91c1c;padding:12px;border-radius:12px;margin-bottom:14px;font-size:13px;}
        .warn{background:#fffbeb;border:1px solid #fde68a;color:#92400e;padding:12px;border-radius:12px;margin-bottom:14px;font-size:13px;}
        .sec{font-size:12px;font-weight:700;color:#6b7280;text-transform:uppercase;letter-spacing:.04em;margin:16px 0 8px;}
        .pay-btn{display:block;width:100%;padding:14px 16px;border:none;border-radius:14px;font-size:15px;font-weight:700;cursor:pointer;margin-bottom:8px;text-align:left;background:#fff;color:#111;border:1px solid #e5e7eb;}
        .pay-btn.primary{background:#F54900;color:#fff;border-color:#F54900;text-align:center;}
        .pay-btn small{display:block;font-size:12px;font-weight:500;opacity:.85;margin-top:2px;}
        .pay-cashier{background:#fff;color:#F54900;border:2px solid #F54900;text-align:center;margin-top:12px;}
        .ewallet-grid{display:grid;grid-template-columns:1fr 1fr;gap:8px;}
        .hint{font-size:12px;color:#9ca3af;text-align:center;margin-top:12px;line-height:1.5;}
    </style>
</head>
<body>
<cfoutput>
<div class="top">
    <a href="/latest/customer/order_status.cfm">&larr; Back</a>
    <h1>Pay Bill</h1>
</div>
<div class="body">
    <cfif len(payErr)>
        <div class="err">
            <cfswitch expression="#payErr#">
                <cfcase value="xendit_not_ready">Online payment is not available yet. Please pay at the cashier.</cfcase>
                <cfcase value="xendit_failed">Could not start online payment. Try again or pay at the cashier.</cfcase>
                <cfcase value="invalid_action">Invalid payment option.</cfcase>
                <cfdefaultcase>Payment could not be completed. Please try again or pay at the cashier.</cfdefaultcase>
            </cfswitch>
        </div>
    </cfif>

    <div class="card">
        <div class="meta">#HTMLEditFormat(tableDisplay)# &middot; Order #HTMLEditFormat(qOrd.order_number)#</div>
        <div class="ord">Your bill</div>
        <cfloop query="qItems">
            <div class="item">
                <span>#HTMLEditFormat(qItems.item_name)# x#qItems.quantity#</span>
                <span>#emenuCurrSym# #numberFormat(val(qItems.subtotal), emenuPriceFmt)#</span>
            </div>
        </cfloop>
        <div class="row" style="margin-top:12px;"><span>Subtotal</span><span>#emenuCurrSym# #numberFormat(totals.subtotal, emenuPriceFmt)#</span></div>
        <div class="row"><span>Tax (10%)</span><span>#emenuCurrSym# #numberFormat(totals.tax_amount, emenuPriceFmt)#</span></div>
        <div class="row grand"><span>Total</span><span>#emenuCurrSym# #numberFormat(totals.total_amount, emenuPriceFmt)#</span></div>
    </div>

    <cfif xenditOn>
        <div class="sec">Pay online</div>

        <cfif pgProf.enable_qris EQ "Y">
        <form action="/latest/customer/paymentProcess.cfm" method="post">
            <input type="hidden" name="pay_action" value="qris">
            <button type="submit" class="pay-btn primary">QRIS<small>Scan QR with any e-wallet / banking app</small></button>
        </form>
        </cfif>

        <cfif pgProf.enable_ewallet EQ "Y">
        <div class="sec" style="margin-top:10px;">E-Wallet</div>
        <div class="ewallet-grid">
            <form action="/latest/customer/paymentProcess.cfm" method="post"><input type="hidden" name="pay_action" value="ewallet"><input type="hidden" name="ewallet_channel" value="OVO"><button type="submit" class="pay-btn">OVO</button></form>
            <form action="/latest/customer/paymentProcess.cfm" method="post"><input type="hidden" name="pay_action" value="ewallet"><input type="hidden" name="ewallet_channel" value="DANA"><button type="submit" class="pay-btn">DANA</button></form>
            <form action="/latest/customer/paymentProcess.cfm" method="post"><input type="hidden" name="pay_action" value="ewallet"><input type="hidden" name="ewallet_channel" value="GOPAY"><button type="submit" class="pay-btn">GoPay</button></form>
            <form action="/latest/customer/paymentProcess.cfm" method="post"><input type="hidden" name="pay_action" value="ewallet"><input type="hidden" name="ewallet_channel" value="SHOPEEPAY"><button type="submit" class="pay-btn">ShopeePay</button></form>
        </div>
        </cfif>

        <cfif pgProf.enable_va EQ "Y">
        <form action="/latest/customer/paymentProcess.cfm" method="post" style="margin-top:8px;">
            <input type="hidden" name="pay_action" value="va">
            <button type="submit" class="pay-btn">Virtual Account<small>Transfer to bank VA number</small></button>
        </form>
        </cfif>

        <cfif pgProf.enable_card EQ "Y">
        <form action="/latest/customer/paymentProcess.cfm" method="post">
            <input type="hidden" name="pay_action" value="card">
            <button type="submit" class="pay-btn">Credit / Debit Card<small>Secure card checkout</small></button>
        </form>
        </cfif>
    <cfelse>
        <div class="warn">Online payment is not active. Merchant must complete Payment Gateway setup in POS.</div>
    </cfif>

    <div class="sec">Or</div>
    <form action="/latest/customer/paymentProcess.cfm" method="post">
        <input type="hidden" name="pay_action" value="cashier">
        <button type="submit" class="pay-btn pay-cashier">Pay at Cashier</button>
    </form>
    <p class="hint">Online payments are processed by Xendit. Cashier payment notifies staff on the waiter dashboard.</p>
</div>
</cfoutput>
</body>
</html>
