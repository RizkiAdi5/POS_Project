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
<cfset SESSION.emenu_is_guest     = "Yes">
<cfset SESSION.emenu_order_id     = "">
<!--- Keep table context — customer returns to menu as guest --->

<cflocation url="/latest/customer/menu.cfm" addtoken="false">
