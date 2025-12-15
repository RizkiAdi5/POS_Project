<cfquery name="getartran" datasource="#dts#">
	select agenno,type,refno from artran
</cfquery>

<cfloop query = "getartran">
        
            <cfquery name="updaeictran" datasource="#dts#">
                update ictran 
                    set agenno=<cfqueryparam cfsqltype="cf_sql_char" value="#getartran.agenno#">
                    where refno=<cfqueryparam cfsqltype="cf_sql_char" value="#getartran.refno#">
                    and type=<cfqueryparam cfsqltype="cf_sql_char" value="#getartran.type#">;
            </cfquery>

          
			
</cfloop>