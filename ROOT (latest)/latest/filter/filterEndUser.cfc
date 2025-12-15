<cfcomponent>
    <cffunction name="listAccount" access="remote" returntype="struct">
        <cfset dts=form.dts>
        <cfset term=form.term>
        <cfset limit=form.limit>
        <cfset page=form.page>
        <cfset start=page*limit>
        <cfset matchedAccountList=ArrayNew(1)>
        
        <cfquery name="listMatchedAccount" datasource="#dts#">
            SELECT driverno, name
            FROM driver
            WHERE driverno LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#term#%" />
            OR name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#term#%" />
            ORDER BY driverno
            LIMIT #start#,#limit#;
        </cfquery>
        
        <cfquery name="getMatchedAccountLength" datasource="#dts#">
            SELECT FOUND_ROWS() AS matchedAccountLength
        </cfquery>	
        
        <cfloop query="listMatchedAccount">
            <cfset matchedAccount=StructNew()>
            <cfset matchedAccount["id"]=evaluate('listMatchedAccount.driverno')>
            <cfset matchedAccount["driverno"]=evaluate('listMatchedAccount.driverno')>
            <cfset matchedAccount["name"]=listMatchedAccount.name>
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
            SELECT driverno, name
            FROM driver
            WHERE driverno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#value#" />;
        </cfquery>
        
        <cfset selectedAccount=StructNew()>
        <cfset matchedAccount["id"]=evaluate('getSelectedAccount.driverno')>
        <cfset selectedAccount["driverno"]=evaluate('getSelectedAccount.driverno')>
        <cfset selectedAccount["name"]=getSelectedAccount.name>
        <cfreturn selectedAccount>
        
    </cffunction>
</cfcomponent>