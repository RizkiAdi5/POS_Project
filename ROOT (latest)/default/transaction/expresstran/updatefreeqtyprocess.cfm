
<cfif val(form.freeqty1) neq 0>
<cfquery name="updatediscountamount" datasource="#dts#">
UPDATE ictrantemp SET 
rem11 = "#val(form.freeqty1)#",
promotion = ""
WHERE 
trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.trancode#">
and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#">
</cfquery>   
</cfif>

<script type="text/javascript">
refreshlist();
ColdFusion.Window.hide('updatefreeqty');
</script>
