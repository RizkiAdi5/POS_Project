<cfprocessingdirective pageencoding="UTF-8">
<cfinclude template="../application.cfm">
<cfinclude template="../customer/inc_emenu_order.cfm">
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

<!--- ── Handle kitchen login POST ── --->
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

<!--- ── Show login page if not authenticated ── --->
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
                position: fixed; top:0; left:0; width:100%; height:100%;
                background: rgba(0,0,0,0.55);
                display: flex; align-items: center; justify-content: center;
                z-index: 9999;
            }
            .chooser-box {
                background: #fff;
                width: 440px;
                border-radius: 4px;
                overflow: hidden;
                box-shadow: 0 4px 24px rgba(0,0,0,.35);
            }
            .chooser-header {
                background: #c0392b;
                color: #fff;
                text-align: center;
                padding: 16px;
                font-size: 18px;
                font-weight: bold;
            }
            .chooser-body { padding: 24px 28px 20px; }
            .chooser-body table { width: 100%; }
            .chooser-body td { padding: 8px 6px; vertical-align: middle; }
            .chooser-body td:first-child { white-space: nowrap; padding-right: 14px; font-size: 14px; }
            .chooser-body select, .chooser-body input[type=password] {
                width: 100%; padding: 6px 10px; border: 1px solid #ccc;
                border-radius: 3px; font-size: 14px;
            }
            .chooser-footer { text-align: center; padding: 0 28px 20px; }
            .chooser-footer .btn-go {
                padding: 7px 36px; background: #e8e8e8;
                border: 1px solid #ccc; border-radius: 3px;
                font-size: 14px; cursor: pointer;
            }
            .chooser-footer .btn-go:hover { background: #d4d4d4; }
            .error-msg { color: #c0392b; font-size: 13px; text-align: center; margin-bottom: 8px; }
            .no-staff { color: #888; text-align: center; padding: 10px 0 4px; font-size: 14px; }
        </style>
    </head>
    <body>
    <cfoutput>
    <div class="overlay">
        <div class="chooser-box">
            <div class="chooser-header">Choose Kitchen Staff</div>
            <cfif qKitchenStaff.recordcount EQ 0>
                <div class="chooser-body">
                    <p class="no-staff">No kitchen profiles set up yet.<br/>
                       Go to <strong>Maintenance &rarr; Kitchen Profile</strong> to add staff.</p>
                </div>
            <cfelse>
            <form method="post" action="Orders.cfm">
            <div class="chooser-body">
                <cfif len(kitchenLoginError)>
                    <p class="error-msg">#kitchenLoginError#</p>
                </cfif>
                <table>
                    <tr>
                        <td>Kitchen Staff :</td>
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
            </div>
            <div class="chooser-footer">
                <input type="hidden" name="kitchen_login_submit" value="1" />
                <button type="submit" class="btn-go">Go</button>
            </div>
            </form>
            </cfif>
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

<!--- ── POST actions ── --->
<cfif isDefined("form.form_action") AND len(trim(dts))>

    <!--- Update single item kitchen status --->
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

                <!--- Deduct recipe raw materials once prep starts (idempotent: guarded by
                      app_order_items.materials_deducted, so re-clicking never double-deducts). --->
                <cfif listFindNoCase("In Progress,Ready", form.new_status)>
                    <cfset emenuDeductMaterialsForOrderItem(dts, val(form.item_id))>
                </cfif>

                <!--- Promote order to 'ready' only when all items are Ready --->
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

                <cfset flashMsg = "Updated to #form.new_status#.">
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

            <!--- Deduct recipe raw materials for any item that skipped "In Progress"
                  (idempotent: guarded by app_order_items.materials_deducted). --->
            <cfquery name="qReadyItems" datasource="#dts#">
                SELECT item_id FROM app_order_items
                WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.order_id#">
            </cfquery>
            <cfloop query="qReadyItems">
                <cfset emenuDeductMaterialsForOrderItem(dts, val(qReadyItems.item_id))>
            </cfloop>

            <cfset flashMsg = "Order marked as Ready.">
            <cfcatch type="any">
                <cfset flashErr = "Update failed: " & left(cfcatch.message,200)>
            </cfcatch>
        </cftry>
        <cflocation url="Orders.cfm?msg=#URLEncodedFormat(flashMsg)#&err=#URLEncodedFormat(flashErr)#" addtoken="false">
    </cfif>
</cfif>

<!--- ── Load paid orders awaiting kitchen preparation ── --->
<cfset pageError = "">
<cfset qOrders   = queryNew("order_id,order_number,table_number,custno,status,total_amount,created_at")>
<cfset qAllItems = queryNew("item_id,order_id,quantity,kitchen_status,item_name")>
<cfset itemsByOrder = structNew()>

<cfif NOT isDefined("dts") OR NOT len(trim(dts))>
    <cfset pageError = "Database not configured. Log in via the staff menu.">
<cfelse>
<cftry>
    <cfquery name="qOrders" datasource="#dts#">
        SELECT o.order_id, o.order_number, o.table_id,
               COALESCE(t.table_number, '') AS table_number,
               o.custno, o.status, o.total_amount, o.created_at
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
            WHERE  order_id IN (
                SELECT order_id FROM app_orders WHERE status IN ('paid','ready')
            )
            ORDER  BY order_id ASC, item_id ASC
        </cfquery>

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
    </cfif>

    <cfcatch type="any">
        <cfset pageError = "Query failed: " & left(cfcatch.message,300)>
    </cfcatch>
</cftry>
</cfif>

<!--- Group by table so two paid orders on the same table (e.g. an e-menu order plus a
      Waiter POS top-up) show as ONE card with two clearly labelled sub-orders, instead of
      two near-identical "Table N" buttons that are easy to mix up. Takeaway orders have no
      table, so each stays its own group. --->
<cfset groupsByKey = structNew()>
<cfset groupKeyOrder = []>
<cfloop query="qOrders">
    <cfset gTableId = val(qOrders.table_id)>
    <cfset gKey = (gTableId gt 0) ? ("t" & gTableId) : ("o" & val(qOrders.order_id))>
    <cfif NOT structKeyExists(groupsByKey, gKey)>
        <cfset groupsByKey[gKey] = {
            "table_number" = trim(toString(qOrders.table_number)),
            "is_takeaway" = (gTableId lte 0),
            "orders" = []
        }>
        <cfset arrayAppend(groupKeyOrder, gKey)>
    </cfif>

    <cfset goid    = val(qOrders.order_id)>
    <cfset gokey   = toString(goid)>
    <cfset goItems = structKeyExists(itemsByOrder, gokey) ? itemsByOrder[gokey] : []>
    <cfset gReady  = 0>
    <cfloop array="#goItems#" index="gi">
        <cfif lCase(trim(gi.kitchen_status)) eq "ready"><cfset gReady = gReady + 1></cfif>
    </cfloop>
    <cfset gAllReady = (arrayLen(goItems) gt 0) AND (gReady eq arrayLen(goItems))>
    <cfset gOrderNum = trim(toString(qOrders.order_number))>
    <cfset gSourceTag = "">
    <cfif left(uCase(gOrderNum), 2) eq "W-">
        <cfset gSourceTag = "waiter">
    <cfelseif left(uCase(gOrderNum), 2) eq "E-">
        <cfset gSourceTag = "emenu">
    </cfif>

    <cfset arrayAppend(groupsByKey[gKey].orders, {
        "order_id" = goid,
        "order_number" = gOrderNum,
        "items" = goItems,
        "item_count" = arrayLen(goItems),
        "ready_count" = gReady,
        "all_ready" = gAllReady,
        "source_tag" = gSourceTag
    })>
</cfloop>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Kitchen Dashboard</title>
<link rel="stylesheet" href="/latest/css/bootstrap/bootstrap.min.css">
<style>
body{background:#f5f7fb;font-family:'Segoe UI',Arial,sans-serif;padding:20px 16px 60px;}
.page-head{display:flex;align-items:center;justify-content:space-between;
           margin-bottom:20px;padding-bottom:12px;border-bottom:3px solid #F54900;}
.page-title{font-size:22px;font-weight:700;margin:0;}

/* Horizontal table button row */
.table-row{display:flex;flex-wrap:wrap;gap:10px;margin-bottom:20px;}
.table-btn{display:flex;flex-direction:column;align-items:center;justify-content:center;
           min-width:90px;padding:12px 16px;border-radius:10px;border:2px solid #e5e7eb;
           background:#fff;cursor:pointer;font-weight:700;font-size:14px;
           color:#374151;transition:all .15s;line-height:1.3;}
.table-btn:hover{border-color:#F54900;color:#F54900;}
.table-btn.active{border-color:#F54900;background:#fff3ee;color:#F54900;}
.table-btn .item-count{font-size:11px;font-weight:600;background:#F54900;color:#fff;
                        border-radius:20px;padding:1px 8px;margin-top:4px;}
.table-btn-ordno{font-size:9.5px;font-weight:600;color:#9ca3af;margin-top:2px;
                  max-width:110px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
.table-btn.all-ready .item-count{background:#15803d;}
.table-btn.all-ready{border-color:#86efac;color:#15803d;}
.table-btn.multi-order{border-color:#93c5fd;}
.table-btn .multi-badge{font-size:10px;font-weight:700;background:#2563EB;color:#fff;
                         border-radius:20px;padding:1px 7px;margin-top:3px;}

/* Detail panel — one per table, holding one sub-block per order at that table */
.order-detail{background:#fff;border:1px solid #e5e7eb;border-radius:12px;
              margin-bottom:12px;box-shadow:0 1px 4px rgba(0,0,0,.06);}
.order-detail.all-ready{border-color:#86efac;background:#f0fdf4;}
.order-sub{border-bottom:1px solid #f0f0f0;}
.order-sub:last-child{border-bottom:none;}
.detail-head{padding:14px 16px;border-bottom:1px solid #f0f0f0;
             display:flex;align-items:center;justify-content:space-between;gap:8px;}
.detail-order-num{font-size:14px;font-weight:700;color:#111;}
.detail-meta{font-size:12px;color:#9ca3af;margin-top:2px;}
.status-chip{display:inline-block;font-size:11px;font-weight:700;
             padding:3px 10px;border-radius:20px;}
.chip-paid   {background:#dbeafe;color:#1d4ed8;}
.chip-ready  {background:#dcfce7;color:#15803d;}
.src-tag{display:inline-block;font-size:10px;font-weight:800;letter-spacing:.02em;
         text-transform:uppercase;padding:2px 8px;border-radius:20px;margin-left:6px;}
.src-emenu{background:#dbeafe;color:#1e3a8a;}
.src-waiter{background:#ffedd5;color:#9a3412;}
.detail-body{padding:12px 16px;}

.item-row{display:flex;align-items:center;justify-content:space-between;
          padding:9px 0;border-bottom:1px solid #f9fafb;}
.item-row:last-child{border-bottom:none;}
.item-name{font-size:14px;font-weight:600;color:#111;}
.item-qty {font-size:12px;color:#9ca3af;}
.item-actions{display:flex;gap:5px;}
.btn-status{font-size:12px;padding:5px 10px;border-radius:8px;border:1px solid;
            cursor:pointer;font-weight:600;background:#fff;}
.btn-pending {color:#6b7280;border-color:#d1d5db;}
.btn-progress{color:#92400e;border-color:#fcd34d;background:#fef3c7;}
.btn-ready-item{color:#15803d;border-color:#86efac;background:#dcfce7;}
.btn-status.active{box-shadow:0 0 0 2px currentColor;font-weight:800;}
.btn-ready-all{width:100%;margin-top:10px;}
.empty{text-align:center;padding:60px;color:#9ca3af;font-size:15px;}
</style>
</head>
<body>
<cfoutput>
<div class="page-head">
    <div>
        <h1 class="page-title">Kitchen Dashboard</h1>
        <p style="margin:0;font-size:12px;color:##9ca3af;">Showing paid orders ready to prepare</p>
    </div>
    <div style="display:flex;align-items:center;gap:8px;">
        <span style="font-size:13px;color:##6b7280;">
            <cfoutput>#HTMLEditFormat(SESSION.kitchen_name)#</cfoutput>
        </span>
        <a href="Orders.cfm" class="btn btn-default btn-sm">&##8635; Refresh</a>
        <a href="WaiterDashboard.cfm" class="btn btn-default btn-sm">Dashboard</a>
        <a href="Orders.cfm?kitchen_logout=1" class="btn btn-default btn-sm">Sign Out</a>
    </div>
</div>

<cfif len(flashMsg)><div class="alert alert-success">#HTMLEditFormat(flashMsg)#</div></cfif>
<cfif len(flashErr)><div class="alert alert-danger">#HTMLEditFormat(flashErr)#</div></cfif>
<cfif len(pageError)><div class="alert alert-warning">#HTMLEditFormat(pageError)#</div></cfif>

<cfif NOT len(pageError)>
<cfif qOrders.recordCount eq 0>
    <div class="empty">No paid orders waiting for the kitchen.</div>
<cfelse>

    <!--- ── Horizontal table buttons — one per TABLE (not per order), so two paid
          orders on the same table don't show up as two confusingly-identical buttons ── --->
    <div class="table-row">
    <cfloop array="#groupKeyOrder#" index="gk">
        <cfset grp = groupsByKey[gk]>
        <cfset grpTotal = 0>
        <cfset grpReady = 0>
        <cfset grpAllReady = true>
        <cfloop array="#grp.orders#" index="go">
            <cfset grpTotal = grpTotal + go.item_count>
            <cfset grpReady = grpReady + go.ready_count>
            <cfif NOT go.all_ready><cfset grpAllReady = false></cfif>
        </cfloop>
        <cfset grpMulti = arrayLen(grp.orders) gt 1>
        <button class="table-btn#(grpAllReady ? ' all-ready' : '')##(grpMulti ? ' multi-order' : '')#"
                data-toggle="collapse" data-target="##grp-#gk#"
                onclick="setActive(this)">
            <cfif grp.is_takeaway>Take Away<cfelse>Table #HTMLEditFormat(grp.table_number)#</cfif>
            <cfif grpMulti>
                <div class="table-btn-ordno">#arrayLen(grp.orders)# orders</div>
                <span class="multi-badge">#grpReady#/#grpTotal# ready</span>
            <cfelse>
                <div class="table-btn-ordno">#HTMLEditFormat(grp.orders[1].order_number)#</div>
                <span class="item-count">#grpReady#/#grpTotal# ready</span>
            </cfif>
        </button>
    </cfloop>
    </div>

    <!--- ── Collapse detail panels — one per table, one sub-block per order in it ── --->
    <cfloop array="#groupKeyOrder#" index="gk">
        <cfset grp = groupsByKey[gk]>
        <cfset grpAllReady2 = true>
        <cfloop array="#grp.orders#" index="goc"><cfif NOT goc.all_ready><cfset grpAllReady2 = false></cfif></cfloop>

        <div id="grp-#gk#" class="collapse order-detail#(grpAllReady2 ? ' all-ready' : '')#">
            <cfloop array="#grp.orders#" index="ord">
                <div class="order-sub">
                    <div class="detail-head">
                        <div>
                            <div class="detail-order-num">
                                <cfif grp.is_takeaway>Take Away<cfelse>Table #HTMLEditFormat(grp.table_number)#</cfif>
                                &mdash; #HTMLEditFormat(ord.order_number)#
                                <cfif ord.source_tag eq "waiter"><span class="src-tag src-waiter">Waiter POS</span></cfif>
                                <cfif ord.source_tag eq "emenu"><span class="src-tag src-emenu">E-Menu</span></cfif>
                            </div>
                        </div>
                        <span class="status-chip #(ord.all_ready ? 'chip-ready' : 'chip-paid')#">
                            #(ord.all_ready ? 'All Ready' : 'Paid &mdash; Prepare Now')#
                        </span>
                    </div>

                    <div class="detail-body">
                        <cfloop array="#ord.items#" index="oi">
                            <cfset ks = lCase(trim(oi.kitchen_status))>
                            <div class="item-row">
                                <div>
                                    <div class="item-name">#HTMLEditFormat(oi.item_name)#</div>
                                    <div class="item-qty">x#oi.quantity#</div>
                                </div>
                                <div class="item-actions">
                                    <form method="post" action="Orders.cfm" style="display:inline;">
                                        <input type="hidden" name="form_action" value="update_item">
                                        <input type="hidden" name="item_id"    value="#oi.item_id#">
                                        <input type="hidden" name="order_id"   value="#ord.order_id#">
                                        <input type="hidden" name="new_status" value="Pending">
                                        <button type="submit" class="btn-status btn-pending#(ks eq 'pending' ? ' active' : '')#">Pending</button>
                                    </form>
                                    <form method="post" action="Orders.cfm" style="display:inline;">
                                        <input type="hidden" name="form_action" value="update_item">
                                        <input type="hidden" name="item_id"    value="#oi.item_id#">
                                        <input type="hidden" name="order_id"   value="#ord.order_id#">
                                        <input type="hidden" name="new_status" value="In Progress">
                                        <button type="submit" class="btn-status btn-progress#(ks eq 'in progress' ? ' active' : '')#">Preparing</button>
                                    </form>
                                    <form method="post" action="Orders.cfm" style="display:inline;">
                                        <input type="hidden" name="form_action" value="update_item">
                                        <input type="hidden" name="item_id"    value="#oi.item_id#">
                                        <input type="hidden" name="order_id"   value="#ord.order_id#">
                                        <input type="hidden" name="new_status" value="Ready">
                                        <button type="submit" class="btn-status btn-ready-item#(ks eq 'ready' ? ' active' : '')#">Ready</button>
                                    </form>
                                </div>
                            </div>
                        </cfloop>

                        <cfif NOT ord.all_ready>
                        <form method="post" action="Orders.cfm">
                            <input type="hidden" name="form_action" value="mark_order_ready">
                            <input type="hidden" name="order_id"   value="#ord.order_id#">
                            <button type="submit" class="btn btn-success btn-sm btn-ready-all">
                                Mark All Ready &mdash; #HTMLEditFormat(ord.order_number)#
                            </button>
                        </form>
                        </cfif>
                    </div>
                </div>
            </cfloop>
        </div>
    </cfloop>

</cfif>
</cfif>
</cfoutput>

<script src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
<script src="/latest/js/bootstrap/bootstrap.min.js"></script>
<script>
function setActive(btn) {
    document.querySelectorAll('.table-btn').forEach(function(b){ b.classList.remove('active'); });
    btn.classList.add('active');
}
/* Open first panel by default if only one order */
$(function(){
    var panels = $('.order-detail');
    if (panels.length === 1) panels.first().addClass('in');
});
</script>
</body>
</html>
