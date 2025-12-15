<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "477,95,478,98,475,65,96">
<cfinclude template="/latest/words.cfm">
<cfif IsDefined('url.source')>
	<cfset URLsource = trim(urldecode(url.source))>
</cfif>


<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="#words[477]#">
		<cfset pageAction="#words[95]#">
		<cfset source = "">
        <cfset project = "">
        
	<cfelseif url.action EQ "update">
		<cfset pageTitle="#words[478]#">
		<cfset pageAction="#words[98]#">
		<cfquery name="getJob" datasource='#dts#'>
            SELECT * 
            FROM #target_project# 
            WHERE source = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLsource#">
            AND porj = 'J';
		</cfquery>
		
		<cfset source = getJob.source>
        <cfset project = getJob.project>
                        
    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete Job Profile">
		<cfset pageAction="Delete">   
        
        <cfquery name="getJob" datasource='#dts#'>
            SELECT * 
            FROM  #target_project#  
            WHERE source = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLsource#">
            AND porj = 'J';
		</cfquery>
		
		<cfset source = getJob.source>
        <cfset project = getJob.project>     
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
<form class="formContainer form2Button" action="/latest/maintenance/jobProcess.cfm?action=#url.action#" method="post" onsubmit="document.getElementById('source').disabled=false";>
	<div>#pageTitle#</div>
	<div>
		<table>
			<tr>
				<th><label for="source">#words[475]#</label></th>
				<td>
                	<input type="text" id="source" name="source" required="required" maxlength="25"
                    	<cfif IsDefined("url.action") AND url.action NEQ "create">  value="#URLsource#"  disabled="true"</cfif>/>
                </td>
			</tr>
			<tr>
				<th><label for="project">#words[65]#</label></th>
				<td>
                	<input type="text" id="project" name="project" value="#project#" />                   
                </td>
			</tr> 
		</table>
	</div>
	<div>
		<input type="submit" value="#pageAction#" />
		<input type="button" value="#words[96]#" onclick="window.location='/latest/maintenance/jobProfile.cfm'" />
	</div>
</form>
</cfoutput>
</body>
</html>