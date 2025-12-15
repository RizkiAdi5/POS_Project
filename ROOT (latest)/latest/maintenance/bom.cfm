<cfif IsDefined('url.itemno')>
	<cfset URLbom = trim(urldecode(url.itemno))>
</cfif>

<cfquery name="getgsetup" datasource="#dts#">
	SELECT * from gsetup
</cfquery>
<cfset c_Period = getgsetup.Period>

<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="Create B.O.M Profile">
		<cfset pageAction="Create">
		<cfset item = "">
        <cfset bom = "">
              
	<cfelseif url.action EQ "update">
		<cfset pageTitle="Update B.O.M Profile">
		<cfset pageAction="Update">
        <cfquery name="getBom" datasource='#dts#'>
            SELECT * 
            FROM billmat 
            WHERE itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLbom#">;
		</cfquery>
		
		<cfset item = getBom.itemno>
        <cfset bom = getBom.bomno>
                  
    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete B.O.M Profile">
		<cfset pageAction="Delete">   
        
        <cfelseif url.action EQ "update">
		<cfset pageTitle="Update B.O.M Profile">
		<cfset pageAction="Update">
        <cfquery name="getBom" datasource='#dts#'>
            SELECT * 
            FROM billmat 
            WHERE itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLbom#">;
		</cfquery>
		
		<cfset item = getBom.itemno>
        <cfset bom = getBom.bomno>   
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
    
	<cfinclude template="/latest/filter/filterItem.cfm">
    <link rel="stylesheet" href="/latest/css/select2/select2.css" />
    <script type="text/javascript" src="/latest/js/select2/select2.min.js"></script>
</head>

<body class="container">
<cfoutput>
<form class="formContainer form2Button" action="/latest/maintenance/bomProcess.cfm?action=#url.action#" method="post" onsubmit="document.getElementById('item').disabled=false";>
	<div>#pageTitle#</div>
	<div>
		<table>
        	<tr>
				<th><label for="item">Item</label></th>
				<td>
                	<input type="hidden" id="item" name="item" class="itemFilter" required="required" data-placeholder="#item#" <cfif IsDefined("url.action") AND url.action NEQ "create">disabled="true"</cfif> />	                   
                </td>
			</tr>
            
			<tr>
				<th><label for="bom">B.O.M No</label></th>
				<td>
                	<input type="text" id="bom" name="bom" value="#bom#" required="required"/>
                </td>
			</tr>
    	</table>
	</div>
	<div>
		<input type="submit" value="#pageAction#" />
		<input type="button" value="Cancel" onclick="window.location='/latest/maintenance/bomProfile.cfm'"/>
	</div>
</form>
</cfoutput>
</body>
</html>