<cfsetting showdebugoutput="no">
<cfquery name="deletepromotion" datasource="#dts#">
delete from promotion where promoid='#url.promoid#'
</cfquery>

<cfquery name="deletepromotion2" datasource="#dts#">
delete from promoitem where promoid='#url.promoid#'
</cfquery>
