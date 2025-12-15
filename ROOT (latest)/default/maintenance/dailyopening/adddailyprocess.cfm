<cfset message=''>

<cfif form.submit eq 'create'>

<cfquery name="insert" datasource="#dts#">
INSERT INTO dailycounter
(
counterid,
openning,
wos_date,
created_on,
created_by,
type,desp
)
VALUES
(
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.counter#">,
<cfqueryparam cfsqltype="cf_sql_double" value="#numberformat(val(form.amount),'.__')#"> ,
"#dateformat(createdate(right(form.wos_date,4),mid(form.wos_date,4,2),left(form.wos_date,2)),'YYYY-MM-DD')#",
now(),
"#huserid#",
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.type#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">
)
</cfquery>
<cfset message='Add Daily Oppening Success!'>

<cfelseif form.submit eq 'edit'>

<cfquery name="checkexist" datasource="#dts#">
select * from dailycounter where id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.openingid#"> 
</cfquery>

<cfif checkexist.recordcount neq 0>

<cfquery name="update" datasource="#dts#">
update dailycounter set 
openning=<cfqueryparam cfsqltype="cf_sql_double" value="#numberformat(val(form.amount),'.__')#"> ,
updated_on=now(),
updated_by="#huserid#",
type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.type#">,
desp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">

where id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.openingid#"> 

</cfquery>

<cfset message='Edit Success!'>
<cfelse>
<cfset message='Data does not exist'>
</cfif>

<cfelseif form.submit eq 'delete'>

<cfquery name="insert" datasource="#dts#">
delete from dailycounter where id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.openingid#"> 
</cfquery>

<cfset message='Delete Success!'>
</cfif>

<cfoutput>
<script type="text/javascript">
alert('#message#');
window.location.href="/default/maintenance/dailyopening/s_dailycountertable.cfm?type=counter";
</script>
</cfoutput>