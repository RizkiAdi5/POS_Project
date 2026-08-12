<cfprocessingdirective pageencoding="UTF-8">
<cfinclude template="../../application.cfm">
<cfsetting showdebugoutput="false">

<cfif SESSION.emenu_loggedin neq "Yes" OR NOT len(SESSION.emenu_custno)>
    <cflocation url="/latest/customer/login.cfm" addtoken="false">
</cfif>

<cfparam name="form.descriptor" default="">

<!--- TEMPORARY breadcrumb — records that this page was actually reached and
      what it decided, so a silent non-save can be told apart from the form
      never submitting at all. Remove with face_debug_log.cfm. --->
<cffunction name="faceTrace" output="false" returntype="void">
    <cfargument name="msg" type="string" required="true">
    <cftry>
        <cfset var stamp = dateFormat(now(), "yyyy-mm-dd") & " " & timeFormat(now(), "HH:mm:ss")>
        <cffile action="append" file="#getTempDirectory()#face_debug.log" charset="utf-8"
                output="[#stamp#] FACE_SAVE #trim(SESSION.emenu_custno)# — #arguments.msg#">
        <cfcatch type="any"></cfcatch>
    </cftry>
</cffunction>

<cfset faceTrace("entered, descriptor bytes=" & len(trim(form.descriptor)))>

<!---
    Accepts two shapes:
      v2 (current)  {"v":2,"templates":[{"pose":"center","d":[128 floats]}, ...]}
      legacy        [128 floats]   — single frontal descriptor
    Legacy is still accepted so the enrolments made before multi-pose
    capture keep working until those customers re-register.
--->
<cfset descriptorValid = false>

<!---
    A well-formed face-api descriptor is 128 numbers with a norm around
    1.4; every element sits well inside +/-1. An enrolment already in this
    database had a single element of -8.29, which pushed that customer's
    distance to everyone (including themselves) past any usable threshold
    and made face login permanently impossible for them. Range-check each
    element so a corrupt capture can never be persisted again.
--->
<cffunction name="isValidDescriptor" returntype="boolean" output="false">
    <cfargument name="d" type="any" required="true">
    <cfif NOT (isArray(arguments.d) AND arrayLen(arguments.d) eq 128)>
        <cfreturn false>
    </cfif>
    <cfloop from="1" to="128" index="i">
        <cfif NOT isNumeric(arguments.d[i]) OR abs(val(arguments.d[i])) gt 2>
            <cfreturn false>
        </cfif>
    </cfloop>
    <cfreturn true>
</cffunction>

<cfif len(trim(form.descriptor))>
    <cftry>
        <cfset parsed = deserializeJSON(trim(form.descriptor))>

        <cfif isArray(parsed)>
            <!--- legacy single descriptor --->
            <cfset descriptorValid = isValidDescriptor(parsed)>

        <cfelseif isStruct(parsed) AND structKeyExists(parsed, "templates")
                  AND isArray(parsed.templates) AND arrayLen(parsed.templates) gt 0>
            <cfset descriptorValid = true>
            <cfloop array="#parsed.templates#" index="tpl">
                <cfif NOT (isStruct(tpl) AND structKeyExists(tpl, "d")
                           AND isValidDescriptor(tpl.d))>
                    <cfset descriptorValid = false>
                </cfif>
            </cfloop>
        </cfif>

        <cfcatch type="any">
            <cfset descriptorValid = false>
        </cfcatch>
    </cftry>

    <cfset faceTrace("parsed, descriptorValid=" & descriptorValid)>

    <cfif descriptorValid>
        <cftry>
            <cfquery result="rSave" datasource="#dts#">
                UPDATE arcust
                SET    face_token  = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#trim(form.descriptor)#">,
                       UPDATED_ON  = <cfqueryparam cfsqltype="cf_sql_timestamp"   value="#now()#">
                WHERE  CUSTNO      = <cfqueryparam cfsqltype="cf_sql_varchar"     value="#SESSION.emenu_custno#">
            </cfquery>
            <cfset faceTrace("UPDATE ok, rows affected=" & rSave.recordCount)>
            <cfcatch type="any">
                <cfset faceTrace("UPDATE FAILED: " & cfcatch.message)>
            </cfcatch>
        </cftry>
    </cfif>
<cfelse>
    <cfset faceTrace("no descriptor posted")>
</cfif>

<cflocation url="/latest/customer/menu.cfm?face=#descriptorValid ? 'saved' : 'failed'#" addtoken="false">
