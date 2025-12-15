<cfcomponent>
	<cffunction name="grosstotal" access="remote" returntype="string">
    	<cfargument name="dts" type="string" required="yes">
		<cfargument name="uuid" type="string">
        
        <cfquery name="sumgross" datasource="#dts#">
        SELECT sum(amt_bil) as sumamtbil FROM ictran_temp where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#" />
        </cfquery>
        
		<cfset myResult=sumgross.sumamtbil>
		<cfreturn myResult>
	</cffunction>
</cfcomponent>