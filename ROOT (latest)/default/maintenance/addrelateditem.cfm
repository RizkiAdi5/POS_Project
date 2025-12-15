<cfinclude template = "/CFC/convert_single_double_quote_script.cfm">
<html>
<head>
	<title>Add Related Item</title>
	<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
	<script type='text/javascript' src='/scripts/ajax.js'></script>
	
	<script type="text/javascript">
		function trim(strval)
		{
			return strval.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
		}
		function addRelItem(){
			if(trim(document.getElementById('relitemno').value)==''){
				alert('Please Select a Related Item.');
			}
			else{
				var itemno = escape(trim(document.getElementById('itemno').value));
				var relitemno = escape(trim(document.getElementById('relitemno').value));
				var ajaxurl = '/default/maintenance/addrelateditemAjax.cfm?itemno='+itemno+'&relitemno='+relitemno+'&action=addRelitem';
				ajaxFunction(document.getElementById('ajaxFieldPro'),ajaxurl);
				
				resetform();
			}
		}
		function removeRelitem(itemno,relitemno){
			if (confirm("Are you sure you want to Delete?")) {
				var ajaxurl = '/default/maintenance/addrelateditemAjax.cfm?itemno='+itemno+'&relitemno='+relitemno+'&action=deleteRelitem';
				ajaxFunction(document.getElementById('ajaxFieldPro'),ajaxurl);
			}	
		}
		function resetform(){
			document.getElementById('relitemno').value='';
			document.getElementById('reldesp').value='';
			document.getElementById('reldespa').value='';
		}
	</script>
</head>
<body>
<h1 align="center">Related Item - <cfoutput>#url.itemno#</cfoutput></h1>
<cfquery name="getdealer_menu" datasource="#dts#">
	select custSuppSortBy,productSortBy from dealer_menu limit 1
</cfquery>
<cfquery name="getitem" datasource="#dts#">
	select itemno, desp,despa from icitem where (nonstkitem<>'T' or nonstkitem is null)
	and itemno <> <cfqueryparam cfsqltype="cf_sql_char" value="#url.itemno#">
	order by <cfif getdealer_menu.productSortBy neq "">#getdealer_menu.productSortBy#<cfelse>itemno</cfif>
</cfquery>
<form action="s_icitem.cfm?type=icitem&process=done" method="post" name="submit3" id="submit3">
<cfoutput>
	<input name="status" value="#status#" type="hidden">
	<input name="itemno" id="itemno" value="#convertquote(url.itemno)#" type="hidden">
</cfoutput>
<table width="650" align="center">
	<tr>
		<th>Related Item No.</th>
		<td>
			<select name="relitemno" id="relitemno" onChange="document.getElementById('reldesp').value=this.options[this.selectedIndex].id.split('|')[0];document.getElementById('reldespa').value=this.options[this.selectedIndex].id.split('|')[1];">
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
			<input type="text" name="reldesp" id="reldesp" size="60" disabled>
		</td>
	</tr>
	<tr>
		<td></td>
		<td>
			<input type="text" name="reldespa" id="reldespa" size="60" disabled>&nbsp;&nbsp;&nbsp;
			<input type="button" value="Insert" onClick="addRelItem();">&nbsp;&nbsp;&nbsp;
			<input type="submit" value="Done" name="btnSubmit">
		</td>
	</tr>
</table>
</form>
<div id="ajaxFieldPro" name="ajaxFieldPro">
<cfquery name="getRelItem" datasource="#dts#">
	select a.itemno, a.relitemno,b.desp,b.despa from relitem a,icitem b
	where a.relitemno=b.itemno 
	and a.itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#url.itemno#"> 
</cfquery>
<table width="700" align="center" class="data">
	<tr>
		<th width="150">Related Item No.</th>
		<th width="250">Description</th>
		<th width="250">2nd Description</th>
		<th width="50">Action</th>
	</tr>
	<cfoutput query="getRelItem">
		<tr>
			<td>#getRelItem.relitemno#</td>
			<td>#getRelItem.desp#</td>
			<td>#getRelItem.despa#</td>
			<td><img src="/images/userdefinedmenu/idelete.gif" alt="Remove" onClick="removeRelitem('#URLEncodedFormat(getRelItem.itemno)#','#URLEncodedFormat(getRelItem.relitemno)#');" style="cursor: hand;"></td>
		</tr>
	</cfoutput>
</table>
</div>
</body>
</html>
	