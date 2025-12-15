<cfcomponent output="false">

	<!--- Lookup used for auto suggest --->
	<cffunction name="findItem" access="remote" returntype="string">
		<cfargument name="search" type="any" required="false" default="">
		<cfargument name="dns" type="any" required="false" default="">
        <cfargument name="hcomid" type="any" required="false" default="">
        <cfargument name="Huserloc" type="any" required="false" default="">
        
		<!--- Define variables --->
		<cfset var local = {} />
        <cfquery name="local.query" datasource="#dns#" >
        			Select concat(Servi,'___',desp) as a from icservi
                     WHERE 
                    Servi like <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.search#%" />
                    union all
        			select concat(itemno,'___',desp) as a from icitem
                    WHERE 
                    itemno like <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.search#%" />
                    <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "kjctrial_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i">
                    <cfif Huserloc neq "All_loc">
                    and itemno in (select itemno from locqdbf where location='#Huserloc#')
                    </cfif>
                    </cfif>
                    order by a desc limit 10
                </cfquery>

<cfreturn valueList(local.query.a)>
	</cffunction>
    
   

</cfcomponent>