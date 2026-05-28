<cfinclude template="/PaymentGateway/_pgBootstrap.cfm">
<cfsetting showdebugoutput="false">
<cfcontent type="application/json; charset=utf-8">

<cfif UCase(Trim(CGI.REQUEST_METHOD)) NEQ "POST">
	<cfheader statuscode="405" statustext="Method Not Allowed">
	<cfoutput>{"error":"method_not_allowed"}</cfoutput>
	<cfabort>
</cfif>

<cfquery name="qP" datasource="#dts#">
	SELECT profile_id, business_email, business_name, xendit_callback_token
	FROM pg_payment_profile
	ORDER BY profile_id
	LIMIT 1
</cfquery>

<cfset businessEmail = "">
<cfset businessName = "">
<cfset profileId = 0>
<cfset callbackToken = "">

<cfif qP.recordCount>
	<cfset profileId = qP.profile_id>
	<cfset businessEmail = Trim(ToString(qP.business_email))>
	<cfset businessName = Trim(ToString(qP.business_name))>
	<cfset callbackToken = Trim(ToString(qP.xendit_callback_token))>
</cfif>

<cfif NOT Len(businessEmail)><cfset businessEmail = Trim(ToString(SESSION.emenu_email))></cfif>
<cfif NOT Len(businessName)><cfset businessName = Len(Trim(ToString(SESSION.emenu_name))) ? Trim(ToString(SESSION.emenu_name)) : "Merchant"></cfif>

<cfif NOT Len(businessEmail) OR NOT IsValid("email", businessEmail)>
	<cfheader statuscode="400" statustext="Bad Request">
	<cfoutput>{"error":"invalid_or_missing_business_email"}</cfoutput>
	<cfabort>
</cfif>

<cfif NOT REQUEST.xendit.isActive>
	<cfheader statuscode="400" statustext="Bad Request">
	<cfoutput>{"error":"xendit_not_configured_or_disabled"}</cfoutput>
	<cfabort>
</cfif>

<!--- Direct master account mode: validate key by simple balance ping only. --->
<cfset ping = pgXenditHttp("GET", "/balance")>
<cfif NOT ping.ok>
	<cfheader statuscode="502" statustext="Bad Gateway">
	<cfoutput>#SerializeJSON({"error":"xendit_master_auth_failed","detail":pgXenditErr(ping),"http_status":ping.httpStatus})#</cfoutput>
	<cfabort>
</cfif>

<cfif NOT Len(callbackToken)>
	<cfset callbackToken = LCase(Replace(CreateUUID(), "-", "", "all"))>
</cfif>

<cfif qP.recordCount>
	<cfquery datasource="#dts#">
		UPDATE pg_payment_profile
		SET business_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#businessEmail#">,
			business_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#businessName#">,
			account_type = 'MANAGED',
			xendit_account_id = NULL,
			xendit_callback_token = <cfqueryparam cfsqltype="cf_sql_varchar" value="#callbackToken#">,
			xendit_status = 'LIVE',
			xendit_synced_at = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">,
			updated_at = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		WHERE profile_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#profileId#">
	</cfquery>
<cfelse>
	<cfquery datasource="#dts#">
		INSERT INTO pg_payment_profile (
			business_email, business_name, account_type, xendit_account_id, xendit_callback_token, xendit_status,
			enable_qris, enable_ewallet, enable_va, enable_card, is_active, created_by, updated_by, created_at, updated_at
		) VALUES (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#businessEmail#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#businessName#">,
			'MANAGED',
			NULL,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#callbackToken#">,
			'LIVE',
			'Y','Y','Y','N','Y',
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		)
	</cfquery>
</cfif>

<cfoutput>#SerializeJSON({"ok":true,"xendit_account_id":"","xendit_status":"LIVE","xendit_callback_token":callbackToken})#</cfoutput>
