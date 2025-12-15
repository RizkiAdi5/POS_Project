<cfquery name="updatelastlogin" datasource="main">
	UPDATE users 
    SET 
    	lastlogin = '0000-00-00 00:00:00' 
    WHERE userid = '#huserid#' 
    AND userbranch = '#hcomid#'
</cfquery>

<cftry>
    <cfquery datasource="main">
    	INSERT INTO userlog(userlogid,userlogtime,udatabase,uipaddress,status,serverside) 
		VALUES(
				'#huserid#',
                NOW(),
                '#hcomid#',
                '#cgi.remote_Addr#',
                'Logout',
                'asia'
                )
    </cfquery>
	<cfcatch>
	</cfcatch>
</cftry>

<cflogout>
	<cfoutput> 
        <cfif IsDefined('url.goerp')>
            <cflocation url="http://erp#url.goerp#.netiquette.com.sg/index.cfm?logout=1" addtoken="no">
        </cfif>
        
        <script>
            window.open('/login/login.cfm?logout=yes', "_top");
        </script>
    </cfoutput>
<cfabort>