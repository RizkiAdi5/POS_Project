<script type='text/javascript' src='/ajax/core/engine.js'></script>
	<script type='text/javascript' src='/ajax/core/util.js'></script>
	<script type='text/javascript' src='/ajax/core/settings.js'></script>
    <script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>

 <script type="text/javascript">
 function changetype()
 {
	if(document.getElementById('supervisor').checked==true)
	{
	ajaxFunction(document.getElementById('editpasswordajaxfield'),'editpasswordajax.cfm?type=supervisor');
	}
	else if(document.getElementById('Cashier').checked==true)
	{
		ajaxFunction(document.getElementById('editpasswordajaxfield'),'editpasswordajax.cfm?type=cashier');
	}
 }
 </script>

<cfoutput>
<div align="center">
<cfquery datasource='#dts#' name="getartran">
	select * from artran where refno='#refno#' and type = "#tran#"
</cfquery>

<cfquery datasource='#dts#' name="getadmin">
	select * from supervisor
</cfquery>

<cfform action="editbillcontrolprocess.cfm?tran=#url.tran#&refno=#url.refno#&type=delete" method="post">
<div <cfif lcase(hcomid) eq 'tcds_i'>style="display:none"</cfif>>
<input type="radio" name="approvetype" id="supervisor" value="supervisor" checked="checked" onclick="changetype();" />Supervisor 
<input type="radio" name="approvetype" id="Cashier" value="Cashier" onclick="changetype();" />Cashier
</div>
<div id="editpasswordajaxfield">
<h4>Please Key in Supervisor Password for Allow Delete Bill</h4>
<cfif lcase(hcomid) eq 'tcds_i'>
<table>
<tr><td>Password  :</td><td><cfinput type="password" name="passwordString" id="passwordString" required="yes" message="Password is Required"></td>
</tr>
</table>
<cfelse>
<table>
<tr><td>Supervisor :</td><td>
<select name="supervisorid" id="supervisorid">
<cfloop query="getadmin">
<option value="#getadmin.supervisorid#">#getadmin.supervisorid# - #getadmin.name#</option>
</cfloop>
</select>
</td>
</tr>
<tr><td>Password  :</td><td><cfinput type="password" name="passwordString" id="passwordString" required="yes" message="Password is Required"></td>
</tr>
</table>
</cfif>
</div>
<br />
Remark :  <input type="text" name="reason" id="reason" value="" maxlength="80" size="50" />
<br />
<br />
<input type="submit" name="btn_sub" value="Submit">&nbsp;&nbsp;<input type="button" name="can_sub" value="Cancel" onClick="window.close();">
 </cfform>
</div>
</cfoutput>

<script type="text/javascript">
document.getElementById('passwordString').focus();
</script>