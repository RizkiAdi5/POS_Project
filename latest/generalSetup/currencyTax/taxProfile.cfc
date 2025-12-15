<cfcomponent>
<cffunction name="listAccount" access="remote" returntype="struct">
	<cfset dts=form.dts>
	<cfset targetTable=form.targetTable>
    <cfset tax_type=form.tax_type>
	
	<cfset criteria="">
	<cfif tax_type NEQ "">
		<cfset criteria=" (">
		<cfloop index="i" list="#tax_type#" delimiters=",">
				<cfset criteria=criteria&"tax_type="""&i&""" OR ">
		</cfloop>
		<cfset criteria=Left(criteria,Len(criteria)-4)>
		<cfset criteria=criteria&")">
	</cfif>
		
	<cfset sLimit="">
	<cfif IsDefined("form.iDisplayStart") AND form.iDisplayLength NEQ "-1">
		<cfset sLimit="LIMIT "&form.iDisplayStart&","&form.iDisplayLength>
	</cfif>		
	
	<cfset sOrder="">
	<cfif IsDefined("form.iSortCol_0")>
		<cfset sOrder="ORDER BY ">
		<cfloop from="0" to="#form.iSortingCols-1#" index="i" step="1">
			<cfif Evaluate('form.bSortable_'&Evaluate('form.iSortCol_'&i)) EQ "true">
				<cfset sOrder=sOrder&Evaluate('form.mDataProp_'&Evaluate('form.iSortCol_'&i))>
				<cfif Evaluate('form.sSortDir_'&i) EQ "asc">
					<cfset sOrder=sOrder&" ASC,">
				<cfelse>
					<cfset sOrder=sOrder&" DESC,">
				</cfif>
			</cfif>
		</cfloop>
		<cfset sOrder=Left(sOrder,Len(sOrder)-1)>
		<cfif sOrder EQ "ORDER BY">
			<cfset sOrder="">
		</cfif>		
	</cfif>

	<cfset sWhere="">
	<cfif IsDefined("form.sSearch") AND form.sSearch NEQ "">
		<cfset sWhere=" AND (">
		<cfloop from="0" to="#form.iColumns-1#" index="i" step="1">	
			<cfif Evaluate('form.bSearchable_'&i) EQ "true">
				<cfset sWhere=sWhere&Evaluate('form.mDataProp_'&i)&" LIKE ""%"&form.sSearch&"%"" OR ">
			</cfif>
		</cfloop>
		<cfset sWhere=Left(sWhere,Len(sWhere)-4)>
		<cfset sWhere=sWhere&")">
	</cfif>
	
	<cfquery name="getFilteredDataSet" datasource="#dts#">
		SELECT SQL_CALC_FOUND_ROWS entryno,code,desp,rate1,tax_type,corr_accno
		FROM #targetTable#
        WHERE
        #criteria#
		#sWhere#
		#sOrder#
		#sLimit#
	</cfquery>

	<cfquery name="getFilteredDataSetLength" datasource="#dts#">
		SELECT FOUND_ROWS() AS iFilteredTotal
	</cfquery>
	<cfquery name="getTotalDataSetLength" datasource="#dts#">
		SELECT COUNT(entryno) AS iTotal
		FROM #targetTable#
        WHERE
        #criteria#
	</cfquery>
    

		<cfset aaData=ArrayNew(1)>
		<cfloop query="getFilteredDataSet">	
			<cfset data=StructNew()>
            <cfset data["entryno"]=getFilteredDataSet.entryno>
			<cfset data["code"]=" "&getFilteredDataSet.code>
			<cfset data["desp"]=getFilteredDataSet.desp>  
            <cfset data["rate1"]=NumberFormat(val(getFilteredDataSet.rate1)*100,',.__')&" %">
            <cfset data["tax_type"]=getFilteredDataSet.tax_type>
            <cfset data["corr_accno"]=getFilteredDataSet.corr_accno>      
          
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