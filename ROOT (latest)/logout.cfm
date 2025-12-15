<cfquery name="updatelastlogin" datasource="main">
	update users set lastlogin = '0000-00-00 00:00:00' where userid = '#huserid#' and userbranch = '#hcomid#'
</cfquery>

<cftry>
<cfquery name="getdefaultlocation" datasource="#dts#">
        select ddllocation from gsetup
        </cfquery>
        
        <cfquery name="insert_user_logrecord" datasource="#dts#">
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
				<cfqueryparam cfsqltype="cf_sql_char" value="#huserid#">,
				now(),
				<cfqueryparam cfsqltype="cf_sql_char" value="#hcomid#">,
				'#cgi.remote_addr#',
				'Logout',<cfqueryparam cfsqltype="cf_sql_char" value="#getdefaultlocation.ddllocation#">
			)
		</cfquery>

<cfcatch></cfcatch>
</cftry>


<cflogout>
<cfoutput> 
<cfif lcase(HcomID) eq "simplysiti_i">
<script>
	window.open('http://simplysiti.fiatech.com.my/login/login.cfm?logout=yes', "_top");
</script>
<cfelse>
<script>
	window.open('/login/login.cfm?logout=yes', "_top");
</script>
</cfif> 
</cfoutput>
<cfabort>