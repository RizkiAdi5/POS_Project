<cfcomponent>
<cffunction name="listAccount" access="remote" returntype="struct">
	<cfset dts=form.dts>

	<cfset sLimit="">
	<cfif IsDefined("form.iDisplayStart") AND form.iDisplayLength NEQ "-1">
		<cfset sLimit="LIMIT "&form.iDisplayStart&","&form.iDisplayLength>
	</cfif>

	<cfset sOrder="ORDER BY item_name ASC">
	<cfif IsDefined("form.iSortCol_0")>
        <cfset sOrder="ORDER BY `">
        <cfloop from="0" to="#form.iSortingCols-1#" index="i" step="1">
            <cfif Evaluate('form.bSortable_'&Evaluate('form.iSortCol_'&i)) EQ "true">
                <cfset sOrder=sOrder&Evaluate('form.mDataProp_'&Evaluate('form.iSortCol_'&i))>
				<cfif Evaluate('form.sSortDir_'&i) EQ "asc">
                    <cfset sOrder=sOrder&"` ASC,`">
                <cfelse>
                    <cfset sOrder=sOrder&"` DESC,`">
                </cfif>
            </cfif>
        </cfloop>
        <cfset sOrder=Left(sOrder,Len(sOrder)-2)>
        <cfif sOrder EQ "ORDER BY `">
            <cfset sOrder="ORDER BY item_name ASC">
        </cfif>
    </cfif>

	<cfquery name="getFilteredDataSet" datasource="#dts#">
		SELECT SQL_CALC_FOUND_ROWS i.ITEMNO AS item_code, i.DESP AS item_name,
		       COALESCE(r.cnt,0) AS recipe_count
		FROM icitem i
		LEFT JOIN (SELECT item_code, COUNT(*) AS cnt FROM app_menu_recipes GROUP BY item_code) r
		  ON r.item_code = i.ITEMNO
		<cfif IsDefined("form.sSearch") AND form.sSearch NEQ "">
            WHERE (
                i.ITEMNO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(form.sSearch)#%">
                OR i.DESP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(form.sSearch)#%">
            )
        </cfif>
		#sOrder#
		#sLimit#
	</cfquery>
	<cfquery name="getFilteredDataSetLength" datasource="#dts#">
		SELECT FOUND_ROWS() AS iFilteredTotal
	</cfquery>
	<cfquery name="getTotalDataSetLength" datasource="#dts#">
		SELECT COUNT(*) AS iTotal FROM icitem
	</cfquery>

	<cfset aaData=ArrayNew(1)>
	<cfloop query="getFilteredDataSet">
		<cfset data=StructNew()>
		<cfset data["item_code"]=trim(item_code)>
		<cfset data["item_name"]=item_name>
		<cfset data["recipe_count"]=recipe_count>
		<cfset ArrayAppend(aaData,data)>
	</cfloop>
	<cfset output=StructNew()>
	<cfset output["sEcho"]=form.sEcho>
	<cfset output["iTotalRecords"]=getTotalDataSetLength.iTotal>
	<cfset output["iTotalDisplayRecords"]=getFilteredDataSetLength.iFilteredTotal>
	<cfset output["aaData"]=aaData>
	<cfreturn output>
</cffunction>
</cfcomponent>
