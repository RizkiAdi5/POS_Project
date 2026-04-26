<cfprocessingdirective pageencoding="UTF-8">
<cfinclude template="../../application.cfm">
<cfsetting enablecfoutputonly="false">
<cfsetting showdebugoutput="false">

<cfset flashMsg = "">
<cfset flashErr = "">
<cfif structKeyExists(url,"msg") AND len(trim(url.msg))><cfset flashMsg = trim(url.msg)></cfif>
<cfif structKeyExists(url,"err") AND len(trim(url.err))><cfset flashErr = trim(url.err)></cfif>

<!--- ── POST actions ── --->
<cfif isDefined("form.form_action") AND len(trim(dts))>

    <!--- Update single item kitchen_status --->
    <cfif form.form_action eq "update_item" AND isNumeric(form.item_id)>
        <cfset allowed = "Pending,In Progress,Ready">
        <cfif listFindNoCase(allowed, form.new_status)>
            <cftry>
                <cfquery datasource="#dts#">
                    UPDATE app_order_items
                    SET    status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.new_status#">
                    <cfif form.new_status eq "Ready">
                        , prepared_at = NOW()
                    </cfif>
                    WHERE  item_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.item_id#">
                </cfquery>

                <!--- Auto-update order status if all items ready --->
                <cfquery name="qCheck" datasource="#dts#">
                    SELECT COUNT(*) AS total,
                           SUM(CASE WHEN status = 'Ready' THEN 1 ELSE 0 END) AS ready_count
                    FROM   app_order_items
                    WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.order_id#">
                </cfquery>
                <cfif val(qCheck.ready_count) eq val(qCheck.total) AND val(qCheck.total) gt 0>
                    <cfquery datasource="#dts#">
                        UPDATE app_orders SET status = 'ready'
                        WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.order_id#">
                    </cfquery>
                <cfelse>
                    <cfquery datasource="#dts#">
                        UPDATE app_orders SET status = 'in progress'
                        WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.order_id#">
                          AND  status NOT IN ('paid','cancelled')
                    </cfquery>
                </cfif>

                <cfset flashMsg = "Item status updated to #form.new_status#.">
                <cfcatch type="any">
                    <cfset flashErr = "Update failed: " & left(cfcatch.message,200)>
                </cfcatch>
            </cftry>
        <cfelse>
            <cfset flashErr = "Invalid status.">
        </cfif>
        <cflocation url="Orders.cfm?msg=#URLEncodedFormat(flashMsg)#&err=#URLEncodedFormat(flashErr)#" addtoken="false">
    </cfif>

    <!--- Mark whole order ready --->
    <cfif form.form_action eq "mark_order_ready" AND isNumeric(form.order_id)>
        <cftry>
            <cfquery datasource="#dts#">
                UPDATE app_order_items
                SET    status = 'Ready', prepared_at = NOW()
                WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.order_id#">
            </cfquery>
            <cfquery datasource="#dts#">
                UPDATE app_orders SET status = 'ready'
                WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.order_id#">
            </cfquery>
            <cfset flashMsg = "Order marked as Ready.">
            <cfcatch type="any">
                <cfset flashErr = "Update failed: " & left(cfcatch.message,200)>
            </cfcatch>
        </cftry>
        <cflocation url="Orders.cfm?msg=#URLEncodedFormat(flashMsg)#&err=#URLEncodedFormat(flashErr)#" addtoken="false">
    </cfif>
</cfif>

<!--- ── Load active orders ── --->
<cfset pageError = "">
<cfset orders    = []>
<cftry>
    <cfquery name="qOrders" datasource="#dts#">
        SELECT order_id, order_number, table_number, custno,
               status, total_amount, created_at
        FROM   app_orders
        WHERE  status NOT IN ('paid','cancelled','completed')
        ORDER  BY created_at ASC
    </cfquery>

    <cfquery name="qAllItems" datasource="#dts#">
        SELECT item_id, order_id, quantity, status AS kitchen_status,
               COALESCE(item_name, item_code) AS item_name
        FROM   app_order_items
        WHERE  order_id IN (
            SELECT order_id FROM app_orders
            WHERE  status NOT IN ('paid','cancelled','completed')
        )
        ORDER  BY order_id ASC, item_id ASC
    </cfquery>

    <!--- Group items by order_id --->
    <cfset itemsByOrder = structNew()>
    <cfloop query="qAllItems">
        <cfset key = toString(qAllItems.order_id)>
        <cfif NOT structKeyExists(itemsByOrder, key)>
            <cfset itemsByOrder[key] = []>
        </cfif>
        <cfset arrayAppend(itemsByOrder[key], {
            "item_id"       : val(qAllItems.item_id),
            "item_name"     : trim(toString(qAllItems.item_name)),
            "quantity"      : val(qAllItems.quantity),
            "kitchen_status": trim(toString(qAllItems.kitchen_status))
        })>
    </cfloop>

    <cfcatch type="any">
        <cfset pageError = "Query failed: " & left(cfcatch.message,300)>
    </cfcatch>
