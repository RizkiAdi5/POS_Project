<cfif IsDefined('url.location') AND IsDefined('url.itemno') >
	<cfset URLlocation = trim(urldecode(url.location))>
    <cfset URLitemno = trim(urldecode(url.itemno))>
</cfif>


<cfif IsDefined("url.action")>
	<cfif url.action EQ "update">
		<cfset pageTitle="Update Opening Quantity Profile">
		<cfset pageAction="Update">
		
        <cfquery name="getOpeningQuantity" datasource='#dts#'>
            SELECT * 
            FROM locqdbf 
            WHERE location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLlocation#">
            AND itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLitemno#"> ;
		</cfquery>
		
		<cfset location = getOpeningQuantity.location>
        <cfset itemNo = getOpeningQuantity.itemno>
        <cfset qtyBF = getOpeningQuantity.locqfield>
        <cfset minimum = getOpeningQuantity.lminimum>
        <cfset reorder = getOpeningQuantity.lreorder>	
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
<form class="formContainer form2Button" action="/latest/maintenance/openingQuantityProcess.cfm?action=#url.action#" method="post" onsubmit="document.getElementById('location').disabled=false;document.getElementById('itemNo').disabled=false;">
	<div>#pageTitle#</div>
	<div>
		<table>
			<tr>
				<th><label for="location">Location</label></th>
				<td>
                	<input type="text" id="location" name="location" <cfif IsDefined("url.action")> value="#URLlocation#" disabled="true"</cfif>/>
                </td>
			</tr>
			<tr>
				<th><label for="itemNo">Item No</label></th>
				<td>
                	<input type="text" id="itemNo" name="itemNo" <cfif IsDefined("url.action")> value="#URLitemNo#" disabled="true"</cfif>/>                   
                </td>
			</tr> 
			<tr>
				<th><label for="qtyBF">Qty B/F</label></th>
				<td>
                	<input type="text" id="qtyBF" name="qtyBF" value="#qtyBF#" />                   
                </td>
			</tr>  
			<tr>
				<th><label for="minimum">Minimum</label></th>
				<td>
                	<input type="text" id="minimum" name="minimum" value="#minimum#" />                   
                </td>
			</tr> 
			<tr>
				<th><label for="reorder">Reorder</label></th>
				<td>
                	<input type="text" id="reorder" name="reorder" value="#reorder#" />                   
                </td>
			</tr>                                  
		</table>
	</div>
	<div>
		<input type="submit" value="#pageAction#" />
		<input type="button" value="Cancel" onclick="window.location='/latest/maintenance/openingQuantityProfile.cfm'" />
	</div>
</form>
</cfoutput>
</body>
</html>