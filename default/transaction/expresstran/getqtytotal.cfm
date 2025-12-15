<cfsetting showdebugoutput="no">
<cfset uuid = url.uuid>
<cfoutput>
<cfquery name="getsumictrantemp" datasource="#dts#">
SELECT sum(qty_bil)as sumqty FROM ictrantemp WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#"> order by trancode desc
</cfquery>
#getsumictrantemp.sumqty#
</cfoutput>
