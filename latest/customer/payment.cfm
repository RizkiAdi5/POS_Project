<!---
    /latest/customer/payment.cfm
    Pay bill — online (Xendit) or at cashier, with optional loyalty points redemption.
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

<!--- Loyalty points --->
<cfset isLoyalty = (SESSION.emenu_loggedin eq "Yes" AND len(trim(SESSION.emenu_custno)) AND SESSION.emenu_custno neq "-")>
<cfset custPts = 0>
<cfset maxRedeemable = 0>
<cfif isLoyalty>
    <cftry>
        <cfquery name="qPts" datasource="#dts#">
            SELECT COALESCE(POINT_BF, 0) AS pts
            FROM   arcust
            WHERE  CUSTNO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SESSION.emenu_custno#">
        </cfquery>
        <cfif qPts.recordCount>
            <cfset custPts = int(val(qPts.pts))>
            <cfset maxRedeemable = min(custPts, int(val(totals.total_amount)))>
        </cfif>
    <cfcatch type="any"></cfcatch>
    </cftry>
</cfif>

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
        .row.discount{color:#16a34a;font-weight:600;}
        .row.final-total{font-size:18px;font-weight:800;color:#F54900;padding-top:10px;border-top:2px solid #F54900;margin-top:4px;}
        .item{display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid #f9fafb;font-size:14px;}
        .item:last-child{border-bottom:none;}
        .err{background:#fef2f2;border:1px solid #fecaca;color:#b91c1c;padding:12px;border-radius:12px;margin-bottom:14px;font-size:13px;}
        .pay-btn{display:block;width:100%;padding:16px;border:none;border-radius:14px;font-size:16px;font-weight:700;cursor:pointer;margin-bottom:10px;text-align:center;}
        .pay-online{background:#F54900;color:#fff;}
        .pay-cashier{background:#fff;color:#F54900;border:2px solid #F54900;}
        .hint{font-size:12px;color:#9ca3af;text-align:center;margin-top:8px;line-height:1.5;}

        /* Points card */
        .pts-card{background:#fff;border-radius:20px;padding:18px 20px;margin-bottom:14px;border:1px solid #fde68a;box-shadow:0 1px 4px rgba(0,0,0,.05);}
        .pts-header{display:flex;align-items:center;gap:10px;}
        .pts-icon{font-size:22px;line-height:1;}
        .pts-label{flex:1;font-size:14px;color:#374151;}
        .pts-label strong{color:#111;}
        .pts-toggle{display:flex;align-items:center;gap:8px;cursor:pointer;user-select:none;}
        .pts-toggle input[type=checkbox]{width:18px;height:18px;accent-color:#F54900;cursor:pointer;}
        .pts-toggle span{font-size:14px;font-weight:600;color:#F54900;}
        .pts-detail{margin-top:14px;padding-top:14px;border-top:1px solid #fef3c7;display:none;}
        .pts-saving{font-size:13px;color:#16a34a;font-weight:600;}
        .pts-remaining{font-size:12px;color:#6b7280;margin-top:4px;}
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

    <!--- Bill summary --->
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
        <div class="row grand" id="row-grand"><span>Total</span><span id="display-total">#emenuCurrSym# #numberFormat(totals.total_amount, emenuPriceFmt)#</span></div>
        <div class="row discount" id="row-discount" style="display:none;"><span>&##9733; Points discount</span><span id="display-discount">&minus; #emenuCurrSym# 0</span></div>
        <div class="row final-total" id="row-final" style="display:none;"><span>You pay</span><span id="display-final">#emenuCurrSym# 0</span></div>
    </div>

    <!--- Points redemption card (loyalty users with points only) --->
    <cfif isLoyalty AND custPts gt 0>
    <div class="pts-card">
        <div class="pts-header">
            <span class="pts-icon">&##9733;</span>
            <div class="pts-label">You have <strong>#numberFormat(custPts,'9,999')# points</strong> (= Rp #numberFormat(custPts,'9,999')#)</div>
            <label class="pts-toggle">
                <input type="checkbox" id="use-pts-toggle" <cfif maxRedeemable eq 0>disabled</cfif>>
                <span>Use</span>
            </label>
        </div>
        <cfif maxRedeemable gt 0>
        <div class="pts-detail" id="pts-detail">
            <div class="pts-saving">Saving Rp #numberFormat(maxRedeemable,'9,999')# on this order</div>
            <div class="pts-remaining">Remaining balance: #numberFormat(custPts - maxRedeemable,'9,999')# pts</div>
        </div>
        </cfif>
    </div>
    </cfif>

    <!--- Payment forms — both carry points_to_redeem hidden input --->
    <form action="/latest/customer/paymentProcess.cfm" method="post" id="form-online">
        <input type="hidden" name="pay_action" value="online">
        <input type="hidden" name="points_to_redeem" id="pts-online" value="0">
        <button type="submit" class="pay-btn pay-online" id="btn-online">Pay with Xendit</button>
    </form>
    <form action="/latest/customer/paymentProcess.cfm" method="post" id="form-cashier">
        <input type="hidden" name="pay_action" value="cashier">
        <input type="hidden" name="points_to_redeem" id="pts-cashier" value="0">
        <button type="submit" class="pay-btn pay-cashier" id="btn-cashier">Pay at Cashier</button>
    </form>
    <p class="hint">Xendit accepts cards, bank transfer, e-wallets &amp; more.</p>
</div>
</cfoutput>

<cfoutput>
<script>
    var grandTotal    = #val(totals.total_amount)#;
    var maxRedeemable = #maxRedeemable#;
    var currSym       = '#emenuCurrSym#';

    function fmt(n) {
        return currSym + ' ' + Math.round(n).toLocaleString('id-ID');
    }

    var toggle = document.getElementById('use-pts-toggle');
    if (toggle) {
        toggle.addEventListener('change', function() {
            var using  = this.checked ? maxRedeemable : 0;
            var final  = grandTotal - using;

            document.getElementById('pts-online').value  = using;
            document.getElementById('pts-cashier').value = using;

            document.getElementById('pts-detail').style.display  = this.checked ? 'block' : 'none';
            document.getElementById('row-discount').style.display = this.checked ? 'flex' : 'none';
            document.getElementById('row-final').style.display    = this.checked ? 'flex' : 'none';
            document.getElementById('row-grand').style.display    = this.checked ? 'none' : 'flex';

            document.getElementById('display-discount').textContent = '− ' + currSym + ' ' + Math.round(using).toLocaleString('id-ID');
            document.getElementById('display-final').textContent    = fmt(final);

            document.getElementById('btn-online').textContent   = this.checked
                ? 'Pay ' + fmt(final) + ' with Xendit'
                : 'Pay with Xendit';
            document.getElementById('btn-cashier').textContent  = this.checked
                ? 'Pay ' + fmt(final) + ' at Cashier'
                : 'Pay at Cashier';
        });
    }
</script>
</cfoutput>
</body>
</html>
