<!---
    Shared e-menu order + QR session helpers (included by waiter + customer pages).
--->
<cffunction name="emenuOrderIsOpen" output="false" returntype="boolean">
    <cfargument name="status" type="string" required="true">
    <cfset var s = lCase(trim(arguments.status))>
    <cfreturn NOT listFindNoCase("paid,cancelled,completed", s)>
</cffunction>

<cffunction name="emenuGetLatestPayment" output="false" returntype="struct">
    <cfargument name="dsn" type="string" required="true">
    <cfargument name="orderId" type="numeric" required="true">
    <cfset var out = { "payment_method" = "", "status" = "", "amount" = 0 }>
    <cfset var qPay = "">
    <cfif arguments.orderId lte 0><cfreturn out></cfif>
    <cftry>
        <cfquery name="qPay" datasource="#arguments.dsn#">
            SELECT payment_method, status, amount
            FROM   app_payments
            WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.orderId#">
            ORDER  BY payment_id DESC
            LIMIT  1
        </cfquery>
        <cfif qPay.recordCount>
            <cfset out.payment_method = lCase(trim(toString(qPay.payment_method)))>
            <cfset out.status = lCase(trim(toString(qPay.status)))>
            <cfset out.amount = val(qPay.amount)>
        </cfif>
        <cfcatch type="any"></cfcatch>
    </cftry>
    <cfreturn out>
</cffunction>

<cffunction name="emenuOrderIsPaid" output="false" returntype="boolean">
    <cfargument name="dsn" type="string" required="true">
    <cfargument name="orderId" type="numeric" required="true">
    <cfargument name="orderStatus" type="string" required="true">
    <cfset var pay = "">
    <cfif lCase(trim(arguments.orderStatus)) eq "paid"><cfreturn true></cfif>
    <!--- Check the payment record directly rather than relying solely on app_orders.status —
          that column is also written by the kitchen prep workflow (new/confirmed/preparing/ready),
          which can silently overwrite a "paid" status set by cash confirmation. A successful
          payment of ANY method (cash included) means the order is paid. --->
    <cfset pay = emenuGetLatestPayment(arguments.dsn, arguments.orderId)>
    <cfreturn pay.status eq "success">
</cffunction>

<cffunction name="emenuCustomerCanAddItems" output="false" returntype="boolean">
    <cfargument name="dsn" type="string" required="true">
    <cfargument name="orderId" type="numeric" required="true">
    <cfargument name="orderStatus" type="string" required="true">
    <cfif arguments.orderId lte 0><cfreturn false></cfif>
    <cfif NOT emenuOrderIsOpen(arguments.orderStatus)><cfreturn false></cfif>
    <cfreturn NOT emenuOrderIsPaid(arguments.dsn, arguments.orderId, arguments.orderStatus)>
</cffunction>

<cffunction name="emenuRecalculateOrderTotals" output="false" returntype="struct">
    <cfargument name="dsn" type="string" required="true">
    <cfargument name="orderId" type="numeric" required="true">
    <cfset var out = { "subtotal" = 0, "tax_amount" = 0, "total_amount" = 0 }>
    <cfset var qSum = "">
    <cfif arguments.orderId lte 0><cfreturn out></cfif>
    <cftry>
        <cfquery name="qSum" datasource="#arguments.dsn#">
            SELECT COALESCE(SUM(subtotal), 0) AS line_subtotal
            FROM   app_order_items
            WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.orderId#">
        </cfquery>
        <cfset out.subtotal = val(qSum.line_subtotal)>
        <cfset out.tax_amount = round(out.subtotal * 0.10 * 100) / 100>
        <cfset out.total_amount = out.subtotal + out.tax_amount>
        <cfquery datasource="#arguments.dsn#">
            UPDATE app_orders
            SET subtotal = <cfqueryparam cfsqltype="cf_sql_decimal" value="#out.subtotal#">,
                tax_amount = <cfqueryparam cfsqltype="cf_sql_decimal" value="#out.tax_amount#">,
                total_amount = <cfqueryparam cfsqltype="cf_sql_decimal" value="#out.total_amount#">
            WHERE order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.orderId#">
        </cfquery>
        <cfcatch type="any"></cfcatch>
    </cftry>
    <cfreturn out>
</cffunction>

