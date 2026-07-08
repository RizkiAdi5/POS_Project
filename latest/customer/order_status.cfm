<!---
    /latest/customer/order_status.cfm
    Live order tracker — polls order_status_json.cfm every 15 seconds.
    Connects with waiter/kitchen updates on app_orders + app_order_items.
--->
<cfinclude template="../../application.cfm">
<cfinclude template="inc_emenu_order.cfm">

<cfif NOT len(trim(SESSION.emenu_table_id))>
    <cflocation url="/latest/customer/qr_error.cfm" addtoken="false">
</cfif>
<cfif NOT len(trim(SESSION.emenu_order_id))>
    <cflocation url="/latest/customer/menu.cfm" addtoken="false">
</cfif>

<!--- Initial data load --->
<cfquery name="qOrder" datasource="#dts#">
    SELECT order_id, order_number, status, total_amount, created_at
    FROM   app_orders
    WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.emenu_order_id#">
    LIMIT  1
</cfquery>

<cfquery name="qItems" datasource="#dts#">
    SELECT item_id, quantity, unit_price, subtotal,
           status AS kitchen_status, special_instructions,
           COALESCE(item_name, item_code) AS item_name
    FROM   app_order_items
    WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.emenu_order_id#">
    ORDER  BY item_id ASC
</cfquery>

