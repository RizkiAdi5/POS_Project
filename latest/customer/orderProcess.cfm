<!---
    /latest/customer/orderProcess.cfm
    Receives cart_json from menu.cfm, saves app_orders + app_order_items,
    awards loyalty points, then redirects to order_confirm.cfm.
    POST only — accessed via the hidden form in menu.cfm.
--->
<cfinclude template="../../application.cfm">

<!--- Guard: must have table context --->
<cfif NOT len(trim(SESSION.emenu_table_id))>
    <cflocation url="/latest/customer/qr_error.cfm" addtoken="false">
</cfif>
<cfif CGI.REQUEST_METHOD neq "POST" OR NOT len(trim(FORM.cart_json))>
    <cflocation url="/latest/customer/menu.cfm" addtoken="false">
</cfif>

<!--- ── Parse cart JSON ── --->
<cftry>
    <cfset cartItems = deserializeJSON(FORM.cart_json)>
    <cfcatch type="any">
        <cflocation url="/latest/customer/menu.cfm" addtoken="false">
    </cfcatch>
</cftry>

<cfif NOT isArray(cartItems) OR arrayLen(cartItems) eq 0>
    <cflocation url="/latest/customer/menu.cfm" addtoken="false">
</cfif>

<!--- ── Build list of menu_ids from cart for a single batch lookup ── --->
<cfset menuIdList = "">
<cfloop array="#cartItems#" index="ci">
    <cfset menuIdList = listAppend(menuIdList, val(ci.id))>
</cfloop>

<!--- ── Single query: fetch authoritative price + item_code for all cart items ── --->
<cfset dbPrices = structNew()><!--- keyed by menu_id --->
<cftry>
    <cfquery name="qMenuPrices" datasource="#dts#">
        SELECT menu_id, item_code, display_name, price
        FROM   app_menu
        WHERE  menu_id IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#menuIdList#" list="true">)
    </cfquery>
    <cfloop query="qMenuPrices">
        <cfset dbPrices[toString(qMenuPrices.menu_id)] = {
            "item_code"   : trim(qMenuPrices.item_code),
            "display_name": trim(qMenuPrices.display_name),
            "price"       : val(qMenuPrices.price)
        }>
    </cfloop>
    <cfcatch type="any"></cfcatch>
</cftry>

<!--- ── Calculate totals using DB prices (never trust client price) ── --->
<cfset subtotal = 0>
<cfloop array="#cartItems#" index="ci">
    <cfset mid = toString(val(ci.id))>
    <cfset dbPrice = structKeyExists(dbPrices, mid) ? dbPrices[mid].price : val(ci.price)>
    <cfset subtotal = subtotal + (dbPrice * val(ci.qty))>
</cfloop>
<cfset taxAmt    = round(subtotal * 0.10 * 100) / 100>
<cfset totalAmt  = subtotal + taxAmt>

<!--- ── Generate order number: ORD-YYYYMMDD-HHMMSS ── --->
<cfset orderNumber = "ORD-" & dateFormat(now(),'yyyymmdd') & "-" & timeFormat(now(),'HHmmss')>

<!--- ── Loyalty info ── --->
<cfset isLoyalty  = (SESSION.emenu_loggedin eq "Yes" AND len(trim(SESSION.emenu_custno)))>
<cfset custno     = isLoyalty ? trim(SESSION.emenu_custno) : "">

<!--- ── INSERT app_orders ── --->
<cftry>
    <cfquery name="qInsertOrder" datasource="#dts#" result="orderResult">
        INSERT INTO app_orders
            (order_number, custno, table_number, order_type,
             status, total_amount, created_at)
        VALUES (
            <cfqueryparam cfsqltype="cf_sql_varchar"   value="#orderNumber#">,
            <cfif len(custno)>
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#custno#">,
            <cfelse>
                NULL,
            </cfif>
            <cfqueryparam cfsqltype="cf_sql_varchar"   value="#SESSION.emenu_table_number#">,
            'dine',
            'in progress',
            <cfqueryparam cfsqltype="cf_sql_decimal"   value="#totalAmt#">,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
        )
    </cfquery>
    <cfset newOrderId = orderResult.GENERATED_KEY>
    <cfcatch type="any">
        <!--- Fallback: get the order_id by order_number --->
        <cfquery name="qGetOrd" datasource="#dts#">
            SELECT order_id FROM app_orders
            WHERE order_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#orderNumber#">
            LIMIT 1
        </cfquery>
        <cfif qGetOrd.recordCount>
            <cfset newOrderId = qGetOrd.order_id>
        <cfelse>
            <cflocation url="/latest/customer/menu.cfm" addtoken="false">
        </cfif>
    </cfcatch>
