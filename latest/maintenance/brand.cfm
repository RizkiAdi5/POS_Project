<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "355,95,356,98,122,65,96">
<cfinclude template="/latest/words.cfm">
<cfif IsDefined('url.brand')>
	<cfset URLbrand = trim(urldecode(url.brand))>
</cfif>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="#words[355]#">
		<cfset pageAction="#words[95]#">
		<cfset category = "">
        <cfset desp = "">

	<cfelseif url.action EQ "update">
		<cfset pageTitle="Update Brand Profile">
		<cfset pageAction="Update">
		<cfquery name="getBrand" datasource='#dts#'>
            SELECT *
            FROM brand
            WHERE brand=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLbrand#">;
		</cfquery>

		<cfset brand = getBrand.brand>
        <cfset desp = getBrand.desp>

    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete Brand Profile">
		<cfset pageAction="Delete">

        <cfquery name="getBrand" datasource='#dts#'>
            SELECT *
            FROM brand
            WHERE brand=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLbrand#">;
		</cfquery>

		<cfset brand = getBrand.brand>
        <cfset desp = getBrand.desp>
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
<form class="formContainer form2Button" action="/latest/maintenance/brandProcess.cfm?action=#url.action#&menuID=#url.menuID#" method="post" onsubmit="document.getElementById('brand').disabled=false";>
	<div>#pageTitle#</div>
	<div>
		<table>
			<tr>
				<th><label for="brand">#words[122]#</label></th>
				<td>
                	<input type="text" id="brand" name="brand" required="required" maxlength="25"
                    	<cfif IsDefined("url.action") AND url.action NEQ "create">  value="#URLbrand#"  disabled="true"</cfif>/>
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
		<input type="button" value="#words[96]#" onclick="window.location='/latest/maintenance/brandProfile.cfm?menuID=#menuID#'" />
	</div>
</form>
</cfoutput>
</body>
</html>