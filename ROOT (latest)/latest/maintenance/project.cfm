<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "508,95,511,509,98,506,65,91,92,93,94,245,183,185,186,187,188,510,96">
<cfinclude template="/latest/words.cfm">
<cfinclude template="/latest/pageTitle/pageTitle.cfm">

<cfif IsDefined('url.source')>
	<cfset URLsource = trim(urldecode(url.source))>
</cfif>


<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle = "#words[508]#">
		<cfset pageAction = "#words[95]#">
		<cfset source = "">
        <cfset project = "">
        <cfloop index="i" from="1" to="5">
        	<cfset 'remark#i#' = "">
        </cfloop>
        <cfset salec = "">
		<cfset salecsc = "">
        <cfset salecnc = "">
        <cfset purc = "">
        <cfset purprc = "">
		<cfset displayDefaultValue = "#words[511]#">

	<cfelseif url.action EQ "update">
		<cfset pageTitle = "#words[509]#">
		<cfset pageAction = "#words[98]#">
		<cfquery name="getProject" datasource='#dts#'>
            SELECT *
            FROM #target_project#
            WHERE source = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLsource#">
            AND porj = 'P';
		</cfquery>

		<cfset source = getProject.source>
        <cfset project = getProject.project>
        <cfloop index="i" from="1" to="5">
        	<cfset 'remark#i#' = evaluate('getProject.remark#i#')>
        </cfloop>
        <cfset salec = getProject.creditsales>
		<cfset salecsc = getProject.cashsales>
        <cfset salecnc = getProject.salesreturn>
        <cfset purc = getProject.purchase>
        <cfset purprc = getProject.purchasereturn>
		<cfset displayDefaultValue = "Choose a GL Account">

    <cfelseif url.action EQ "delete">
    	<cfset pageTitle = "Delete Project Profile">
		<cfset pageAction = "Delete">

        <cfquery name="getProject" datasource='#dts#'>
            SELECT *
            FROM  #target_project#
            WHERE source = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLsource#">
            AND porj = 'P';
		</cfquery>

		<cfset source = getProject.source>
        <cfset project = getProject.project>
        <cfloop index="i" from="1" to="5">
        	<cfset 'remark#i#' = evaluate('getProject.remark#i#')>
        </cfloop>
        <cfset salec = getProject.creditsales>
		<cfset salecsc = getProject.cashsales>
        <cfset salecnc = getProject.salesreturn>
        <cfset purc = getProject.purchase>
        <cfset purprc = getProject.purchasereturn>
		<cfset displayDefaultValue = "Choose a GL Account">
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

    <cfinclude template="/latest/maintenance/filter/filterGL.cfm">
    <link rel="stylesheet" href="/latest/css/select2/select2.css" />
    <script type="text/javascript" src="/latest/js/select2/select2.min.js"></script>
</head>

<body class="container">
<cfoutput>
<form class="formContainer form2Button" action="/latest/maintenance/projectProcess.cfm?action=#url.action#&menuID=#url.menuID#" method="post" onsubmit="document.getElementById('source').disabled=false";>
	<div>#pageTitle#</div>
	<div>
		<table>
			<tr>
				<th><label for="source">#words[506]#</label></th>
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

            <cfloop index="i" from="1" to="5">
                <tr>
                    <th><label for="remark#i#"><cfif i lt 5>#words[i+90]#<cfelse>#words[i+240]#</cfif></label></th>
                    <td>
                    	<cfset remarkValue = evaluate('remark#i#')>
                        <input type="text" id="remark#i#" name="remark#i#" value="#remarkValue#" />
                    </td>
                </tr>
            </cfloop>

            <cfif salec neq ''>
				<cfset displayValue = salec>
            <cfelse>
                <cfset displayValue = displayDefaultValue>
            </cfif>
 			<tr>
                <th><label for="creditSales">#words[183]#</label></th>
                <td>
                    <input type="hidden" id="creditSales" name="creditSales" class="accno1" data-placeholder="#displayValue#" />
                </td>
            </tr>

            <cfif salecsc neq ''>
				<cfset displayValue = salecsc>
            <cfelse>
                <cfset displayValue = displayDefaultValue>
            </cfif>
            <tr>
                <th><label for="cashSales">#words[185]#</label></th>
                <td>
                    <input type="hidden" id="cashSales" name="cashSales" class="accno2" data-placeholder="#displayValue#" />
                </td>
            </tr>

			<cfif salecnc neq ''>
                <cfset displayValue = salecnc>
            <cfelse>
                <cfset displayValue = displayDefaultValue>
            </cfif>
            <tr>
                <th><label for="salesReturn">#words[186]#</label></th>
                <td>
                    <input type="hidden" id="salesReturn" name="salesReturn" class="accno3" data-placeholder="#displayValue#" />
                </td>
            </tr>

			<cfif purc neq ''>
                <cfset displayValue = purc>
            <cfelse>
                <cfset displayValue = displayDefaultValue>
            </cfif>
            <tr>
                <th><label for="purchase">#words[187]#</label></th>
                <td>
                    <input type="hidden" id="purchase" name="purchase" class="accno4" data-placeholder="#displayValue#" />
                </td>
            </tr>

            <cfif purprc neq ''>
				<cfset displayValue = purprc>
            <cfelse>
                <cfset displayValue = displayDefaultValue>
            </cfif>
            <tr>
                <th><label for="purchaseReturn">#words[188]#</label></th>
                <td>
                    <input type="hidden" id="purchaseReturn" name="purchaseReturn" class="accno5" data-placeholder="#displayValue#" />
                </td>
            </tr>

            <tr>
                <th><label for="completed">#words[510]#</label></th>
                <td>
                    <input type="checkbox" id="completed" name="completed" <cfif IsDefined("url.action") AND url.action NEQ "create"><cfif getProject.completed eq 'Y'>checked</cfif></cfif> />
                </td>
            </tr>

		</table>
	</div>
	<div>
		<input type="submit" value="#pageAction#" />
		<input type="button" value="Cancel" onclick="window.location='/latest/maintenance/projectProfile.cfm?menuID=#url.menuID#'" />
	</div>
</form>
</cfoutput>
</body>
</html>