<cfcomponent>
<cffunction name="listAccount" access="remote" returntype="struct">
	<cfset dts=form.dts>

	<cfset sLimit="">
	<cfif IsDefined("form.iDisplayStart") AND form.iDisplayLength NEQ "-1">
		<cfset sLimit="LIMIT "&form.iDisplayStart&","&form.iDisplayLength>
	</cfif>

	<cfset sOrder="ORDER BY used_at DESC">
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
            <cfset sOrder="ORDER BY used_at DESC">
        </cfif>
    </cfif>

	<cfquery name="getFilteredDataSet" datasource="#dts#">
		SELECT SQL_CALC_FOUND_ROWS
		       l.usage_id AS usage_id,
		       DATE_FORMAT(l.used_at, '%d-%m-%Y %H:%i') AS used_at,
		       COALESCE(o.order_number, CONCAT('##', l.order_id)) AS order_number,
		       COALESCE(oi.item_name, '') AS item_name,
		       m.material_name AS material_name,
		       CONCAT(FORMAT(l.qty_used, 3), ' ', m.unit) AS qty_used
		FROM   app_material_usage_log l
		JOIN   app_raw_materials m ON m.material_id = l.material_id
		LEFT JOIN app_order_items oi ON oi.item_id = l.item_id
		LEFT JOIN app_orders o ON o.order_id = l.order_id
		<cfif IsDefined("form.sSearch") AND form.sSearch NEQ "">
            WHERE (
                COALESCE(o.order_number,'') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(form.sSearch)#%">
                OR COALESCE(oi.item_name,'') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(form.sSearch)#%">
                OR m.material_name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(form.sSearch)#%">
            )
        </cfif>
		#sOrder#
		#sLimit#
	</cfquery>
	<cfquery name="getFilteredDataSetLength" datasource="#dts#">
		SELECT FOUND_ROWS() AS iFilteredTotal
	</cfquery>
	<cfquery name="getTotalDataSetLength" datasource="#dts#">
		SELECT COUNT(*) AS iTotal FROM app_material_usage_log
	</cfquery>

	<cfset aaData=ArrayNew(1)>
	<cfloop query="getFilteredDataSet">
		<cfset data=StructNew()>
		<cfset data["used_at"]=used_at>
		<cfset data["order_number"]=order_number>
		<cfset data["item_name"]=item_name>
		<cfset data["material_name"]=material_name>
		<cfset data["qty_used"]=qty_used>
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
