<!---<cfif IsDefined("url.logout")>
	<cfif IsDefined ("session.id")>
		<cfset dummy = StructDelete(application.sessiontracker, "#session.company_name#(#session.id#)")>
		<cfset session.islogin="No">
	</cfif>
</cfif>

<cfset currentURL = CGI.SERVER_NAME>
<cfset HTTPreferer = CGI.HTTP_REFERER>

<cfif right(currentURL,4) NEQ "asia">
	<cfif cgi.SERVER_PORT_SECURE eq 0>
		<cflocation addtoken="no" url="https://#currentURL#">
	</cfif>
</cfif>
<cfif findnocase('pro',CGI.SERVER_NAME) NEQ 0>
<cfelse>
	<cfif isdefined('url.loaddone') eq false>
		<cfset serverkey = "">
        <cfif CGI.SERVER_NAME eq "ims.netiquette.com.sg" or CGI.SERVER_NAME eq "ims2.netiquette.com.sg" or CGI.SERVER_NAME eq "ims.autoserv.sg" or CGI.SERVER_NAME eq "ims2.autoserv.sg">
			<cfif mid(currentURL,'4','1') eq "2">
				<cfset servername = "appserver2">
			<cfelse>
				<cfset servername = "appserver1">
			</cfif>
			<cfset serverkey = "sg">
            
		<cfelseif CGI.SERVER_NAME eq "ims.netiquette.asia" or CGI.SERVER_NAME eq "ims2.netiquette.asia" or CGI.SERVER_NAME eq "ims2-hk.netiquette.asia" or CGI.SERVER_NAME eq "ims-hk.netiquette.asia">
			<cfif mid(currentURL,'4','1') eq "2">
				<cfset servername = "appserver2">
			<cfelse>
				<cfset servername = "appserver1">
			</cfif>
			<cfset serverkey = "asia">
        
		<cfelseif CGI.SERVER_NAME eq "imsmy.netiquette.com.sg" or CGI.SERVER_NAME eq "ims-my.netiquette.asia" 
or CGI.SERVER_NAME eq "cloudims.celcom.com.my">
			<cfset serverkey = "exa">
           
 
                <cfset servername = "appserver1">

		</cfif>

        <cfquery name="checkload" datasource="loadbalance">
            SELECT servername,serveraddress 
            FROM redirection 
            WHERE applicationtype = "IMS" 
            AND serverside = "#serverkey#" 
            ORDER BY memoryload DESC;
        </cfquery>
    
        <cfif checkload.servername neq servername>
            <cfif right(currentURL,11) eq "autoserv.sg">
                <cflocation url="#replace(checkload.serveraddress,'netiquette.com.sg','autoserv.sg','all')#?loaddone=yes" addtoken="no"> 
            <cfelse>
                <cflocation url="#checkload.serveraddress#?loaddone=yes" addtoken="no"> 
            </cfif>
        </cfif>
	</cfif>
</cfif>--->


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-Equiv="Cache-Control" Content="no-cache">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>Netiquette Inventory Management System | Login</title>
    <link rel="shortcut icon" href="/IMS.ico" />
    <link rel="stylesheet" type="text/css" href="/latest/css/style.css" />
    <link rel="stylesheet" type="text/css" href="/latest/css/lessframework4.css" />
</head>

<body>
	<div class="main fix">
		<div class="header_area fix">
			<div class="header structure fix">
				<img src="/latest/img/login/head_text.png" alt="Netiquette Logo" />
			</div>
		</div>
        
		<div class="main_body_area fix">
			<div class="main_body structure fix">
				<cfif IsDefined("url.status")>
               		<cfif url.status EQ 'failed'>
                		<cfset message = "Incorrect User ID or Password. Please try again.">
                    <cfelse>
                        <cfset message = "You have been blocked for too many attempts! Please try again after 30 minutes!">
                    </cfif>    
					<h2 style="color:red;">Login Error</h2>
					<p style="color:red; text-align:center"><cfoutput>#message#</cfoutput></p>
				<cfelseif IsDefined("url.logout")>
					<h3>You had been successfully logged off!</h3>
					<p style="text-align:center;">Please enter your User ID, Password and Company ID.</p>
				<cfelse>
					<h2>Secured Login</h2>
					<p style="text-align:center;">Please enter your User ID, Password and Company ID.</p>
				</cfif>
                
				<div class="form_heading fix">
					<img src="/latest/img/login/logo.png" alt="Netiquette IMS Logo" />
				</div>
                
				<div class="input fix">
					<form action="/index.cfm" method="post" target="_parent">
						<p>User ID</p>
						<input type="text" name="userId" id="userId" autofocus="autofocus" required="yes" maxlength="50"/>
						<p>Password</p>
						<input type="password" name="userPwd" id="userPwd" required="yes" autocomplete="off" maxlength="32"/>
						<p>Company ID</p>
						<input type="text" name="companyid" id="companyid" required="yes" maxlength="50"/>
						<div class="sign">
							<input type="submit" name="submit" id="submit" value="Login" />
						</div>
					</form>
				</div>
			</div>
            
			<p id="secured"><img src="/latest/img/login/lock.png" alt="Lock Icon" /> This website is secured by 256-bit SSL security</p>
			<div class="right">
				<a href="http://crm.netiquette.com.sg/signupnew/signup.cfm">
					<p id="user" class="link_color">Not A User Yet?</p>
					<p id="sign">Sign Up Here</p>
				</a>
			</div>
		</div>
	</div>
</body>
</html>

<script type="text/javascript">
	if(window.self != window.parent){
		parent.location.replace("/logout.cfm");
	}
</script>
