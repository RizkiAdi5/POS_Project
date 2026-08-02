<cfprocessingdirective pageencoding="UTF-8">
<cfif NOT isDefined("dashboardMode") OR NOT dashboardMode>
    <cfinclude template="../application.cfm">
</cfif>
<cfinclude template="/latest/customer/inc_emenu_order.cfm">
<cfsetting enablecfoutputonly="false">
<cfsetting showdebugoutput="false">

<!--- Table Management merged into Waiter Dashboard; keep this file as the implementation include only. --->
<cfparam name="dashboardMode" default="false">
<cfif NOT dashboardMode>
    <cflocation url="WaiterDashboard.cfm" addtoken="false">
</cfif>
<cfset pageSelf = "WaiterDashboard.cfm">

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

<!--- dts is set by application.cfm from the logged-in user's userdept — no override needed --->
<cfif NOT (isDefined("dts") AND len(trim(dts)))>
    <cfabort showerror="dts not set — application.cfm must run before Tables.cfm">
</cfif>
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
                        <cfquery datasource="#dts#" result="qAddTbl">
                            INSERT INTO app_tables (
                                table_number, seats, qr_token, status
                            ) VALUES (
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#tableNum#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#seatsVal#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#emenuNewQrToken()#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="Available">
                            )
                        </cfquery>
                        <cfset newTblId = val(qAddTbl.GENERATED_KEY)>
                        <cfif newTblId lte 0>
                            <cfquery name="qNewTbl" datasource="#dts#">
                                SELECT table_id FROM app_tables
                                WHERE table_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tableNum#">
                                LIMIT 1
                            </cfquery>
                            <cfif qNewTbl.recordCount><cfset newTblId = val(qNewTbl.table_id)></cfif>
                        </cfif>
                        <cfif newTblId gt 0>
                            <cfset phAdd = emenuCreatePlaceholderOrder(dts, newTblId)>
                            <cfif phAdd.ok>
                                <cfset flashMsg = "Table " & tableNum & " added. QR session: " & phAdd.order_number & ".">
                            <cfelse>
                                <cfset flashMsg = "Table " & tableNum & " added. " & phAdd.error>
                            </cfif>
                        <cfelse>
                            <cfset flashMsg = "Table " & tableNum & " added.">
                        </cfif>
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
                    <cfif NOT len(flashMsg)><cfset flashMsg = "Table " & tableNum & " added."></cfif>
                </cfif>
                <cfcatch type="any">
                    <cfset flashErr = "Add table failed: " & left(trim(cfcatch.message & " " & toString(cfcatch.detail)), 300)>
                </cfcatch>
            </cftry>
        </cfif>
    </cfif>

    <cfif form.form_action eq "complete_session" AND isNumeric(form.table_id) AND isNumeric(form.order_id)>
        <cfset csTblId = val(form.table_id)>
        <cfset csOrdId = val(form.order_id)>
        <cfset csRecordCash = structKeyExists(form, "record_cash") AND (form.record_cash eq "1" OR lCase(trim(form.record_cash)) eq "yes")>
        <cfset csAmount = val(form.cash_amount)>
        <cfset csNote = "">
        <cfif structKeyExists(form, "waiter_note")><cfset csNote = trim(form.waiter_note)></cfif>
        <cfset cs = emenuCompleteTableSession(dts, csTblId, csOrdId, csRecordCash, csAmount, csNote)>
        <cfif cs.ok>
            <cfif cs.status eq "cancelled">
                <cfset flashMsg = "No payment was recorded, so the order was cancelled. You can regenerate QR for the next customers.">
            <cfelse>
                <cfset flashMsg = "Session completed. You can regenerate QR for the next customers.">
            </cfif>
        <cfelse>
            <cfset flashErr = cs.error>
        </cfif>
    </cfif>

    <cfif form.form_action eq "regenerate_session" AND isNumeric(form.table_id) AND hasQrToken>
        <cfset regTblId = val(form.table_id)>
        <cfset reg = emenuRegenerateTableQrSession(dts, regTblId)>
        <cfif NOT reg.ok>
            <cfset flashErr = reg.error>
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
                        SELECT payment_id FROM (
                            SELECT MAX(payment_id) AS payment_id
                            FROM app_payments
                            WHERE order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#oid#">
                              AND payment_method = <cfqueryparam cfsqltype="cf_sql_varchar" value="cash">
                        ) AS latest_cash_payment
                    )
                </cfquery>
                <!--- Mirror what the Xendit webhook does on successful payment — otherwise the order
                      stays stuck at its kitchen-workflow status and never shows as "paid" like online payments --->
                <cfquery datasource="#dts#">
                    UPDATE app_orders
                    SET    status = <cfqueryparam cfsqltype="cf_sql_varchar" value="paid">
                    WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#oid#">
                      AND  status NOT IN ('paid','completed','cancelled')
                </cfquery>
                <cfset flashMsg = "Cash payment confirmed.">
                <cfcatch type="any">
                    <cfset flashErr = "Cash confirmation failed: " & left(trim(cfcatch.message & " " & toString(cfcatch.detail)), 300)>
                </cfcatch>
            </cftry>
        </cfif>
    </cfif>

    <cfif form.form_action eq "set_reserved" AND isNumeric(form.table_id)>
        <cfset tid = val(form.table_id)>
        <cftry>
            <cfquery datasource="#dts#">
                UPDATE app_tables
                SET status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Reserved">
                WHERE table_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tid#">
            </cfquery>
            <cfset flashMsg = "Table marked as reserved.">
            <cfcatch type="any">
                <cfset flashErr = "Could not mark reserved: " & left(trim(cfcatch.message), 200)>
            </cfcatch>
        </cftry>
    </cfif>

    <cfif form.form_action eq "clear_reserved" AND isNumeric(form.table_id)>
        <cfset tid = val(form.table_id)>
        <cfset oid = val(form.order_id)>
        <cfset ic = val(form.item_count)>
        <cfset oOpen = (form.order_is_open eq "1")>
        <cfset autoSt = emenuAutoTableStatus(oOpen, ic)>
        <cftry>
            <cfquery datasource="#dts#">
                UPDATE app_tables
                SET status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emenuDbTableStatusLabel(autoSt)#">
                WHERE table_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tid#">
            </cfquery>
            <cfset flashMsg = "Reservation cleared. Table is now #autoSt#.">
            <cfcatch type="any">
                <cfset flashErr = "Could not clear reservation: " & left(trim(cfcatch.message), 200)>
            </cfcatch>
        </cftry>
    </cfif>

    <cfif len(flashErr)>
        <cflocation url="#pageSelf#?tab=#URLEncodedFormat(redirectTab)#&err=#URLEncodedFormat(flashErr)#" addtoken="false">
    <cfelse>
        <cflocation url="#pageSelf#?tab=#URLEncodedFormat(redirectTab)#&msg=#URLEncodedFormat(flashMsg)#" addtoken="false">
    </cfif>
