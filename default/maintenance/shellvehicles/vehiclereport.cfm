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
		<cfset displaycounter = counter +5>
		
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
  select carno, model, custcode, custname from vehicles order by carno
</cfquery>

<cfquery name="getcust" datasource="#dts#">
  select custcode,custname from vehicles group by custcode order by custcode
</cfquery>

  <h1 align="center"><cfoutput>Vehicles History Report</cfoutput></h1>
<cfoutput>
    <h4 align = "center">
    <a href="vehicles.cfm">Creating a New Vehicles</a>||
    <a href="p_vehicles.cfm">Vehicles Listing</a>||
    <a href="vehiclereport.cfm">Vehicles History Report</a>||
    <a href="vehiclerenew.cfm">Vehicles Renew Report</a>
  </h4>
  </cfoutput>

<cfform action="vehiclereport2.cfm" name="form" method="post" target="_blank">
  	<input type="hidden" name="Tick" value="0">

	<cfoutput><input type="hidden" name="counter" id="counter" value="#counter#"></cfoutput>
  <table border="0" align="center" width="90%" class="data">

   <tr> 
      <th width="20%"><cfoutput>Report Sort By</cfoutput></th>
      <td width="5%"> <div align="center"></div></td>
      <td colspan="1"><input type="radio" name="trantype" id="trantype" value="carno" checked /> Vehicle NO</td>
      <td colspan="2"><input type="radio" name="trantype" id="trantype" value="custcode" /> Customer Code</td>
    </tr>

    
    <tr> 
      <th width="20%"><cfoutput>Vehicles</cfoutput></th>
      <td width="5%"> <div align="center">From</div></td>
      <td colspan="6"><select name="groupfrom">
          <option value=""><cfoutput>Choose a Vehicles</cfoutput></option>
          <cfoutput query="getgroup">
            <option value="#carno#">#carno# </option>
          </cfoutput> </select>
          </td>
    </tr>
    <tr>
      <th height="24"><cfoutput>Vehicles</cfoutput></th>
      <td><div align="center">To</div></td>
      <td colspan="6" nowrap> <select name="groupto">
          <option value=""><cfoutput>Choose a Vehicles</cfoutput></option>
          <cfoutput query="getgroup">
            <option value="#carno#">#carno#</option>
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
			</cfif></td>
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
      <td colspan="8"><div align="center">
          <h4><font color="#FF3333">Please Tick <cfoutput>#displaycounter#</cfoutput> Fields To Display In The Report</font></h4>
        </div></td>
    </tr>
    <tr> 
      <td colspan="8"><hr></td>
    </tr>
    <tr> 
      <th width="20%">Model</th>
      <td width="5%"><input type="checkbox" name="cbmodel" value="checkbox" onClick="javascript:Tickmodel()"  checked></td>
      <th width="20%">Customer name</th>
      <td width="5%"><input type="checkbox" name="cbcustname" value="checkbox" onClick="javascript:Tickcustname()"  checked></td>
      <th width="20%">Custtomer IC</th>
      <td width="5%"><input type="checkbox" name="cbcustic" value="checkbox" onClick="javascript:Tickcustic()"  checked></td>
      <td width="12%" colspan="2"><div align="right"> 
          <input type="Button" name="ClearAllChkBox" value="Clear All Check Box" onClick="javascript:ClearAll()">
        </div></td>
    </tr>
	 <tr> 
      <th width="20%">Gender</th>
      <td width="5%"><input type="checkbox" name="cbgender" value="checkbox" onClick="javascript:Tickgender()"></td>
      <th width="20%">Marial Status</th>
      <td width="5%"><input type="checkbox" name="cbmarstatus" value="checkbox" onClick="javascript:Tickmarstatus()"></td>
      <th width="20%">Customer address</th>
      <td width="5%"><input type="checkbox" name="cbcustadd" value="checkbox" onClick="javascript:Tickcustadd()"  checked></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <th width="20%">Date Of Birth</th>
      <td width="5%"><input type="checkbox" name="cbdob" value="checkbox" onClick="javascript:Tickdob()"></td>
      <th width="20%">NCD</th>
      <td width="5%"><input type="checkbox" name="cbNCD" value="checkbox" onClick="javascript:TickNCD()"></td>
      <th width="20%">Certificate of Merit</th>
      <td width="5%"><input type="checkbox" name="cbcom" value="checkbox" onClick="javascript:Tickcom()"></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <th width="20%">Scheme</th>
      <td width="5%"><input type="checkbox" name="cbscheme" value="checkbox" onClick="javascript:Tickscheme()"></td>
      <th width="20%">Vehicle Make</th>
      <td width="5%"><input type="checkbox" name="cbmake" value="checkbox" onClick="javascript:Tickmake()"></td>
      <th width="20%">Chasis No</th>
      <td width="5%"><input type="checkbox" name="cbchasisno" value="checkbox" onClick="javascript:Tickchasisno()"></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <th width="20%">Year of Manufacture</th>
      <td width="5%"><input type="checkbox" name="cbyearmade" value="checkbox" onClick="javascript:Tickyearmade()"  checked></td>
      <th width="20%">Original reg Date</th>
      <td width="5%"><input type="checkbox" name="cboriregdate" value="checkbox" onClick="javascript:Tickoriregdate()"></td>
      <th width="20%">Capacity</th>
      <td width="5%"><input type="checkbox" name="cbcapacity" value="checkbox" onClick="javascript:Tickcapacity()"></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <th width="20%">Coverage type</th>
      <td width="5%"><input type="checkbox" name="cbcoveragetype" value="checkbox" onClick="javascript:Tickcoveragetype()"></td>
      <th width="20%">Sum insured</th>
      <td width="5%"><input type="checkbox" name="cbsuminsured" value="checkbox" onClick="javascript:Ticksuminsured()"></td>
      <th width="20%">Insurance</th>
      <td width="5%"><input type="checkbox" name="cbinsurance" value="checkbox" onClick="javascript:Tickinsurance()"></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <th width="20%">Premium</th>
      <td width="5%"><input type="checkbox" name="cbpremium" value="checkbox" onClick="javascript:Tickpremium()"></td>
      <th width="20%">Finance company</th>
      <td width="5%"><input type="checkbox" name="cbfinancecom" value="checkbox" onClick="javascript:Tickfinancecom()"></td>
      <th width="20%">Commission</th>
      <td width="5%"><input type="checkbox" name="cbcommission" value="checkbox" onClick="javascript:Tickcommission()"></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <th width="20%">Contact</th>
      <td width="5%"><input type="checkbox" name="cbcontract" value="checkbox" onClick="javascript:Tickcontract()"></td>
      <th width="20%">Payment</th>
      <td width="5%"><input type="checkbox" name="cbpayment" value="checkbox"  onClick="javascript:Tickpayment()"></td>
      <th width="20%">Refered By</th>
      <td width="5%"><input type="checkbox" name="cbcustrefer" value="checkbox"  onClick="javascript:Tickcustrefer()"></td>
       <th width="20%">Insurance Expire Date&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="cbinexpdate" value="checkbox" onClick="javascript:Tickinexpdate()"></th>
      <td width="5%"><div align="right"> 
          <input type="Submit" name="Submit" value="Submit">
        </div></td>
    </tr>
  </table>
</cfform>
</body>
</html>
