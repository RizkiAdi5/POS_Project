<html>
<head>
<title><cfoutput>Vehicles</cfoutput> Listing</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">

<script type='text/javascript' src='/ajax/core/engine.js'></script>
<script type='text/javascript' src='/ajax/core/util.js'></script>
<script type='text/javascript' src='/ajax/core/settings.js'></script>

</head>

<script language="JavaScript">
<!--- 	document.form.Tick.value = toString(val(document.form.Tick.value)+1); --->
		<cfset counter=2>
		
		function getCust(type,option){
	if(type == 'custfrom'){
		var inputtext = document.form.searchsuppfr.value;
		DWREngine._execute(_reportflocation, null, 'supplierlookup', inputtext, option, getCustResult);
		
	}
	else{
		var inputtext = document.form.searchsuppto.value;
		DWREngine._execute(_reportflocation, null, 'supplierlookup', inputtext, option, getCustResult2);
	}
}

function getCustResult(suppArray){
	DWRUtil.removeAllOptions("groupfrom2");
	DWRUtil.addOptions("groupfrom2", suppArray,"KEY", "VALUE");
}

function getCustResult2(suppArray){
	DWRUtil.removeAllOptions("groupto2");
	DWRUtil.addOptions("groupto2", suppArray,"KEY", "VALUE");
}

