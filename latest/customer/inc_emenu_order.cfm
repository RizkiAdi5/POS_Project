<!---
    Shared e-menu order + QR session helpers (included by waiter + customer pages).
--->
<cffunction name="emenuOrderIsOpen" output="false" returntype="boolean">
    <cfargument name="status" type="string" required="true">
    <cfset var s = lCase(trim(arguments.status))>
    <cfreturn NOT listFindNoCase("paid,cancelled,completed", s)>
</cffunction>

<cffunction name="emenuNewOrderNumber" output="false" returntype="string">
    <cfreturn "EMENU-" & dateFormat(now(), "yyyymmdd") & "-" & timeFormat(now(), "HHmmss") & "-" & right(replace(createUUID(), "-", "", "all"), 4)>
</cffunction>

<cffunction name="emenuNewQrToken" output="false" returntype="string">
    <cfreturn left(replace(createUUID(), "-", "", "all"), 100)>
</cffunction>

<cffunction name="emenuAutoTableStatus" output="false" returntype="string">
    <!--- available = session with no line items yet; occupied = open order with at least one item --->
    <cfargument name="orderIsOpen" type="boolean" required="true">
    <cfargument name="itemCount" type="numeric" required="true">
    <cfif arguments.orderIsOpen AND val(arguments.itemCount) gt 0>
        <cfreturn "occupied">
    </cfif>
    <cfreturn "available">
</cffunction>

<cffunction name="emenuDbTableStatusLabel" output="false" returntype="string">
    <cfargument name="autoStatus" type="string" required="true">
    <cfset var s = lCase(trim(arguments.autoStatus))>
    <cfswitch expression="#s#">
        <cfcase value="occupied"><cfreturn "Occupied"></cfcase>
        <cfcase value="reserved"><cfreturn "Reserved"></cfcase>
        <cfdefaultcase><cfreturn "Available"></cfdefaultcase>
    </cfswitch>
</cffunction>

<cffunction name="emenuSyncTableStatusAuto" output="false" returntype="void">
    <!--- Writes Available/Occupied to DB; never overwrites Reserved (manual). --->
    <cfargument name="dsn" type="string" required="true">
    <cfargument name="tableId" type="numeric" required="true">
    <cfargument name="autoStatus" type="string" required="true">
    <cfset var label = emenuDbTableStatusLabel(arguments.autoStatus)>
    <cfif arguments.tableId lte 0><cfreturn></cfif>
    <cftry>
        <cfquery datasource="#arguments.dsn#">
            UPDATE app_tables
            SET status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#label#">
            WHERE table_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tableId#">
              AND LOWER(TRIM(IFNULL(status,''))) <> 'reserved'
        </cfquery>
        <cfcatch type="any"></cfcatch>
    </cftry>
</cffunction>

<cffunction name="emenuSyncTableOccupiedForOrder" output="false" returntype="void">
    <cfargument name="dsn" type="string" required="true">
    <cfargument name="tableId" type="numeric" required="true">
    <cfargument name="orderId" type="numeric" required="true">
    <cfset var qCnt = "">
    <cfif arguments.tableId lte 0 OR arguments.orderId lte 0><cfreturn></cfif>
    <cftry>
        <cfquery name="qCnt" datasource="#arguments.dsn#">
            SELECT COUNT(*) AS item_count
            FROM app_order_items
            WHERE order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.orderId#">
        </cfquery>
        <cfif val(qCnt.item_count) gt 0>
            <cfset emenuSyncTableStatusAuto(arguments.dsn, arguments.tableId, "occupied")>
        </cfif>
        <cfcatch type="any"></cfcatch>
    </cftry>
</cffunction>

<cffunction name="emenuQrUrl" output="false" returntype="string">
    <cfargument name="token" type="string" required="true">
    <cfset var host = trim(CGI.HTTP_HOST)>
    <cfif NOT len(host)><cfset host = "localhost"></cfif>
    <cfreturn "http://" & host & "/latest/customer/qr.cfm?t=" & URLEncodedFormat(trim(arguments.token))>
</cffunction>