<cffunction name="emenuAwardLoyaltyPoints" output="false" returntype="numeric">
    <cfargument name="dsn" type="string" required="true">
    <cfargument name="custno" type="string" required="true">
    <cfargument name="orderNumber" type="string" required="true">
    <cfargument name="amountForPoints" type="numeric" required="true">
    <cfset var pointsEarned = int(val(arguments.amountForPoints) * 0.05)>
    <cfif NOT len(trim(arguments.custno)) OR arguments.custno eq "-" OR pointsEarned lte 0><cfreturn 0></cfif>
    <cftry>
        <!--- Idempotency guard: skip if points already awarded for this order --->
        <cfquery name="qAlreadyAwarded" datasource="#arguments.dsn#">
            SELECT COUNT(*) AS cnt
            FROM   points_transactions
            WHERE  order_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.orderNumber#">
              AND  type         = 'Earned'
        </cfquery>
        <cfif val(qAlreadyAwarded.cnt) gt 0><cfreturn 0></cfif>
    <cfcatch type="any"></cfcatch>
    </cftry>
    <cftry>
        <cfquery datasource="#arguments.dsn#">
            UPDATE arcust
            SET    POINT_BF = COALESCE(POINT_BF, 0) + <cfqueryparam cfsqltype="cf_sql_integer" value="#pointsEarned#">
            WHERE  CUSTNO   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.custno)#">
        </cfquery>
        <cfquery name="qPtsAfter" datasource="#arguments.dsn#">
            SELECT COALESCE(POINT_BF, 0) AS pts
            FROM   arcust
            WHERE  CUSTNO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.custno)#">
        </cfquery>
        <cfquery datasource="#arguments.dsn#">
            INSERT INTO points_transactions
                (custno, order_number, type, points, balance_after, created_at)
            VALUES (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.custno)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.orderNumber#">,
                'Earned',
                <cfqueryparam cfsqltype="cf_sql_integer" value="#pointsEarned#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#val(qPtsAfter.pts)#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            )
        </cfquery>
        <cfcatch type="any"><cfset pointsEarned = 0></cfcatch>
    </cftry>
    <cfreturn pointsEarned>
</cffunction>