</cftry>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Active Orders — Waiter</title>
<link rel="stylesheet" href="/latest/css/bootstrap/bootstrap.min.css">
<style>
body{background:#f5f7fb;font-family:'Segoe UI',Arial,sans-serif;padding:20px 16px 60px;}
.page-head{display:flex;align-items:center;justify-content:space-between;margin-bottom:18px;
           padding-bottom:12px;border-bottom:3px solid #F54900;}
.page-title{font-size:24px;font-weight:700;margin:0;}
.order-card{background:#fff;border:1px solid #e5e7eb;border-radius:12px;
            padding:16px;margin-bottom:16px;box-shadow:0 1px 3px rgba(0,0,0,.04);}
.order-card.ready{border-color:#86efac;background:#f0fdf4;}
.order-header{display:flex;align-items:center;justify-content:space-between;
              margin-bottom:12px;padding-bottom:10px;border-bottom:1px solid #f0f0f0;}
.order-num{font-size:15px;font-weight:700;color:#111;}
.order-meta{font-size:12px;color:#9ca3af;margin-top:2px;}
.status-chip{display:inline-block;font-size:11px;font-weight:700;
             padding:3px 10px;border-radius:20px;}
.chip-progress{background:#fef3c7;color:#92400e;}
.chip-ready   {background:#dcfce7;color:#15803d;}
.chip-pending {background:#f3f4f6;color:#6b7280;}
.item-row{display:flex;align-items:center;justify-content:space-between;
          padding:8px 0;border-bottom:1px solid #f9fafb;}
.item-row:last-child{border-bottom:none;}
.item-name{font-size:14px;font-weight:600;color:#111;}
.item-qty {font-size:12px;color:#9ca3af;}
.item-actions{display:flex;gap:6px;}
.btn-status{font-size:12px;padding:5px 10px;border-radius:8px;border:1px solid;
            cursor:pointer;font-weight:600;background:#fff;}
.btn-pending {color:#6b7280;border-color:#d1d5db;}
.btn-progress{color:#92400e;border-color:#fcd34d;background:#fef3c7;}
.btn-ready   {color:#15803d;border-color:#86efac;background:#dcfce7;}
.btn-status.active{box-shadow:0 0 0 2px currentColor;font-weight:800;}
.btn-ready-all{width:100%;margin-top:10px;}
.empty{text-align:center;padding:48px;color:#9ca3af;font-size:15px;}
.auto-badge{font-size:12px;color:#F54900;font-weight:600;
            background:#fff3ee;border:1px solid #fed7aa;border-radius:20px;
            padding:4px 12px;display:flex;align-items:center;gap:6px;}
.pulse{width:8px;height:8px;background:#F54900;border-radius:50%;
       animation:pulse 1.5s ease-in-out infinite;display:inline-block;}
@keyframes pulse{0%,100%{opacity:1;}50%{opacity:.3;}}
</style>
</head>
<body>
<cfoutput>
<div class="page-head">
    <div>
        <h1 class="page-title">Active Orders</h1>
        <p style="margin:0;font-size:13px;color:##9ca3af;">Auto-refreshes every 20 seconds</p>
    </div>
    <div style="display:flex;align-items:center;gap:10px;">
        <div class="auto-badge"><span class="pulse"></span> Live</div>
        <a href="Tables.cfm" class="btn btn-default btn-sm">Tables</a>
    </div>
</div>

<cfif len(flashMsg)><div class="alert alert-success">#HTMLEditFormat(flashMsg)#</div></cfif>
<cfif len(flashErr)><div class="alert alert-danger">#HTMLEditFormat(flashErr)#</div></cfif>
<cfif len(pageError)><div class="alert alert-warning">#HTMLEditFormat(pageError)#</div></cfif>

<cfif qOrders.recordCount eq 0>
    <div class="empty">No active orders right now.</div>
<cfelse>
    <cfloop query="qOrders">
        <cfset oid     = val(qOrders.order_id)>
        <cfset okey    = toString(oid)>
        <cfset oStatus = lCase(trim(qOrders.status))>
        <cfset oItems  = structKeyExists(itemsByOrder, okey) ? itemsByOrder[okey] : []>

        <cfset allReady = arrayLen(oItems) gt 0>
        <cfloop array="#oItems#" index="oi">
            <cfif lCase(trim(oi.kitchen_status)) neq "ready"><cfset allReady = false></cfif>
        </cfloop>

        <div class="order-card#(allReady ? ' ready' : '')#">
            <div class="order-header">
                <div>
                    <div class="order-num">Table #HTMLEditFormat(qOrders.table_number)# &mdash; #HTMLEditFormat(qOrders.order_number)#</div>
                    <div class="order-meta">
                        #timeFormat(qOrders.created_at,'HH:mm')# &bull; RM #numberFormat(val(qOrders.total_amount),'9,990.00')#
                        <cfif len(trim(qOrders.custno))> &bull; #HTMLEditFormat(qOrders.custno)#</cfif>
                    </div>
                </div>
                <span class="status-chip #(allReady ? 'chip-ready' : (oStatus eq 'in progress' ? 'chip-progress' : 'chip-pending'))#">
                    #(allReady ? 'All Ready' : (oStatus eq 'in progress' ? 'In Progress' : HTMLEditFormat(qOrders.status)))#
                </span>
            </div>

            <cfloop array="#oItems#" index="oi2">
                <cfset ks = lCase(trim(oi2.kitchen_status))>
                <div class="item-row">
                    <div>
                        <div class="item-name">#HTMLEditFormat(oi2.item_name)#</div>
                        <div class="item-qty">x#oi2.quantity#</div>
                    </div>
                    <div class="item-actions">
                        <form method="post" action="Orders.cfm" style="display:inline;">
                            <input type="hidden" name="form_action" value="update_item">
                            <input type="hidden" name="item_id"    value="#oi2.item_id#">
                            <input type="hidden" name="order_id"   value="#oid#">
                            <input type="hidden" name="new_status" value="Pending">
                            <button type="submit" class="btn-status btn-pending#(ks eq 'pending' ? ' active' : '')#">Pending</button>
                        </form>
                        <form method="post" action="Orders.cfm" style="display:inline;">
                            <input type="hidden" name="form_action" value="update_item">
                            <input type="hidden" name="item_id"    value="#oi2.item_id#">
                            <input type="hidden" name="order_id"   value="#oid#">
                            <input type="hidden" name="new_status" value="In Progress">
                            <button type="submit" class="btn-status btn-progress#(ks eq 'in progress' ? ' active' : '')#">Preparing</button>
                        </form>
                        <form method="post" action="Orders.cfm" style="display:inline;">
                            <input type="hidden" name="form_action" value="update_item">
                            <input type="hidden" name="item_id"    value="#oi2.item_id#">
                            <input type="hidden" name="order_id"   value="#oid#">
                            <input type="hidden" name="new_status" value="Ready">
                            <button type="submit" class="btn-status btn-ready#(ks eq 'ready' ? ' active' : '')#">Ready</button>
                        </form>
                    </div>
                </div>
            </cfloop>

            <cfif NOT allReady>
            <form method="post" action="Orders.cfm">
                <input type="hidden" name="form_action" value="mark_order_ready">
                <input type="hidden" name="order_id"   value="#oid#">
                <button type="submit" class="btn btn-success btn-sm btn-ready-all">
                    Mark All Ready
                </button>
            </form>
            </cfif>
        </div>
    </cfloop>
</cfif>
</cfoutput>

<script>
/* Auto-refresh every 20 seconds */
var t = 20;
setInterval(function(){
    t--;
    if (t <= 0) { window.location.reload(); }
}, 1000);
</script>
<script src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
<script src="/latest/js/bootstrap/bootstrap.min.js"></script>
</body>
</html>
