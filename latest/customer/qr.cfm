<cfprocessingdirective pageencoding="UTF-8">
<cfinclude template="../../application.cfm">
<cfinclude template="inc_emenu_order.cfm">
<cfsetting showdebugoutput="false">

<!--- QR: token -> table + active session order (created by waiter regenerate) --->
<cfparam name="url.t" default="">
<cfset token = trim(url.t)>

<cfif NOT len(token)>
    <cfset qrError = "No QR code token provided. Please scan the QR code on your table.">
    <cfinclude template="qr_error.cfm">
    <cfabort>
</cfif>

<cftry>
    <cfquery name="qTable" datasource="#dts#">
        SELECT t.table_id, t.table_number, t.table_name, t.seats,
               t.location, t.floor_number, t.status, t.is_active,
               t.current_order_id, t.qr_token,
               o.order_id, o.order_number, o.status AS order_status
        FROM   app_tables t
        LEFT JOIN app_orders o ON o.order_id = t.current_order_id
        WHERE  t.qr_token = <cfqueryparam cfsqltype="cf_sql_varchar" value="#token#">
        AND    t.is_active = <cfqueryparam cfsqltype="cf_sql_tinyint" value="1">
        LIMIT  1
    </cfquery>
    <cfcatch type="any">
        <cfset qrError = "Could not verify QR code. Please try again or ask staff for help.">
        <cfinclude template="qr_error.cfm">
        <cfabort>
    </cfcatch>
</cftry>

<cfif qTable.recordCount eq 0>
    <cfset qrError = "This QR code is not valid or has expired. Please ask staff for a new QR code.">
    <cfinclude template="qr_error.cfm">
    <cfabort>
</cfif>

<cfif lCase(trim(qTable.status)) eq "inactive">
    <cfset qrError = "This table is currently not in service. Please ask staff for assistance.">
    <cfinclude template="qr_error.cfm">
    <cfabort>
</cfif>

<cfset bindOrderId = val(qTable.order_id)>
<cfset bindOrderNum = "">
<cfset bindOrderStatus = "">

<cfif bindOrderId gt 0>
    <cfset bindOrderNum = trim(toString(qTable.order_number))>
    <cfset bindOrderStatus = trim(toString(qTable.order_status))>
</cfif>

<!--- Fallback: latest open order on this table --->
<cfif bindOrderId lte 0 OR NOT emenuOrderIsOpen(bindOrderStatus)>
    <cfquery name="qOpenOrd" datasource="#dts#">
        SELECT order_id, order_number, status
        FROM   app_orders
        WHERE  table_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(qTable.table_id)#">
          AND  status NOT IN ('paid','cancelled','completed')
        ORDER  BY created_at DESC
        LIMIT  1
    </cfquery>
    <cfif qOpenOrd.recordCount>
        <cfset bindOrderId = val(qOpenOrd.order_id)>
        <cfset bindOrderNum = trim(qOpenOrd.order_number)>
        <cfset bindOrderStatus = trim(qOpenOrd.status)>
        <cftry>
            <cfquery datasource="#dts#">
                UPDATE app_tables
                SET current_order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#bindOrderId#">
                WHERE table_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(qTable.table_id)#">
            </cfquery>
            <cfcatch type="any"></cfcatch>
        </cftry>
    </cfif>
</cfif>

<cfif bindOrderId lte 0 OR NOT emenuOrderIsOpen(bindOrderStatus)>
    <cfset qrError = "No active order session for this table. Please ask staff to generate a new QR code.">
    <cfinclude template="qr_error.cfm">
    <cfabort>
</cfif>

<cfset emenuBindCustomerSession(qTable, bindOrderId, bindOrderNum, token)>

<cfif SESSION.emenu_loggedin eq "Yes" AND len(trim(SESSION.emenu_custno))>
    <cflocation url="/latest/customer/menu.cfm" addtoken="false">
<cfelse>
    <cflocation url="/latest/customer/welcome.cfm" addtoken="false">
</cfif>
