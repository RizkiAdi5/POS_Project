<html>
<head>
<title>Itemstatues Menu</title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">

<script type='text/javascript' src='../../ajax/core/engine.js'></script>
<script type='text/javascript' src='../../ajax/core/util.js'></script>
<script type='text/javascript' src='../../ajax/core/settings.js'></script>

<script type="text/javascript">

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

<cfquery name="getgeneral" datasource="#dts#">
	select filterall,lCATEGORY,lGROUP,lSIZE,lMATERIAL,lMODEL,lRATING,lAGENT,lDRIVER,lLOCATION from gsetup
</cfquery>
<!--- <cfquery name="getitem" datasource="#dts#">
	select itemno, desp from icitem order by itemno 
</cfquery> --->
<cfquery name="getgroup" datasource="#dts#">
	select wos_group, desp from icgroup 
</cfquery>
<cfquery name="getcate" datasource="#dts#">  
	select * from iccate  
</cfquery>

<!--- <h1 align="center">View Group Status and Value</h1> --->
<h3>
	<a href="stock_listingmenu.cfm">Inventory Listing Menu</a> >> 
	<a><font size="2">View Group Status and Value</font></a>
</h3>
<cfform action="groupstatus2.cfm" name="form" method="post" target="_blank">
  <table border="0" align="center" width="80%" class="data">
    <tr> 
		<th width="16%"><cfoutput>#getgeneral.lCATEGORY#</cfoutput> </th>
      	<td width="5%"> <div align="center">From</div></td>
      	<td colspan="2">
			<select name="Catefrom">
          		<option value="">Choose a <cfoutput>#getgeneral.lCATEGORY#</cfoutput></option>
          		<cfloop query="getcate"> 
            		<cfoutput><option value="#cate#">#cate# - #desp#</option></cfoutput>
          		</cfloop> 
			</select>
			<cfif getgeneral.filterall eq "1">
				<input type="text" name="searchcatefr" onkeyup="getCategory('Catefrom');">
			</cfif>
		</td>
    </tr>
    <tr> 
      	<th width="16%"><cfoutput>#getgeneral.lCATEGORY#</cfoutput></th>
      	<td width="5%"> <div align="center">To</div></td>
      	<td colspan="2">
			<select name="Cateto">
          		<option value="">Choose a <cfoutput>#getgeneral.lCATEGORY#</cfoutput></option>
          		<cfloop query="getcate"> 
            		<cfoutput><option value="#cate#">#cate# - #desp#</option></cfoutput>
          		</cfloop> 
			</select>
			<cfif getgeneral.filterall eq "1">
				<input type="text" name="searchcateto" onkeyup="getCategory('Cateto');">
			</cfif>
		</td>
    </tr>
    <tr> 
      <td colspan="5"><hr></td>
    </tr>
    <tr> 
      	<th width="16%"><cfoutput>#getgeneral.lGROUP#</cfoutput></th>
      	<td width="5%"> <div align="center">From</div></td>
      	<td colspan="2">
			<select name="groupfrom">
          		<option value="">Choose a <cfoutput>#getgeneral.lGROUP#</cfoutput></option>
          		<cfloop query="getgroup"> 
            		<cfoutput><option value="#wos_group#">#wos_group#</option></cfoutput>
          		</cfloop> 
			</select>
			<cfif getgeneral.filterall eq "1">
				<input type="text" name="searchgroupfr" onkeyup="getGroup('groupfrom');">
			</cfif>
		</td>
    </tr>
    <tr> 
      	<th width="16%"><cfoutput>#getgeneral.lGROUP#</cfoutput></th>
      	<td width="5%"> <div align="center">To</div></td>
      	<td colspan="2">
			<select name="groupto">
          		<option value="">Choose a <cfoutput>#getgeneral.lGROUP#</cfoutput></option>
          		<cfloop query="getgroup"> 
            		<cfoutput><option value="#wos_group#">#wos_group#</option></cfoutput>
          		</cfloop> 
			</select>
			<cfif getgeneral.filterall eq "1">
				<input type="text" name="searchgroupto" onkeyup="getGroup('groupto');">
			</cfif>
		</td>
    </tr>
    <tr> 
      <td colspan="5"><hr></td>
    </tr>
    <tr> 
      <th width="16%">Period</th>
      <td width="5%"> <div align="center">From</div></td>
      <td colspan="2"><select name="periodfrom">
          <!--- <option value="">Choose a period</option> --->
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
        </select></td>
    </tr>
    <tr> 
      <th width="16%">Period</th>
      <td width="5%"> <div align="center">To</div></td>
      <td colspan="2"><select name="periodto">
          <!--- <option value="">Choose a period</option> --->
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
        </select></td>
    </tr>
    <tr> 
      <td width="16%">&nbsp;</td>
      <td width="5%">&nbsp;</td>
      <td width="69%">&nbsp;</td>
      <td width="10%"><input type="Submit" name="Submit" value="Submit"></td>
    </tr>
  </table>
</cfform>


</body>
</html>