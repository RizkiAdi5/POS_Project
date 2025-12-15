<cfsilent>
<cfset value = "">
<cfset tabchr = Chr(13) & Chr(10)> 

	<cfquery name="getfields" datasource="#dts#">
		select * from userpin
	</cfquery>

	<cfquery name="insert" datasource="#dts#">
		insert into userpin2 
		(level
		<cfloop query="getfields">
			<cfset fieldname = "H"&"#getfields.code#">,#fieldname#
		</cfloop>) 
		values
		('#newgroupname#'<cfloop query="getfields">,'T'</cfloop>)
	</cfquery>

<cfset header = "count|error|msg">
<cfset value = "1|0|0#tabchr#">	
</cfsilent><cfoutput>#header##tabchr##value#</cfoutput>