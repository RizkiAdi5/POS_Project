<cfif IsDefined('url.langno')>
	<cfset URLlanguageNo = trim(urldecode(url.langno))>
</cfif>
 

<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="Create Language Profile">
		<cfset pageAction="Create">
        
		<cfset languageNo = "">
        <cfset english = "">
        <cfset chinese = "">
        
	<cfelseif url.action EQ "update">
		<cfset pageTitle="Update Language Profile">
		<cfset pageAction="Update">
		<cfquery name="getLanguage" datasource='#dts#'>
            SELECT * 
            FROM iclanguage 
            WHERE langno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLlanguageNo#">;
		</cfquery>
		
		<cfset languageNo = getLanguage.langno>
        <cfset english = getLanguage.english>
        <cfset chinese = getLanguage.chinese>
                        
    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete Language Profile">
		<cfset pageAction="Delete">   
        
        <cfquery name="getLanguage" datasource='#dts#'>
            SELECT * 
            FROM iclanguage 
            WHERE langno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLlanguageNo#">;
		</cfquery>
		
		<cfset languageNo = getLanguage.langno>
        <cfset english = getLanguage.english>
        <cfset chinese = getLanguage.chinese>   
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
<form class="formContainer form2Button" action="/latest/maintenance/languageProcess.cfm?action=#url.action#" method="post" onsubmit="document.getElementById('language').disabled=false";>
	<div>#pageTitle#</div>
	<div>
		<table>
			<tr>
            	<input type="hidden" id="languageNo" name="languageNo" value="#languageNo#"/>
                
				<th><label for="english">English</label></th>
				<td>
                	<input type="text" id="english" name="english" value="#english#" required="required" maxlength="25" />
                </td>
			</tr>
			<tr>
				<th><label for="chinese">Chinese</label></th>
				<td>
                	<input type="text" id="chinese" name="chinese" value="#chinese#" />                   
                </td>
			</tr> 
		</table>
	</div>
	<div>
		<input type="submit" value="#pageAction#" />
	</div>
</form>
</cfoutput>
</body>
</html>