<cfset newColour = "#form.colour#">
<cfquery name="checkexist" datasource="#dts#">
    select * from vehicolour where colour = '#form.colour#'
</cfquery>

<cfif checkexist.recordcount eq 0>
	<cfquery name="insertrating" datasource="#dts#">
		INSERT INTO vehicolour(colour,desp)
		VALUES( 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.colour#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">
		)
	</cfquery>
	<cfset msg="New Colour Created Successfully">
    <cfoutput>
        <h2>#msg#</h2>
        <input type="button" onClick="updateColour('#form.colour#');ColdFusion.Window.hide('createNewColour');" value="Close" >
    </cfoutput>
<cfelse>
	<cfset msg="Duplicate colour! Please input different colour.">
    <cfoutput>
        <h2>#msg#</h2>
        <input type="button" onClick="ColdFusion.Window.hide('createNewColour');" value="Close" >
    </cfoutput>
</cfif>
