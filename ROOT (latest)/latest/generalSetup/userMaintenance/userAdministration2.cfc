<cfcomponent>
<cffunction name="listAccount" access="remote" returntype="struct">
	<cfset dts=form.dts>
    <cfset husergrpid=form.userGroup>
    <cfset huserid=form.userID>
	<cfset comid=form.targetTable>
		
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
    	
	<cfquery name="getFilteredDataSet" datasource="main">  	
		<cfif husergrpid EQ "super">
            SELECT * 
            FROM users 
            WHERE userbranch = '#trim(comid)#'
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
			#sLimit#;
        <cfelseif husergrpid EQ "admin">
            SELECT * 
            FROM users 
            WHERE userbranch = '#trim(comid)#'
            	  AND usergrpid != 'super' 
            	  AND userid NOT LIKE 'ultra%'
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
			#sLimit#;    
        <cfelse>
            SELECT * 
            FROM users 
            WHERE userid='#trim(huserid)#' 
                  AND userbranch='#trim(comid)#'
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
			#sLimit#;      
        </cfif>
	</cfquery>
    
	<cfquery name="getFilteredDataSetLength" datasource="main">
		SELECT FOUND_ROWS() AS iFilteredTotal
	</cfquery>
    
	<cfquery name="getTotalDataSetLength" datasource="main">
		<cfif husergrpid EQ "super">
            SELECT COUNT(userid) AS iTotal
            FROM users 
            WHERE userbranch = '#trim(comid)#';
        <cfelseif husergrpid EQ "admin">
            SELECT COUNT(userid) AS iTotal
            FROM users 
            WHERE userbranch='#trim(comid)#' 
                  AND usergrpid != 'super' 
                  AND userid NOT LIKE 'ultra%';
        <cfelse>
        	SELECT COUNT(userid) AS iTotal 
            FROM users 
            WHERE userid='#trim(huserid)#' 
                  AND userbranch='#trim(comid)#';
        </cfif>		
	</cfquery>
    
	<cfset aaData=ArrayNew(1)>
    <cfloop query="getFilteredDataSet">	
        <cfset data=StructNew()>
        <cfset data["userbranch"]=" "&getFilteredDataSet.userbranch> 
        <cfset data["userid"]=" "&getFilteredDataSet.userid> 
        <cfset data["username"]=" "&getFilteredDataSet.username> 
        <cfset data["usergrpid"]=usergrpid>  
        <cfset data["useremail"]=useremail>   
        <cfset data["lastlogin"]=lastlogin>
        <cfset data["created_by"]=created_by>    
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