<cfsilent>
<cfset value = "">
<cfset tabchr = Chr(13) & Chr(10)> 

	<cfquery name="delete" datasource="#dts#">
		delete from userpin2 
		where level = '#groupname#'
	</cfquery>

<cfset header = "count|error|msg">
<cfset value = "1|0|0#tabchr#">	
</cfsilent><cfoutput>#header##tabchr##value#</cfoutput>