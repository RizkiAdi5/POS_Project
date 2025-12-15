<cfcomponent>
    <cffunction name="listAccount" access="remote" returntype="struct">
        <cfset dts=form.dts>
        <cfset term=form.term>
        <cfset limit=form.limit>
        <cfset page=form.page>
        <cfset start=page*limit>
        <cfset matchedAccountList=ArrayNew(1)>

        <cfquery name="listMatchedAccount" datasource="main">
            SELECT userID, userName
            FROM users
            WHERE userBranch="#dts#"
            AND userGrpID <> 'Super'
            AND ( userID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#term#%" />
            	  OR username LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#term#%" />
                )
            ORDER BY userID
            LIMIT #start#,#limit#;
        </cfquery>
        
        <cfquery name="getMatchedAccountLength" datasource="#dts#">
            SELECT FOUND_ROWS() AS matchedAccountLength
        </cfquery>	
        
        <cfloop query="listMatchedAccount">
            <cfset matchedAccount=StructNew()>
            <cfset matchedAccount["id"]=evaluate('listMatchedAccount.userID')>
            <cfset matchedAccount["userID"]=evaluate('listMatchedAccount.userID')>
            <cfset matchedAccount["userName"]=listMatchedAccount.userName>
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
            SELECT userID,username
            FROM users
            WHERE userBranch="#dts#"
            AND userGrpID <> 'Super'
            AND userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#value#" />;
        </cfquery>
        
        <cfset selectedAccount=StructNew()>
        <cfset matchedAccount["id"]=evaluate('getSelectedAccount.userID')>
        <cfset selectedAccount["userID"]=evaluate('getSelectedAccount.userID')>
        <cfset selectedAccount["userName"]=getSelectedAccount.userName>
        <cfreturn selectedAccount>
        
    </cffunction>
</cfcomponent>