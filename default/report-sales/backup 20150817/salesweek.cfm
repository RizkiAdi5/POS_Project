<cfinclude template = "../../CFC/convert_single_double_quote_script.cfm">
<html>
<head>
<title>Sales Report By Week</title>
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
		var inputtext = document.salesweek.searchitemto.value;
		DWREngine._execute(_reportflocation, null, 'productlookup', inputtext, getProductResult);
		
	}else{
		var inputtext = document.salesweek.searchitemfr.value;
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
		var inputtext = document.salesweek.searchcatefr.value;
		DWREngine._execute(_reportflocation, null, 'categorylookup', inputtext, getCategoryResult);
	}else{
		var inputtext = document.salesweek.searchcateto.value;
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
		var inputtext = document.salesweek.searchgroupfr.value;
		DWREngine._execute(_reportflocation, null, 'grouplookup', inputtext, getGroupResult);
		
	}
	else{
		var inputtext = document.salesweek.searchgroupto.value;
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

<cfparam name="alown" default="0">

	<cfif getpin2.h4700 eq 'T'>
  		<cfset alown = 1>
  	</cfif>

<cfif type eq "productweek">
	<cfset trantype = "PRODUCTS">
<cfelseif type eq "customerweek">
	<cfset trantype = "CUSTOMERS">
<cfelseif type eq "agentweek">
	<cfset trantype = "AGENT">	
<cfelseif type eq "groupweek">
	<cfset trantype = "GROUP">
<cfelseif type eq "enduserweek">
	<cfset trantype = "END USER">
</cfif>

<!--- REMARK ON 190908 AND REPLACE WITH THE BELOW ONE --->
<!--- <cfquery name="getgeneral" datasource="#dts#">
	select lastaccyear from gsetup
</cfquery> --->
<cfquery name="getgeneral" datasource="#dts#">
	select lastaccyear,filterall,lCATEGORY,lGROUP,lSIZE,lMATERIAL,lMODEL,lRATING,lAGENT,lDRIVER,lLOCATION,agentuserid,AGENTLISTUSERID,lTEAM from gsetup
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
<!--- <h2>Print #trantype# Sales Report By Week</h2> --->
<h3>
	<a href="salesmenu.cfm">Sales Report Menu</a> >> 
	<a><font size="2">Print #trantype# Sales Report By Week</font></a>
</h3>

<cfif type is "productweek">
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

<cfquery name="getagent" datasource="#dts#">
	select agent,desp from icagent where 0=0 
    <cfif alown eq 1>
					<cfif getgeneral.agentlistuserid eq "Y">and ucase(agent) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and  ucase(agent)='#ucase(huserid)#'
					</cfif>
					<cfelse>
					
					</cfif>
    order by agent
</cfquery>

<cfquery name="getarea" datasource="#dts#">
	select area,desp from icarea icarea order by area 
</cfquery>

<cfquery datasource="#dts#" name="getuser">
	select * from driver 
</cfquery>

<cfquery name="getteam" datasource="#dts#">
		select team,desp from icteam order by team;
	</cfquery>

<form name="salesweek" action="salesweek1.cfm?trantype=#trantype#&alown=#alown#" method="post" target="_blank">
<table width="80%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
	<tr>
		<th>Report Format<input type="hidden" name="tran" id="tran" value="#target_arcust#" /><input type="hidden" name="fromto" id="fromto" value="" /></th>
	</tr>
	<tr>
	  	<td><input type="radio" name="label" id="2" value="salesvalue" checked> <label for="salesvalue">By Sales Value</label>
		<br><input type="radio" name="label" id="2" value="salesqty"> <label for="salesqty">By Sales Quantity</label></td>
		<td><input type="checkbox" name="include" value="yes"> Include DN/CN
		<br><input type="checkbox" name="include0" id="1" value="yes"> <label for="include0">Include 0 Figure</label></td>
	</tr>
	<tr> 
        <td colspan="3"><hr></td>
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
        <td colspan="3"><hr></td>
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
        <td colspan="3"><hr></td>
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
        <td colspan="3"><hr></td>
    </tr>
    <tr> 
        <th>#getgeneral.lAGENT# From</th>
        <td><select name="agentfrom">
					
					<option value="">Choose an #getgeneral.lAGENT#</option>
					<cfloop query="getagent">
					<option value="#getagent.agent#">#getagent.agent# - #getagent.desp#</option>
					</cfloop>
			</select>
		</td>
    </tr>
    <tr> 
        <th>#getgeneral.lAGENT# To</th>
        <td><select name="agentto">

					<option value="">Choose an #getgeneral.lAGENT#</option>
					<cfloop query="getagent">
					<option value="#getagent.agent#">#getagent.agent# - #getagent.desp#</option>
					</cfloop>

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
        <td colspan="3"><hr></td>
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
        <td colspan="3"><hr></td>
    </tr>
    <tr>
		<th>#getgeneral.lDRIVER# From</th>
        <td><select name="userfrom">
				<option value="">Choose an #getgeneral.lDRIVER#</option>
				<cfloop query="getuser">
				<option value="#driverno#">#driverno# - #name#</option>
				</cfloop>
			</select>
		</td>
    </tr>
    <tr> 
        <th>#getgeneral.lDRIVER# To</th>
        <td><select name="userto">
				<option value="">Choose an #getgeneral.lDRIVER#</option>
				<cfloop query="getuser">
				<option value="#driverno#">#driverno# - #name#</option>
				</cfloop>
			</select>
		</td>
    </tr>
	<tr> 
        <td colspan="3"><hr></td>
    </tr>
	<tr>
		<th>Period</th>
        <td><select name="periodfrom" onChange="displaymonth()">
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
        <td colspan="3" align="right"><input type="submit" name="Submit" value="Submit"></td>
    </tr>
</table>
</form>

<cfelseif type eq "customerweek">
<cfquery name="getagent" datasource="#dts#">
	select agent,desp from icagent where 0=0
    <cfif alown eq 1>
					<cfif getgeneral.agentlistuserid eq "Y">and ucase(agent) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and  ucase(agent)='#ucase(huserid)#'
					</cfif>
					<cfelse>
					
					</cfif>
                     order by agent
</cfquery>

<cfquery name="getarea" datasource="#dts#">
	select area,desp from icarea order by area 
</cfquery>

<cfquery datasource="#dts#" name="getuser">
	select * from driver 
</cfquery>

<cfquery name="getteam" datasource="#dts#">
		select team,desp from icteam order by team;
	</cfquery>

<form name="salesweek" action="salesweek2.cfm?trantype=#trantype#&alown=#alown#" method="post" target="_blank">
<table width="50%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
	<tr>
		<th>Report Format<input type="hidden" name="tran" id="tran" value="#target_arcust#" /><input type="hidden" name="fromto" id="fromto" value="" /></th>
	</tr>
	<tr>
	  	<td nowrap><input type="radio" name="label" id="2" value="salesvalue" checked> <label for="salesvalue">By Sales Value</label>
		<br><input type="radio" name="label" id="2" value="salesqty"> <label for="salesqty">By Sales Quantity</label></td>
		<td nowrap><input type="checkbox" name="include" value="yes"> Include DN/CN
		<br><input type="checkbox" name="include0" id="1" value="yes"> <label for="include0">Include 0 Figure</label>
        <br><input type="checkbox" name="headfig" value="yes">Base On Total Amount
        </td>
	</tr>
	<tr> 
        <td colspan="3"><hr></td>
    </tr>
	<tr> 
        <th>#getgeneral.lAGENT# From</th>
        <td><select name="agentfrom">
					<option value="">Choose an #getgeneral.lAGENT#</option>
					<cfloop query="getagent">
					<option value="#getagent.agent#">#getagent.agent# - #getagent.desp#</option>
					</cfloop>
			</select>
		</td>
    </tr>
    <tr> 
        <th>#getgeneral.lAGENT# To</th>
        <td><select name="agentto">
				
					<option value="">Choose an #getgeneral.lAGENT#</option>
					<cfloop query="getagent">
					<option value="#getagent.agent#">#getagent.agent# - #getagent.desp#</option>
					</cfloop>
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
        <td colspan="3"><hr></td>
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
        <td colspan="3"><hr></td>
    </tr>
    <tr>
		<th>#getgeneral.lDRIVER# From</th>
        <td><select name="userfrom">
				<option value="">Choose an #getgeneral.lDRIVER#</option>
				<cfloop query="getuser">
				<option value="#driverno#">#driverno# - #name#</option>
				</cfloop>
			</select>
		</td>
    </tr>
    <tr> 
        <th>#getgeneral.lDRIVER# To</th>
        <td><select name="userto">
				<option value="">Choose an #getgeneral.lDRIVER#</option>
				<cfloop query="getuser">
				<option value="#driverno#">#driverno# - #name#</option>
				</cfloop>
			</select>
		</td>
    </tr>
	<tr> 
        <td colspan="3"><hr></td>
    </tr>
	<tr>
		<th>Period</th>
        <td><select name="periodfrom" onChange="displaymonth()">
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
        <td colspan="3" align="right"><input type="submit" name="Submit" value="Submit"></td>
    </tr>      
</table>
</form>

<cfelseif type is "agentweek">
<cfquery name="getagent" datasource="#dts#">
	select agent,desp from icagent where 0=0
    <cfif alown eq 1>
					<cfif getgeneral.agentlistuserid eq "Y">and ucase(agent) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and  ucase(agent)='#ucase(huserid)#'
					</cfif>
					<cfelse>
					
					</cfif>
                     order by agent
</cfquery>

<cfquery name="getarea" datasource="#dts#">
	select area,desp from icarea order by area 
</cfquery>

<cfquery datasource="#dts#" name="getuser">
	select * from driver 
</cfquery>

<cfquery name="getteam" datasource="#dts#">
		select team,desp from icteam order by team;
	</cfquery>
<form name="salesweek" action="salesweek3.cfm?trantype=#trantype#&alown=#alown#" method="post" target="_blank">
<table width="50%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
    <tr>
		<th>Report Format<input type="hidden" name="tran" id="tran" value="#target_arcust#" /><input type="hidden" name="fromto" id="fromto" value="" /></th>
	</tr>
	<tr>
	  	<td><input type="radio" name="label" id="2" value="salesvalue" checked> <label for="salesvalue">By Sales Value</label>
		<br><input type="radio" name="label" id="2" value="salesqty"> <label for="salesqty">By Sales Quantity</label></td>
		<td><input type="checkbox" name="include" value="yes"> Include DN/CN</td>
	</tr>
	<tr> 
        <td colspan="2"><hr></td>
    </tr>
	<tr> 
        <th>#getgeneral.lAGENT# From</th>
        <td><select name="agentfrom">
				
					<option value="">Choose an #getgeneral.lAGENT#</option>
					<cfloop query="getagent">
					<option value="#getagent.agent#">#getagent.agent# - #getagent.desp#</option>
					</cfloop>

			</select>
		</td>
    </tr>
    <tr> 
        <th>#getgeneral.lAGENT# To</th>
        <td><select name="agentto">
				
					<option value="">Choose an #getgeneral.lAGENT#</option>
					<cfloop query="getagent">
					<option value="#getagent.agent#">#getagent.agent# - #getagent.desp#</option>
					</cfloop>

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
        <td colspan="2"><hr></td>
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
        <td colspan="2"><hr></td>
    </tr>
    <tr>
		<th>#getgeneral.lDRIVER# From</th>
        <td><select name="userfrom">
				<option value="">Choose an #getgeneral.lDRIVER#</option>
				<cfloop query="getuser">
				<option value="#driverno#">#driverno# - #name#</option>
				</cfloop>
			</select>
		</td>
    </tr>
    <tr> 
        <th>#getgeneral.lDRIVER# To</th>
        <td><select name="userto">
				<option value="">Choose an #getgeneral.lDRIVER#</option>
				<cfloop query="getuser">
				<option value="#driverno#">#driverno# - #name#</option>
				</cfloop>
			</select>
		</td>
    </tr>
	<tr> 
        <td colspan="2"><hr></td>
    </tr>
	<tr>
		<th>Period</th>
        <td><select name="periodfrom" onChange="displaymonth()">
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
        <td colspan="2" align="right"><input type="submit" name="Submit" value="Submit"></td>
    </tr>      
</table>
</form>

<cfelseif type eq "groupweek">
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

<cfquery name="getagent" datasource="#dts#">
	select agent,desp from icagent where 0=0
    <cfif alown eq 1>
					<cfif getgeneral.agentlistuserid eq "Y">and ucase(agent) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and  ucase(agent)='#ucase(huserid)#'
					</cfif>
					<cfelse>
					
					</cfif>
                     order by agent
</cfquery>

<cfquery name="getarea" datasource="#dts#">
	select area,desp from icarea order by area 
</cfquery>

<cfquery datasource="#dts#" name="getuser">
	select * from driver 
</cfquery>

<cfquery name="getteam" datasource="#dts#">
		select team,desp from icteam order by team;
	</cfquery>
<form name="salesweek" action="salesweek4.cfm?trantype=#trantype#&alown=#alown#" method="post" target="_blank">
<table width="80%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
	<tr>
		<th>Report Format<input type="hidden" name="tran" id="tran" value="#target_arcust#" /><input type="hidden" name="fromto" id="fromto" value="" /></th>
	</tr>
	<tr>
	  	<td><input type="radio" name="label" id="2" value="salesvalue" checked> <label for="salesvalue">By Sales Value</label>
		<br><input type="radio" name="label" id="2" value="salesqty"> <label for="salesqty">By Sales Quantity</label></td>
		<td><input type="checkbox" name="include" value="yes"> Include DN/CN</td>
	</tr>
	<tr> 
        <td colspan="2"><hr></td>
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
        <td colspan="2"><hr></td>
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
        <td colspan="2"><hr></td>
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
        <td colspan="2"><hr></td>
    </tr>
    <tr> 
        <th>#getgeneral.lAGENT# From</th>
        <td><select name="agentfrom">
				
					<option value="">Choose an #getgeneral.lAGENT#</option>
					<cfloop query="getagent">
					<option value="#getagent.agent#">#getagent.agent# - #getagent.desp#</option>
					</cfloop>

			</select>
		</td>
    </tr>
    <tr> 
        <th>#getgeneral.lAGENT# To</th>
        <td><select name="agentto">
			
					<option value="">Choose an #getgeneral.lAGENT#</option>
					<cfloop query="getagent">
					<option value="#getagent.agent#">#getagent.agent# - #getagent.desp#</option>
					</cfloop>

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
        <td colspan="2"><hr></td>
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
        <td colspan="2"><hr></td>
    </tr>
    <tr>
		<th>#getgeneral.lDRIVER# From</th>
        <td><select name="userfrom">
				<option value="">Choose an #getgeneral.lDRIVER#</option>
				<cfloop query="getuser">
				<option value="#driverno#">#driverno# - #name#</option>
				</cfloop>
			</select>
		</td>
    </tr>
    <tr> 
        <th>#getgeneral.lDRIVER# To</th>
        <td><select name="userto">
				<option value="">Choose an #getgeneral.lDRIVER#</option>
				<cfloop query="getuser">
				<option value="#driverno#">#driverno# - #name#</option>
				</cfloop>
			</select>
		</td>
    </tr>
	<tr> 
        <td colspan="2"><hr></td>
    </tr>
	<tr>
		<th>Period</th>
        <td><select name="periodfrom" onChange="displaymonth()">
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
        <td colspan="2" align="right"><input type="submit" name="Submit" value="Submit"></td>
    </tr>
</table>
</form>

<cfelse>
<cfquery datasource="#dts#" name="getuser">
	select driverno, name from driver order by driverno
</cfquery>

<form name="salesweek" action="salesweek5.cfm?trantype=#trantype#" method="post" target="_blank">
<table width="45%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
	<tr> <input type="hidden" name="tran" id="tran" value="#target_arcust#" /><input type="hidden" name="fromto" id="fromto" value="" />
        <th>#getgeneral.lDRIVER# From</th>
        <td><select name="userfrom">
				<option value="">Choose an #getgeneral.lDRIVER#</option>
				<cfloop query="getuser">
				<option value="#driverno#">#driverno# - #name#</option>
				</cfloop>
			</select>
		</td>
    </tr>
    <tr> 
        <th>#getgeneral.lDRIVER# To</th>
        <td><select name="userto">
				<option value="">Choose an #getgeneral.lDRIVER#</option>
				<cfloop query="getuser">
				<option value="#driverno#">#driverno# - #name#</option>
				</cfloop>
			</select>
		</td>
    </tr>
	<tr> 
        <td colspan="2"><hr></td>
    </tr>
	<tr>
		<th>Period</th>
        <td><select name="periodfrom" onChange="displaymonth()">
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
        <td colspan="2" align="right"><input type="submit" name="Submit" value="Submit"></td>
    </tr>
    </table>
</cfif>

<script language="JavaScript">
	function displaymonth(){
		
	if(document.salesweek.periodfrom.value=='01')		
	{	document.salesweek.monthfrom.value='#vmonthto1#'; }
		
	else if(document.salesweek.periodfrom.value=='02')	
	{	document.salesweek.monthfrom.value='#vmonthto2#'; }
	
	else if(document.salesweek.periodfrom.value=='03')	
	{	document.salesweek.monthfrom.value='#vmonthto3#'; }
	
	else if(document.salesweek.periodfrom.value=='04')	
	{	document.salesweek.monthfrom.value='#vmonthto4#'; }
	
	else if(document.salesweek.periodfrom.value=='05')	
	{	document.salesweek.monthfrom.value='#vmonthto5#'; }
	
	else if(document.salesweek.periodfrom.value=='06')	
	{	document.salesweek.monthfrom.value='#vmonthto6#'; }
	
	else if(document.salesweek.periodfrom.value=='07')	
	{	document.salesweek.monthfrom.value='#vmonthto7#'; }
	
	else if(document.salesweek.periodfrom.value=='08')	
	{	document.salesweek.monthfrom.value='#vmonthto8#'; }
	
	else if(document.salesweek.periodfrom.value=='09')	
	{	document.salesweek.monthfrom.value='#vmonthto9#'; }
	
	else if(document.salesweek.periodfrom.value=='10')	
	{	document.salesweek.monthfrom.value='#vmonthto10#'; }
	
	else if(document.salesweek.periodfrom.value=='11')	
	{	document.salesweek.monthfrom.value='#vmonthto11#'; }
	
	else if(document.salesweek.periodfrom.value=='12')	
	{	document.salesweek.monthfrom.value='#vmonthto12#'; }
	
	else if(document.salesweek.periodfrom.value=='13')	
	{	document.salesweek.monthfrom.value='#vmonthto13#'; }
	
	else if(document.salesweek.periodfrom.value=='14')	
	{	document.salesweek.monthfrom.value='#vmonthto14#'; }
	
	else if(document.salesweek.periodfrom.value=='15')	
	{	document.salesweek.monthfrom.value='#vmonthto15#'; }
	
	else if(document.salesweek.periodfrom.value=='16')	
	{	document.salesweek.monthfrom.value='#vmonthto16#'; }
	
	else if(document.salesweek.periodfrom.value=='17')	
	{	document.salesweek.monthfrom.value='#vmonthto17#'; }
	
	else if(document.salesweek.periodfrom.value=='18')	
	{	document.salesweek.monthfrom.value='#vmonthto18#'; }
	
	if(document.salesweek.periodto.value=='01')		
	{	document.salesweek.monthto.value='#vmonthto1#'; }
		
	else if(document.salesweek.periodto.value=='02')	
	{	document.salesweek.monthto.value='#vmonthto2#'; }
	
	else if(document.salesweek.periodto.value=='03')	
	{	document.salesweek.monthto.value='#vmonthto3#'; }
	
	else if(document.salesweek.periodto.value=='04')	
	{	document.salesweek.monthto.value='#vmonthto4#'; }
	
	else if(document.salesweek.periodto.value=='05')	
	{	document.salesweek.monthto.value='#vmonthto5#'; }
	
	else if(document.salesweek.periodto.value=='06')	
	{	document.salesweek.monthto.value='#vmonthto6#'; }
	
	else if(document.salesweek.periodto.value=='07')	
	{	document.salesweek.monthto.value='#vmonthto7#'; }
	
	else if(document.salesweek.periodto.value=='08')	
	{	document.salesweek.monthto.value='#vmonthto8#'; }
	
	else if(document.salesweek.periodto.value=='09')	
	{	document.salesweek.monthto.value='#vmonthto9#'; }
	
	else if(document.salesweek.periodto.value=='10')	
	{	document.salesweek.monthto.value='#vmonthto10#'; }
	
	else if(document.salesweek.periodto.value=='11')	
	{	document.salesweek.monthto.value='#vmonthto11#'; }
	
	else if(document.salesweek.periodto.value=='12')	
	{	document.salesweek.monthto.value='#vmonthto12#'; }
	
	else if(document.salesweek.periodto.value=='13')	
	{	document.salesweek.monthto.value='#vmonthto13#'; }
	
	else if(document.salesweek.periodto.value=='14')	
	{	document.salesweek.monthto.value='#vmonthto14#'; }
	
	else if(document.salesweek.periodto.value=='15')	
	{	document.salesweek.monthto.value='#vmonthto15#'; }
	
	else if(document.salesweek.periodto.value=='16')	
	{	document.salesweek.monthto.value='#vmonthto16#'; }
	
	else if(document.salesweek.periodto.value=='17')	
	{	document.salesweek.monthto.value='#vmonthto17#'; }
	
	else if(document.salesweek.periodto.value=='18')	
	{	document.salesweek.monthto.value='#vmonthto18#'; }
	
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