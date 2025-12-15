
<cfif isdefined('url.uuid') and isdefined('url.trancode')>
<cfset url.uuid = URLDECODE(url.uuid)>
<cfquery name="updaterow" datasource="#dts#">
DELETE FROM ictrantemp 
WHERE 
trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.trancode#">
and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#">
</cfquery>

<cfquery name="checkitemExist" datasource="#dts#">
select 
itemcount 
from ictrantemp 
where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#">
</cfquery>
<cfif checkitemExist.recordcount gt 0>
<cfset itemcountlist = valuelist(checkitemExist.itemcount)>

<cfloop index="i" from="1" to="#listlen(itemcountlist)#">
<cfif listgetat(itemcountlist,i) neq i>
<cfquery name="updateIctran" datasource="#dts#">
	update ictrantemp set 
	itemcount='#i#',
	trancode='#i#'
	where 
	uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#">
	and itemcount='#listgetat(itemcountlist,i)#';
</cfquery>
</cfif>
</cfloop>
</cfif>


<cfquery name="getsum" datasource="#dts#">
SELECT SUM(amt1_bil) as sumsubtotal,count(trancode) as notran FROM ictrantemp where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#" />
</cfquery>

<cfoutput>
<input type="hidden" name="hidsubtotal" id="hidsubtotal" value="#numberformat(getsum.sumsubtotal,'.__')#" />
<input type="hidden" name="hiditemcount" id="hiditemcount" value="#getsum.notran#" />
</cfoutput>


</cfif>