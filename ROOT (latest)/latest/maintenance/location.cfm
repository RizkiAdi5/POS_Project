<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "485,95,486,98,482,65,483,54,55,484,16,6,546,96,125">
<cfinclude template="/latest/words.cfm">
<cfif IsDefined('url.location')>
	<cfset URLlocation = trim(urldecode(url.location))>
</cfif>

<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="#words[485]#">
		<cfset pageAction="#words[95]#">
		<cfset location = "">
        <cfset desp = "">
        <cfset consignmentOutlet = "">
        <cfset customerNo = "">
        <cfset add1 = "">
        <cfset add2 = "">
        <cfset add3 = "">
        <cfset add4 = "">


	<cfelseif url.action EQ "update">
		<cfset pageTitle="#words[486]#">
		<cfset pageAction="#words[98]#">
        <cfquery name="getLocation" datasource='#dts#'>
            SELECT *
            FROM iclocation
            WHERE location=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLlocation#">;
		</cfquery>

		<cfset location = getLocation.location>
        <cfset desp = getLocation.desp>
        <cfset consignmentOutlet = getLocation.outlet>
        <cfset customerNo = getLocation.custno>
        <cfset add1 = getLocation.addr1>
        <cfset add2 = getLocation.addr2>
        <cfset add3 = getLocation.addr3>
        <cfset add4 = getLocation.addr4>


    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete Location Profile">
		<cfset pageAction="Delete">

        <cfquery name="getLocation" datasource='#dts#'>
            SELECT *
            FROM iclocation
            WHERE location=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLlocation#">;
		</cfquery>

		<cfset location = getLocation.location>
        <cfset desp = getLocation.desp>
        <cfset consignmentOutlet = getLocation.outlet>
        <cfset customerNo = getLocation.custno>
        <cfset add1 = getLocation.addr1>
        <cfset add2 = getLocation.addr2>
        <cfset add3 = getLocation.addr3>
        <cfset add4 = getLocation.addr4>
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

	<cfinclude template="filterCustomer.cfm">
    <link rel="stylesheet" href="/latest/css/select2/select2.css" />
    <script type="text/javascript" src="/latest/js/select2/select2.min.js"></script>
</head>

<body class="container">
<cfoutput>
<form class="formContainer form2Button" action="/latest/maintenance/locationProcess.cfm?action=#url.action#" method="post" onsubmit="document.getElementById('location').disabled=false";>
	<div>#pageTitle#</div>
	<div>
		<table>
			<tr>
				<th><label for="location">#words[482]#</label></th>
				<td>
                	<input type="text" id="location" name="location" required="required" maxlength="25"
                    	<cfif IsDefined("url.action") AND url.action NEQ "create">  value="#URLlocation#"  disabled="true"</cfif>/>
                </td>
			</tr>
			<tr>
				<th><label for="desp">#words[65]#</label></th>
				<td>
                	<input type="text" id="desp" name="desp" value="#desp#" />
                </td>
			</tr>
            <tr>
				<th><label for="consignmentOutlet">#words[483]#</label></th>
				<td>
                	<select id="consignmentOutlet" name="consignmentOutlet">
                    	<option value="Y" <cfif consignmentOutlet EQ 'Y'>selected</cfif>>#words[54]#</option>
                      	<option value="N" <cfif consignmentOutlet EQ 'N'>selected</cfif>>#words[55]#</option>
                    </select>
                </td>
			</tr>
            <cfif url.action EQ 'create'>
                <tr>
                    <th><label for="">#words[484]#</label></th>
                    <td>
                        <input type="checkbox" id="generateItem" name="generateItem" value="generate"/>
                    </td>
                </tr>
            </cfif>
            <tr>
				<th><label for="customerNo">#words[16]#</label></th>
				<td>
                	<input type="hidden" id="customerNo" name="customerNo" class="customerNo" data-placeholder="#customerNo#" />
                </td>
			</tr>
            <tr>
				<th><label for="add1">#words[6]#</label></th>
				<td>
                	<input type="text" id="add1" name="add1" value="#add1#" />
                </td>
			</tr>
            <tr>
				<th></th>
				<td>
                	<input type="text" id="add2" name="add2" value="#add2#" />
                </td>
			</tr>
            <tr>
				<th></th>
				<td>
                	<input type="text" id="add3" name="add3" value="#add3#" />
                </td>
			</tr>
            <tr>
				<th></th>
				<td>
                	<input type="text" id="add4" name="add4" value="#add4#" />
                </td>
			</tr>
            <cfif url.action NEQ 'create'>
                <tr>
                    <th><label for="discontinueLocation">#words[546]#</label></th>
                    <td>
                        <input type="checkbox" id="discontinueLocation" name="discontinueLocation" <cfif IsDefined("url.action") AND url.action NEQ "create"><cfif getLocation.noactivelocation eq 'Y'>checked</cfif></cfif> />
                    </td>
                </tr>
            </cfif>
    	</table>
	</div>
	<div>
		<input type="submit" value="#pageAction#" />
		<input type="button" value="#words[96]#" onclick="window.location='/latest/maintenance/locationProfile.cfm'" />
	</div>
</form>
</cfoutput>
</body>
</html>