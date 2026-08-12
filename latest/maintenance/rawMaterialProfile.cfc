<cfcomponent>
<cffunction name="listAccount" access="remote" returntype="struct">
	<cfset dts=form.dts>
	<cfset targetTable=form.targetTable>

	<cfset sLimit="">
	<cfif IsDefined("form.iDisplayStart") AND form.iDisplayLength NEQ "-1">
		<cfset sLimit="LIMIT "&form.iDisplayStart&","&form.iDisplayLength>
	</cfif>

	<cfset sOrder="">
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
            <cfset sOrder="">
        </cfif>
    </cfif>

	<cfquery name="getFilteredDataSet" datasource="#dts#">
		SELECT SQL_CALC_FOUND_ROWS material_id,material_name,unit,stock_qty,reorder_level,is_active
		FROM #targetTable#
		<cfif IsDefined("form.sSearch") AND form.sSearch NEQ "">
            WHERE (
            <cfloop from="0" to="#form.iColumns-1#" index="i" step="1">
                <cfif Evaluate('form.bSearchable_'&i) EQ "true">
                    `#Evaluate('form.mDataProp_#i#')#` LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(form.sSearch)#%">
                </cfif>
                <cfif i neq form.iColumns-1>
                    OR
                </cfif>
                <cfif i eq form.iColumns-1>
                    )
                </cfif>
            </cfloop>
        </cfif>
		#sOrder#
		#sLimit#
	</cfquery>
	<cfquery name="getFilteredDataSetLength" datasource="#dts#">
		SELECT FOUND_ROWS() AS iFilteredTotal
	</cfquery>
	<cfquery name="getTotalDataSetLength" datasource="#dts#">
		SELECT COUNT(material_id) AS iTotal
		FROM #targetTable#
	</cfquery>

	<cfset aaData=ArrayNew(1)>
	<cfloop query="getFilteredDataSet">
		<cfset data=StructNew()>
		<cfset data["material_id"]=material_id>
		<cfset data["material_name"]=material_name>
		<cfset data["unit"]=unit>
		<cfset data["stock_qty"]=NumberFormat(stock_qty,"0.000")>
		<cfset data["reorder_level"]=len(trim(reorder_level)) ? NumberFormat(reorder_level,"0.000") : "">
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
