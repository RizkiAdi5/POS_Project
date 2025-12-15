<cflogin>
	<cfif isdefined("form.userId") is false or isdefined("form.userPwd") is false>
		<cfinclude template="login.cfm">
		<cfabort>
	</cfif>
	<cfif isdefined('url.crmin') eq false>
	<cfset form.userPwd = hash(form.userPwd)>
	</cfif>
	<!--- Add on 120808 --->
	<cfif findnocase("_i",form.companyid) eq 0>
		<cfset form.companyid = form.companyid & "_i">
	</cfif>
    
    <!--- check bruteforce---> 
    <cfset nowtimezone = dateformat(dateadd('n',-15,now()),'YYYY-MM-DD')&" "&timeformat(dateadd('n',-15,now()),'HH:MM:SS')>
    <cfquery name="checkbrute" datasource="main">
    SELECT count(id) as idtry FROM tracklogin 
    where ip = '#cgi.remote_Addr#' 
    and timetry >= "#nowtimezone#"
    and companyid = <cfqueryparam cfsqltype="cf_sql_char" value="#form.companyid#"> 
    and userid = <cfqueryparam cfsqltype="cf_sql_char" value="#form.userid#">
    </cfquery>
	<cfif checkbrute.idtry gte 5>
    <cflocation url="/login/login.cfm?login=Failed&reason=brute">
    <cfabort/>
	</cfif>
    
    <cfquery datasource='main' name="getmulticompany">
	select comlist from multicomusers where userid=<cfqueryparam cfsqltype="cf_sql_char" value="#form.userid#">
	</cfquery>
    <cfif getmulticompany.recordcount neq 0>
    <cfset testcomlist=valuelist(getmulticompany.comlist)>
    <cfif ListFindNoCase(testcomlist,'#form.companyid#') GT 0>
    <cfset multicomlist=valuelist(getmulticompany.comlist)>
    </cfif>
    </cfif>
	<cfquery name="validateUser" datasource='main'>
		select 
		* 
		from users 
		where 
		userid=<cfqueryparam cfsqltype="cf_sql_char" value="#form.userid#">
		and userPwd=<cfqueryparam cfsqltype="cf_sql_char" value="#form.userpwd#">
        <cfif form.userId neq "ultracai" and form.userId neq "ultrack" and form.userId neq "ultrasw" and form.userId neq "ultrakahyin" and form.userId neq "ultratheresa" and form.userId neq "ultrasiong" and form.userId neq "ultranoon" and form.userId neq "ultralung" and form.userId neq "ultraedwin" and form.userId neq "ultrairene" and form.userId neq "ultraseeyoon" and form.userId neq "ultrauser1" and form.userId neq "ultrauser2" and form.userId neq "ultrauser3" and form.userId neq "ultrauser4" and form.userId neq "ultrauser5">
		and 
        <cfif isdefined('multicomlist')>
        <cfqueryparam cfsqltype="cf_sql_char" value="#form.companyid#"> in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#multicomlist#">)
        <cfelse>
        userbranch=<cfqueryparam cfsqltype="cf_sql_char" value="#form.companyid#">
        </cfif>
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



	<cfif validateUser.Recordcount eq 1 and (form.userId eq "ultracai" or form.userId eq "ultrack" or form.userId eq "ultrasw" or form.userId eq "ultrakahyin" or form.userId eq "ultratheresa" or form.userId eq "ultrasiong" or form.userId eq "ultranoon" or form.userId eq "ultralung" or form.userId eq "ultraedwin" or form.userId eq "ultrairene" or form.userId eq "ultraseeyoon" or form.userId eq "ultrauser1"  or form.userId eq "ultrauser2" or form.userId eq "ultrauser3" or form.userId eq "ultrauser4" or form.userId eq "ultrauser5" or isdefined('multicomlist'))>
    
    <cfif (form.companyid eq 'net_i' or form.companyid eq 'netm_i' or form.companyid eq 'netsm_i' or form.companyid eq 'nett_i')>
    <cfif form.userId eq "ultrairene" or form.userId eq "ultrasiong" or form.userId eq "ultrasw" or form.userId eq "ultraseeyoon" or form.userId eq "ultraedwin" or form.userId eq "ultralung" or form.userId eq "ultracai" or form.userId eq "ultrakahyin" or form.userId eq "ultrack">
    <cfelse>
    <cfabort>
    </cfif>
    </cfif>

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
    
  
                
                <cfif validateUser.linktoams eq "Y">
				<cfset linkdb = replacenocase('#form.companyid#',"_i","_a","all") >

    
			
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
</cfif>>