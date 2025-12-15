<cfquery name="getgsetup" datasource="#dts#">
select * from gsetup
</cfquery>


<cfquery name="update" datasource="#dts#">
update icitem set qtybf=0
</cfquery>

<cfquery name="resultSet" datasource="#dts#">
select * from locqdbf where location='QW'
</cfquery>

<cfloop query="resultSet">

<cfquery name="update" datasource="#dts#">
update icitem set qtybf='#resultSet.locqfield#' where itemno='#resultSet.itemno#'
</cfquery>

</cfloop>

<script type="text/javascript">
alert('Update Complete!');
window.location.href="/index.cfm";
</script>