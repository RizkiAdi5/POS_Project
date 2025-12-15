<cfsetting showdebugoutput="yes">
<cfquery name="updateonhold" datasource="#dts#">
	update ictrantemp set onhold='Y',rem9='#remark#' where uuid='#uuid#'
</cfquery>
