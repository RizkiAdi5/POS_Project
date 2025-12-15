<cfsilent>
<cfset value = "">
<cfset tabchr = Chr(13) & Chr(10)> 

<cfif input_type eq "chkbox">
	<cfquery name="getinfo" datasource="#dts#">
		select #fieldname#  as code
		from refnoset 
		where type = '#type#'
		and counter = '#counter#'
	</cfquery>

	<cfif getinfo.recordcount neq 0>
		<cfif getinfo.code eq "1">
			<cfset nextcode = "0">
		<cfelse>
			<cfset nextcode = "1">
		</cfif>
		<cfquery name="update" datasource="#dts#">
			update refnoset set #fieldname# = '#nextcode#'
			where type = '#type#'
			and counter = '#counter#'
		</cfquery>
	</cfif>
<cfelse>
	<cfquery name="update" datasource="#dts#">
		update refnoset 
		set #fieldname# = UPPER('#fieldvalue#')
		where type = '#type#'
		and counter = '#counter#'
	</cfquery>
</cfif>

<cfset header = "count|alert|msg|type|counter|fieldname">
<cfset value = "1|0|0|#type#|#counter#|#fieldname##tabchr#">	
</cfsilent><cfoutput>#header##tabchr##value#</cfoutput>