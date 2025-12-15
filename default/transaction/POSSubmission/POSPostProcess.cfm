<cfquery name="getfilename" datasource="#dts#">
    select * from POSFTP
</cfquery>
<cfset msg="Submission Success!!">


<cfif getfilename.mall eq 'smp313'>
<cfftp connection="myConnection" server="#getfilename.ftphost#" username="#getfilename.ftpuser#" password="#getfilename.ftppass#" port="#getfilename.ftpport#" action="putfile"  localfile="C:\railo\tomcat\webapps\ROOT\default\transaction\POSSubmission\#getfilename.tenantno#_#form.ndate#_#form.timenow#.txt" remoteFile="#getfilename.tenantno#_#dateformat(form.ndate,'YYYYMMDD')#_#timeformat(now(),'HHMMSS')#.txt" passive="yes"> 

<cfelseif getfilename.mall eq 'katong112'>
<cfftp connection="myConnection" server="#getfilename.ftphost#" username="#getfilename.ftpuser#" password="#getfilename.ftppass#" port="#getfilename.ftpport#" action="putfile"  localfile="C:\railo\tomcat\webapps\ROOT\default\transaction\POSSubmission\h#getfilename.tenantno#_01_#getfilename.tranno#_#form.ndate##left(form.timenow,4)#.txt" remoteFile="h#getfilename.tenantno#_01_#getfilename.tranno#_#form.ndate##left(form.timenow,4)#.txt" passive="yes"> 

<cfelseif getfilename.mall eq 'capitaland'>
<cfftp connection="myConnection" server="#getfilename.ftphost#" username="#getfilename.ftpuser#" password="#getfilename.ftppass#" port="#getfilename.ftpport#" action="putfile"  localfile="C:\railo\tomcat\webapps\ROOT\default\transaction\POSSubmission\D#getfilename.tenantno#.#getfilename.tranno#" remoteFile="D#getfilename.tenantno#.#numberformat(val(getfilename.tranno),'000')#" passive="yes"> 

<cfelseif getfilename.mall eq 'serangoon'>
<cfftp connection="myConnection" server="#getfilename.ftphost#" username="#getfilename.ftpuser#" password="#getfilename.ftppass#" port="#getfilename.ftpport#" action="putfile"  localfile="C:\railo\tomcat\webapps\ROOT\default\transaction\POSSubmission\#form.afilename#" remoteFile="#form.afilename#" passive="yes"> 


<cfelse>
<cfftp connection="myConnection" server="#getfilename.ftphost#" username="#getfilename.ftpuser#" password="#getfilename.ftppass#" port="#getfilename.ftpport#" action="putfile"  localfile="C:\railo\tomcat\webapps\ROOT\default\transaction\POSSubmission\#getfilename.tenantno##form.ndate#.txt" remoteFile="#getfilename.tenantno##form.ndate#.txt" passive="yes"> 
</cfif>


<cfoutput>
   <form name="form1" id="form1" method="post" action="/default/transaction/POSSubmission/POSSubmission.cfm">
   <input type="hidden" name="msg" id="msg" value="#msg#" />
   </form>
   </cfoutput>
   
   <script>
	form1.submit();
	</script>