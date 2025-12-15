 <cfquery name="getsymbol" datasource="#dts#">
    SELECT * FROM SYMBOL
    </cfquery>
    
<cfquery name="updateSymbol" datasource="#dts#">

<cfif getsymbol.recordcount eq 0>INSERT INTO<cfelse>UPDATE</cfif> symbol
SET
symbol1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#tobase64(form.symbol1)#">,
symbol2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#TOBASE64(form.symbol2)#">,
symbol3=<cfqueryparam cfsqltype="cf_sql_varchar" value="#TOBASE64(form.symbol3)#">,
symbol4=<cfqueryparam cfsqltype="cf_sql_varchar" value="#TOBASE64(form.symbol4)#">,
symbol5=<cfqueryparam cfsqltype="cf_sql_varchar" value="#TOBASE64(form.symbol5)#">,
symbol6=<cfqueryparam cfsqltype="cf_sql_varchar" value="#TOBASE64(form.symbol6)#">,
symbol7=<cfqueryparam cfsqltype="cf_sql_varchar" value="#TOBASE64(form.symbol7)#">,
symbol8=<cfqueryparam cfsqltype="cf_sql_varchar" value="#TOBASE64(form.symbol8)#">,
symbol9=<cfqueryparam cfsqltype="cf_sql_varchar" value="#TOBASE64(form.symbol9)#">,
symbol10=<cfqueryparam cfsqltype="cf_sql_varchar" value="#TOBASE64(form.symbol10)#">,
symbol11=<cfqueryparam cfsqltype="cf_sql_varchar" value="#TOBASE64(form.symbol11)#">,
symbol12=<cfqueryparam cfsqltype="cf_sql_varchar" value="#TOBASE64(form.symbol12)#">,
symbol13=<cfqueryparam cfsqltype="cf_sql_varchar" value="#TOBASE64(form.symbol13)#">,
symbol14=<cfqueryparam cfsqltype="cf_sql_varchar" value="#TOBASE64(form.symbol14)#">,
symbol15=<cfqueryparam cfsqltype="cf_sql_varchar" value="#TOBASE64(form.symbol15)#">,
symbol16=<cfqueryparam cfsqltype="cf_sql_varchar" value="#TOBASE64(form.symbol16)#">,
symbol17=<cfqueryparam cfsqltype="cf_sql_varchar" value="#TOBASE64(form.symbol17)#">,
symbol18=<cfqueryparam cfsqltype="cf_sql_varchar" value="#TOBASE64(form.symbol18)#">,
symbol19=<cfqueryparam cfsqltype="cf_sql_varchar" value="#TOBASE64(form.symbol19)#">,
symbol20=<cfqueryparam cfsqltype="cf_sql_varchar" value="#TOBASE64(form.symbol20)#">
</cfquery>
<cflocation url="/default/maintenance/symbol/symbolMaintenance.cfm">