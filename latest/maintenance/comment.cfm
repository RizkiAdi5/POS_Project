<cfif IsDefined('url.code')>
	<cfset URLcomment = trim(urldecode(url.code))>
</cfif>


<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="Create Comment Profile">
		<cfset pageAction="Create">
		<cfset code = "">
        <cfset desp = "">
        <cfset detail = "">
        
	<cfelseif url.action EQ "update">
		<cfset pageTitle="Update Comment Profile">
		<cfset pageAction="Update">
		<cfquery name="getComment" datasource='#dts#'>
            SELECT * 
            FROM comments 
            WHERE code=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLcomment#">;
		</cfquery>
		
		<cfset comment = getComment.code>
        <cfset desp = getComment.desp>
        <cfset detail = ToString(getComment.details)>
                        
    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete Comment Profile">
		<cfset pageAction="Delete">   
        
        <cfquery name="getComment" datasource='#dts#'>
            SELECT * 
            FROM comments 
            WHERE code=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLcomment#">;
		</cfquery>
		
		<cfset comment = getComment.code>
        <cfset desp = getComment.desp> 
        <cfset detail = ToString(getComment.details)>    
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
<form class="formContainer form2Button" action="/latest/maintenance/commentProcess.cfm?action=#url.action#" method="post" onsubmit="document.getElementById('comment').disabled=false";>
	<div>#pageTitle#</div>
	<div>
		<table>
			<tr>
				<th><label for="comment">Comment</label></th>
				<td>
                	<input type="text" id="comment" name="comment" required="required" maxlength="25"
                    	<cfif IsDefined("url.action") AND url.action NEQ "create">  value="#URLcomment#"  disabled="true"</cfif>/>
                </td>
			</tr>
			<tr>
				<th><label for="desp">Description</label></th>
				<td>
                	<input type="text" id="desp" name="desp" value="#desp#" />                   
                </td>
			</tr>
            <tr>
				<th><label for="detail">Detail(s)</label></th>
				<td>
                	<textarea id="detail" name="detail" cols="90" row="10" />#detail#</textarea>                   
                </td>
			</tr> 
		</table>
	</div>
	<div>
		<input type="submit" value="#pageAction#" />
		<input type="button" value="Cancel" onclick="window.location='/latest/maintenance/commentProfile.cfm'" />
	</div>
</form>
</cfoutput>
</body>
</html>