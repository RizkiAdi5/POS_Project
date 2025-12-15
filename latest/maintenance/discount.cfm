<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "593,95,594,98,592,65,96">
<cfinclude template="/latest/words.cfm">
<cfif IsDefined('url.discount')>
	<cfset URLdiscount = trim(urldecode(url.discount))>
</cfif>


<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="#words[593]#">
		<cfset pageAction="#words[95]#">
		<cfset discount = "">
        <cfset desp = "">
        
	<cfelseif url.action EQ "update">
		<cfset pageTitle="#words[594]#">
		<cfset pageAction="#words[98]#">
		<cfquery name="getDiscount" datasource='#dts#'>
            SELECT * 
            FROM discount 
            WHERE discount=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLdiscount#">;
		</cfquery>
		
		<cfset discount = getDiscount.discount>
        <cfset desp = getDiscount.desp>
                        
    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete Discount Profile">
		<cfset pageAction="Delete">   
        
        <cfquery name="getDiscount" datasource='#dts#'>
            SELECT * 
            FROM discount 
            WHERE discount=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLdiscount#">;
		</cfquery>
		
		<cfset discount = getDiscount.discount>
        <cfset desp = getDiscount.desp>     
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
<form class="formContainer form2Button" action="/latest/maintenance/discountProcess.cfm?action=#url.action#" method="post" onsubmit="document.getElementById('discount').disabled=false";>
	<div>#pageTitle#</div>
	<div>
		<table>
			<tr>
				<th><label for="discount">#words[592]#</label></th>
				<td>
                	<input type="text" id="discount" name="discount" required="required" maxlength="25"
                    	<cfif IsDefined("url.action") AND url.action NEQ "create">  value="#URLdiscount#"  disabled="true"</cfif>/>
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
        <input type="button" value="#words[96]#" onclick="window.location='/latest/maintenance/discountProfile.cfm'" class="btn btn-default" />
    </div>
</form>
</cfoutput>
</body>
</html>