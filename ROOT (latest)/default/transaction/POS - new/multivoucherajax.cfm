<cfquery name="getexistingvoucher" datasource="#dts#">
	select voucherno from posvoucherno where uuid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.uuid)#">
</cfquery>
<cfset voucherexistlist=valuelist(getexistingvoucher.voucherno)>

<cfquery name="getvoucher" datasource="#dtssync#">
	select * from voucher where (used='' or used is null) and DATEDIFF(now(),created_on)<=365 and voucherno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.voucherno)#"> and voucherno not in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#voucherexistlist#">)
</cfquery>

<cfoutput>
<cfif getvoucher.recordcount neq 0>

<cfquery name="insertvoucher" datasource="#dts#">
	insert into posvoucherno (voucherno,amt,created_on,uuid) values (<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.voucherno)#">,'#val(getvoucher.value)#',now(),<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.uuid)#">)
</cfquery>

<cfelse>
<h3>Voucher No Not Found</h3>
</cfif>

<cfquery name="getlist" datasource="#dts#">
	select * from posvoucherno where uuid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.uuid)#">
</cfquery>

<cfquery name="getlistamt" datasource="#dts#">
	select ifnull(sum(amt),0) as amt from posvoucherno where uuid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.uuid)#">
</cfquery>

<table width="250">
<tr>
<th>No</th>
<th>Voucher No</th>
<th>Amount</th>
</tr>
<cfloop query="getlist">
<tr>
<td><div align="center">#getlist.currentrow#</div></td>
<td>#getlist.voucherno#</td>
<td>#numberformat(getlist.amt,'.__')#</td>
</tr>
</cfloop>
<tr>
<td></td>
<td><input type="text" name="multivoucherno" id="multivoucherno" value="" onkeyup="addmultivoucherfunc(event,this.value);"/></td>
<td><input type="hidden" name="totalvoucherlist" id="totalvoucherlist" value="#valuelist(getlist.voucherno)#" /><input type="hidden" name="totalvoucheramt" id="totalvoucheramt" value="#getlistamt.amt#" /></td>
</tr>
</table>
</cfoutput>
