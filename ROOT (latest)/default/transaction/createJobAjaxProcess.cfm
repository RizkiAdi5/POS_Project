<cfquery name="getgsetup" datasource="#dts#">
  select * from gsetup
</cfquery>

	<cfset newjobno = "#form.jobno#">
    <cfquery name="checkexist" datasource="#dts#">
    select * from project where source = '#form.jobno#'
    </cfquery>

    <cfif checkexist.recordcount eq 0>
    <cfquery name="insertjob" datasource="#dts#">
		insert into project
		(
        source,
        project,
        porj)
		values
		(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.jobno#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">,
        "J"
		)
	</cfquery>

     <cfoutput>
     <cfset msg="New #getgsetup.ljob# Created Successfully">
 <h2>#msg#</h2>
 <input type="button" onClick="window.opener.updatejob('#form.jobno#');window.close();" value="Close" >
 </cfoutput>
<cfelse>

     <cfoutput>
     <cfset msg="Duplicate #getgsetup.ljob# No. Please Use Another Job No.">
 <h2>#msg#</h2>
 <input type="button" onClick="window.close();" value="Close" >
 </cfoutput>
</cfif>