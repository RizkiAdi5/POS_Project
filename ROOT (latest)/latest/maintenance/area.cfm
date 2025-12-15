<cfif IsDefined('url.area')>
	<cfset URLarea = trim(urldecode(url.area))>
</cfif>


<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="Create Area Profile">
		<cfset pageAction="Create">
		<cfset area = "">
        <cfset desp = "">
        
	<cfelseif url.action EQ "update">
		<cfset pageTitle="Update Area Profile">
		<cfset pageAction="Update">
		<cfquery name="getArea" datasource='#dts#'>
            SELECT * 
            FROM #target_icarea# 
            WHERE area=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLarea#">;
		</cfquery>
		
		<cfset area = getArea.area>
        <cfset desp = getArea.desp>
                        
    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete Area Profile">
		<cfset pageAction="Delete">   
        
        <cfquery name="getArea" datasource='#dts#'>
            SELECT * 
            FROM #target_icarea# 
            WHERE area=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLarea#">;
		</cfquery>
		
		<cfset area = getArea.area>
        <cfset desp = getArea.desp>     
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
<form class="formContainer form2Button" action="/latest/maintenance/areaProcess.cfm?action=#url.action#" method="post" onsubmit="document.getElementById('area').disabled=false";>
	<div>#pageTitle#</div>
	<div>
		<table>
			<tr>
				<th><label for="area">Area</label></th>
				<td>
                	<input type="text" id="area" name="area" required="required" maxlength="25"
                    	<cfif IsDefined("url.action") AND url.action NEQ "create">  value="#URLarea#"  disabled="true"</cfif>/>
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
		<input type="button" value="Cancel" onclick="window.location='/latest/maintenance/areaProfile.cfm'" />
	</div>
</form>
</cfoutput>
</body>
</html>