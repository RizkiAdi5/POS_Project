<cfoutput>
<div align="center">

<cfif url.type eq 'supervisor'>
<cfquery datasource='#dts#' name="getadmin">
	select * from supervisor
</cfquery>

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
<tr><td>Password  :</td><td><input type="password" name="passwordString" id="passwordString" ></td>
</tr>
</table>
</cfif>
<cfelse>

<cfquery name="getcashier" datasource="#dts#">
select * from cashier
</cfquery>

<h4>Please Key in Supervisor Password for Allow Delete Bill</h4>
<table>
<tr><td nowrap="nowrap">Cashier 1 :</td><td>
<select name="cashierid1" id="cashierid1">
<cfloop query="getcashier">
<option value="#getcashier.cashierid#">#getcashier.cashierid#</option>
</cfloop>
</select>
</td>
<td nowrap="nowrap">Password  :</td><td><input type="password" name="passwordString1" id="passwordString1"></td>
</tr>

<tr><td>Cashier 2 :</td><td>
<select name="cashierid2" id="cashierid2">
<cfloop query="getcashier">
<option value="#getcashier.cashierid#">#getcashier.cashierid#</option>
</cfloop>
</select>
</td>
<td>Password  :</td><td><input type="password" name="passwordString2" id="passwordString2"></td>
</tr>

</table>

</cfif>
</cfoutput>