<cfprocessingdirective pageencoding="UTF-8">
<cfinclude template="../../application.cfm">
<cfsetting enablecfoutputonly="true">
<cfsetting showdebugoutput="false">
<cfheader name="Cache-Control" value="no-store">
<cfheader name="Content-Type" value="application/json; charset=utf-8">

<!---
  Customer dining assistant proxy.
  Browser (guest / logged-in customer) -> this CFM -> Node /chat/customer.
  No business analytics — menu, order status, and guest help only.
--->

<cfset AI_NODE_URL       = "http://127.0.0.1:8088/chat/customer">
<cfset AI_SHARED_SECRET  = "cleRkQqi7ogrKX5mAn6xr8LXmz9MobDlzcnKAYYHYCIqDnBy2c5bfuWRyrXDTcVw">

<!--- Customer e-menu session required --->
<cfif NOT len(trim(SESSION.emenu_table_id))>
    <cfheader statuscode="401">
    <cfoutput>{"error":"no_table_session"}</cfoutput>
    <cfabort>
</cfif>
<cfif SESSION.emenu_loggedin neq "Yes" AND SESSION.emenu_is_guest neq "Yes">
    <cfheader statuscode="401">
    <cfoutput>{"error":"not_authenticated"}</cfoutput>
    <cfabort>
</cfif>
<cfif NOT len(dts)>
    <cfheader statuscode="500">
    <cfoutput>{"error":"dts_missing"}</cfoutput>
    <cfabort>
</cfif>

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

<cfset guestUser = "guest">
<cfif len(trim(SESSION.emenu_custno))>
    <cfset guestUser = trim(SESSION.emenu_custno)>
<cfelseif len(trim(SESSION.emenu_name))>
    <cfset guestUser = trim(SESSION.emenu_name)>
</cfif>

<cfset tableName = "">
<cfif isDefined("SESSION.emenu_table_name") AND len(trim(SESSION.emenu_table_name))>
    <cfset tableName = trim(SESSION.emenu_table_name)>
</cfif>

<cfset forwardBody = {
    "question" = userQuestion,
    "dts"      = dts,
    "user"     = guestUser,
    "role"     = "customer",
    "context"  = {
        "order_id"      = val(SESSION.emenu_order_id),
        "order_number"  = len(trim(SESSION.emenu_order_number)) ? trim(SESSION.emenu_order_number) : "",
        "table_id"      = val(SESSION.emenu_table_id),
        "table_number"  = len(trim(SESSION.emenu_table_number)) ? trim(SESSION.emenu_table_number) : "",
        "table_name"    = tableName,
        "is_guest"      = (SESSION.emenu_is_guest eq "Yes"),
        "customer_name" = len(trim(SESSION.emenu_name)) ? trim(SESSION.emenu_name) : "Guest",
        "currency_code" = isDefined("SESSION.emenu_currency_code") ? SESSION.emenu_currency_code : "MYR",
        "currency_symbol" = isDefined("SESSION.emenu_currency_symbol") ? SESSION.emenu_currency_symbol : "RM",
        "currency_decimals" = isDefined("SESSION.emenu_currency_decimals") ? val(SESSION.emenu_currency_decimals) : 2
    }
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
        <cfif isNumeric(codePart)><cfset httpStatus = int(codePart)></cfif>
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
