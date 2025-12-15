<cfcomponent>
	<cffunction name="cal_project" access="public" returntype="any">
		<cfargument name="db" required="yes">
		<cfargument name="empno" required="yes">
		<cfargument name="CPFWW_ADD_PRJ" required="yes">
	    <cfargument name="CPFCC_ADD_PRJ" required="yes">
	    <cfargument name="qry_tbl_pay" required="yes">
	    <cfargument name="proj_pay_qry" required="yes">   
		<cfargument name="compid" required="yes">
		<cfargument name="db_main" required="yes">	
			
			<cfquery name="gsetup_qry" datasource="#db_main#">
				Select c_acfwl from gsetup where comp_id="#compid#"
			</cfquery>
			
			<cfquery name="pay_qry" datasource="#db#">
				SELECT netpay,EPFCC, EPFWW,grosspay,tded,DED102 FROM #qry_tbl_pay#
				WHERE empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
			</cfquery>
			
			<cfquery name="prj_rcd_qry" datasource="#db#">
				SELECT project_code,dw_p, entryno FROM #proj_pay_qry#
				WHERE empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#"> and payyes="Y"
			</cfquery>
			
			<cfquery name="cal_dw" datasource="#db#">
				SELECT SUM(coalesce(dw_p,0)) as dw_sum FROM #proj_pay_qry#
				WHERE empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#"> and payyes="Y"
			</cfquery>
			
			<cfquery name="comm_qry" datasource="#db#">
				SELECT levy_fw_w from comm where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#"> 
			</cfquery>
			
			<cfloop query="prj_rcd_qry">
				<!-- cal salary pay per project  -->
				<cfset project_saly_pay = numberformat(val(pay_qry.netpay),'.__') * numberformat(val(prj_rcd_qry.dw_p),'.__')/numberformat(val(cal_dw.dw_sum),'.__')>
				<cfset project_saly_pay = numberformat(project_saly_pay,'.__')>
			
				<!--  	cal costing pay per project 	 --> 
				<cfset PRJ_NET = numberformat(val(pay_qry.grosspay),'.__') - numberformat(pay_qry.tded,'.__')>
				<cfif CPFWW_ADD_PRJ eq "1">
					<cfset PRJ_NET = PRJ_NET - numberformat(val(pay_qry.epfww),'.__')>
				</cfif>
				
				<cfif CPFCC_ADD_PRJ eq "1">
					<cfset PRJ_NET = PRJ_NET - numberformat(val(pay_qry.epfcc),'.__')>
				</cfif>
				 
				<cfset project_cost_pay = numberformat(val(PRJ_NET),'.__')* numberformat(val(prj_rcd_qry.dw_p),'.__')/numberformat(val(cal_dw.dw_sum),'.__')>
				<cfset project_cost_pay = numberformat(project_cost_pay,'.__')>
			
				
				<!--  	cal cpf per project -->
				<cfset project_epfww_pay = numberformat(val(pay_qry.epfww),'.__') * numberformat(val(prj_rcd_qry.dw_p),'.__')/numberformat(val(cal_dw.dw_sum),'.__')>
				<cfset project_epfcc_pay = numberformat(val(pay_qry.epfcc),'.__') * numberformat(val(prj_rcd_qry.dw_p),'.__')/numberformat(val(cal_dw.dw_sum),'.__')>
				
				<!--  	cal gross per project -->
				<cfset project_grosspay = numberformat(val(pay_qry.grosspay),'.__') * numberformat(val(prj_rcd_qry.dw_p),'.__')/numberformat(val(cal_dw.dw_sum),'.__')>
				<cfset project_fwl = 0>
				
				<cfif qry_tbl_pay eq "paytran">
					<cfif gsetup_qry.c_acfwl eq "1" >
						
						<cfset project_fwl = numberformat(val(comm_qry.levy_fw_w),'.__') * numberformat(val(prj_rcd_qry.dw_p),'.__')/numberformat(val(cal_dw.dw_sum),'.__')>
					<cfelse>
						<cfset project_fwl = numberformat(val(pay_qry.DED102),'.__') * numberformat(val(prj_rcd_qry.dw_p),'.__')/numberformat(val(cal_dw.dw_sum),'.__')>
					</cfif>
				 </cfif>
				 <!--- <cfoutput>#empno# #qry_tbl_pay# #comm_qry.levy_fw_w#</cfoutput> --->
				 <cfquery name="update_prj_rcd" datasource="#db#">
					UPDATE #proj_pay_qry#
					SET netpay = #val(project_saly_pay)#,
						jobcosting = #val(project_cost_pay)#,
						proj_epfww = #val(project_epfww_pay)#,
						proj_epfcc = #val(project_epfcc_pay)#,
						proj_gross = #val(project_grosspay)#,
						proj_fwl = #val(project_fwl)#
					WHERE empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#"> 
					and entryno = #prj_rcd_qry.entryno#
				 </cfquery> 
		<!--- 	<cfoutput>#prj_rcd_qry.entryno# #prj_rcd_qry.project_code# #val(project_epfcc_pay)# <br></cfoutput> --->
			</cfloop>
		<!--- <cfabort> --->
	
	
        <cfset myResult = "success">
		<cfreturn myResult>
	</cffunction>

</cfcomponent>