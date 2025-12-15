<cfsilent>
<cfset value = "">
<cfset tabchr = Chr(13) & Chr(10)> 

<cfquery name="getinfo" datasource="#dts#">
	select #pincode#  as code 
	from userpin2 
	where level = '#groupid#'
</cfquery>

<cfif getinfo.recordcount neq 0>
	<cfif getinfo.code eq "T">
		<cfset nextcode = "F">
	<cfelse>
		<cfset nextcode = "T">
	</cfif>
	<cfquery name="update" datasource="#dts#">
		update userpin2 set #pincode# = '#nextcode#'
		where level = '#groupid#'
	</cfquery>
</cfif>

<cfset header = "count|alert|msg|codeid">
<cfset value = "1|0|0|#pincode##tabchr#">	
</cfsilent><cfoutput>#header##tabchr##value#</cfoutput>