<cfsetting showdebugoutput="no">
<cfif isdefined('url.reserveno') and isdefined('url.trancode')>
<cfset url.reserveno = URLDECODE(url.reserveno)>
<cfquery name="updaterow" datasource="#dts#">
DELETE FROM reservedet 
WHERE 
trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.trancode#">
and reserveno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.reserveno#">
</cfquery>

<cfquery name="checkitemExist" datasource="#dts#">
select 
trancode 
from reservedet 
where reserveno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.reserveno#">
</cfquery>

<cfif checkitemExist.recordcount gt 0>
<cfset itemcountlist = valuelist(checkitemExist.trancode)>

<cfloop index="i" from="1" to="#listlen(itemcountlist)#">
<cfif listgetat(itemcountlist,i) neq i>
<cfquery name="updateIctran" datasource="#dts#">
	update reservedet set 
	trancode='#i#'
	where 
	reserveno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.reserveno#">
	and trancode='#listgetat(itemcountlist,i)#';
</cfquery>
</cfif>
</cfloop>
</cfif>


<cfquery name="getsum" datasource="#dts#">
SELECT SUM(amt_bil) as sumsubtotal,count(trancode) as notran FROM reservedet where reserveno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.reserveno#" />
</cfquery>

<cfquery name="addreserve" datasource="#dts#">
update Reserve set grossamt="#numberformat(val(getsum.sumsubtotal),'.__')#" where reserveno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#reserveno#" />
</cfquery>

<cfoutput>
<input type="hidden" name="hidsubtotal" id="hidsubtotal" value="#numberformat(getsum.sumsubtotal,'.__')#" />
<input type="hidden" name="hiditemcount" id="hiditemcount" value="#getsum.notran#" />
</cfoutput>


</cfif>