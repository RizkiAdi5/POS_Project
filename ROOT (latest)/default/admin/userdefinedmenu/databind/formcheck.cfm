<cfsilent>
<cfset value = "">
<cfset tabchr = Chr(13) & Chr(10)> 

<cfset error = 0>
<cfset msg = "">

<cfif action eq "add">
	<cfquery name="getinfo" datasource="#dts#">
		select * from userpin2 
		where level = '#groupname#'
	</cfquery>

	<cfif getinfo.recordcount neq 0>
		<cfset error = 1>
		<cfset msg = "The group name: " & "#groupname#" & " already exist!">
	</cfif>
	
<cfelseif action eq "delete">
	<cfif groupname eq "Standard">
		<cfset thisgroupid = "Suser">
	<cfelseif groupname eq "General">	
		<cfset thisgroupid = "guser">
	<cfelseif groupname eq "Limited">	
		<cfset thisgroupid = "luser">
	<cfelseif groupname eq "Mobile">	
		<cfset thisgroupid = "muser">
	<cfelseif groupname eq "Admin">	
		<cfset thisgroupid = "admin">
	<cfelse>	
		<cfset thisgroupid = "#groupname#">
	</cfif>
	
	<cfquery name="getinfo" datasource="main">
		select * from users
		where userGrpID = '#thisgroupid#'
		and userBranch = '#HcomID#'
		limit 1
	</cfquery>
	<cfif getinfo.recordcount neq 0>
		<cfset error = 1>
		<cfset msg = "Cannot Delete! This group : " & "#groupname#" & " is used!">
	</cfif>
</cfif>
<cfset header = "count|error|msg|action|groupname">
<cfset value = "1|#error#|#msg#|#action#|#groupname##tabchr#">	
</cfsilent><cfoutput>#header##tabchr##value#</cfoutput>