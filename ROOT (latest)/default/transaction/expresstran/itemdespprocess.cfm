<cfsetting showdebugoutput="no">


<cfoutput>
<cfquery name="updateitemdesp" datasource="#dts#">
update ictrantemp set 
desp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.desp#">,
despa=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.despa#">,
comment=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.comment#">
where trancode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.trancode#">  
and uuid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#"> 
</cfquery>

</cfoutput>