<cfoutput>
<cfquery name="updatemember" datasource="#dts#">
UPDATE Driver Set 
name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.membernamesearch)#">,
contact = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.membertelsearch)#">,
add1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.memberadd1search)#">,
add2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.memberadd2search)#">,
add3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.memberadd3search)#">
WHERE driverno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.memberidsearch)#">
</cfquery>
</cfoutput>