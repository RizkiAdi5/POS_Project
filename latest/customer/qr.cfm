<cfprocessingdirective pageencoding="UTF-8">
<cfinclude template="../../application.cfm">
<cfsetting showdebugoutput="false">

<!--- ================================================================
    QR Landing Page
    URL: /latest/customer/qr.cfm?t={qr_token}
    1. Validates the token against app_tables
    2. Sets table context in SESSION
    3. Redirects to login page
================================================================ --->

<cfparam name="url.t" default="">
<cfset token = trim(url.t)>

<!--- No token at all --->
<cfif NOT len(token)>
    <cfset qrError = "No QR code token provided. Please scan the QR code on your table.">
    <cfinclude template="qr_error.cfm">
    <cfabort>
</cfif>

<!--- Look up the table --->
<cftry>
    <cfquery name="qTable" datasource="#dts#">
        SELECT table_id, table_number, table_name, seats,
               location, floor_number, status, is_active
        FROM   app_tables
        WHERE  qr_token   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#token#">
        AND    is_active   = <cfqueryparam cfsqltype="cf_sql_tinyint"  value="1">
        LIMIT  1
    </cfquery>
    <cfcatch type="any">
        <cfset qrError = "Could not verify QR code. Please try again or ask staff for help.">
        <cfinclude template="qr_error.cfm">
        <cfabort>
    </cfcatch>
</cftry>

<!--- Token not found or table inactive --->
<cfif qTable.recordCount eq 0>
    <cfset qrError = "This QR code is not valid or has expired. Please ask staff for a new QR code.">
    <cfinclude template="qr_error.cfm">
    <cfabort>
</cfif>

<!--- Table is out of service --->
<cfif lCase(trim(qTable.status)) eq "inactive">
    <cfset qrError = "This table is currently not in service. Please ask staff for assistance.">
    <cfinclude template="qr_error.cfm">
    <cfabort>
</cfif>

<!--- 
    All good — store table context in session.
    Clear any previous order context (new scan = new session at that table).
--->
<cfset SESSION.emenu_table_id     = qTable.table_id>
<cfset SESSION.emenu_table_number = qTable.table_number>
<cfset SESSION.emenu_table_name   = len(trim(qTable.table_name)) ? trim(qTable.table_name) : "Table " & qTable.table_number>
<cfset SESSION.emenu_qr_token     = token>
<cfset SESSION.emenu_order_id     = "">

<!--- Redirect: if already logged in go straight to menu, else go to welcome --->
<cfif SESSION.emenu_loggedin eq "Yes" and len(SESSION.emenu_custno)>
    <cflocation url="/latest/customer/menu.cfm" addtoken="false">
<cfelse>
    <cflocation url="/latest/customer/welcome.cfm" addtoken="false">
</cfif>
