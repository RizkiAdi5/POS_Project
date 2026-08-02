<!---
    /latest/Waiter/WaiterPOSPayment.cfm
    Counter payment screen: order summary + Cash / Online (Xendit) buttons.
    "Online" redirects the browser straight to Xendit's hosted invoice page —
    same behavior as latest/customer/payment.cfm — then Xendit redirects back
    here (?from=xendit). If the webhook hasn't landed yet at that point, show
    a brief "processing" state instead of the raw Cash/Online choice again.
--->
<cfprocessingdirective pageencoding="UTF-8">
<cfinclude template="/application.cfm">
<cfinclude template="/latest/customer/inc_emenu_order.cfm">
<cfinclude template="/latest/customer/inc_emenu_currency.cfm">
<cfsetting showdebugoutput="false">

<cfparam name="SESSION.wpos_order_id"     default="">
<cfparam name="SESSION.wpos_order_number" default="">
<cfparam name="SESSION.wpos_table_id"     default="">
<cfparam name="SESSION.wpos_table_number" default="">
<cfparam name="SESSION.wpos_is_takeaway"  default="No">

<cfif val(SESSION.wpos_order_id) lte 0>
    <cflocation url="WaiterPOS.cfm" addtoken="false">
</cfif>

<cfset orderId = val(SESSION.wpos_order_id)>
<cfset emenuCurrSym  = REQUEST.emenu_currency_symbol>
<cfset emenuPriceFmt = REQUEST.emenu_currency_decimals eq 0 ? "9,990" : "9,990.00">
<cfset payErr = structKeyExists(url, "err") ? trim(url.err) : "">
<cfset justReturned = (structKeyExists(url, "from") AND url.from eq "xendit")>

<cfquery name="qOrd" datasource="#dts#">
    SELECT order_number, status, subtotal, tax_amount, total_amount
    FROM   app_orders
    WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">
    LIMIT  1
</cfquery>
<cfif qOrd.recordCount eq 0>
    <cflocation url="WaiterPOS.cfm?cancel=1" addtoken="false">
</cfif>

<cfquery name="qItems" datasource="#dts#">
    SELECT quantity, subtotal, COALESCE(item_name, item_code) AS item_name
    FROM   app_order_items
    WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">
    ORDER  BY item_id ASC
</cfquery>
<cfif qItems.recordCount eq 0>
    <cflocation url="WaiterPOS.cfm" addtoken="false">
</cfif>

<cfset totals = emenuRecalculateOrderTotals(dts, orderId)>
<cfset isPaid = emenuOrderIsPaid(dts, orderId, qOrd.status)>

<cfset orderLabel = (SESSION.wpos_is_takeaway eq "Yes")
    ? "Take Away &mdash; " & SESSION.wpos_order_number
    : "Table " & SESSION.wpos_table_number & " &mdash; " & SESSION.wpos_order_number>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1">
<title>Waiter POS &mdash; Payment</title>
<cfif justReturned AND NOT isPaid>
<meta http-equiv="refresh" content="4">
</cfif>
<style>
:root{
  --accent:#F54900; --accent-dark:#D04000; --accent-soft:#FFF3ED;
  --ink:#111827; --ink-soft:#6B7280; --ink-faint:#9CA3AF;
  --line:#E9EAEE; --bg:#F6F7FB; --card:#FFFFFF;
  --green:#16A34A; --green-soft:#EAFBF1;
  --blue:#2563EB; --blue-soft:#EEF2FF;
  --shadow-sm:0 1px 2px rgba(16,24,40,.06);
  --shadow-md:0 4px 16px rgba(16,24,40,.08);
  --shadow-lg:0 12px 32px rgba(16,24,40,.12);
}
*{box-sizing:border-box;}
body{margin:0;background:var(--bg);color:var(--ink);min-height:100vh;
     font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Helvetica,Arial,sans-serif;
     -webkit-font-smoothing:antialiased;}
.wrap{max-width:520px;margin:0 auto;padding:22px 18px 60px;}
.topbar{display:flex;align-items:center;justify-content:space-between;margin-bottom:18px;}
.topbar h1{font-size:19px;font-weight:800;margin:0;}
.back{font-size:13.5px;font-weight:600;color:var(--ink-soft);text-decoration:none;display:inline-flex;align-items:center;gap:4px;}
.back:hover{color:var(--ink);}

