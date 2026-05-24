<!---
    /latest/customer/my_orders.cfm
    Lists orders the current guest OR loyalty diner may view at this table.
    Guest: only order_ids accumulated in SESSION.emenu_guest_order_ids (privacy).
    Loyalty: custno matches + same table_id as current QR session.
--->
<cfinclude template="../../application.cfm">

<cfif NOT len(trim(SESSION.emenu_table_id))>
    <cflocation url="/latest/customer/qr_error.cfm" addtoken="false">
</cfif>

<cfset isGuest   = SESSION.emenu_is_guest eq "Yes">
<cfset isLoyalty = SESSION.emenu_loggedin eq "Yes" AND len(trim(SESSION.emenu_custno))>
<cfif NOT isGuest AND NOT isLoyalty>
    <cflocation url="/latest/customer/account_choice.cfm" addtoken="false">
</cfif>

<cfset tableDisplay = len(trim(SESSION.emenu_table_name)) ? SESSION.emenu_table_name : "Table " & SESSION.emenu_table_number>
<cfset qOrders    = queryNew("order_id,order_number,status,total_amount,created_at")>

<cftry>
    <cfif isLoyalty>
        <cfquery name="qOrders" datasource="#dts#">
            SELECT order_id, order_number, status, total_amount, created_at
            FROM   app_orders
            WHERE  custno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(SESSION.emenu_custno)#">
            AND    table_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(SESSION.emenu_table_id)#">
            ORDER  BY created_at DESC
            LIMIT  40
        </cfquery>
    <cfelseif isGuest AND len(trim(SESSION.emenu_guest_order_ids))>
        <!--- sanitize to integers only --->
        <cfset safeIds = "">
        <cfloop list="#SESSION.emenu_guest_order_ids#" index="tid">
            <cfset nid = val(trim(tid))>
            <cfif nid gt 0>
                <cfset safeIds = len(safeIds) ? listAppend(safeIds, nid) : toString(nid)>
            </cfif>
        </cfloop>
        <cfif len(safeIds)>
            <cfquery name="qOrders" datasource="#dts#">
                SELECT order_id, order_number, status, total_amount, created_at
                FROM   app_orders
                WHERE  order_id IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#safeIds#" list="true">)
                AND    (custno IS NULL OR TRIM(IFNULL(custno,'')) = '')
                AND    table_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(SESSION.emenu_table_id)#">
                ORDER  BY created_at DESC
            </cfquery>
        </cfif>
    </cfif>
    <cfcatch type="any">
        <cfset qOrders = queryNew("order_id,order_number,status,total_amount,created_at")>
    </cfcatch>
</cftry>

