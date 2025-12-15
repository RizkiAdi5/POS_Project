<cfcomponent>
	<cffunction name="addspace" access="public" returntype="string">
		<cfargument name="inputdata" type="string" required="yes">
        <cfargument name="fieldsize" type="numeric" required="yes">
        <cfset inputdatalen = len(inputdata)>
        <cfset additional_space = fieldsize - inputdatalen >
    	<cfset spaces = "">
        <cfif additional_space neq 0>
        <cfloop from="1" to="#additional_space#" index="i">
        <cfset spaces = spaces&" " >
        </cfloop>
        </cfif>
		<cfset myResult="#inputdata#"&"#spaces#">
		<cfreturn myResult>
	</cffunction>
    
    <cffunction name="addspace1" access="public" returntype="string">
		<cfargument name="inputdata" type="string" required="yes">
        <cfargument name="fieldsize" type="numeric" required="yes">
        <cfset inputdatalen = len(inputdata)>
        <cfset additional_space = fieldsize - inputdatalen >
    	<cfset spaces = "">
        <cfif additional_space neq 0>
        <cfloop from="1" to="#additional_space#" index="i">
        <cfset spaces = spaces&" " >
        </cfloop>
        </cfif>
		<cfset myResult="#spaces#"&"#inputdata#">
		<cfreturn myResult>
	</cffunction>
    
</cfcomponent>