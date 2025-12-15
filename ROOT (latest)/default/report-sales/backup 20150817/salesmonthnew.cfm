<cfinclude template = "../../CFC/convert_single_double_quote_script.cfm">
<html>
<head>
<title>Sales Report By Month</title>
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
		var inputtext = document.salesmonth.searchitemto.value;
		DWREngine._execute(_reportflocation, null, 'productlookup', inputtext, getProductResult);
		
	}else{
		var inputtext = document.salesmonth.searchitemfr.value;
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
		var inputtext = document.salesmonth.searchcatefr.value;
		DWREngine._execute(_reportflocation, null, 'categorylookup', inputtext, getCategoryResult);
	}else{
		var inputtext = document.salesmonth.searchcateto.value;
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
		var inputtext = document.salesmonth.searchgroupfr.value;
		DWREngine._execute(_reportflocation, null, 'grouplookup', inputtext, getGroupResult);
		
	}
	else{
		var inputtext = document.salesmonth.searchgroupto.value;
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

function getSupp(type,option){
	if(type == 'custfrom'){
		var inputtext = document.salesmonth.searchsuppfr.value;
		DWREngine._execute(_reportflocation, null, 'supplierlookup', inputtext, option, getSuppResult);
		
	}
	else{
		var inputtext = document.salesmonth.searchsuppto.value;
		DWREngine._execute(_reportflocation, null, 'supplierlookup', inputtext, option, getSuppResult2);
	}
}

function getSuppResult(suppArray){
	DWRUtil.removeAllOptions("custfrom");
	DWRUtil.addOptions("custfrom", suppArray,"KEY", "VALUE");
}

function getSuppResult2(suppArray){
	DWRUtil.removeAllOptions("custto");
	DWRUtil.addOptions("custto", suppArray,"KEY", "VALUE");
}
</script>

</head>
<cfparam name="alown" default="0">

	<cfif getpin2.h4700 eq 'T'>
  		<cfset alown = 1>
  	</cfif>
<cfif type eq "productmonth">
	<cfset trantype = "PRODUCTS">
<cfelseif type eq "customermonth">
	<cfset trantype = "CUSTOMERS">	
<cfelseif type eq "Agentmonth">
	<cfset trantype = "AGENT">		
<cfelseif type eq "groupmonth">
	<cfset trantype = "GROUP">
<cfelseif type eq "brandmonth">
	<cfset trantype = "BRAND">
<cfelseif type eq "endusermonth">
	<cfset trantype = "END USER">
</cfif>

<!--- ADD ON 190908 --->
<cfquery name="getgeneral" datasource="#dts#">
	select filterall,lCATEGORY,lGROUP,lSIZE,lMATERIAL,lMODEL,lRATING,lAGENT,lDRIVER,lLOCATION,agentlistuserid,lTEAM from gsetup
</cfquery>
<!--- Add On 15-01-2010 --->
<cfquery name="getdealer_menu" datasource="#dts#">
	select custSuppSortBy,productSortBy from dealer_menu limit 1
</cfquery>

<body>
<cfoutput>
<!--- <h2>Print #trantype# Sales Report By Month</h2> --->
<h3>
	<a href="salesmenu.cfm">Sales Report Menu</a> >> 
	<a><font size="2">Print #trantype# Sales Report By Month</font></a>
</h3>

<cfif type is "productmonth">
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

<cfquery name="getarea" datasource="#dts#">
	select area,desp from icarea order by area
</cfquery>
<cfquery datasource="#dts#" name="getuser">
	select * from driver 
</cfquery>


<cfquery name="getteam" datasource="#dts#">
		select team,desp from icteam order by team;
	</cfquery>

<form name="salesmonth" action="salesmonth1new.cfm?trantype=#trantype#&alown=#alown#" method="post" target="_blank">
<table width="80%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
	<tr>
		<th>Report Format<input type="hidden" name="tran" id="tran" value="#target_arcust#" /><input type="hidden" name="fromto" id="fromto" value="" /></th>
	</tr>
	<tr>
	  	<td>
			<input type="radio" name="period" id="1" value="1" checked> Period (1-6)<br/>
			<input type="radio" name="period" id="1" value="2"> Period (7-12)<br/>
			<input type="radio" name="period" id="1" value="3"> Period (13-18)<br/>
			<input type="radio" name="period" id="1" value="4"> One Year <br/>
            <input type="radio" name="period" id="1" value="6"> Period From
            <select name="periodfrom">
            <option value="1">01</option>
            <option value="2">02</option>
            <option value="3">03</option>
            <option value="4">04</option>
            <option value="5">05</option>
            <option value="6">06</option>
            <option value="7">07</option>
            <option value="8">08</option>
            <option value="9">09</option>
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
            to
            <select name="periodto">
            <option value="1">01</option>
            <option value="2">02</option>
            <option value="3">03</option>
            <option value="4">04</option>
            <option value="5">05</option>
            <option value="6">06</option>
            <option value="7">07</option>
            <option value="8">08</option>
            <option value="9">09</option>
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
	  	<td>	
			<input type="radio" name="label" id="2" value="salesvalue" checked> By Sales Value<br/> 
			<input type="radio" name="label" id="2" value="salesqty"> By Sales Quantity<br/>
			<input type="checkbox" name="include" value="yes"> Include DN/CN<br/> 
			<input type="checkbox" name="include0" id="1" value="yes"> Include 0 Figure
            
		</td>
	</tr>
	<tr><td></td></tr>
	<tr>
		<td>
			<!--- <input type="radio" name="result" id="3" value="HTML" checked> HTML<br/>
			<input type="radio" name="result" id="3" value="EXCELDEFAULT"> Excel Default<br/>
			<input type="radio" name="result" id="3" value="EXCELBYGROUP"> Excel By Group --->
		</td>
	</tr>
	<tr> 
        <td colspan="2"><hr></td>
    </tr>
	<tr> 
        <th>#getgeneral.lCATEGORY# From</th>
        <td><select name="catefrom">
				<option value="">Choose a #getgeneral.lCATEGORY#</option>
				<cfloop query="getcate">
				<option value="#cate#">#getcate.cate# - #getcate.desp#</option>
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
				<option value="#cate#">#getcate.cate# - #getcate.desp#</option>
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
				<option value="#wos_group#">#getgroup.wos_group# - #getgroup.desp#</option>
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
				<option value="#wos_group#">#getgroup.wos_group# - #getgroup.desp#</option>
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
				<option value="#convertquote(itemno)#">#getitem.itemno# - #getitem.desp#</option>
				</cfloop>
			</select>
			<cfif getgeneral.filterall eq "1">
				<input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='from';ColdFusion.Window.show('finditem');" />&nbsp;<input type="text" name="searchitemfr" onKeyUp="getProduct('itemfrom');">
			</cfif>
		</td>
    </tr>
    <tr> 
        <th>Item No To</th>
        <td><select name="itemto">
				<option value="">Choose an Item</option>
				<cfloop query="getitem">
				<option value="#convertquote(itemno)#">#getitem.itemno# - #getitem.desp#</option>
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
				<option value="">Choose an Team</option>
				<cfloop query="getteam">
				<option value="#team#">#team# - #desp#</option>
				</cfloop>
			</select>
		</td>
    </tr>
    <tr> 
        <th>#getgeneral.lTEAM# To</th>
        <td><select name="teamto">
				<option value="">Choose an Team</option>
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
				<option value="#area#">#getarea.area# - #getarea.desp#</option>
				</cfloop>
			</select>
		</td>
    </tr>
	<tr> 
        <th>Area To</th>
        <td><select name="areato">
				<option value="">Choose an Area</option>
				<cfloop query="getarea">
				<option value="#area#">#getarea.area# - #getarea.desp#</option>
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
		<td colspan="2" align="right"><input type="submit" name="Submit" value="Submit"></td>
	</tr>
</table>
	
<cfelseif type eq "customermonth">

<cfquery name="getarea" datasource="#dts#">
	select area,desp from icarea order by area;
</cfquery>
<cfquery datasource="#dts#" name="getuser">
	select * from driver 
</cfquery>


<cfquery name="getteam" datasource="#dts#">
		select team,desp from icteam order by team;
	</cfquery>

<cfquery name="getcust" datasource="#dts#">
	select name, custno from #target_arcust# order by custno
</cfquery>
<cfquery name="getdealer_menu" datasource="#dts#">
	select custSuppSortBy,productSortBy from dealer_menu limit 1
</cfquery>

<form name="salesmonth" action="salesmonth2new.cfm?trantype=#trantype#&alown=#alown#" method="post" target="_blank">
<table width="70%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
	<tr>
	  	<th >Report Format<input type="hidden" name="tran" id="tran" value="#target_arcust#" /><input type="hidden" name="fromto" id="fromto" value="" /></th>
	</tr>
	<tr>
	  	<td><input type="radio" name="period" id="1" value="1" checked> <label for="1">Period (1-6)</label><br>
			<input type="radio" name="period" id="1" value="2"> <label for="1">Period (7-12)</label><br>
			<input type="radio" name="period" id="1" value="3"> <label for="1">Period (13-18)</label><br>
			<input type="radio" name="period" id="1" value="4"> <label for="1">One Year</label><br />
            <input type="radio" name="period" id="1" value="5"> Period&nbsp;&nbsp;&nbsp;
            <select name="poption" id="poption">
            <option value="01" selected>1</option>
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
            </select><br/>
            <input type="radio" name="period" id="1" value="6"> Period From
            <select name="periodfrom">
            <option value="1">01</option>
            <option value="2">02</option>
            <option value="3">03</option>
            <option value="4">04</option>
            <option value="5">05</option>
            <option value="6">06</option>
            <option value="7">07</option>
            <option value="8">08</option>
            <option value="9">09</option>
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
            to
            <select name="periodto">
            <option value="1">01</option>
            <option value="2">02</option>
            <option value="3">03</option>
            <option value="4">04</option>
            <option value="5">05</option>
            <option value="6">06</option>
            <option value="7">07</option>
            <option value="8">08</option>
            <option value="9">09</option>
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
		<td colspan="4"><br><br><br><input type="checkbox" name="include" value="yes"> Include DN/CN
		<br><input type="checkbox" name="include0" id="1" value="yes"> <label for="include0">Include 0 Figure</label>
        <br><input type="checkbox" name="bodyfig" id="1" value="yes"> <label for="include0">Based on body amount</label></td>
	</tr>
        <tr> 
        <td colspan="2"><hr></td>
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
				<input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='from';ColdFusion.Window.show('findCustomer');" />&nbsp;<input type="text" name="searchsuppfr" onKeyUp="getSupp('custfrom','Customer');">
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
				<input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='to';ColdFusion.Window.show('findCustomer');" />&nbsp;<input type="text" name="searchsuppto" onKeyUp="getSupp('custto','Customer');">
			</cfif>
		</td>
	</tr>
	<tr> 
        <td colspan="2"><hr></td>
    </tr>
	<tr> 
        <th>#getgeneral.lAGENT# From</th>
        <td><select name="agentfrom">
				
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
        <td colspan="2" align="right"><input type="submit" name="Submit" value="Submit"></td>
    </tr>      
</table>

<cfelseif type is "agentmonth">


<cfquery name="getarea" datasource="#dts#">
	select area,desp from icarea order by area;
</cfquery>

<cfquery datasource="#dts#" name="getuser">
	select * from driver 
</cfquery>


<cfquery name="getteam" datasource="#dts#">
		select team,desp from icteam order by team;
        </cfquery>
        


<form name="salesmonth" action="salesmonth3new.cfm?trantype=#trantype#&alown=#alown#" method="post" target="_blank">
<table width="50%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
	<tr>
	  	<th>Report Format<input type="hidden" name="tran" id="tran" value="#target_arcust#" /><input type="hidden" name="fromto" id="fromto" value="" /></th>
	</tr>
	<tr>
	  	<td><input type="radio" name="period" id="1" value="1" checked> <label for="1">Period (1-6)</label><br>
			<input type="radio" name="period" id="1" value="2"> <label for="1">Period (7-12)</label><br>
			<input type="radio" name="period" id="1" value="3"> <label for="1">Period (13-18)</label><br>
			<input type="radio" name="period" id="1" value="4"> <label for="1">One Year</label><br>
            <input type="radio" name="period" id="1" value="6"> Period From
            <select name="periodfrom">
            <option value="1">01</option>
            <option value="2">02</option>
            <option value="3">03</option>
            <option value="4">04</option>
            <option value="5">05</option>
            <option value="6">06</option>
            <option value="7">07</option>
            <option value="8">08</option>
            <option value="9">09</option>
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
            to
            <select name="periodto">
            <option value="1">01</option>
            <option value="2">02</option>
            <option value="3">03</option>
            <option value="4">04</option>
            <option value="5">05</option>
            <option value="6">06</option>
            <option value="7">07</option>
            <option value="8">08</option>
            <option value="9">09</option>
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
		<td>
			<br><br><br>
			<input type="checkbox" name="include" value="yes"> Include DN/CN
            <br><input type="checkbox" name="include0" id="1" value="yes"> <label for="include0">Include 0 Figure</label><br><input type="checkbox" name="bodyfig" id="1" value="yes"> <label for="include0">Based on body amount</label>
		</td>
	</tr>

    <tr> 
        <td colspan="2"><hr></td>
    </tr>
	<tr> 
        <th>#getgeneral.lAGENT# From</th>
        <td><select name="agentfrom">
				
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
        <td colspan="2" align="right"><input type="submit" name="Submit" value="Submit"></td>
    </tr>      
</table>

<cfelseif type eq "groupmonth">
<cfquery name="getcate" datasource="#dts#">
	select cate,desp from iccate order by cate
</cfquery>

<cfquery name="getgroup" datasource="#dts#">
	select wos_group,desp from icgroup order by wos_group
</cfquery>

<!--- <cfquery name="getitem" datasource="#dts#">
	select itemno,desp from icitem order by itemno
</cfquery> --->
<cfquery name="getitem" datasource="#dts#">
	select itemno,desp from icitem order by <cfif getdealer_menu.productSortBy neq "">#getdealer_menu.productSortBy#<cfelse>itemno</cfif>
</cfquery>

<cfquery name="getagent" datasource="#dts#">
	select agent,desp from icagent order by agent
</cfquery>

<cfquery name="getarea" datasource="#dts#">
	select area,desp from icarea order by area;
</cfquery>

<cfquery datasource="#dts#" name="getuser">
	select * from driver 
</cfquery>

<cfquery name="getteam" datasource="#dts#">
		select team,desp from icteam order by team;
	</cfquery>

<form name="salesmonth" action="salesmonth4new.cfm?trantype=#trantype#&alown=#alown#" method="post" target="_blank">
<table width="80%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
	<tr>
	  	<th>Report Format<input type="hidden" name="tran" id="tran" value="#target_arcust#" /><input type="hidden" name="fromto" id="fromto" value="" /></th>
	</tr>
	<tr>
	  	<td><input type="radio" name="period" id="1" value="1" checked> <label for="1">Period (1-6)</label><br>
			<input type="radio" name="period" id="1" value="2"> <label for="1">Period (7-12)</label><br>
			<input type="radio" name="period" id="1" value="3"> <label for="1">Period (13-18)</label><br>
			<input type="radio" name="period" id="1" value="4"> <label for="1">One Year</label><br>
            <input type="radio" name="period" id="1" value="6"> Period From
            <select name="periodfrom">
            <option value="1">01</option>
            <option value="2">02</option>
            <option value="3">03</option>
            <option value="4">04</option>
            <option value="5">05</option>
            <option value="6">06</option>
            <option value="7">07</option>
            <option value="8">08</option>
            <option value="9">09</option>
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
            to
            <select name="periodto">
            <option value="1">01</option>
            <option value="2">02</option>
            <option value="3">03</option>
            <option value="4">04</option>
            <option value="5">05</option>
            <option value="6">06</option>
            <option value="7">07</option>
            <option value="8">08</option>
            <option value="9">09</option>
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
	  	<td><input type="radio" name="label" id="2" value="salesvalue" checked> <label for="salesvalue">By Sales Value</label>
		<br><input type="radio" name="label" id="2" value="salesqty"> <label for="salesqty">By Sales Quantity</label>
		<br><br><input type="checkbox" name="include" value="yes"> Include DN/CN<br><input type="checkbox" name="include0" id="1" value="yes"> Include 0 Figure
		</td>
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
        <td colspan="2" align="right"><input type="submit" name="Submit" value="Submit"></td>
    </tr>
</table>

<cfelseif type eq "brandmonth">
<cfquery name="getcate" datasource="#dts#">
	select cate,desp from iccate order by cate
</cfquery>

<cfquery name="getgroup" datasource="#dts#">
	select wos_group,desp from icgroup order by wos_group
</cfquery>

<!--- <cfquery name="getitem" datasource="#dts#">
	select itemno,desp from icitem order by itemno
</cfquery> --->
<cfquery name="getitem" datasource="#dts#">
	select itemno,desp from icitem order by <cfif getdealer_menu.productSortBy neq "">#getdealer_menu.productSortBy#<cfelse>itemno</cfif>
</cfquery>

<cfquery name="getagent" datasource="#dts#">
	select agent,desp from icagent order by agent
</cfquery>

<cfquery name="getarea" datasource="#dts#">
	select area,desp from icarea order by area;
</cfquery>

<cfquery datasource="#dts#" name="getuser">
	select * from driver 
</cfquery>

<cfquery name="getbrand" datasource="#dts#">
	select brand,desp from brand order by brand 
</cfquery>

<cfquery name="getteam" datasource="#dts#">
		select team,desp from icteam order by team;
	</cfquery>

<form name="salesmonth" action="salesmonth6new.cfm?trantype=#trantype#&alown=#alown#" method="post" target="_blank">
<table width="80%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
	<tr>
	  	<th>Report Format<input type="hidden" name="tran" id="tran" value="#target_arcust#" /><input type="hidden" name="fromto" id="fromto" value="" /></th>
	</tr>
	<tr>
	  	<td><input type="radio" name="period" id="1" value="1" checked> <label for="1">Period (1-6)</label><br>
			<input type="radio" name="period" id="1" value="2"> <label for="1">Period (7-12)</label><br>
			<input type="radio" name="period" id="1" value="3"> <label for="1">Period (13-18)</label><br>
			<input type="radio" name="period" id="1" value="4"> <label for="1">One Year</label><br>
            <input type="radio" name="period" id="1" value="6"> Period From
            <select name="periodfrom">
            <option value="1">01</option>
            <option value="2">02</option>
            <option value="3">03</option>
            <option value="4">04</option>
            <option value="5">05</option>
            <option value="6">06</option>
            <option value="7">07</option>
            <option value="8">08</option>
            <option value="9">09</option>
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
            to
            <select name="periodto">
            <option value="1">01</option>
            <option value="2">02</option>
            <option value="3">03</option>
            <option value="4">04</option>
            <option value="5">05</option>
            <option value="6">06</option>
            <option value="7">07</option>
            <option value="8">08</option>
            <option value="9">09</option>
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
	  	<td><input type="radio" name="label" id="2" value="salesvalue" checked> <label for="salesvalue">By Sales Value</label>
		<br><input type="radio" name="label" id="2" value="salesqty"> <label for="salesqty">By Sales Quantity</label>
		<br><br><input type="checkbox" name="include" value="yes"> Include DN/CN<br><input type="checkbox" name="include0" id="1" value="yes"> Include 0 Figure
		</td>
	</tr>
	<tr> 
        <td colspan="2"><hr></td>
    </tr>
    <tr> 
        <th>Brand From</th>
        <td><select name="brandfrom">
				<option value="">Choose an Brand</option>
				<cfloop query="getbrand">
				<option value="#brand#">#brand# - #desp#</option>
				</cfloop>
			</select>
		</td>
	</tr>
    <tr> 
        <th>Brand To</th>
        <td><select name="brandto">
				<option value="">Choose an Brand</option>
				<cfloop query="getbrand">
				<option value="#brand#">#brand# - #desp#</option>
				</cfloop>
			</select>
		</td>
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
        <td colspan="2" align="right"><input type="submit" name="Submit" value="Submit"></td>
    </tr>
</table>

<cfelse>
<cfquery datasource="#dts#" name="getuser">
	select driverno, name from driver order by driverno
</cfquery>

<form name="salesmonth" action="salesmonth5.cfm?trantype=#trantype#" method="post" target="_blank">
<table width="50%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
	<tr>
	  	<th>Report Format<input type="hidden" name="tran" id="tran" value="#target_arcust#" /><input type="hidden" name="fromto" id="fromto" value="" /></th>
	</tr>
	<tr>
	  	<td><input type="radio" name="period" id="1" value="1" checked> <label for="1">Period (1-6)</label><br>
			<input type="radio" name="period" id="1" value="2"> <label for="1">Period (7-12)</label><br>
			<input type="radio" name="period" id="1" value="3"> <label for="1">Period (13-18)</label><br>
			<input type="radio" name="period" id="1" value="4"> <label for="1">One Year</label><br>
            <input type="radio" name="period" id="1" value="6"> Period From
            <select name="periodfrom">
            <option value="1">01</option>
            <option value="2">02</option>
            <option value="3">03</option>
            <option value="4">04</option>
            <option value="5">05</option>
            <option value="6">06</option>
            <option value="7">07</option>
            <option value="8">08</option>
            <option value="9">09</option>
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
            to
            <select name="periodto">
            <option value="1">01</option>
            <option value="2">02</option>
            <option value="3">03</option>
            <option value="4">04</option>
            <option value="5">05</option>
            <option value="6">06</option>
            <option value="7">07</option>
            <option value="8">08</option>
            <option value="9">09</option>
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
        <td colspan="2" align="right"><input type="submit" name="Submit" value="Submit"></td>
    </tr>
</table>
</cfif>
</cfoutput>
</form>
<cfwindow  width="550" height="400" name="findCustomer" refreshOnShow="true"
        title="Find Customer or Supplier" initshow="false"
        source="findCustomer.cfm?type={tran}&fromto={fromto}" />
<cfwindow  width="550" height="400" name="finditem" refreshOnShow="true"
        title="Find Item" initshow="false"
        source="finditem.cfm?type=Item&fromto={fromto}" />
</body>
</html>