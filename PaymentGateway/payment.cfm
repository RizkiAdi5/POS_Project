<!---
    /PaymentGateway/payment.cfm — Customer pay bill (Xendit + cashier).
--->
<cfinclude template="/application.cfm">
<cfinclude template="/latest/customer/inc_emenu_order.cfm">
<cfinclude template="/latest/customer/inc_xendit_pay.cfm">
<cfparam name="REQUEST.emenu_currency_symbol" default="RM">
<cfparam name="REQUEST.emenu_currency_decimals" default="2">
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
<cfset ewalletMobilePrefill = structKeyExists(SESSION, "emenu_phone") ? trim(SESSION.emenu_phone) : "">
<cfset payErr = structKeyExists(url, "err") ? trim(url.err) : "">
<cfset payErrDetail = "">
<cfif structKeyExists(SESSION, "emenu_pay_error") AND len(trim(SESSION.emenu_pay_error))>
    <cfset payErrDetail = trim(SESSION.emenu_pay_error)>
    <cfset SESSION.emenu_pay_error = "">
</cfif>
<cfset pgProf = emenuPgProfile(dts)>
<cfset xenditOn = REQUEST.xendit.isActive AND pgProf.xendit_ready>
<cfset enabledMethods = pgSafeJsonArray(pgProf.payment_methods_enabled)>
<cfset enabledMethodList = UCase(ArrayToList(enabledMethods))>
<cfset enabledVaBanks = pgSafeJsonArray(pgProf.va_banks_enabled)>
<cfif ArrayLen(enabledMethods) EQ 0>
    <cfset enabledMethodList = "">
    <cfif pgProf.enable_qris EQ "Y"><cfset enabledMethodList = ListAppend(enabledMethodList, "QRIS")></cfif>
    <cfif pgProf.enable_ewallet EQ "Y"><cfset enabledMethodList = ListAppend(enabledMethodList, "EWALLET")></cfif>
    <cfif pgProf.enable_va EQ "Y"><cfset enabledMethodList = ListAppend(enabledMethodList, "VIRTUAL_ACCOUNT")></cfif>
    <cfif pgProf.enable_card EQ "Y"><cfset enabledMethodList = ListAppend(enabledMethodList, "CARD")></cfif>
</cfif>
<cfset enableQris = ListFindNoCase(enabledMethodList, "QRIS") GT 0>
<cfset enableEwallet = ListFindNoCase(enabledMethodList, "EWALLET") GT 0>
<cfset enableVa = ListFindNoCase(enabledMethodList, "VIRTUAL_ACCOUNT") GT 0>
<cfset enableCard = ListFindNoCase(enabledMethodList, "CARD") GT 0>
<cfset hasOnlineOption = (enableQris OR enableEwallet OR enableVa OR enableCard)>
<cfif enableVa AND ArrayLen(enabledVaBanks) EQ 0>
    <cfif Len(Trim(ToString(pgProf.payout_channel_code)))>
        <cfset ArrayAppend(enabledVaBanks, UCase(Trim(ToString(pgProf.payout_channel_code))))>
    <cfelse>
        <cfset ArrayAppend(enabledVaBanks, "BRI")>
    </cfif>
