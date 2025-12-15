<cfcomponent>
    <cffunction name="listAccount" access="remote" returntype="struct">
		<cfif form.Hlinkams eq 'Y'>
			<cfset dts=replace(LCASE(form.dts),'_i','_a','all')>
        <cfelse>
			<cfset dts=form.dts>        	
        </cfif>
        <cfset term=form.term>
        <cfset limit=form.limit>
        <cfset page=form.page>
        <cfset start=page*limit>
        <cfset matchedAccountList=ArrayNew(1)>
        
        <cfquery name="listMatchedAccount" datasource="#dts#">
            SELECT currcode,currency1
            FROM currency
            WHERE currcode LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#term#%" />
            OR currency1 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#term#%" />
            ORDER BY currcode
            LIMIT #start#,#limit#;
        </cfquery>
        
        <cfquery name="getMatchedAccountLength" datasource="#dts#">
            SELECT FOUND_ROWS() AS matchedAccountLength
        </cfquery>	
        
        <cfloop query="listMatchedAccount">
            <cfset matchedAccount=StructNew()>
            <cfset matchedAccount["id"]=evaluate('listMatchedAccount.currcode')>
            <cfset matchedAccount["currencyCode"]=evaluate('listMatchedAccount.currcode')>
            <cfset matchedAccount["currency"]=listMatchedAccount.currency1>
            <cfset ArrayAppend(matchedAccountList,matchedAccount)>
        </cfloop>
        <cfset output=StructNew()>
        <cfset output["total"]=getMatchedAccountLength.matchedAccountLength>
        <cfset output["result"]=matchedAccountList>
        <cfreturn output>
    </cffunction>
    
    <cffunction name="getSelectedAccount" access="remote" returntype="struct">
		<cfif form.Hlinkams eq 'Y'>
			<cfset dts=replace(LCASE(form.dts),'_i','_a','all')>
        <cfelse>
			<cfset dts=form.dts>        	
        </cfif>
        <cfset value=form.value>
        
        <cfquery name="getSelectedAccount" datasource="#dts#">
            SELECT currcode,currency1
            FROM currency
            WHERE currcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#value#" />;
        </cfquery>
        
        <cfset selectedAccount=StructNew()>
        <cfset matchedAccount["id"]=evaluate('listMatchedAccount.currcode')>
        <cfset selectedAccount["currencyCode"]=evaluate('getSelectedAccount.currcode')>
        <cfset matchedAccount["currency"]=listMatchedAccount.currency1>
        <cfreturn selectedAccount>
        
    </cffunction>
</cfcomponent>