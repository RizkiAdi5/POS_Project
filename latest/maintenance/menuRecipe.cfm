<cfprocessingdirective pageencoding="UTF-8">
<cfif NOT IsDefined('url.itemno') OR trim(url.itemno) EQ "">
	<cfoutput>
	<script type="text/javascript">
		alert('No menu item specified.');
		window.open('/latest/maintenance/menuRecipeProfile.cfm?menuID=#url.menuID#','_self');
	</script>
	</cfoutput>
	<cfabort>
</cfif>

<cfset URLitemno = trim(urldecode(url.itemno))>

<cfquery name="getItem" datasource="#dts#">
	SELECT ITEMNO, DESP
	FROM icitem
	WHERE ITEMNO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLitemno#">
</cfquery>

<cfif getItem.recordcount EQ 0>
	<cfoutput>
	<script type="text/javascript">
		alert('Menu item #URLitemno# not found.');
		window.open('/latest/maintenance/menuRecipeProfile.cfm?menuID=#url.menuID#','_self');
	</script>
	</cfoutput>
	<cfabort>
</cfif>

<cfset itemName = getItem.DESP>

<cfquery name="getMaterials" datasource="#dts#">
	SELECT material_id, material_name, unit
	FROM app_raw_materials
	WHERE is_active = 1
	ORDER BY material_name
</cfquery>

<cfquery name="getRecipe" datasource="#dts#">
	SELECT r.material_id, r.qty_per_unit, m.material_name, m.unit
	FROM app_menu_recipes r
	INNER JOIN app_raw_materials m ON m.material_id = r.material_id
	WHERE r.item_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLitemno#">
	ORDER BY m.material_name
</cfquery>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><cfoutput>Recipe - #itemName#</cfoutput></title>
    <link rel="stylesheet" href="/latest/css/form.css" />
    <script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
    <!--[if (gte IE 6)&(lte IE 8)]>
        <script type="text/javascript" src="/latest/js/selectivizr/selectivizr-min.js"></script>
        <noscript><link rel="stylesheet" href="" /></noscript>
    <![endif]-->
</head>

<body class="container">
<cfoutput>

<!--- Template used by JS to clone a material <select> for each new row --->
<select id="materialOptionsTemplate" style="display:none">
	<option value="">-- choose material --</option>
	<cfloop query="getMaterials">
		<option value="#material_id#">#material_name# (#unit#)</option>
	</cfloop>
</select>

<form id="recipeForm" class="formContainer form2Button" action="/latest/maintenance/menuRecipeProcess.cfm" method="post">
	<div>Recipe for: #itemName# (#URLitemno#)</div>
	<div>
		<input type="hidden" name="itemCode" value="#URLitemno#" />
		<input type="hidden" name="menuID" value="#url.menuID#" />
		<input type="hidden" id="maxRowIndex" name="maxRowIndex" value="-1" />
		<table>
			<tr>
				<th>Raw Material</th>
				<th>Qty per Unit Sold</th>
				<th></th>
			</tr>
			<tbody id="ingredientRows"></tbody>
		</table>
		<div style="margin-top:10px;">
			<input type="button" id="addRowBtn" value="+ Add Ingredient" />
		</div>
	</div>
	<div>
		<input type="submit" value="Save Recipe" />
		<input type="button" value="Cancel" onclick="window.location='/latest/maintenance/menuRecipeProfile.cfm?menuID=#url.menuID#'" />
	</div>
</form>

<script type="text/javascript">
	var rowIndex = 0;
	var templateHtml = $('##materialOptionsTemplate').html();

	function addRow(materialId, qty) {
		var idx = rowIndex++;
		var $select = $('<select name="material_id' + idx + '" required></select>').html(templateHtml);
		if (materialId) { $select.val(String(materialId)); }
		var $qty = $('<input type="number" step="0.001" min="0.001" name="qty' + idx + '" required style="width:100%" />');
		if (qty) { $qty.val(qty); }
		var $remove = $('<span style="cursor:pointer;font-weight:bold;padding:0 8px;" title="Remove">&times;</span>').on('click', function(){
			$tr.remove();
		});
		var $tr = $('<tr id="ingRow' + idx + '"></tr>');
		$tr.append($('<td></td>').append($select));
		$tr.append($('<td></td>').append($qty));
		$tr.append($('<td></td>').append($remove));
		$('##ingredientRows').append($tr);
		$('##maxRowIndex').val(idx);
	}

	$('##addRowBtn').on('click', function(){ addRow(null, null); });

	$(document).ready(function(){
		<cfloop query="getRecipe">
			addRow(#material_id#, #NumberFormat(qty_per_unit, "0.000")#);
		</cfloop>
		if (rowIndex === 0) { addRow(null, null); }
	});

	$('##recipeForm').on('submit', function(){
		var ok = true;
		$('##ingredientRows tr').each(function(){
			var sel = $(this).find('select');
			var qty = $(this).find('input[type=number]');
			if (sel.val() === '' || qty.val() === '' || parseFloat(qty.val()) <= 0) { ok = false; }
		});
		if (!ok) {
			alert('Please choose a material and a positive quantity for every row, or remove the empty row.');
			return false;
		}
		return true;
	});
</script>
</cfoutput>
</body>
</html>
