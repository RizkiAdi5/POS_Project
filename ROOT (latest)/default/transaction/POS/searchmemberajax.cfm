<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "2125, 23, 2129, 440, 2130, 6, 10, 11">
<cfinclude template="/latest/words.cfm">
<cfoutput>
<cfquery name="getlist" datasource="#dts#">
SELECT driverno,name,contact,add1,add2,add3,attn,customerno FROM driver 
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
<cfif url.attn neq "">
and attn like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.attn)#%">
</cfif>
<cfif url.custno neq "">
and customerno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.custno)#%">
</cfif>
<cfif url.address neq "">
and concat(add1,' ',add2,' ',add3) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDECODE(url.address)#%">
</cfif>
order by driverno
</cfquery>

<table>
<tr>
<th width="100px">#words[2125]#</th>
<th width="150px">#words[23]#</th>
<th width="100px">#words[2129]#</th>
<th width="100px">#words[2130]#</th>
<th width="100px">#words[440]#</th>
<th width="300px">#words[6]#</th>
<th width="100px">#words[10]#</th>
</tr>
<cfloop query="getlist">
<tr>
<td>#getlist.driverno#</td>
<td>#getlist.name#</td>
<td>#getlist.attn#</td>
<td>#getlist.customerno#</td>
<td>#getlist.contact#</td>
<td>
#getlist.add1# #getlist.add2# #getlist.add3#
</td>
<td align="right">
<cfif url.main eq "in"><a style="cursor:pointer" onclick="fillsearch('#URLENCODEDFORMAT(getlist.driverno)#','#URLENCODEDFORMAT(getlist.name)#','#URLENCODEDFORMAT(getlist.contact)#','#URLENCODEDFORMAT(getlist.add1)#','#URLENCODEDFORMAT(getlist.add2)#','#URLENCODEDFORMAT(getlist.add3)#');ColdFusion.Window.hide('searchmember');">#words[11]#</a>
<cfelse>
<a style="cursor:pointer" onclick="selectlist('#getlist.driverno#','driver');
ColdFusion.Window.hide('searchmember');">#words[11]#</a>
</cfif>
</td>
</tr>
</cfloop>
</table>
</cfoutput>