<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "532,95,533,98,67,65,534,535,536,537,539,96">
<cfinclude template="/latest/words.cfm">
<cfif IsDefined('url.term')>
	<cfset URLterm = trim(urldecode(url.term))>
</cfif>


<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="#words[532]#">
		<cfset pageAction="#words[95]#">
		<cfset term = "">
        <cfset desp = "">
        <cfset days = "">
        <cfset sign = "P">
        <cfset validity = "">
        <cfset leadTime = "">
        <cfset remarks = "">
        
	<cfelseif url.action EQ "update">
		<cfset pageTitle="#words[533]#">
		<cfset pageAction="#words[98]#">
		<cfquery name="getTerm" datasource='#dts#'>
            SELECT * 
            FROM #target_icterm# 
            WHERE term=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLterm#">;
		</cfquery>
		
		<cfset term = getTerm.term>
        <cfset desp = getTerm.desp>
        <cfset days = getTerm.days>
        <cfset sign = getTerm.sign>
        <cfset validity = getTerm.validity>
        <cfset leadTime = getTerm.leadtime>
        <cfset remarks = getTerm.remarks>
                                
    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete Term Profile">
		<cfset pageAction="Delete">   
        
        <cfquery name="getTerm" datasource='#dts#'>
            SELECT * 
            FROM #target_icterm#  
            WHERE term=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLterm#">;
		</cfquery>
		
		<cfset term = getTerm.term>
        <cfset desp = getTerm.desp>
        <cfset days = getTerm.days>
        <cfset sign = getTerm.sign>
        <cfset validity = getTerm.validity>
        <cfset leadTime = getTerm.leadtime>
        <cfset remarks = getTerm.remarks>     
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
<form class="formContainer form2Button" action="/latest/maintenance/termProcess.cfm?action=#url.action#" method="post" onsubmit="document.getElementById('term').disabled=false";>
	<div>#pageTitle#</div>
	<div>
		<table>
			<tr>
				<th><label for="term">#words[67]#</label></th>
				<td>
                	<input type="text" id="term" name="term" required="required" maxlength="12"
                    	<cfif IsDefined("url.action") AND url.action NEQ "create">  value="#URLterm#" disabled="true"</cfif>/>
                </td>
			</tr>
			<tr>
				<th><label for="desp">#words[65]#</label></th>
				<td>
                	<input type="text" id="desp" name="desp" value="#desp#" maxlength="40"/>                   
                </td>
			</tr>
            <tr>
				<th><label for="validity">#words[534]#</label></th>
				<td>
                	<input type="text" id="validity" name="validity" value="#validity#" maxlength="100"/>                   
                </td>
			</tr> 
            <tr>
				<th><label for="leadTime">#words[535]#</label></th>
				<td>
                	<input type="text" id="leadTime" name="leadTime" value="#leadTime#" maxlength="100"/>                   
                </td>
			</tr>
            <tr>
				<th><label for="remarks">#words[536]#</label></th>
				<td>
                	<input type="text" id="remarks" name="remarks" value="#remarks#" />                   
                </td>
			</tr>
            <tr>
				<th><label for="sign">#words[537]#</label></th>
				<td>
                	<div style="align:left">
                        <input type="radio" name="sign" value="P"<cfif sign eq 'P'>checked</cfif>>+ (Plus)<br>
                        <input type="radio" name="sign" value="" <cfif sign neq 'P'>checked</cfif>>
                    </div>
                </td>
			</tr>
            <tr>
				<th><label for="days">#words[539]#</label></th>
				<td>
                	<input type="text" id="days" name="days" value="#days#" maxlength="3"/>                   
                </td>
			</tr>
		</table>
	</div>
	<div>
		<input type="submit" value="#pageAction#" />
		<input type="button" value="#words[96]#" onclick="window.location='/latest/maintenance/termProfile.cfm'" />
	</div>
</form>
</cfoutput>
</body>
</html>