</cfif>

<cfset pageError = "">
<cfset queryTables = queryNew("table_id")>
<cfset queryOrders = queryNew("order_id")>
<cfset queryPayments = queryNew("payment_id")>
<cfset rows = []>
<cfset latestOrderByTable = structNew()>
<cfset latestPaymentByOrder = structNew()>
<cfset itemCountByOrder = structNew()>
<cfset summaryCounts = {
    "all" = 0,
    "available" = 0,
    "occupied" = 0,
    "paid" = 0,
    "reserved" = 0,
    "pending-cash" = 0
}>

<cfif len(trim(dts))>
    <cftry>
        <cfquery name="queryTables" datasource="#dts#">
            SELECT t.table_id, t.table_number, t.seats, t.status AS table_status,
                   t.qr_token, t.current_order_id
            FROM app_tables t
            ORDER BY t.table_number ASC
        </cfquery>

        <cfquery name="queryOrders" datasource="#dts#">
            SELECT o.order_id, o.order_number, o.table_id, t.table_number, o.status, o.total_amount, o.created_at
            FROM app_orders o
            LEFT JOIN app_tables t ON o.table_id = t.table_id
            WHERE o.status NOT IN ('completed','cancelled')
            ORDER BY o.table_id ASC, o.created_at DESC
        </cfquery>

        <cfloop query="queryOrders">
            <cfset tableIdKey = toString(val(queryOrders.table_id))>
            <cfif val(queryOrders.table_id) gt 0 AND NOT structKeyExists(latestOrderByTable, tableIdKey)>
                <cfset latestOrderByTable[tableIdKey] = {
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

            <cfquery name="queryItemCounts" datasource="#dts#">
                SELECT order_id, COUNT(*) AS item_count
                FROM app_order_items
                WHERE order_id IN (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#orderIdList#" list="true">
                )
                GROUP BY order_id
            </cfquery>
            <cfloop query="queryItemCounts">
                <cfset itemCountByOrder[toString(val(queryItemCounts.order_id))] = val(queryItemCounts.item_count)>
            </cfloop>
        </cfif>

        <cfloop query="queryTables">
            <cfset st = normTableStatus(queryTables.table_status)>
            <cfset tableKey = toString(val(queryTables.table_id))>
            <cfset tblQrToken = "">
            <cfif structKeyExists(queryTables, "qr_token") AND len(trim(queryTables.qr_token))>
                <cfset tblQrToken = trim(queryTables.qr_token)>
            </cfif>
            <cfset tblQrUrl = len(tblQrToken) ? emenuQrUrl(tblQrToken) : "">
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

            <cfset itemCount = 0>
            <cfif orderId gt 0 AND structKeyExists(itemCountByOrder, toString(orderId))>
                <cfset itemCount = val(itemCountByOrder[toString(orderId)])>
            </cfif>
            <cfset orderIsOpen = hasOrder AND len(orderStatus) AND emenuOrderIsOpen(orderStatus)>
            <cfset displaySt = st>
            <cfif st neq "reserved">
                <cfset displaySt = emenuAutoTableStatus(orderIsOpen, itemCount)>
                <!--- Paid orders: table still occupied until waiter completes session --->
                <cfif displaySt eq "available" AND hasOrder AND orderStatus eq "paid">
                    <cfset displaySt = "paid">
                </cfif>
                <!--- "paid" is a virtual display state — don't write it to DB --->
                <cfif displaySt neq "paid">
                    <cfset emenuSyncTableStatusAuto(dts, val(queryTables.table_id), displaySt)>
                </cfif>
            </cfif>

            <cfset summaryCounts["all"] = summaryCounts["all"] + 1>
            <cfif structKeyExists(summaryCounts, displaySt)>
                <cfset summaryCounts[displaySt] = summaryCounts[displaySt] + 1>
            </cfif>
            <cfif payTag eq "pending-cash"><cfset summaryCounts["pending-cash"] = summaryCounts["pending-cash"] + 1></cfif>

            <cfset includeThis = false>
            <cfif selectedTab eq "all"><cfset includeThis = true></cfif>
            <cfif selectedTab eq "available" AND displaySt eq "available"><cfset includeThis = true></cfif>
            <cfif selectedTab eq "occupied" AND displaySt eq "occupied"><cfset includeThis = true></cfif>
            <cfif selectedTab eq "paid" AND displaySt eq "paid"><cfset includeThis = true></cfif>
            <cfif selectedTab eq "reserved" AND displaySt eq "reserved"><cfset includeThis = true></cfif>
            <cfif selectedTab eq "pending-cash" AND payTag eq "pending-cash"><cfset includeThis = true></cfif>

            <!--- Only allow regenerate when table has no order or only an empty placeholder order --->
            <cfset canRegenQr = hasQrToken AND (NOT hasOrder OR itemCount eq 0)>

            <cfif includeThis>
                <cfset arrayAppend(rows, {
                    "table_id" = val(queryTables.table_id),
                    "table_number" = trim(toString(queryTables.table_number)),
                    "seats" = val(queryTables.seats),
                    "table_status" = displaySt,
                    "item_count" = itemCount,
                    "order_id" = orderId,
                    "order_number" = orderNumber,
                    "order_status" = orderStatus,
                    "total_amount" = totalAmount,
                    "payment_tag" = payTag,
                    "has_order" = hasOrder,
                    "order_is_open" = orderIsOpen,
                    "can_regenerate_qr" = canRegenQr,
                    "is_reserved" = (displaySt eq "reserved"),
                    "qr_token" = tblQrToken,
                    "qr_url" = tblQrUrl
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
<title>Waiter Dashboard</title>
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
.qr-block { margin-bottom:8px; }
.qr-block .qr-label { display:block; font-size:11px; color:#6b7280; margin-bottom:6px; }
.qr-canvas { display:inline-block; padding:6px; background:#fff; border:1px solid #e5e7eb; border-radius:6px; line-height:0; cursor:pointer; }
.qr-canvas:hover { border-color:#F54900; box-shadow:0 0 0 2px rgba(245,73,0,.15); }
.qr-canvas img, .qr-canvas canvas { display:block; max-width:100%; height:auto; }
/* QR zoom modal */
#qrZoomModal { display:none; position:fixed; inset:0; z-index:9999; background:rgba(0,0,0,.65); align-items:center; justify-content:center; padding:24px; }
#qrZoomModal.open { display:flex; }
#qrZoomModal .qz-box { background:#fff; border-radius:16px; padding:24px 24px 20px; text-align:center; max-width:340px; width:100%; position:relative; }
#qrZoomModal .qz-title { font-size:16px; font-weight:700; color:#111; margin-bottom:4px; }
#qrZoomModal .qz-sub { font-size:12px; color:#6b7280; margin-bottom:16px; }
#qrZoomModal .qz-canvas { display:inline-block; padding:10px; background:#fff; border:1px solid #e5e7eb; border-radius:8px; line-height:0; margin-bottom:14px; }
#qrZoomModal .qz-close { width:100%; padding:10px; border:1px solid #e5e7eb; border-radius:10px; background:#f3f4f6; color:#374151; font-size:14px; font-weight:600; cursor:pointer; }
.qr-url-input { margin-top:6px; font-size:11px; }
.qr-flash { display:flex; flex-wrap:wrap; align-items:flex-start; gap:12px; }
.qr-flash .qr-canvas { flex:0 0 auto; }
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
            <h1 class="page-title">Waiter Dashboard</h1>
            <p class="page-sub">Monitor tables, payments, and customer QR order sessions. Regenerate QR when a table is finished to start a new order.</p>
        </div>
        <div class="head-links">
            <cfif isDefined("SESSION.waiter_name") AND len(trim(SESSION.waiter_name))>
                <span style="font-size:13px;color:##6b7280;line-height:30px;">
                    #HTMLEditFormat(SESSION.waiter_name)#
                </span>
                <a href="WaiterDashboard.cfm?waiter_logout=1" class="btn btn-default btn-sm">Sign Out</a>
            </cfif>
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
            <a class="btn <cfif selectedTab eq 'all'>btn-primary<cfelse>btn-default</cfif> btn-sm" href="#pageSelf#?tab=all">All <span class="badge">#summaryCounts["all"]#</span></a>
            <a class="btn <cfif selectedTab eq 'occupied'>btn-primary<cfelse>btn-default</cfif> btn-sm" href="#pageSelf#?tab=occupied">Occupied <span class="badge">#summaryCounts["occupied"]#</span></a>
            <a class="btn <cfif selectedTab eq 'paid'>btn-success<cfelse>btn-default</cfif> btn-sm" href="#pageSelf#?tab=paid">Paid <span class="badge">#summaryCounts["paid"]#</span></a>
            <a class="btn <cfif selectedTab eq 'available'>btn-primary<cfelse>btn-default</cfif> btn-sm" href="#pageSelf#?tab=available">Available <span class="badge">#summaryCounts["available"]#</span></a>
            <a class="btn <cfif selectedTab eq 'reserved'>btn-primary<cfelse>btn-default</cfif> btn-sm" href="#pageSelf#?tab=reserved">Reserved <span class="badge">#summaryCounts["reserved"]#</span></a>
            <a class="btn <cfif selectedTab eq 'pending-cash'>btn-primary<cfelse>btn-default</cfif> btn-sm" href="#pageSelf#?tab=pending-cash">Cash Pending <span class="badge">#summaryCounts["pending-cash"]#</span></a>
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
                                <span>Items ordered</span>
                                <span>#r.item_count#</span>
                            </div>
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
                            <cfif hasQrToken AND len(r.qr_url)>
                                <div class="qr-block">
                                    <span class="qr-label">Customer QR — scan to order</span>
                                    <div class="qr-canvas" id="qr-table-#r.table_id#" data-qr-url="#esc(r.qr_url)#"></div>
                                    <input type="text" class="form-control input-sm qr-url-input" readonly="readonly" value="#esc(r.qr_url)#" onclick="this.select();" title="Click to copy link" />
                                </div>
                            </cfif>
                            <!--- Derive "paid" from the actual payment record (payment_tag), not app_orders.status —
                                  that column is also written by the kitchen prep workflow and can overwrite "paid". --->
                            <cfset rIsPaid = listFindNoCase("paid-online,paid-cash", r.payment_tag) gt 0>
                            <cfif r.has_order AND (r.order_is_open OR rIsPaid)>
                                <button type="button" class="btn <cfif rIsPaid>btn-success<cfelse>btn-primary</cfif> btn-sm btn-block"
                                    data-toggle="modal" data-target="##completeSessionModal"
                                    data-table-id="#r.table_id#"
                                    data-table-number="#esc(r.table_number)#"
                                    data-order-id="#r.order_id#"
                                    data-order-number="#esc(r.order_number)#"
                                    data-order-total="#val(r.total_amount)#"
                                    data-order-status="#lCase(trim(r.order_status))#"
                                    data-is-paid="<cfif rIsPaid>1<cfelse>0</cfif>"
                                >Complete Session</button>
                                <cfif rIsPaid>
                                    <p style="font-size:11px;color:##166534;margin:6px 0 0;">Payment received. Complete session to free the table.</p>
                                <cfelse>
                                    <p style="font-size:11px;color:##92400e;margin:6px 0 0;">Finish this visit before regenerating QR. Cash payment is optional.</p>
                                </cfif>
                            </cfif>
                            <cfif r.can_regenerate_qr>
                                <form method="post" action="#pageSelf#" style="margin:0;" onsubmit="return confirm('Create a new QR and order session for this table?');">
                                    <input type="hidden" name="form_action" value="regenerate_session" />
                                    <input type="hidden" name="table_id" value="#r.table_id#" />
                                    <input type="hidden" name="rt_tab" value="#selectedTab#" />
                                    <button type="submit" class="btn btn-warning btn-sm btn-block">Regenerate QR / New Order</button>
                                </form>
                            </cfif>
                            <cfif r.payment_tag eq "pending-cash">
                                <form method="post" action="#pageSelf#" style="margin:0;">
                                    <input type="hidden" name="form_action" value="confirm_cash" />
                                    <input type="hidden" name="order_id" value="#r.order_id#" />
                                    <input type="hidden" name="rt_tab" value="#selectedTab#" />
                                    <button type="submit" class="btn btn-success btn-sm btn-block">Confirm Cash Payment</button>
                                </form>
                            </cfif>
                            <cfif r.is_reserved>
                                <form method="post" action="#pageSelf#" style="margin:0;">
                                    <input type="hidden" name="form_action" value="clear_reserved" />
                                    <input type="hidden" name="table_id" value="#r.table_id#" />
                                    <input type="hidden" name="order_id" value="#r.order_id#" />
                                    <input type="hidden" name="item_count" value="#r.item_count#" />
                                    <input type="hidden" name="order_is_open" value="<cfif r.order_is_open>1<cfelse>0</cfif>" />
                                    <input type="hidden" name="rt_tab" value="#selectedTab#" />
                                    <button type="submit" class="btn btn-default btn-sm btn-block">Clear Reservation</button>
                                </form>
                            <cfelse>
                                <form method="post" action="#pageSelf#" style="margin:0;">
                                    <input type="hidden" name="form_action" value="set_reserved" />
                                    <input type="hidden" name="table_id" value="#r.table_id#" />
                                    <input type="hidden" name="rt_tab" value="#selectedTab#" />
                                    <button type="submit" class="btn btn-default btn-sm btn-block">Mark Reserved</button>
                                </form>
                            </cfif>
                            <p style="font-size:11px;color:##6b7280;margin:8px 0 0;">Available / Occupied updates automatically from orders.</p>
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
            <cfoutput><form method="post" action="#pageSelf#"></cfoutput>
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

<div class="modal fade" id="completeSessionModal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <cfoutput><form method="post" action="#pageSelf#"></cfoutput>
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">Complete Session</h4>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="form_action" value="complete_session" />
                    <input type="hidden" name="table_id" id="complete_table_id" value="" />
                    <input type="hidden" name="order_id" id="complete_order_id" value="" />
                    <cfoutput><input type="hidden" name="rt_tab" value="#selectedTab#" /></cfoutput>
                    <p id="complete_session_label" style="font-weight:600; margin-bottom:12px;"></p>
                    <p style="font-size:13px;color:##6b7280;margin-bottom:14px;">
                        Marks the order as <strong>completed</strong> and frees the table. You do not have to record payment for cash guests, but you can log it below for your records.
                    </p>
                    <div id="online_paid_notice" style="display:none;background:##f0fdf4;border:1px solid ##bbf7d0;border-radius:6px;padding:10px 14px;margin-bottom:12px;font-size:13px;color:##166534;">
                        &#10003; Payment already received online &mdash; no cash entry needed.
                    </div>
                    <div id="cash_section">
                    <div class="checkbox">
                        <label>
                            <input type="checkbox" name="record_cash" id="record_cash" value="1" />
                            Record cash payment in system
                        </label>
                    </div>
                    <div class="form-group" id="cash_amount_group" style="display:none;">
                        <label for="cash_amount">Cash amount (RM)</label>
                        <input type="number" name="cash_amount" id="cash_amount" class="form-control" min="0" step="0.01" />
                    </div>
                    </div><!--- /cash_section --->
                    <div class="form-group" style="margin-bottom:0;">
                        <label for="waiter_note">Note (optional)</label>
                        <input type="text" name="waiter_note" id="waiter_note" class="form-control" maxlength="500" placeholder="e.g. Paid cash at counter" />
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Complete Session</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!--- QR zoom modal --->
<div id="qrZoomModal" role="dialog" aria-modal="true">
    <div class="qz-box">
        <div class="qz-title" id="qzTitle">Table QR Code</div>
        <div class="qz-canvas" id="qzCanvas"></div>
        <button class="qz-close" onclick="closeQrZoom()">Close</button>
    </div>
</div>

<script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/latest/js/bootstrap/bootstrap.min.js"></script>
<script type="text/javascript" src="/latest/js/vendor/qrcode.min.js"></script>
<script type="text/javascript">
(function($){
    function renderQrCodes() {
        if (typeof QRCode === 'undefined') { return; }
        $('.qr-canvas[data-qr-url]').each(function(){
            var $el = $(this);
            var url = $.trim($el.data('qr-url') || '');
            if (!url || $el.data('qr-rendered')) { return; }
            $el.empty();
            new QRCode(this, {
                text: url,
                width: 128,
                height: 128,
                colorDark: '#111827',
                colorLight: '#ffffff',
                correctLevel: QRCode.CorrectLevel.M
            });
            $el.data('qr-rendered', 1);
        });
    }

    function toggleCashAmount() {
        if ($('#record_cash').is(':checked')) {
            $('#cash_amount_group').show();
        } else {
            $('#cash_amount_group').hide();
        }
    }
    $(document).on('change', '#record_cash', toggleCashAmount);

    $('#completeSessionModal').on('show.bs.modal', function (event) {
        var btn = $(event.relatedTarget);
        var $modal = $(this);
        var total = parseFloat(btn.data('order-total')) || 0;
        $modal.find('#complete_table_id').val(btn.data('table-id') || '');
        $modal.find('#complete_order_id').val(btn.data('order-id') || '');
        $modal.find('#complete_session_label').text(
            'Table ' + (btn.data('table-number') || '') +
            ' — Order #' + (btn.data('order-number') || '') +
            ' — RM ' + total.toFixed(2)
        );
        $modal.find('#cash_amount').val(total > 0 ? total.toFixed(2) : '0.00');
        $modal.find('#record_cash').prop('checked', false);
        $modal.find('#waiter_note').val('');
        var alreadyPaid = (String(btn.data('is-paid')) === '1');
        $modal.find('#cash_section').toggle(!alreadyPaid);
        $modal.find('#online_paid_notice').toggle(alreadyPaid);
        toggleCashAmount();
    });

    /* QR zoom modal */
    var qzQrObj = null;
    function openQrZoom(url, tableLabel) {
        if (typeof QRCode === 'undefined') { return; }
        var $modal = $('#qrZoomModal');
        var $canvas = $('#qzCanvas');
        $('#qzTitle').text(tableLabel || 'Table QR Code');
        $canvas.empty();
        if (qzQrObj) { try { qzQrObj.clear(); } catch(e){} }
        qzQrObj = new QRCode($canvas[0], {
            text: url,
            width: 260,
            height: 260,
            colorDark: '#111827',
            colorLight: '#ffffff',
            correctLevel: QRCode.CorrectLevel.M
        });
        $modal.addClass('open');
    }
    window.closeQrZoom = function() {
        $('#qrZoomModal').removeClass('open');
    };
    $('#qrZoomModal').on('click', function(e) {
        if (e.target === this) { closeQrZoom(); }
    });
    $(document).on('keydown', function(e) {
        if (e.key === 'Escape') { closeQrZoom(); }
    });

    /* Attach click to each QR block — grab table name from the card header */
    $(document).on('click', '.qr-canvas[data-qr-url]', function() {
        var url = $.trim($(this).data('qr-url') || '');
        if (!url) { return; }
        var $card = $(this).closest('.tbl-card');
        var tableName = $.trim($card.find('.tbl-title').first().text()) || 'Table QR Code';
        openQrZoom(url, tableName);
    });

    $(renderQrCodes);
})(jQuery);
</script>
</body>
</html>
