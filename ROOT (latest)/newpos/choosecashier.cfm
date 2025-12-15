<link rel="stylesheet" type="text/css" href="../newpos/table.css" />
 
<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "2061, 2057, 572, 1276">
<cfinclude template="/latest/words.cfm">

<cfquery name="getcashier" datasource="#dts#">
SELECT "" as cashierid,"#words[2061]#" as cashierdesp
union all
SELECT * from (
SELECT cashierid, concat(cashierid,' - ',name) as cashierdesp FROM cashier order by cashierid) as a
</cfquery>

<cfoutput>
<center>
<table class="table-style-three">
	<thead>
	<tr>
		<th colspan="2"><h2>#words[2061]#</h2></th>
	</tr>
	</thead>
	<tbody>
	<tr>
		<td "250px;">#words[2057]# :</td>
		<td>
        <select name="cashierlist" id="cashierlist" onchange="ajaxFunction(document.getElementById('getpasswordajax'),'choosecashier2.cfm?cashierid='+document.getElementById('cashierlist').value);"  style="width:206px" >
<cfloop query="getcashier">
<option value="#cashierid#">#cashierdesp#</option>
</cfloop>
</select>
        </td>
	</tr>
	<tr>
		<td>#words[572]# :</td>
		<td><input type="password" name="cashierpassword" id="cashierpassword" value="" required="yes" message="Password cannot be empty" onkeyup="if(event.keyCode==13){ajaxFunction(document.getElementById('getpasswordajax2'),'choosecashier3.cfm?password='+document.getElementById('cashierpassword').value);setTimeout('checkpassword();',200);}"></td>
	</tr>
	<tr>
		<td colspan="2" align="center"><input type="button" name="counter_btn" id="counter_btn" value="#words[1276]#" onClick="ajaxFunction(document.getElementById('getpasswordajax2'),'choosecashier3.cfm?password='+document.getElementById('cashierpassword').value);setTimeout('checkpassword();',200);"></td>
	</tr>
	</tbody>
</table>
<div id="getpasswordajax2">
<input type="hidden" name="cashierpasswordhash" id="cashierpasswordhash" value="" required>
</div>
<div id="getpasswordajax">
<input type="hidden" name="hidcashierpassword" id="hidcashierpassword" value="">
</div>
</center>
</cfoutput>