<cfset tableDisplay   = len(trim(SESSION.emenu_table_number)) ? "Table " & SESSION.emenu_table_number : "Your Table">
<cfset orderStatus    = qOrder.recordCount gt 0 ? lCase(trim(qOrder.status)) : "in progress">
<cfset orderId        = val(SESSION.emenu_order_id)>
<cfset isPaid         = qOrder.recordCount gt 0 AND emenuOrderIsPaid(dts, orderId, qOrder.status)>
<cfset canOrderMore   = qOrder.recordCount gt 0 AND emenuCustomerCanAddItems(dts, orderId, qOrder.status)>
<cfset hasItems       = qItems.recordCount gt 0>
<cfset latestPay      = emenuGetLatestPayment(dts, orderId)>
<cfset payPendingCash = (latestPay.payment_method eq "cash" AND listFindNoCase("pending,processing", latestPay.status))>
<cfset statusMsg      = structKeyExists(url, "msg") ? trim(url.msg) : "">
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1">
    <title>Order Status</title>
    <style>
        *{box-sizing:border-box;margin:0;padding:0;}
        body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;
             background:#f3f4f6;min-height:100vh;padding-bottom:40px;}

        /* Header */
        .top-bar{background:#F54900;padding:16px 20px;display:flex;
                 align-items:center;justify-content:space-between;}
        .top-bar a{color:#fff;font-size:14px;font-weight:600;text-decoration:none;
                   display:flex;align-items:center;gap:6px;}
        .top-bar a svg{width:18px;height:18px;}
        .top-bar-title{color:#fff;font-size:16px;font-weight:700;}

        .body{padding:20px 16px;}

        /* Order number card */
        .order-card{background:#fff;border-radius:20px;padding:20px;margin-bottom:16px;
                    box-shadow:0 1px 4px rgba(0,0,0,.06);border:1px solid #f0f0f0;
                    display:flex;align-items:center;justify-content:space-between;}
        .order-num{font-size:13px;color:#9ca3af;margin-bottom:3px;}
        .order-val{font-size:18px;font-weight:800;color:#111;letter-spacing:.5px;}
        .order-table{font-size:13px;color:#6b7280;margin-top:4px;}
        .refresh-badge{font-size:11px;color:#F54900;background:#fff3ee;
                       border:1px solid #fed7aa;border-radius:20px;padding:4px 10px;
                       display:flex;align-items:center;gap:4px;}
        .refresh-dot{width:6px;height:6px;background:#F54900;border-radius:50%;
                     animation:pulse 1.5s ease-in-out infinite;}
        @keyframes pulse{0%,100%{opacity:1;}50%{opacity:.3;}}

        /* Progress stepper */
        .stepper-card{background:#fff;border-radius:20px;padding:20px;margin-bottom:16px;
                      box-shadow:0 1px 4px rgba(0,0,0,.06);border:1px solid #f0f0f0;}
        .stepper-title{font-size:15px;font-weight:700;color:#111;margin-bottom:18px;}
        .stepper{display:flex;align-items:flex-start;gap:0;}
        .step{flex:1;display:flex;flex-direction:column;align-items:center;position:relative;}
        .step:not(:last-child)::after{
            content:'';position:absolute;top:20px;left:50%;width:100%;
            height:2px;background:#e5e7eb;z-index:0;
        }
        .step.done:not(:last-child)::after{background:#F54900;}
        .step-dot{width:40px;height:40px;border-radius:50%;border:2px solid #e5e7eb;
                  background:#fff;display:flex;align-items:center;justify-content:center;
                  z-index:1;transition:all .4s;}
        .step-dot svg{width:18px;height:18px;}
        .step.done .step-dot{background:#F54900;border-color:#F54900;}
        .step.done .step-dot svg{color:#fff;}
        .step.active .step-dot{background:#fff;border-color:#F54900;
                               box-shadow:0 0 0 4px rgba(245,73,0,.15);}
        .step.active .step-dot svg{color:#F54900;}
        .step-label{font-size:11px;font-weight:600;color:#9ca3af;margin-top:8px;text-align:center;}
        .step.done .step-label{color:#F54900;}
        .step.active .step-label{color:#F54900;}

        /* Ready banner */
        .ready-banner{background:linear-gradient(135deg,##16a34a,##15803d);
                      border-radius:16px;padding:20px;margin-bottom:16px;
                      text-align:center;color:#fff;display:none;}
        .ready-banner.show{display:block;}
        .ready-banner svg{width:48px;height:48px;margin:0 auto 10px;display:block;}
        .ready-banner h3{font-size:20px;font-weight:800;margin-bottom:4px;}
        .ready-banner p{font-size:13px;opacity:.9;}

        /* Items list */
        .items-card{background:#fff;border-radius:20px;padding:20px;margin-bottom:16px;
                    box-shadow:0 1px 4px rgba(0,0,0,.06);border:1px solid #f0f0f0;}
        .items-title{font-size:15px;font-weight:700;color:#111;margin-bottom:14px;}
        .item-row{display:flex;align-items:center;justify-content:space-between;
                  padding:10px 0;border-bottom:1px solid #f9fafb;}
        .item-row:last-child{border-bottom:none;}
        .item-left{display:flex;align-items:center;gap:12px;}
        .item-status-dot{width:10px;height:10px;border-radius:50%;flex-shrink:0;}
        .dot-pending {background:#d1d5db;}
        .dot-progress{background:#f59e0b;animation:pulse 1s infinite;}
        .dot-ready   {background:#22c55e;}
        .item-name{font-size:14px;font-weight:600;color:#111;}
        .item-qty {font-size:12px;color:#9ca3af;margin-top:2px;}
        .item-chip{font-size:11px;font-weight:700;padding:3px 10px;border-radius:20px;}
        .chip-pending {background:#f3f4f6;color:#6b7280;}
        .chip-progress{background:#fef3c7;color:#92400e;}
        .chip-ready   {background:#dcfce7;color:#15803d;}

        /* Buttons */
        .btn-more{display:block;width:100%;padding:16px;border-radius:14px;
                  background:#F54900;color:#fff;text-align:center;
                  font-size:16px;font-weight:700;text-decoration:none;margin-bottom:10px;}
        .btn-profile{display:block;width:100%;padding:14px;border-radius:14px;
                     background:#fff;color:#F54900;text-align:center;
                     font-size:15px;font-weight:700;text-decoration:none;
                     border:2px solid #F54900;}
        .btn-pay{display:block;width:100%;padding:16px;border-radius:14px;
                 background:##16a34a;color:#fff;text-align:center;
                 font-size:16px;font-weight:700;text-decoration:none;margin-bottom:10px;}
        .info-box{background:#fff7ed;border:1px solid #fed7aa;border-radius:12px;
                 padding:12px 14px;font-size:13px;color:#9a3412;margin-bottom:14px;line-height:1.45;}
        .countdown{text-align:center;font-size:12px;color:#9ca3af;margin:12px 0;}
    </style>
</head>
<body>
<cfoutput>

<!--- Top bar --->
<div class="top-bar">
    <a href="/latest/customer/menu.cfm">
        <svg fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7"/>
        </svg>
        Menu
    </a>
    <span class="top-bar-title">Order Status</span>
    <div style="width:60px;"></div>
</div>

<div class="body">

    <cfif statusMsg eq "already_paid">
        <div class="info-box">This bill has already been paid. Ask staff to complete the table session if you are leaving.</div>
    <cfelseif payPendingCash>
        <div class="info-box">Cash payment pending &mdash; please pay at the cashier. Staff will confirm on the waiter dashboard.</div>
    <cfelseif isPaid>
        <div class="info-box">Payment received. Thank you! Staff will clear this table when your visit is finished.</div>
    </cfif>

    <!--- Order number + table --->
    <div class="order-card">
        <div>
            <div class="order-num">Order Number</div>
            <div class="order-val" id="orderNumDisplay">#HTMLEditFormat(SESSION.emenu_order_number)#</div>
            <div class="order-table">#HTMLEditFormat(tableDisplay)#</div>
        </div>
        <div class="refresh-badge">
            <div class="refresh-dot"></div>
            Live
        </div>
    </div>

    <!--- Ready banner (shown when all ready) --->
    <div class="ready-banner" id="readyBanner">
        <svg fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round"
                  d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
        </svg>
        <h3>Your Order is Ready!</h3>
        <p>Our staff will bring it to #HTMLEditFormat(tableDisplay)# shortly.</p>
    </div>

    <!--- Progress stepper --->
    <div class="stepper-card">
        <div class="stepper-title">Order Progress</div>
        <div class="stepper" id="stepper">
            <!--- Rendered by JS --->
            <div class="step done" id="step0">
                <div class="step-dot">
                    <svg fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/>
                    </svg>
                </div>
                <div class="step-label">Received</div>
            </div>
            <div class="step" id="step1">
                <div class="step-dot">
                    <svg fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round"
                              d="M15.362 5.214A8.252 8.252 0 0112 21 8.25 8.25 0 016.038 7.048 8.287 8.287 0 009 9.6a8.983 8.983 0 013.361-6.867 8.21 8.21 0 003 2.48z"/>
                    </svg>
                </div>
                <div class="step-label">Preparing</div>
            </div>
            <div class="step" id="step2">
                <div class="step-dot">
                    <svg fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round"
                              d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                </div>
                <div class="step-label">Ready!</div>
            </div>
        </div>
    </div>

    <!--- Item list --->
    <div class="items-card">
        <div class="items-title">Your Items</div>
        <div id="itemsList">
            <cfloop query="qItems">
                <cfset ks = lCase(trim(qItems.kitchen_status))>
                <cfif ks eq "ready">
                    <cfset dotClass = "dot-ready"><cfset chipClass = "chip-ready"><cfset chipLabel = "Ready">
                <cfelseif ks eq "in progress">
                    <cfset dotClass = "dot-progress"><cfset chipClass = "chip-progress"><cfset chipLabel = "Preparing">
                <cfelse>
                    <cfset dotClass = "dot-pending"><cfset chipClass = "chip-pending"><cfset chipLabel = "Pending">
                </cfif>
                <div class="item-row">
                    <div class="item-left">
                        <div class="item-status-dot #dotClass#"></div>
                        <div>
                            <div class="item-name">#HTMLEditFormat(qItems.item_name)#</div>
                            <div class="item-qty">x#qItems.quantity#</div>
                        </div>
                    </div>
                    <span class="item-chip #chipClass#">#chipLabel#</span>
                </div>
            </cfloop>
        </div>
    </div>

    <div class="countdown" id="countdown">Refreshing in <span id="countNum">15</span>s</div>

    <cfif canOrderMore>
        <a href="/latest/customer/menu.cfm" class="btn-more">Order More</a>
    </cfif>
    <cfif hasItems AND NOT isPaid AND NOT payPendingCash>
        <a href="/latest/customer/payment.cfm" class="btn-pay">Pay Bill</a>
    </cfif>
    <cfif SESSION.emenu_loggedin eq "Yes">
    <a href="/latest/customer/profile.cfm" class="btn-profile">View Points &amp; Profile</a>
    </cfif>

</div>
</cfoutput>

<script>
/* ── Status helpers ── */
function getStepFromStatus(orderStatus, items) {
    var allReady    = items.length > 0 && items.every(function(i){ return i.status.toLowerCase() === 'ready'; });
    var anyProgress = items.some(function(i){ return i.status.toLowerCase() === 'in progress'; });
    var s = (orderStatus || '').toLowerCase();
    if (allReady || s === 'ready') return 2;
    if (anyProgress || s === 'preparing' || s === 'in progress') return 1;
    return 0;
}

function renderStepper(step) {
    for (var i = 0; i <= 2; i++) {
        var el = document.getElementById('step' + i);
        el.className = 'step';
        if (i < step)  el.className += ' done';
        if (i === step) el.className += ' active';
    }
    /* always mark step 0 done (order received) */
    if (step === 0) {
        document.getElementById('step0').className = 'step active';
    }
    var banner = document.getElementById('readyBanner');
    if (step === 2) banner.classList.add('show');
    else            banner.classList.remove('show');
}

function renderItems(items) {
    var html = '';
    items.forEach(function(item) {
        var ks = (item.status || '').toLowerCase();
        var dotClass, chipClass, chipLabel;
        if (ks === 'ready')       { dotClass='dot-ready';    chipClass='chip-ready';    chipLabel='Ready';    }
        else if (ks === 'in progress') { dotClass='dot-progress'; chipClass='chip-progress'; chipLabel='Preparing'; }
        else                      { dotClass='dot-pending';  chipClass='chip-pending';  chipLabel='Pending';  }

        html += '<div class="item-row">' +
            '<div class="item-left">' +
                '<div class="item-status-dot ' + dotClass + '"></div>' +
                '<div>' +
                    '<div class="item-name">' + escHtml(item.name) + '</div>' +
                    '<div class="item-qty">x' + item.qty + '</div>' +
                '</div>' +
            '</div>' +
            '<span class="item-chip ' + chipClass + '">' + chipLabel + '</span>' +
        '</div>';
    });
    document.getElementById('itemsList').innerHTML = html;
}

function escHtml(s){ return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }

/* ── Initial render ── */
<cfoutput>
var initialStatus = '#lCase(trim(qOrder.status))#';
var initialItems  = [
    <cfset sep = "">
    <cfloop query="qItems">
        <cfoutput>#sep#{"name":"#JSStringFormat(qItems.item_name)#","qty":#qItems.quantity#,"status":"#JSStringFormat(qItems.kitchen_status)#"}</cfoutput>
        <cfset sep = ",">
    </cfloop>
];
</cfoutput>
renderStepper(getStepFromStatus(initialStatus, initialItems));

/* ── Polling every 15 seconds ── */
var countEl  = document.getElementById('countNum');
var countdown = 15;

setInterval(function(){
    countdown--;
    countEl.textContent = countdown;
    if (countdown <= 0) {
        countdown = 15;
        fetch('/latest/customer/order_status_json.cfm', { credentials: 'include' })
            .then(function(r){ return r.json(); })
            .then(function(data){
                if (data.error) return;
                renderStepper(getStepFromStatus(data.order_status, data.items));
                renderItems(data.items);
            })
            .catch(function(){});
    }
}, 1000);
</script>

</body>
</html>
