<cfsilent>
<cfset value = "">
<cfset tabchr = Chr(13) & Chr(10)> 

<cfset oldpwd = hash(oldpwd)>
<cfquery name="checkpwd" datasource="main">
	select * from users
	where userID = <cfqueryparam cfsqltype="cf_sql_char" value="#userid#">
	and userPwd=<cfqueryparam cfsqltype="cf_sql_char" value="#oldpwd#">
</cfquery>

<cfset error =0>
<cfset msg = "">

<cfif checkpwd.recordcount eq 0>
	<cfset error = 1>
	<cfset msg = "You Old Password Not Tally! Please Key In Again!">
</cfif>

<cfset header = "count|error|msg">
<cfset value = "1|#error#|#msg##tabchr#">	
</cfsilent><cfoutput>#header##tabchr##value#</cfoutput>