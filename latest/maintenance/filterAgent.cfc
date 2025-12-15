<cfcomponent>
<cffunction name="listAccount" access="remote" returntype="struct">
	<cfset dts=replace(form.dts,'_i','_a','all')>
	<cfset term=form.term>
	<cfset limit=form.limit>
	<cfset page=form.page>
	<cfset start=page*limit>
	<cfset matchedAccountList=ArrayNew(1)>
    
	<cfquery name="listMatchedAccount" datasource="#dts#">
		SELECT agent AS agent
		FROM #target_icagent#
		WHERE agent LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#term#%" />
		ORDER BY agent
		LIMIT #start#,#limit#
	</cfquery>
    
	<cfquery name="getMatchedAccountLength" datasource="#dts#">
		SELECT FOUND_ROWS() AS matchedAccountLength
	</cfquery>	
    
	<cfloop query="listMatchedAccount">
		<cfset matchedAccount=StructNew()>
		<cfset matchedAccount["agent"]=listMatchedAccount.agent>
		<cfset ArrayAppend(matchedAccountList,matchedAccount)>
	</cfloop>
	<cfset output=StructNew()>
	<cfset output["total"]=getMatchedAccountLength.matchedAccountLength>
	<cfset output["result"]=matchedAccountList>
	<cfreturn output>
</cffunction>

<cffunction name="getSelectedAccount" access="remote" returntype="struct">
	<cfset dts=replace(form.dts,'_i','_a','all')>
	<cfset value=form.value>
    
	<cfquery name="getSelectedAccount" datasource="#dts#">
		SELECT agent
		FROM #target_icagent#
		WHERE agent=<cfqueryparam cfsqltype="cf_sql_varchar" value="#value#" />
	</cfquery>
    
	<cfset selectedAccount=StructNew()>
	<cfset selectedAccount["agent"]=getSelectedAccount.agent>
	<cfreturn selectedAccount>
    
</cffunction>
</cfcomponent>