<cfinclude template = "../../CFC/convert_single_double_quote_script.cfm">
<html>
<head>
<title>Calculate Cost Menu</title>
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<script type='text/javascript' src='../../ajax/core/engine.js'></script>
<script type='text/javascript' src='../../ajax/core/util.js'></script>
<script type='text/javascript' src='../../ajax/core/settings.js'></script>

<script type="text/javascript">

// begin: product search
function getProduct(type){
	if(type == 'itemto'){
		var inputtext = document.form.searchitemto.value;
		DWREngine._execute(_reportflocation, null, 'productlookup', inputtext, getProductResult);
		
	}else{
		var inputtext = document.form.searchitemfr.value;
		DWREngine._execute(_reportflocation, null, 'productlookup', inputtext, getProductResult2);
	}
}

function getProductResult(itemArray){
	DWRUtil.removeAllOptions("itemto");
	DWRUtil.addOptions("itemto", itemArray,"KEY", "VALUE");
}

function getProductResult2(itemArray){
	DWRUtil.removeAllOptions("itemfrom");
	DWRUtil.addOptions("itemfrom", itemArray,"KEY", "VALUE");
}
// end: product search

</script>

</head>

<body>
<cfoutput>
<cfif isdefined("url.type") and url.type eq "fixed">
	<cfset costtype = "Fixed Cost Method">
<cfelseif isdefined("url.type") and url.type eq "month">
	<cfset costtype = "Month Average Method">
<cfelseif isdefined("url.type") and url.type eq "moving">
	<cfset costtype = "Moving Average Method">
<cfelseif isdefined("url.type") and url.type eq "fifo">
	<cfset costtype = "First In First Out Method">
<cfelseif isdefined("url.type") and url.type eq "lifo">
	<cfset costtype = "Last In First Out Method">
</cfif>

<cfquery name="getgeneral" datasource="#dts#">
	select filterall from gsetup
</cfquery>
<!--- Add On 15-01-2010 --->
<cfquery name="getdealer_menu" datasource="#dts#">
	select custSuppSortBy,productSortBy from dealer_menu limit 1
</cfquery>

<!--- <cfquery name="getitem" datasource="#dts#">
	select itemno, desp from icitem order by itemno
</cfquery> --->
<cfquery name="getitem" datasource="#dts#">
	select itemno, desp from icitem order by <cfif getdealer_menu.productSortBy neq "">#getdealer_menu.productSortBy#<cfelse>itemno</cfif>
</cfquery>

<!--- <h2 align="center">Calculate Cost of #costtype# </h2> --->
<h3>
	<a href="salesmenu.cfm">Sales Report Menu</a> >> 
	<a><font size="2">Calculate Cost of #costtype#</font></a>
</h3>
<br><br>* Please Select Some Items

<form name="form" action="calculatecost.cfm?type=#url.type#" method="post" target="_blank">
<table width="75%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
	<tr> 
    	<th>Item No From</th>
        <td><select name="itemfrom">
			<option value="">Choose an Item</option>
			<cfloop query="getitem">
			<option value="#convertquote(itemno)#">#itemno# - #desp#</option>
			</cfloop>
			</select>
			<cfif getgeneral.filterall eq "1">
				<input type="text" name="searchitemfr" onKeyUp="getProduct('itemfrom');">
			</cfif>
		</td>
	</tr>
	<tr><td><br></td></tr>
    <tr> 
        <th>Item No To</th>
        <td><select name="itemto">
				<option value="">Choose an Item</option>
				<cfloop query="getitem">
					<option value="#convertquote(itemno)#">#itemno# - #desp#</option>
				</cfloop>
			</select>
			<cfif getgeneral.filterall eq "1">
				<input type="text" name="searchitemto" onKeyUp="getProduct('itemto');">
			</cfif>
		</td>
     </tr>
     <cfif isdefined("url.type") and url.type eq "fifo">
     <tr>
     <td>&nbsp;</td>
     </tr>
     <tr>
     <td></td>
     <td>Tick to include Misc Charges<input type="checkbox" name="cbincludecharge" id="cbincludecharge" value="1"></td>
     </tr>
     </cfif>
	 <tr> 
        <td colspan="2" align="right"><input type="submit" name="Submit" value="Submit"></td>
     </tr>
    </table>
</form>
</cfoutput>
</body>
</html>