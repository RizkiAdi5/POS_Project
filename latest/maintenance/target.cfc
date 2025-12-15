<cfcomponent>
<cffunction name="checkCustNoExist" access="remote" returntype="struct">
	<cfset dts=form.dts>
	<cfset targetTable=form.targetTable>
	<cfset custno=form.custno>
	<cfquery name="checkCustNoExist" datasource="#dts#">
		SELECT COUNT(custno) AS recordTotal
		FROM #targetTable#
		WHERE custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#custno#">
	</cfquery>
	<cfset output=StructNew()>
	<cfset output["recordTotal"]=checkCustNoExist.recordTotal>
	<cfreturn output>
</cffunction>
<cffunction name="checkNameExist" access="remote" returntype="struct">
	<cfset dts=form.dts>
	<cfset targetTable=form.targetTable>
	<cfset name=form.name>
	<cfset name2=form.name2>
	<cfquery name="checkNameExist" datasource="#dts#">
		SELECT COUNT(custno) AS recordTotal
		FROM #targetTable#
		WHERE name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">
		AND name2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#name2#">
	</cfquery>
	<cfset output=StructNew()>
	<cfset output["recordTotal"]=checkNameExist.recordTotal>
	<cfreturn output>
</cffunction>
</cfcomponent>