function Tickmodel()	{
  if(document.form.cbmodel.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 7 Fields.");
	  document.form.cbmodel.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickcustname()	{
  if(document.form.cbcustname.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 7 Fields.");
	  document.form.cbcustname.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickcustic()	{
  if(document.form.cbcustic.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 7 Fields.");
	  document.form.cbcustic.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickgender()	{
  if(document.form.cbgender.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 7 Fields.");
	  document.form.cbgender.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}


function Tickmarstatus()	{
  if(document.form.cbmarstatus.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 7 Fields.");
	  document.form.cbmarstatus.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickcustadd()	{
  if(document.form.cbcustadd.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 7 Fields.");
	  document.form.cbcustadd.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickdob()	{
  if(document.form.cbdob.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 7 Fields.");
	  document.form.cbdob.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickNCD()	{
  if(document.form.cbNCD.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 7 Fields.");
	  document.form.cbNCD.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickcom()	{
  if(document.form.cbcom.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 7 Fields.");
	  document.form.cbcom.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickscheme()	{
  if(document.form.cbscheme.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 7 Fields.");
	  document.form.cbscheme.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickmake()	{
  if(document.form.cbmake.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 7 Fields.");
	  document.form.cbmake.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickchasisno()	{
  if(document.form.cbchasisno.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 7 Fields.");
	  document.form.cbchasisno.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickyearmade()	{
  if(document.form.cbyearmade.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 7 Fields.");
	  document.form.cbyearmade.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickoriregdate()	{
  if(document.form.cboriregdate.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 7 Fields.");
	  document.form.cboriregdate.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickcapacity()	{
  if(document.form.cbcapacity.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 7 Fields.");
	  document.form.cbcapacity.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickcoveragetype()	{
  if(document.form.cbcoveragetype.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 7 Fields.");
	  document.form.cbcoveragetype.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Ticksuminsured()	{
  if(document.form.cbsuminsured.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 7 Fields.");
	  document.form.cbsuminsured.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickinsurance()	{
  if(document.form.cbinsurance.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 7 Fields.");
	  document.form.cbinsurance.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickpremium()	{
  if(document.form.cbpremium.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 7 Fields.");
	  document.form.cbpremium.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickfinancecom()	{
  if(document.form.cbfinancecom.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 7 Fields.");
	  document.form.cbfinancecom.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickcommission()	{
  if(document.form.cbcommission.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 7 Fields.");
	  document.form.cbcommission.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickcontract()	{
  if(document.form.cbcontract.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 7 Fields.");
	  document.form.cbcontract.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickpayment()	{
  if(document.form.cbpayment.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 7 Fields.");
	  document.form.cbpayment.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickcustrefer()	{
  if(document.form.cbcustrefer.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 7 Fields.");
	  document.form.cbcustrefer.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickinexpdate()	{
  if(document.form.cbinexpdate.checked) {
    if(eval(document.form.Tick.value)<=(eval(document.form.counter.value)-1)){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 7 Fields.");
	  document.form.cbinexpdate.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function ClearAll()	{
  document.form.Tick.value = "-5";
  document.form.cbmodel.checked = false;
  document.form.cbcustname.checked = false;
  document.form.cbcustic.checked = false;
  document.form.cbgender.checked = false;
  document.form.cbmarstatus.checked = false;
  document.form.cbcustadd.checked = false;
  document.form.cbdob.checked = false;
  document.form.cbNCD.checked = false;
  document.form.cbcom.checked = false;
  document.form.cbscheme.checked = false;
  document.form.cbmake.checked = false;
  document.form.cbchasisno.checked = false;
  document.form.cbyearmade.checked = false;
  document.form.cboriregdate.checked = false;
  document.form.cbcapacity.checked = false;
  document.form.cbcoveragetype.checked = false;
  document.form.cbsuminsured.checked = false;
  document.form.cbinsurance.checked = false;
  document.form.cbpremium.checked = false;
  document.form.cbfinancecom.checked = false;
  document.form.cbcommission.checked = false;
  document.form.cbcontract.checked = false;
    document.form.cbpayment.checked = false;
	  document.form.cbcustrefer.checked = false;
	  	  	  document.form.cbinexpdate.checked = false;
  return true;
}


</script>

<body>

<cfquery name="getgeneral" datasource="#dts#">
select * from gsetup
</cfquery>
<cfquery name="getgroup" datasource="#dts#">
  select entryno, model, custcode, custname from vehicles order by entryno
</cfquery>

<cfquery name="getcust" datasource="#dts#">
  select custcode,custname from vehicles group by custcode order by custcode
</cfquery>



  <h1 align="center"><cfoutput>Vehicles Listing</cfoutput></h1>
<cfoutput>
    <h4 align = "center">
   <cfif getpin2.h1310 eq 'T'>
		<a href="vehicles2.cfm?type=Create">Creating a Vehicle</a> 
	</cfif>
	<cfif getpin2.h1320 eq 'T'>
		|| <a href="vehicles.cfm">List all Vehicles</a> 
	</cfif>
	<cfif getpin2.h1330 eq 'T'>
		|| <a href="s_Vehicles.cfm">Search For Vehicles</a> 
	</cfif>
	<cfif getpin2.h1340 eq 'T'>
		|| <a href="p_Vehicles.cfm">Vehicles Listing</a> 
	</cfif>
  </h4>
  </cfoutput>

<cfform action="l_vehicles.cfm" name="form" method="post" target="_blank">
  	<input type="hidden" name="Tick" value="0">

	<cfoutput><input type="hidden" name="counter" id="counter" value="#counter#"></cfoutput>
  <table border="0" align="center" width="90%" class="data">
    <tr> 
      <th width="20%"><cfoutput>Vehicles</cfoutput></th>
      <td width="5%"> <div align="center">From</div></td>
      <td colspan="6"><select name="groupfrom">
          <option value=""><cfoutput>Choose a Vehicles</cfoutput></option>
          <cfoutput query="getgroup">
            <option value="#entryno#">#entryno# </option>
          </cfoutput> </select></td>
    </tr>
    <tr>
      <th height="24"><cfoutput>Vehicles</cfoutput></th>
      <td><div align="center">To</div></td>
      <td colspan="6" nowrap> <select name="groupto">
          <option value=""><cfoutput>Choose a Vehicles</cfoutput></option>
          <cfoutput query="getgroup">
            <option value="#entryno#">#entryno#</option>
          </cfoutput> </select> </td>
	  </td>
    </tr>

    <tr> 
      <td colspan="8">&nbsp;</td>
    </tr>
    
    <tr> 
      <th width="20%"><cfoutput>Customer</cfoutput></th>
      <td width="5%"> <div align="center">From</div></td>
      <td colspan="6"><select name="groupfrom2">
          <option value=""><cfoutput>Choose Customer</cfoutput></option>
          <cfoutput query="getcust">
            <option value="#custcode#">#custcode# - #custname# </option>
          </cfoutput> </select>
           <cfif getgeneral.filterall eq "1">
				<input type="text" name="searchsuppfr" onKeyUp="getCust('custfrom','Customer');">
			</cfif>
          </td>
    </tr>
    <tr>
      <th height="24"><cfoutput>Customer</cfoutput></th>
      <td><div align="center">To</div></td>
      <td colspan="6" nowrap> <select name="groupto2">
          <option value=""><cfoutput>Choose Customer</cfoutput></option>
          <cfoutput query="getcust">
            <option value="#custcode#">#custcode# - #custname#</option>
          </cfoutput> </select>
          <cfif getgeneral.filterall eq "1">
				<input type="text" name="searchsuppto" onKeyUp="getCust('custto','Customer');">
			</cfif>
           </td>
	  </td>
    </tr>




    <tr> 
      <td colspan="8">&nbsp;</td>
    </tr>
   
    <tr> 
     
      <td colspan="100%"><div align="center"> 
          <input type="Submit" name="Submit" value="Submit">
        </div></td>
    </tr>
  </table>
</cfform>
</body>
</html>
