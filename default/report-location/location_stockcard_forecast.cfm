<cfinclude template = "../../CFC/convert_single_double_quote_script.cfm">
<html>
<head>
<title>View Forecast Menu</title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
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

// begin: category search
function getCategory(type){
	if(type == 'catefrom'){
		var inputtext = document.form.searchcatefr.value;
		DWREngine._execute(_reportflocation, null, 'categorylookup', inputtext, getCategoryResult);
	}else{
		var inputtext = document.form.searchcateto.value;
		DWREngine._execute(_reportflocation, null, 'categorylookup', inputtext, getCategoryResult2);
	}
}

function getCategoryResult(cateArray){
	DWRUtil.removeAllOptions("catefrom");
	DWRUtil.addOptions("catefrom", cateArray,"KEY", "VALUE");
}

function getCategoryResult2(cateArray){
	DWRUtil.removeAllOptions("cateto");
	DWRUtil.addOptions("cateto", cateArray,"KEY", "VALUE");
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

<!--- <cfquery name="getlocation" datasource="#dts#">
	select 
	location,
	desp 
	from iclocation 
	order by location;
</cfquery> --->

<!--- ADD ON 220908 --->
<cfquery name="getgeneral" datasource="#dts#">
	select filterall,lCATEGORY,lGROUP,lSIZE,lMATERIAL,lMODEL,lRATING,lAGENT,lDRIVER,lLOCATION from gsetup
</cfquery>

<!--- Add On 15-01-2010 --->
<cfquery name="getdealer_menu" datasource="#dts#">
	select custSuppSortBy,productSortBy from dealer_menu limit 1
</cfquery>

<cfquery name="getlocation" datasource="#dts#">
	select location,desp 
	from iclocation 
	<cfif getpin2.h4700 eq 'T' and HUserGrpID neq 'Super' and Huserloc neq "All_loc">
		where location in (#ListQualify(Huserloc,"'",",")#)
	</cfif>
	order by location
</cfquery>

<!--- <cfquery name="getitem" datasource="#dts#">
	select 
	itemno,
	desp 
	from icitem 
	order by itemno;
</cfquery> --->
<cfquery name="getitem" datasource="#dts#">
	select itemno,desp from icitem order by <cfif getdealer_menu.productSortBy neq "">#getdealer_menu.productSortBy#<cfelse>itemno</cfif>
</cfquery>

<cfquery name="getgroup" datasource="#dts#">
	select 
	wos_group,
	desp 
	from icgroup 
	order by wos_group;
</cfquery>

<cfquery name="getcate" datasource="#dts#">
	select 
	cate,
	desp 
	from iccate 
	order by cate;
</cfquery>
<body>

<!--- <h1 align="center">View <cfoutput>#getgeneral.lLOCATION#</cfoutput> Forecast</h1> --->
<h3>
	<a href="location_listingmenu.cfm"><cfoutput>#getgeneral.lLOCATION#</cfoutput> Reports Menu</a> >> 
	<a><font size="2">View <cfoutput>#getgeneral.lLOCATION#</cfoutput> Forecast</font></a>
</h3>

<cfform action="location_stockcard_forecast1.cfm" name="form" method="post" target="_blank">
	<table width="65%" border="0" align="center" class="data">
    	<tr> 
      		<th><cfoutput>#getgeneral.lCATEGORY#</cfoutput><input type="hidden" name="fromto" id="fromto" value="" /></th>
      		<td><div align="center">From</div></td>
      		<td colspan="2">
				<select name="catefrom">
          			<option value="">Choose a <cfoutput>#getgeneral.lCATEGORY#</cfoutput></option>
          			<cfoutput query="getcate"> 
            		<option value="#getcate.cate#">#getcate.cate# - #getcate.desp#</option>
          			</cfoutput>
				</select>
				<cfif getgeneral.filterall eq "1">
					<input type="text" name="searchcatefr" onKeyUp="getCategory('catefrom');">
				</cfif>
			</td>
    	</tr>
    	<tr> 
      		<th><cfoutput>#getgeneral.lCATEGORY#</cfoutput></th>
			<td><div align="center">To</div></td>
      		<td colspan="2">
				<select name="cateto">
          			<option value="">Choose a <cfoutput>#getgeneral.lCATEGORY#</cfoutput></option>
          			<cfoutput query="getcate"> 
            		<option value="#getcate.cate#">#getcate.cate# - #getcate.desp#</option>
          			</cfoutput>
				</select>
				<cfif getgeneral.filterall eq "1">
					<input type="text" name="searchcateto" onKeyUp="getCategory('cateto');">
				</cfif>
			</td>
		</tr>
    	<tr>
			<td height="24" colspan="5"> <hr></td>
    	</tr>
    	<tr>
			<th width="16%"><cfoutput>#getgeneral.lGROUP#</cfoutput></th>
      		<td width="5%"><div align="center">From</div></td>
      		<td colspan="2">
				<select name="groupfrom">
					<option value="">Choose a <cfoutput>#getgeneral.lGROUP#</cfoutput></option>
					<cfoutput query="getgroup"> 
					<option value="#getgroup.wos_group#">#getgroup.wos_group# - #getgroup.desp#</option>
					</cfoutput>
				</select>
				<cfif getgeneral.filterall eq "1">
					<input type="text" name="searchgroupfr" onKeyUp="getGroup('groupfrom');">
				</cfif>
			</td>
    	</tr>
    	<tr>
		<th><cfoutput>#getgeneral.lGROUP#</cfoutput></th>
			<td><div align="center">To</div></td>
      		<td colspan="2" nowrap> 
				<select name="groupto">
          			<option value="">Choose a <cfoutput>#getgeneral.lGROUP#</cfoutput></option>
        			<cfoutput query="getgroup"> 
					<option value="#getgroup.wos_group#">#getgroup.wos_group# - #getgroup.desp#</option>
					</cfoutput>
				</select>
				<cfif getgeneral.filterall eq "1">
					<input type="text" name="searchgroupto" onKeyUp="getGroup('groupto');">
				</cfif>
			</td>
    	</tr>
		<tr>
			<td height="24" colspan="5"> <hr></td>
    	</tr>
    	<tr> 
      		<th width="16%">Product</th>
      		<td width="5%"> <div align="center">From</div></td>
      		<td colspan="2">
				<select name="productfrom">
          			<option value="">Choose a product</option>
          			<cfoutput query="getitem"> 
            		<option value="#convertquote(getitem.itemno)#">#getitem.itemno# - #getitem.desp#</option>
          			</cfoutput>
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
      		<td colspan="2" nowrap>
				<select name="productto">
          			<option value="">Choose a product</option>
          			<cfoutput query="getitem"> 
            		<option value="#convertquote(getitem.itemno)#">#getitem.itemno# - #getitem.desp#</option>
          			</cfoutput>
				</select>
				<cfif getgeneral.filterall eq "1">
                <input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='to';ColdFusion.Window.show('finditem');" />&nbsp;
					<input type="text" name="searchitemto" onKeyUp="getProduct('productto');">
				</cfif>
			</td>
    	</tr>
    	<tr> 
      		<td height="24" colspan="5"> <hr></td>
    	</tr>
    	<tr> 
      		<th>Period</th>
      		<td><div align="center">From</div></td>
      		<td colspan="2">
				<select name="periodfrom">
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
    	<tr> 
      		<th>Period</th>
      		<td><div align="center">To</div></td>
      		<td colspan="2">
				<select name="periodto">
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
    	<tr> 
      		<td height="24" colspan="5"> <hr></td>
    	</tr>
    	<tr> 
      		<th width="16%">Date</th>
      		<td width="5%"> <div align="center">From</div></td>
      		<td colspan="2"><cfinput type="text" name="datefrom" maxlength="10" validate="eurodate" size="10"> (DD/MM/YYYY)</td>
		</tr>
    	<tr>
			<th width="16%">Date</th>
      		<td width="5%"> <div align="center">To</div></td>
      		<td colspan="2"> <cfinput type="text" name="dateto" maxlength="10" validate="eurodate" size="10"> (DD/MM/YYYY)</td>
    	</tr>
    	<tr> 
      		<td colspan="4"><hr></td>
    	</tr>
    	<tr> 
      		<th><cfoutput>#getgeneral.lLOCATION#</cfoutput></th>
      		<td><div align="center">From</div></td>
      		<td colspan="2">
				<select name="locfrom">
					<cfif HUserGrpID eq 'Super' or getpin2.h4700 neq 'T'>
          				<option value="">Choose a <cfoutput>#getgeneral.lLOCATION#</cfoutput></option>
					</cfif>
          			<!--- <option value="">Choose a Location</option> --->
          			<cfoutput query="getlocation"> 
            		<option value="#getlocation.location#">#getlocation.location# - #getlocation.desp#</option>
          			</cfoutput>
				</select>
			</td>
		</tr>
    	<tr>
			<th><cfoutput>#getgeneral.lLOCATION#</cfoutput></th>
      		<td><div align="center">To</div></td>
      		<td width="69%">
				<select name="locto">
					<cfif HUserGrpID eq 'Super' or getpin2.h4700 neq 'T'>
          				<option value="">Choose a <cfoutput>#getgeneral.lLOCATION#</cfoutput></option>
					</cfif>
					<!--- <option value="">Choose a Location</option> --->
					<cfoutput query="getlocation"> 
            			<option value="#getlocation.location#">#getlocation.location# - #getlocation.desp#</option>
          			</cfoutput>
				</select>
			</td>
      		<td width="10%"><input type="Submit" name="Submit" value="Submit"></td>
    	</tr>
  	</table>
</cfform>
<cfwindow width="550" height="400" name="finditem" refreshOnShow="true"
        title="Find Item" initshow="false"
        source="finditem.cfm?type=Product&fromto={fromto}" />
</body>
</html>