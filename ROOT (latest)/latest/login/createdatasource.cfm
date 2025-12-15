 <cfset custom = StructNew()>
	<cfset mycustom = StructInsert(custom,"zeroDateTimeBehavior","convertToNull")>
 	<cfadmin
                action="updateDatasource"
                type="server"
                password="123456"
                classname="org.gjt.mm.mysql.Driver"
                dsn="jdbc:mysql://{host}:{port}/{database}"
                name="main"
                newname="main"
                host="localhost"
                
                database="main"
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
    	
        <cfadmin
                action="updateDatasource"
                type="server"
                password="123456"
                classname="org.gjt.mm.mysql.Driver"
                dsn="jdbc:mysql://{host}:{port}/{database}"
                name="#form.companyid#"
                newname="#form.companyid#"
                host="localhost"
                database="#form.companyid#"
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
               	

<cfquery name="updateUser" datasource="main">
UPDATE users SET userBranch="#form.companyid#", userDept="#form.companyid#"
WHERE userID IN ("adminpos","pos")
</cfquery>