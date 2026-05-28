<!--- Xendit config: pgConfig.cfm, APPLICATION, or PG_XENDIT_* env. Test: auth.cfm?xenditTest=1 --->
<cfsetting requesttimeout="60" showdebugoutput="no">
<cfinclude template="/PaymentGateway/pgCore.cfm">

<cfset REQUEST.xendit = {
	enabledFlag="", secretKey="", publicKey="", webhookToken="",
	apiBaseUrl="https://api.xendit.co", isConfigured=false, isActive=false,
	keyHint="", authHeaderBasic=""
}>

<cfif FileExists(ExpandPath("/PaymentGateway/pgConfig.cfm"))>
	<cfinclude template="/PaymentGateway/pgConfig.cfm">
</cfif>

<cfset REQUEST.xendit.enabledFlag = pgAppOrEnv("pg_xendit_enabled", "PG_XENDIT_ENABLED")>
<cfset REQUEST.xendit.secretKey = pgAppOrEnv("pg_xendit_secret_key", "PG_XENDIT_SECRET_KEY")>
<cfset REQUEST.xendit.publicKey = pgAppOrEnv("pg_xendit_public_key", "PG_XENDIT_PUBLIC_KEY")>
<cfset REQUEST.xendit.webhookToken = pgAppOrEnv("pg_xendit_webhook_token", "PG_XENDIT_WEBHOOK_TOKEN")>
<cfif StructKeyExists(APPLICATION, "pg_xendit_api_base_url") AND Len(Trim(APPLICATION.pg_xendit_api_base_url))>
	<cfset REQUEST.xendit.apiBaseUrl = Trim(APPLICATION.pg_xendit_api_base_url)>
</cfif>

<cfset REQUEST.xendit.isConfigured = Len(REQUEST.xendit.secretKey) GT 0>
<cfif REQUEST.xendit.isConfigured>
	<cfset REQUEST.xendit.keyHint = Left(REQUEST.xendit.secretKey, 12) & "...">
	<cfset REQUEST.xendit.authHeaderBasic = "Basic " & ToBase64(REQUEST.xendit.secretKey & ":")>
</cfif>

<cfset pgOn = LCase(REQUEST.xendit.enabledFlag)>
<cfif REQUEST.xendit.isConfigured AND NOT Len(pgOn)>
	<cfset pgOn = "y">
	<cfset REQUEST.xendit.enabledFlag = "Y">
</cfif>
<cfset REQUEST.xendit.isActive = REQUEST.xendit.isConfigured AND ListFindNoCase("y,yes,1,true", pgOn) GT 0>

<cfif StructKeyExists(URL, "xenditTest") AND Val(URL.xenditTest) EQ 1>
	<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><title>Xendit test</title>
	<link rel="stylesheet" href="/latest/css/bootstrap/bootstrap.css"></head>
	<body class="container" style="padding:1.5rem"><cfoutput>
	<h1>Xendit test</h1>
	<p>Active: <strong><cfif REQUEST.xendit.isActive>yes<cfelse>no</cfif></strong>
	<cfif REQUEST.xendit.isConfigured> | Key: #XmlFormat(REQUEST.xendit.keyHint)#</cfif></p>
	</cfoutput>
	<cfif NOT REQUEST.xendit.isConfigured>
		<p class="text-danger">Add <code>pgConfig.cfm</code> (see pgConfig.example.cfm).</p>
	<cfelse>
		<cfset bal = pgXenditHttp("GET", "/balance")>
		<cfset xp = pgXenditHttp("GET", "/v2/accounts", "", "", "limit=1")>
		<cfoutput>
			<p>Balance: <strong>HTTP #bal.httpStatus#</strong></p>
			<p>xenPlatform: <strong>HTTP #xp.httpStatus#</strong> <cfif xp.httpStatus NEQ 200>(need new key + xenPlatform enabled)</cfif></p>
		</cfoutput>
	</cfif>
	</body></html>
	<cfabort>
</cfif>