<cffunction name="emenuCloseOpenOrdersForTable" output="false" returntype="void">
    <cfargument name="dsn" type="string" required="true">
    <cfargument name="tableId" type="numeric" required="true">
    <cftry>
        <cfquery datasource="#arguments.dsn#">
            UPDATE app_orders
            SET status = <cfqueryparam cfsqltype="cf_sql_varchar" value="completed">
            WHERE table_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tableId#">
              AND status NOT IN ('paid','cancelled','completed')
        </cfquery>
        <cfcatch type="any"></cfcatch>
    </cftry>
</cffunction>

<cffunction name="emenuCreatePlaceholderOrder" output="false" returntype="struct">
    <cfargument name="dsn" type="string" required="true">
    <cfargument name="tableId" type="numeric" required="true">
    <cfset var out = { "ok" = false, "order_id" = 0, "order_number" = "", "error" = "" }>
    <cfset var orderNum = emenuNewOrderNumber()>
    <cftry>
        <cfquery name="qIns" datasource="#arguments.dsn#" result="insRes">
            INSERT INTO app_orders
                (order_number, custno, table_id, order_type, order_source, status, total_amount, created_at)
            VALUES (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#orderNum#">,
                NULL,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tableId#">,
                'dine_in',
                'qr_code',
                'pending',
                <cfqueryparam cfsqltype="cf_sql_decimal" value="0">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            )
        </cfquery>
        <cfset out.order_id = val(insRes.GENERATED_KEY)>
        <cfif out.order_id lte 0>
            <cfquery name="qOid" datasource="#arguments.dsn#">
                SELECT order_id FROM app_orders
                WHERE order_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#orderNum#">
                LIMIT 1
            </cfquery>
            <cfif qOid.recordCount><cfset out.order_id = val(qOid.order_id)></cfif>
        </cfif>
        <cfif out.order_id gt 0>
            <cfquery datasource="#arguments.dsn#">
                UPDATE app_tables
                SET current_order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#out.order_id#">,
                    status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Available">
                WHERE table_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tableId#">
            </cfquery>
            <cfset out.order_number = orderNum>
            <cfset out.ok = true>
        <cfelse>
            <cfset out.error = "Could not create session order.">
        </cfif>
        <cfcatch type="any">
            <cfset out.error = left(trim(cfcatch.message & " " & toString(cfcatch.detail)), 300)>
        </cfcatch>
    </cftry>
    <cfreturn out>
</cffunction>

<cffunction name="emenuTableHasOpenOrder" output="false" returntype="boolean">
    <cfargument name="dsn" type="string" required="true">
    <cfargument name="tableId" type="numeric" required="true">
    <cfset var qOpen = "">
    <cfif arguments.tableId lte 0><cfreturn false></cfif>
    <cftry>
        <cfquery name="qOpen" datasource="#arguments.dsn#">
            SELECT COUNT(*) AS row_count
            FROM app_orders
            WHERE table_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tableId#">
              AND status NOT IN ('completed','cancelled')
        </cfquery>
        <cfreturn val(qOpen.row_count) gt 0>
        <cfcatch type="any"><cfreturn false></cfcatch>
    </cftry>
</cffunction>