</cfif>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1">
    <title>Pay Bill</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        *{box-sizing:border-box;margin:0;padding:0;}
        body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;background:linear-gradient(180deg,#fff7ed 0%,#f3f4f6 240px,#f3f4f6 100%);min-height:100vh;padding-bottom:40px;}
        .top{background:linear-gradient(135deg,#F54900,#d9480f);color:#fff;padding:16px 20px;display:flex;align-items:center;gap:12px;box-shadow:0 4px 18px rgba(245,73,0,.28);}
        .top a{color:#fff;text-decoration:none;font-size:14px;font-weight:600;}
        .top h1{font-size:18px;font-weight:800;flex:1;text-align:center;margin-right:40px;}
        .body{padding:16px;max-width:760px;margin:0 auto;}
        .card{background:#fff;border-radius:20px;padding:20px;margin-bottom:14px;border:1px solid #f0f0f0;box-shadow:0 6px 24px rgba(0,0,0,.06);}
        .meta{font-size:13px;color:#6b7280;margin-bottom:4px;}
        .ord{font-size:16px;font-weight:800;color:#111;margin-bottom:16px;}
        .row{display:flex;justify-content:space-between;font-size:14px;color:#374151;margin-bottom:8px;}
        .row.grand{font-size:17px;font-weight:800;color:#111;padding-top:12px;border-top:1px solid #eee;margin-top:8px;}
        .item{display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid #f9fafb;font-size:14px;}
        .item:last-child{border-bottom:none;}
        .err{background:#fef2f2;border:1px solid #fecaca;color:#b91c1c;padding:12px;border-radius:12px;margin-bottom:14px;font-size:13px;}
        .warn{background:#fffbeb;border:1px solid #fde68a;color:#92400e;padding:12px;border-radius:12px;margin-bottom:14px;font-size:13px;}
        .sec{font-size:12px;font-weight:800;color:#6b7280;text-transform:uppercase;letter-spacing:.06em;margin:16px 0 10px;}
        .option-grid{display:grid;grid-template-columns:1fr;gap:10px;}
        .option-card{display:flex;align-items:center;justify-content:space-between;gap:12px;width:100%;padding:14px;border-radius:16px;border:1px solid #e5e7eb;background:#fff;color:#111;cursor:pointer;transition:all .18s ease;}
        .option-card:hover{border-color:#fed7aa;box-shadow:0 6px 16px rgba(245,73,0,.12);transform:translateY(-1px);}
        .option-main{display:flex;align-items:center;gap:12px;min-width:0;text-align:left;}
        .option-icon{width:42px;height:42px;flex:0 0 42px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:18px;background:#fff3ed;color:#F54900;}
        .option-text{min-width:0;}
        .option-title{font-size:15px;font-weight:800;color:#111;line-height:1.2;}
        .option-sub{font-size:12px;color:#6b7280;margin-top:2px;line-height:1.35;}
        .option-arrow{font-size:16px;color:#9ca3af;}
        .option-primary{width:100%;padding:15px;border-radius:16px;border:none;background:#F54900;color:#fff;font-size:15px;font-weight:800;cursor:pointer;display:flex;align-items:center;justify-content:center;gap:8px;box-shadow:0 8px 20px rgba(245,73,0,.28);}
        .option-primary:hover{opacity:.95;}
        .ewallet-grid{display:grid;grid-template-columns:1fr 1fr;gap:10px;}
        .ewallet-mobile-wrap{margin:8px 0 10px;}
        .ewallet-mobile-label{display:block;font-size:12px;color:#6b7280;margin-bottom:6px;font-weight:700;}
        .ewallet-mobile-input{width:100%;padding:11px 12px;border-radius:10px;border:1px solid #e5e7eb;font-size:14px;outline:none;}
        .ewallet-mobile-input:focus{border-color:#fb923c;box-shadow:0 0 0 3px rgba(251,146,60,.15);}
        .pill-btn{width:100%;padding:12px;border-radius:12px;border:1px solid #fed7aa;background:#fff7ed;color:#9a3412;font-weight:700;cursor:pointer;}
        .pill-btn:hover{background:#ffedd5;}
        .pay-cashier{width:100%;padding:14px;border-radius:14px;background:#fff;color:#F54900;border:2px solid #F54900;font-weight:800;cursor:pointer;}
        .hint{font-size:12px;color:#6b7280;text-align:center;margin-top:12px;line-height:1.5;}
        @media (max-width:560px){ .ewallet-grid{grid-template-columns:1fr;} }
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
                <cfcase value="xendit_failed">Could not start online payment. <cfif len(payErrDetail)>#HTMLEditFormat(payErrDetail)#<cfelse>Try again or pay at the cashier.</cfif></cfcase>
                <cfcase value="ovo_mobile_required">OVO requires a valid mobile number. Please enter your OVO number (format 08xxx or 62xxx).</cfcase>
                <cfcase value="ovo_mobile_invalid">OVO mobile number format is invalid. Use Indonesian mobile format (08xxx or 62xxx).</cfcase>
                <cfcase value="invalid_action">Invalid payment option.</cfcase>
                <cfdefaultcase>Payment could not be completed. <cfif len(payErrDetail)>#HTMLEditFormat(payErrDetail)#<cfelse>Please try again or pay at the cashier.</cfif></cfdefaultcase>
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

    <cfif xenditOn AND hasOnlineOption>
        <div class="sec">Pay online</div>
        <div class="option-grid">
        <cfif enableQris>
        <form action="/PaymentGateway/paymentProcess.cfm" method="post" class="pm-method" data-method="QRIS">
            <input type="hidden" name="pay_action" value="qris">
            <button type="submit" class="option-primary"><i class="bi bi-qr-code-scan"></i> Pay with QRIS</button>
        </form>
        </cfif>
        <cfif enableEwallet>
        <div class="sec">E-Wallet</div>
        <div class="ewallet-mobile-wrap">
            <label class="ewallet-mobile-label" for="ewalletMobile">Phone number (required for OVO)</label>
            <input id="ewalletMobile" class="ewallet-mobile-input" type="tel" inputmode="numeric" autocomplete="tel" placeholder="08xxxxxxxxxx / 628xxxxxxxxxx" value="#HTMLEditFormat(ewalletMobilePrefill)#">
        </div>
        <div class="ewallet-grid">
            <form action="/PaymentGateway/paymentProcess.cfm" method="post" class="pm-channel" data-method="EWALLET" data-channel="OVO" onsubmit="return attachEwalletMobile(this)"><input type="hidden" name="pay_action" value="ewallet"><input type="hidden" name="ewallet_channel" value="OVO"><input type="hidden" name="ewallet_mobile" value=""><button type="submit" class="pill-btn">OVO</button></form>
            <form action="/PaymentGateway/paymentProcess.cfm" method="post" class="pm-channel" data-method="EWALLET" data-channel="DANA" onsubmit="return attachEwalletMobile(this)"><input type="hidden" name="pay_action" value="ewallet"><input type="hidden" name="ewallet_channel" value="DANA"><input type="hidden" name="ewallet_mobile" value=""><button type="submit" class="pill-btn">DANA</button></form>
            <form action="/PaymentGateway/paymentProcess.cfm" method="post" class="pm-channel" data-method="EWALLET" data-channel="GOPAY" onsubmit="return attachEwalletMobile(this)"><input type="hidden" name="pay_action" value="ewallet"><input type="hidden" name="ewallet_channel" value="GOPAY"><input type="hidden" name="ewallet_mobile" value=""><button type="submit" class="pill-btn">GoPay</button></form>
            <form action="/PaymentGateway/paymentProcess.cfm" method="post" class="pm-channel" data-method="EWALLET" data-channel="SHOPEEPAY" onsubmit="return attachEwalletMobile(this)"><input type="hidden" name="pay_action" value="ewallet"><input type="hidden" name="ewallet_channel" value="SHOPEEPAY"><input type="hidden" name="ewallet_mobile" value=""><button type="submit" class="pill-btn">ShopeePay</button></form>
        </div>
        </cfif>
        <cfif enableVa>
        <form action="/PaymentGateway/paymentProcess.cfm" method="post" class="pm-method" data-method="VIRTUAL_ACCOUNT">
            <input type="hidden" name="pay_action" value="va">
            <cfif ArrayLen(enabledVaBanks) GT 1>
                <div class="ewallet-mobile-wrap" style="margin-top:10px">
                    <label class="ewallet-mobile-label" for="vaBank">Virtual Account Bank</label>
                    <select id="vaBank" name="va_bank" class="ewallet-mobile-input">
                        <cfloop from="1" to="#ArrayLen(enabledVaBanks)#" index="i">
                            <cfset vaOpt = UCase(Trim(ToString(enabledVaBanks[i])))>
                            <option value="#HTMLEditFormat(vaOpt)#">#HTMLEditFormat(vaOpt)#</option>
                        </cfloop>
                    </select>
                </div>
            <cfelseif ArrayLen(enabledVaBanks) EQ 1>
                <input type="hidden" name="va_bank" value="#HTMLEditFormat(UCase(Trim(ToString(enabledVaBanks[1]))))#">
            </cfif>
            <button type="submit" class="option-card">
                <span class="option-main"><span class="option-icon"><i class="bi bi-bank"></i></span><span class="option-text"><span class="option-title">Virtual Account</span><span class="option-sub">Transfer to bank VA number</span></span></span>
                <span class="option-arrow"><i class="bi bi-chevron-right"></i></span>
            </button>
        </form>
        </cfif>
        <cfif enableCard>
        <form action="/PaymentGateway/paymentProcess.cfm" method="post" class="pm-method" data-method="CARD">
            <input type="hidden" name="pay_action" value="card">
            <button type="submit" class="option-card">
                <span class="option-main"><span class="option-icon"><i class="bi bi-credit-card-2-front"></i></span><span class="option-text"><span class="option-title">Credit / Debit Card</span><span class="option-sub">Secure card checkout</span></span></span>
                <span class="option-arrow"><i class="bi bi-chevron-right"></i></span>
            </button>
        </form>
        </cfif>
        </div>
    <cfelseif NOT xenditOn>
        <div class="warn">Online payment is not active. Merchant must complete Payment Gateway setup in POS.</div>
    <cfelse>
        <div class="warn">No online payment method is enabled yet. Ask merchant to enable methods in Payment Gateway Profile.</div>
    </cfif>

    <div class="sec">Or</div>
    <form action="/PaymentGateway/paymentProcess.cfm" method="post">
        <input type="hidden" name="pay_action" value="cashier">
        <button type="submit" class="pay-cashier">Pay at Cashier</button>
    </form>
    <p class="hint">Online payments are processed by Xendit. Cashier payment notifies staff on the waiter dashboard.</p>
</div>
</cfoutput>
<script>
function attachEwalletMobile(formEl){
    var input = document.getElementById("ewalletMobile");
    var hidden = formEl.querySelector('input[name="ewallet_mobile"]');
    if (hidden && input) {
        hidden.value = (input.value || "").trim();
    }
    return true;
}

(function syncPaymentConfig(){
    fetch("/PaymentGateway/api/payment-config.cfm", { credentials: "same-origin" })
        .then(function(r){ return r.json(); })
        .then(function(res){
            if(!res || res.success !== true || !res.data || !res.data.channels){ return; }
            var enabledMethods = {};
            var enabledChannels = {};
            (res.data.channels || []).forEach(function(g){
                var m = String(g.method || "").toUpperCase();
                if(!m){ return; }
                enabledMethods[m] = true;
                (g.channels || []).forEach(function(c){
                    enabledChannels[m + ":" + String(c || "").toUpperCase()] = true;
                });
            });

            document.querySelectorAll(".pm-method").forEach(function(el){
                var m = String(el.getAttribute("data-method") || "").toUpperCase();
                if(m && !enabledMethods[m]){
                    el.style.display = "none";
                }
            });
            document.querySelectorAll(".pm-channel").forEach(function(el){
                var m = String(el.getAttribute("data-method") || "").toUpperCase();
                var c = String(el.getAttribute("data-channel") || "").toUpperCase();
                if(m && c && !enabledChannels[m + ":" + c]){
                    el.style.display = "none";
                }
            });
        })
        .catch(function(){});
})();
</script>
</body>
</html>
