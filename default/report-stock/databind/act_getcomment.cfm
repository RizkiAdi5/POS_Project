<cfsetting showdebugoutput="false"><cfsilent>
<cfset value = "">
<cfset tabchr = Chr(13) & Chr(10)> 

<cfif commentcode neq "">
	 <cfquery datasource='#dts#' name="getcomment">
		select * from comments 
		where code =  '#commentcode#'
	</cfquery>
	<cfif getcomment.recordcount neq 0>
		<cfset commentdetails = getcomment.details>
	<cfelse>
		<cfset commentdetails = "">
	</cfif>
<cfelse>
	<cfset commentdetails = "">
</cfif>

<cfset header = "count|error|msg|commentdetails">
<cfset value = "1|0|0|#URLEncodedFormat(tostring(commentdetails))##tabchr#">	
</cfsilent><cfoutput>#header##tabchr##value#</cfoutput>