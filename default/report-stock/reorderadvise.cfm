<cfinclude template = "../../CFC/convert_single_double_quote_script.cfm">
<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
<!--- Add On 13-01-2010 --->
<cfquery name="getdealer_menu" datasource="#dts#">
	select custSuppSortBy,productSortBy from dealer_menu limit 1
</cfquery>
<!--- <cfquery name="getitem" datasource="#dts#">
	select itemno, desp from icitem order by itemno
</cfquery> --->
<cfquery name="getitem" datasource="#dts#">
	select itemno, desp from icitem order by <cfif getdealer_menu.productSortBy neq "">#getdealer_menu.productSortBy#<cfelse>itemno</cfif>
</cfquery>
<cfquery name="getgroup" datasource="#dts#">
	select wos_group, desp from icgroup order by wos_group
</cfquery>
<cfquery name="getcate" datasource="#dts#">
	select * from iccate order by cate
</cfquery>
<!--- <cfquery name="getsupp" datasource="#dts#">
	select custno,name from #target_apvend# order by custno
</cfquery> --->
<cfquery name="getsupp" datasource="#dts#">
	select custno,name from #target_apvend# order by <cfif getdealer_menu.custSuppSortBy neq "">#getdealer_menu.custSuppSortBy#<cfelse>custno</cfif>
</cfquery>
<cfquery name="getgeneral" datasource="#dts#">
	select filterall,lCATEGORY,lGROUP,lSIZE,lMATERIAL,lMODEL,lRATING,lAGENT,lDRIVER,lLOCATION from gsetup
</cfquery>
<html>
<head>
<title>Reorder Advise</title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">

<script type='text/javascript' src='../../ajax/core/engine.js'></script>
<script type='text/javascript' src='../../ajax/core/util.js'></script>
<script type='text/javascript' src='../../ajax/core/settings.js'></script>

<script type="text/javascript">

function selectlist(custno,fieldtype){

			for (var idx=0;idx<document.getElementById(fieldtype).options.length;idx++) 
			{
        	if (custno==document.getElementById(fieldtype).options[idx].value) 
			{
            document.getElementById(fieldtype).options[idx].selected=true;
        	}
    		} 
			
									}
									
// begin: product search
function getProduct(type){
	if(type == 'productto'){
		var inputtext = document.form.searchitemto.value;
		DWREngine._execute(_reportflocation, null, 'productlookup', inputtext, getProductResult);
		
	}else{
		var inputtext = document.form.searchitemfr.value;
		DWREngine._execute(_reportflocation, null, 'productlookup', inputtext, getProductResult2);
	}
}

function getProductResult(itemArray){
	DWRUtil.removeAllOptions("productto");
	DWRUtil.addOptions("productto", itemArray,"KEY", "VALUE");
}

function getProductResult2(itemArray){
	DWRUtil.removeAllOptions("productfrom");
	DWRUtil.addOptions("productfrom", itemArray,"KEY", "VALUE");
}
// end: product search

// begin: supplier search
function getSupp(type,option){
	if(type == 'suppfrom'){
		var inputtext = document.form.searchsuppfr.value;
		DWREngine._execute(_reportflocation, null, 'supplierlookup', inputtext, option, getSuppResult);
		
	}
	else{
		var inputtext = document.form.searchsuppto.value;
		DWREngine._execute(_reportflocation, null, 'supplierlookup', inputtext, option, getSuppResult2);
	}
}

function getSuppResult(suppArray){
	DWRUtil.removeAllOptions("suppfrom");
	DWRUtil.addOptions("suppfrom", suppArray,"KEY", "VALUE");
}

function getSuppResult2(suppArray){
	DWRUtil.removeAllOptions("suppto");
	DWRUtil.addOptions("suppto", suppArray,"KEY", "VALUE");
}
// end: supplier search

// begin: category search
function getCategory(type){
	if(type == 'Catefrom'){
		var inputtext = document.form.searchcatefr.value;
		DWREngine._execute(_reportflocation, null, 'categorylookup', inputtext, getCategoryResult);
	}else{
		var inputtext = document.form.searchcateto.value;
		DWREngine._execute(_reportflocation, null, 'categorylookup', inputtext, getCategoryResult2);
	}
}

