	<cfset newmakeno = "#form.makeno#">
    <cfquery name="checkexist" datasource="#dts#">
    select * from vehimake where make = '#form.makeno#'
    </cfquery>
    
    <cfif checkexist.recordcount eq 0>
    <cfquery name="insertrating" datasource="#dts#">
		insert into vehimake
		(
        make,
        desp)
		values
		( 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.makeno#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">
		)
	</cfquery>
    <cfset msg="New Make Created Successfully">
     <cfoutput>
 <h2>#msg#</h2>
 <input type="button" onClick="updatemake('#form.makeno#');ColdFusion.Window.hide('createmakeAjax');" value="Close" >
 </cfoutput>
<cfelse>
	<cfset msg="Duplicate Make No. Please Use Another Rating No.">
     <cfoutput>
 <h2>#msg#</h2>
 <input type="button" onClick="ColdFusion.Window.hide('createmakeAjax');" value="Close" >
 </cfoutput>
</cfif>