<cfcomponent>
<cffunction name="listAccount" access="remote" returntype="struct">
	<cfset dts=form.dts>

	<cfset sLimit="">
	<cfif IsDefined("form.iDisplayStart") AND form.iDisplayLength NEQ "-1">
		<cfset sLimit="LIMIT "&form.iDisplayStart&","&form.iDisplayLength>
	</cfif>

	<cfset sOrder="ORDER BY material_name ASC">
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
            <cfset sOrder="ORDER BY material_name ASC">
        </cfif>
    </cfif>

	<cfset rangeVal = IsDefined("form.range") ? form.range : "all">

	<cfquery name="getFilteredDataSet" datasource="#dts#">
		SELECT SQL_CALC_FOUND_ROWS
		       m.material_id AS material_id,
		       m.material_name AS material_name,
		       m.unit AS unit,
		       CONCAT(FORMAT(m.stock_qty, 3), ' ', m.unit) AS stock_qty,
		       CONCAT(FORMAT(COALESCE(SUM(l.qty_used), 0), 3), ' ', m.unit) AS total_used
		FROM   app_raw_materials m
		LEFT JOIN app_material_usage_log l
		       ON l.material_id = m.material_id
		       <cfif rangeVal EQ "today">
		           AND l.used_at >= CURDATE()
		       <cfelseif rangeVal EQ "week">
		           AND l.used_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
		       <cfelseif rangeVal EQ "month">
		           AND l.used_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
		       </cfif>
		WHERE  m.is_active = 1
		<cfif IsDefined("form.sSearch") AND form.sSearch NEQ "">
            AND m.material_name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(form.sSearch)#%">
        </cfif>
		GROUP BY m.material_id, m.material_name, m.unit, m.stock_qty
		#sOrder#
		#sLimit#
	</cfquery>
	<cfquery name="getFilteredDataSetLength" datasource="#dts#">
		SELECT FOUND_ROWS() AS iFilteredTotal
	</cfquery>
	<cfquery name="getTotalDataSetLength" datasource="#dts#">
		SELECT COUNT(*) AS iTotal FROM app_raw_materials WHERE is_active = 1
	</cfquery>

	<cfset aaData=ArrayNew(1)>
	<cfloop query="getFilteredDataSet">
		<cfset data=StructNew()>
		<cfset data["material_name"]=material_name>
		<cfset data["total_used"]=total_used>
		<cfset data["stock_qty"]=stock_qty>
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
