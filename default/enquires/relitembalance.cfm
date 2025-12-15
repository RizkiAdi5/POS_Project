<cfinclude template = "/CFC/convert_single_double_quote_script.cfm">
<html>
<head>
	<title>Related Item Balance</title>
	<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
	<script type='text/javascript' src='/scripts/ajax.js'></script>
	
	<script type="text/javascript">
		function trim(strval)
		{
			return strval.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
		}
		function checkRelItem(itemno){
			if(itemno!=''){
				var ajaxurl = '/default/enquires/relitembalanceAjax.cfm?itemno='+itemno;
				ajaxFunction(document.getElementById('ajaxFieldPro'),ajaxurl);
			}
		}
	</script>
</head>
<body>
<h1 align="center">Related Item Balance</h1>
<cfquery name="getdealer_menu" datasource="#dts#">
	select custSuppSortBy,productSortBy from dealer_menu limit 1
</cfquery>
<cfquery name="getitem" datasource="#dts#">
	select itemno, desp,despa from icitem where (nonstkitem<>'T' or nonstkitem is null) order by <cfif getdealer_menu.productSortBy neq "">#getdealer_menu.productSortBy#<cfelse>itemno</cfif>
</cfquery>
<form action="" method="post" name="submit3" id="submit3">
<table width="600" align="center">
	<tr>
		<th>Item No.</th>
		<td>
			<select name="itemno" id="itemno" onChange="document.getElementById('desp').value=this.options[this.selectedIndex].id.split('|')[0];document.getElementById('despa').value=this.options[this.selectedIndex].id.split('|')[1];checkRelItem(this.value);">
				<option value="" id="">-</option>
				<cfoutput query="getitem">
					<option value="#convertquote(itemno)#" id="#convertquote(desp)#|#convertquote(despa)#">#itemno# - #desp#</option>
				</cfoutput>
			</select>
		</td>
	</tr>
	<tr>
		<th>Item Description</th>
		<td>
			<input type="text" name="desp" id="desp" size="60" disabled>
		</td>
	</tr>
	<tr>
		<td></td>
		<td>
			<input type="text" name="despa" id="despa" size="60" disabled>
		</td>
	</tr>
</table>
</form>
<div id="ajaxFieldPro" name="ajaxFieldPro">
<table width="600" align="center" class="data">
	<tr>
		<th width="150">Related Item No.</th>
		<th width="250">Description</th>
		<th width="100">Stock Balance</th>
		<th width="100">Unit Price</th>
	</tr>
</table>
</div>
</body>
</html>
	