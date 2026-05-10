<cfprocessingdirective pageencoding="UTF-8">
<cfsetting enablecfoutputonly="false">
<cfsetting showdebugoutput="false">

<cffunction name="resolveDatasourceName" output="false" returntype="string">
    <cfset var resolved = "">
    <cfset var qUserDept = "">

    <!--- 1) Explicit request input (flexible override) --->
    <cfif structKeyExists(form, "dts") AND len(trim(toString(form.dts)))>
        <cfreturn trim(toString(form.dts))>
    </cfif>
    <cfif structKeyExists(url, "dts") AND len(trim(toString(url.dts)))>
        <cfreturn trim(toString(url.dts))>
    </cfif>

    <!--- 2) Existing runtime scopes --->
    <cfif isDefined("request.dts") AND len(trim(toString(request.dts)))>
        <cfreturn trim(toString(request.dts))>
    </cfif>
    <cfif isDefined("session.dts") AND len(trim(toString(session.dts)))>
        <cfreturn trim(toString(session.dts))>
    </cfif>
    <cfif isDefined("dts") AND len(trim(toString(dts)))>
        <cfreturn trim(toString(dts))>
    </cfif>

    <!--- 3) Resolve from user profile in main datasource --->
    <cfif len(trim(GetAuthUser()))>
        <cftry>
            <cfquery name="qUserDept" datasource="main">
                SELECT userdept
                FROM users
                WHERE userId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GetAuthUser()#">
            </cfquery>
            <cfif qUserDept.recordCount AND len(trim(qUserDept.userdept))>
                <cfset resolved = trim(qUserDept.userdept)>
            </cfif>
            <cfcatch type="any"><cfset resolved = ""></cfcatch>
        </cftry>
    </cfif>

    <cfreturn resolved>
</cffunction>

<cffunction name="hasTableColumn" output="false" returntype="boolean">
    <cfargument name="dsn" type="string" required="true">
    <cfargument name="tableName" type="string" required="true">
    <cfargument name="columnName" type="string" required="true">
    <cfset var qCol = "">
    <cftry>
        <cfquery name="qCol" datasource="#arguments.dsn#">
            SELECT COUNT(*) AS col_count
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tableName#">
              AND COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.columnName#">
        </cfquery>
        <cfreturn val(qCol.col_count) gt 0>
        <cfcatch type="any"><cfreturn false></cfcatch>
    </cftry>
</cffunction>

<cfset dts = resolveDatasourceName()>
<cfset hasQrToken = false>
<cfif len(trim(dts))>
    <cfset hasQrToken = hasTableColumn(dts, "app_tables", "qr_token")>
</cfif>

<cffunction name="esc" output="false" returntype="string">
    <cfargument name="v" required="false" default="">
    <cfset var s = "">
    <cfif NOT isNull(arguments.v)><cfset s = toString(arguments.v)></cfif>
    <cfreturn HTMLEditFormat(s)>
</cffunction>

<cffunction name="normTableStatus" output="false" returntype="string">
    <cfargument name="s" type="string" required="true">
    <cfset var x = lCase(trim(arguments.s))>
    <cfswitch expression="#x#">
        <cfcase value="available,free,open"><cfreturn "available"></cfcase>
        <cfcase value="reserved,booked"><cfreturn "reserved"></cfcase>
        <cfdefaultcase><cfreturn "occupied"></cfdefaultcase>
    </cfswitch>
</cffunction>

<cffunction name="dbTableStatus" output="false" returntype="string">
    <cfargument name="s" type="string" required="true">
    <cfset var x = lCase(trim(arguments.s))>
    <cfswitch expression="#x#">
        <cfcase value="available"><cfreturn "Available"></cfcase>
        <cfcase value="reserved"><cfreturn "Reserved"></cfcase>
        <cfdefaultcase><cfreturn "Occupied"></cfdefaultcase>
    </cfswitch>
</cffunction>

<cfparam name="url.tab" default="all">
<cfset selectedTab = lCase(trim(url.tab))>
<cfif NOT listFindNoCase("all,occupied,available,reserved,pending-cash", selectedTab)>
    <cfset selectedTab = "all">
</cfif>

<cfset flashMsg = "">
<cfset flashErr = "">
<cfif structKeyExists(url, "msg") AND len(trim(url.msg))><cfset flashMsg = trim(url.msg)></cfif>
<cfif structKeyExists(url, "err") AND len(trim(url.err))><cfset flashErr = trim(url.err)></cfif>

