<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "360,95,361,98,123,65,96">
<cfinclude template="/latest/words.cfm">
<cfif IsDefined('url.cate')>
	<cfset URLcate = trim(urldecode(url.cate))>
</cfif>


<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="#words[360]#">
		<cfset pageAction="#words[95]#">
		<cfset category = "">
        <cfset desp = "">
        
	<cfelseif url.action EQ "update">
		<cfset pageTitle="#words[361]#">
		<cfset pageAction="#words[98]#">
		<cfquery name="getCategory" datasource='#dts#'>
            SELECT * 
            FROM iccate 
            WHERE cate=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLcate#">;
		</cfquery>
		
		<cfset category = getCategory.cate>
        <cfset desp = getCategory.desp>
                        
    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete Category Profile">
		<cfset pageAction="Delete">   
        
        <cfquery name="getCategory" datasource='#dts#'>
            SELECT * 
            FROM iccate 
            WHERE cate=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLcate#">;
		</cfquery>
		
		<cfset category = getCategory.cate>
        <cfset desp = getCategory.desp>     
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
<form class="formContainer form2Button" action="/latest/maintenance/categoryProcess.cfm?action=#url.action#&menuID=#url.menuID#" method="post" onsubmit="document.getElementById('category').disabled=false";>
	<div>#pageTitle#</div>
	<div>
		<table>
			<tr>
				<th><label for="category">#words[123]#</label></th>
				<td>
                	<input type="text" id="category" name="category" required="required" maxlength="50"
                    	<cfif IsDefined("url.action") AND url.action NEQ "create">  value="#URLcate#"  disabled="true"</cfif>/>
                </td>
			</tr>
			<tr>
				<th><label for="desp">#words[65]#</label></th>
				<td>
                	<input type="text" id="desp" name="desp" value="#desp#" maxlength="40"/>                   
                </td>
			</tr> 
		</table>
	</div>
	<div>
		<input type="submit" value="#pageAction#" />
		<input type="button" value="#words[96]#" onclick="window.location='/latest/maintenance/categoryProfile.cfm?menuID=#url.menuID#'" />
	</div>
</form>
</cfoutput>
</body>
</html>