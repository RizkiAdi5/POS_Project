<html>
<head>
	<title>Purchase Listing By Vendors Report</title>
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
function getSupp(type,option){
	if(type == 'suppfrom'){
		var inputtext = document.purchaselisting.searchsuppfr.value;
		DWREngine._execute(_reportflocation, null, 'supplierlookup', inputtext, option, getSuppResult);
		
	}
	else{
		var inputtext = document.purchaselisting.searchsuppto.value;
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

</script>

</head>

<cfquery name="getgeneral" datasource="#dts#">
	select lastaccyear,filterall,lCATEGORY,lGROUP,lSIZE,lMATERIAL,lMODEL,lRATING,lAGENT,lDRIVER,lLOCATION from gsetup
</cfquery>

<!--- Add On 15-01-2010 --->
<cfquery name="getdealer_menu" datasource="#dts#">
	select custSuppSortBy,productSortBy from dealer_menu limit 1
</cfquery>

<cfquery name="getagent" datasource="#dts#">
	select agent,desp from icagent order by agent
</cfquery>

<!--- <cfquery name="getsupp" datasource="#dts#">
	select custno, name from #target_apvend# order by custno
</cfquery>  --->
<cfquery name="getsupp" datasource="#dts#">
	select custno, name from #target_apvend# order by <cfif getdealer_menu.custSuppSortBy neq "">#getdealer_menu.custSuppSortBy#<cfelse>custno</cfif>
</cfquery>

<cfquery name="getarea" datasource="#dts#">
	select * from icarea order by area
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
<!--- <h2>Print Purchase Listing By Vendors Report</h2> --->
<h3>
	<a href="purchasemenu.cfm">Purchase Report Menu</a> >> 
	<a><font size="2">Print Purchase Listing By Vendors Report</font></a>
</h3>

<form name="purchaselisting" action="purchaselisting1.cfm" method="post" target="_blank">

<table width="60%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
	<tr><input type="hidden" name="tran" id="tran" value="#target_apvend#" /><input type="hidden" name="fromto" id="fromto" value="" />

		<th>Report Format</th>
		<td>
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
				<option value="">Choose an #getgeneral.lAGENT#</option>
				<cfloop query="getagent"><option value="#agent#">#agent# - #desp#</option></cfloop>
			</select>
		</td>
	</tr>
    <tr> 
        <th>#getgeneral.lAGENT# To</th>
        <td><select name="agentto">
				<option value="">Choose an #getgeneral.lAGENT#</option>
				<cfloop query="getagent"><option value="#agent#">#agent# - #desp#</option></cfloop>
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
				<cfloop query="getarea"><option value="#area#">#area# - #desp#</option></cfloop>
			</select>
		</td>
	</tr>
    <tr> 
        <th>Area To</th>
        <td><select name="areato">
				<option value="">Choose an Area</option>
				<cfloop query="getarea"><option value="#area#">#area# - #desp#</option></cfloop>
			</select>
		</td>
    </tr>
    <tr> 
        <td colspan="2"><hr></td>
    </tr>
	<tr>   
    <th>Supplier From</th>
        <td><select name="suppfrom">
				<option value="">Choose a Supplier</option>
				<cfloop query="getsupp">
					<option value="#custno#">#custno# - #name#</option>
				</cfloop>
			</select>
			<cfif getgeneral.filterall eq "1">
				
<input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='from';ColdFusion.Window.show('findCustomer');" />&nbsp;<input type="text" name="searchsuppfr" onKeyUp="getSupp('suppfrom','Supplier');">
			</cfif>
		</td>
    </tr>
    <tr> 
        <th>Supplier To</th>
        <td><select name="suppto">
				<option value="">Choose a Supplier</option>
				<cfloop query="getsupp">
					<option value="#custno#">#custno# - #name#</option>
				</cfloop>
			</select>
			<cfif getgeneral.filterall eq "1">
				
<input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='to';ColdFusion.Window.show('findCustomer');" />&nbsp;<input type="text" name="searchsuppto" onKeyUp="getSupp('suppto','Supplier');">
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

<script language="JavaScript">
	function displaymonth(){
	
	if(document.purchaselisting.periodfrom.value=="")
	{	document.purchaselisting.periodto.value = "";}
	
	if(document.purchaselisting.periodfrom.value=='01')		
	{	document.purchaselisting.monthfrom.value='#vmonthto1#'; }
		
	else if(document.purchaselisting.periodfrom.value=='02')	
	{	document.purchaselisting.monthfrom.value='#vmonthto2#'; }
	
	else if(document.purchaselisting.periodfrom.value=='03')	
	{	document.purchaselisting.monthfrom.value='#vmonthto3#'; }
	
	else if(document.purchaselisting.periodfrom.value=='04')	
	{	document.purchaselisting.monthfrom.value='#vmonthto4#'; }
	
	else if(document.purchaselisting.periodfrom.value=='05')	
	{	document.purchaselisting.monthfrom.value='#vmonthto5#'; }
	
	else if(document.purchaselisting.periodfrom.value=='06')	
	{	document.purchaselisting.monthfrom.value='#vmonthto6#'; }
	
	else if(document.purchaselisting.periodfrom.value=='07')	
	{	document.purchaselisting.monthfrom.value='#vmonthto7#'; }
	
	else if(document.purchaselisting.periodfrom.value=='08')	
	{	document.purchaselisting.monthfrom.value='#vmonthto8#'; }
	
	else if(document.purchaselisting.periodfrom.value=='09')	
	{	document.purchaselisting.monthfrom.value='#vmonthto9#'; }
	
	else if(document.purchaselisting.periodfrom.value=='10')	
	{	document.purchaselisting.monthfrom.value='#vmonthto10#'; }
	
	else if(document.purchaselisting.periodfrom.value=='11')	
	{	document.purchaselisting.monthfrom.value='#vmonthto11#'; }
	
	else if(document.purchaselisting.periodfrom.value=='12')	
	{	document.purchaselisting.monthfrom.value='#vmonthto12#'; }
	
	else if(document.purchaselisting.periodfrom.value=='13')	
	{	document.purchaselisting.monthfrom.value='#vmonthto13#'; }
	
	else if(document.purchaselisting.periodfrom.value=='14')	
	{	document.purchaselisting.monthfrom.value='#vmonthto14#'; }
	
	else if(document.purchaselisting.periodfrom.value=='15')	
	{	document.purchaselisting.monthfrom.value='#vmonthto15#'; }
	
	else if(document.purchaselisting.periodfrom.value=='16')	
	{	document.purchaselisting.monthfrom.value='#vmonthto16#'; }
	
	else if(document.purchaselisting.periodfrom.value=='17')	
	{	document.purchaselisting.monthfrom.value='#vmonthto17#'; }
	
	else if(document.purchaselisting.periodfrom.value=='18')	
	{	document.purchaselisting.monthfrom.value='#vmonthto18#'; }
	
	if(document.purchaselisting.periodto.value=='01')		
	{	document.purchaselisting.monthto.value='#vmonthto1#'; }
		
	else if(document.purchaselisting.periodto.value=='02')	
	{	document.purchaselisting.monthto.value='#vmonthto2#'; }
	
	else if(document.purchaselisting.periodto.value=='03')	
	{	document.purchaselisting.monthto.value='#vmonthto3#'; }
	
	else if(document.purchaselisting.periodto.value=='04')	
	{	document.purchaselisting.monthto.value='#vmonthto4#'; }
	
	else if(document.purchaselisting.periodto.value=='05')	
	{	document.purchaselisting.monthto.value='#vmonthto5#'; }
	
	else if(document.purchaselisting.periodto.value=='06')	
	{	document.purchaselisting.monthto.value='#vmonthto6#'; }
	
	else if(document.purchaselisting.periodto.value=='07')	
	{	document.purchaselisting.monthto.value='#vmonthto7#'; }
	
	else if(document.purchaselisting.periodto.value=='08')	
	{	document.purchaselisting.monthto.value='#vmonthto8#'; }
	
	else if(document.purchaselisting.periodto.value=='09')	
	{	document.purchaselisting.monthto.value='#vmonthto9#'; }
	
	else if(document.purchaselisting.periodto.value=='10')	
	{	document.purchaselisting.monthto.value='#vmonthto10#'; }
	
	else if(document.purchaselisting.periodto.value=='11')	
	{	document.purchaselisting.monthto.value='#vmonthto11#'; }
	
	else if(document.purchaselisting.periodto.value=='12')	
	{	document.purchaselisting.monthto.value='#vmonthto12#'; }
	
	else if(document.purchaselisting.periodto.value=='13')	
	{	document.purchaselisting.monthto.value='#vmonthto13#'; }
	
	else if(document.purchaselisting.periodto.value=='14')	
	{	document.purchaselisting.monthto.value='#vmonthto14#'; }
	
	else if(document.purchaselisting.periodto.value=='15')	
	{	document.purchaselisting.monthto.value='#vmonthto15#'; }
	
	else if(document.purchaselisting.periodto.value=='16')	
	{	document.purchaselisting.monthto.value='#vmonthto16#'; }
	
	else if(document.purchaselisting.periodto.value=='17')	
	{	document.purchaselisting.monthto.value='#vmonthto17#'; }
	
	else if(document.purchaselisting.periodto.value=='18')	
	{	document.purchaselisting.monthto.value='#vmonthto18#'; }
	
	}
</script>
</cfoutput>

<cfwindow width="550" height="400" name="findCustomer" refreshOnShow="true"
        title="Find Customer or Supplier" initshow="false"
        source="findCustomer.cfm?type={tran}&fromto={fromto}" />
</body>
</html>