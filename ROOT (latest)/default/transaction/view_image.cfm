<cfquery name="getimage" datasource="#dts#">
	select itemno,desp,despa,photo from icitem where itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.itemno#">
</cfquery>
<cfif getimage.photo neq "">
	<cfset photopath="/images/#hcomid#/"&getimage.photo>
	<div align="center"><cfoutput>
		<img height='400px' src='#photopath#' border='0'> <br>
		#getimage.itemno# - #getimage.desp# #getimage.despa#
	</cfoutput></div>
<cfelse>
	Sorry.. No images for this item.
</cfif>