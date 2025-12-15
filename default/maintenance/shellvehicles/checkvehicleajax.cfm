<cfsetting showdebugoutput="no">

<cfquery name="checkvehicleexist" datasource="#dts#">
select entryno from vehicles
where entryno = "#url.entryno#"
</cfquery>
<cfif checkvehicleexist.recordcount gt 0>
<h3>This Vehicle No Already Existed</h3>
</cfif>