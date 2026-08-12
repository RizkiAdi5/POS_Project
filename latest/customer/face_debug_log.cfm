<cfprocessingdirective pageencoding="UTF-8">
<!---
    TEMPORARY diagnostic sink for face enrolment tuning.

    face_register.cfm?debug=1 posts its per-frame gate readings here so the
    numbers can be reviewed afterwards — they scroll past far too quickly to
    read while posing. Writes to the CF temp directory, not the webroot, so
    the log is never downloadable over HTTP.

    DELETE THIS FILE once SAME_PERSON_MAX and the gate thresholds are settled.
--->
<cfinclude template="../../application.cfm">
<cfsetting showdebugoutput="false">

<cfset logFile = getTempDirectory() & "face_debug.log">

<!--- Writing requires a customer session, so this cannot be used as an
      open write endpoint by anyone who finds the URL. --->
<cfif CGI.REQUEST_METHOD eq "POST">
    <cfif SESSION.emenu_loggedin neq "Yes">
        <cfcontent type="text/plain"><cfoutput>denied</cfoutput><cfabort>
    </cfif>
    <cfparam name="form.lines" default="">
    <cfif len(trim(form.lines))>
        <cftry>
            <cfset chunk = left(trim(form.lines), 20000)>
            <!--- dateTimeFormat() does not exist on CF10 — build the stamp
                  from dateFormat/timeFormat, which do. --->
            <cfset stamp = dateFormat(now(), "yyyy-mm-dd") & " " & timeFormat(now(), "HH:mm:ss")>
            <cffile action="append" file="#logFile#" charset="utf-8"
                    output="[#stamp#] #trim(SESSION.emenu_custno)# #trim(SESSION.emenu_name)#
#chunk#">
            <cfcatch type="any"></cfcatch>
        </cftry>
    </cfif>
    <cfcontent type="text/plain"><cfoutput>ok</cfoutput><cfabort>
</cfif>

<!--- GET: show the path and the captured log --->
<cfcontent type="text/plain"><cfoutput>log file: #logFile#

<cfif fileExists(logFile)>#fileRead(logFile, "utf-8")#<cfelse>(nothing captured yet)</cfif></cfoutput>
