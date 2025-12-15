<cfcomponent>
	<cffunction name="getpass" access="remote" returntype="string">
		<cfargument name="dts" type="string" required="yes">
        <cfargument name="cashierlist" type="string" required="no">
        
        <cfquery name="getwsqdts" datasource="#dts#">
        SELECT password from cashier where cashierid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cashierlist#" >
        </cfquery>
		<cfset myResult=getwsqdts.wsq>
		<cfreturn myResult>
	</cffunction>
    
</cfcomponent>