<cfif isDefined("form.form_action") AND len(trim(dts))>
    <cfset redirectTab = selectedTab>
    <cfif structKeyExists(form, "rt_tab") AND len(trim(form.rt_tab))>
        <cfset redirectTab = lCase(trim(form.rt_tab))>
    </cfif>
    <cfif NOT listFindNoCase("all,occupied,available,reserved,pending-cash", redirectTab)>
        <cfset redirectTab = "all">
    </cfif>

    <cfif form.form_action eq "add_table">
        <cfset tableNum = left(trim(toString(form.table_number)), 20)>
        <cfset seatsVal = int(val(form.seats))>
        <cfif NOT len(tableNum)>
            <cfset flashErr = "Table number is required.">
        <cfelseif seatsVal lte 0>
            <cfset flashErr = "Seats must be greater than zero.">
        <cfelse>
            <cftry>
                <cfquery name="qDupTable" datasource="#dts#">
                    SELECT COUNT(*) AS row_count FROM app_tables
                    WHERE table_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tableNum#">
                </cfquery>
                <cfif val(qDupTable.row_count) gt 0>
                    <cfset flashErr = "Table number already exists.">
                <cfelse>
                    <cfif hasQrToken>
                        <cfquery datasource="#dts#">
                            INSERT INTO app_tables (
                                table_number, seats, qr_token, status
                            ) VALUES (
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#tableNum#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#seatsVal#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(replace(createUUID(), "-", "", "all"), 100)#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="Available">
                            )
                        </cfquery>
                    <cfelse>
                        <cfquery datasource="#dts#">
                            INSERT INTO app_tables (
                                table_number, seats, status
                            ) VALUES (
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#tableNum#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#seatsVal#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="Available">
                            )
                        </cfquery>
                    </cfif>
                    <cfset flashMsg = "Table " & tableNum & " added.">
                </cfif>
                <cfcatch type="any">
                    <cfset flashErr = "Add table failed: " & left(trim(cfcatch.message & " " & toString(cfcatch.detail)), 300)>
                </cfcatch>
            </cftry>
        </cfif>
    </cfif>

    <cfif form.form_action eq "confirm_cash" AND isNumeric(form.order_id)>
        <cfset oid = val(form.order_id)>
        <cfif oid lte 0>
            <cfset flashErr = "Invalid order for cash confirmation.">
        <cfelse>
            <cftry>
                <cfquery datasource="#dts#">
                    UPDATE app_payments
                    SET status = <cfqueryparam cfsqltype="cf_sql_varchar" value="success">,
                        paid_at = NOW()
                    WHERE payment_id = (
                        SELECT MAX(payment_id)
                        FROM app_payments
                        WHERE order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#oid#">
                          AND payment_method = <cfqueryparam cfsqltype="cf_sql_varchar" value="cash">
                    )
                </cfquery>
                <cfset flashMsg = "Cash payment confirmed.">
                <cfcatch type="any">
                    <cfset flashErr = "Cash confirmation failed: " & left(trim(cfcatch.message & " " & toString(cfcatch.detail)), 300)>
                </cfcatch>
            </cftry>
        </cfif>
    </cfif>

    <cfif form.form_action eq "update_table_status" AND isNumeric(form.table_id)>
        <cfset tid = val(form.table_id)>
        <cfset wanted = lCase(trim(toString(form.new_status)))>
        <cfif NOT listFindNoCase("available,occupied,reserved", wanted)>
            <cfset flashErr = "Invalid status.">
        <cfelse>
            <cftry>
                <cfquery name="qTable" datasource="#dts#">
                    SELECT table_id, table_number
                    FROM app_tables
                    WHERE table_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tid#">
                </cfquery>

                <cfif qTable.recordCount eq 0>
                    <cfset flashErr = "Table not found.">
                <cfelse>
                    <cfquery name="qLatestOrder" datasource="#dts#">
                        SELECT MAX(order_id) AS order_id
                        FROM app_orders
                        WHERE table_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(toString(qTable.table_number))#">
                          AND status NOT IN ('completed','cancelled')
                    </cfquery>
                    <cfset latestOrderId = val(qLatestOrder.order_id)>
                    <cfset payMethod = "">
                    <cfset payStatus = "">
                    <cfif latestOrderId gt 0>
                        <cfquery name="qLatestPayment" datasource="#dts#">
                            SELECT payment_method, status
                            FROM app_payments
                            WHERE payment_id = (
                                SELECT MAX(payment_id)
                                FROM app_payments
                                WHERE order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#latestOrderId#">
                            )
                        </cfquery>
                        <cfif qLatestPayment.recordCount gt 0>
                            <cfset payMethod = lCase(trim(toString(qLatestPayment.payment_method)))>
                            <cfset payStatus = lCase(trim(toString(qLatestPayment.status)))>
                        </cfif>
                    </cfif>
                    <cfset hasActiveOrder = (latestOrderId gt 0)>
                    <cfset isPaid = ((payMethod eq "cash" OR payMethod eq "online") AND payStatus eq "success")>
                    <cfif wanted eq "available" AND hasActiveOrder AND NOT isPaid>
                        <cfset flashErr = "Cannot set table to Available while payment is unpaid or pending.">
                    <cfelse>
                        <cfquery datasource="#dts#">
                            UPDATE app_tables
                            SET status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dbTableStatus(wanted)#">
                            WHERE table_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tid#">
                        </cfquery>
                        <cfset flashMsg = "Table status updated.">
                    </cfif>
                </cfif>
                <cfcatch type="any">
                    <cfset flashErr = "Status update failed: " & left(trim(cfcatch.message & " " & toString(cfcatch.detail)), 300)>
                </cfcatch>
            </cftry>
        </cfif>
    </cfif>

    <cfif len(flashErr)>
        <cflocation url="Tables.cfm?tab=#URLEncodedFormat(redirectTab)#&err=#URLEncodedFormat(flashErr)#" addtoken="false">
    <cfelse>
        <cflocation url="Tables.cfm?tab=#URLEncodedFormat(redirectTab)#&msg=#URLEncodedFormat(flashMsg)#" addtoken="false">
    </cfif>
