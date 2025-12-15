<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "454,95,455,98,452,65,453,96">
<cfinclude template="/latest/words.cfm">
<cfif IsDefined('url.business')>
	<cfset URLbusiness = trim(urldecode(url.business))>
</cfif>


<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="#words[454]#">
		<cfset pageAction="#words[95]#">
		<cfset business = "">
        <cfset desp = "">
        <cfset priceLevel = "1">
        
	<cfelseif url.action EQ "update">
		<cfset pageTitle="#words[455]#">
		<cfset pageAction="#words[98]#">
		<cfquery name="getBusiness" datasource='#dts#'>
            SELECT * 
            FROM business 
            WHERE business=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLbusiness#">;
		</cfquery>
		
		<cfset business = getBusiness.business>
        <cfset desp = getBusiness.desp>
        <cfset priceLevel = getBusiness.pricelvl>
                        
    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete Business Profile">
		<cfset pageAction="Delete">   
        
        <cfquery name="getBusiness" datasource='#dts#'>
            SELECT * 
            FROM business 
            WHERE business=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLbusiness#">;
		</cfquery>
		
		<cfset business = getBusiness.business>
        <cfset desp = getBusiness.desp> 
        <cfset priceLevel = getBusiness.pricelvl>    
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
<form class="formContainer form2Button" action="/latest/maintenance/businessProcess.cfm?action=#url.action#" method="post" onsubmit="document.getElementById('business').disabled=false";>
	<div>#pageTitle#</div>
	<div>
		<table>
			<tr>
				<th><label for="business">#words[452]#</label></th>
				<td>
                	<input type="text" id="business" name="business" required="required" maxlength="25"
                    	<cfif IsDefined("url.action") AND url.action NEQ "create">  value="#URLbusiness#"  disabled="true"</cfif>/>
                </td>
			</tr>
			<tr>
				<th><label for="desp">#words[65]#</label></th>
				<td>
                	<input type="text" id="desp" name="desp" value="#desp#" />                   
                </td>
			</tr> 
			<tr>
				<th><label for="priceLevel">#words[453]#</label></th>
				<td>
                	<select id="priceLevel" name="priceLevel">
            			<cfloop list="1,2,3,4,5,6" index="i">
            				<option value="#i#" <cfif priceLevel eq i>Selected</cfif>>#i#</option>
            			</cfloop>
            		</select>	     
                </td>
			</tr>            
		</table>
	</div>
	<div>
		<input type="submit" value="#pageAction#" />
		<input type="button" value="#words[96]#" onclick="window.location='/latest/maintenance/businessProfile.cfm'" />
	</div>
</form>
</cfoutput>
</body>
</html>



