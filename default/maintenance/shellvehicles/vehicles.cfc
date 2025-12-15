<cfcomponent output="false">
    
    <!--- Lookup used for auto suggest --->
	<cffunction name="findcustomer" access="remote" returntype="string">
		<cfargument name="search" type="any" required="false" default="">
		<cfargument name="dns" type="any" required="false" default="">
        <cfargument name="Hlinkams" type="any" required="false" default="">
		<!--- Define variables --->
		<cfset var local = {} />
        <cfquery name="local.query" datasource="#dns#" >
        			select custno as a from <cfif Hlinkams eq 'Y'>#replace(dns,'_i','_a')#<cfelse>#dns#</cfif>.arcust
                    WHERE 
                    custno like <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.search#%" />
                    order by custno desc limit 10
                </cfquery>

<cfreturn valueList(local.query.a)>
	</cffunction>


	
</cfcomponent>