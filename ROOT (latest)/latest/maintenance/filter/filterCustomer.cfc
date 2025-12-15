<cfcomponent>
    <cffunction name="listAccount" access="remote" returntype="struct">
        <cfset dts=replace(form.dts,'_i','_a','all')>
        <cfset term=form.term>
        <cfset limit=form.limit>
        <cfset page=form.page>
        <cfset start=page*limit>
        <cfset matchedAccountList=ArrayNew(1)>
        
        <cfquery name="listMatchedAccount" datasource="#dts#">
            SELECT custno, name,name2
            FROM arcust
            WHERE custno LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#term#%" />
            OR name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#term#%" />
            OR name2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#term#%" />
            ORDER BY custno
            LIMIT #start#,#limit#;
        </cfquery>
        
        <cfquery name="getMatchedAccountLength" datasource="#dts#">
            SELECT FOUND_ROWS() AS matchedAccountLength
        </cfquery>	
        
        <cfloop query="listMatchedAccount">
            <cfset matchedAccount=StructNew()>
            <cfset matchedAccount["id"]=evaluate('listMatchedAccount.custno')>
            <cfset matchedAccount["customerNo"]=evaluate('listMatchedAccount.custno')>
            <cfset matchedAccount["name"]=listMatchedAccount.name>
            <cfset matchedAccount["name2"]=listMatchedAccount.name2>
            <cfset ArrayAppend(matchedAccountList,matchedAccount)>
        </cfloop>
        <cfset output=StructNew()>
        <cfset output["total"]=getMatchedAccountLength.matchedAccountLength>
        <cfset output["result"]=matchedAccountList>
        <cfreturn output>
    </cffunction>
    
    <cffunction name="getSelectedAccount" access="remote" returntype="struct">
        <cfset dts=replace(form.dts,'_i','_a','all')>
        <cfset value=form.value>
        
        <cfquery name="getSelectedAccount" datasource="#dts#">
            SELECT custno, name,name2
            FROM arcust
            WHERE custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#value#" />;
        </cfquery>
        
        <cfset selectedAccount=StructNew()>
        <cfset matchedAccount["id"]=evaluate('listMatchedAccount.custno')>
        <cfset selectedAccount["customerNo"]=evaluate('getSelectedAccount.custno')>
        <cfset matchedAccount["name"]=listMatchedAccount.name>
        <cfset matchedAccount["name2"]=listMatchedAccount.name2>
        <cfreturn selectedAccount>
        
    </cffunction>
</cfcomponent>