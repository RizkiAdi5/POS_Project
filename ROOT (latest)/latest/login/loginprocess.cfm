<cflogin>
	<cfif isdefined("form.userId") is false or isdefined("form.userPwd") is false>
		<cfinclude template="login.cfm">
		<cfabort>
	</cfif>
	
	<cfset form.userPwd = hash(form.userPwd)>
	
	<!--- Add on 120808 --->
	<cfif findnocase("_i",form.companyid) eq 0>
		<cfset form.companyid = form.companyid & "_i">
	</cfif>
    
    <!--- check bruteforce---> 
    <cfset nowtimezone = dateformat(dateadd('n',-15,now()),'YYYY-MM-DD')&" "&timeformat(dateadd('n',-15,now()),'HH:MM:SS')>
    <cftry>
    <cfquery name="checkbrute" datasource="main">
    SELECT count(id) as idtry FROM tracklogin 
    where ip = '#cgi.remote_Addr#' 
    and timetry >= "#nowtimezone#"
    and companyid = <cfqueryparam cfsqltype="cf_sql_char" value="#form.companyid#"> 
    and userid = <cfqueryparam cfsqltype="cf_sql_char" value="#form.userid#">
    </cfquery>
    <cfcatch>
    	<cfinclude template="createschemaandretoredatabase.cfm"> 
        <cfinclude template="createdatasource.cfm"> 
    
                   <cfquery name="checkbrute" datasource="main">
                    SELECT count(id) as idtry FROM tracklogin 
                    where ip = '#cgi.remote_Addr#' 
                    and timetry >= "#nowtimezone#"
                    and companyid = <cfqueryparam cfsqltype="cf_sql_char" value="#form.companyid#"> 
                    and userid = <cfqueryparam cfsqltype="cf_sql_char" value="#form.userid#">
                </cfquery>
        </cfcatch>
        </cftry>
    
	<cfif checkbrute.idtry gte 5>
    <cflocation url="/login/login.cfm?login=Failed&reason=brute">
    <cfabort/>
	</cfif>
	<cfquery name="validateUser" datasource='main'>
		select 
		* 
		from users 
		where 
		userid=<cfqueryparam cfsqltype="cf_sql_char" value="#form.userid#">
		and userPwd=<cfqueryparam cfsqltype="cf_sql_char" value="#form.userpwd#">
        <cfif form.userId neq "ultracai" and form.userId neq "ultrack" and form.userId neq "ultrasw" and form.userId neq "ultrakahyin" and form.userId neq "ultratheresa" and form.userId neq "ultrasiong" and form.userId neq "ultranoon" and form.userId neq "ultralung" and form.userId neq "ultraedwin" and form.userId neq "ultrairene" and form.userId neq "ultraseeyoon">
		and userbranch=<cfqueryparam cfsqltype="cf_sql_char" value="#form.companyid#">
		</cfif>
        and status = '1';
	</cfquery>
	<cfset validlogin = 1>
	<cfif ucase(form.companyid) eq "HOM">
		<cfset udb = "HOMAX">
	<cfelseif ucase(form.companyid) eq "KW">
		<cfset udb = "KAWAH">
	<cfelseif ucase(form.companyid) eq "ECN">
		<cfset udb = "GLOBAL_ECN">
	<cfelse>
		<cfset udb = form.companyid>
	</cfif>
	
	<cfif validateUser.Recordcount eq 1 and (form.userId eq "ultracai" or form.userId eq "ultrack" or form.userId eq "ultrasw" or form.userId eq "ultrakahyin" or form.userId eq "ultratheresa" or form.userId eq "ultrasiong" or form.userId eq "ultranoon" or form.userId eq "ultralung" or form.userId eq "ultraedwin" or form.userId eq "ultrairene" or form.userId eq "ultraseeyoon")>
    
    <cfquery name="checkuserlink" datasource="main">
    SELECT linktoams from users where userbranch=<cfqueryparam cfsqltype="cf_sql_char" value="#form.companyid#">
    </cfquery>
    <cfif checkuserlink.recordcount neq 0>
    <cfquery name="updatemain" datasource="main">
    Update users SET 
    userbranch = <cfqueryparam cfsqltype="cf_sql_char" value="#form.companyid#">, 
    userdept = <cfqueryparam cfsqltype="cf_sql_char" value="#form.companyid#">,
    linktoams = "#checkuserlink.linktoams#"
    WHERE
    USERID = <cfqueryparam cfsqltype="cf_sql_char" value="#form.userid#">
    and userPwd=<cfqueryparam cfsqltype="cf_sql_char" value="#form.userpwd#">
    </cfquery>
    	<cfquery name="validateUser" datasource='main'>
		select 
		* 
		from users 
		where 
		userid=<cfqueryparam cfsqltype="cf_sql_char" value="#form.userid#">
		and userPwd=<cfqueryparam cfsqltype="cf_sql_char" value="#form.userpwd#">
        and status = '1';
	</cfquery>
    
    <cfset validateUser.userBranch ="#form.companyid#">
    <cfelse>
    <cfset validlogin = 0>
	</cfif>
	</cfif>
	
	<cfif validateUser.Recordcount eq 1 and validlogin eq 1>
    
    	 <!--- Create Datasource for SS account creation
                <cfinvoke component="cfc.verify" method="VerifyDSN" dsn="#form.companyid#" returnvariable="result" /> --->
              	
    
				<!--- <cfif result eq "false" >
                <cfquery name="select_key" datasource="main">
                SELECT * FROM sec
                </cfquery>
                
                <cfset key = decrypt(#select_key.enc#,#select_key.keys#,#select_key.algo#,#select_key.encode#) >
                <cfset dbkey = decrypt(#select_key.dbkey#,#select_key.keys#,#select_key.algo#,#select_key.encode#) >
                
                <cfscript>
				  adminObj = createObject("component","cfide.adminapi.administrator");
				  adminObj.login("#key#");
				  myObj = createObject("component","cfide.adminapi.datasource");
				  myObj.setMySQL5(driver="MySQL5", 
				  name="#form.companyid#", 
				  host = "localhost", 
				  port = "3306",
				  database = "#form.companyid#",
				  username = "root",
				  password = "#dbkey#",
				  args = "zeroDateTimeBehavior=convertToNull",
				  login_timeout = "29",
				  timeout = "23",
				  interval = 6,
				  buffer = "64000",
				  blob_buffer = "64000",
				  description = "MYSQL 5",
				  pooling = true,
				  enableMaxConnections = "false",
				  maxConnections = "3000",
				  disable = false,
				  storedProc = true,
				  alter = true,
				  grant = true,
				  select = true,
				  update = true,
				  create = true,
				  delete = true,
				  drop = true,
				  revoke = true);
				</cfscript>
                </cfif> --->
                
                <cfif validateUser.linktoams eq "Y">
				<cfset linkdb = replacenocase('#form.companyid#',"_i","_a","all") >
				  <!--- <cfinvoke component="cfc.verify" method="VerifyDSN" dsn="#linkdb#" returnvariable="result1" />
              	 --->
    
				<!--- <cfif result1 eq "false" >
                <cfquery name="select_key" datasource="main">
                SELECT * FROM sec
                </cfquery>
                
                <cfset key = decrypt(#select_key.enc#,#select_key.keys#,#select_key.algo#,#select_key.encode#) >
                <cfset dbkey = decrypt(#select_key.dbkey#,#select_key.keys#,#select_key.algo#,#select_key.encode#) >
                
                <cfscript>
				  adminObj = createObject("component","cfide.adminapi.administrator");
				  adminObj.login("#key#");
				  myObj = createObject("component","cfide.adminapi.datasource");
				  myObj.setMySQL5(driver="MySQL5", 
				  name="#linkdb#", 
				  host = "119.73.212.37", 
				  port = "3306",
				  database = "#linkdb#",
				  username = "ams2",
				  password = "#key#",
				  args = "zeroDateTimeBehavior=convertToNull",
				  login_timeout = "29",
				  timeout = "23",
				  interval = 6,
				  buffer = "64000",
				  blob_buffer = "64000",
				  description = "MYSQL 5",
				  pooling = true,
				  enableMaxConnections = "false",
				  maxConnections = "3000",
				  disable = false,
				  storedProc = true,
				  alter = true,
				  grant = true,
				  select = true,
				  update = true,
				  create = true,
				  delete = true,
				  drop = true,
				  revoke = true);
				</cfscript>
                </cfif> --->
                </cfif>
                
		<cfloginuser name="#form.userid#" password="#form.userpwd#" roles="">
		
		<cfset time = now()>
		<cfset SESSION.loginTime = "#time#">
		<cfset SESSION.isLogIn = "Yes">
		<cfset SESSION.userCty = "#validateUser.userBranch#">
		<cfset SESSION.pass = form.userPwd>
		
		<cfquery name="insert_user_log" datasource="main">
			insert into userlog 
			(
				userlogid,
				userlogtime,
				udatabase,
				uipaddress,
				status
			) 
			values
			(
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.userid#">,
				now(),
				<cfqueryparam cfsqltype="cf_sql_char" value="#udb#">,
				'#cgi.remote_addr#',
				'Success'
			)
		</cfquery>
        
        <cfquery name="getdefaultlocation" datasource="#udb#">
        select ddllocation from gsetup
        </cfquery>
        
        <cfquery name="insert_user_logrecord" datasource="#udb#">
			insert into poslog 
			(
				userlogid,
				userlogtime,
				udatabase,
				uipaddress,
				status,
                location
			) 
			values
			(
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.userid#">,
				now(),
				<cfqueryparam cfsqltype="cf_sql_char" value="#udb#">,
				'#cgi.remote_addr#',
				'Success',<cfqueryparam cfsqltype="cf_sql_char" value="#getdefaultlocation.ddllocation#">
			)
		</cfquery>

        <cfquery name="resetbrute" datasource="main">
        DELETE FROM tracklogin WHERE companyid = <cfqueryparam cfsqltype="cf_sql_char" value="#udb#">
        and userid = <cfqueryparam cfsqltype="cf_sql_char" value="#form.userid#">
        </cfquery>
        
        <cfquery name="deleteallold" datasource="main">
		DELETE FROM tracklogin where timetry < "#nowtimezone#"
        </cfquery>
				
		<cfquery name="update_user_last_login" datasource="main">
			update users set 
			lastlogin=#now()# 
			where userid=<cfqueryparam cfsqltype="cf_sql_char" value="#form.userid#"> 
			and userpwd=<cfqueryparam cfsqltype="cf_sql_char" value="#form.userpwd#"> 
			and userbranch=<cfqueryparam cfsqltype="cf_sql_char" value="#form.companyid#"> 
		</cfquery>
	<cfelse>
		<!--- <cfloginuser name="#form.userid#" password="#form.userpwd#" roles="">
		
		<cfset time = now()>
		<cfset SESSION.loginTime = "#time#">
		<cfset SESSION.isLogIn = "Yes">
		<cfset SESSION.userCty = "#validateUser.userBranch#">
		<cfset SESSION.pass = form.userpwd> --->
		
		<cfquery datasource="main">
			insert into userlog 
			(
				userlogid,
				userlogtime,
				udatabase,
				uipaddress,
				status
			) 
			values 
			(
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.userid#">,
				now(),
				<cfqueryparam cfsqltype="cf_sql_char" value="#udb#">,
				'#cgi.remote_Addr#',
				'Failure'
			)
		</cfquery>
        
        <cfquery name="trackbruteforce" datasource="main">
        INSERT INTO tracklogin (ip,companyid,timetry,userid)
        VALUES ('#cgi.remote_Addr#',<cfqueryparam cfsqltype="cf_sql_char" value="#udb#">,now(),<cfqueryparam cfsqltype="cf_sql_char" value="#form.userid#"> )
        </cfquery>
		
		<cflocation url="../login/login.cfm?login=Failed">
		<cfabort>
	</cfif>
</cflogin>

<cfif isdefined("SESSION.isLogIn") and SESSION.ISLOGIN eq "Yes" and CGI.SCRIPT_NAME eq "login.cfm">
	<h1>You are already logged in.</h1>
	<cflocation url="../home.cfm">
</cfif>
