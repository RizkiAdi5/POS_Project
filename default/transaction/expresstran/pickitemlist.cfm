<cfsetting showdebugoutput="no">  
<cfif url.action eq "add">
     <cfquery name="getitemdetail" datasource="#dts#">
    SELECT desp FROM icitem WHERE itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.itemno)#">
    </cfquery>
    
    <cfif getitemdetail.recordcount eq 0>
    <cfquery name="getitemdetail" datasource="#dts#">
    SELECT desp FROM icservi WHERE servi = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.itemno)#">
    </cfquery>
	</cfif>
    
    <cfif getitemdetail.recordcount neq 0>
    <cfset desp = getitemdetail.desp>
    <cfif len(desp) gt 10>
    <cfset desp = left(desp,10)&"...">
	</cfif>
    <cfquery name="inserttempitem" datasource="#dts#">
    INSERT INTO expresspickitem (itemno,desp,created_on,uuid)
    VALUES
    (
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.itemno)#">,
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#desp#">,
    now(),
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.uuid)#">
    )
    </cfquery>
    </cfif>
    
<cfelseif url.action eq "delete">

<cfif isdefined('url.id')>
<cfquery name="delete" datasource="#dts#">
DELETE FROM expresspickitem WHERE id = "#url.id#"
</cfquery>

<cfelse>

<cfquery name="delete" datasource="#dts#">
DELETE FROM expresspickitem WHERE itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.itemno)#"> and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.uuid)#">
</cfquery>

</cfif>

</cfif>

<cfquery name="getlist" datasource="#dts#">
SELECT * FROM expresspickitem WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.uuid)#"> ORDER BY CREATED_ON DESC
</cfquery>
<cfoutput>
<table width="250">
<tr>
<th>ITEM NO</th>
<th>DESP</th>
<th>DELETE</th>
</tr>
<cfloop query="getlist">
<tr>
<td>#getlist.itemno#</td>
<td>#getlist.desp#</td>
<th><input type="button" name="pickitemdel" id="pickitemdel" value="DEL" size="4" onClick="if(confirm('Are You Sure You Want To Remove This Item From Pick List?')){ajaxFunction(document.getElementById('pickitemlist'),'pickitemlist.cfm?action=delete&uuid=#url.uuid#&id=#getlist.id#')}"></th>
</tr>
</cfloop>
</table>
</cfoutput>