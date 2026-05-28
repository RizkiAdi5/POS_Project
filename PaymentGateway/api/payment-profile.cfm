<cfinclude template="/PaymentGateway/_pgBootstrap.cfm">
<cfsetting showdebugoutput="false">
<cfcontent type="application/json; charset=utf-8">

<cfset method = UCase(Trim(CGI.REQUEST_METHOD))>
<cfset allowedMethods = "VIRTUAL_ACCOUNT,EWALLET,QRIS">
<cfset allowedBanks = "BRI,BNI,MANDIRI,PERMATA">

<cfif method EQ "GET">
	<cfquery name="qP" datasource="#dts#">
		SELECT *
		FROM pg_payment_profile
		ORDER BY profile_id
		LIMIT 1
	</cfquery>
	<cfset p = pgProfileDefaults()>
	<cfif qP.recordCount><cfset p = pgApplyQuery(p, qP)></cfif>
	<cfset methods = pgSafeJsonArray(p.payment_methods_enabled)>
	<cfset banks = pgSafeJsonArray(p.va_banks_enabled)>
	<cfset statusVal = pgPaymentStatusNormalized(p.xendit_status)>
	<cfif REQUEST.xendit.isActive AND (NOT Len(Trim(ToString(p.xendit_account_id))))>
		<cfset statusVal = "LIVE">
	</cfif>
	<cfset result = {
		"xendit_account_id" = Trim(ToString(p.xendit_account_id)),
		"xendit_callback_token" = Trim(ToString(p.xendit_callback_token)),
		"xendit_status" = statusVal,
		"payment_methods_enabled" = methods,
		"va_banks_enabled" = banks,
		"payment_active" = (Val(p.payment_active) EQ 1),
		"business_name" = Trim(ToString(p.business_name)),
		"business_email" = Trim(ToString(p.business_email))
	}>
	<cfoutput>#SerializeJSON(result)#</cfoutput>
	<cfabort>
</cfif>

<cfif ListFindNoCase("PUT,POST", method)>
	<cfset raw = ToString(GetHttpRequestData().content)>
	<cfset payload = StructNew()>
	<cftry>
		<cfset payload = DeserializeJSON(raw)>
		<cfcatch type="any">
			<cfheader statuscode="400" statustext="Bad Request">
			<cfoutput>{"error":"invalid_json"}</cfoutput>
			<cfabort>
		</cfcatch>
	</cftry>

	<cfset methods = ArrayNew(1)>
	<cfset banks = ArrayNew(1)>
	<cfset i = 0>
	<cfif StructKeyExists(payload, "payment_methods_enabled") AND IsArray(payload.payment_methods_enabled)>
		<cfloop from="1" to="#ArrayLen(payload.payment_methods_enabled)#" index="i">
			<cfset m = UCase(Trim(ToString(payload.payment_methods_enabled[i])))>
			<cfif ListFindNoCase(allowedMethods, m) AND NOT ListFindNoCase(ArrayToList(methods), m)>
				<cfset ArrayAppend(methods, m)>
			</cfif>
		</cfloop>
	</cfif>
	<cfif StructKeyExists(payload, "va_banks_enabled") AND IsArray(payload.va_banks_enabled)>
		<cfloop from="1" to="#ArrayLen(payload.va_banks_enabled)#" index="i">
			<cfset b = UCase(Trim(ToString(payload.va_banks_enabled[i])))>
			<cfif ListFindNoCase(allowedBanks, b) AND NOT ListFindNoCase(ArrayToList(banks), b)>
				<cfset ArrayAppend(banks, b)>
			</cfif>
		</cfloop>
	</cfif>

	<cfset active = (ArrayLen(methods) GT 0) ? 1 : 0>

	<cfquery name="qP2" datasource="#dts#">
		SELECT profile_id
		FROM pg_payment_profile
		ORDER BY profile_id
		LIMIT 1
	</cfquery>

	<cfif qP2.recordCount>
		<cfquery datasource="#dts#">
			UPDATE pg_payment_profile
			SET payment_methods_enabled = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#SerializeJSON(methods)#">,
				va_banks_enabled = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#SerializeJSON(banks)#">,
				payment_active = <cfqueryparam cfsqltype="cf_sql_integer" value="#active#">,
				enable_qris = <cfqueryparam cfsqltype="cf_sql_char" value="#ListFindNoCase(ArrayToList(methods), 'QRIS') ? 'Y' : 'N'#">,
				enable_ewallet = <cfqueryparam cfsqltype="cf_sql_char" value="#ListFindNoCase(ArrayToList(methods), 'EWALLET') ? 'Y' : 'N'#">,
				enable_va = <cfqueryparam cfsqltype="cf_sql_char" value="#ListFindNoCase(ArrayToList(methods), 'VIRTUAL_ACCOUNT') ? 'Y' : 'N'#">,
				updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">,
				updated_at = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			WHERE profile_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#qP2.profile_id#">
		</cfquery>
	<cfelse>
		<cfquery datasource="#dts#">
			INSERT INTO pg_payment_profile (
				payment_methods_enabled, va_banks_enabled, payment_active,
				enable_qris, enable_ewallet, enable_va, is_active, created_by, updated_by, created_at, updated_at
			) VALUES (
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#SerializeJSON(methods)#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#SerializeJSON(banks)#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#active#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#ListFindNoCase(ArrayToList(methods), 'QRIS') ? 'Y' : 'N'#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#ListFindNoCase(ArrayToList(methods), 'EWALLET') ? 'Y' : 'N'#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#ListFindNoCase(ArrayToList(methods), 'VIRTUAL_ACCOUNT') ? 'Y' : 'N'#">,
				'Y',
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			)
		</cfquery>
	</cfif>

	<cfoutput>#SerializeJSON({"ok":true,"payment_methods_enabled":methods,"va_banks_enabled":banks,"payment_active":(active EQ 1)})#</cfoutput>
	<cfabort>
</cfif>

<cfheader statuscode="405" statustext="Method Not Allowed">
<cfoutput>{"error":"method_not_allowed"}</cfoutput>