<!DOCTYPE html>
<html lang="en" class="emenu-customer">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, viewport-fit=cover">
    <title>My Orders</title>
    <cfinclude template="inc_bootstrap_head.cfm">
    <link rel="stylesheet" href="/latest/customer/customer-emenu-fullbleed.css">
    <style>
        body.customer-emenu.my-orders-page { font-family: "Segoe UI", Arial, sans-serif; background: ##f3f4f6; min-height: 100vh; }
        .mo-header {
            background: linear-gradient(135deg, ##F54900 0%, ##D04000 100%);
            color: ##fff; padding: 16px 16px 20px; width: 100%; box-sizing: border-box;
        }
        .mo-header-top { display: flex; align-items: center; justify-content: space-between; gap: 10px; margin-bottom: 8px; }
        .mo-back { color: ##fff !important; text-decoration: none !important; font-size: 14px; font-weight: 600;
                   display: inline-flex; align-items: center; gap: 6px; opacity: .95; flex-shrink: 0; }
        .mo-back:hover { opacity: 1; color: ##fff !important; }
        .mo-title { font-size: 20px; font-weight: 800; margin: 0 0 4px; text-align: center; flex: 1; min-width: 0; }
        .mo-sub { font-size: 13px; opacity: .9; margin: 0; text-align: center; }
        .mo-body { padding: 14px 12px 32px; max-width: 100%; box-sizing: border-box; }
        .mo-hint {
            font-size: 12px; color: ##92400e; background: ##fffbeb; border: 1px solid ##fde68a;
            border-radius: 12px; padding: 10px 12px; margin-bottom: 14px;
        }
        .mo-card {
            background: ##fff; border-radius: 16px; padding: 14px 14px;
            margin-bottom: 12px; box-shadow: 0 2px 8px rgba(0,0,0,.06); border: 1px solid ##f0f0f0;
            box-sizing: border-box; width: 100%; max-width: 100%; overflow: hidden;
        }
        .mo-card-top { display: flex; align-items: flex-start; justify-content: space-between; gap: 10px; margin-bottom: 8px; }
        .mo-ord-num { font-size: 13px; color: ##9ca3af; }
        .mo-ord-val { font-size: 16px; font-weight: 800; color: ##111; word-break: break-all; }
        .mo-meta { font-size: 12px; color: ##6b7280; margin-top: 2px; }
        .mo-stat-pill {
            font-size: 11px; font-weight: 700; padding: 4px 10px; border-radius: 999px;
            white-space: nowrap; flex-shrink: 0;
        }
        .st-open { background: ##fef3c7; color: ##92400e; }
        .st-done { background: ##dcfce7; color: ##15803d; }
        .st-clsd { background: ##f3f4f6; color: ##6b7280; }
        .mo-amt { font-size: 15px; font-weight: 700; color: ##F54900; margin: 10px 0; }
        .mo-btn {
            display: block; width: 100%; text-align: center; padding: 12px;
            border-radius: 12px; background: ##F54900; color: ##fff !important;
            font-size: 14px; font-weight: 700; text-decoration: none !important;
            box-sizing: border-box;
        }
        .mo-empty { text-align: center; padding: 40px 20px; color: ##9ca3af; font-size: 15px; }
    </style>
</head>
<body class="customer-emenu emenu-fullbleed my-orders-page">

<div class="emenu-shell">

<div class="mo-header">
    <div class="mo-header-top">
        <a href="/latest/customer/menu.cfm" class="mo-back">
            <svg width="18" height="18" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7"/>
            </svg>
            Menu
        </a>
        <h1 class="mo-title">My Orders</h1>
        <div style="width:52px;"></div>
    </div>
    <p class="mo-sub"><cfoutput>#HTMLEditFormat(tableDisplay)#</cfoutput></p>
</div>

<div class="mo-body">

<cfif isGuest>
<div class="mo-hint">
    As a guest, only orders placed on this phone at this table are listed. Clear your browser session or scanning a new QR clears the list.
</div>
</cfif>

<cfif qOrders.recordCount eq 0>
    <div class="mo-empty">No orders to show yet.<br><br>
        <a href="/latest/customer/menu.cfm" class="mo-btn" style="max-width:280px;margin:0 auto;">Browse menu</a>
    </div>
<cfelse>
    <cfoutput query="qOrders">
        <cfset st = lCase(trim(qOrders.status))>
        <cfif listFindNoCase("paid,cancelled,completed", st)>
            <cfset pillClass = "st-clsd"><cfset pillTxt = "Completed">
        <cfelseif st eq "ready">
            <cfset pillClass = "st-done"><cfset pillTxt = "Ready">
        <cfelse>
            <cfset pillClass = "st-open"><cfset pillTxt = "In progress">
        </cfif>
        <div class="mo-card">
            <div class="mo-card-top">
                <div style="min-width:0;">
                    <div class="mo-ord-num">Order</div>
                    <div class="mo-ord-val">#HTMLEditFormat(qOrders.order_number)#</div>
                    <div class="mo-meta">#dateFormat(qOrders.created_at,'dd mmm yyyy')# &bull; #timeFormat(qOrders.created_at,'HH:mm')#</div>
                </div>
                <span class="mo-stat-pill #pillClass#">#pillTxt#</span>
            </div>
            <div class="mo-amt">RM #numberFormat(val(qOrders.total_amount),'9,990.00')#</div>
            <a class="mo-btn" href="/latest/customer/open_order.cfm?order_id=#val(qOrders.order_id)#">View items &amp; status</a>
        </div>
    </cfoutput>
</cfif>

</div>

</div><!--- shell --->

</body>
</html>
