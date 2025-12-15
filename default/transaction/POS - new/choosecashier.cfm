<cfoutput>
<h1>Choose Cashier</h1>
<cfform name="choosecounter" id="choosecounter" action="choosecashier2.cfm" method="post">
<table>
<tr>
<th width="100px">Cashier</th>
<td width="15px">:</td>
<td width="200px">
<!---<cfquery name="getcounter" datasource="#dts#">
SELECT "" as cashierid,"Choose a Cashier" as cashierdesp
union all
SELECT * from (
SELECT counterid, concat(counterid,' - ',counterdesp) as counterdesp FROM counter order by counterid) as a
</cfquery>
<cfquery name="getbond" datasource="#dts#">
Select counterid FROM counter WHERE bonduser = <cfqueryparam cfsqltype="cf_sql_varchar" value="#huserid#">
</cfquery>

<cfselect name="cashierlist" id="cashierlist" query="getcashier" value="counterid" display="counterdesp" selected="#getbond.counterid#">
</cfselect>--->
<cfinput type="text" name="cashierlist" id="cashierlist" value="" onBlur="ajaxFunction(document.getElementById('getpasswordajax'),'choosecashier2.cfm?cashierid='+document.getElementById('cashierlist').value);" required="yes" message="cashier cannot be empty">
</td>
</tr>
<tr>
<th>Password</th>
<td width="15px">:</td>
<td><cfinput type="text" name="cashierpassword" id="cashierpassword" value="" required="yes" message="Password cannot be empty">

</td>
</tr>
<tr>
<td colspan="3" align="center">
<input type="button" name="counter_btn" id="counter_btn" value="Go" onClick="ajaxFunction(document.getElementById('getpasswordajax2'),'choosecashier3.cfm?password='+document.getElementById('cashierpassword').value);setTimeout('checkpassword();',200);">
</td>
</tr>
<tr><td>
<div id="getpasswordajax2">
<input type="hidden" name="cashierpasswordhash" id="cashierpasswordhash" value="" required="yes">
</div>
 <div id="getpasswordajax">
 <input type="hidden" name="hidcashierpassword" id="hidcashierpassword" value="">
 </div>
</td></tr>
</table>
</cfform>
</cfoutput>