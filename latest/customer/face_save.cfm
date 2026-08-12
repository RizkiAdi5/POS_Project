<cfprocessingdirective pageencoding="UTF-8">
<cfinclude template="../../application.cfm">
<cfsetting showdebugoutput="false">

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

<!--- Trace BEFORE the session guard. The guard redirects, so tracing after it
      would make a session bounce look identical to the form never submitting. --->
<cfset faceTrace("entered, descriptor bytes=" & len(trim(form.descriptor))
                 & ", loggedin=" & SESSION.emenu_loggedin
                 & ", custno=[" & trim(SESSION.emenu_custno) & "]")>

<cfif SESSION.emenu_loggedin neq "Yes" OR NOT len(SESSION.emenu_custno)>
    <cfset faceTrace("REJECTED by session guard — redirecting to login")>
    <cflocation url="/latest/customer/login.cfm" addtoken="false">
</cfif>

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
<!--- Returns "" when the descriptor is good, otherwise why it was refused.
      A bare true/false told us an enrolment had been rejected but not which
      element or value caused it, leaving the customer with a silent failure
      and nothing to diagnose from. --->
<cffunction name="descriptorProblem" returntype="string" output="false">
    <cfargument name="d" type="any" required="true">
    <cfif NOT isArray(arguments.d)>
        <cfreturn "not an array">
    </cfif>
    <cfif arrayLen(arguments.d) neq 128>
        <cfreturn "length " & arrayLen(arguments.d) & ", expected 128">
    </cfif>
    <cfloop from="1" to="128" index="i">
        <cfif NOT isNumeric(arguments.d[i])>
            <cfreturn "element " & i & " not numeric: [" & left(toString(arguments.d[i]), 40) & "]">
        </cfif>
        <cfif abs(val(arguments.d[i])) gt 2>
            <cfreturn "element " & i & " out of range: " & arguments.d[i]>
        </cfif>
    </cfloop>
    <cfreturn "">
</cffunction>

<cffunction name="isValidDescriptor" returntype="boolean" output="false">
    <cfargument name="d" type="any" required="true">
    <cfreturn NOT len(descriptorProblem(arguments.d))>
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
            <cfset tplNum = 0>
            <cfloop array="#parsed.templates#" index="tpl">
                <cfset tplNum = tplNum + 1>
                <cfif NOT (isStruct(tpl) AND structKeyExists(tpl, "d"))>
                    <cfset descriptorValid = false>
                    <cfset faceTrace("template " & tplNum & " has no 'd' key")>
                <cfelse>
                    <cfset problem = descriptorProblem(tpl.d)>
                    <cfif len(problem)>
                        <cfset descriptorValid = false>
                        <cfset faceTrace("template " & tplNum
                                         & " (" & (structKeyExists(tpl, "pose") ? tpl.pose : "?")
                                         & ") rejected: " & problem)>
                    </cfif>
                </cfif>
            </cfloop>
        <cfelse>
            <cfset faceTrace("payload shape not recognised: isArray="
                             & isArray(parsed) & " isStruct=" & isStruct(parsed))>
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