.alert{padding:12px 16px;border-radius:12px;font-size:13.5px;font-weight:500;margin-bottom:14px;}
.alert-err{background:#FEF2F2;color:#B91C1C;border:1px solid #FECACA;}

.card{background:var(--card);border-radius:18px;box-shadow:var(--shadow-sm);border:1px solid var(--line);padding:20px 22px;margin-bottom:16px;}
.order-meta{font-size:13px;color:var(--ink-soft);margin-bottom:14px;}

.total-card{background:linear-gradient(135deg,var(--accent),var(--accent-dark));border-radius:18px;
            padding:22px 24px;color:#fff;margin-bottom:16px;box-shadow:0 10px 26px rgba(245,73,0,.25);}
.total-label{font-size:13px;opacity:.85;margin-bottom:4px;}
.total-amt{font-size:38px;font-weight:800;letter-spacing:-.02em;}

.item-row{display:flex;justify-content:space-between;padding:9px 0;border-bottom:1px solid #F3F4F6;font-size:13.5px;}
.item-row:last-child{border-bottom:none;}
.item-row .nm{color:var(--ink);}
.item-row .amt{font-weight:600;color:var(--ink);}
.sum-row{display:flex;justify-content:space-between;font-size:13px;color:var(--ink-soft);margin-top:10px;}
.sum-row.grand{font-size:16px;font-weight:800;color:var(--ink);margin-top:8px;padding-top:10px;border-top:1px dashed var(--line);}

.pay-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-top:4px;}
.pay-grid form{width:100%;margin:0;}
.pay-card{width:100%;border:none;border-radius:16px;padding:22px 14px;text-align:center;cursor:pointer;transition:.15s;
          display:flex;flex-direction:column;align-items:center;gap:8px;font-family:inherit;box-sizing:border-box;}
.pay-card svg{width:28px;height:28px;}
.pay-card .lbl{font-size:14.5px;font-weight:700;}
.pay-cash{background:var(--green-soft);color:#166534;}
.pay-cash:hover{box-shadow:var(--shadow-md);transform:translateY(-2px);}
.pay-online{background:var(--blue-soft);color:#1E3A8A;}
.pay-online:hover{box-shadow:var(--shadow-md);transform:translateY(-2px);}
.hint{font-size:12px;color:var(--ink-faint);text-align:center;margin-top:14px;line-height:1.6;}

.paid-card{text-align:center;padding:40px 24px;background:var(--card);border-radius:20px;box-shadow:var(--shadow-lg);}
.paid-icon{width:56px;height:56px;border-radius:50%;background:var(--green-soft);color:var(--green);
           display:flex;align-items:center;justify-content:center;margin:0 auto 14px;}
.paid-icon svg{width:28px;height:28px;}
.paid-title{font-size:20px;font-weight:800;margin-bottom:6px;}
.paid-meta{font-size:13.5px;color:var(--ink-soft);}
.next-btn{display:block;width:100%;margin-top:18px;padding:15px;border:none;border-radius:13px;font-size:15px;font-weight:700;
          color:#fff;background:linear-gradient(135deg,var(--accent),var(--accent-dark));cursor:pointer;text-decoration:none;text-align:center;}

.processing-card{text-align:center;padding:40px 24px;background:var(--card);border-radius:20px;box-shadow:var(--shadow-lg);}
.spinner{width:40px;height:40px;border-radius:50%;border:4px solid var(--blue-soft);border-top-color:var(--blue);
         margin:0 auto 16px;animation:spin 0.8s linear infinite;}
@keyframes spin{to{transform:rotate(360deg);}}
.processing-title{font-size:18px;font-weight:800;margin-bottom:6px;}
.processing-meta{font-size:13.5px;color:var(--ink-soft);}
.qr-actions{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-top:18px;}
.qr-actions a, .qr-actions button{border:none;border-radius:12px;padding:12px;font-size:13.5px;font-weight:700;cursor:pointer;text-decoration:none;text-align:center;width:100%;font-family:inherit;}
.qr-refresh{background:#F1F2F5;color:var(--ink);}
.qr-cash{background:var(--green-soft);color:#166534;}
</style>
</head>
<body>
<cfoutput>
<div class="wrap">

<div class="topbar">
    <h1>Payment</h1>
    <a href="WaiterPOS.cfm" class="back">&larr; Back</a>
</div>

<cfif len(payErr)>
    <div class="alert alert-err">#HTMLEditFormat(payErr)#</div>
</cfif>

<cfif isPaid>
    <div class="paid-card">
        <div class="paid-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12.75l6 6 9-13.5"/></svg>
        </div>
        <div class="paid-title">Payment Received</div>
        <div class="paid-meta">#orderLabel# &middot; #emenuCurrSym# #numberFormat(totals.total_amount, emenuPriceFmt)#</div>
        <a href="WaiterPOS.cfm?cancel=1" class="next-btn">Start Next Order</a>
    </div>

<cfelseif justReturned>
    <div class="processing-card">
        <div class="spinner"></div>
        <div class="processing-title">Confirming payment&hellip;</div>
        <div class="processing-meta">#orderLabel# &middot; #emenuCurrSym# #numberFormat(totals.total_amount, emenuPriceFmt)#</div>
    </div>
    <div class="qr-actions">
        <a href="WaiterPOSPayment.cfm?from=xendit" class="qr-refresh">Refresh Status</a>
        <form action="WaiterPOSPaymentProcess.cfm" method="post">
            <input type="hidden" name="pay_action" value="cash">
            <button type="submit" class="qr-cash">Paid Cash Instead</button>
        </form>
    </div>

<cfelse>
    <div class="total-card">
        <div class="total-label">#orderLabel#</div>
        <div class="total-amt">#emenuCurrSym# #numberFormat(totals.total_amount, emenuPriceFmt)#</div>
    </div>

    <div class="card">
        <div class="order-meta">Order Summary</div>
        <cfloop query="qItems">
            <div class="item-row">
                <span class="nm">#HTMLEditFormat(qItems.item_name)# &times;#qItems.quantity#</span>
                <span class="amt">#emenuCurrSym# #numberFormat(val(qItems.subtotal), emenuPriceFmt)#</span>
            </div>
        </cfloop>
        <div class="sum-row"><span>Subtotal</span><span>#emenuCurrSym# #numberFormat(totals.subtotal, emenuPriceFmt)#</span></div>
        <div class="sum-row"><span>Tax (10%)</span><span>#emenuCurrSym# #numberFormat(totals.tax_amount, emenuPriceFmt)#</span></div>
        <div class="sum-row grand"><span>Total</span><span>#emenuCurrSym# #numberFormat(totals.total_amount, emenuPriceFmt)#</span></div>
    </div>

    <div class="pay-grid">
        <form action="WaiterPOSPaymentProcess.cfm" method="post">
            <input type="hidden" name="pay_action" value="cash">
            <button type="submit" class="pay-card pay-cash">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path stroke-linecap="round" stroke-linejoin="round" d="M2.25 8.25h19.5M2.25 8.25v10.5a1.5 1.5 0 001.5 1.5h16.5a1.5 1.5 0 001.5-1.5V8.25M2.25 8.25l1.564-3.913A1.5 1.5 0 015.19 3.375h13.62a1.5 1.5 0 011.376.962L21.75 8.25M12 15a2.25 2.25 0 100-4.5 2.25 2.25 0 000 4.5z"/></svg>
                <span class="lbl">Cash</span>
            </button>
        </form>
        <form action="WaiterPOSPaymentProcess.cfm" method="post">
            <input type="hidden" name="pay_action" value="online">
            <button type="submit" class="pay-card pay-online">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6.75h16.5a1.5 1.5 0 011.5 1.5v7.5a1.5 1.5 0 01-1.5 1.5H3.75a1.5 1.5 0 01-1.5-1.5v-7.5a1.5 1.5 0 011.5-1.5z"/><path stroke-linecap="round" stroke-linejoin="round" d="M2.25 10.5h19.5"/></svg>
                <span class="lbl">Online (Xendit)</span>
            </button>
        </form>
    </div>
</cfif>

</div>
</cfoutput>
</body>
</html>