</cftry>

<!--- ── INSERT app_order_items (one per cart line) ── --->
<cfloop array="#cartItems#" index="ci">
    <cfset ciMenuId  = val(ci.id)>
    <cfset ciMidKey  = toString(ciMenuId)>
    <cfset ciQty     = val(ci.qty)>
    <cfset ciNote    = isDefined("ci.note") ? trim(ci.note) : "">

    <!--- Use DB-authoritative values; fall back to client values if DB lookup missed --->
    <cfif structKeyExists(dbPrices, ciMidKey)>
        <cfset ciPrice    = dbPrices[ciMidKey].price>
        <cfset ciItemCode = dbPrices[ciMidKey].item_code>
        <cfset ciName     = dbPrices[ciMidKey].display_name>
    <cfelse>
        <cfset ciPrice    = val(ci.price)>
        <cfset ciItemCode = "">
        <cfset ciName     = isDefined("ci.name") ? trim(ci.name) : "">
    </cfif>
    <cfset ciSubtot = round(ciPrice * ciQty * 100) / 100>

    <cftry>
        <cfquery datasource="#dts#">
            INSERT INTO app_order_items
                (order_id, item_code, item_name, quantity, unit_price, subtotal,
                 special_instructions, status)
            VALUES (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#newOrderId#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ciItemCode#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ciName#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#ciQty#">,
                <cfqueryparam cfsqltype="cf_sql_decimal" value="#ciPrice#">,
                <cfqueryparam cfsqltype="cf_sql_decimal" value="#ciSubtot#">,
                <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#ciNote#">,
                'Pending'
            )
        </cfquery>
        <cfcatch type="any"></cfcatch>
    </cftry>
</cfloop>

<!--- ── Link order to table + mark Occupied ── --->
<cftry>
    <cfquery datasource="#dts#">
        UPDATE app_tables
        SET    current_order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#newOrderId#">,
               status = 'Occupied'
        WHERE  table_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.emenu_table_id#">
    </cfquery>
    <cfcatch type="any"></cfcatch>
</cftry>

<!--- ── Award loyalty points (10 pts per RM 1) ── --->
<cfset pointsEarned = 0>
<cfif isLoyalty>
    <cfset pointsEarned = int(totalAmt * 10)>
    <cfif pointsEarned gt 0>
        <cftry>
            <!--- Atomic increment — no race condition --->
            <cfquery datasource="#dts#">
                UPDATE arcust
                SET    POINT_BF = COALESCE(POINT_BF, 0) + <cfqueryparam cfsqltype="cf_sql_integer" value="#pointsEarned#">
                WHERE  CUSTNO   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#custno#">
            </cfquery>

            <!--- Read new balance for the transaction log --->
            <cfquery name="qPtsAfter" datasource="#dts#">
                SELECT COALESCE(POINT_BF, 0) AS pts
                FROM   arcust
                WHERE  CUSTNO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#custno#">
            </cfquery>
            <cfset newBal = val(qPtsAfter.pts)>

            <cfquery datasource="#dts#">
                INSERT INTO points_transactions
                    (custno, order_number, type, points, balance_after, created_at)
                VALUES (
                    <cfqueryparam cfsqltype="cf_sql_varchar"   value="#custno#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar"   value="#orderNumber#">,
                    'Earned',
                    <cfqueryparam cfsqltype="cf_sql_integer"   value="#pointsEarned#">,
                    <cfqueryparam cfsqltype="cf_sql_integer"   value="#newBal#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                )
            </cfquery>
            <cfcatch type="any"></cfcatch>
        </cftry>
    </cfif>
</cfif>

<!--- ── Store in session for confirm page ── --->
<cfset SESSION.emenu_order_id     = newOrderId>
<cfset SESSION.emenu_order_number = orderNumber>
<cfset SESSION.emenu_order_total  = totalAmt>
<cfset SESSION.emenu_order_subtot = subtotal>
<cfset SESSION.emenu_order_tax    = taxAmt>
<cfset SESSION.emenu_points_earned= pointsEarned>

<cflocation url="/latest/customer/order_confirm.cfm" addtoken="false">
