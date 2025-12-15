<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "2061, 2057, 572, 1276">
<cfinclude template="/latest/words.cfm">

<cfoutput>
<h1>#words[2061]#</h1>
<table>
<tr>
<th width="100px">#words[2057]#</th>
<td width="15px">:</td>
<td width="200px">
<cfquery name="getcashier" datasource="#dts#">
SELECT "" as cashierid,"#words[2061]#" as cashierdesp
union all
SELECT * from (
SELECT cashierid, concat(cashierid,' - ',name) as cashierdesp FROM cashier order by cashierid) as a
</cfquery><!---
<cfquery name="getbond" datasource="#dts#">
Select counterid FROM counter WHERE bonduser = <cfqueryparam cfsqltype="cf_sql_varchar" value="#huserid#">
</cfquery>--->

<select name="cashierlist" id="cashierlist" onchange="ajaxFunction(document.getElementById('getpasswordajax'),'choosecashier2.cfm?cashierid='+document.getElementById('cashierlist').value);"  >
<cfloop query="getcashier">
<option value="#cashierid#">#cashierdesp#</option>
</cfloop>
</select><!---
<cfinput type="text" name="cashierlist" id="cashierlist" value="" onBlur="ajaxFunction(document.getElementById('getpasswordajax'),'choosecashier2.cfm?cashierid='+document.getElementById('cashierlist').value);" required="yes" message="cashier cannot be empty">--->
</td>
</tr>
<tr>
<th>#words[572]#</th>
<td width="15px">:</td>
<td><input type="password" name="cashierpassword" id="cashierpassword" value="" required="yes" message="Password cannot be empty" onkeyup="if(event.keyCode==13){ajaxFunction(document.getElementById('getpasswordajax2'),'choosecashier3.cfm?password='+document.getElementById('cashierpassword').value);setTimeout('checkpassword();',200);}">

</td>
</tr>
<tr>
<td colspan="3" align="center">
<input type="button" name="counter_btn" id="counter_btn" value="#words[1276]#" onClick="ajaxFunction(document.getElementById('getpasswordajax2'),'choosecashier3.cfm?password='+document.getElementById('cashierpassword').value);setTimeout('checkpassword();',200);">
</td>
</tr>
<tr><td>
<div id="getpasswordajax2">
<input type="hidden" name="cashierpasswordhash" id="cashierpasswordhash" value="" required>
</div>
 <div id="getpasswordajax">
 <input type="hidden" name="hidcashierpassword" id="hidcashierpassword" value="">
 </div>
</td></tr>
</table>

</cfoutput>