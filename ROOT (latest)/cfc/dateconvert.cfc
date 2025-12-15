<cfcomponent>
	<cffunction name="ndate" access="public" returntype="string">
		<cfargument name="olddate" type="string" required="yes">
        <cfif olddate neq "">
		<cfset validdate = createdate(right(olddate,4),mid(olddate,4,2),left(olddate,2))>
        <cfset validdate = dateformat(validdate,'YYYY-MM-DD')>
        <cfelse>
        <cfset validdate = "0000-00-00">
        </cfif>
		<cfreturn validdate>
	</cffunction>
</cfcomponent>