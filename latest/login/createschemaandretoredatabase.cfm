
<cfoutput>
 <cfset custom = StructNew()>
	<cfset mycustom = StructInsert(custom,"zeroDateTimeBehavior","convertToNull")>
    <cfset companyid =replace(form.companyid,"_i","","all")>
 	<cfadmin
                action="updateDatasource"
                type="server"
                password="123456"
                classname="org.gjt.mm.mysql.Driver"
                dsn="jdbc:mysql://{host}:{port}/{database}"
                name="test"
                newname="test"
                host="localhost"
                database="test"
                port="3306"
                dbusername="root"
                dbpassword="123456"
                connectionTimeout="1"
                blob="false"
                clob="false"
                allowed_select="true"
                allowed_insert="true"
                allowed_update="true"
                allowed_delete="true"
                allowed_alter="true"
                allowed_drop="true"
                allowed_revoke="true"
                allowed_create="true"
                allowed_grant="true"
                custom="#custom#">

<cfquery name="createdb" datasource="test">
CREATE DATABASE #form.companyid#
</cfquery>
<cftry>
<cfadmin
                action="updateDatasource"
                type="server"
                password="123456"
                classname="org.gjt.mm.mysql.Driver"
                dsn="jdbc:mysql://{host}:{port}/{database}"
                name="#companyid#sync"
                newname="#companyid#sync"
                host="db.netiquette.com.sg"
                database="#form.companyid#"
                port="3306"
                dbusername="pos#companyid#"
                dbpassword="Toapayoh831"
                connectionTimeout="1"
                blob="false"
                clob="false"
                allowed_select="true"
                allowed_insert="true"
                allowed_update="true"
                allowed_delete="true"
                allowed_alter="true"
                allowed_drop="true"
                allowed_revoke="true"
                allowed_create="true"
                allowed_grant="true"
                custom="#custom#">
<cfcatch>
<cflocation url="../login/login.cfm?login=Failed">
<cfabort>
</cfcatch>
</cftry>
<cfquery name="createmaindb" datasource="test">
CREATE DATABASE main
</cfquery>

<cfset serverhost = "localhost">
<cfset servername = "root">
<cfset serverpass = "123456">

<cfset currentDirectory = "C:\railo\tomcat\webapps\ROOT\BackUpPos\">
<cfset runfile = currentDirectory&"createmain.bat">
<cfset filename="mainpos.sql">
<cfset filecontent = currentDirectory&"mysql.exe "&" --host=#serverhost# --user=#servername# --password=#serverpass# "&"main"&" < "&currentDirectory&filename>
<cffile action="Write"
            file="#runfile#"
            output="#filecontent#" nameconflict="overwrite">

<cfexecute name = "#runfile#" timeout="720">
</cfexecute>

<cfset currentDirectory = "C:\railo\tomcat\webapps\ROOT\BackUpPos\">
<cfset runfile = currentDirectory&form.companyid&".bat">
<cfset filename="emptyposnew.sql">
<cfset filecontent = currentDirectory&"mysql.exe "&" --host=#serverhost# --user=#servername# --password=#serverpass# "&form.companyid&" < "&currentDirectory&filename>
<cffile action="Write"
            file="#runfile#"
            output="#filecontent#" nameconflict="overwrite">

<cfexecute name = "#runfile#" timeout="720">
</cfexecute>
</cfoutput>
