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
<!--- Recover the table's open order if the session lost it. The order is a
      property of the table's QR session, so as long as table context is
      intact it can be re-resolved rather than failing the customer. Without
      this, anything that drops emenu_order_id mid-visit silently costs the
      customer their cart. --->
<cfif val(SESSION.emenu_order_id) lte 0>
    <cftry>
        <cfquery name="qRebind" datasource="#dts#">
            SELECT order_id, order_number
            FROM   app_orders
            WHERE  table_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(SESSION.emenu_table_id)#">
              AND  status NOT IN ('paid','cancelled','completed')
            ORDER  BY created_at DESC
            LIMIT  1
        </cfquery>
        <cfif qRebind.recordCount>
            <cfset SESSION.emenu_order_id     = val(qRebind.order_id)>
            <cfset SESSION.emenu_order_number = trim(qRebind.order_number)>
        </cfif>
        <cfcatch type="any"></cfcatch>
    </cftry>
</cfif>

<cfif SESSION.emenu_cart_locked eq true OR val(SESSION.emenu_order_id) lte 0>
    <cflocation url="/latest/customer/menu.cfm?msg=order_already_submitted" addtoken="false">
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

<!--- Build list of ITEMNOs from cart for a single batch lookup --->
<cfset menuIdList = "">
<cfloop array="#cartItems#" index="ci">
    <cfset menuIdList = listAppend(menuIdList, trim(ci.id))>
</cfloop>

<!--- Single query: fetch authoritative price + item_code for all cart items --->
<cfset dbPrices = structNew()>
<cftry>
    <cfquery name="qMenuPrices" datasource="#dts#">
        SELECT ITEMNO AS item_code, DESP AS display_name, PRICE AS price
        FROM   icitem
        WHERE  ITEMNO IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#menuIdList#" list="true">)
    </cfquery>
    <cfloop query="qMenuPrices">
        <cfset dbPrices[trim(qMenuPrices.item_code)] = {
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

<!--- Use session order created when waiter generated QR --->
<cfset newOrderId = val(SESSION.emenu_order_id)>
<cfset orderNumber = len(trim(SESSION.emenu_order_number)) ? trim(SESSION.emenu_order_number) : "">

<cfif newOrderId lte 0>
    <cflocation url="/latest/customer/qr_error.cfm" addtoken="false">
</cfif>

<!--- Loyalty info --->
<cfset isLoyalty = (SESSION.emenu_loggedin eq "Yes" AND len(trim(SESSION.emenu_custno)))>
<cfset custno    = isLoyalty ? trim(SESSION.emenu_custno) : "">

<!--- ── Block the order if a required raw material doesn't have enough stock ──
      Runs before any DB write below, so a rejected order leaves no partial state. --->
<cfset stockCheck = emenuCheckStockSufficient(dts, cartItems, dbPrices)>
<cfif NOT stockCheck.ok>
    <cfset SESSION.emenu_stock_shortages = stockCheck.shortages>
    <cflocation url="/latest/customer/menu.cfm?stockErr=1" addtoken="false">
</cfif>

<!--- ── UPDATE session app_orders (placeholder -> real cart) ── --->
<cftry>
    <cfquery datasource="#dts#">
        UPDATE app_orders
        SET custno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#len(trim(custno)) ? trim(custno) : '-'#">,
            subtotal = <cfqueryparam cfsqltype="cf_sql_decimal" value="#subtotal#">,
            tax_amount = <cfqueryparam cfsqltype="cf_sql_decimal" value="#taxAmt#">,
            total_amount = <cfqueryparam cfsqltype="cf_sql_decimal" value="#totalAmt#">,
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

<!--- ── INSERT app_order_items (one per cart line) ── --->
<cfloop array="#cartItems#" index="ci">
    <cfset ciMenuId  = trim(ci.id)>
    <cfset ciMidKey  = ciMenuId>
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

<!--- ── Link order to table; status Occupied only when line items exist (else Available) ── --->
<cftry>
    <cfquery datasource="#dts#">
        UPDATE app_tables
        SET current_order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#newOrderId#">
        WHERE table_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.emenu_table_id#">
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

<!--- ── Store in session for confirm page (lock cart — one checkout per QR session) ── --->
<cfset SESSION.emenu_order_id     = newOrderId>
<cfset SESSION.emenu_order_number = orderNumber>
<cfset SESSION.emenu_cart_locked  = true>
<cfset SESSION.emenu_order_total  = totalAmt>
<cfset SESSION.emenu_order_subtot = subtotal>
<cfset SESSION.emenu_order_tax    = taxAmt>
<cfset SESSION.emenu_points_earned= pointsEarned>

<cflocation url="/latest/customer/order_confirm.cfm" addtoken="false">
