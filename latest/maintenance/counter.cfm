<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "586,95,587,98,585,65,588,96">
<cfinclude template="/latest/words.cfm">
<cfoutput>

<cfif IsDefined('url.counterID')>
	<cfset URLcounter = trim(urldecode(url.counterID))>
</cfif>

    <cfquery name="getBondUser" datasource='main'>
        SELECT userID 
        FROM users 
        WHERE userbranch='#dts#' 
        AND usergrpid <> "SUPER" 
        ORDER BY usergrpid;
    </cfquery>

<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="#words[586]#">
		<cfset pageAction="#words[95]#">
		<cfset counter = "">
        <cfset desp = "">
        <cfset bondUser = "">
        
	<cfelseif url.action EQ "update">
		<cfset pageTitle="#words[587]#">
		<cfset pageAction="#words[98]#">
        
		<cfquery name="getCounter" datasource='#dts#'>
            SELECT * 
            FROM counter 
            WHERE counterid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLcounter#">;
		</cfquery>
		
		<cfset counter = getCounter.counterid>
        <cfset desp = getCounter.counterdesp>
        <cfset bondUser = getCounter.bonduser>
                        
    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete Counter Profile">
		<cfset pageAction="Delete">   
        
		<cfquery name="getCounter" datasource='#dts#'>
            SELECT * 
            FROM counter 
            WHERE counterid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLcounter#">;
		</cfquery>
		
		<cfset counter = getCounter.counterid>
        <cfset desp = getCounter.counterdesp>
        <cfset bondUser = getCounter.bonduser>     
	</cfif>
    
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><cfoutput>#pageTitle#</cfoutput></title>
    <link rel="stylesheet" href="/latest/css/form.css" />
    <script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
    <!--[if (gte IE 6)&(lte IE 8)]>
        <script type="text/javascript" src="/latest/js/selectivizr/selectivizr-min.js"></script>
        <noscript><link rel="stylesheet" href="" /></noscript>
    <![endif]-->
</head>

<body class="container">

<form class="formContainer form2Button" action="/latest/maintenance/counterProcess.cfm?action=#url.action#" method="post" onsubmit="document.getElementById('counter').disabled=false";>
	<div>#pageTitle#</div>
	<div>
		<table>
			<tr>
				<th><label for="counter">#words[585]#</label></th>
				<td>
                	<input type="text" id="counter" name="counter" required="required" maxlength="25"
                    	<cfif IsDefined("url.action") AND url.action NEQ "create">  value="#URLcounter#"  disabled="true"</cfif>/>
                </td>
			</tr>
			<tr>
				<th><label for="desp">#words[65]#</label></th>
				<td>
                	<input type="text" id="desp" name="desp" value="#desp#" />                   
                </td>
			</tr> 
            <tr>
				<th><label for="bondUser">#words[588]#</label></th>
				<td>
                	<select id="bondUser" name="bondUser">
                        <cfloop query="getBondUser">
                            <option value>#userid#</option>
                        </cfloop>
                    </select>                  
                </td>
			</tr>
		</table>
	</div>
	<div>
		<input type="submit" value="#pageAction#" />
		<input type="button" value="#words[96]#" onclick="window.location='/latest/maintenance/counterProfile.cfm'" />
	</div>
</form>

</body>
</html>
</cfoutput>