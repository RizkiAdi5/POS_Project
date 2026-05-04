<cfprocessingdirective pageencoding="UTF-8">
<cfinclude template="../../application.cfm">
<cfsetting showdebugoutput="false">

<!--- Clear all customer session vars --->
<cfset SESSION.emenu_loggedin     = "No">
<cfset SESSION.emenu_custno       = "">
<cfset SESSION.emenu_name         = "">
<cfset SESSION.emenu_email        = "">
<cfset SESSION.emenu_points       = 0>
<cfset SESSION.emenu_tier         = "">
<cfset SESSION.emenu_is_guest     = "No">
<cfset SESSION.emenu_order_id     = "">
<!--- Keep table context so QR doesn't need to be scanned again --->

<cflocation url="/latest/customer/account_choice.cfm" addtoken="false">
