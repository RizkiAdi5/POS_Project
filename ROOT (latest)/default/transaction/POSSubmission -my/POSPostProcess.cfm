<cfquery name="getfilename" datasource="#dts#">
    select * from POSFTP
</cfquery>
<cfset msg="Submission Success!!">
<cftry>

<cfquery name="getbillamount" datasource="#dts#">
    select HOUR(created_on) as created_hour from artran where type='CS' and wos_date='#form.ndate#' and (void ='' or void is null)
    group by HOUR(created_on)
    
    </cfquery>
    <cfloop query="getbillamount">

<cfftp connection="myConnection" server="#getfilename.ftphost#" username="#getfilename.ftpuser#" password="#getfilename.ftppass#" port="#getfilename.ftpport#" action="putfile"  localfile="C:\railo\tomcat\webapps\ROOT\default\transaction\POSSubmission\#getfilename.tenantno#_#form.ndate#_H_#created_hour#.txt" remoteFile="#getfilename.tenantno#_#form.ndate#_H_#created_hour#.txt" passive="yes"> 

</cfloop>
<cfcatch>
<cfset msg="Submission Failed!!">
</cfcatch></cftry>

<cfoutput>
   <form name="form1" id="form1" method="post" action="/default/transaction/POSSubmission/POSSubmission.cfm">
   <input type="hidden" name="msg" id="msg" value="#msg#" />
   </form>
   </cfoutput>
   
   <script>
	form1.submit();
	</script>