<cfprocessingdirective pageencoding="UTF-8">
<cfinclude template="../application.cfm">
<cfsetting enablecfoutputonly="false">
<cfsetting showdebugoutput="false">

<!--- ── Kitchen session defaults ── --->
<cfparam name="SESSION.kitchen_loggedin" default="No">
<cfparam name="SESSION.kitchen_id"       default="">
<cfparam name="SESSION.kitchen_name"     default="">
<cfparam name="SESSION.kitchen_dts"      default="">

<!--- ── Logout ── --->
<cfif isDefined("url.kitchen_logout") AND url.kitchen_logout EQ "1">
    <cfset SESSION.kitchen_loggedin = "No">
    <cfset SESSION.kitchen_id       = "">
    <cfset SESSION.kitchen_name     = "">
    <cfset SESSION.kitchen_dts      = "">
    <cflocation url="Orders.cfm" addtoken="false">
</cfif>

<!--- ── Handle login POST ── --->
<cfset kitchenLoginError = "">
<cfif isDefined("form.kitchen_login_submit")>
    <cfif NOT len(trim(form.kitchen_id))>
        <cfset kitchenLoginError = "Please select a kitchen staff.">
    <cfelseif NOT len(trim(form.kitchen_password))>
        <cfset kitchenLoginError = "Please enter your password.">
    <cfelse>
        <cfquery name="qCheckKitchen" datasource="#dts#">
            SELECT kitchenID, name
            FROM   kitchen
            WHERE  kitchenID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.kitchen_id)#">
              AND  password  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.kitchen_password)#">
        </cfquery>
        <cfif qCheckKitchen.recordcount EQ 1>
            <cfset SESSION.kitchen_loggedin = "Yes">
            <cfset SESSION.kitchen_id       = qCheckKitchen.kitchenID>
            <cfset SESSION.kitchen_name     = qCheckKitchen.name>
            <cfset SESSION.kitchen_dts      = dts>
            <cflocation url="Orders.cfm" addtoken="false">
        <cfelse>
            <cfset kitchenLoginError = "Invalid kitchen ID or password.">
        </cfif>
    </cfif>
</cfif>

