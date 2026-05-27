<!---
    /latest/customer/orderProcess.cfm
    Receives cart_json from menu.cfm, appends items to the QR session order,
    then redirects to order_confirm.cfm.
    POST only — accessed via the hidden form in menu.cfm.
--->
<cfinclude template="../../application.cfm">
<cfinclude template="inc_emenu_order.cfm">

<!--- Guard: must have table context --->
<cfif NOT len(trim(SESSION.emenu_table_id))>
    <cflocation url="/latest/customer/qr_error.cfm" addtoken="false">
</cfif>
<cfif val(SESSION.emenu_order_id) lte 0>
    <cflocation url="/latest/customer/qr_error.cfm" addtoken="false">
</cfif>

<cfquery name="qOrdGuard" datasource="#dts#">
    SELECT status FROM app_orders
    WHERE order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(SESSION.emenu_order_id)#">
    LIMIT 1
</cfquery>
<cfif qOrdGuard.recordCount eq 0 OR NOT emenuCustomerCanAddItems(dts, val(SESSION.emenu_order_id), qOrdGuard.status)>
    <cflocation url="/latest/customer/order_status.cfm?msg=order_closed" addtoken="false">
</cfif>

<cfif CGI.REQUEST_METHOD neq "POST" OR NOT len(trim(FORM.cart_json))>
    <cflocation url="/latest/customer/menu.cfm" addtoken="false">
</cfif>

<!--- Parse cart JSON --->
<cftry>
    <cfset cartItems = deserializeJSON(FORM.cart_json)>
    <cfcatch type="any">
        <cflocation url="/latest/customer/menu.cfm" addtoken="false">
    </cfcatch>
</cftry>

<cfif NOT isArray(cartItems) OR arrayLen(cartItems) eq 0>
    <cflocation url="/latest/customer/menu.cfm" addtoken="false">
</cfif>

<!--- Build list of menu_ids from cart for a single batch lookup --->
<cfset menuIdList = "">
<cfloop array="#cartItems#" index="ci">
    <cfset menuIdList = listAppend(menuIdList, val(ci.id))>
</cfloop>

<!--- Single query: fetch authoritative price + item_code for all cart items --->
<cfset dbPrices = structNew()>
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

<!--- Use session order created when waiter generated QR --->
<cfset newOrderId = val(SESSION.emenu_order_id)>
<cfset orderNumber = len(trim(SESSION.emenu_order_number)) ? trim(SESSION.emenu_order_number) : "">

<!--- Loyalty info --->
<cfset isLoyalty = (SESSION.emenu_loggedin eq "Yes" AND len(trim(SESSION.emenu_custno)))>
<cfset custno    = isLoyalty ? trim(SESSION.emenu_custno) : "">

<!--- Update session order (customer + status; totals recalculated after items) --->
<cftry>
    <cfquery datasource="#dts#">
        UPDATE app_orders
        SET custno = <cfif len(custno)>
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#custno#">
            <cfelse>
                NULL
            </cfif>,
            status = <cfqueryparam cfsqltype="cf_sql_varchar" value="in progress">,
            order_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="dine">
        WHERE order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#newOrderId#">
          AND table_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(SESSION.emenu_table_id)#">
          AND status NOT IN ('paid','cancelled','completed')
    </cfquery>
    <cfcatch type="any">
        <cflocation url="/latest/customer/menu.cfm" addtoken="false">
    </cfcatch>
</cftry>

<cfif NOT len(orderNumber)>
    <cfquery name="qOrdNum" datasource="#dts#">
        SELECT order_number FROM app_orders
        WHERE order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#newOrderId#">
        LIMIT 1
    </cfquery>
    <cfif qOrdNum.recordCount><cfset orderNumber = trim(qOrdNum.order_number)></cfif>
</cfif>

<!--- Insert app_order_items (one per cart line) --->
<cfloop array="#cartItems#" index="ci">
    <cfset ciMenuId  = val(ci.id)>
    <cfset ciMidKey  = toString(ciMenuId)>
    <cfset ciQty     = val(ci.qty)>
    <cfset ciNote    = isDefined("ci.note") ? trim(ci.note) : "">

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

<!--- Link order to table; mark Occupied when line items exist --->
<cftry>
    <cfquery datasource="#dts#">
        UPDATE app_tables
        SET current_order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#newOrderId#">
        WHERE table_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(SESSION.emenu_table_id)#">
    </cfquery>
    <cfset emenuSyncTableOccupiedForOrder(dts, val(SESSION.emenu_table_id), newOrderId)>
    <cfcatch type="any"></cfcatch>
</cftry>

<!--- Recalculate bill from all line items (supports Order More rounds) --->
<cfset totals = emenuRecalculateOrderTotals(dts, newOrderId)>
<cfset subtotal = totals.subtotal>
<cfset taxAmt   = totals.tax_amount>
<cfset totalAmt = totals.total_amount>

<!--- Points awarded when bill is paid (see paymentProcess.cfm) --->
<cfset pointsEarned = 0>

<!--- Guest order history (privacy: only orders from this device at this table) --->
<cfif SESSION.emenu_is_guest eq "Yes" AND newOrderId gt 0>
    <cfif NOT structKeyExists(SESSION, "emenu_guest_order_ids") OR NOT len(trim(SESSION.emenu_guest_order_ids))>
        <cfset SESSION.emenu_guest_order_ids = toString(newOrderId)>
    <cfelseif NOT listFind(SESSION.emenu_guest_order_ids, newOrderId)>
        <cfset SESSION.emenu_guest_order_ids = listAppend(SESSION.emenu_guest_order_ids, newOrderId)>
    </cfif>
</cfif>

<!--- Store in session for confirm page --->
<cfset SESSION.emenu_order_id      = newOrderId>
<cfset SESSION.emenu_order_number  = orderNumber>
<cfset SESSION.emenu_cart_locked   = false>
<cfset SESSION.emenu_order_total   = totalAmt>
<cfset SESSION.emenu_order_subtot  = subtotal>
<cfset SESSION.emenu_order_tax     = taxAmt>
<cfset SESSION.emenu_points_earned = pointsEarned>

<cflocation url="/latest/customer/order_confirm.cfm" addtoken="false">
