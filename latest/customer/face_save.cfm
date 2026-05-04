<cfprocessingdirective pageencoding="UTF-8">
<cfinclude template="../../application.cfm">
<cfsetting showdebugoutput="false">

<cfif SESSION.emenu_loggedin neq "Yes" OR NOT len(SESSION.emenu_custno)>
    <cflocation url="/latest/customer/login.cfm" addtoken="false">
</cfif>

<cfparam name="form.descriptor" default="">

<cfif len(trim(form.descriptor))>
    <!--- Validate it is a JSON array of 128 numbers before persisting --->
    <cfset descriptorValid = false>
    <cftry>
        <cfset parsedDesc = deserializeJSON(trim(form.descriptor))>
        <cfif isArray(parsedDesc) AND arrayLen(parsedDesc) eq 128>
            <cfset descriptorValid = true>
        </cfif>
        <cfcatch type="any"></cfcatch>
    </cftry>

    <cfif descriptorValid>
        <cftry>
            <cfquery datasource="#dts#">
                UPDATE arcust
                SET    face_token  = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#trim(form.descriptor)#">,
                       UPDATED_ON  = <cfqueryparam cfsqltype="cf_sql_timestamp"   value="#now()#">
                WHERE  CUSTNO      = <cfqueryparam cfsqltype="cf_sql_varchar"     value="#SESSION.emenu_custno#">
            </cfquery>
            <cfcatch type="any">
                <!--- Non-fatal — just skip to menu --->
            </cfcatch>
        </cftry>
    </cfif>
</cfif>

<cflocation url="/latest/customer/menu.cfm" addtoken="false">