<cffunction name="emenuRedeemLoyaltyPoints" output="false" returntype="numeric">
    <cfargument name="dsn"           type="string"  required="true">
    <cfargument name="custno"        type="string"  required="true">
    <cfargument name="orderNumber"   type="string"  required="true">
    <cfargument name="pointsToRedeem" type="numeric" required="true">
    <cfset var pts = int(val(arguments.pointsToRedeem))>
    <cfif NOT len(trim(arguments.custno)) OR arguments.custno eq "-" OR pts lte 0><cfreturn 0></cfif>
    <cftry>
        <!--- Re-read live balance to prevent over-redemption --->
        <cfquery name="qCurrent" datasource="#arguments.dsn#">
            SELECT COALESCE(POINT_BF, 0) AS pts FROM arcust
            WHERE  CUSTNO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.custno)#">
        </cfquery>
        <cfif val(qCurrent.pts) lt pts><cfreturn 0></cfif>
        <!--- Atomic deduct: WHERE guard prevents balance going negative under concurrent requests --->
        <cfquery datasource="#arguments.dsn#">
            UPDATE arcust
            SET    POINT_BF = COALESCE(POINT_BF, 0) - <cfqueryparam cfsqltype="cf_sql_integer" value="#pts#">
            WHERE  CUSTNO   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.custno)#">
              AND  COALESCE(POINT_BF, 0) >= <cfqueryparam cfsqltype="cf_sql_integer" value="#pts#">
        </cfquery>
        <cfquery name="qNewBal" datasource="#arguments.dsn#">
            SELECT COALESCE(POINT_BF, 0) AS pts FROM arcust
            WHERE  CUSTNO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.custno)#">
        </cfquery>
        <cfquery datasource="#arguments.dsn#">
            INSERT INTO points_transactions
                (custno, order_number, type, points, balance_after, created_at)
            VALUES (
                <cfqueryparam cfsqltype="cf_sql_varchar"   value="#trim(arguments.custno)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar"   value="#arguments.orderNumber#">,
                'Redeemed',
                <cfqueryparam cfsqltype="cf_sql_integer"   value="#pts#">,
                <cfqueryparam cfsqltype="cf_sql_integer"   value="#val(qNewBal.pts)#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            )
        </cfquery>
        <cfreturn pts>
    <cfcatch type="any"><cfreturn 0></cfcatch>
    </cftry>
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
    <cfset var scheme = (CGI.HTTPS eq "on" OR CGI.SERVER_PORT eq "443") ? "https" : "http">
    <cfset var dtsSuffix = (isDefined("dts") AND len(trim(dts))) ? "&dts=" & URLEncodedFormat(trim(dts)) : "">
    <cfreturn scheme & "://" & host & "/latest/customer/qr.cfm?t=" & URLEncodedFormat(trim(arguments.token)) & dtsSuffix>
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
                <cfqueryparam cfsqltype="cf_sql_varchar" value="-">,
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

<cffunction name="emenuCreateTakeawayOrder" output="false" returntype="struct">
    <!--- Waiter POS: standalone order with no table, its own order_number as the pickup reference --->
    <cfargument name="dsn" type="string" required="true">
    <cfset var out = { "ok" = false, "order_id" = 0, "order_number" = "", "error" = "" }>
    <cfset var orderNum = emenuNewOrderNumber()>
    <cftry>
        <cfquery name="qIns" datasource="#arguments.dsn#" result="insRes">
            INSERT INTO app_orders
                (order_number, custno, table_id, order_type, order_source, status, total_amount, created_at)
            VALUES (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#orderNum#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="-">,
                NULL,
                'takeaway',
                'waiter_pos',
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
            <cfset out.order_number = orderNum>
            <cfset out.ok = true>
        <cfelse>
            <cfset out.error = "Could not create takeaway order.">
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
              AND status NOT IN ('completed','cancelled','paid')
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
            SELECT order_id, order_number, total_amount, status,
                   TRIM(IFNULL(custno, '')) AS custno
            FROM app_orders
            WHERE order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.orderId#">
              AND table_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tableId#">
            LIMIT 1
        </cfquery>
        <cfif qOrd.recordCount eq 0>
            <cfset out.error = "Order not found for this table.">
            <cfreturn out>
        </cfif>
        <cfif lCase(trim(qOrd.status)) eq "cancelled">
            <cfset out.error = "This order has been cancelled.">
            <cfreturn out>
        </cfif>
        <cfif lCase(trim(qOrd.status)) eq "completed">
            <cfset out.error = "This order is already completed.">
            <cfreturn out>
        </cfif>
        <cfif arguments.recordCash>
            <!--- Skip cash insert if a successful online payment already exists --->
            <cfquery name="qExistPay" datasource="#arguments.dsn#">
                SELECT COUNT(*) AS cnt
                FROM   app_payments
                WHERE  order_id       = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.orderId#">
                  AND  status         = 'success'
                  AND  payment_method <> 'cash'
            </cfquery>
            <cfif val(qExistPay.cnt) eq 0>
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
        </cfif>
        <!--- A session only "completes" if payment was actually collected (cash just recorded above,
              or already paid online). No payment on close-out = the visit is cancelled, not completed. --->
        <cfquery name="qConfirmedPay" datasource="#arguments.dsn#">
            SELECT COUNT(*) AS cnt
            FROM   app_payments
            WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.orderId#">
              AND  status   = 'success'
        </cfquery>
        <cfset var finalStatus = (val(qConfirmedPay.cnt) gt 0) ? "completed" : "cancelled">
        <cfquery datasource="#arguments.dsn#">
            UPDATE app_orders
            SET status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#finalStatus#">
                <cfif finalStatus eq "completed">,
                completed_at = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                </cfif>
                <cfif len(noteText)>,
                kitchen_notes = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#noteText#">
                </cfif>
            WHERE order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.orderId#">
        </cfquery>
        <!--- Also close out any other lingering open orders for the same table — completed if they
              were paid, cancelled if not, same rule as the main order above --->
        <cfquery datasource="#arguments.dsn#">
            UPDATE app_orders
            SET status = <cfqueryparam cfsqltype="cf_sql_varchar" value="completed">,
                completed_at = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            WHERE table_id  = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tableId#">
              AND order_id  <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.orderId#">
              AND status NOT IN ('completed','cancelled')
              AND EXISTS (
                  SELECT 1 FROM app_payments
                  WHERE app_payments.order_id = app_orders.order_id AND app_payments.status = 'success'
              )
        </cfquery>
        <cfquery datasource="#arguments.dsn#">
            UPDATE app_orders
            SET status = <cfqueryparam cfsqltype="cf_sql_varchar" value="cancelled">
            WHERE table_id  = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tableId#">
              AND order_id  <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.orderId#">
              AND status NOT IN ('completed','cancelled')
              AND NOT EXISTS (
                  SELECT 1 FROM app_payments
                  WHERE app_payments.order_id = app_orders.order_id AND app_payments.status = 'success'
              )
        </cfquery>
        <!--- Award loyalty points only when the order actually completed with a confirmed payment --->
        <cfif finalStatus eq "completed" AND len(qOrd.custno) AND qOrd.custno neq "-" AND val(qOrd.total_amount) gt 0>
            <cfset emenuAwardLoyaltyPoints(arguments.dsn, qOrd.custno, qOrd.order_number, val(qOrd.total_amount))>
        </cfif>
        <!--- Auto-create a new placeholder order so the table's QR stays active --->
        <cfset emenuCreatePlaceholderOrder(arguments.dsn, arguments.tableId)>
        <cfset out.ok = true>
        <cfset out.status = finalStatus>
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
    <cftry>
        <cfquery name="qAutoClose" datasource="#arguments.dsn#">
            UPDATE app_orders
            SET status = <cfqueryparam cfsqltype="cf_sql_varchar" value="completed">,
                completed_at = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            WHERE table_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tableId#">
              AND status NOT IN ('paid','cancelled','completed')
              AND NOT EXISTS (
                  SELECT 1 FROM app_order_items
                  WHERE app_order_items.order_id = app_orders.order_id
              )
        </cfquery>
        <cfcatch type="any"></cfcatch>
    </cftry>
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

<cffunction name="emenuGetDineInTableBoard" output="false" returntype="array">
    <!--- Read-only table status board for Waiter POS's table picker. Same status derivation
          as Tables.cfm (available/occupied/paid/reserved) but never writes to app_tables —
          Tables.cfm remains the single writer of auto-synced status. --->
    <cfargument name="dsn" type="string" required="true">
    <cfset var out = []>
    <cfset var qTables = "">
    <cfset var qOrders = "">
    <cfset var qPayments = "">
    <cfset var qItems = "">
    <cfset var latestOrderByTable = structNew()>
    <cfset var latestPaymentByOrder = structNew()>
    <cfset var itemsByOrder = structNew()>
    <cfset var orderIdList = "">
    <cfset var tableKeyForOrderMap = "">
    <cfset var mappedOrder = "">

    <cfquery name="qTables" datasource="#arguments.dsn#">
        SELECT table_id, table_number, seats, status AS table_status
        FROM   app_tables
        WHERE  is_active = 1
        ORDER  BY table_number ASC
    </cfquery>

    <cfquery name="qOrders" datasource="#arguments.dsn#">
        SELECT order_id, order_number, table_id, status, total_amount, created_at
        FROM   app_orders
        WHERE  status NOT IN ('completed','cancelled')
          AND  table_id IS NOT NULL
        ORDER  BY table_id ASC, created_at DESC
    </cfquery>

    <cfloop query="qOrders">
        <cfset var tableIdKey = toString(val(qOrders.table_id))>
        <cfif NOT structKeyExists(latestOrderByTable, tableIdKey)>
            <cfset latestOrderByTable[tableIdKey] = {
                "order_id" = val(qOrders.order_id),
                "order_number" = trim(toString(qOrders.order_number)),
                "order_status" = lCase(trim(toString(qOrders.status))),
                "total_amount" = val(qOrders.total_amount)
            }>
        </cfif>
    </cfloop>

    <cfloop collection="#latestOrderByTable#" item="tableKeyForOrderMap">
        <cfset mappedOrder = latestOrderByTable[tableKeyForOrderMap]>
        <cfset orderIdList = listAppend(orderIdList, val(mappedOrder.order_id))>
    </cfloop>

    <cfif len(orderIdList)>
        <cftry>
            <cfquery name="qPayments" datasource="#arguments.dsn#">
                SELECT payment_id, order_id, payment_method, status
                FROM   app_payments
                WHERE  order_id IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#orderIdList#" list="true">)
                ORDER  BY order_id ASC, payment_id DESC
            </cfquery>
            <cfloop query="qPayments">
                <cfset var orderKey = toString(val(qPayments.order_id))>
                <cfif NOT structKeyExists(latestPaymentByOrder, orderKey)>
                    <cfset latestPaymentByOrder[orderKey] = {
                        "payment_method" = lCase(trim(toString(qPayments.payment_method))),
                        "payment_status" = lCase(trim(toString(qPayments.status)))
                    }>
                </cfif>
            </cfloop>
            <cfcatch type="any"></cfcatch>
        </cftry>

        <cftry>
            <cfquery name="qItems" datasource="#arguments.dsn#">
                SELECT order_id, COALESCE(item_name, item_code) AS item_name, quantity
                FROM   app_order_items
                WHERE  order_id IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#orderIdList#" list="true">)
                ORDER  BY order_id ASC, item_id ASC
            </cfquery>
            <cfloop query="qItems">
                <cfset var itmKey = toString(val(qItems.order_id))>
                <cfif NOT structKeyExists(itemsByOrder, itmKey)>
                    <cfset itemsByOrder[itmKey] = []>
                </cfif>
                <cfset arrayAppend(itemsByOrder[itmKey], {
                    "name" = trim(toString(qItems.item_name)),
                    "qty" = val(qItems.quantity)
                })>
            </cfloop>
            <cfcatch type="any"></cfcatch>
        </cftry>
    </cfif>

    <cfloop query="qTables">
        <cfset var tableKey = toString(val(qTables.table_id))>
        <cfset var manualStatus = lCase(trim(toString(qTables.table_status)))>
        <cfset var hasOrder = structKeyExists(latestOrderByTable, tableKey)>
        <cfset var orderId = 0>
        <cfset var orderNumber = "">
        <cfset var orderStatus = "">
        <cfset var totalAmount = 0>
        <cfset var payMethod = "">
        <cfset var payStatus = "">
        <cfset var payTag = "">
        <cfset var itemCount = 0>
        <cfset var rowItems = []>
        <cfset var displaySt = "">

        <cfif hasOrder>
            <cfset orderId = val(latestOrderByTable[tableKey].order_id)>
            <cfset orderNumber = latestOrderByTable[tableKey].order_number>
            <cfset orderStatus = latestOrderByTable[tableKey].order_status>
            <cfset totalAmount = val(latestOrderByTable[tableKey].total_amount)>

            <cfset var payKey = toString(orderId)>
            <cfif structKeyExists(latestPaymentByOrder, payKey)>
                <cfset payMethod = latestPaymentByOrder[payKey].payment_method>
                <cfset payStatus = latestPaymentByOrder[payKey].payment_status>
            </cfif>
            <cfif structKeyExists(itemsByOrder, payKey)>
                <cfset rowItems = itemsByOrder[payKey]>
                <cfset itemCount = arrayLen(rowItems)>
            </cfif>

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

        <cfif listFindNoCase("reserved,booked", manualStatus)>
            <cfset displaySt = "reserved">
        <cfelse>
            <cfset displaySt = emenuAutoTableStatus(hasOrder AND len(orderStatus) AND emenuOrderIsOpen(orderStatus), itemCount)>
            <cfif displaySt eq "available" AND hasOrder AND orderStatus eq "paid">
                <cfset displaySt = "paid">
            </cfif>
        </cfif>

        <!--- Only surface the item list for statuses where staff would want to see "what's already ordered" --->
        <cfif NOT listFindNoCase("occupied,paid", displaySt)>
            <cfset rowItems = []>
        </cfif>

        <cfset arrayAppend(out, {
            "table_id" = val(qTables.table_id),
            "table_number" = trim(toString(qTables.table_number)),
            "seats" = val(qTables.seats),
            "status" = displaySt,
            "has_order" = hasOrder,
            "order_id" = orderId,
            "order_number" = orderNumber,
            "order_status" = orderStatus,
            "item_count" = itemCount,
            "total_amount" = totalAmount,
            "payment_tag" = payTag,
            "items" = rowItems
        })>
    </cfloop>

    <cfreturn out>
</cffunction>
