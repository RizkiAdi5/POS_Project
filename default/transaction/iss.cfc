<cfcomponent>
	<cffunction name="loclist" access="remote" returntype="query">
    	<cfargument name="dts" type="string" required="yes">
        <cfargument name="target_arcust" type="string">
        <cfargument name="filterdesp" type="string" required="no">
        <cfargument name="selecteddesp" type="string" required="no">
        <cfset defloc = "">
        <cfset defdesp = "Choose a location">
        <cfif selecteddesp neq "">
            <cfquery name="getdesp" datasource="#dts#">
            SELECT location,concat(location," - ",desp," - ",custno) as locdesp
            from iclocation WHERE location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#selecteddesp#">
            </cfquery>
            <cfif getdesp.recordcount neq 0>
            <cfset defloc = getdesp.location>
            <cfset defdesp = getdesp.locdesp>
            </cfif>
		</cfif>
        
        <cfquery name="getloc" datasource="#dts#">
        <cfif filterdesp eq "">
        select "#defloc#" as loc,"#defdesp#" as locdesp
        union all
        </cfif>
        select a.location as loc, concat(a.location," - ",a.desp," - ",a.custno) as locdesp
        FROM
        (
        select location,desp,custno,(select name from #target_arcust# where custno=iclocation.custno) as name from iclocation
        WHERE 1=1		
		<cfif defloc neq "">
        and location <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#defloc#">
		</cfif>
		<cfif filterdesp neq "">
        and desp like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#filterdesp#%">
		</cfif>
         order by location) as a
        </cfquery>
        
		<cfreturn getloc>
	</cffunction>
</cfcomponent>