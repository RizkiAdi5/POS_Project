<cfif IsDefined('url.servi')>
	<cfset URLservi = trim(urldecode(url.servi))>
</cfif>

<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="Create Service Profile">
		<cfset pageAction="Create">
		<cfset servi = "">
        <cfset desp = "">
        <cfset despa = "">
        <cfset SALEC = "">
        <cfset SALECSC = "">
        <cfset SALECNC = "">
        <cfset PURC = "">
        <cfset PURPRC = "">
        <cfset SERCOST = "0.00">
        <cfset serprice = "0.00">
        
	<cfelseif url.action EQ "update">
		<cfset pageTitle="Update Service Profile">
		<cfset pageAction="Update">
		<cfquery name="getService" datasource='#dts#'>
            SELECT * 
            FROM icservi 
            WHERE servi=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLservi#">;
		</cfquery>
		
		<cfset servi = getService.servi>
        <cfset desp = getService.desp>
        <cfset despa = getService.despa>
        <cfset salec = getService.SALEC>
        <cfset SALECSC = getService.SALECSC>
        <cfset SALECNC = getService.SALECNC>
        <cfset PURC = getService.PURC>
        <cfset PURPRC = getService.PURPRC>
        <cfset SERCOST = getService.SERCOST>
        <cfset serprice = getService.serprice>
                
    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete Service Profile">
		<cfset pageAction="Delete">   
        
        <cfquery name="getService" datasource='#dts#'>
            SELECT * 
            FROM icservi 
            WHERE servi=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLservi#">;
		</cfquery>
		
		<cfset servi = getService.servi>
        <cfset desp = getService.desp>
        <cfset despa = getService.despa>
        <cfset SALEC = getService.SALEC>
        <cfset SALECSC = getService.SALECSC>
        <cfset SALECNC = getService.SALECNC>
        <cfset PURC = getService.PURC>
        <cfset PURPRC = getService.PURPRC>
        <cfset SERCOST = getService.SERCOST>
        <cfset serprice = getService.serprice>     
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
<form class="formContainer form2Button" action="/latest/maintenance/serviceProcess.cfm?action=#url.action#&menuID=#url.menuID#" method="post"  onsubmit="document.getElementById('service').disabled=false";>
	<div>#pageTitle#</div>
	<div>
		<table>
			<tr>
				<th><label for="service">Service</label></th>
				<td>
                	<input type="text" id="service" name="service" required="required" maxlength="8"  
						<cfif IsDefined("url.action") AND url.action NEQ "create"> value="#servi#" disabled="true"</cfif> />
                </td>
			</tr>
			<tr>
				<th><label for="desp">Description</label></th>
				<td>
                	<input type="text" id="desp" name="desp" value="#desp#" maxlength="100"/>                   
                </td>
			</tr>
            <tr>
            	<td></td>
                <td>
                	<input type="text" id="despa" name="despa" value="#despa#" maxlength="100"/>
                </td>
			</tr>
            <tr>
				<th><label for="creditSales">Credit Sales</label></th>
				<td>
                	<input type="text" id="creditSales" name="creditSales" value="#SALEC#" maxlength="8"/>
                </td>
			</tr>
            <tr>
				<th><label for="cashSales">Cash Sales</label></th>
				<td>
                	<input type="text" id="cashSales" name="cashSales" value="#SALECSC#" maxlength="8"/>
                </td>
			</tr>
            <tr>
				<th><label for="salesReturn">Sales Return</label></th>
				<td>
                	<input type="text" id="salesReturn" name="salesReturn" value="#SALECNC#" maxlength="8"/>
                </td>
			</tr>
            <tr>
				<th><label for="purchase">Purchase</label></th>
				<td>
                	<input type="text" id="purchase" name="purchase" value="#PURC#" maxlength="8"/>
                </td>
			</tr>
            <tr>
				<th><label for="purchaseReturn">Purchase Return</label></th>
				<td>
                	<input type="text" id="purchaseReturn" name="purchaseReturn" value="#PURPRC#" maxlength="8"/>
                </td>
			</tr>
            <tr>
				<th><label for="serviceCost">Service Cost</label></th>
				<td>
                	<input type="text" id="serviceCost" name="serviceCost" value="#SERCOST#" maxlength="8"/>
                </td>
			</tr>
            <tr>
				<th><label for="servicePrice">Service Price</label></th>
				<td>
                	<input type="text" id="servicePrice" name="servicePrice" value="#serprice#" maxlength="8"/>
                </td>
			</tr>
		</table>
	</div>
	<div>
		<input type="submit" value="#pageAction#" />
		<input type="button" value="Cancel" onclick="window.location='/latest/maintenance/serviceProfile.cfm?menuID=#url.menuID#'"/>
        
	</div>
</form>
</cfoutput>
</body>
</html>