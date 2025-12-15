<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "385,95,386,98,148,65,96">
<cfinclude template="/latest/words.cfm">
<cfif IsDefined('url.colorid')>
	<cfset URLcolorid = trim(urldecode(url.colorid))>
</cfif>

<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="#words[385]#">
		<cfset pageAction="#words[95]#">
		<cfset material = "">
        <cfset desp = "">
        
	<cfelseif url.action EQ "update">
		<cfset pageTitle="#words[386]#">
		<cfset pageAction="#words[98]#">
		<cfquery name="getMaterial" datasource='#dts#'>
            SELECT * 
            FROM iccolorid 
            WHERE colorid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLcolorid#">;
		</cfquery>
		
		<cfset material = getMaterial.colorid>
        <cfset desp = getMaterial.desp>
                        
    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete Material Profile">
		<cfset pageAction="Delete">   
        
        <cfquery name="getMaterial" datasource='#dts#'>
            SELECT * 
            FROM iccolorid 
            WHERE colorid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLcolorid#">;
		</cfquery>
		
		<cfset material = getMaterial.colorid>
        <cfset desp = getMaterial.desp>     
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
<cfoutput>
<form class="formContainer form2Button" action="/latest/maintenance/materialProcess.cfm?action=#url.action#&menuID=#url.menuID#" method="post" onsubmit="document.getElementById('material').disabled=false";>
	<div>#pageTitle#</div>
	<div>
		<table>
			<tr>
				<th><label for="material">#words[148]#</label></th>
				<td>
                	<input type="text" id="material" name="material" required="required" 
						<cfif IsDefined("url.action") AND url.action NEQ "create"> value="#URLcolorid#" disabled="true"</cfif>/>
                </td>
			</tr>
			<tr>
				<th><label for="desp">#words[65]#</label></th>
				<td>
                	<input type="text" id="desp" name="desp" value="#desp#" />                   
                </td>
			</tr> 
		</table>
	</div>
	<div>
		<input type="submit" value="#pageAction#" />
		<input type="button" value="#words[96]#" onclick="window.location='/latest/maintenance/materialProfile.cfm?menuID=#url.menuID#'" />
	</div>
</form>
</cfoutput>
</body>
</html>