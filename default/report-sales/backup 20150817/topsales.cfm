<html>
<head>
<title>Sales Report By Type</title>
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

// begin: supplier search
function getCust(type,option){
	if(type == 'custfrom'){
		var inputtext = document.salestype.searchsuppfr.value;
		DWREngine._execute(_reportflocation, null, 'supplierlookup', inputtext, option, getCustResult);
		
	}
	else{
		var inputtext = document.salestype.searchsuppto.value;
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

<cfif type eq "producttype">
	<cfset trantype = "PRODUCTS">
	
<cfelseif type eq "customertype">
	<cfset trantype = "CUSTOMERS">	

<cfelseif type eq "agenttype">
	<cfset trantype = "AGENT">	
	
<cfelseif type eq "areatype">
	<cfset trantype = "AREA">
</cfif>

<!---cfquery name="getgeneral" datasource="#dts#">
	select lastaccyear from gsetup
</cfquery--->

<cfquery name="getgeneral" datasource="#dts#">
	select lastaccyear,filterall,lAGENT,agentuserid,lTEAM from gsetup
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
<!--- <h2>Print Top Sales Report By #trantype#</h2> --->
<h3>
	<a href="salesmenu.cfm">Sales Report Menu</a> >> 
	<a><font size="2">Print Top Sales Report By #trantype#</font></a>
</h3>

<cfif type eq "customertype">
<cfquery name="getarea" datasource="#dts#">
	select area,desp from icarea order by area 
</cfquery>
<cfquery name="getteam" datasource="#dts#">
		select team,desp from icteam order by team;
	</cfquery>

<!--- <cfquery name="getcust" datasource="#dts#">
	select name, custno from #target_arcust# order by custno
</cfquery> --->
<cfquery name="getcust" datasource="#dts#">
	select name, custno from #target_arcust# order by <cfif getdealer_menu.custSuppSortBy neq "">#getdealer_menu.custSuppSortBy#<cfelse>custno</cfif>
</cfquery>

<form name="salestype" action="topsales1.cfm?trantype=#trantype#" method="post" target="_blank">
<table width="65%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
	<tr>
		<th>Report Format<input type="hidden" name="tran" id="tran" value="#target_arcust#" /><input type="hidden" name="fromto" id="fromto" value="" /></th>
	</tr>
	<tr>
	  	<td nowrap>
			<input type="radio" name="result" value="HTML" checked>HTML<br/>
			<input type="radio" name="result" value="EXCELDEFAULT">EXCEL DEFAULT<br/>
		</td>
		<td nowrap>
			<input type="radio" name="qtysold" id="2" value="yes"> Show Qty Sold Only</br>
			<input type="radio" name="qtysold" id="2" value="no" checked> Show Qty Sold & Sales Value
		</td>
	</tr>
	<tr>
		<td nowrap><input type="checkbox" name="include0" id="1" value="yes"> <label for="include0">Include 0 Figure</label></td>
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
        <td colspan="2"><hr></td>
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
        <td colspan="2"><hr></td>
    </tr>
	<tr> 
        <th>Date From</th>
        <td><input type="text" name="datefrom" maxlength="10" size="11"> (DD/MM/YYYY)</td>
    </tr>
    <tr> 
        <th>Date To</th>
        <td><input type="text" name="dateto" maxlength="10" size="11"> (DD/MM/YYYY)</td>
    </tr>
	 <tr> 
        <th>Range To</th>
        <td><input size="5" message="Input Must Be a Number !" validate="integer" type="text" name="rangeto" maxlength="5" value="50" onChange="notzero();"><br></td>
	</tr>	
    <tr> 
        <td colspan="2" align="right"><input type="submit" name="Submit" value="Submit"></td>
    </tr>      
</table>

<cfelse>
<cfquery name="getarea" datasource="#dts#">
	select area,desp from icarea order by area 
</cfquery>

<cfquery name="getteam" datasource="#dts#">
		select team,desp from icteam order by team;
	</cfquery>

<!--- <cfquery name="getcust" datasource="#dts#">
	select name, custno from #target_arcust# order by custno
</cfquery> --->
<cfquery name="getcust" datasource="#dts#">
	select name, custno from #target_arcust# order by <cfif getdealer_menu.custSuppSortBy neq "">#getdealer_menu.custSuppSortBy#<cfelse>custno</cfif>
</cfquery>

<cfif type is "agenttype">
	<form name="salestype" action="topsales2.cfm?trantype=#trantype#" method="post" target="_blank">
<cfelseif type is "areatype">
	<form name="salestype" action="topsales3.cfm?trantype=#trantype#" method="post" target="_blank">	
</cfif>
<table width="60%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
	<tr>
		<th>Report Format<input type="hidden" name="tran" id="tran" value="#target_arcust#" /><input type="hidden" name="fromto" id="fromto" value="" /></th>
		<td nowrap>
			<input type="radio" name="result" value="HTML" checked>HTML<br/>
			<input type="radio" name="result" value="EXCELDEFAULT">EXCEL DEFAULT
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
        <td colspan="2"><hr></td>
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
        <td colspan="2"><hr></td>
	</tr>
    <tr> 
        <th>Date From</th>
        <td><input type="text" name="datefrom" maxlength="10" size="11"> (DD/MM/YYYY)</td>
    </tr>
    <tr> 
        <th>Date To</th>
        <td><input type="text" name="dateto" maxlength="10" size="11"> (DD/MM/YYYY)</td>
    </tr>
	 <tr> 
        <th>Range To</th>
        <td><input size="5" message="Input Must Be a Number !" validate="integer" type="text" name="rangeto" maxlength="5" value="50" onChange="notzero();"><br></td>
	</tr>	
    <tr> 
        <td colspan="2" align="right"><input type="submit" name="Submit" value="Submit"></td>
    </tr>      
</table>
</cfif>

</cfoutput>
</form>

<cfoutput>
<script language="JavaScript">
	function displaymonth(){
	
	if(document.salestype.periodfrom.value=="")
	{	document.salestype.periodto.value = "";}
	
	if(document.salestype.periodfrom.value=='01')		
	{	document.salestype.monthfrom.value='#vmonthto1#'; }
		
	else if(document.salestype.periodfrom.value=='02')	
	{	document.salestype.monthfrom.value='#vmonthto2#'; }
	
	else if(document.salestype.periodfrom.value=='03')	
	{	document.salestype.monthfrom.value='#vmonthto3#'; }
	
	else if(document.salestype.periodfrom.value=='04')	
	{	document.salestype.monthfrom.value='#vmonthto4#'; }
	
	else if(document.salestype.periodfrom.value=='05')	
	{	document.salestype.monthfrom.value='#vmonthto5#'; }
	
	else if(document.salestype.periodfrom.value=='06')	
	{	document.salestype.monthfrom.value='#vmonthto6#'; }
	
	else if(document.salestype.periodfrom.value=='07')	
	{	document.salestype.monthfrom.value='#vmonthto7#'; }
	
	else if(document.salestype.periodfrom.value=='08')	
	{	document.salestype.monthfrom.value='#vmonthto8#'; }
	
	else if(document.salestype.periodfrom.value=='09')	
	{	document.salestype.monthfrom.value='#vmonthto9#'; }
	
	else if(document.salestype.periodfrom.value=='10')	
	{	document.salestype.monthfrom.value='#vmonthto10#'; }
	
	else if(document.salestype.periodfrom.value=='11')	
	{	document.salestype.monthfrom.value='#vmonthto11#'; }
	
	else if(document.salestype.periodfrom.value=='12')	
	{	document.salestype.monthfrom.value='#vmonthto12#'; }
	
	else if(document.salestype.periodfrom.value=='13')	
	{	document.salestype.monthfrom.value='#vmonthto13#'; }
	
	else if(document.salestype.periodfrom.value=='14')	
	{	document.salestype.monthfrom.value='#vmonthto14#'; }
	
	else if(document.salestype.periodfrom.value=='15')	
	{	document.salestype.monthfrom.value='#vmonthto15#'; }
	
	else if(document.salestype.periodfrom.value=='16')	
	{	document.salestype.monthfrom.value='#vmonthto16#'; }
	
	else if(document.salestype.periodfrom.value=='17')	
	{	document.salestype.monthfrom.value='#vmonthto17#'; }
	
	else if(document.salestype.periodfrom.value=='18')	
	{	document.salestype.monthfrom.value='#vmonthto18#'; }
	
	if(document.salestype.periodto.value=='01')		
	{	document.salestype.monthto.value='#vmonthto1#'; }
		
	else if(document.salestype.periodto.value=='02')	
	{	document.salestype.monthto.value='#vmonthto2#'; }
	
	else if(document.salestype.periodto.value=='03')	
	{	document.salestype.monthto.value='#vmonthto3#'; }
	
	else if(document.salestype.periodto.value=='04')	
	{	document.salestype.monthto.value='#vmonthto4#'; }
	
	else if(document.salestype.periodto.value=='05')	
	{	document.salestype.monthto.value='#vmonthto5#'; }
	
	else if(document.salestype.periodto.value=='06')	
	{	document.salestype.monthto.value='#vmonthto6#'; }
	
	else if(document.salestype.periodto.value=='07')	
	{	document.salestype.monthto.value='#vmonthto7#'; }
	
	else if(document.salestype.periodto.value=='08')	
	{	document.salestype.monthto.value='#vmonthto8#'; }
	
	else if(document.salestype.periodto.value=='09')	
	{	document.salestype.monthto.value='#vmonthto9#'; }
	
	else if(document.salestype.periodto.value=='10')	
	{	document.salestype.monthto.value='#vmonthto10#'; }
	
	else if(document.salestype.periodto.value=='11')	
	{	document.salestype.monthto.value='#vmonthto11#'; }
	
	else if(document.salestype.periodto.value=='12')	
	{	document.salestype.monthto.value='#vmonthto12#'; }
	
	else if(document.salestype.periodto.value=='13')	
	{	document.salestype.monthto.value='#vmonthto13#'; }
	
	else if(document.salestype.periodto.value=='14')	
	{	document.salestype.monthto.value='#vmonthto14#'; }
	
	else if(document.salestype.periodto.value=='15')	
	{	document.salestype.monthto.value='#vmonthto15#'; }
	
	else if(document.salestype.periodto.value=='16')	
	{	document.salestype.monthto.value='#vmonthto16#'; }
	
	else if(document.salestype.periodto.value=='17')	
	{	document.salestype.monthto.value='#vmonthto17#'; }
	
	else if(document.salestype.periodto.value=='18')	
	{	document.salestype.monthto.value='#vmonthto18#'; }
	
	}
	
	function notzero()
	{
		if(document.salestype.rangeto.value == 0)
		{
			alert("Range Number Can Not Be Zero !");
			document.topbottomlist.rangeto.select();
			return false;
		}
		return true;
	}
</script>
</cfoutput>
<cfwindow  width="550" height="400" name="findCustomer" refreshOnShow="true"
        title="Find Customer or Supplier" initshow="false"
        source="findCustomer.cfm?type={tran}&fromto={fromto}" />
</body>
</html>