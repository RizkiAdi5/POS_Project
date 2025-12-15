<cfcomponent>
    <cffunction name="listAccount" access="remote" returntype="struct">
        <cfset dts=replace(form.dts,'_i','_a','all')>
        <cfset term=form.term>
        <cfset limit=form.limit>
        <cfset page=form.page>
        <cfset start=page*limit>
        <cfset matchedAccountList=ArrayNew(1)>
        
        <cfquery name="listMatchedAccount" datasource="#dts#">
            SELECT source,project
            FROM project
            WHERE porj = 'J'
           	AND (source LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#term#%" />
            	 OR project LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#term#%" />
            	)
            ORDER BY source
            LIMIT #start#,#limit#;
        </cfquery>
        
        <cfquery name="getMatchedAccountLength" datasource="#dts#">
            SELECT FOUND_ROWS() AS matchedAccountLength
        </cfquery>	
        
        <cfloop query="listMatchedAccount">
            <cfset matchedAccount=StructNew()>
            <cfset matchedAccount["id"]=evaluate('listMatchedAccount.source')>
            <cfset matchedAccount["source"]=evaluate('listMatchedAccount.source')>
            <cfset matchedAccount["project"]=listMatchedAccount.project>
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
            SELECT source, project
            FROM project
            WHERE porj = 'J'
            AND source=<cfqueryparam cfsqltype="cf_sql_varchar" value="#value#" />;
        </cfquery>
        
        <cfset selectedAccount=StructNew()>
        <cfset matchedAccount["id"]=evaluate('getSelectedAccount.source')>
        <cfset selectedAccount["source"]=evaluate('getSelectedAccount.source')>
        <cfset selectedAccount["project"]=getSelectedAccount.project>
        <cfreturn selectedAccount>
        
    </cffunction>
</cfcomponent>