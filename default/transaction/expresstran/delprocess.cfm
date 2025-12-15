<cfoutput>
<cfquery name="updatemember" datasource="#dts#">
UPDATE Driver Set 
name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.membernamesearch#">,
contact = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.membertelsearch#">,
add1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.memberadd1search#">,
add2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.memberadd2search#">,
add3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.memberadd3search#">
WHERE driverno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.memberidsearch#">
</cfquery>
<script type="text/javascript">
document.getElementById('rem6').value='#form.deliverydate#';
document.getElementById('rem7').value='#form.deliverytime#';
selectmemberlist('#form.memberidsearch#');
ColdFusion.Window.hide('neweu');
</script>

</cfoutput>