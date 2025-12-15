<cfcomponent>
	<cffunction name="getTax" access="remote" returntype="string">
		<cfargument name="dts" type="string" required="yes">
        <cfargument name="taxtable" type="string" required="yes">
        <cfargument name="taxcode" type="string">
        
        <cfquery name="taxrate" datasource="#dts#">
        SELECT rate1 FROM #taxtable# WHERE code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#taxcode#">
        </cfquery>
		<cfset myResult=val(taxrate.rate1) * 100>
		<cfreturn myResult>
	</cffunction>
    
    <cffunction name="getTaxQry" access="remote" returntype="query">
		<cfargument name="dts" type="string" required="yes">
        <cfargument name="taxtable" type="string" required="yes">
        <cfargument name="tran" type="string">
        
        <cfquery name="getdf" datasource="#dts#">
        SELECT df_salestax,df_purchasetax FROM gsetup
        </cfquery>
        
        <cfquery name="taxrate" datasource="#dts#">
        
		<cfif (tran eq 'RC' or tran eq 'PO' or tran eq 'PR') and getdf.df_purchasetax neq "">
        SELECT 
        "#getdf.df_purchasetax#" as code
         union all
        <cfelseif tran eq 'DN' or tran eq 'CN'>
        <cfelseif getdf.df_salestax neq "">
        SELECT 
        "#getdf.df_salestax#" as code
         union all
		</cfif>
        SELECT code FROM #taxtable# 
        <cfif tran eq 'RC' or tran eq 'PO' or tran eq 'PR' >
        WHERE tax_type <> "ST"
        <cfif getdf.df_purchasetax neq "">
        and code <> "#getdf.df_purchasetax#"
		</cfif>
        <cfelseif tran eq 'DN' or tran eq 'CN' >
        <cfelse>
        WHERE tax_type <> "PT"
        <cfif getdf.df_purchasetax neq "">
        and code <> "#getdf.df_salestax#"
		</cfif>
        </cfif>
        </cfquery>
        
		<cfreturn taxrate>
	</cffunction>
</cfcomponent>