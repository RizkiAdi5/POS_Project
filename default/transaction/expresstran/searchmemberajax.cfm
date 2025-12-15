<cfoutput>
<cfquery name="getlist" datasource="#dts#">
SELECT driverno,name,contact,add1,add2,add3 FROM driver 
WHERE 1 = 1
<cfif url.driverno neq "">
and driverno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.driverno)#%">
</cfif>
<cfif url.name neq "">
and name like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.name)#%">
</cfif>
<cfif url.contact neq "">
and contact like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.contact)#%">
</cfif>
<cfif url.address neq "">
and concat(add1,' ',add2,' ',add3) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.address)#%">
</cfif>
order by driverno
</cfquery>

<table>
<tr>
<th width="100px">Member ID</th>
<th width="150px">Name</th>
<th width="100px">Tel</th>
<th width="300px">Address</th>
<th width="100px">Action</th>
</tr>
<cfloop query="getlist">
<tr>
<td>#getlist.driverno#</td>
<td>#getlist.name#</td>
<td>#getlist.contact#</td>
<td>
#getlist.add1# #getlist.add2# #getlist.add3#
</td>
<td align="right">
<cfif url.main eq "in"><a style="cursor:pointer" onclick="fillsearch('#URLENCODEDFORMAT(getlist.driverno)#','#URLENCODEDFORMAT(getlist.name)#','#URLENCODEDFORMAT(getlist.contact)#','#URLENCODEDFORMAT(getlist.add1)#','#URLENCODEDFORMAT(getlist.add2)#','#URLENCODEDFORMAT(getlist.add3)#');getmember();ColdFusion.Window.hide('searchmember');">Select</a>
<cfelse>
<a style="cursor:pointer" onclick="selectlist('#getlist.driverno#','driver');getmember();
ColdFusion.Window.hide('searchmember');">Select</a>
</cfif>
</td>
</tr>
</cfloop>
</table>
</cfoutput>