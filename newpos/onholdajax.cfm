<cfsetting showdebugoutput="yes">

<cfquery name="updateonhold" datasource="#dts#">
	update ictrantemp set onhold='Y' where uuid='#uuid#'
</cfquery>