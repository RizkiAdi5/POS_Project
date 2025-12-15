<cfinclude template = "../../CFC/convert_single_double_quote_script.cfm">
<html>
<head>
<title>Profit Margin Report</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
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
	if(type == 'itemto'){
		var inputtext = document.profitmargin.searchitemto.value;
		DWREngine._execute(_reportflocation, null, 'productlookup', inputtext, getProductResult);
		
	}else{
		var inputtext = document.profitmargin.searchitemfr.value;
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

// begin: category search
function getCategory(type){
	if(type == 'catefrom'){
		var inputtext = document.profitmargin.searchcatefr.value;
		DWREngine._execute(_reportflocation, null, 'categorylookup', inputtext, getCategoryResult);
	}else{
		var inputtext = document.profitmargin.searchcateto.value;
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
		var inputtext = document.profitmargin.searchgroupfr.value;
		DWREngine._execute(_reportflocation, null, 'grouplookup', inputtext, getGroupResult);
		
	}
	else{
		var inputtext = document.profitmargin.searchgroupto.value;
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

// begin: supplier search
function getCust(type,option){
	if(type == 'custfrom'){
		var inputtext = document.profitmargin.searchsuppfr.value;
		DWREngine._execute(_reportflocation, null, 'supplierlookup', inputtext, option, getCustResult);
		
	}
	else{
		var inputtext = document.profitmargin.searchsuppto.value;
		DWREngine._execute(_reportflocation, null, 'supplierlookup', inputtext, option, getCustResult2);
	}
}

function getCustResult(suppArray){
	DWRUtil.removeAllOptions("custfrom");
	DWRUtil.addOptions("custfrom", suppArray,"KEY", "VALUE");
}

function getCustResult2(suppArray){
	DWRUtil.removeAllOptions("custto");
	DWRUtil.addOptions("custto", suppArray,"KEY", "VALUE");
}
// end: supplier search

</script>

</head>

<cfswitch expression="#url.type#">
	<cfcase value="productmargin"><cfset trantype = "PROFIT MARGIN BY PRODUCT"></cfcase>
	<cfcase value="billmargin"><cfset trantype = "PROFIT MARGIN BY BILL"></cfcase>
	<cfcase value="agentmargin"><cfset trantype = "PROFIT MARGIN BY AGENT"></cfcase>
	<cfcase value="projectmargin"><cfset trantype = "PROFIT MARGIN BY PROJECT"></cfcase>
	<cfcase value="billitemmargin"><cfset trantype = "PROFIT MARGIN BY BILL ITEM"></cfcase>
	<cfcase value="customermargin"><cfset trantype = "PROFIT MARGIN BY CUSTOMER"></cfcase>
</cfswitch>

<!--- REMARK ON 200908 --->
<!---cfquery name="getgeneral" datasource="#dts#">
	select lastaccyear from gsetup
</cfquery--->

<cfquery name="getgeneral" datasource="#dts#">
	select lastaccyear,filterall,lCATEGORY,lGROUP,lSIZE,lMATERIAL,lMODEL,lRATING,lAGENT,lDRIVER,lLOCATION,agentuserid,lTEAM from gsetup
</cfquery>
<!--- Add On 15-01-2010 --->
<cfquery name="getdealer_menu" datasource="#dts#">
	select custSuppSortBy,productSortBy from dealer_menu limit 1
</cfquery>

<cfset clsyear = year(getgeneral.lastaccyear)>	
<cfset clsmonth = month(getgeneral.lastaccyear)>
<!--- period default --->
<cfset newmonth = clsmonth + 1>	

<cfif newmonth gt 12>
	<cfset newmonth = newmonth - 12>
	<cfset newyear = clsyear + 1>
<cfelse>
	<cfset newyear = clsyear>
</cfif>

<cfset newdate = CreateDate(newyear, newmonth, newmonth)>
<cfset vmonth = dateformat(newdate,"mmm yy")>
<cfset xnewmonth = newmonth + 11>
	
<cfif xnewmonth gt 12>
	<cfset xnewmonth = xnewmonth - 12>
	<cfset xnewyear = newyear + 1>
<cfelse>
	<cfset xnewyear = newyear>
</cfif>

<cfset xnewdate = CreateDate(xnewyear, xnewmonth, xnewmonth)>
<cfset vmonthto = dateformat(xnewdate,"mmm yy")>
<!--- period 1 --->
<cfset newmonth1 = clsmonth + 1>

<cfif newmonth1 gt 12>
	<cfset newmonth1 = newmonth1 - 12>
	<cfset newyear1 = clsyear + 1>
<cfelse>
	<cfset newyear1 = clsyear>
</cfif>

<cfset newdate1 = CreateDate(newyear1, newmonth1, newmonth1)>
<cfset vmonthto1 = dateformat(newdate1,"mmm yy")>
<!--- period 2 --->
<cfset newmonth2 = clsmonth + 2>

<cfif newmonth2 gt 12>
	<cfset newmonth2 = newmonth2 - 12>
	<cfset newyear2 = clsyear + 1>
<cfelse>
	<cfset newyear2 = clsyear>
</cfif>

<cfset newdate2 = CreateDate(newyear2, newmonth2, newmonth2)>
<cfset vmonthto2 = dateformat(newdate2,"mmm yy")>
<!--- period 3 --->
<cfset newmonth3 = clsmonth + 3>	

<cfif newmonth3 gt 12>
	<cfset newmonth3 = newmonth3 - 12>
	<cfset newyear3= clsyear + 1>
<cfelse>
	<cfset newyear3 = clsyear>
</cfif>

<cfset newdate3 = CreateDate(newyear3, newmonth3, newmonth3)>
<cfset vmonthto3 = dateformat(newdate3,"mmm yy")>
<!--- period 4--->
<cfset newmonth4 = clsmonth + 4>	

<cfif newmonth4 gt 12>
	<cfset newmonth4 = newmonth4 - 12>
	<cfset newyear4= clsyear + 1>
<cfelse>
	<cfset newyear4 = clsyear>
</cfif>

<cfset newdate4 = CreateDate(newyear4, newmonth4, newmonth4)>
<cfset vmonthto4 = dateformat(newdate4,"mmm yy")>
<!--- period 5--->
<cfset newmonth5 = clsmonth + 5>

<cfif newmonth5 gt 12>
	<cfset newmonth5 = newmonth5 - 12>
	<cfset newyear5= clsyear + 1>
<cfelse>
	<cfset newyear5 = clsyear>
</cfif>

<cfset newdate5 = CreateDate(newyear5, newmonth5, newmonth5)>
<cfset vmonthto5 = dateformat(newdate5,"mmm yy")>
<!--- period 6--->
<cfset newmonth6 = clsmonth + 6>

<cfif newmonth6 gt 12>
	<cfset newmonth6 = newmonth6 - 12>
	<cfset newyear6= clsyear + 1>
<cfelse>
	<cfset newyear6 = clsyear>
</cfif>

<cfset newdate6 = CreateDate(newyear6, newmonth6, newmonth6)>
<cfset vmonthto6 = dateformat(newdate6,"mmm yy")>
<!--- period 7--->
<cfset newmonth7 = clsmonth + 7>

<cfif newmonth7 gt 12>
	<cfset newmonth7 = newmonth7 - 12>
	<cfset newyear7= clsyear + 1>
<cfelse>
	<cfset newyear7 = clsyear>
</cfif>

<cfset newdate7 = CreateDate(newyear7, newmonth7, newmonth7)>
<cfset vmonthto7 = dateformat(newdate7,"mmm yy")>
<!--- period 8--->
<cfset newmonth8 = clsmonth + 8>

<cfif newmonth8 gt 12>
	<cfset newmonth8 = newmonth8 - 12>
	<cfset newyear8= clsyear + 1>
<cfelse>
	<cfset newyear8 = clsyear>
</cfif>

<cfset newdate8 = CreateDate(newyear8, newmonth8, newmonth8)>
<cfset vmonthto8 = dateformat(newdate8,"mmm yy")>
<!--- period 9--->
<cfset newmonth9 = clsmonth + 9>

<cfif newmonth9 gt 12>
	<cfset newmonth9 = newmonth9 - 12>
	<cfset newyear9= clsyear + 1>
<cfelse>
	<cfset newyear9 = clsyear>
</cfif>

<cfset newdate9 = CreateDate(newyear9, newmonth9, newmonth9)>
<cfset vmonthto9 = dateformat(newdate9,"mmm yy")>
<!--- period 10--->
<cfset newmonth10 = clsmonth + 10>

<cfif newmonth10 gt 12>
	<cfset newmonth10 = newmonth10 - 12>
	<cfset newyear10= clsyear + 1>
<cfelse>
	<cfset newyear10 = clsyear>
</cfif>

<cfset newdate10 = CreateDate(newyear10, newmonth10, newmonth10)>
<cfset vmonthto10 = dateformat(newdate10,"mmm yy")>
<!--- period 11--->
<cfset newmonth11 = clsmonth + 11>

<cfif newmonth11 gt 12>
	<cfset newmonth11 = newmonth11 - 12>
	<cfset newyear11= clsyear + 1>
<cfelse>
	<cfset newyear11 = clsyear>
</cfif>

<cfset newdate11 = CreateDate(newyear11, newmonth11, newmonth11)>
<cfset vmonthto11 = dateformat(newdate11,"mmm yy")>
<!--- period 12--->
<cfset newmonth12 = clsmonth + 12>

<cfif newmonth12 gt 12>
	<cfset newmonth12 = newmonth12 - 12>
	<cfset newyear12= clsyear + 1>
<cfelse>
	<cfset newyear12 = clsyear>
</cfif>

<cfset newdate12 = CreateDate(newyear12, newmonth12, newmonth12)>
<cfset vmonthto12 = dateformat(newdate12,"mmm yy")>
<!--- period 13--->
<cfset newmonth13 = clsmonth + 13>

<cfif newmonth13 gt 24>
	<cfset newmonth13 = newmonth13 - 24>
	<cfset newyear13= clsyear + 2>	
<cfelseif newmonth13 gt 12>
	<cfset newmonth13 = newmonth13 - 12>
	<cfset newyear13= clsyear + 1>
<cfelse>
	<cfset newyear13 = clsyear>
</cfif>

<cfset newdate13 = CreateDate(newyear13, newmonth13, newmonth13)>
<cfset vmonthto13 = dateformat(newdate13,"mmm yy")>
<!--- period 14--->
<cfset newmonth14 = clsmonth + 14>

<cfif newmonth14 gt 24>
	<cfset newmonth14 = newmonth14 - 24>
	<cfset newyear14= clsyear + 2>	
<cfelseif newmonth14 gt 12>
	<cfset newmonth14 = newmonth14 - 12>
	<cfset newyear14= clsyear + 1>
<cfelse>
	<cfset newyear14 = clsyear>
</cfif>

<cfset newdate14 = CreateDate(newyear14, newmonth14, newmonth14)>
<cfset vmonthto14 = dateformat(newdate14,"mmm yy")>
<!--- period 15--->
<cfset newmonth15 = clsmonth + 15>

<cfif newmonth15 gt 24>
	<cfset newmonth15 = newmonth15 - 24>
	<cfset newyear15= clsyear + 2>	
<cfelseif newmonth15 gt 12>
	<cfset newmonth15 = newmonth15 - 12>
	<cfset newyear15= clsyear + 1>
<cfelse>
	<cfset newyear15 = clsyear>
</cfif>

<cfset newdate15 = CreateDate(newyear15, newmonth15, newmonth15)>
<cfset vmonthto15 = dateformat(newdate15,"mmm yy")>
<!--- period 16--->
<cfset newmonth16 = clsmonth + 16>

<cfif newmonth16 gt 24>
	<cfset newmonth16 = newmonth16 - 24>
	<cfset newyear16= clsyear + 2>	
<cfelseif newmonth16 gt 12>
	<cfset newmonth16 = newmonth16 - 12>
	<cfset newyear16= clsyear + 1>
<cfelse>
	<cfset newyear16 = clsyear>
</cfif>

<cfset newdate16 = CreateDate(newyear16, newmonth16, newmonth16)>
<cfset vmonthto16 = dateformat(newdate16,"mmm yy")>
<!--- period 17--->
<cfset newmonth17 = clsmonth + 17>

<cfif newmonth17 gt 24>
	<cfset newmonth17 = newmonth17 - 24>
	<cfset newyear17= clsyear + 2>	
<cfelseif newmonth17 gt 12>
	<cfset newmonth17 = newmonth17 - 12>
	<cfset newyear17= clsyear + 1>
<cfelse>
	<cfset newyear17 = clsyear>
</cfif>

<cfset newdate17 = CreateDate(newyear17, newmonth17, newmonth17)>
<cfset vmonthto17 = dateformat(newdate17,"mmm yy")>
<!--- period 18--->
<cfset newmonth18 = clsmonth + 18>

<cfif newmonth18 gt 24>
	<cfset newmonth18 = newmonth18 - 24>
	<cfset newyear18= clsyear + 2>	
<cfelseif newmonth18 gt 12>
	<cfset newmonth18 = newmonth18 - 12>
	<cfset newyear18= clsyear + 1>
<cfelse>
	<cfset newyear18 = clsyear>
</cfif>

<cfset newdate18 = CreateDate(newyear18, newmonth18, newmonth18)>
<cfset vmonthto18 = dateformat(newdate18,"mmm yy")>

<body>
<cfoutput>
<!--- <h2>Print #trantype# Report</h2> --->
<h3>
	<a href="salesmenu.cfm">Sales Report Menu</a> >> 
	<a><font size="2">Print #trantype# Report</font></a>
</h3>
<h3 align="left">* Please Run Calculate Cost Before Using This Function</h3>
<cfif type is "productmargin">
	<cfquery name="getcate" datasource="#dts#">
		select cate,desp from iccate order by cate
	</cfquery>
	
	<cfquery name="getgroup" datasource="#dts#">
		select wos_group,desp from icgroup order by wos_group
	</cfquery>
	
	<!--- <cfquery name="getitem" datasource="#dts#">
		select itemno, desp from icitem order by itemno
	</cfquery> --->
	<cfquery name="getitem" datasource="#dts#">
		select itemno, desp from icitem order by <cfif getdealer_menu.productSortBy neq "">#getdealer_menu.productSortBy#<cfelse>itemno</cfif>
	</cfquery>

	<!--- <cfquery name="getcust" datasource="#dts#">
		select custno, name from #target_arcust# order by custno
	</cfquery>  --->
	<cfquery name="getcust" datasource="#dts#">
		select custno, name from #target_arcust# order by <cfif getdealer_menu.custSuppSortBy neq "">#getdealer_menu.custSuppSortBy#<cfelse>custno</cfif>
	</cfquery> 

<form name="profitmargin" action="profitmargin1.cfm?trantype=#trantype#" method="post" target="_blank">
<table width="75%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
	<tr><input type="hidden" name="tran" id="tran" value="#target_arcust#" /><input type="hidden" name="fromto" id="fromto" value="" />
		<th>Report Format</th>
		<td><input type="radio" name="result" value="HTML" checked>HTML<br/>
			<input type="radio" name="result" value="EXCELDEFAULT">EXCEL DEFAULT<br/>
			<input type="radio" name="result" value="EXCELGROUP">EXCEL - BY GROUP<br/>
			<input type="radio" name="result" value="EXCELNODISCOUNT">EXCEL - WITHOUT SALES DISCOUNT<br/>
			<input type="radio" name="result" value="EXCELXCOST">EXCEL - WITH ADDITIONAL COST<br/>
			<input type="checkbox" name="withcategory" value="">WITH CATEGORY
			&nbsp;&nbsp;&nbsp;<input type="checkbox" name="withgroup" value="">WITH GROUP
            <br/><input type="checkbox" name="include0" value="">Exclude 0 Qty
		</td>
	</tr>
	<tr> 
        <td colspan="4"><hr></td>
    </tr>
	<tr>  
    	<th>#getgeneral.lCATEGORY# From</th>
        <td><select name="catefrom">
				<option value="">Choose a #getgeneral.lCATEGORY#</option>
				<cfloop query="getcate">
				<option value="#cate#">#cate# - #desp#</option>
				</cfloop>
			</select>
            <cfif getgeneral.filterall eq "1">
				<input type="text" name="searchcatefr" onKeyUp="getCategory('catefrom');">
			</cfif>
		</td>
    </tr>
    <tr> 
        <th>#getgeneral.lCATEGORY# To</th>
        <td><select name="cateto">
				<option value="">Choose a #getgeneral.lCATEGORY#</option>
				<cfloop query="getcate">
				<option value="#cate#">#cate# - #desp#</option>
				</cfloop>
			</select>
            <cfif getgeneral.filterall eq "1">
				<input type="text" name="searchcateto" onKeyUp="getCategory('cateto');">
			</cfif>
		</td>
    </tr>
    <tr> 
        <td colspan="4"><hr></td>
    </tr>
    <tr> 
        <th>#getgeneral.lGROUP# From</th>
        <td><select name="groupfrom">
				<option value="">Choose a #getgeneral.lGROUP#</option>
				<cfloop query="getgroup">
				<option value="#wos_group#">#wos_group# - #desp#</option>
				</cfloop>
			</select>
            <cfif getgeneral.filterall eq "1">
				<input type="text" name="searchgroupfr" onKeyUp="getGroup('groupfrom');">
			</cfif>
		</td>
    </tr>
    <tr> 
        <th>#getgeneral.lGROUP# To</th>
        <td><select name="groupto">
				<option value="">Choose a #getgeneral.lGROUP#</option>
				<cfloop query="getgroup">
				<option value="#wos_group#">#wos_group# - #desp#</option>
				</cfloop>
			</select>
            <cfif getgeneral.filterall eq "1">
				<input type="text" name="searchgroupto" onKeyUp="getGroup('groupto');">
			</cfif>
		</td>
    </tr>
    <tr> 
        <td colspan="4"><hr></td>
    </tr>
    <tr>   
    <th>Item No From</th>
        <td><select name="itemfrom">
				<option value="">Choose an Item</option>
				<cfloop query="getitem">
				<option value="#convertquote(itemno)#">#itemno# - #desp#</option>
				</cfloop>
			</select>
            <cfif getgeneral.filterall eq "1">
            <input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='from';ColdFusion.Window.show('finditem');" />&nbsp;
				<input type="text" name="searchitemfr" onKeyUp="getProduct('itemfrom');">
			</cfif>
		</td>
    </tr>
    <tr> 
        <th>Item No To</th>
        <td><select name="itemto">
				<option value="">Choose an Item</option>
				<cfloop query="getitem">
				<option value="#convertquote(itemno)#">#itemno# - #desp#</option>
				</cfloop>
			</select>
            <cfif getgeneral.filterall eq "1">
            <input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='to';ColdFusion.Window.show('finditem');" />&nbsp;
				<input type="text" name="searchitemto" onKeyUp="getProduct('itemto');">
			</cfif>
		</td>
    </tr>
    <tr> 
        <td colspan="4"><hr></td>
    </tr>
	  	<th>Customer From</th>
        <td><select name="custfrom">
				<option value="">Choose a Customer</option>
				<cfloop query="getcust">
				<option value="#custno#">#custno# - #name#</option>
				</cfloop>
			</select>
            <cfif getgeneral.filterall eq "1">
				
<input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='from';ColdFusion.Window.show('findCustomer');" />&nbsp;<input type="text" name="searchsuppfr" onKeyUp="getCust('custfrom','Customer');">
			</cfif>
		</td>
    </tr>
    <tr> 
        <th>Customer To</th>
        <td><select name="custto">
				<option value="">Choose a Customer</option>
				<cfloop query="getcust">
				<option value="#custno#">#custno# - #name#</option>
				</cfloop>
			</select>
            <cfif getgeneral.filterall eq "1">
				<input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='to';ColdFusion.Window.show('findCustomer');" />&nbsp;<input type="text" name="searchsuppto" onKeyUp="getCust('custto','Customer');">
			</cfif>
		</td>
    </tr>
	<tr> 
        <td colspan="4"><hr></td>
    </tr>
    <tr> 
        <th>Period From</th>
        <td><select name="periodfrom" onChange="displaymonth()">
			<option value="">Choose a Period</option>
			<option value="01"selected>1</option>
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
			</select>&nbsp;<input type="text" name="monthfrom" value="#vmonth#" size="6" readonly>
		</td>
    </tr>
    <tr> 
        <th>Period To</th>
        <td><select name="periodto" onChange="displaymonth()">
			<option value="">Choose a Period</option>
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
			<option value="12"selected>12</option>
			<option value="13">13</option>
			<option value="14">14</option>
			<option value="15">15</option>
			<option value="16">16</option>
			<option value="17">17</option>
			<option value="18">18</option>
			</select>&nbsp;<input type="text" name="monthto" value="#vmonthto#" size="6" readonly>
		</td>
    </tr>
    <tr> 
        <td colspan="4"><hr></td>
    </tr>
    <tr> 
        <th>Date From</th>
        <td><input type="text" name="datefrom" validate="eurodate" message="Invalid Input" maxlength="10" size="10"> (DD/MM/YYYY)</td>
    </tr>
    <tr> 
        <th>Date To</th>
        <td><input type="text" name="dateto" validate="eurodate" message="Invalid Input" maxlength="10" size="10"> (DD/MM/YYYY)</td>
    </tr>

	<tr> 
        <td colspan="2" align="right"><input type="submit" name="Submit" value="Submit"></td>
    </tr>
</table>
</form>
<cfelseif type eq "billmargin" or type eq "billitemmargin">
	<cfquery name="getproject" datasource="#dts#">
		select source,project from project <cfif lcase(HcomID) eq "mphcranes_i">order by project<cfelse> order by source</cfif>
	</cfquery>
	
	<!--- <cfquery name="getcust" datasource="#dts#">
		select custno, name from #target_arcust# order by custno
	</cfquery> --->
	<cfquery name="getcust" datasource="#dts#">
		select custno, name from #target_arcust# order by <cfif getdealer_menu.custSuppSortBy neq "">#getdealer_menu.custSuppSortBy#<cfelse>custno</cfif>
	</cfquery> 
	
	<cfquery name="getarea" datasource="#dts#">
		select area,desp from icarea order by area;
	</cfquery>
    
    <cfquery name="getteam" datasource="#dts#">
		select team,desp from icteam order by team;
	</cfquery>

	<cfif type eq "billmargin">
		<form name="profitmargin" action="profitmargin2.cfm?trantype=#trantype#" method="post" target="_blank">
		<table width="65%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
			<tr><input type="hidden" name="tran" id="tran" value="#target_arcust#" /><input type="hidden" name="fromto" id="fromto" value="" />
				<th>Report Format</th>
				<td><input type="radio" name="result" value="HTML" checked>HTML<br/>
					<input type="radio" name="result" value="EXCELDEFAULT">EXCEL DEFAULT<br/>
					<input type="radio" name="result" value="EXCELDISCOUNT">EXCEL - AFTER PROVOSION DISCOUNT<br/>
					<input type="radio" name="result" value="EXCELXCOST">EXCEL - WITH ADDITIONAL COST
				</td>
			</tr>
	<cfelse>
		<form name="profitmargin" action="profitmargin5.cfm?trantype=#trantype#" method="post" target="_blank">
		<table width="65%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
			<tr><input type="hidden" name="tran" id="tran" value="#target_arcust#" /><input type="hidden" name="fromto" id="fromto" value="" />
				<th>Report Format</th>
				<td><input type="radio" name="result" value="HTML" checked>HTML<br/>
					<input type="radio" name="result" value="EXCEL">EXCEL
				</td>
			</tr>
	</cfif>
	<tr> 
        <td colspan="4"><hr></td>
    </tr>
	<cfif lcase(HcomID) eq "chemline_i">
		<tr> 
	        <th>Refno From</th>
	        <td><input type="text" name="refnofrom"></td>
	    </tr>
	    <tr> 
	        <th>Refno To</th>
	        <td><input type="text" name="refnoto"></td>
	    </tr>
	    <tr> 
	        <td colspan="4"><hr></td>
	    </tr>
	</cfif>
	<cfif lcase(HcomID) eq "chemline_i" and type eq "billitemmargin">
		<cfquery name="getgroup" datasource="#dts#">
			select wos_group,desp from icgroup order by wos_group
		</cfquery>
		<tr> 
	        <th>#getgeneral.lGROUP# From</th>
	        <td><select name="groupfrom">
					<option value="">Choose a #getgeneral.lGROUP#</option>
					<cfloop query="getgroup">
					<option value="#wos_group#">#wos_group# - #desp#</option>
					</cfloop>
				</select>
	            <cfif getgeneral.filterall eq "1">
					<input type="text" name="searchgroupfr" onKeyUp="getGroup('groupfrom');">
				</cfif>
			</td>
	    </tr>
	    <tr> 
	        <th>#getgeneral.lGROUP# To</th>
	        <td><select name="groupto">
					<option value="">Choose a #getgeneral.lGROUP#</option>
					<cfloop query="getgroup">
					<option value="#wos_group#">#wos_group# - #desp#</option>
					</cfloop>
				</select>
	            <cfif getgeneral.filterall eq "1">
					<input type="text" name="searchgroupto" onKeyUp="getGroup('groupto');">
				</cfif>
			</td>
	    </tr>
	    <tr> 
	        <td colspan="4"><hr></td>
	    </tr>
	</cfif>
	<tr> 
    	<th>#getgeneral.lAGENT# From</th>
        <td><select name="agentfrom">
				<cfif getpin2.h4700 eq 'T' and HUserGrpID neq 'Super'>
                <cfif getgeneral.agentuserid eq 'Y'>
					<cfquery name="getagent" datasource="#dts#">
						select agent,desp from icagent where agentID = '#HUserID#'
					</cfquery>
                    <cfelse>
                    <cfquery name="getagent" datasource="#dts#">
						select agent,desp from icagent where agent = '#HUserID#'
					</cfquery>
                    </cfif>
					<option value="#getagent.agent#">#getagent.agent#-#getagent.desp#</option>
				<cfelse>
					<cfquery name="getagent" datasource="#dts#">
						select agent,desp from icagent order by agent
					</cfquery>
					<option value="">Choose an #getgeneral.lAGENT#</option>
					<cfloop query="getagent">
					<option value="#getagent.agent#">#getagent.agent# - #getagent.desp#</option>
					</cfloop>
				</cfif>
			</select>
		</td>
    </tr>
    <tr> 
        <th>#getgeneral.lAGENT# To</th>
        <td><select name="agentto">
				<cfif getpin2.h4700 eq 'T' and HUserGrpID neq 'Super'>
                 <cfif getgeneral.agentuserid eq 'Y'>
					<cfquery name="getagent" datasource="#dts#">
						select agent,desp from icagent where agentID = '#HUserID#'
					</cfquery>
                    <cfelse>
					<cfquery name="getagent" datasource="#dts#">
						select agent,desp from icagent where agent = '#HUserID#'
					</cfquery>
                    </cfif>
					<option value="#getagent.agent#">#getagent.agent#-#getagent.desp#</option>
				<cfelse>
					<cfquery name="getagent" datasource="#dts#">
						select agent,desp from icagent order by agent
					</cfquery>
					<option value="">Choose an #getgeneral.lAGENT#</option>
					<cfloop query="getagent">
					<option value="#getagent.agent#">#getagent.agent# - #getagent.desp#</option>
					</cfloop>
				</cfif>
			</select>
		</td>
    </tr>
    
    <tr> 
        <td colspan="4"><hr></td>
    </tr>
	<tr> 
        <th>#getgeneral.lTEAM# From</th>
        <td><select name="teamfrom">
				<option value="">Choose an #getgeneral.lTEAM#</option>
				<cfloop query="getteam">
				<option value="#team#">#team# - #desp#</option>
				</cfloop>
			</select>
		</td>
    </tr>
    <tr> 
        <th>#getgeneral.lTEAM# To</th>
        <td><select name="teamto">
				<option value="">Choose an #getgeneral.lTEAM#</option>
				<cfloop query="getteam">
				<option value="#team#">#team# - #desp#</option>
				</cfloop>
			</select>
		</td>
    </tr>
    
    <tr> 
        <td colspan="4"><hr></td>
    </tr>
	<tr> 
        <th>Area From</th>
        <td><select name="areafrom">
				<option value="">Choose an Area</option>
				<cfloop query="getarea">
				<option value="#area#">#area#</option>
				</cfloop>
			</select>
		</td>
    </tr>
    <tr> 
        <th>Area To</th>
        <td><select name="areato">
				<option value="">Choose an Area</option>
				<cfloop query="getarea">
				<option value="#area#">#area#</option>
				</cfloop>
			</select>
		</td>
    </tr>
    <tr> 
        <td colspan="4"><hr></td>
    </tr>
	<tr>     
    	<th>Customer From</th>
        <td><select name="custfrom">
				<option value="">Choose a Customer</option>
				<cfloop query="getcust">
				<option value="#custno#">#custno# - #name#</option>
				</cfloop>
			</select>
            <cfif getgeneral.filterall eq "1">
				<input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='from';ColdFusion.Window.show('findCustomer');" />&nbsp;<input type="text" name="searchsuppfr" onKeyUp="getCust('custfrom','Customer');">
			</cfif>
		</td>
    </tr>
    <tr> 
        <th>Customer To</th>
        <td><select name="custto">
				<option value="">Choose a Customer</option>
				<cfloop query="getcust">
				<option value="#custno#">#custno# - #name#</option>
				</cfloop>
			</select>
            <cfif getgeneral.filterall eq "1">
				<input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='to';ColdFusion.Window.show('findCustomer');" />&nbsp;<input type="text" name="searchsuppto" onKeyUp="getCust('custto','Customer');">
			</cfif>
		</td>
    </tr>
	<tr> 
        <td colspan="4"><hr></td>
    </tr>
	<tr> 
        <th>Project From</th>
        <td><select name="projectfrom">
				<option value="">Choose an Project</option>
				<cfloop query="getproject">
				<option value="#source#">#source# - #project#</option>
				</cfloop>
			</select>
		</td>
    </tr>
    <tr> 
        <th>Project To</th>
        <td><select name="projectto">
				<option value="">Choose an Project</option>
				<cfloop query="getproject">
				<option value="#source#">#source# - #project#</option>
				</cfloop>
			</select>
		</td>
    </tr>
	<tr> 
        <td colspan="4"><hr></td>
    </tr>      
    <tr> 
        <th>Period From</th>
        <td><select name="periodfrom" onChange="displaymonth()">
			<option value="">Choose a Period</option>
			<option value="01"selected>1</option>
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
			</select>&nbsp;<input type="text" name="monthfrom" value="#vmonth#" size="6" readonly>
		</td>
    </tr>
    <tr> 
        <th>Period To</th>
        <td><select name="periodto" onChange="displaymonth()">
			<option value="">Choose a Period</option>
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
			<option value="12"selected>12</option>
			<option value="13">13</option>
			<option value="14">14</option>
			<option value="15">15</option>
			<option value="16">16</option>
			<option value="17">17</option>
			<option value="18">18</option>
			</select>&nbsp;<input type="text" name="monthto" value="#vmonthto#" size="6" readonly>
		</td>
    </tr>
    <tr> 
        <td colspan="4"><hr></td>
    </tr>
    <tr> 
        <th>Date From</th>
        <td><input type="text" name="datefrom" validate="eurodate" message="Invalid Input" maxlength="10" size="10"> (DD/MM/YYYY)</td>
    </tr>
    
    <tr> 
        <th>Date To</th>
        <td><input type="text" name="dateto" validate="eurodate" message="Invalid Input" maxlength="10" size="10"> (DD/MM/YYYY) &nbsp;&nbsp;&nbsp;
			<input type="checkbox" name="sort" value="yes">  Sort By Reference No
		</td>
    </tr>
   <tr> 
        <td colspan="4"><hr></td>
    </tr>
    <tr>
    <th>Filter by</th>
     <td><input type="radio" name="radio1" id="radio1" value="all" checked>Service and Item</td>
     </tr>
     <tr><td></td>
     <td><input type="radio" name="radio1" id="radio1" value="item" />Item Only</td>
     </tr>
     <tr><td></td>
     <td><input type="radio" name="radio1" id="radio1" value="serv" />Service Only</td>
    </tr>
      <tr> 
        <td colspan="4"><hr></td>
    </tr>
    <tr> 
        <td colspan="2" align="right"><input type="submit" name="Submit" value="Submit"></td>
    </tr>      
</table>
</form>
<cfelseif type is "agentmargin">
	<!--- <cfquery name="getcust" datasource="#dts#">
		select custno, name from #target_arcust# order by custno
	</cfquery> --->
	<cfquery name="getcust" datasource="#dts#">
		select custno, name from #target_arcust# order by <cfif getdealer_menu.custSuppSortBy neq "">#getdealer_menu.custSuppSortBy#<cfelse>custno</cfif>
	</cfquery> 
	
	<cfquery name="getarea" datasource="#dts#">
		select area,desp from icarea order by area 
	</cfquery>
    
    <cfquery name="getteam" datasource="#dts#">
		select team,desp from icteam order by team;
	</cfquery>

<form name="profitmargin" action="profitmargin3.cfm?trantype=#trantype#" method="post" target="_blank">
<table width="60%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
	<tr><input type="hidden" name="tran" id="tran" value="#target_arcust#" /><input type="hidden" name="fromto" id="fromto" value="" />
		<th>Report Format</th>
		<td><input type="radio" name="result" value="HTML" checked>HTML<br/>
			<input type="radio" name="result" value="EXCEL">EXCEL
		</td>
	</tr>
	<tr> 
        <td colspan="4"><hr></td>
    </tr>
	<tr> 
    	<th>#getgeneral.lAGENT# From</th>
        <td><select name="agentfrom">
				<cfif getpin2.h4700 eq 'T' and HUserGrpID neq 'Super'>
					<cfif getgeneral.agentuserid eq 'Y'>
					<cfquery name="getagent" datasource="#dts#">
						select agent,desp from icagent where agentID = '#HUserID#'
					</cfquery>
                    <cfelse>
					<cfquery name="getagent" datasource="#dts#">
						select agent,desp from icagent where agent = '#HUserID#'
					</cfquery>
                    </cfif>
					<option value="#getagent.agent#">#getagent.agent#-#getagent.desp#</option>
				<cfelse>
					<cfquery name="getagent" datasource="#dts#">
						select agent,desp from icagent order by agent
					</cfquery>
					<option value="">Choose an #getgeneral.lAGENT#</option>
					<cfloop query="getagent">
					<option value="#getagent.agent#">#getagent.agent# - #getagent.desp#</option>
					</cfloop>
				</cfif>
			</select>
		</td>
    </tr>
    <tr> 
        <th>#getgeneral.lAGENT# To</th>
        <td><select name="agentto">
				<cfif getpin2.h4700 eq 'T' and HUserGrpID neq 'Super'>
					<cfif getgeneral.agentuserid eq 'Y'>
					<cfquery name="getagent" datasource="#dts#">
						select agent,desp from icagent where agentID = '#HUserID#'
					</cfquery>
                    <cfelse>
					<cfquery name="getagent" datasource="#dts#">
						select agent,desp from icagent where agent = '#HUserID#'
					</cfquery>
                    </cfif>
					<option value="#getagent.agent#">#getagent.agent#-#getagent.desp#</option>
				<cfelse>
					<cfquery name="getagent" datasource="#dts#">
						select agent,desp from icagent order by agent
					</cfquery>
					<option value="">Choose an #getgeneral.lAGENT#</option>
					<cfloop query="getagent">
					<option value="#getagent.agent#">#getagent.agent# - #getagent.desp#</option>
					</cfloop>
				</cfif>
			</select>
		</td>
    </tr>
    
    <tr> 
        <td colspan="4"><hr></td>
    </tr>
	<tr> 
        <th>#getgeneral.lTEAM# From</th>
        <td><select name="teamfrom">
				<option value="">Choose an #getgeneral.lTEAM#</option>
				<cfloop query="getteam">
				<option value="#team#">#team# - #desp#</option>
				</cfloop>
			</select>
		</td>
    </tr>
    <tr> 
        <th>#getgeneral.lTEAM# To</th>
        <td><select name="teamto">
				<option value="">Choose an #getgeneral.lTEAM#</option>
				<cfloop query="getteam">
				<option value="#team#">#team# - #desp#</option>
				</cfloop>
			</select>
		</td>
    </tr>
    
    <tr> 
        <td colspan="4"><hr></td>
    </tr>
	<tr> 
        <th>Area From</th>
        <td><select name="areafrom">
				<option value="">Choose an Area</option>
				<cfloop query="getarea">
				<option value="#area#">#area#</option>
				</cfloop>
			</select>
		</td>
    </tr>
    <tr> 
        <th>Area To</th>
        <td><select name="areato">
				<option value="">Choose an Area</option>
				<cfloop query="getarea">
				<option value="#area#">#area#</option>
				</cfloop>
			</select>
		</td>
    </tr>
    <tr> 
        <td colspan="4"><hr></td>
    </tr>
	<tr>   
    	<th>Customer From</th>
        <td><select name="custfrom">
				<option value="">Choose a Customer</option>
				<cfloop query="getcust">
				<option value="#custno#">#custno# - #name#</option>
				</cfloop>
			</select>
            <cfif getgeneral.filterall eq "1">
				<input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='from';ColdFusion.Window.show('findCustomer');" />&nbsp;<input type="text" name="searchsuppfr" onKeyUp="getCust('custfrom','Customer');">
			</cfif>
		</td>
    </tr>
    <tr> 
        <th>Customer To</th>
        <td><select name="custto">
				<option value="">Choose a Customer</option>
				<cfloop query="getcust">
				<option value="#custno#">#custno# - #name#</option>
				</cfloop>
			</select>
            <cfif getgeneral.filterall eq "1">
				<input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='to';ColdFusion.Window.show('findCustomer');" />&nbsp;
<input type="text" name="searchsuppto" onKeyUp="getCust('custto','Customer');">
			</cfif>
		</td>
    </tr>
	<tr> 
        <td colspan="4"><hr></td>
    </tr>    
    <tr> 
        <th>Period From</th>
        <td><select name="periodfrom" onChange="displaymonth()">
			<option value="">Choose a Period</option>
			<option value="01"selected>1</option>
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
			</select>&nbsp;<input type="text" name="monthfrom" value="#vmonth#" size="6" readonly>
		</td>
    </tr>
    <tr> 
        <th>Period To</th>
        <td><select name="periodto" onChange="displaymonth()">
			<option value="">Choose a Period</option>
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
			<option value="12"selected>12</option>
			<option value="13">13</option>
			<option value="14">14</option>
			<option value="15">15</option>
			<option value="16">16</option>
			<option value="17">17</option>
			<option value="18">18</option>
			</select>&nbsp;<input type="text" name="monthto" value="#vmonthto#" size="6" readonly>
		</td>
    </tr>
    <tr> 
        <td colspan="4"><hr></td>
    </tr>
    <tr> 
        <th>Date From</th>
        <td><input type="text" name="datefrom" validate="eurodate" message="Invalid Input" maxlength="10" size="10"> (DD/MM/YYYY)</td>
    </tr>
    <tr> 
        <th>Date To</th>
        <td><input type="text" name="dateto" validate="eurodate" message="Invalid Input" maxlength="10" size="10"> (DD/MM/YYYY)</td>
    </tr>
    <tr> 
        <td colspan="4"><hr></td>
    </tr>
    <tr>
    <th>Filter by</th>
     <td><input type="radio" name="radio1" id="radio1" value="all" checked>Service and Item</td>
     </tr>
     <tr><td></td>
     <td><input type="radio" name="radio1" id="radio1" value="item" />Item Only</td>
     </tr>
     <tr><td></td>
     <td><input type="radio" name="radio1" id="radio1" value="serv" />Service Only</td>
    </tr>
      <tr> 
        <td colspan="4"><hr></td>
    </tr>
    <tr> 
        <td colspan="2" align="right"><input type="submit" name="Submit" value="Submit"></td>
    </tr>      
</table>
</form>
<cfelseif type eq "projectmargin">
	<cfquery name="getcate" datasource="#dts#">
		select cate,desp from iccate order by cate
	</cfquery>
	
	<cfquery name="getproject" datasource="#dts#">
		select source,project from project <cfif lcase(HcomID) eq "mphcranes_i">order by project<cfelse>order by source</cfif>
	</cfquery>
	
	<cfquery name="getgroup" datasource="#dts#">
		select wos_group,desp from icgroup order by wos_group
	</cfquery>
	
	<!--- <cfquery name="getitem" datasource="#dts#">
		select itemno, desp from icitem order by itemno
	</cfquery> --->
	<cfquery name="getitem" datasource="#dts#">
		select itemno, desp from icitem order by <cfif getdealer_menu.productSortBy neq "">#getdealer_menu.productSortBy#<cfelse>itemno</cfif>
	</cfquery>

<form name="profitmargin" action="profitmargin4.cfm?trantype=#trantype#" method="post" target="_blank">
<table width="70%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
	<tr><input type="hidden" name="tran" id="tran" value="#target_arcust#" /><input type="hidden" name="fromto" id="fromto" value="" />
		<th>Report Format</th>
		<td><input type="radio" name="result" value="HTML" checked>HTML<br/>
			<input type="radio" name="result" value="EXCEL">EXCEL
		</td>
	</tr>
	<tr> 
        <td colspan="4"><hr></td>
    </tr>
	<tr>     
		<th>#getgeneral.lCATEGORY# From</th>
		<td><select name="catefrom">
				<option value="">Choose a #getgeneral.lCATEGORY#</option>
				<cfloop query="getcate">
					<option value="#cate#">#cate# - #desp#</option>
				</cfloop>
			</select>
            <cfif getgeneral.filterall eq "1">
				<input type="text" name="searchcatefr" onKeyUp="getCategory('catefrom');">
			</cfif>
			</td>
    </tr>
    <tr> 
        <th>#getgeneral.lCATEGORY# To</th>
        <td><select name="cateto">
				<option value="">Choose a #getgeneral.lCATEGORY#</option>
				<cfloop query="getcate">
				<option value="#cate#">#cate# - #desp#</option>
				</cfloop>
			</select>
            <cfif getgeneral.filterall eq "1">
				<input type="text" name="searchcateto" onKeyUp="getCategory('cateto');">
			</cfif>
		</td>
    </tr>
	<tr> 
		<td colspan="4"><hr></td>
	</tr>
    <tr> 
        <th>#getgeneral.lGROUP# From</th>
        <td><select name="groupfrom">
				<option value="">Choose a #getgeneral.lGROUP#</option>
				<cfloop query="getgroup">
				<option value="#wos_group#">#wos_group# - #desp#</option>
				</cfloop>
			</select>
            <cfif getgeneral.filterall eq "1">
				<input type="text" name="searchgroupfr" onKeyUp="getGroup('groupfrom');">
			</cfif>
		</td>
    </tr>
    <tr> 
        <th>#getgeneral.lGROUP# To</th>
        <td><select name="groupto">
				<option value="">Choose a #getgeneral.lGROUP#</option>
				<cfloop query="getgroup">
				<option value="#wos_group#">#wos_group# - #desp#</option>
				</cfloop>
			</select>
            <cfif getgeneral.filterall eq "1">
				<input type="text" name="searchgroupto" onKeyUp="getGroup('groupto');">
			</cfif>
		</td>
    </tr>
    <tr> 
        <td colspan="4"><hr></td>
    </tr>
	<tr> 
      	<th>Item No From</th>
        <td><select name="itemfrom">
				<option value="">Choose an Item</option>
				<cfloop query="getitem">
				<option value="#itemno#">#itemno# - #desp#</option>
				</cfloop>
			</select>
            <cfif getgeneral.filterall eq "1">
            <input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='from';ColdFusion.Window.show('finditem');" />&nbsp;
				<input type="text" name="searchitemfr" onKeyUp="getProduct('itemfrom');">
			</cfif>
		</td>
    </tr>
    <tr> 
        <th>Item No To</th>
        <td><select name="itemto">
				<option value="">Choose an Item</option>
				<cfloop query="getitem">
				<option value="#itemno#">#itemno# - #desp#</option>
				</cfloop>
			</select>
            <cfif getgeneral.filterall eq "1">
            <input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='to';ColdFusion.Window.show('finditem');" />&nbsp;
				<input type="text" name="searchitemto" onKeyUp="getProduct('itemto');">
			</cfif>
		</td>
    </tr>
	<tr> 
        <td colspan="4"><hr></td>
    </tr>
	<tr> 
        <th>Project From</th>
        <td><select name="projectfrom">
				<option value="">Choose an Project</option>
				<cfloop query="getproject">
				<option value="#source#">#source# - #project#</option>
				</cfloop>
			</select>
		</td>
    </tr>
    <tr> 
        <th>Project To</th>
        <td><select name="projectto">
				<option value="">Choose an Project</option>
				<cfloop query="getproject">
				<option value="#source#">#source# - #project#</option>
				</cfloop>
			</select>
		</td>
    </tr>
	<tr> 
        <td colspan="4"><hr></td>
    </tr>
	<tr>
    	<th>Period From</th>
        <td><select name="periodfrom" onChange="displaymonth()">
			<option value="">Choose a Period</option>
			<option value="01"selected>1</option>
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
			</select>&nbsp;<input type="text" name="monthfrom" value="#vmonth#" size="6" readonly>
		</td>
    </tr>
    <tr> 
        <th>Period To</th>
        <td><select name="periodto" onChange="displaymonth()">
			<option value="">Choose a Period</option>
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
			<option value="12"selected>12</option>
			<option value="13">13</option>
			<option value="14">14</option>
			<option value="15">15</option>
			<option value="16">16</option>
			<option value="17">17</option>
			<option value="18">18</option>
			</select>&nbsp;<input type="text" name="monthto" value="#vmonthto#" size="6" readonly>
		</td>
    </tr>
    <tr> 
        <td colspan="4"><hr></td>
    </tr>
    <tr> 
    	<th>Date From</th>
        <td><input type="text" name="datefrom" validate="eurodate" message="Invalid Input" maxlength="10" size="10"> (DD/MM/YYYY)</td>
    </tr>
    <tr> 
        <th>Date To</th>
        <td><input type="text" name="dateto" validate="eurodate" message="Invalid Input" maxlength="10" size="10"> (DD/MM/YYYY)</td>
    </tr>
    
    <tr> 
        <td colspan="2" align="right"><input type="submit" name="Submit" value="Submit"></td>
    </tr>
</table>
</form>
<cfelseif type eq "customermargin">
	<!--- <cfquery name="getcust" datasource="#dts#">
		select custno, name from #target_arcust# order by custno
	</cfquery> --->
	<cfquery name="getcust" datasource="#dts#">
		select custno, name from #target_arcust# order by <cfif getdealer_menu.custSuppSortBy neq "">#getdealer_menu.custSuppSortBy#<cfelse>custno</cfif>
	</cfquery> 
	
	<cfquery name="getarea" datasource="#dts#">
		select area,desp from icarea order by area 
	</cfquery>
    
    <cfquery name="getteam" datasource="#dts#">
		select team,desp from icteam order by team;
	</cfquery>
<form name="profitmargin" action="profitmargin6.cfm?trantype=#trantype#" method="post" target="_blank">
<table width="65%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
	<tr><input type="hidden" name="tran" id="tran" value="#target_arcust#" /><input type="hidden" name="fromto" id="fromto" value="" />
		<th>Report Format</th>
		<td><input type="radio" name="result" value="HTML" checked>HTML<br/>
			<input type="radio" name="result" value="EXCELDEFAULT">EXCEL DEFAULT<br/>
			<input type="radio" name="result" value="EXCELWITHADDITIONALCOST">EXCEL WITH ADDITIONAL COST
		</td>
	</tr>
	<tr> 
        <td colspan="4"><hr></td>
    </tr>
	<tr> 
    	<th>#getgeneral.lAGENT# From</th>
        <td><select name="agentfrom">
				<cfif getpin2.h4700 eq 'T' and HUserGrpID neq 'Super'>
					<cfif getgeneral.agentuserid eq 'Y'>
					<cfquery name="getagent" datasource="#dts#">
						select agent,desp from icagent where agentID = '#HUserID#'
					</cfquery>
                    <cfelse>
					<cfquery name="getagent" datasource="#dts#">
						select agent,desp from icagent where agent = '#HUserID#'
					</cfquery>
                    </cfif>
					<option value="#getagent.agent#">#getagent.agent#-#getagent.desp#</option>
				<cfelse>
					<cfquery name="getagent" datasource="#dts#">
						select agent,desp from icagent order by agent
					</cfquery>
					<option value="">Choose an #getgeneral.lAGENT#</option>
					<cfloop query="getagent">
					<option value="#getagent.agent#">#getagent.agent# - #getagent.desp#</option>
					</cfloop>
				</cfif>
			</select>
		</td>
    </tr>
    <tr> 
        <th>#getgeneral.lAGENT# To</th>
        <td><select name="agentto">
				<cfif getpin2.h4700 eq 'T' and HUserGrpID neq 'Super'>
					<cfif getgeneral.agentuserid eq 'Y'>
					<cfquery name="getagent" datasource="#dts#">
						select agent,desp from icagent where agentID = '#HUserID#'
					</cfquery>
                    <cfelse>
					<cfquery name="getagent" datasource="#dts#">
						select agent,desp from icagent where agent = '#HUserID#'
					</cfquery>
                    </cfif>
					<option value="#getagent.agent#">#getagent.agent#-#getagent.desp#</option>
				<cfelse>
					<cfquery name="getagent" datasource="#dts#">
						select agent,desp from icagent order by agent
					</cfquery>
					<option value="">Choose an #getgeneral.lAGENT#</option>
					<cfloop query="getagent">
					<option value="#getagent.agent#">#getagent.agent# - #getagent.desp#</option>
					</cfloop>
				</cfif>
			</select>
		</td>
    </tr>
    
    <tr> 
        <td colspan="4"><hr></td>
    </tr>
	<tr> 
        <th>#getgeneral.lTEAM# From</th>
        <td><select name="teamfrom">
				<option value="">Choose an #getgeneral.lTEAM#</option>
				<cfloop query="getteam">
				<option value="#team#">#team# - #desp#</option>
				</cfloop>
			</select>
		</td>
    </tr>
    <tr> 
        <th>#getgeneral.lTEAM# To</th>
        <td><select name="teamto">
				<option value="">Choose an #getgeneral.lTEAM#</option>
				<cfloop query="getteam">
				<option value="#team#">#team# - #desp#</option>
				</cfloop>
			</select>
		</td>
    </tr>
    
    <tr> 
        <td colspan="4"><hr></td>
    </tr>
	<tr> 
        <th>Area From</th>
        <td><select name="areafrom">
				<option value="">Choose an Area</option>
				<cfloop query="getarea">
				<option value="#area#">#area#</option>
				</cfloop>
			</select>
		</td>
    </tr>
    <tr> 
        <th>Area To</th>
        <td><select name="areato">
				<option value="">Choose an Area</option>
				<cfloop query="getarea">
				<option value="#area#">#area#</option>
				</cfloop>
			</select>
		</td>
    </tr>
    <tr> 
        <td colspan="4"><hr></td>
    </tr>
	<tr>     
    	<th>Customer From</th>
        <td><select name="custfrom">
				<option value="">Choose a Customer</option>
				<cfloop query="getcust">
				<option value="#custno#">#custno# - #name#</option>
				</cfloop>
			</select>
            <cfif getgeneral.filterall eq "1">
				<input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='from';ColdFusion.Window.show('findCustomer');" />&nbsp;<input type="text" name="searchsuppfr" onKeyUp="getCust('custfrom','Customer');">
			</cfif>
		</td>
    </tr>
    <tr> 
        <th>Customer To</th>
        <td><select name="custto">
				<option value="">Choose a Customer</option>
				<cfloop query="getcust">
				<option value="#custno#">#custno# - #name#</option>
				</cfloop>
			</select>
            <cfif getgeneral.filterall eq "1">
				<input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='to';ColdFusion.Window.show('findCustomer');" />&nbsp;<input type="text" name="searchsuppto" onKeyUp="getCust('custto','Customer');">
			</cfif>
		</td>
    </tr>
	<tr> 
        <td colspan="4"><hr></td>
    </tr>
    <tr> 
        <th>Period From</th>
        <td><select name="periodfrom" onChange="displaymonth()">
			<option value="">Choose a Period</option>
			<option value="01"selected>1</option>
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
			</select>&nbsp;<input type="text" name="monthfrom" value="#vmonth#" size="6" readonly>
		</td>
    </tr>
    <tr> 
        <th>Period To</th>
        <td><select name="periodto" onChange="displaymonth()">
			<option value="">Choose a Period</option>
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
			<option value="12"selected>12</option>
			<option value="13">13</option>
			<option value="14">14</option>
			<option value="15">15</option>
			<option value="16">16</option>
			<option value="17">17</option>
			<option value="18">18</option>
			</select>&nbsp;<input type="text" name="monthto" value="#vmonthto#" size="6" readonly>
		</td>
    </tr>
    <tr> 
        <td colspan="4"><hr></td>
    </tr>
    <tr> 
        <th>Date From</th>
        <td><input type="text" name="datefrom" validate="eurodate" message="Invalid Input" maxlength="10" size="10"> (DD/MM/YYYY)</td>
    </tr>
    <tr> 
        <th>Date To</th>
        <td><input type="text" name="dateto" validate="eurodate" message="Invalid Input" maxlength="10" size="10"> (DD/MM/YYYY)</td>
    </tr>
    <tr> 
        <td colspan="4"><hr></td>
    </tr>
    <tr>
    <th>Filter by</th>
     <td><input type="radio" name="radio1" id="radio1" value="all" checked>Service and Item</td>
     </tr>
     <tr><td></td>
     <td><input type="radio" name="radio1" id="radio1" value="item" />Item Only</td>
     </tr>
     <tr><td></td>
     <td><input type="radio" name="radio1" id="radio1" value="serv" />Service Only</td>
    </tr>
      <tr> 
        <td colspan="4"><hr></td>
    </tr>
    <tr> 
        <td colspan="2" align="right"><input type="submit" name="Submit" value="Submit"></td>
    </tr>      
</table>
</form>
</cfif>

<script language="JavaScript">
	function displaymonth(){
	
	if(document.profitmargin.periodfrom.value=="")
	{	document.profitmargin.periodto.value = "";}
	
	if(document.profitmargin.periodfrom.value=='01')		
	{	document.profitmargin.monthfrom.value='#vmonthto1#'; }
		
	else if(document.profitmargin.periodfrom.value=='02')	
	{	document.profitmargin.monthfrom.value='#vmonthto2#'; }
	
	else if(document.profitmargin.periodfrom.value=='03')	
	{	document.profitmargin.monthfrom.value='#vmonthto3#'; }
	
	else if(document.profitmargin.periodfrom.value=='04')	
	{	document.profitmargin.monthfrom.value='#vmonthto4#'; }
	
	else if(document.profitmargin.periodfrom.value=='05')	
	{	document.profitmargin.monthfrom.value='#vmonthto5#'; }
	
	else if(document.profitmargin.periodfrom.value=='06')	
	{	document.profitmargin.monthfrom.value='#vmonthto6#'; }
	
	else if(document.profitmargin.periodfrom.value=='07')	
	{	document.profitmargin.monthfrom.value='#vmonthto7#'; }
	
	else if(document.profitmargin.periodfrom.value=='08')	
	{	document.profitmargin.monthfrom.value='#vmonthto8#'; }
	
	else if(document.profitmargin.periodfrom.value=='09')	
	{	document.profitmargin.monthfrom.value='#vmonthto9#'; }
	
	else if(document.profitmargin.periodfrom.value=='10')	
	{	document.profitmargin.monthfrom.value='#vmonthto10#'; }
	
	else if(document.profitmargin.periodfrom.value=='11')	
	{	document.profitmargin.monthfrom.value='#vmonthto11#'; }
	
	else if(document.profitmargin.periodfrom.value=='12')	
	{	document.profitmargin.monthfrom.value='#vmonthto12#'; }
	
	else if(document.profitmargin.periodfrom.value=='13')	
	{	document.profitmargin.monthfrom.value='#vmonthto13#'; }
	
	else if(document.profitmargin.periodfrom.value=='14')	
	{	document.profitmargin.monthfrom.value='#vmonthto14#'; }
	
	else if(document.profitmargin.periodfrom.value=='15')	
	{	document.profitmargin.monthfrom.value='#vmonthto15#'; }
	
	else if(document.profitmargin.periodfrom.value=='16')	
	{	document.profitmargin.monthfrom.value='#vmonthto16#'; }
	
	else if(document.profitmargin.periodfrom.value=='17')	
	{	document.profitmargin.monthfrom.value='#vmonthto17#'; }
	
	else if(document.profitmargin.periodfrom.value=='18')	
	{	document.profitmargin.monthfrom.value='#vmonthto18#'; }
	
	if(document.profitmargin.periodto.value=='01')		
	{	document.profitmargin.monthto.value='#vmonthto1#'; }
		
	else if(document.profitmargin.periodto.value=='02')	
	{	document.profitmargin.monthto.value='#vmonthto2#'; }
	
	else if(document.profitmargin.periodto.value=='03')	
	{	document.profitmargin.monthto.value='#vmonthto3#'; }
	
	else if(document.profitmargin.periodto.value=='04')	
	{	document.profitmargin.monthto.value='#vmonthto4#'; }
	
	else if(document.profitmargin.periodto.value=='05')	
	{	document.profitmargin.monthto.value='#vmonthto5#'; }
	
	else if(document.profitmargin.periodto.value=='06')	
	{	document.profitmargin.monthto.value='#vmonthto6#'; }
	
	else if(document.profitmargin.periodto.value=='07')	
	{	document.profitmargin.monthto.value='#vmonthto7#'; }
	
	else if(document.profitmargin.periodto.value=='08')	
	{	document.profitmargin.monthto.value='#vmonthto8#'; }
	
	else if(document.profitmargin.periodto.value=='09')	
	{	document.profitmargin.monthto.value='#vmonthto9#'; }
	
	else if(document.profitmargin.periodto.value=='10')	
	{	document.profitmargin.monthto.value='#vmonthto10#'; }
	
	else if(document.profitmargin.periodto.value=='11')	
	{	document.profitmargin.monthto.value='#vmonthto11#'; }
	
	else if(document.profitmargin.periodto.value=='12')	
	{	document.profitmargin.monthto.value='#vmonthto12#'; }
	
	else if(document.profitmargin.periodto.value=='13')	
	{	document.profitmargin.monthto.value='#vmonthto13#'; }
	
	else if(document.profitmargin.periodto.value=='14')	
	{	document.profitmargin.monthto.value='#vmonthto14#'; }
	
	else if(document.profitmargin.periodto.value=='15')	
	{	document.profitmargin.monthto.value='#vmonthto15#'; }
	
	else if(document.profitmargin.periodto.value=='16')	
	{	document.profitmargin.monthto.value='#vmonthto16#'; }
	
	else if(document.profitmargin.periodto.value=='17')	
	{	document.profitmargin.monthto.value='#vmonthto17#'; }
	
	else if(document.profitmargin.periodto.value=='18')	
	{	document.profitmargin.monthto.value='#vmonthto18#'; }
	
	}
</script>
</cfoutput>

<cfwindow  width="550" height="400" name="findCustomer" refreshOnShow="true"
        title="Find Customer or Supplier" initshow="false"
        source="findCustomer.cfm?type={tran}&fromto={fromto}" />
<cfwindow  width="550" height="400" name="finditem" refreshOnShow="true"
        title="Find Item" initshow="false"
        source="finditem.cfm?type=Item&fromto={fromto}" />
</body>
</html>