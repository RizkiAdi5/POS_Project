<cfprocessingdirective pageencoding="UTF-8">
<cfinclude template="../../application.cfm">
<cfsetting showdebugoutput="false">

<!--- No table context — send back to QR error --->
<cfif NOT len(trim(SESSION.emenu_table_id))>
    <cflocation url="/latest/customer/qr_error.cfm" addtoken="false">
</cfif>

<!--- Set guest session — no custno, loggedin stays No --->
<cfset SESSION.emenu_loggedin = "No">
<cfset SESSION.emenu_custno   = "">
<cfset SESSION.emenu_name     = "Guest">
<cfset SESSION.emenu_email    = "">
<cfset SESSION.emenu_is_guest = "Yes">

<cflocation url="/latest/customer/menu.cfm" addtoken="false">
