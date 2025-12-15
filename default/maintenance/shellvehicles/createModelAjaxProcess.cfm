	<cfset newmodelno = "#form.modelno#">
    <cfquery name="checkexist" datasource="#dts#">
    select * from vehimodel where model = '#form.modelno#'
    </cfquery>
    
    <cfif checkexist.recordcount eq 0>
    <cfquery name="insertrating" datasource="#dts#">
		insert into vehimodel
		(
        model,
        desp)
		values
		( 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.modelno#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">
		)
	</cfquery>
    <cfset msg="New Model Created Successfully">
     <cfoutput>
 <h2>#msg#</h2>
 <input type="button" onClick="updatemodel('#form.modelno#');ColdFusion.Window.hide('createmodelAjax');" value="Close" >
 </cfoutput>
<cfelse>
	<cfset msg="Duplicate Model No. Please Use Another Rating No.">
     <cfoutput>
 <h2>#msg#</h2>
 <input type="button" onClick="ColdFusion.Window.hide('createmodelAjax');" value="Close" >
 </cfoutput>
</cfif>