<!---
    /latest/customer/payment.cfm
    Pay bill — online (sandbox) or at cashier.
--->
<cfinclude template="../../application.cfm">
<cfinclude template="inc_emenu_order.cfm">
<cfinclude template="inc_emenu_currency.cfm">
<cfset emenuCurrSym = REQUEST.emenu_currency_symbol>
<cfset emenuPriceFmt = REQUEST.emenu_currency_decimals eq 0 ? "9,990" : "9,990.00">
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
    SELECT quantity, subtotal,
           COALESCE(item_name, item_code) AS item_name
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
        .pay-btn{display:block;width:100%;padding:16px;border:none;border-radius:14px;font-size:16px;font-weight:700;cursor:pointer;margin-bottom:10px;text-align:center;}
        .pay-online{background:#F54900;color:#fff;}
        .pay-cashier{background:#fff;color:#F54900;border:2px solid #F54900;}
        .hint{font-size:12px;color:#9ca3af;text-align:center;margin-top:8px;line-height:1.5;}
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
        <div class="err">Payment could not be completed. Please try again or pay at the cashier.</div>
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

    <form action="/latest/customer/paymentProcess.cfm" method="post">
        <input type="hidden" name="pay_action" value="online">
        <button type="submit" class="pay-btn pay-online">Pay with Xendit</button>
    </form>
    <form action="/latest/customer/paymentProcess.cfm" method="post">
        <input type="hidden" name="pay_action" value="cashier">
        <button type="submit" class="pay-btn pay-cashier">Pay at Cashier</button>
    </form>
    <p class="hint">Xendit accepts cards, bank transfer, e-wallets &amp; more. Cashier payment notifies staff on the waiter dashboard.</p>
</div>
</cfoutput>
</body>
</html>
