<cfcomponent>
<cffunction name="listAccount" access="remote" returntype="struct">
	<cfset dts=form.dts>
    <cfset husergrpid=form.userGroup>
    <cfset huserid=form.userID>
	<cfset hcomid=form.targetTable>
		
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

	<!---<cfset sWhere="">
	<cfif IsDefined("form.sSearch") AND form.sSearch NEQ "">
		<cfset sWhere=" AND (">
		<cfloop from="0" to="#form.iColumns-1#" index="i" step="1">	
			<cfif Evaluate('form.bSearchable_'&i) EQ "true">
				<cfset sWhere=sWhere&Evaluate('form.mDataProp_'&i)&" LIKE ""%"&trim(form.sSearch)&"%"" OR ">
			</cfif>
		</cfloop>
		<cfset sWhere=Left(sWhere,Len(sWhere)-4)>
		<cfset sWhere=sWhere&")">    
	</cfif>--->
    
	<cfquery name="getMultiCompany" datasource='main'>
		SELECT * 
        FROM multicomusers 
        WHERE userid='#huserid#'; 
	</cfquery>
	
    <cfset multiCompanyList = valuelist(getMultiCompany.comlist)>
	
	<cfquery name="getFilteredDataSet" datasource="main">  	
    	<cfif husergrpid eq "super">
            SELECT a.userbranch,b.compro,b.period,b.lastaccyear,b.remark 
            FROM users AS a 
            LEFT JOIN ( SELECT compro,period,lastaccyear,companyid,remark 
						FROM useraccountlimit) AS b ON b.companyid=a.userbranch
            WHERE a.userDept NOT IN ('cyt_i','hom_i','mj_i','oilestates_a','pwd_i','steel05_i','steel_i','marujyu_i')
            AND a.userDept NOT LIKE '%_a'
            AND a.comsta = "Y"
            AND a.userbranch != ''
            <cfif IsDefined("form.sSearch") AND form.sSearch NEQ "">
            	AND (
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
            GROUP BY a.userbranch		
			#sOrder#
			#sLimit#
        <cfelseif getMultiCompany.recordcount NEQ 0>
            SELECT a.userbranch,b.compro,b.period,b.lastaccyear,b.remark  
            FROM users AS a 
            LEFT JOIN ( SELECT compro,period,lastaccyear,companyid,remark 
            			FROM useraccountlimit) AS b ON b.companyid=a.userbranch
            WHERE a.userbranch IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#multiCompanyList#">)
            <cfif IsDefined("form.sSearch") AND form.sSearch NEQ "">
            	AND (
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
            GROUP BY a.userbranch
            #sOrder#
			#sLimit#
        <cfelseif husergrpid eq "admin">
            SELECT a.userbranch,b.compro,b.period,b.lastaccyear,b.remark  
            FROM users AS a
            LEFT JOIN ( SELECT compro,period,lastaccyear,companyid,remark
            		    FROM useraccountlimit) AS b ON b.companyid=a.userbranch
            WHERE a.userbranch='#trim(hcomid)#'
            <cfif IsDefined("form.sSearch") AND form.sSearch NEQ "">
            	AND (
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
            GROUP BY a.userbranch
            #sOrder#
			#sLimit#
        <cfelse>
            SELECT a.userbranch,b.compro,b.period,b.lastaccyear,b.remark  
            FROM users AS a
            LEFT JOIN ( SELECT compro,period,lastaccyear,companyid,remark 
            			FROM useraccountlimit) AS b ON b.companyid=a.userbranch
            WHERE a.userid='#trim(huserid)#' 
            AND a.userbranch='#trim(hcomid)#' 
            <cfif IsDefined("form.sSearch") AND form.sSearch NEQ "">
            	AND (
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
        </cfif> 
	</cfquery>
    
	<cfquery name="getFilteredDataSetLength" datasource="main">
		SELECT FOUND_ROWS() AS iFilteredTotal
	</cfquery>
    
	<cfquery name="getTotalDataSetLength" datasource="main">
        SELECT COUNT(userbranch) AS iTotal
        FROM users
        WHERE userbranch != '';		 
	</cfquery>
    
	<cfset aaData=ArrayNew(1)>
    <cfloop query="getFilteredDataSet">	
        <cfset data=StructNew()>
        <cfset data["userbranch"]=" "&UCASE(userbranch)> 
        <cfset data["compro"]=" "&compro> 
        <cfset data["lastaccyear"]=DateFormat(lastaccyear,"DD/MM/YYYY")>  
        <cfset data["period"]=period>   
        <cfset data["remark"]=remark>    
        <cfset ArrayAppend(aaData,data)>
    </cfloop>
	
	<cfset output=StructNew()>
	<cfset output["sEcho"]=form.sEcho>
	<cfset output["iTotalRecords"]=getTotalDataSetLength.iTotal>
	<cfset output["iTotalDisplayRecords"]=getTotalDataSetLength.iTotal>
	<cfset output["aaData"]=aaData>
	<cfreturn output>
</cffunction>
</cfcomponent>