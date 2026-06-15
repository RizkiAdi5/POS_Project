<!---
    /latest/customer/open_order.cfm
    Validates the diner may open this order (guest session list + table, or loyalty custno + table),
    then sets SESSION emenu_order_* and redirects to order_status.cfm.
--->
<cfinclude template="../../application.cfm">

<cfif NOT len(trim(SESSION.emenu_table_id))>
    <cflocation url="/latest/customer/qr_error.cfm" addtoken="false">
</cfif>

<cfparam name="url.order_id" default="0">
<cfset oid = val(url.order_id)>
<cfif oid lte 0>
    <cflocation url="/latest/customer/my_orders.cfm" addtoken="false">
</cfif>

<cfset isGuest   = SESSION.emenu_is_guest eq "Yes">
<cfset isLoyalty = SESSION.emenu_loggedin eq "Yes" AND len(trim(SESSION.emenu_custno))>
<cfif NOT isGuest AND NOT isLoyalty>
    <cflocation url="/latest/customer/menu.cfm" addtoken="false">
</cfif>

<cfset tableId = val(SESSION.emenu_table_id)>
<cfset ok = false>
<cfset qChk = queryNew("order_id,order_number,total_amount")>

<cftry>
    <cfif isLoyalty>
        <cfquery name="qChk" datasource="#dts#">
            SELECT order_id, order_number, total_amount
            FROM   app_orders
            WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#oid#">
            AND    custno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(SESSION.emenu_custno)#">
            AND    table_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tableId#">
            LIMIT  1
        </cfquery>
    <cfelse>
        <cfif listFind(SESSION.emenu_guest_order_ids, toString(oid))>
            <cfquery name="qChk" datasource="#dts#">
                SELECT order_id, order_number, total_amount
                FROM   app_orders
                WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#oid#">
                AND    (custno IS NULL OR TRIM(IFNULL(custno,'')) = '')
                AND    table_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tableId#">
                LIMIT  1
            </cfquery>
        </cfif>
    </cfif>
    <cfif qChk.recordCount eq 1>
        <cfset ok = true>
    </cfif>
    <cfcatch type="any">
        <cfset ok = false>
    </cfcatch>
</cftry>

<cfif NOT ok>
    <cflocation url="/latest/customer/my_orders.cfm" addtoken="false">
</cfif>

<!--- Recalculate subtotal/tax from lines for session (confirm page pattern) --->
<cfset subtot = 0>
<cftry>
    <cfquery name="qSum" datasource="#dts#">
        SELECT COALESCE(SUM(subtotal), 0) AS s
        FROM   app_order_items
        WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#oid#">
    </cfquery>
    <cfif qSum.recordCount><cfset subtot = val(qSum.s)></cfif>
    <cfcatch type="any"><cfset subtot = 0></cfcatch>
</cftry>
<cfset taxAmt   = round(subtot * 0.10 * 100) / 100>
<cfset totalAmt = val(qChk.total_amount)>
<cfif totalAmt lte 0>
    <cfset totalAmt = subtot + taxAmt>
</cfif>

<cfset SESSION.emenu_order_id     = oid>
<cfset SESSION.emenu_order_number = trim(qChk.order_number)>
<cfset SESSION.emenu_order_total  = totalAmt>
<cfset SESSION.emenu_order_subtot = subtot>
<cfset SESSION.emenu_order_tax    = taxAmt>
<cfset SESSION.emenu_points_earned= 0>

<cflocation url="/latest/customer/order_status.cfm" addtoken="false">