function getCategoryResult(cateArray){
	DWRUtil.removeAllOptions("Catefrom");
	DWRUtil.addOptions("Catefrom", cateArray,"KEY", "VALUE");
}

function getCategoryResult2(cateArray){
	DWRUtil.removeAllOptions("Cateto");
	DWRUtil.addOptions("Cateto", cateArray,"KEY", "VALUE");
}
// end: category search

// begin: group search
function getGroup(type){
	if(type == 'groupfrom'){
		var inputtext = document.form.searchgroupfr.value;
		DWREngine._execute(_reportflocation, null, 'grouplookup', inputtext, getGroupResult);
		
	}
	else{
		var inputtext = document.form.searchgroupto.value;
		DWREngine._execute(_reportflocation, null, 'grouplookup', inputtext, getGroupResult2);
	}
}

function getGroupResult(groupArray){
	DWRUtil.removeAllOptions("groupfrom");
	DWRUtil.addOptions("groupfrom", groupArray,"KEY", "VALUE");
}

function getGroupResult2(groupArray){
	DWRUtil.removeAllOptions("groupto");
	DWRUtil.addOptions("groupto", groupArray,"KEY", "VALUE");
}
// end: group search

</script>

</head>
<body>

<!--- <h1 align="center">Reorder Advise</h1> --->
<h3>
	<a href="stock_listingmenu.cfm">Inventory Listing Menu</a> >> 
	<a><font size="2">Reorder Advise</font></a>
