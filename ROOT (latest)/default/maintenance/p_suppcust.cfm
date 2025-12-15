<html>
<head>
<title><cfoutput>#type#</cfoutput> Listing</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
<script type='text/javascript' src='../../ajax/core/engine.js'></script>
<script type='text/javascript' src='../../ajax/core/util.js'></script>
<script type='text/javascript' src='../../ajax/core/settings.js'></script>

</head>

<script language="JavaScript">
function selectlist(custno,fieldtype){

			for (var idx=0;idx<document.getElementById(fieldtype).options.length;idx++)
			{
        	if (custno==document.getElementById(fieldtype).options[idx].value)
			{
            document.getElementById(fieldtype).options[idx].selected=true;
        	}
    		}

									}

<!--- 	document.form.Tick.value = toString(val(document.form.Tick.value)+1); --->
function TickAddress()	{
  if(document.form.cbAddress.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over "+document.form.counter.value+" Fields.");
	  document.form.cbAddress.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickAgent()	{
  if(document.form.cbAgent.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over "+document.form.counter.value+" Fields.");
	  document.form.cbAgent.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickArea()	{
  if(document.form.cbArea.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over "+document.form.counter.value+" Fields.");
	  document.form.cbArea.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickBusiness()	{
  if(document.form.cbBusiness.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over "+document.form.counter.value+" Fields.");
	  document.form.cbBusiness.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}


function TickDate()	{
  if(document.form.cbDate.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over "+document.form.counter.value+" Fields.");
	  document.form.cbDate.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickAttn()	{
  if(document.form.cbAttn.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over "+document.form.counter.value+" Fields.");
	  document.form.cbAttn.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickTerms()	{
  if(document.form.cbTerms.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over "+document.form.counter.value+" Fields.");
	  document.form.cbTerms.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickInvLimit()	{
  if(document.form.cbInvLimit.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over "+document.form.counter.value+" Fields.");
	  document.form.cbInvLimit.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickContact()	{
  if(document.form.cbContact.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over "+document.form.counter.value+" Fields.");
	  document.form.cbContact.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickCLimit()	{
  if(document.form.cbCLimit.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over "+document.form.counter.value+" Fields.");
	  document.form.cbCLimit.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickDPCate()	{
  if(document.form.cbDPCate.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over "+document.form.counter.value+" Fields.");
	  document.form.cbDPCate.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickPhone()	{
  if(document.form.cbPhone.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over "+document.form.counter.value+" Fields.");
	  document.form.cbPhone.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickCurrCode()	{
  if(document.form.cbCurrCode.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over "+document.form.counter.value+" Fields.");
	  document.form.cbCurrCode.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickDPL1()	{
  if(document.form.cbDPL1.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over "+document.form.counter.value+" Fields.");
	  document.form.cbDPL1.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickPhone2()	{
  if(document.form.cbPhone2.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over "+document.form.counter.value+" Fields.");
	  document.form.cbPhone2.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickCurr()	{
  if(document.form.cbCurr.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over "+document.form.counter.value+" Fields.");
	  document.form.cbCurr.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickDPL2()	{
  if(document.form.cbDPL2.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over "+document.form.counter.value+" Fields.");
	  document.form.cbDPL2.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickFax()	{
  if(document.form.cbFax.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over "+document.form.counter.value+" Fields.");
	  document.form.cbFax.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickCurrDollar()	{
  if(document.form.cbCurrDollar.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over "+document.form.counter.value+"5 Fields.");
	  document.form.cbCurrDollar.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickDPL3()	{
  if(document.form.cbDPL3.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over "+document.form.counter.value+" Fields.");
	  document.form.cbDPL3.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickEmail()	{
  if(document.form.cbEmail.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over "+document.form.counter.value+" Fields.");
	  document.form.cbEmail.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickCurrCents()	{
  if(document.form.cbCurrCents.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over "+document.form.counter.value+" Fields.");
	  document.form.cbCurrCents.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickdadd()	{
  if(document.form.cbdadd.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over "+document.form.counter.value+" Fields.");
	  document.form.cbdadd.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Ticknormalrate()	{
  if(document.form.cbnormalrate.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over "+document.form.counter.value+" Fields.");
	  document.form.cbnormalrate.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickofferrate()	{
  if(document.form.cbofferrate.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over "+document.form.counter.value+" Fields.");
	  document.form.cbofferrate.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickotherrate()	{
  if(document.form.cbotherrate.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over "+document.form.counter.value+" Fields.");
	  document.form.cbotherrate.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickcountry()	{
  if(document.form.cbcountry.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over "+document.form.counter.value+" Fields.");
	  document.form.cbcountry.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Ticksalec()	{
  if(document.form.cbsalec.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over "+document.form.counter.value+" Fields.");
	  document.form.cbsalec.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Ticksalecnc()	{
  if(document.form.cbsalecnc.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over "+document.form.counter.value+" Fields.");
	  document.form.cbsalecnc.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function ClearAll()	{
  document.form.Tick.value = "0";
  document.form.cbAddress.checked = false;
  document.form.cbAgent.checked = false;
  document.form.cbArea.checked = false;
  document.form.cbBusiness.checked = false;
  document.form.cbDate.checked = false;
  document.form.cbAttn.checked = false;
  document.form.cbTerms.checked = false;
  document.form.cbInvLimit.checked = false;
  document.form.cbContact.checked = false;
  document.form.cbCLimit.checked = false;
  document.form.cbDPCate.checked = false;
  document.form.cbPhone.checked = false;
  document.form.cbCurrCode.checked = false;
  document.form.cbDPL1.checked = false;
  document.form.cbPhone2.checked = false;
  document.form.cbCurr.checked = false;
  document.form.cbDPL2.checked = false;
  document.form.cbFax.checked = false;
  document.form.cbCurrDollar.checked = false;
  document.form.cbDPL3.checked = false;
  document.form.cbEmail.checked = false;
  document.form.cbCurrCents.checked = false;
  document.form.cbdadd.checked = false;
  document.form.cbnormalrate.checked = false;
  document.form.cbofferrate.checked = false;
  document.form.cbotherrate.checked = false;
  document.form.cbpostal.checked = false;
  document.form.cbcountry.checked = false;
  document.form.cbsalec.checked = false;
  document.form.cbsalecnc.checked = false;
  return true;
}

// begin: supplier search
function getSupp(type,option){
	if(type == 'Custfrom'){
		var inputtext = document.form.searchsuppfr.value;
		DWREngine._execute(_reportflocation, null, 'supplierlookup', inputtext, option, getSuppResult);

	}
	else{
		var inputtext = document.form.searchsuppto.value;
		DWREngine._execute(_reportflocation, null, 'supplierlookup', inputtext, option, getSuppResult2);
	}
}

function getSuppResult(suppArray){
	DWRUtil.removeAllOptions("Custfrom");
	DWRUtil.addOptions("Custfrom", suppArray,"KEY", "VALUE");
}

function getSuppResult2(suppArray){
	DWRUtil.removeAllOptions("Custto");
	DWRUtil.addOptions("Custto", suppArray,"KEY", "VALUE");
}
// end: supplier search

</script>

<body>
<!--- ADD ON 11-09-2008 --->
<cfquery name="getgeneral" datasource="#dts#">
	select filterall,agentlistuserid from gsetup
</cfquery>
<!--- Add On 13-01-2010 --->
<cfquery name="getdealer_menu" datasource="#dts#">
	select custSuppSortBy,productSortBy,custformat from dealer_menu limit 1
</cfquery>
<cfset target_table = iif(url.type eq "customer",DE(target_arcust),DE(target_apvend))>

<cfif isdefined("url.type")>
  	<cfset typeNo="cust" & "No">
  	<cfset link = url.type &".cfm">

  	<!--- <cfquery datasource='#dts#' name="getPersonnel">
		Select * from #target_table# order by #typeNo#
  	</cfquery> --->
	<cfquery datasource='#dts#' name="getPersonnel">
		Select * from #target_table# where 0=0
        <cfif url.type eq "Customer" and getpin2.h1t00 eq 'T'>
<cfif getgeneral.agentlistuserid eq "Y">and ucase(agent) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(created_by)='#ucase(huserid)#' or ucase(agent)='#ucase(huserid)#')
					</cfif>
					<cfelse>
					<cfif Huserloc neq "All_loc">
					and (created_by in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif>
                    </cfif>
        order by <cfif getdealer_menu.custSuppSortBy neq "">#getdealer_menu.custSuppSortBy#<cfelse>custno</cfif>
  	</cfquery>
  	<cfset type = url.type>
<cfelse>
  	<cfset typeNo= type & "No">
  	<cfset link = type &".cfm">

  	<!--- <cfquery datasource='#dts#' name="getPersonnel">
		Select * from #target_table#
		<cfif url.type eq 'Customer' and husergrpid neq "admin"and husergrpid neq 'super'>
	  		where agent = '#huserid#'
		</cfif>
		order by #typeNo#
  	</cfquery> --->
	<cfquery datasource='#dts#' name="getPersonnel">
		Select * from #target_table#
		<cfif url.type eq 'Customer' and husergrpid neq "admin"and husergrpid neq 'super'>
			where agent = '#huserid#'
		</cfif>
		order by <cfif getdealer_menu.custSuppSortBy neq "">#getdealer_menu.custSuppSortBy#<cfelse>custno</cfif>
  </cfquery>
</cfif>

<cfoutput>
  <h1 align="center">#url.type# Listing</h1>

  <h4>
	<cfif husergrpid eq 'Admin' or husergrpid eq 'Super'><a href="#link#?type=Create"> Creating a New #type#</a> || </cfif>
	<a href="vPersonnel.cfm?type=#url.type#">List all #type#</a> ||
	<a href="linkPage.cfm?type=#url.type#">Search #type#</a> ||
	<a href="p_suppcust.cfm?type=#url.type#">#type# Listing</a>
	|| <a href="printlabel.cfm?type=#type#">Print #type# Labels</a>
	<!--- <cfif #url.type# eq 'Customer'>
	   || <a href="psuppcust.cfm?type=Customer" target="_blank">Customer Summary Report</a>
	</cfif> --->
  </h4>
</cfoutput>

<cfform action="l_suppcust.cfm?Type=#url.type#" name="form" method="post" target="_blank">
<input type="hidden" name="fromto" id="fromto" value="" />
  	<input type="hidden" name="Tick" value="0">
    <cfoutput>
    <cfif url.type eq "customer">
<input type="hidden" name="tran" id="tran" value="#target_arcust#" />
<cfelse>
<input type="hidden" name="tran" id="tran" value="#target_apvend#" />
</cfif>
    </cfoutput>

	<cfif lcase(hcomid) eq "fdipx_i">
		<cfset counter=30>
	<cfelse>
		<cfset counter=30>
	</cfif>
	<cfoutput><input type="hidden" name="counter" id="counter" value="#counter#"></cfoutput>
  <table border="0" align="center" width="90%" class="data">
  <tr>
		<th>Report Format</th>
		<td colspan="3">
			<input type="radio" name="result" value="HTML" checked>HTML<br/>
			<input type="radio" name="result" value="EXCELDEFAULT">EXCEL DEFAULT
		</td>
	</tr>
    <tr>
      <th width="20%"><cfoutput>#type#</cfoutput></th>
      <td width="5%"> <div align="center">From</div></td>
      <td colspan="6">
	    <select name="Custfrom">
          <option value=""><cfoutput>Choose a #type#</cfoutput></option>
          <cfoutput query="getPersonnel">
            <option value="#custno#">#custno# - #name#</option>
          </cfoutput>
		</select>
		<cfif getgeneral.filterall eq "1">
			<cfoutput><input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='from';ColdFusion.Window.show('findCustomer');" />&nbsp;<input type="text" name="searchsuppfr" onKeyUp="getSupp('Custfrom','#type#');"></cfoutput>
		</cfif>
	  </td>
    </tr>
    <tr>
      <th><cfoutput>#type#</cfoutput></th>
      <td><div align="center">To</div></td>
      <td colspan="6" nowrap>
	    <select name="Custto">
          <option value=""><cfoutput>Choose a #type#</cfoutput></option>
          <cfoutput query="getPersonnel">
            <option value="#custno#">#custno# - #name#</option>
          </cfoutput>
		</select>
		<cfif getgeneral.filterall eq "1">
			<cfoutput>
            <input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='to';ColdFusion.Window.show('findCustomer');" />&nbsp;
            <input type="text" name="searchsuppto" onKeyUp="getSupp('Custto','#type#');"></cfoutput>
		</cfif>
	  </td>
    </tr>
	<tr><td><br></td></tr>

	<cfoutput>
	<cfquery name="getagent" datasource="#dts#">
		select agent,desp from icagent order by agent
	</cfquery>
	<tr>
      <th>Agent</th>
      <td><div align="center">From</div></td>
      <td colspan="6" nowrap>
	    <select name="agentfrom">
          <option value="">Choose a Agent</option>
          <cfloop query="getagent">
            <option value="#agent#">#agent# - #desp#</option>
          </cfloop>
		</select>
	  </td>
    </tr>
	<tr>
      <th>Agent</th>
      <td><div align="center">To</div></td>
      <td colspan="6" nowrap>
	    <select name="agentto">
          <option value="">Choose a Agent</option>
          <cfloop query="getagent">
            <option value="#agent#">#agent# - #desp#</option>
		  </cfloop>
		</select>
	  </td>
    </tr>
	</cfoutput>
	<tr><td><br></td></tr>
	<cfoutput>
	<cfquery name="getarea" datasource="#dts#">
		select area from icarea order by area
	</cfquery>
	<tr>
      <th>Area</th>
      <td><div align="center">From</div></td>
      <td colspan="6" nowrap>
	    <select name="areafrom">
          <option value="">Choose a Area</option>
          <cfloop query="getarea">
            <option value="#area#">#area# </option>
          </cfloop>
		</select>
	  </td>
    </tr>
	<tr>
      <th>Area</th>
      <td><div align="center">To</div></td>
      <td colspan="6" nowrap>
	    <select name="areato">
          <option value="">Choose a Area</option>
          <cfloop query="getarea">
            <option value="#area#">#area#</option>
		  </cfloop>
		</select>
	  </td>
    </tr>
	</cfoutput>
	<tr><td><br></td></tr>
	<cfoutput>
	<cfquery name="getbusiness" datasource="#dts#">
		select business from business order by business
	</cfquery>
	<tr>
      <th>Business</th>
      <td><div align="center">From</div></td>
      <td colspan="6" nowrap>
	    <select name="businessfrom">
          <option value="">Choose a Business</option>
          <cfloop query="getbusiness">
            <option value="#business#">#business# </option>
          </cfloop>
		</select>
	  </td>
    </tr>
	<tr>
      <th>Business</th>
      <td><div align="center">To</div></td>
      <td colspan="6" nowrap>
	    <select name="businessto">
          <option value="">Choose a Business</option>
          <cfloop query="getbusiness">
            <option value="#business#">#business#</option>
		  </cfloop>
		</select>
	  </td>
    </tr>
	</cfoutput>
    <tr>
      <td colspan="8">&nbsp;</td>
    </tr>
    <tr>
      <th>Exclude Bad Status</th>
      <td><div align="center"></div></td>
      <td colspan="6" nowrap>
	   <input type="checkbox" name="badstatus" value="checkbox" >
	  </td>
    </tr>

    <tr>
      <td colspan="8">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="8"><div align="center">
          <h4><font color="#FF3333">Please Tick Fields To Display In The Listing</font></h4>
        </div></td>
    </tr>
    <tr>
      <td colspan="8"><hr></td>
    </tr>
    <tr>
      <th width="20%">Address</th>
      <td width="5%"><input type="checkbox" name="cbAddress" value="checkbox" onClick="javascript:TickAddress()"></td>
      <th width="20%">Agent</th>
      <td width="5%"><input type="checkbox" name="cbAgent" value="checkbox" onClick="javascript:TickAgent()"></td>
      <th width="20%">Date</th>
      <td width="5%"><input type="checkbox" name="cbDate" value="checkbox" onClick="javascript:TickDate()"></td>
      <td width="12%" colspan="2"><div align="right">
          <input type="Button" name="ClearAllChkBox" value="Clear All Check Box" onClick="javascript:ClearAll()">
        </div></td>
    </tr>
	 <tr>
      <th width="20%">Area</th>
      <td width="5%"><input type="checkbox" name="cbArea" value="checkbox" onClick="javascript:TickArea()"></td>
      <th width="20%">Business</th>
      <td width="5%"><input type="checkbox" name="cbBusiness" value="checkbox" onClick="javascript:TickBusiness()"></td>
      <th width="20%">Attention</th>
      <td width="5%"><input type="checkbox" name="cbAttn" value="checkbox" onClick="javascript:TickAttn()"></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <th width="20%">Contact</th>
      <td width="5%"><input type="checkbox" name="cbContact" value="checkbox" onClick="javascript:TickContact()"></td>
      <th width="20%">Terms</th>
      <td width="5%"><input type="checkbox" name="cbTerms" value="checkbox" onClick="javascript:TickTerms()"></td>
      <th width="20%">Invoice Limit</th>
      <td width="5%"><input type="checkbox" name="cbInvLimit" value="checkbox" onClick="javascript:TickInvLimit()"></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <th width="20%">Telephone</th>
      <td width="5%"><input type="checkbox" name="cbPhone" value="checkbox" onClick="javascript:TickPhone()"></td>
      <th width="20%">Credit Limit</th>
      <td width="5%"><input type="checkbox" name="cbCLimit" value="checkbox" onClick="javascript:TickCLimit()"></td>
      <th width="20%">Discount Percentage Category</th>
      <td width="5%"><input type="checkbox" name="cbDPCate" value="checkbox" onClick="javascript:TickDPCate()"></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <th width="20%">Telephone 2</th>
      <td width="5%"><input type="checkbox" name="cbPhone2" value="checkbox" onClick="javascript:TickPhone2()"></td>
      <th width="20%">Currency Code</th>
      <td width="5%"><input type="checkbox" name="cbCurrCode" value="checkbox" onClick="javascript:TickCurrCode()"></td>
      <th width="20%">Discount Percentage Level 1</th>
      <td width="5%"><input type="checkbox" name="cbDPL1" value="checkbox" onClick="javascript:TickDPL1()"></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <th width="20%">Fax</th>
      <td width="5%"><input type="checkbox" name="cbFax" value="checkbox" onClick="javascript:TickFax()"></td>
      <th width="20%">Currency</th>
      <td width="5%"><input type="checkbox" name="cbCurr" value="checkbox" onClick="javascript:TickCurr()"></td>
      <th width="20%">Discount Percentage Level 2</th>
      <td width="5%"><input type="checkbox" name="cbDPL2" value="checkbox" onClick="javascript:TickDPL2()"></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <th width="20%">Email</th>
      <td width="5%"><input type="checkbox" name="cbEmail" value="checkbox" onClick="javascript:TickEmail()"></td>
      <th width="20%">Currency Dollar</th>
      <td width="5%"><input type="checkbox" name="cbCurrDollar" value="checkbox" onClick="javascript:TickCurrDollar()"></td>
      <th width="20%">Discount Percentage Level 3</th>
      <td width="5%"><input type="checkbox" name="cbDPL3" value="checkbox" onClick="javascript:TickDPL3()"></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <th width="20%">Currency Cents</th>
      <td width="5%"><input type="checkbox" name="cbCurrCents" value="checkbox" onClick="javascript:TickCurrCents()"></td>
      <th width="20%">Delivery Address</th>
      <td width="5%"><input type="checkbox" name="cbdadd" value="checkbox" onClick="javascript:Tickdadd()"></td>
      <th width="20%">Postal Code</th>
      <td width="5%"><input type="checkbox" name="cbpostal" value="checkbox"></td>
      <td width="12%"> <cfoutput> </cfoutput></td>
      <td width="5%"></td>
    </tr>
    <tr>
      <th width="20%">Country</th>
      <td width="5%"><input type="checkbox" name="cbcountry" value="checkbox" onClick="javascript:Tickcountry()"></td>
      <th width="20%">Normal Rate</th>
      <td width="5%"><input type="checkbox" name="cbnormalrate" value="checkbox" onClick="javascript:Ticknormalrate()"></td>
      <th width="20%">Offer Rate</th>
      <td width="5%"><input type="checkbox" name="cbofferrate" value="checkbox" onClick="javascript:Tickofferrate()"></td>

      <td width="12%"> <cfoutput> </cfoutput></td>
    </tr>

    <tr>

      <th width="20%">Other Rate</th>
      <td width="5%"><input type="checkbox" name="cbotherrate" value="checkbox" onClick="javascript:Tickotherrate()"></td>
      <th width="20%">Credit Sales Code</th>
      <td width="5%"><input type="checkbox" name="cbsalec" value="checkbox" onClick="javascript:Ticksalec()"></td>
      <th width="20%">Sales Return Code</th>
      <td width="5%"><input type="checkbox" name="cbsalecnc" value="checkbox" onClick="javascript:Ticksalecnc()"></td>
      <td width="12%"> <cfoutput> </cfoutput></td>
      <td width="5%"><div align="right">
          <input type="Submit" name="Submit" value="Submit">
        </div></td>
    </tr>
  </table>
</cfform>
</body>
</html>

<cfif getdealer_menu.custformat eq '2'>
<cfwindow width="550" height="400" name="findCustomer" refreshOnShow="true"
        title="Find Customer or Supplier" initshow="false"
        source="findCustomer2.cfm?type={tran}&fromto={fromto}" />
<cfelse>
<cfwindow width="550" height="400" name="findCustomer" refreshOnShow="true"
        title="Find Customer or Supplier" initshow="false"
        source="findCustomer.cfm?type={tran}&fromto={fromto}" />
</cfif>