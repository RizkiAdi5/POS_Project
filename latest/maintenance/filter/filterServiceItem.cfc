<cfcomponent>
    <cffunction name="listAccount" access="remote" returntype="struct">
        <cfset dts=form.dts>
        <cfset term=form.term>
        <cfset limit=form.limit>
        <cfset page=form.page>
        <cfset start=page*limit>
        <cfset matchedAccountList=ArrayNew(1)>

        <cfquery name="listMatchedAccount" datasource="#dts#">
            SELECT itemno, desp
            FROM icitem
            WHERE itemtype = 'SV'
            AND ( itemno LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#term#%" /> 
            	  OR desp LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#term#%" /> 
                 )
            ORDER BY itemno
            LIMIT #start#,#limit#;
        </cfquery>
        
        <cfquery name="getMatchedAccountLength" datasource="#dts#">
            SELECT FOUND_ROWS() AS matchedAccountLength
        </cfquery>	
        
        <cfloop query="listMatchedAccount">
            <cfset matchedAccount=StructNew()>
            <cfset matchedAccount["id"]=evaluate('listMatchedAccount.itemno')>
            <cfset matchedAccount["itemno"]=evaluate('listMatchedAccount.itemno')>
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
            SELECT itemno, desp
            FROM icitem
            WHERE itemtype = 'SV'
            AND ( itemno LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#value#%" /> 
            	  OR desp LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#value#%" /> 
                 );
        </cfquery>
        
        <cfset selectedAccount=StructNew()>
        <cfset matchedAccount["id"]=evaluate('getSelectedAccount.itemno')>
        <cfset selectedAccount["itemno"]=evaluate('getSelectedAccount.itemno')>
        <cfset selectedAccount["desp"]=getSelectedAccount.desp>
        <cfreturn selectedAccount>
        
    </cffunction>
</cfcomponent>