<!--- ── Show modal chooser if not logged in ── --->
<cfif SESSION.kitchen_loggedin NEQ "Yes" OR SESSION.kitchen_dts NEQ dts>

    <cfquery name="qKitchenStaff" datasource="#dts#">
        SELECT kitchenID, name FROM kitchen ORDER BY name
    </cfquery>

    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Kitchen Dashboard</title>
        <link rel="stylesheet" href="/latest/css/bootstrap/bootstrap.min.css" />
        <style>
            body { margin:0; padding:0; background:#888; }
            .overlay {
                position:fixed; top:0; left:0; width:100%; height:100%;
                background:rgba(0,0,0,0.55);
                display:flex; align-items:center; justify-content:center;
                z-index:9999;
            }
            .chooser-box { background:#fff; width:440px; border-radius:4px; overflow:hidden; box-shadow:0 4px 24px rgba(0,0,0,.35); }
            .chooser-header { background:#c0392b; color:#fff; text-align:center; padding:16px; font-size:18px; font-weight:bold; }
            .chooser-body { padding:24px 28px 20px; }
            .chooser-body table { width:100%; }
            .chooser-body td { padding:8px 6px; vertical-align:middle; }
            .chooser-body td:first-child { white-space:nowrap; padding-right:14px; font-size:14px; }
            .chooser-body select, .chooser-body input[type=password] { width:100%; padding:6px 10px; border:1px solid #ccc; border-radius:3px; font-size:14px; }
            .chooser-footer { text-align:center; padding:0 28px 20px; }
            .btn-go { padding:7px 36px; background:#e8e8e8; border:1px solid #ccc; border-radius:3px; font-size:14px; cursor:pointer; }
            .btn-go:hover { background:#d4d4d4; }
            .error-msg { color:#c0392b; font-size:13px; text-align:center; margin-bottom:8px; }
            .no-staff-msg { color:#555; font-size:13px; text-align:center; margin-top:10px; }
        </style>
    </head>
    <body>
    <cfoutput>
    <div class="overlay">
        <div class="chooser-box">
            <div class="chooser-header">Choose Kitchen Staff</div>
            <form method="post" action="Orders.cfm">
            <div class="chooser-body">
                <cfif len(kitchenLoginError)><p class="error-msg">#kitchenLoginError#</p></cfif>
                <cfif qKitchenStaff.recordcount EQ 0>
                    <p class="no-staff-msg">No kitchen staff found.<br/>Go to Maintenance &rsaquo; Kitchen Profile to add staff.</p>
                <cfelse>
                    <table>
                        <tr>
                            <td>Staff :</td>
                            <td>
                                <select name="kitchen_id" required>
                                    <option value="">Choose Kitchen Staff</option>
                                    <cfloop query="qKitchenStaff">
                                        <option value="#kitchenID#">#kitchenID# - #name#</option>
                                    </cfloop>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>Password :</td>
                            <td><input type="password" name="kitchen_password" /></td>
                        </tr>
                    </table>
                </cfif>
            </div>
            <div class="chooser-footer">
                <input type="hidden" name="kitchen_login_submit" value="1" />
                <cfif qKitchenStaff.recordcount GT 0>
                    <button type="submit" class="btn-go">Go</button>
                </cfif>
            </div>
            </form>
        </div>
    </div>
    </cfoutput>
    </body>
    </html>
    <cfabort>
</cfif>

<cfset flashMsg = "">
<cfset flashErr = "">
<cfif structKeyExists(url,"msg") AND len(trim(url.msg))><cfset flashMsg = trim(url.msg)></cfif>
<cfif structKeyExists(url,"err") AND len(trim(url.err))><cfset flashErr = trim(url.err)></cfif>

<cfparam name="url.tab" default="all">
<cfset selectedTab = lCase(trim(url.tab))>
<cfif NOT listFindNoCase("all,pending,progress,ready", selectedTab)><cfset selectedTab = "all"></cfif>

<!--- ── POST actions ── --->
<cfif isDefined("form.form_action") AND len(trim(dts))>

    <cfif form.form_action eq "update_item" AND isNumeric(form.item_id)>
        <cfset allowed = "Pending,In Progress,Ready">
        <cfif listFindNoCase(allowed, form.new_status)>
            <cftry>
                <cfquery datasource="#dts#">
                    UPDATE app_order_items
                    SET    status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.new_status#">
                    <cfif form.new_status eq "Ready">, prepared_at = NOW()</cfif>
                    WHERE  item_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.item_id#">
                </cfquery>
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
                </cfif>
                <cfset flashMsg = "Updated.">
                <cfcatch type="any"><cfset flashErr = left(cfcatch.message,200)></cfcatch>
            </cftry>
        </cfif>
        <cflocation url="Orders.cfm?tab=#selectedTab#&msg=#URLEncodedFormat(flashMsg)#&err=#URLEncodedFormat(flashErr)#" addtoken="false">
    </cfif>

    <cfif form.form_action eq "mark_order_ready" AND isNumeric(form.order_id)>
        <cftry>
            <cfquery datasource="#dts#">
                UPDATE app_order_items SET status = 'Ready', prepared_at = NOW()
                WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.order_id#">
            </cfquery>
            <cfquery datasource="#dts#">
                UPDATE app_orders SET status = 'ready'
                WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.order_id#">
            </cfquery>
            <cfset flashMsg = "Order marked as Ready.">
            <cfcatch type="any"><cfset flashErr = left(cfcatch.message,200)></cfcatch>
        </cftry>
        <cflocation url="Orders.cfm?tab=#selectedTab#&msg=#URLEncodedFormat(flashMsg)#&err=#URLEncodedFormat(flashErr)#" addtoken="false">
    </cfif>
</cfif>

<!--- ── Load paid orders ── --->
<cfset pageError = "">
<cfset qOrders   = queryNew("order_id,order_number,table_number,total_amount,created_at")>
<cfset itemsByOrder = structNew()>

<cfif NOT isDefined("dts") OR NOT len(trim(dts))>
    <cfset pageError = "Database not configured.">
<cfelse>
<cftry>
    <cfquery name="qOrders" datasource="#dts#">
        SELECT o.order_id, o.order_number,
               COALESCE(t.table_number, '?') AS table_number,
               o.total_amount, o.created_at
        FROM   app_orders o
        LEFT JOIN app_tables t ON o.table_id = t.table_id
        WHERE  o.status IN ('paid','ready')
        ORDER  BY o.created_at ASC
    </cfquery>

    <cfif qOrders.recordCount gt 0>
        <cfquery name="qAllItems" datasource="#dts#">
            SELECT item_id, order_id, quantity,
                   status AS kitchen_status,
                   COALESCE(item_name, item_code) AS item_name
            FROM   app_order_items
            WHERE  order_id IN (SELECT order_id FROM app_orders WHERE status IN ('paid','ready'))
            ORDER  BY order_id ASC, item_id ASC
        </cfquery>
        <cfloop query="qAllItems">
            <cfset key = toString(qAllItems.order_id)>
            <cfif NOT structKeyExists(itemsByOrder, key)><cfset itemsByOrder[key] = []></cfif>
            <cfset arrayAppend(itemsByOrder[key], {
                "item_id"       : val(qAllItems.item_id),
                "item_name"     : trim(toString(qAllItems.item_name)),
                "quantity"      : val(qAllItems.quantity),
                "kitchen_status": trim(toString(qAllItems.kitchen_status))
            })>
        </cfloop>
    </cfif>
    <cfcatch type="any"><cfset pageError = left(cfcatch.message,300)></cfcatch>
</cftry>
</cfif>

<!--- ── Compute per-order kitchen state + summary counts ── --->
<cfset counts = {"all":0,"pending":0,"progress":0,"ready":0}>
<cfset rows   = []>

<cfloop query="qOrders">
    <cfset oid    = val(qOrders.order_id)>
    <cfset oItems = structKeyExists(itemsByOrder, toString(oid)) ? itemsByOrder[toString(oid)] : []>
    <cfset nTotal = arrayLen(oItems)>
    <cfset nReady = 0>
    <cfset nStarted = 0>
    <cfloop array="#oItems#" index="oi">
        <cfif lCase(trim(oi.kitchen_status)) eq "ready"><cfset nReady++></cfif>
        <cfif lCase(trim(oi.kitchen_status)) eq "in progress"><cfset nStarted++></cfif>
    </cfloop>
    <cfif nTotal eq 0 OR nReady eq nTotal>
        <cfset kState = "ready">
    <cfelseif nReady gt 0 OR nStarted gt 0>
        <cfset kState = "progress">
    <cfelse>
        <cfset kState = "pending">
    </cfif>
    <cfset counts["all"]++>
    <cfset counts[kState]++>
    <cfset includeThis = (selectedTab eq "all") OR (selectedTab eq kState)>
    <cfif includeThis>
        <cfset arrayAppend(rows, {
            "order_id"     : oid,
            "order_number" : trim(toString(qOrders.order_number)),
            "table_number" : trim(toString(qOrders.table_number)),
            "total_amount" : val(qOrders.total_amount),
            "created_at"   : qOrders.created_at,
            "items"        : oItems,
            "n_total"      : nTotal,
            "n_ready"      : nReady,
            "k_state"      : kState
        })>
    </cfif>
</cfloop>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Kitchen Dashboard</title>
<link rel="stylesheet" href="/latest/css/bootstrap/bootstrap.min.css">
<style>
body { font-family:"Segoe UI",Arial,sans-serif; background:#f3f5f8; color:#1d2835; margin:0; padding:16px 12px 40px; }
.container { max-width:1280px; }
.page-head { display:flex; flex-wrap:wrap; align-items:flex-end; justify-content:space-between; gap:12px 16px; margin-bottom:14px; padding-bottom:10px; border-bottom:3px solid #f0606d; }
.page-title { margin:0; font-size:24px; font-weight:600; }
.page-sub { margin:4px 0 0; color:#6b7280; font-size:13px; }
.panel-soft { background:#fff; border:1px solid #e5e7eb; border-radius:8px; padding:16px; box-shadow:0 1px 3px rgba(0,0,0,.05); margin-bottom:14px; }
.summary-grid { display:grid; grid-template-columns:repeat(4,minmax(0,1fr)); gap:12px; }
.sum-card { border-radius:8px; padding:12px; border:1px solid #e4e7ec; background:#fff; }
.sum-card .label { display:block; font-size:12px; color:#6b7280; margin-bottom:4px; font-weight:600; text-transform:uppercase; letter-spacing:.02em; }
.sum-card .value { font-size:28px; font-weight:700; line-height:1; }
.sum-blue   { background:#eff6ff; border-color:#bfdbfe; }
.sum-amber  { background:#fffbeb; border-color:#fde68a; }
.sum-orange { background:#fff7ed; border-color:#fed7aa; }
.sum-green  { background:#ecfdf3; border-color:#c8edd8; }
.tabs-row { display:flex; flex-wrap:wrap; gap:8px; margin-bottom:10px; }
.tabs-row .btn .badge { margin-left:6px; }
.table-grid { display:grid; grid-template-columns:repeat(4,minmax(0,1fr)); gap:12px; }
.tbl-card { border:1px solid #e5e7eb; border-radius:10px; background:#fff; padding:12px; box-shadow:0 1px 2px rgba(0,0,0,.04); }
.tbl-card.k-pending  { background:#fff; border-color:#e5e7eb; }
.tbl-card.k-progress { background:#fff7ed; border-color:#fdba74; }
.tbl-card.k-ready    { background:#f0fdf4; border-color:#bbf7d0; }
.tbl-top { display:flex; align-items:flex-start; justify-content:space-between; gap:8px; margin-bottom:8px; }
.tbl-title { margin:0; font-size:22px; font-weight:700; line-height:1.1; }
.tbl-sub { color:#6b7280; font-size:12px; margin-top:4px; }
.status-chip { display:inline-block; font-size:11px; font-weight:700; padding:2px 8px; border-radius:999px; border:1px solid transparent; }
.chip-pending  { background:#f3f4f6; color:#374151; border-color:#d1d5db; }
.chip-progress { background:#ffedd5; color:#9a3412; border-color:#fdba74; }
.chip-ready    { background:#dcfce7; color:#166534; border-color:#86efac; }
.tbl-row { display:flex; align-items:center; justify-content:space-between; margin:5px 0; font-size:13px; }
.tbl-actions { margin-top:10px; padding-top:10px; border-top:1px solid #e5e7eb; }
.item-block { padding:7px 0; border-bottom:1px solid #f3f4f6; }
.item-block:last-child { border-bottom:none; }
.item-name { font-size:13px; font-weight:600; }
.item-qty  { font-size:11px; color:#9ca3af; }
.item-btns { display:flex; gap:4px; margin-top:5px; }
.ks-btn { font-size:11px; padding:3px 9px; border-radius:6px; border:1px solid; cursor:pointer; font-weight:600; background:#fff; }
.ks-pending  { color:#6b7280; border-color:#d1d5db; }
.ks-progress { color:#92400e; border-color:#fcd34d; background:#fef3c7; }
.ks-ready    { color:#15803d; border-color:#86efac; background:#dcfce7; }
.ks-btn.active { box-shadow:0 0 0 2px currentColor; }
.btn-ready-all { width:100%; margin-top:8px; }
.empty-state { text-align:center; color:#6b7280; padding:34px 8px; border:1px dashed #d1d5db; border-radius:8px; background:#fff; }
@media (max-width:1199px) { .table-grid { grid-template-columns:repeat(3,minmax(0,1fr)); } }
@media (max-width:991px)  { .summary-grid { grid-template-columns:repeat(2,minmax(0,1fr)); } .table-grid { grid-template-columns:repeat(2,minmax(0,1fr)); } }
@media (max-width:640px)  { .summary-grid, .table-grid { grid-template-columns:1fr; } }
</style>
</head>
<body>
<cfoutput>
<div class="container">

    <div class="page-head">
        <div>
            <h1 class="page-title">Kitchen Dashboard</h1>
            <p class="page-sub">Paid orders ready to prepare — update item status as you cook.</p>
        </div>
        <div>
            <a href="/Waiter/WaiterDashboard.cfm" class="btn btn-default btn-sm">Waiter Dashboard</a>
        </div>
    </div>

    <cfif len(flashMsg)><div class="alert alert-success">#HTMLEditFormat(flashMsg)#</div></cfif>
    <cfif len(flashErr)><div class="alert alert-danger">#HTMLEditFormat(flashErr)#</div></cfif>
    <cfif len(pageError)><div class="alert alert-warning">#HTMLEditFormat(pageError)#</div></cfif>

    <div class="panel-soft">
        <div class="summary-grid">
            <div class="sum-card sum-blue">
                <span class="label">Total Paid</span>
                <div class="value">#counts["all"]#</div>
            </div>
            <div class="sum-card sum-amber">
                <span class="label">Pending</span>
                <div class="value">#counts["pending"]#</div>
            </div>
            <div class="sum-card sum-orange">
                <span class="label">In Progress</span>
                <div class="value">#counts["progress"]#</div>
            </div>
            <div class="sum-card sum-green">
                <span class="label">All Ready</span>
                <div class="value">#counts["ready"]#</div>
            </div>
        </div>
    </div>

    <div class="panel-soft">
        <div class="tabs-row">
            <a class="btn #(selectedTab eq 'all'     ? 'btn-primary' : 'btn-default')# btn-sm" href="Orders.cfm?tab=all">All <span class="badge">#counts["all"]#</span></a>
            <a class="btn #(selectedTab eq 'pending'  ? 'btn-primary' : 'btn-default')# btn-sm" href="Orders.cfm?tab=pending">Pending <span class="badge">#counts["pending"]#</span></a>
            <a class="btn #(selectedTab eq 'progress' ? 'btn-warning' : 'btn-default')# btn-sm" href="Orders.cfm?tab=progress">In Progress <span class="badge">#counts["progress"]#</span></a>
            <a class="btn #(selectedTab eq 'ready'    ? 'btn-success' : 'btn-default')# btn-sm" href="Orders.cfm?tab=ready">Ready <span class="badge">#counts["ready"]#</span></a>
        </div>

        <cfif arrayLen(rows) eq 0>
            <div class="empty-state">
                <cfif counts["all"] eq 0>
                    No paid orders waiting for the kitchen.
                <cfelse>
                    No orders match this filter.
                </cfif>
            </div>
        <cfelse>
            <div class="table-grid">
            <cfloop array="#rows#" index="r">
                <div class="tbl-card k-#r.k_state#">
                    <div class="tbl-top">
                        <div>
                            <h3 class="tbl-title">Table #HTMLEditFormat(r.table_number)#</h3>
                            <div class="tbl-sub">#timeFormat(r.created_at,'HH:mm')#</div>
                        </div>
                        <cfif r.k_state eq "ready">
                            <span class="status-chip chip-ready">All Ready</span>
                        <cfelseif r.k_state eq "progress">
                            <span class="status-chip chip-progress">In Progress</span>
                        <cfelse>
                            <span class="status-chip chip-pending">Pending</span>
                        </cfif>
                    </div>

                    <div class="tbl-row">
                        <span>Order</span>
                        <span style="font-size:11px;color:##6b7280;">&##&nbsp;#HTMLEditFormat(r.order_number)#</span>
                    </div>
                    <div class="tbl-row">
                        <span>Total</span>
                        <span><strong>Rp #numberFormat(r.total_amount,'9,990')#</strong></span>
                    </div>
                    <div class="tbl-row">
                        <span>Progress</span>
                        <span>#r.n_ready# / #r.n_total# ready</span>
                    </div>

                    <div class="tbl-actions">
                        <cfloop array="#r.items#" index="oi">
                            <cfset ks = lCase(trim(oi.kitchen_status))>
                            <div class="item-block">
                                <div class="item-name">#HTMLEditFormat(oi.item_name)#</div>
                                <div class="item-qty">x#oi.quantity#</div>
                                <div class="item-btns">
                                    <form method="post" action="Orders.cfm" style="display:inline">
                                        <input type="hidden" name="form_action" value="update_item">
                                        <input type="hidden" name="item_id"    value="#oi.item_id#">
                                        <input type="hidden" name="order_id"   value="#r.order_id#">
                                        <input type="hidden" name="new_status" value="Pending">
                                        <button type="submit" class="ks-btn ks-pending#(ks eq 'pending' ? ' active' : '')#">Pending</button>
                                    </form>
                                    <form method="post" action="Orders.cfm" style="display:inline">
                                        <input type="hidden" name="form_action" value="update_item">
                                        <input type="hidden" name="item_id"    value="#oi.item_id#">
                                        <input type="hidden" name="order_id"   value="#r.order_id#">
                                        <input type="hidden" name="new_status" value="In Progress">
                                        <button type="submit" class="ks-btn ks-progress#(ks eq 'in progress' ? ' active' : '')#">Preparing</button>
                                    </form>
                                    <form method="post" action="Orders.cfm" style="display:inline">
                                        <input type="hidden" name="form_action" value="update_item">
                                        <input type="hidden" name="item_id"    value="#oi.item_id#">
                                        <input type="hidden" name="order_id"   value="#r.order_id#">
                                        <input type="hidden" name="new_status" value="Ready">
                                        <button type="submit" class="ks-btn ks-ready#(ks eq 'ready' ? ' active' : '')#">Ready</button>
                                    </form>
                                </div>
                            </div>
                        </cfloop>

                        <cfif r.k_state neq "ready">
                        <form method="post" action="Orders.cfm">
                            <input type="hidden" name="form_action" value="mark_order_ready">
                            <input type="hidden" name="order_id"   value="#r.order_id#">
                            <button type="submit" class="btn btn-success btn-sm btn-ready-all">Mark All Ready</button>
                        </form>
                        </cfif>
                    </div>
                </div>
            </cfloop>
            </div>
        </cfif>
    </div>

</div>
</cfoutput>
<script src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
<script src="/latest/js/bootstrap/bootstrap.min.js"></script>
</body>
</html>
