<!---
    /latest/Waiter/WaiterPOSOrderProcess.cfm
    Staff-side counter ordering, single-page flow: on first submit for this
    session (no SESSION.wpos_order_id yet), resolves/creates the order from
    the posted order_mode/table_number, then — same request — appends the
    cart items. Later submits (order already resolved) just append items.
    Mirrors latest/customer/orderProcess.cfm but driven by staff input
    (table number / take-away) instead of a QR session.
--->
<cfprocessingdirective pageencoding="UTF-8">
<cfinclude template="/application.cfm">
<cfinclude template="/latest/customer/inc_emenu_order.cfm">
<cfsetting enablecfoutputonly="false">
<cfsetting showdebugoutput="false">

<cfparam name="SESSION.wpos_order_id"     default="">
<cfparam name="SESSION.wpos_order_number" default="">
<cfparam name="SESSION.wpos_table_id"     default="">
<cfparam name="SESSION.wpos_table_number" default="">
<cfparam name="SESSION.wpos_is_takeaway"  default="No">
<cfparam name="SESSION.wpos_invoice_url"  default="">
<cfparam name="SESSION.wpos_show_qr"      default="No">

<cfset wposAction = structKeyExists(url, "action") ? lCase(trim(url.action)) : "">

<cfif wposAction neq "submit">
    <cflocation url="WaiterPOS.cfm" addtoken="false">
</cfif>

<cfif CGI.REQUEST_METHOD neq "POST" OR NOT len(trim(FORM.cart_json))>
    <cflocation url="WaiterPOS.cfm" addtoken="false">
</cfif>

<!--- ───────────────────────────────────────────────────────────
      Resolve/create the order if this session doesn't have one yet
──────────────────────────────────────────────────────────── --->
<cfif val(SESSION.wpos_order_id) lte 0>

    <cfset orderMode = structKeyExists(form, "order_mode") ? lCase(trim(form.order_mode)) : "">

    <cfif orderMode eq "takeaway">

        <cfset res = emenuCreateTakeawayOrder(dts)>
        <cfif NOT res.ok>
            <cflocation url="WaiterPOS.cfm?err=#URLEncodedFormat(res.error)#" addtoken="false">
        </cfif>
        <cfset SESSION.wpos_order_id     = res.order_id>
        <cfset SESSION.wpos_order_number = res.order_number>
        <cfset SESSION.wpos_table_id     = "">
        <cfset SESSION.wpos_table_number = "">
        <cfset SESSION.wpos_is_takeaway  = "Yes">

    <cfelseif orderMode eq "dine_in">

        <cfif NOT structKeyExists(form, "table_number") OR NOT len(trim(form.table_number))>
            <cflocation url="WaiterPOS.cfm?err=#URLEncodedFormat('Enter a table number.')#" addtoken="false">
        </cfif>

        <cfquery name="qTable" datasource="#dts#">
            SELECT table_id, table_number
            FROM   app_tables
            WHERE  table_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.table_number)#">
              AND  is_active = 1
            LIMIT  1
        </cfquery>
        <cfif qTable.recordCount eq 0>
            <cflocation url="WaiterPOS.cfm?err=#URLEncodedFormat('No table found with that number.')#" addtoken="false">
        </cfif>
        <cfset tableId = val(qTable.table_id)>

        <!--- Reuse an existing open order at this table (merge), else create a fresh one --->
        <cfquery name="qOpenOrd" datasource="#dts#">
            SELECT order_id, order_number
            FROM   app_orders
            WHERE  table_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tableId#">
              AND  status NOT IN ('completed','cancelled','paid')
            ORDER  BY created_at DESC
            LIMIT  1
        </cfquery>

        <cfif qOpenOrd.recordCount gt 0>
            <cfset SESSION.wpos_order_id     = val(qOpenOrd.order_id)>
            <cfset SESSION.wpos_order_number = trim(qOpenOrd.order_number)>
        <cfelse>
            <cfset res = emenuCreatePlaceholderOrder(dts, tableId)>
            <cfif NOT res.ok>
                <cflocation url="WaiterPOS.cfm?err=#URLEncodedFormat(res.error)#" addtoken="false">
            </cfif>
            <cfset SESSION.wpos_order_id     = res.order_id>
            <cfset SESSION.wpos_order_number = res.order_number>
        </cfif>

        <cfset SESSION.wpos_table_id     = tableId>
        <cfset SESSION.wpos_table_number = trim(qTable.table_number)>
        <cfset SESSION.wpos_is_takeaway  = "No">

    <cfelse>
        <cflocation url="WaiterPOS.cfm?err=#URLEncodedFormat('Choose Dine In or Take Away.')#" addtoken="false">
    </cfif>

    <cfset SESSION.wpos_invoice_url = "">
    <cfset SESSION.wpos_show_qr     = "No">

</cfif>

<!--- ───────────────────────────────────────────────────────────
      Append priced cart items to the (now-resolved) order
──────────────────────────────────────────────────────────── --->
<cftry>
    <cfset cartItems = deserializeJSON(FORM.cart_json)>
    <cfcatch type="any">
        <cflocation url="WaiterPOS.cfm" addtoken="false">
    </cfcatch>
</cftry>
<cfif NOT isArray(cartItems) OR arrayLen(cartItems) eq 0>
    <cflocation url="WaiterPOS.cfm" addtoken="false">
</cfif>

<cfset orderId = val(SESSION.wpos_order_id)>

<!--- Batch price lookup — never trust client price --->
<cfset menuIdList = "">
<cfloop array="#cartItems#" index="ci">
    <cfset menuIdList = listAppend(menuIdList, trim(ci.id))>
</cfloop>
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

<!--- Move a fresh placeholder/reused order into 'in progress' (leave order_type/custno as set at creation) --->
<cftry>
    <cfquery datasource="#dts#">
        UPDATE app_orders
        SET    status = <cfqueryparam cfsqltype="cf_sql_varchar" value="in progress">
        WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">
          AND  status NOT IN ('paid','cancelled','completed')
    </cfquery>
    <cfcatch type="any"></cfcatch>
</cftry>

<cfloop array="#cartItems#" index="ci">
    <cfset ciMenuId = trim(ci.id)>
    <cfset ciQty    = val(ci.qty)>
    <cfset ciNote   = isDefined("ci.note") ? trim(ci.note) : "">

    <cfif structKeyExists(dbPrices, ciMenuId)>
        <cfset ciPrice    = dbPrices[ciMenuId].price>
        <cfset ciItemCode = dbPrices[ciMenuId].item_code>
        <cfset ciName     = dbPrices[ciMenuId].display_name>
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
                <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">,
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

<!--- Dine-in: keep the table linked/occupied --->
<cfif SESSION.wpos_is_takeaway neq "Yes" AND val(SESSION.wpos_table_id) gt 0>
    <cftry>
        <cfquery datasource="#dts#">
            UPDATE app_tables
            SET current_order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">
            WHERE table_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(SESSION.wpos_table_id)#">
        </cfquery>
        <cfset emenuSyncTableOccupiedForOrder(dts, val(SESSION.wpos_table_id), orderId)>
        <cfcatch type="any"></cfcatch>
    </cftry>
</cfif>

<cfset emenuRecalculateOrderTotals(dts, orderId)>

<cflocation url="WaiterPOSPayment.cfm" addtoken="false">
