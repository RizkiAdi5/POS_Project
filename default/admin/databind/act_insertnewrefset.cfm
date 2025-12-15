<cfsilent>
<cfset value = "">
<cfset tabchr = Chr(13) & Chr(10)> 

<cfif action eq "add">
	<cfquery name="getmax" datasource="#dts#">
		select max(counter) as maxcount from refnoset
		where type = '#newrefsettype#'
	</cfquery>
	<cfset nextcounter = getmax.maxcount + 1>
	
	<cfquery name="insert" datasource="#dts#">
		insert into refnoset (type,refnocode,refnocode2,lastusedno,refnoused,presuffixuse,counter)
		values
		('#newrefsettype#','','','','0','0','#nextcounter#')
	</cfquery>
<cfelseif action eq "delete">
	<cfquery name="delete" datasource="#dts#">
		delete  from refnoset
		where type = '#type#'
		and counter = '#counter#'
	</cfquery>
</cfif>

<cfset header = "count|error|msg">
<cfset value = "1|0|0#tabchr#">	
</cfsilent><cfoutput>#header##tabchr##value#</cfoutput>