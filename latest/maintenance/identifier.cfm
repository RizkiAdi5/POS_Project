<cfif IsDefined('url.identifierno')>
	<cfset URLidentifierno = trim(urldecode(url.identifierno))>
</cfif>


<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="Create Identifier Profile">
		<cfset pageAction="Create">
		<cfset identifier = "">
        <cfset desp = "">
        
	<cfelseif url.action EQ "update">
		<cfset pageTitle="Update Identifier Profile">
		<cfset pageAction="Update">
		<cfquery name="getIdentifier" datasource='#dts#'>
            SELECT * 
            FROM identifier 
            WHERE identifierno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLidentifierno#">;
		</cfquery>
		
		<cfset identifier = getIdentifier.identifierno>
        <cfset desp = getIdentifier.desp>
                        
    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete Identifier Profile">
		<cfset pageAction="Delete">   
        
        <cfquery name="getIdentifier" datasource='#dts#'>
            SELECT * 
            FROM identifier 
            WHERE identifierno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLidentifierno#">;
		</cfquery>
		
		<cfset identifier = getIdentifier.identifierno>
        <cfset desp = getIdentifier.desp>     
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
<form class="formContainer form2Button" action="/latest/maintenance/identifierProcess.cfm?action=#url.action#" method="post" onsubmit="document.getElementById('identifier').disabled=false";>
	<div>#pageTitle#</div>
	<div>
		<table>
			<tr>
				<th><label for="identifier">Identifier</label></th>
				<td>
                	<input type="text" id="identifier" name="identifier" required="required" maxlength="10"
                    	<cfif IsDefined("url.action") AND url.action NEQ "create">  value="#URLidentifierno#"  disabled="true"</cfif>/>
                </td>
			</tr>
			<tr>
				<th><label for="desp">Description</label></th>
				<td>
                	<input type="text" id="desp" name="desp" value="#desp#" />                   
                </td>
			</tr> 
		</table>
	</div>
	<div>
		<input type="submit" value="#pageAction#" />
		<input type="button" value="Cancel" onclick="window.location='/latest/maintenance/identifierProfile.cfm'" />
	</div>
</form>
</cfoutput>
</body>
</html>