<cffunction name="emenuCompleteTableSession" output="false" returntype="struct">
    <cfargument name="dsn" type="string" required="true">
    <cfargument name="tableId" type="numeric" required="true">
    <cfargument name="orderId" type="numeric" required="true">
    <cfargument name="recordCash" type="boolean" required="false" default="false">
    <cfargument name="cashAmount" type="numeric" required="false" default="0">
    <cfargument name="waiterNote" type="string" required="false" default="">
    <cfset var out = { "ok" = false, "error" = "" }>
    <cfset var qOrd = "">
    <cfset var noteText = left(trim(arguments.waiterNote), 500)>
    <cfif arguments.tableId lte 0 OR arguments.orderId lte 0>
        <cfset out.error = "Invalid table or order.">
        <cfreturn out>
    </cfif>
    <cftry>
        <cfquery name="qOrd" datasource="#arguments.dsn#">
            SELECT order_id, order_number, total_amount, status
            FROM app_orders
            WHERE order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.orderId#">
              AND table_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tableId#">
            LIMIT 1
        </cfquery>
        <cfif qOrd.recordCount eq 0>
            <cfset out.error = "Order not found for this table.">
            <cfreturn out>
        </cfif>
        <cfif NOT emenuOrderIsOpen(qOrd.status)>
            <cfset out.error = "This order is already completed or cancelled.">
            <cfreturn out>
        </cfif>
        <cfif arguments.recordCash>
            <cfset var payAmt = arguments.cashAmount>
            <cfif payAmt lte 0><cfset payAmt = val(qOrd.total_amount)></cfif>
            <cfquery datasource="#arguments.dsn#">
                INSERT INTO app_payments
                    (order_id, payment_method, amount, status, paid_at)
                VALUES (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.orderId#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="cash">,
                    <cfqueryparam cfsqltype="cf_sql_decimal" value="#payAmt#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="success">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                )
            </cfquery>
        </cfif>
        <cfquery datasource="#arguments.dsn#">
            UPDATE app_orders
            SET status = <cfqueryparam cfsqltype="cf_sql_varchar" value="completed">,
                completed_at = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                <cfif len(noteText)>,
                kitchen_notes = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#noteText#">
                </cfif>
            WHERE order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.orderId#">
        </cfquery>
        <cfquery datasource="#arguments.dsn#">
            UPDATE app_tables
            SET status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Available">,
                current_order_id = NULL
            WHERE table_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tableId#">
        </cfquery>
        <cfset out.ok = true>
        <cfcatch type="any">
            <cfset out.error = left(trim(cfcatch.message & " " & toString(cfcatch.detail)), 300)>
        </cfcatch>
    </cftry>
    <cfreturn out>
</cffunction>

<cffunction name="emenuRegenerateTableQrSession" output="false" returntype="struct">
    <cfargument name="dsn" type="string" required="true">
    <cfargument name="tableId" type="numeric" required="true">
    <cfset var out = { "ok" = false, "qr_token" = "", "qr_url" = "", "order_id" = 0, "order_number" = "", "error" = "" }>
    <cfset var newToken = "">
    <cfset var ph = "">
    <cfif arguments.tableId lte 0>
        <cfset out.error = "Invalid table.">
        <cfreturn out>
    </cfif>
    <cfif emenuTableHasOpenOrder(arguments.dsn, arguments.tableId)>
        <cfset out.error = "Complete the current session first (use Complete Session). Payment in the system is optional for cash.">
        <cfreturn out>
    </cfif>
  <cftry>
    <cfset newToken = emenuNewQrToken()>
    <cfquery datasource="#arguments.dsn#">
        UPDATE app_tables
        SET qr_token = <cfqueryparam cfsqltype="cf_sql_varchar" value="#newToken#">,
            qr_generated_at = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
            current_order_id = NULL,
            status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Available">
        WHERE table_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tableId#">
    </cfquery>
    <cfset ph = emenuCreatePlaceholderOrder(arguments.dsn, arguments.tableId)>
    <cfif NOT ph.ok>
        <cfset out.error = ph.error>
        <cfreturn out>
    </cfif>
    <cfset out.ok = true>
    <cfset out.qr_token = newToken>
    <cfset out.qr_url = emenuQrUrl(newToken)>
    <cfset out.order_id = ph.order_id>
    <cfset out.order_number = ph.order_number>
    <cfcatch type="any">
        <cfset out.error = left(trim(cfcatch.message & " " & toString(cfcatch.detail)), 300)>
    </cfcatch>
  </cftry>
    <cfreturn out>
</cffunction>

<cffunction name="emenuBindCustomerSession" output="false" returntype="void">
    <cfargument name="qTable" type="query" required="true">
    <cfargument name="orderId" type="numeric" required="true">
    <cfargument name="orderNumber" type="string" required="true">
    <cfargument name="qrToken" type="string" required="true">
    <cfset SESSION.emenu_table_id      = qTable.table_id>
    <cfset SESSION.emenu_table_number    = qTable.table_number>
    <cfset SESSION.emenu_table_name      = len(trim(qTable.table_name)) ? trim(qTable.table_name) : "Table " & qTable.table_number>
    <cfset SESSION.emenu_qr_token        = arguments.qrToken>
    <cfset SESSION.emenu_order_id        = arguments.orderId>
    <cfset SESSION.emenu_order_number    = arguments.orderNumber>
    <cfset SESSION.emenu_cart_locked     = false>
</cffunction>
