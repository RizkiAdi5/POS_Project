<cfinclude template="/PaymentGateway/_pgBootstrap.cfm">

<cfparam name="URL.action" default="save">
<cfif StructKeyExists(FORM, "action") AND Len(FORM.action)><cfset URL.action = FORM.action></cfif>

<cfif URL.action EQ "sync">
	<cfquery name="qP" datasource="#dts#">
		SELECT profile_id, xendit_account_id FROM pg_payment_profile LIMIT 1
	</cfquery>
	<cfif qP.recordCount EQ 0 OR NOT Len(Trim(qP.xendit_account_id))>
		<cflocation url="paymentProfile.cfm?err=noaccount" addtoken="false">
	</cfif>
	<cftry>
		<cfset sync = pgXenditSyncAccount(qP.xendit_account_id)>
		<cfif sync.ok>
			<cfquery datasource="#dts#">
				UPDATE pg_payment_profile SET
					xendit_status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sync.status#">,
					xendit_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sync.type#">,
					xendit_synced_at = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">
				WHERE profile_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#qP.profile_id#">
			</cfquery>
			<cflocation url="paymentProfile.cfm?msg=synced&status=#URLEncodedFormat(sync.status)#" addtoken="false">
		</cfif>
		<cflocation url="paymentProfile.cfm?err=Sync failed" addtoken="false">
		<cfcatch type="any">
			<cflocation url="paymentProfile.cfm?err=#URLEncodedFormat(cfcatch.message)#" addtoken="false">
		</cfcatch>
	</cftry>
</cfif>

<cfif URL.action NEQ "save"><cflocation url="paymentProfile.cfm" addtoken="false"></cfif>

<cfparam name="FORM.profile_id" default="0">
<cfparam name="FORM.business_name" default="">
<cfparam name="FORM.business_email" default="">
<cfparam name="FORM.country_code" default="ID">
<cfparam name="FORM.account_type" default="MANAGED">
<cfparam name="FORM.payout_channel_code" default="">
<cfparam name="FORM.payout_channel_name" default="">
<cfparam name="FORM.payout_account_number" default="">
<cfparam name="FORM.payout_account_holder" default="">

<cfif NOT Len(Trim(FORM.business_name)) OR NOT Len(Trim(FORM.business_email)) OR NOT Len(Trim(FORM.payout_channel_code))>
	<cflocation url="paymentProfile.cfm?err=Required fields missing" addtoken="false">
</cfif>

<cfquery name="qExist" datasource="#dts#">
	SELECT profile_id, xendit_account_id FROM pg_payment_profile ORDER BY profile_id LIMIT 1
</cfquery>

<cfset profileId = Val(FORM.profile_id)>
<cfset xAccountId = "">
<cfif qExist.recordCount>
	<cfset profileId = qExist.profile_id>
	<cfset xAccountId = Trim(qExist.xendit_account_id)>
</cfif>
<cfset xStatus = "">
<cfset xType = "">
<cfset apiError = "">

<cfif REQUEST.xendit.isActive>
	<cftry>
		<cfif NOT Len(xAccountId)>
			<cfset cr = pgXenditCreateAccount(FORM.business_email, FORM.account_type, FORM.business_name, "", FORM.country_code)>
			<cfif cr.ok AND IsStruct(cr.data) AND StructKeyExists(cr.data, "id")>
				<cfset xAccountId = cr.data.id>
				<cfif StructKeyExists(cr.data, "status")><cfset xStatus = cr.data.status></cfif>
				<cfif StructKeyExists(cr.data, "type")><cfset xType = cr.data.type></cfif>
			<cfelse>
				<cfset apiError = "HTTP #cr.httpStatus#: #pgXenditErr(cr)#">
			</cfif>
		<cfelse>
			<cfset pgXenditUpdateAccount(xAccountId, FORM.business_name, "")>
			<cfset sync = pgXenditSyncAccount(xAccountId)>
			<cfif sync.ok>
				<cfif Len(sync.status)><cfset xStatus = sync.status></cfif>
				<cfif Len(sync.type)><cfset xType = sync.type></cfif>
			</cfif>
		</cfif>
		<cfcatch type="any"><cfset apiError = cfcatch.message></cfcatch>
	</cftry>
</cfif>

<cfset chName = FORM.payout_channel_code>
<cfif Len(Trim(FORM.payout_channel_name))><cfset chName = Trim(FORM.payout_channel_name)></cfif>

<cfif qExist.recordCount>
	<cfquery datasource="#dts#">
		UPDATE pg_payment_profile SET
			business_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.business_email)#">,
			business_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.business_name)#">,
			country_code = <cfqueryparam cfsqltype="cf_sql_char" value="#UCase(Trim(FORM.country_code))#">,
			account_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Trim(FORM.account_type))#">,
			<cfif Len(xAccountId)>xendit_account_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#xAccountId#">,</cfif>
			<cfif Len(xStatus)>xendit_status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#xStatus#">,</cfif>
			<cfif Len(xType)>xendit_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#xType#">,</cfif>
			xendit_synced_at = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#" null="#NOT Len(xAccountId)#">,
			payout_channel_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.payout_channel_code)#">,
			payout_channel_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#chName#">,
			payout_account_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.payout_account_number)#">,
			payout_account_holder = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.payout_account_holder)#">,
			enable_qris = <cfqueryparam cfsqltype="cf_sql_char" value="#pgFormYn('enable_qris')#">,
			enable_ewallet = <cfqueryparam cfsqltype="cf_sql_char" value="#pgFormYn('enable_ewallet')#">,
			enable_va = <cfqueryparam cfsqltype="cf_sql_char" value="#pgFormYn('enable_va')#">,
			enable_card = <cfqueryparam cfsqltype="cf_sql_char" value="#pgFormYn('enable_card')#">,
			is_active = <cfqueryparam cfsqltype="cf_sql_char" value="#pgFormYn('is_active')#">,
			updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">
		WHERE profile_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#profileId#">
	</cfquery>
<cfelse>
	<cfquery datasource="#dts#">
		INSERT INTO pg_payment_profile (
			business_email, business_name, country_code, account_type,
			xendit_account_id, xendit_status, xendit_type, xendit_synced_at,
			payout_channel_code, payout_channel_name, payout_account_number, payout_account_holder,
			enable_qris, enable_ewallet, enable_va, enable_card, is_active,
			created_by, updated_by
		) VALUES (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.business_email)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.business_name)#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#UCase(Trim(FORM.country_code))#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Trim(FORM.account_type))#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#xAccountId#" null="#NOT Len(xAccountId)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#xStatus#" null="#NOT Len(xStatus)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#xType#" null="#NOT Len(xType)#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#" null="#NOT Len(xAccountId)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.payout_channel_code)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#chName#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.payout_account_number)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.payout_account_holder)#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#pgFormYn('enable_qris')#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#pgFormYn('enable_ewallet')#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#pgFormYn('enable_va')#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#pgFormYn('enable_card')#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#pgFormYn('is_active')#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">
		)
	</cfquery>
</cfif>

<cfset extra = Len(apiError) ? "&warn=#URLEncodedFormat(apiError)#" : "">
<cflocation url="paymentProfile.cfm?msg=saved#extra#" addtoken="false">