</h3>
<cfform action="reorderadvise2.cfm" name="form" method="post" target="_blank">
	<table border="0" align="center" width="80%" class="data">
	<tr>
		<th>Report Format<cfoutput><input type="hidden" name="tran" id="tran" value="#target_apvend#" /><input type="hidden" name="fromto" id="fromto" value="" /></cfoutput></th>
		<td colspan="3">
			<input type="radio" name="result" value="HTML" checked>HTML<br/>
			<input type="radio" name="result" value="EXCELDEFAULT">EXCEL DEFAULT
		</td>
	</tr>
	<tr><td colspan="5"><hr></td></tr>
    <tr> 
		<th width="16%">Product</th>
		<td width="5%"> <div align="center">From</div></td>
		<td colspan="2"><select name="productfrom">
		<option value="">Choose a product</option>
		<cfoutput query="getitem"><option value="#convertquote(itemno)#">#itemno# - #desp#</option></cfoutput> 
		</select>
		<cfif getgeneral.filterall eq "1">
        <input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='from';ColdFusion.Window.show('finditem');" />&nbsp;
			<input type="text" name="searchitemfr" onKeyUp="getProduct('productfrom');">
		</cfif>
		</td>
    </tr>
    <tr> 
		<th>Product</th>
		<td><div align="center">To</div></td>
		<td colspan="2" nowrap> <select name="productto">
		<option value="">Choose a product</option>
		<cfoutput query="getitem"><option value="#convertquote(itemno)#">#itemno# - #desp#</option></cfoutput> 
		</select> 
		<cfif getgeneral.filterall eq "1">
			<input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='to';ColdFusion.Window.show('finditem');" />&nbsp;<input type="text" name="searchitemto" onKeyUp="getProduct('productto');">
		</cfif>
		</td>
    </tr>
    <tr><td colspan="5"><hr></td></tr>
    <tr> 
		<th width="16%"><cfoutput>#getgeneral.lCATEGORY#</cfoutput> </th>
		<td width="5%"> <div align="center">From</div></td>
		<td colspan="2"><select name="Catefrom">
		<option value="">Choose a <cfoutput>#getgeneral.lCATEGORY#</cfoutput></option>
		<cfoutput query="getcate"><option value="#cate#">#cate# - #desp#</option></cfoutput> 
		</select>
		<cfif getgeneral.filterall eq "1">
			<input type="text" name="searchcatefr" onKeyUp="getCategory('Catefrom');">
		</cfif>
		</td>
    </tr>
    <tr> 
		<th width="16%"><cfoutput>#getgeneral.lCATEGORY#</cfoutput></th>
		<td width="5%"> <div align="center">To</div></td>
		<td colspan="2"><select name="Cateto">
		<option value="">Choose a <cfoutput>#getgeneral.lCATEGORY#</cfoutput></option>
		<cfoutput query="getcate"><option value="#cate#">#cate# - #desp#</option></cfoutput> 
		</select>
		<cfif getgeneral.filterall eq "1">
			<input type="text" name="searchcateto" onKeyUp="getCategory('Cateto');">
		</cfif>
		</td>
    </tr>
    <tr><td colspan="5"><hr></td></tr>
    <tr> 
		<th width="16%"><cfoutput>#getgeneral.lGROUP#</cfoutput></th>
		<td width="5%"> <div align="center">From</div></td>
		<td colspan="2"><select name="groupfrom">
		<option value="">Choose a <cfoutput>#getgeneral.lGROUP#</cfoutput></option>
		<cfoutput query="getgroup"><option value="#wos_group#">#wos_group#</option></cfoutput> 
		</select>
		<cfif getgeneral.filterall eq "1">
			<input type="text" name="searchgroupfr" onKeyUp="getGroup('groupfrom');">
		</cfif>
		</td>
    </tr>
    <tr> 
		<th width="16%"><cfoutput>#getgeneral.lGROUP#</cfoutput></th>
		<td width="5%"> <div align="center">To</div></td>
		<td colspan="2"><select name="groupto">
		<option value="">Choose a <cfoutput>#getgeneral.lGROUP#</cfoutput></option>
		<cfoutput query="getgroup"><option value="#wos_group#">#wos_group#</option></cfoutput> 
		</select>
		<cfif getgeneral.filterall eq "1">
			<input type="text" name="searchgroupto" onKeyUp="getGroup('groupto');">
		</cfif>
		</td>
    </tr>
    <tr><td colspan="5"><hr></td></tr>
    <tr> 
		<th width="16%">Period</th>
		<td width="5%"> <div align="center">At</div></td>
		<td colspan="2">
		<select name="period">
		<option value="">Choose a period</option>
		<option value="01">1</option>
		<option value="02">2</option>
		<option value="03">3</option>
		<option value="04">4</option>
		<option value="05">5</option>
		<option value="06">6</option>
		<option value="07">7</option>
		<option value="08">8</option>
		<option value="09">9</option>
		<option value="10">10</option>
		<option value="11">11</option>
		<option value="12">12</option>
		<option value="13">13</option>
		<option value="14">14</option>
		<option value="15">15</option>
		<option value="16">16</option>
		<option value="17">17</option>
		<option value="18">18</option>
		</select>
		</td>
    </tr>
    <tr><td colspan="5"><hr></td></tr>
    <tr> 
		<th width="16%">Supplier</th>
		<td width="5%"> <div align="center">From</div></td>
		<td colspan="2">
		<select name="suppfrom">
		<option value="">Choose a Supplier</option>
		<cfoutput query="getsupp"><option value="#custno#">#custno# - #name#</option></cfoutput> 
		</select>
		<cfif getgeneral.filterall eq "1">
			<input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='from';ColdFusion.Window.show('findCustomer');" />&nbsp;<input type="text" name="searchsuppfr" onKeyUp="getSupp('suppfrom','Supplier');">
		</cfif>
		</td>
    </tr>
    <tr> 
		<th width="16%">Supplier</th>
		<td width="5%"> <div align="center">To</div></td>
		<td width="69%">
		<select name="suppto">
		<option value="">Choose a Supplier</option>
		<cfoutput query="getsupp"><option value="#custno#">#custno# - #name#</option></cfoutput> 
		</select>
		<cfif getgeneral.filterall eq "1">
			
<input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='to';ColdFusion.Window.show('findCustomer');" />&nbsp;<input type="text" name="searchsuppto" onKeyUp="getSupp('suppto','Supplier');">
		</cfif>
		</td>
      	<td width="10%"><input type="Submit" name="Submit" value="Submit"></td>
    </tr>
  </table>
</cfform>
<cfwindow  width="550" height="400" name="findCustomer" refreshOnShow="true"
        title="Find Customer or Supplier" initshow="false"
        source="findCustomer.cfm?type={tran}&fromto={fromto}" />
<cfwindow  width="550" height="400" name="finditem" refreshOnShow="true"
        title="Find Item" initshow="false"
        source="finditem.cfm?type=Product&fromto={fromto}" />
</body>
</html>