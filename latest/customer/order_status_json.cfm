<!---
    /latest/customer/order_status_json.cfm
    Lightweight JSON endpoint polled by order_status.cfm every 15 seconds.
    Returns order + item status as JSON.
--->
<cfinclude template="../../application.cfm">
<cfcontent type="application/json; charset=utf-8">

<cfif NOT len(trim(SESSION.emenu_order_id))>
    <cfoutput>{"error":"no_order"}</cfoutput>
    <cfabort>
</cfif>

<cftry>
    <cfquery name="qOrder" datasource="#dts#">
        SELECT order_id, order_number, status, total_amount
        FROM   app_orders
        WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.emenu_order_id#">
        LIMIT  1
    </cfquery>

    <cfquery name="qItems" datasource="#dts#">
        SELECT item_id, quantity, status AS kitchen_status,
               COALESCE(item_name, item_code) AS item_name
        FROM   app_order_items
        WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.emenu_order_id#">
        ORDER  BY item_id ASC
    </cfquery>

    <cfset itemsArr = []>
    <cfloop query="qItems">
        <cfset arrayAppend(itemsArr, {
            "name"   : qItems.item_name,
            "qty"    : val(qItems.quantity),
            "status" : trim(qItems.kitchen_status)
        })>
    </cfloop>

    <cfset result = {
        "order_status" : trim(qOrder.status),
        "order_number" : trim(qOrder.order_number),
        "items"        : itemsArr
    }>

    <cfoutput>#serializeJSON(result)#</cfoutput>

    <cfcatch type="any">
        <cfoutput>{"error":"query_failed"}</cfoutput>
    </cfcatch>
</cftry>
