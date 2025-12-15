<cfcomponent>
	<cffunction name="commcal" access="public" returntype="string">
		<cfargument name="dts" type="string" required="yes">
        <cfargument name="itemno" type="string" required="yes">
		<cfargument name="salesamt" type="string" default="0">
        <cfargument name="agentid" type="string" default="0">
        
        <cfquery name="getitem" datasource="#dts#">
        SELECT commlvl,wos_group,category,brand FROM icitem WHERE 
        itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#">
        </cfquery>
        <cfset commrate = 0>
        <cfset gotcomm = 0>
        
        <cfif getitem.category neq "">
        <cfquery name="getcommlist" datasource="#dts#">
        SELECT rate,type FROM commrate WHERE
        rangefrom <= <cfqueryparam cfsqltype="cf_sql_float" value="#salesamt#">
        and rangeto >= <cfqueryparam cfsqltype="cf_sql_float" value="#salesamt#">
        and type = "D" and typeid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getitem.category#">
        ORDER BY Type
        </cfquery>
        <cfif getcommlist.recordcount neq 0>
        <cfset commrate = getcommlist.rate>
        <cfset gotcomm = 1>
		</cfif>
        </cfif>
        
        <cfif getitem.wos_group neq "">
        <cfquery name="getcommlist" datasource="#dts#">
        SELECT rate,type FROM commrate WHERE
        rangefrom <= <cfqueryparam cfsqltype="cf_sql_float" value="#salesamt#">
        and rangeto >= <cfqueryparam cfsqltype="cf_sql_float" value="#salesamt#">
        and type = "C" and typeid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getitem.wos_group#">
        ORDER BY Type
        </cfquery>
        <cfif getcommlist.recordcount neq 0>
        <cfset commrate = getcommlist.rate>
        <cfset gotcomm = 1>
		</cfif>
        </cfif>
        
        <cfif getitem.brand neq "">
        <cfquery name="getcommlist" datasource="#dts#">
        SELECT rate,type FROM commrate WHERE
        rangefrom <= <cfqueryparam cfsqltype="cf_sql_float" value="#salesamt#">
        and rangeto >= <cfqueryparam cfsqltype="cf_sql_float" value="#salesamt#">
        and type = "B" and typeid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getitem.brand#">
        ORDER BY Type
        </cfquery>
        <cfif getcommlist.recordcount neq 0>
        <cfset commrate = getcommlist.rate>
        <cfset gotcomm = 1>
		</cfif>
        </cfif>
        
        <cfif getitem.commlvl neq "">
        <cfquery name="getcommlist" datasource="#dts#">
        SELECT rate,type FROM commrate WHERE
        rangefrom <= <cfqueryparam cfsqltype="cf_sql_float" value="#salesamt#">
        and rangeto >= <cfqueryparam cfsqltype="cf_sql_float" value="#salesamt#">
        and type = "A" and commname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getitem.commlvl#">
        ORDER BY Type
        </cfquery>
        <cfif getcommlist.recordcount neq 0>
        <cfset commrate = getcommlist.rate>
        <cfset gotcomm = 1>
		</cfif>
        </cfif>
        
        <cfset salescomm = 0>
        <cfset ratecomm = 0>
        <cfif gotcomm neq "0">
        <cfset salescomm = salesamt * val(commrate) / 100>
        <cfset ratecomm = commrate>
		<cfelse>
        <cfquery name="getagentcomm" datasource="#dts#">
        SELECT commsion1 FROM icagent WHERE agent = <cfqueryparam cfsqltype="cf_sql_varchar" value="#agentid#">
        </cfquery>
        
        <cfif getagentcomm.recordcount neq 0>
        <cfset salescomm = salesamt * val(getagentcomm.commsion1) / 100>
		</cfif>
        <cfset ratecomm = val(getagentcomm.commsion1)>
        </cfif>
        <cfset finalcomm = ratecomm&","&salescomm>
		<cfreturn finalcomm>
	</cffunction>
</cfcomponent>