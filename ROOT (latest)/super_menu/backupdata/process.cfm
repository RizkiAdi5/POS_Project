<cfset currentURL =  CGI.SERVER_NAME>
<cfset serverhost = "localhost">
<cfset servername = "root">
<cfset serverpass = "123456">

<cftry>
<cffile
    action = "copy"
    source = "C:\Program Files (x86)\MySQL\MySQL Server 5.5\bin\mysqldump.exe"
    destination = "C:\railo\tomcat\webapps\ROOT\">
<cfcatch>
<cffile
    action = "copy"
    source = "C:\Program Files (x86)\MySQL\MySQL Server 5.5\bin\mysqldump.exe"
    destination = "C:\railo\tomcat\webapps\ROOT\">
</cfcatch>
</cftry>

<cfset currentDirectory = "C:\railo\tomcat\webapps\ROOT\POSBACKUP\"& dts>
<cfif DirectoryExists(currentDirectory) eq false>
<cfdirectory action = "create" directory = "#currentDirectory#" >
</cfif>
<cfset filename=dts&"_"&dateformat(now(),'YYYYMMDD')&"_"&timeformat(now(),'HHMMSS')&"_"&GetAuthUser()&"_"&trim(form.remark)&".sql">
<cfset currentdirfile=currentDirectory&"\"&filename>
<cfexecute name = "C:\railo\tomcat\webapps\ROOT\mysqldump"
    arguments = "--host=#serverhost# --user=#servername# --password=#serverpass# #dts#" outputfile="#currentdirfile#" timeout="720">
</cfexecute>

<cfset filesize = GetFileInfo('#currentdirfile#').size >

<!---<cfif filesize lt 200000>
<h1>Backup Failed! Please contact System Administrator!</h1>
<cfabort>
<cfelse>--->
<script type="text/javascript">
alert('Backup Complete!');
window.location.href="/super_menu/backupdata/index.cfm";
</script>
<!---</cfif>--->

