<cfquery name="getfilename" datasource="#dts#">
    select tenantno from POSFTP
</cfquery>

<cfheader name="Content-Type" value="txt">
<cfheader name="Content-Disposition" value="attachment; filename=#getfilename.tenantno##url.ndate#.txt">
<cfcontent type="application/x-zip-compressed" file="C:\railo\tomcat\webapps\ROOT\default\transaction\POSSubmission\#getfilename.tenantno##url.ndate#.txt">
