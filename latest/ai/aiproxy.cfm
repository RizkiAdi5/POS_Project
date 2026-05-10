<cfprocessingdirective pageencoding="UTF-8">
<cfsetting enablecfoutputonly="true">
<cfsetting showdebugoutput="false">
<cfheader name="Cache-Control" value="no-store">
<cfheader name="Content-Type" value="application/json; charset=utf-8">

<!---
  AI Business Analyst proxy.
  Browser -> this CFM -> Node service at AI_NODE_URL.
  The DeepSeek key never leaves the Node process. The shared secret never
  leaves the server. The browser only talks to this CFM.
--->

<!--- ============ CONFIG (must match WEB-INF/ai/.env) ============ --->
<cfset AI_NODE_URL    = "http://127.0.0.1:8088/chat">
<cfset AI_SHARED_SECRET = "cleRkQqi7ogrKX5mAn6xr8LXmz9MobDlzcnKAYYHYCIqDnBy2c5bfuWRyrXDTcVw">
<!--- ============================================================ --->

<!--- ============ AUTH GUARD: admin only ============ --->
<cfif NOT isDefined("session.isLogIn") OR session.isLogIn NEQ "Yes">
    <cfheader statuscode="401">
    <cfoutput>{"error":"not_logged_in"}</cfoutput>
    <cfabort>
</cfif>
<!--- Keep this list in sync with AI_ALLOWED_ROLES in analyst.cfm --->
<cfset AI_ALLOWED_ROLES = "super,suser">

<cfif NOT isDefined("husergrpid") OR NOT listFindNoCase(AI_ALLOWED_ROLES, husergrpid)>
    <cfheader statuscode="403">
    <cfoutput>{"error":"role_not_allowed","your_role":"#(isDefined("husergrpid") ? husergrpid : "")#"}</cfoutput>
    <cfabort>
</cfif>
<cfif NOT isDefined("dts") OR NOT len(trim(dts))>
    <cfheader statuscode="500">
    <cfoutput>{"error":"dts_missing"}</cfoutput>
    <cfabort>
</cfif>

<!--- ============ READ JSON BODY ============ --->
<cfset rawBody = "">
<cftry>
    <cfset rawBody = toString(getHttpRequestData().content)>
    <cfcatch type="any"><cfset rawBody = ""></cfcatch>
</cftry>

<cfset payload = {}>
<cfif len(trim(rawBody))>
    <cftry>
        <cfset payload = deserializeJSON(rawBody)>
        <cfcatch type="any"><cfset payload = {}></cfcatch>
    </cftry>
</cfif>

<cfset userQuestion = "">
<cfif isStruct(payload) AND structKeyExists(payload, "question")>
    <cfset userQuestion = toString(payload.question)>
</cfif>
<cfif NOT len(trim(userQuestion))>
    <cfheader statuscode="400">
    <cfoutput>{"error":"question_required"}</cfoutput>
    <cfabort>
</cfif>
<cfif len(userQuestion) gt 2000>
    <cfset userQuestion = left(userQuestion, 2000)>
</cfif>

<!--- ============ FORWARD TO NODE ============ --->
<cfset forwardBody = {
    "question" = userQuestion,
    "dts"      = dts,
    "user"     = HUserID,
    "role"     = husergrpid
}>

<cfset httpStatus = 502>
<cfset responseText = "{""error"":""upstream_unreachable""}">

<cftry>
    <cfhttp url="#AI_NODE_URL#" method="POST" timeout="60" charset="utf-8" result="aiResp">
        <cfhttpparam type="header" name="Content-Type" value="application/json; charset=utf-8">
        <cfhttpparam type="header" name="X-AI-Secret" value="#AI_SHARED_SECRET#">
        <cfhttpparam type="body" value="#serializeJSON(forwardBody)#">
    </cfhttp>

    <cfif structKeyExists(aiResp, "Statuscode")>
        <cfset codePart = listFirst(aiResp.Statuscode, " ")>
        <cfif isNumeric(codePart)>
            <cfset httpStatus = int(codePart)>
        </cfif>
    </cfif>
    <cfif structKeyExists(aiResp, "FileContent") AND len(toString(aiResp.FileContent))>
        <cfset responseText = toString(aiResp.FileContent)>
    </cfif>

    <cfcatch type="any">
        <cfset httpStatus = 502>
        <cfset responseText = serializeJSON({
            "error" = "proxy_failed",
            "detail" = left(toString(cfcatch.message), 300)
        })>
    </cfcatch>
</cftry>

<cfheader statuscode="#httpStatus#">
<cfoutput>#responseText#</cfoutput>