</cfif>

<cfset pageError = "">
<cfset queryTables = queryNew("table_id")>
<cfset queryOrders = queryNew("order_id")>
<cfset queryPayments = queryNew("payment_id")>
<cfset rows = []>
<cfset latestOrderByTable = structNew()>
<cfset latestPaymentByOrder = structNew()>
<cfset summaryCounts = {
    "all" = 0,
    "available" = 0,
    "occupied" = 0,
    "reserved" = 0,
    "pending-cash" = 0
}>

<cfif len(trim(dts))>
    <cftry>
        <cfquery name="queryTables" datasource="#dts#">
            SELECT t.table_id, t.table_number, t.seats, t.status AS table_status
            FROM app_tables t
            ORDER BY t.table_number ASC
        </cfquery>

        <cfquery name="queryOrders" datasource="#dts#">
            SELECT order_id, order_number, table_number, status, total_amount, created_at
            FROM app_orders
            WHERE status NOT IN ('completed','cancelled')
            ORDER BY table_number ASC, created_at DESC
        </cfquery>

        <cfloop query="queryOrders">
            <cfset tableNumberKey = trim(toString(queryOrders.table_number))>
            <cfif len(tableNumberKey) AND NOT structKeyExists(latestOrderByTable, tableNumberKey)>
                <cfset latestOrderByTable[tableNumberKey] = {
                    "order_id" = val(queryOrders.order_id),
                    "order_number" = trim(toString(queryOrders.order_number)),
                    "order_status" = lCase(trim(toString(queryOrders.status))),
                    "total_amount" = val(queryOrders.total_amount)
                }>
            </cfif>
        </cfloop>

        <cfset orderIdList = "">
        <cfloop collection="#latestOrderByTable#" item="tableKeyForOrderMap">
            <cfset mappedOrder = latestOrderByTable[tableKeyForOrderMap]>
            <cfif structKeyExists(mappedOrder, "order_id") AND val(mappedOrder.order_id) gt 0>
                <cfset orderIdList = listAppend(orderIdList, val(mappedOrder.order_id))>
            </cfif>
        </cfloop>

        <cfif len(orderIdList)>
            <cfquery name="queryPayments" datasource="#dts#">
                SELECT payment_id, order_id, payment_method, status
                FROM app_payments
                WHERE order_id IN (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#orderIdList#" list="true">
                )
                ORDER BY order_id ASC, payment_id DESC
            </cfquery>

            <cfloop query="queryPayments">
                <cfset orderKey = toString(val(queryPayments.order_id))>
                <cfif NOT structKeyExists(latestPaymentByOrder, orderKey)>
                    <cfset latestPaymentByOrder[orderKey] = {
                        "payment_method" = lCase(trim(toString(queryPayments.payment_method))),
                        "payment_status" = lCase(trim(toString(queryPayments.status)))
                    }>
                </cfif>
            </cfloop>
        </cfif>

        <cfloop query="queryTables">
            <cfset st = normTableStatus(queryTables.table_status)>
            <cfset tableKey = trim(toString(queryTables.table_number))>
            <cfset hasOrder = false>
            <cfset orderId = 0>
            <cfset orderNumber = "">
            <cfset orderStatus = "">
            <cfset totalAmount = 0>
            <cfset payMethod = "">
            <cfset payStatus = "">
            <cfset payTag = "">

            <cfif structKeyExists(latestOrderByTable, tableKey)>
                <cfset hasOrder = true>
                <cfset orderId = val(latestOrderByTable[tableKey].order_id)>
                <cfset orderNumber = trim(toString(latestOrderByTable[tableKey].order_number))>
                <cfset orderStatus = lCase(trim(toString(latestOrderByTable[tableKey].order_status)))>
                <cfset totalAmount = val(latestOrderByTable[tableKey].total_amount)>

                <cfset payKey = toString(orderId)>
                <cfif structKeyExists(latestPaymentByOrder, payKey)>
                    <cfset payMethod = lCase(trim(toString(latestPaymentByOrder[payKey].payment_method)))>
                    <cfset payStatus = lCase(trim(toString(latestPaymentByOrder[payKey].payment_status)))>
                </cfif>
            </cfif>

            <cfif hasOrder>
                <cfif (payMethod eq "online") AND (payStatus eq "success")>
                    <cfset payTag = "paid-online">
                <cfelseif (payMethod eq "cash") AND (payStatus eq "success")>
                    <cfset payTag = "paid-cash">
                <cfelseif (payMethod eq "cash") AND listFindNoCase("pending,processing", payStatus)>
                    <cfset payTag = "pending-cash">
                <cfelse>
                    <cfset payTag = "unpaid">
                </cfif>
            </cfif>

            <cfset summaryCounts["all"] = summaryCounts["all"] + 1>
            <cfset summaryCounts[st] = summaryCounts[st] + 1>
            <cfif payTag eq "pending-cash"><cfset summaryCounts["pending-cash"] = summaryCounts["pending-cash"] + 1></cfif>

            <cfset includeThis = false>
            <cfif selectedTab eq "all"><cfset includeThis = true></cfif>
            <cfif selectedTab eq "available" AND st eq "available"><cfset includeThis = true></cfif>
            <cfif selectedTab eq "occupied" AND st eq "occupied"><cfset includeThis = true></cfif>
            <cfif selectedTab eq "reserved" AND st eq "reserved"><cfset includeThis = true></cfif>
            <cfif selectedTab eq "pending-cash" AND payTag eq "pending-cash"><cfset includeThis = true></cfif>

            <cfif includeThis>
                <cfset arrayAppend(rows, {
                    "table_id" = val(queryTables.table_id),
                    "table_number" = trim(toString(queryTables.table_number)),
                    "seats" = val(queryTables.seats),
                    "table_status" = st,
                    "order_id" = orderId,
                    "order_number" = orderNumber,
                    "order_status" = orderStatus,
                    "total_amount" = totalAmount,
                    "payment_tag" = payTag,
                    "has_order" = hasOrder,
                    "can_set_available" = (NOT hasOrder) OR (payTag eq "paid-online") OR (payTag eq "paid-cash")
                })>
            </cfif>
        </cfloop>

        <cfcatch type="any">
            <cfset pageError = "app_tables query failed: " & left(trim(cfcatch.message & " " & toString(cfcatch.detail)), 350)>
        </cfcatch>
    </cftry>
