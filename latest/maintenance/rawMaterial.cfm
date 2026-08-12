<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "95,98,96">
<cfinclude template="/latest/words.cfm">
<cfif IsDefined('url.material_id')>
	<cfset URLmaterialId = trim(urldecode(url.material_id))>
</cfif>

<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="Add Raw Material">
		<cfset pageAction="#words[95]#">
		<cfset materialName = "">
        <cfset unit = "">
        <cfset stockQty = "0">
        <cfset reorderLevel = "">

	<cfelseif url.action EQ "update">
		<cfset pageTitle="Update Raw Material">
		<cfset pageAction="#words[98]#">
		<cfquery name="getMaterial" datasource='#dts#'>
            SELECT *
            FROM app_raw_materials
            WHERE material_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#URLmaterialId#">;
		</cfquery>

		<cfset materialName = getMaterial.material_name>
        <cfset unit = getMaterial.unit>
        <cfset stockQty = NumberFormat(getMaterial.stock_qty, "0.000")>
        <cfset reorderLevel = len(trim(getMaterial.reorder_level)) ? NumberFormat(getMaterial.reorder_level, "0.000") : "">

    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete Raw Material">
		<cfset pageAction="Delete">

        <cfquery name="getMaterial" datasource='#dts#'>
            SELECT *
            FROM app_raw_materials
            WHERE material_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#URLmaterialId#">;
		</cfquery>

		<cfset materialName = getMaterial.material_name>
        <cfset unit = getMaterial.unit>
        <cfset stockQty = NumberFormat(getMaterial.stock_qty, "0.000")>
        <cfset reorderLevel = len(trim(getMaterial.reorder_level)) ? NumberFormat(getMaterial.reorder_level, "0.000") : "">
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
<form class="formContainer form2Button" action="/latest/maintenance/rawMaterialProcess.cfm?action=#url.action#&menuID=#url.menuID#<cfif IsDefined('url.action') AND url.action NEQ "create">&material_id=#URLmaterialId#</cfif>" method="post">
	<div>#pageTitle#</div>
	<div>
		<table>
			<tr>
				<th><label for="materialName">Material Name</label></th>
				<td>
                	<input type="text" id="materialName" name="materialName" required="required" value="#materialName#" <cfif IsDefined("url.action") AND url.action EQ "delete">disabled="true"</cfif> />
                </td>
			</tr>
			<tr>
				<th><label for="unit">Unit</label></th>
				<td>
                	<input type="text" id="unit" name="unit" required="required" value="#unit#" placeholder="e.g. gram, pcs, ml" <cfif IsDefined("url.action") AND url.action EQ "delete">disabled="true"</cfif> />
                </td>
			</tr>
			<tr>
				<th><label for="stockQty">Stock Qty</label></th>
				<td>
                	<input type="number" step="0.001" min="0" id="stockQty" name="stockQty" required="required" value="#stockQty#" <cfif IsDefined("url.action") AND url.action EQ "delete">disabled="true"</cfif> />
                </td>
			</tr>
			<tr>
				<th><label for="reorderLevel">Reorder Level</label></th>
				<td>
                	<input type="number" step="0.001" min="0" id="reorderLevel" name="reorderLevel" value="#reorderLevel#" <cfif IsDefined("url.action") AND url.action EQ "delete">disabled="true"</cfif> />
                </td>
			</tr>
		</table>
	</div>
	<div>
		<input type="submit" value="#pageAction#" />
		<input type="button" value="#words[96]#" onclick="window.location='/latest/maintenance/rawMaterialProfile.cfm?menuID=#url.menuID#'" />
	</div>
</form>
</cfoutput>
</body>
</html>
