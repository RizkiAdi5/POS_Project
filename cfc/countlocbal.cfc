<cfcomponent>
	<cffunction name="countlocbal" returntype="string">
		<cfargument name="dts" type="string" required="yes">
        <cfargument name="refno" type="string" required="yes">
        <cfargument name="type" type="string" required="yes">
        <cfif type eq "TR" or type eq "ISS" or type eq "RC" or type eq "PR" or type eq "DO" or type eq "INV" or type eq "CS" or type eq "CN" or type eq "DN" or type eq "OAI" or type eq "OAR">
        <cfquery name="inserttrans" datasource="#dts#">
        INSERT INTO locationbalpro (refno,type) VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">)
        </cfquery>
        </cfif>
		<cfset myResult="foo">
		<cfreturn myResult>
	</cffunction>
</cfcomponent>