<cfcomponent>
    <cffunction name="listAccount" access="remote" returntype="struct">
        <cfset dts=form.dts>
        <cfset term=form.term>
        <cfset limit=form.limit>
        <cfset page=form.page>
        <cfset start=page*limit>
        <cfset matchedAccountList=ArrayNew(1)>

        <cfquery name="listMatchedAccount" datasource="#dts#">
            SELECT sizeid AS sizeid , desp AS desp
            FROM icsizeid
            WHERE sizeid LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#term#%" />
            OR desp LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#term#%" />
            ORDER BY sizeid
            LIMIT #start#,#limit#;
        </cfquery>
        
        <cfquery name="getMatchedAccountLength" datasource="#dts#">
            SELECT FOUND_ROWS() AS matchedAccountLength
        </cfquery>	
        
        <cfloop query="listMatchedAccount">
            <cfset matchedAccount=StructNew()>
            <cfset matchedAccount["id"]=evaluate('listMatchedAccount.sizeid')>
            <cfset matchedAccount["size"]=evaluate('listMatchedAccount.sizeid')>
            <cfset matchedAccount["desp"]=listMatchedAccount.desp>
            <cfset ArrayAppend(matchedAccountList,matchedAccount)>
        </cfloop>
        <cfset output=StructNew()>
        <cfset output["total"]=getMatchedAccountLength.matchedAccountLength>
        <cfset output["result"]=matchedAccountList>
        <cfreturn output>
    </cffunction>
    
    <cffunction name="getSelectedAccount" access="remote" returntype="struct">
        <cfset dts=form.dts>
        <cfset value=form.value>
        
        <cfquery name="getSelectedAccount" datasource="#dts#">
            SELECT sizeid AS sizeid, desp AS desp
            FROM icsizeid
            WHERE sizeid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#value#" />;
        </cfquery>
        
        <cfset selectedAccount=StructNew()>
        <cfset matchedAccount["id"]=evaluate('listMatchedAccount.sizeid')>
        <cfset selectedAccount["size"]=evaluate('getSelectedAccount.sizeid')>
        <cfset selectedAccount["desp"]=getSelectedAccount.desp>
        <cfreturn selectedAccount>
        
    </cffunction>
</cfcomponent>