<cfelse>
    <cfset pageError = "Datasource is not configured.">
</cfif>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Waiter - Tables</title>
<link rel="stylesheet" type="text/css" href="/latest/css/bootstrap/bootstrap.min.css" />
<style type="text/css">
body { font-family: "Segoe UI", Arial, sans-serif; background:#f3f5f8; color:#1d2835; margin:0; padding:16px 12px 40px; }
.container { max-width: 1280px; }
.page-head { display:flex; flex-wrap:wrap; align-items:flex-end; justify-content:space-between; gap:12px 16px; margin-bottom:14px; padding-bottom:10px; border-bottom:3px solid #f0606d; }
.page-title { margin:0; font-size:24px; font-weight:600; }
.page-sub { margin:4px 0 0; color:#6b7280; font-size:13px; }
.head-links a { margin-left:8px; }
.panel-soft { background:#fff; border:1px solid #e5e7eb; border-radius:8px; padding:16px; box-shadow:0 1px 3px rgba(0,0,0,.05); margin-bottom:14px; }
.summary-grid { display:grid; grid-template-columns:repeat(4,minmax(0,1fr)); gap:12px; }
.sum-card { border-radius:8px; padding:12px; border:1px solid #e4e7ec; background:#fff; }
.sum-card .label { display:block; font-size:12px; color:#6b7280; margin-bottom:4px; font-weight:600; text-transform:uppercase; letter-spacing:.02em; }
.sum-card .value { font-size:28px; font-weight:700; line-height:1; }
.sum-green { background:#ecfdf3; border-color:#c8edd8; }
.sum-orange { background:#fff7ed; border-color:#fed7aa; }
.sum-amber { background:#fffbeb; border-color:#fde68a; }
.tabs-row { display:flex; flex-wrap:wrap; gap:8px; margin-bottom:10px; }
.tabs-row .btn .badge { margin-left:6px; }
.table-grid { display:grid; grid-template-columns:repeat(4,minmax(0,1fr)); gap:12px; }
.tbl-card { border:1px solid #e5e7eb; border-radius:10px; background:#fff; padding:12px; box-shadow:0 1px 2px rgba(0,0,0,.04); }
.tbl-card.available { background:#f0fdf4; border-color:#bbf7d0; }
.tbl-card.occupied { background:#fff7ed; border-color:#fdba74; }
.tbl-card.reserved { background:#fefce8; border-color:#fde68a; }
.tbl-top { display:flex; align-items:flex-start; justify-content:space-between; gap:8px; margin-bottom:8px; }
.tbl-title { margin:0; font-size:22px; font-weight:700; line-height:1.1; }
.tbl-seat { color:#6b7280; font-size:12px; margin-top:4px; }
.status-chip { display:inline-block; font-size:11px; font-weight:700; padding:2px 8px; border-radius:999px; border:1px solid transparent; }
.chip-available { background:#dcfce7; color:#166534; border-color:#86efac; }
.chip-occupied { background:#ffedd5; color:#9a3412; border-color:#fdba74; }
.chip-reserved { background:#fef9c3; color:#854d0e; border-color:#fde68a; }
.chip-order-new { background:#dbeafe; color:#1e3a8a; }
.chip-order-progress { background:#ffedd5; color:#9a3412; }
.chip-order-ready { background:#dcfce7; color:#166534; }
.chip-payment-unpaid { background:#f3f4f6; color:#374151; }
.chip-payment-pending { background:#fef3c7; color:#92400e; }
.chip-payment-paid { background:#dcfce7; color:#166534; }
.tbl-row { display:flex; align-items:center; justify-content:space-between; margin:6px 0; font-size:13px; }
.tbl-actions { margin-top:10px; padding-top:10px; border-top:1px solid #e5e7eb; }
.tbl-actions .btn { width:100%; margin-top:6px; }
.empty-state { text-align:center; color:#6b7280; padding:34px 8px; border:1px dashed #d1d5db; border-radius:8px; background:#fff; }
@media (max-width: 1199px) { .table-grid { grid-template-columns:repeat(3,minmax(0,1fr)); } }
@media (max-width: 991px) { .summary-grid { grid-template-columns:repeat(2,minmax(0,1fr)); } .table-grid { grid-template-columns:repeat(2,minmax(0,1fr)); } }
@media (max-width: 640px) { .summary-grid, .table-grid { grid-template-columns:repeat(1,minmax(0,1fr)); } .head-links a { margin:4px 4px 0 0; } }
</style>
</head>
<body>
<cfoutput>
<div class="container">
    <div class="page-head">
        <div>
            <h1 class="page-title">Table Management</h1>
            <p class="page-sub">Monitor table availability, active orders, and payment status.</p>
        </div>
        <div class="head-links">
            <a href="Menu.cfm" class="btn btn-default btn-sm">Menu</a>
            <a href="Orders.cfm" class="btn btn-default btn-sm">Orders</a>
            <button type="button" class="btn btn-primary btn-sm" data-toggle="modal" data-target="##addTableModal">+ Add Table</button>
        </div>
    </div>

    <cfif len(flashMsg)><div class="alert alert-success">#esc(flashMsg)#</div></cfif>
    <cfif len(flashErr)><div class="alert alert-danger">#esc(flashErr)#</div></cfif>
    <cfif len(pageError)><div class="alert alert-warning">#esc(pageError)#</div></cfif>

    <div class="panel-soft">
        <div class="summary-grid">
            <div class="sum-card">
                <span class="label">Total tables</span>
                <div class="value">#summaryCounts["all"]#</div>
            </div>
            <div class="sum-card sum-green">
                <span class="label">Available</span>
                <div class="value">#summaryCounts["available"]#</div>
            </div>
            <div class="sum-card sum-orange">
                <span class="label">Occupied</span>
                <div class="value">#summaryCounts["occupied"]#</div>
            </div>
            <div class="sum-card sum-amber">
                <span class="label">Cash pending</span>
                <div class="value">#summaryCounts["pending-cash"]#</div>
            </div>
        </div>
    </div>

    <div class="panel-soft">
        <div class="tabs-row">
            <a class="btn <cfif selectedTab eq 'all'>btn-primary<cfelse>btn-default</cfif> btn-sm" href="Tables.cfm?tab=all">All <span class="badge">#summaryCounts["all"]#</span></a>
            <a class="btn <cfif selectedTab eq 'occupied'>btn-primary<cfelse>btn-default</cfif> btn-sm" href="Tables.cfm?tab=occupied">Occupied <span class="badge">#summaryCounts["occupied"]#</span></a>
            <a class="btn <cfif selectedTab eq 'available'>btn-primary<cfelse>btn-default</cfif> btn-sm" href="Tables.cfm?tab=available">Available <span class="badge">#summaryCounts["available"]#</span></a>
            <a class="btn <cfif selectedTab eq 'reserved'>btn-primary<cfelse>btn-default</cfif> btn-sm" href="Tables.cfm?tab=reserved">Reserved <span class="badge">#summaryCounts["reserved"]#</span></a>
            <a class="btn <cfif selectedTab eq 'pending-cash'>btn-primary<cfelse>btn-default</cfif> btn-sm" href="Tables.cfm?tab=pending-cash">Cash Pending <span class="badge">#summaryCounts["pending-cash"]#</span></a>
        </div>

        <cfif arrayLen(rows) eq 0>
            <div class="empty-state">No tables found for this filter.</div>
        <cfelse>
            <div class="table-grid">
                <cfloop array="#rows#" index="r">
                    <div class="tbl-card #r.table_status#">
                        <div class="tbl-top">
                            <div>
                                <h3 class="tbl-title">Table #esc(r.table_number)#</h3>
                                <div class="tbl-seat">#r.seats# seats</div>
                            </div>
                            <div>
                                <cfif r.table_status eq "available"><span class="status-chip chip-available">Available</span></cfif>
                                <cfif r.table_status eq "occupied"><span class="status-chip chip-occupied">Occupied</span></cfif>
                                <cfif r.table_status eq "reserved"><span class="status-chip chip-reserved">Reserved</span></cfif>
                            </div>
                        </div>

                        <cfif r.has_order>
                            <div class="tbl-row">
                                <span>Order</span>
                                <span>## #esc(r.order_number)#</span>
                            </div>
                            <div class="tbl-row">
                                <span>Order status</span>
                                <span>
                                    <cfif listFindNoCase("new,pending,confirmed", r.order_status)><span class="status-chip chip-order-new">New</span>
                                    <cfelseif listFindNoCase("preparing,cooking,in-progress,in progress", r.order_status)><span class="status-chip chip-order-progress">In progress</span>
                                    <cfelseif r.order_status eq "ready"><span class="status-chip chip-order-ready">Ready</span>
                                    <cfelse><span class="status-chip chip-order-new">#esc(r.order_status)#</span></cfif>
                                </span>
                            </div>
                            <div class="tbl-row">
                                <span>Total</span>
                                <span><strong>#NumberFormat(r.total_amount, "9,999.99")#</strong></span>
                            </div>
                            <div class="tbl-row">
                                <span>Payment</span>
                                <span>
                                    <cfif r.payment_tag eq "paid-online"><span class="status-chip chip-payment-paid">Paid online</span></cfif>
                                    <cfif r.payment_tag eq "paid-cash"><span class="status-chip chip-payment-paid">Paid cash</span></cfif>
                                    <cfif r.payment_tag eq "pending-cash"><span class="status-chip chip-payment-pending">Cash pending</span></cfif>
                                    <cfif r.payment_tag eq "unpaid"><span class="status-chip chip-payment-unpaid">Unpaid</span></cfif>
                                </span>
                            </div>
                        </cfif>

                        <div class="tbl-actions">
                            <cfif r.payment_tag eq "pending-cash">
                                <form method="post" action="Tables.cfm" style="margin:0;">
                                    <input type="hidden" name="form_action" value="confirm_cash" />
                                    <input type="hidden" name="order_id" value="#r.order_id#" />
                                    <input type="hidden" name="rt_tab" value="#selectedTab#" />
                                    <button type="submit" class="btn btn-success btn-sm">Confirm Cash Payment</button>
                                </form>
                            </cfif>

                            <button
                                type="button"
                                class="btn btn-default btn-sm"
                                data-toggle="modal"
                                data-target="##statusModal"
                                data-table-id="#r.table_id#"
                                data-table-number="#esc(r.table_number)#"
                                data-current-status="#r.table_status#"
                                data-can-available="<cfif r.can_set_available>1<cfelse>0</cfif>"
                            >Change Status</button>
                        </div>
                    </div>
                </cfloop>
            </div>
        </cfif>
    </div>
</div>
</cfoutput>

<div class="modal fade" id="addTableModal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <form method="post" action="Tables.cfm">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">Add New Table</h4>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="form_action" value="add_table" />
                    <cfoutput><input type="hidden" name="rt_tab" value="#selectedTab#" /></cfoutput>
                    <div class="form-group">
                        <label for="table_number">Table Number</label>
                        <input type="text" name="table_number" id="table_number" maxlength="20" class="form-control" placeholder="e.g. T-05" required="required" />
                    </div>
                    <div class="form-group" style="margin-bottom:0;">
                        <label for="seats">Seats</label>
                        <input type="number" name="seats" id="seats" min="1" max="24" class="form-control" value="4" required="required" />
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Add Table</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="statusModal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <form method="post" action="Tables.cfm">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">Change Table Status</h4>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="form_action" value="update_table_status" />
                    <input type="hidden" name="table_id" id="status_table_id" value="" />
                    <cfoutput><input type="hidden" name="rt_tab" value="#selectedTab#" /></cfoutput>
                    <p id="status_table_label" style="font-weight:600; margin-bottom:12px;"></p>
                    <div class="form-group">
                        <label for="new_status">New status</label>
                        <select name="new_status" id="new_status" class="form-control" required="required">
                            <option value="available">Available</option>
                            <option value="occupied">Occupied</option>
                            <option value="reserved">Reserved</option>
                        </select>
                    </div>
                    <div id="status_warning" class="alert alert-warning" style="display:none; margin-bottom:0;">
                        This table has an unpaid/pending order. You cannot set it to Available until payment is completed.
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Update</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/latest/js/bootstrap/bootstrap.min.js"></script>
<script type="text/javascript">
(function($){
    $('#statusModal').on('show.bs.modal', function (event) {
        var btn = $(event.relatedTarget);
        var tableId = btn.data('table-id');
        var tableNo = btn.data('table-number');
        var currentStatus = (btn.data('current-status') || '').toString();
        var canAvailable = String(btn.data('can-available')) === '1';
        var $modal = $(this);

        $modal.find('#status_table_id').val(tableId || '');
        $modal.find('#status_table_label').text('Table ' + tableNo + ' — current: ' + currentStatus);
        $modal.find('#new_status').val(currentStatus);

        if (!canAvailable) {
            $modal.find('#new_status option[value="available"]').prop('disabled', true);
            if ($modal.find('#new_status').val() === 'available') {
                $modal.find('#new_status').val('occupied');
            }
            $modal.find('#status_warning').show();
        } else {
            $modal.find('#new_status option[value="available"]').prop('disabled', false);
            $modal.find('#status_warning').hide();
        }
    });
})(jQuery);
</script>
</body>
</html>
