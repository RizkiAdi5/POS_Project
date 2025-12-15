<cfoutput>
	<cfinvoke component="cfc.create_update_delete_customer_supplier" method="amend_customer_supplier" returnvariable="status1">
		<cfinvokeargument name="dts" value="#dts#">
		<cfinvokeargument name="dts1" value="#dts#">
		<cfinvokeargument name="hlinkams" value="#hlinkams#">
		<cfinvokeargument name="huserid" value="#huserid#">
		<cfinvokeargument name="form" value="#form#">
	</cfinvoke>

<cfif isdefined('form.nexcustno')>
    <cfif form.nexcustno eq 1>
    <cfset lastusedno = right(form.custno,3) >
	<cfelse>
    <cfset lastusedno = form.custno >
	</cfif>
    <cfquery name="updatelastusedno" datasource="#dts#">
    Update refnoset SET lastUsedNo = "#lastusedno#" WHERE type = "SUPP"
    </cfquery>
	</cfif>
    
    <cfquery name="updateremark4" datasource="#dts#">
 UPDATE #target_apvend#
 SET
 SALEC  = '#form.SALEC#',
 SALECNC  = '#form.SALECNC#'
 WHERE
 custno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.custno#">
</cfquery>
    	
	<form name="done" action="vPersonnel.cfm?type=Supplier&process=done" method="post">
		<input name="status" value="#status1#" type="hidden">
	</form>
</cfoutput>

<script>
	done.submit();
</script>