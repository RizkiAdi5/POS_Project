<cfinclude template="/PaymentGateway/_pgBootstrap.cfm">
<cfsetting showdebugoutput="false">
<cfcontent type="application/json; charset=utf-8">

<cfif UCase(Trim(CGI.REQUEST_METHOD)) NEQ "GET">
	<cfheader statuscode="405" statustext="Method Not Allowed">
	<cfoutput>{"error":"method_not_allowed"}</cfoutput>
	<cfabort>
</cfif>

<cfset ping = pgXenditHttp("GET", "/balance")>
<cfif NOT ping.ok>
	<cfheader statuscode="502" statustext="Bad Gateway">
	<cfoutput>{"error":"xendit_status_sync_failed","detail":"master_account_unreachable"}</cfoutput>
	<cfabort>
</cfif>

<cfquery name="qP" datasource="#dts#">
	SELECT profile_id
	FROM pg_payment_profile
	ORDER BY profile_id
	LIMIT 1
</cfquery>

<cfif qP.recordCount>
	<cfquery datasource="#dts#">
		UPDATE pg_payment_profile
		SET xendit_status = 'LIVE',
			xendit_type = 'MASTER',
			xendit_synced_at = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">,
			updated_at = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		WHERE profile_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#qP.profile_id#">
	</cfquery>
</cfif>

<cfoutput>#SerializeJSON({"ok":true,"xendit_account_id":"","xendit_status":"LIVE"})#</cfoutput>
