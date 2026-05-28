<cfparam name="HUserID" default="">

<cfif NOT IsDefined("dts") OR NOT Len(Trim(dts))>
	<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><title>Payment Gateway</title>
	<link rel="stylesheet" href="/latest/css/bootstrap/bootstrap.css"></head>
	<body class="container" style="padding:2rem"><h2>Payment Gateway</h2>
	<p class="alert alert-warning">Log in to POS first (<strong>dts</strong> missing).</p></body></html>
	<cfabort>
</cfif>

<cfif NOT Len(Trim(HUserID)) AND IsDefined("SESSION") AND StructKeyExists(SESSION, "isLogIn") AND SESSION.isLogIn EQ "Yes" AND StructKeyExists(SESSION, "path")>
	<cfset HUserID = SESSION.path>
</cfif>

<cftry>
	<cfinclude template="/PaymentGateway/ensureTable.cfm">
	<cfcatch type="any">
		<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><title>Database error</title>
		<link rel="stylesheet" href="/latest/css/bootstrap/bootstrap.css"></head>
		<body class="container" style="padding:2rem"><cfoutput>
		<h2>Database error</h2>
		<p>Run <code>PaymentGateway/sql/pg_payment_profile.sql</code> on <code>#XmlFormat(dts)#</code>.</p>
		<pre class="well">#XmlFormat(cfcatch.message)#</pre>
		</cfoutput></body></html>
		<cfabort>
	</cfcatch>
</cftry>

<cfinclude template="/PaymentGateway/auth.cfm">
