<!---
    /latest/Waiter/WaiterPOSTables.cfm
    JSON endpoint backing the Waiter POS table picker: read-only board of
    dine-in tables with their live status (available/occupied/paid/reserved)
    and, for occupied/paid tables, the existing order's items — so staff can
    see what's already on a table before picking it, without a page reload.
--->
<cfprocessingdirective pageencoding="UTF-8">
<cfinclude template="/application.cfm">
<cfinclude template="/latest/customer/inc_emenu_order.cfm">
<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfset tables = emenuGetDineInTableBoard(dts)>

<cfcontent type="text/json; charset=utf-8" reset="true">
<cfoutput>#serializeJSON({ "ok" = true, "tables" = tables })#</cfoutput>
