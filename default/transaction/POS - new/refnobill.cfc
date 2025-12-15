<cfcomponent>
	<cffunction name="getrefno" access="remote" returntype="string">
		<cfargument name="tran" type="string" required="yes">
        <cfargument name="dts" type="string" required="yes">
        <cfargument name="refnoset" type="string">
        
        <cfquery datasource="#dts#" name="getGeneralInfo">
			select lastUsedNo as tranno, refnoused as arun,refnocode,refnocode2,presuffixuse 
            from refnoset
			where type = '#tran#'
			and counter = '#refnoset#'
		</cfquery>
        
        <cfif getGeneralInfo.arun eq "1">
        <cfinvoke component="cfc.refno" method="processNum" oldNum="#getGeneralInfo.tranno#" returnvariable="newnextNum" />
        	<cfset actual_nexttranno = newnextNum>
            <cfif (getGeneralInfo.refnocode2 neq "" or getGeneralInfo.refnocode neq "") and getGeneralInfo.presuffixuse eq "1">
				<cfset nexttranno = tran&"-"&getGeneralInfo.refnocode&actual_nexttranno&getGeneralInfo.refnocode2>
            <cfelse>
            	<cfset nexttranno = tran&"-"&actual_nexttranno>
			</cfif>
            <cfset tranarun_1 = getGeneralInfo.arun>
		<cfelse>
			<cfset nexttranno = "">
            <cfset tranarun_1 = "0">
		</cfif>
        <cfset nexttranno = tostring(nexttranno)>
		<cfreturn nexttranno>
	</cffunction>
    
    <cffunction name="getrefnoset" access="remote" returntype="query">
		<cfargument name="tran" type="string" required="yes">
        <cfargument name="dts" type="string" required="yes">
        
		<cfif tran eq "INV">
        <cfset validset = "invoneset">
        <cfelse>
        <cfset validset = tran&"_oneset">
		</cfif>
        
        <cfquery name="validset" datasource="#dts#">
        SELECT #validset# as oneset from gsetup
        </cfquery>
        <cfif lcase(dts) eq "kjcpl_i" or lcase(dts) eq "kjctrial_i" or lcase(dts) eq "mlpl_i" or lcase(dts) eq "viva_i">
        <cfquery datasource="#dts#" name="getset">
			select counter,concat(refnotitle," - ",lastusedno) as lastno
            from refnoset
			where type = '#tran#'
            <cfif validset.oneset eq 1>
            and counter = 1
			</cfif>
             order by counter
		</cfquery>
		<cfelse>
        <cfquery datasource="#dts#" name="getset">
			select counter,concat(counter," - ",lastusedno) as lastno
            from refnoset
			where type = '#tran#'
            <cfif validset.oneset eq 1>
            and counter = 1
			</cfif>
             order by counter
		</cfquery>
        </cfif>
        
		<cfreturn getset>
	</cffunction>
</cfcomponent>