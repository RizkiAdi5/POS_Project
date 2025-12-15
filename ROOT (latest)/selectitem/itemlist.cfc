<cfcomponent>
<cfsetting showdebugoutput="no">
<cffunction name="listitem" access="remote" returntype="struct">
	<cfset dts=form.dts>
	<cfset table=form.table>
	<cfset term=form.term>
	<cfset limit=form.limit>
	<cfset page=form.page>
	<cfset start=page*limit>
	<cfset matcheditemList=ArrayNew(1)>
	<cfquery name="listMatcheditem" datasource="#dts#">
    			Select servi as itemno , Servi as desp from icservi
                     WHERE 
                    Servi like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#term#%" />
                    or desp like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#term#%" />
                    union all
        			select itemno, desp from icitem
                    WHERE 
                    itemno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#term#%" />
                   or desp like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#term#%" />
                    order by itemno limit #start#,#limit#
	</cfquery>

	<cfloop query="listMatcheditem">
		<cfset matcheditem=StructNew()>
        <cfset matcheditem["id"]=listMatcheditem.itemno>
		<cfset matcheditem["itemno"]=listMatcheditem.itemno>
		<cfset matcheditem["desp"]=listMatcheditem.desp>
		<cfset ArrayAppend(matcheditemList,matcheditem)>
	</cfloop>
	<cfset output=StructNew()>
	<cfset output["total"]=listMatcheditem.recordcount>
	<cfset output["result"]=matcheditemList>
	<cfreturn output>
</cffunction>

<cffunction name="getSelecteditem" access="remote" returntype="struct">
	<cfset dts=form.dts>
	<cfset table=form.table>
	<cfset value=form.value>
	<cfquery name="getSelecteditem" datasource="#dts#">
		SELECT itemno, desp from icitem
		WHERE itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#value#" />
	</cfquery>
    
    <cfif getSelecteditem.recordcount eq 0>
    <cfquery name="getSelecteditem" datasource="#dts#">
		SELECT servi as itemno , Servi as desp from icservi
		WHERE servi=<cfqueryparam cfsqltype="cf_sql_varchar" value="#value#" />
	</cfquery>
	</cfif>
    
	<cfset selecteditem=StructNew()>
    <cfset selecteditem["id"]=getSelecteditem.itemno>
	<cfset selecteditem["itemno"]=getSelecteditem.itemno>
	<cfset selecteditem["desp"]=getSelecteditem.desp>
	<cfreturn selecteditem>
</cffunction>
</cfcomponent>