<!--- Payment Gateway: helpers + Xendit HTTP + banks + accounts --->
<cffunction name="pgAppOrEnv" access="public" returntype="string" output="false">
	<cfargument name="applicationKey" type="string" required="true">
	<cfargument name="envKey" type="string" required="true">
	<cfif StructKeyExists(APPLICATION, arguments.applicationKey) AND Len(Trim(ToString(APPLICATION[arguments.applicationKey])))>
		<cfreturn Trim(ToString(APPLICATION[arguments.applicationKey]))>
	</cfif>
	<cfset var env = CreateObject("java", "java.lang.System").getenv()>
	<cfset var val = env.get(JavaCast("string", arguments.envKey))>
	<cfif NOT IsNull(val)><cfreturn Trim(ToString(val))></cfif>
	<cfreturn "">
</cffunction>

<cffunction name="pgFormYn" access="public" returntype="string" output="false">
	<cfargument name="field" type="string" required="true">
	<cfif StructKeyExists(FORM, arguments.field) AND FORM[arguments.field] EQ "Y"><cfreturn "Y"></cfif>
	<cfreturn "N">
</cffunction>

<cffunction name="pgCountryCurrency" access="public" returntype="string" output="false">
	<cfargument name="countryCode" type="string" required="true">
	<cfargument name="fallback" type="string" required="false" default="IDR">
	<cfset var m = {ID="IDR",PH="PHP",MY="MYR",TH="THB",VN="VND"}>
	<cfset var cc = UCase(Trim(arguments.countryCode))>
	<cfif StructKeyExists(m, cc)><cfreturn m[cc]></cfif>
	<cfreturn arguments.fallback>
</cffunction>

<cffunction name="pgCurrencyToCountry" access="public" returntype="string" output="false">
	<cfargument name="v" type="string" required="true">
	<cfset var x = UCase(Trim(arguments.v))>
	<cfif Len(x) EQ 2><cfreturn x></cfif>
	<cfif x EQ "IDR"><cfreturn "ID"></cfif>
	<cfif x EQ "PHP"><cfreturn "PH"></cfif>
	<cfif x EQ "MYR"><cfreturn "MY"></cfif>
	<cfif x EQ "THB"><cfreturn "TH"></cfif>
	<cfif x EQ "VND"><cfreturn "VN"></cfif>
	<cfreturn "ID">
</cffunction>

<cffunction name="pgProfileDefaults" access="public" returntype="struct" output="false">
	<cfreturn {
		profile_id=0, business_email="", business_name="", business_description="",
		country_code="ID", account_type="MANAGED", xendit_account_id="", xendit_status="",
		xendit_callback_token="", payment_active=0, payment_methods_enabled="[]", va_banks_enabled="[]",
		payout_channel_code="", payout_channel_name="", payout_account_number="", payout_account_holder="",
		enable_qris="Y", enable_ewallet="Y", enable_va="Y", enable_card="N", is_active="Y", notes=""
	}>
</cffunction>

<cffunction name="pgPaymentStatusNormalized" access="public" returntype="string" output="false">
	<cfargument name="status" type="string" required="false" default="">
	<cfset var s = UCase(Trim(arguments.status))>
	<cfif NOT Len(s)><cfreturn "PENDING"></cfif>
	<cfif s EQ "LIVE"><cfreturn "LIVE"></cfif>
	<cfif s EQ "SUSPENDED"><cfreturn "SUSPENDED"></cfif>
	<cfif s EQ "REGISTERED"><cfreturn "REGISTERED"></cfif>
	<cfif ListFindNoCase("VERIFIED,ACTIVE,ENABLED", s)><cfreturn "LIVE"></cfif>
	<cfif ListFindNoCase("INACTIVE,DISABLED,BLOCKED", s)><cfreturn "SUSPENDED"></cfif>
	<cfreturn "REGISTERED">
</cffunction>

<cffunction name="pgSafeJsonArray" access="public" returntype="array" output="false">
	<cfargument name="raw" type="string" required="false" default="">
	<cfset var out = ArrayNew(1)>
	<cfif NOT Len(Trim(arguments.raw))><cfreturn out></cfif>
	<cftry>
		<cfset out = DeserializeJSON(arguments.raw)>
		<cfif NOT IsArray(out)><cfset out = ArrayNew(1)></cfif>
		<cfcatch type="any"><cfset out = ArrayNew(1)></cfcatch>
	</cftry>
	<cfreturn out>
</cffunction>

<cffunction name="pgApplyQuery" access="public" returntype="struct" output="false">
	<cfargument name="formStruct" required="true">
	<cfargument name="q" required="true">
	<cfif NOT arguments.q.recordCount><cfreturn arguments.formStruct></cfif>
	<cfloop list="#arguments.q.columnList#" index="col">
		<cfif StructKeyExists(arguments.formStruct, col)>
			<cfset arguments.formStruct[col] = arguments.q[col][1]>
		</cfif>
	</cfloop>
	<cfreturn arguments.formStruct>
</cffunction>

<cffunction name="pgCh" access="public" returntype="string" output="false">
	<cfargument name="channel" required="true">
	<cfargument name="field" type="string" required="true">
	<cfif NOT IsStruct(arguments.channel)><cfreturn ""></cfif>
	<cfif StructKeyExists(arguments.channel, arguments.field)><cfreturn Trim(ToString(arguments.channel[field]))></cfif>
	<cfset var u = UCase(arguments.field)>
	<cfif StructKeyExists(arguments.channel, u)><cfreturn Trim(ToString(arguments.channel[u]))></cfif>
	<cfreturn "">
</cffunction>

<cffunction name="pgXenditHttp" access="public" returntype="struct" output="false">
	<cfargument name="method" type="string" required="true">
	<cfargument name="path" type="string" required="true">
	<cfargument name="body" type="string" required="false" default="">
	<cfargument name="forUserId" type="string" required="false" default="">
	<cfargument name="queryString" type="string" required="false" default="">
	<cfset var result = {ok=false, httpStatus=0, rawBody="", data=StructNew()}>
	<cfset var url = REQUEST.xendit.apiBaseUrl & arguments.path>
	<cfif Len(arguments.queryString)><cfset url = url & "?" & arguments.queryString></cfif>
	<cftry>
		<cfhttp url="#url#" method="#UCase(arguments.method)#" result="local.http" timeout="60" charset="utf-8">
			<cfhttpparam type="header" name="Authorization" value="#REQUEST.xendit.authHeaderBasic#">
			<cfhttpparam type="header" name="Accept" value="application/json">
			<cfif Left(arguments.path, 4) EQ "/v3/">
				<cfhttpparam type="header" name="api-version" value="2024-11-11">
			</cfif>
			<cfif Len(Trim(arguments.forUserId))>
				<cfhttpparam type="header" name="for-user-id" value="#Trim(arguments.forUserId)#">
			</cfif>
			<cfif Len(arguments.body) AND ListFindNoCase("POST,PATCH,PUT", UCase(arguments.method))>
				<cfhttpparam type="header" name="Content-Type" value="application/json">
				<cfhttpparam type="body" value="#arguments.body#">
			</cfif>
		</cfhttp>
		<cfcatch type="any">
			<cfset result.rawBody = cfcatch.message>
			<cfreturn result>
		</cfcatch>
	</cftry>
	<cfif StructKeyExists(local.http, "statusCode") AND Len(local.http.statusCode)>
		<cfset result.httpStatus = Val(ListFirst(Trim(local.http.statusCode), " "))>
	<cfelseif StructKeyExists(local.http, "Statuscode") AND Len(local.http.Statuscode)>
		<cfset result.httpStatus = Val(ListFirst(Trim(local.http.Statuscode), " "))>
	</cfif>
	<cfif StructKeyExists(local.http, "fileContent") AND Len(local.http.fileContent)>
		<cfset result.rawBody = ToString(local.http.fileContent)>
	<cfelseif StructKeyExists(local.http, "Filecontent") AND Len(local.http.Filecontent)>
		<cfset result.rawBody = ToString(local.http.Filecontent)>
	</cfif>
	<cfif Len(result.rawBody) AND (Left(Trim(result.rawBody), 1) EQ "{" OR Left(Trim(result.rawBody), 1) EQ "[")>
		<cftry><cfset result.data = DeserializeJSON(result.rawBody)><cfcatch type="any"></cfcatch></cftry>
	</cfif>
	<cfset result.ok = (result.httpStatus GTE 200 AND result.httpStatus LT 300)>
	<cfreturn result>
</cffunction>

<cffunction name="pgXenditErr" access="public" returntype="string" output="false">
	<cfargument name="resp" type="struct" required="true">
	<cfif IsStruct(arguments.resp.data)>
		<cfif StructKeyExists(arguments.resp.data, "error_message") AND Len(arguments.resp.data.error_message)>
			<cfreturn arguments.resp.data.error_message>
		</cfif>
		<cfif StructKeyExists(arguments.resp.data, "message") AND Len(arguments.resp.data.message)>
			<cfreturn arguments.resp.data.message>
		</cfif>
	</cfif>
	<cfreturn "HTTP #arguments.resp.httpStatus#">
</cffunction>

<cffunction name="pgAsArray" access="public" returntype="array" output="false">
	<cfargument name="data" required="true">
	<cfif IsArray(arguments.data)><cfreturn arguments.data></cfif>
	<cfif IsStruct(arguments.data)>
		<cfif StructKeyExists(arguments.data, "channels") AND IsArray(arguments.data.channels)>
			<cfreturn arguments.data.channels>
		</cfif>
		<cfif StructKeyExists(arguments.data, "data") AND IsArray(arguments.data.data)>
			<cfreturn arguments.data.data>
		</cfif>
	</cfif>
	<cfreturn ArrayNew(1)>
</cffunction>

<cffunction name="pgFilterBanks" access="public" returntype="array" output="false">
	<cfargument name="channels" type="array" required="true">
	<cfset var out = ArrayNew(1)>
	<cfset var i = 0>
	<cfloop from="1" to="#ArrayLen(arguments.channels)#" index="i">
		<cfif NOT IsStruct(arguments.channels[i])><cfcontinue></cfif>
		<cfif StructKeyExists(arguments.channels[i], "channel_category")>
			<cfif UCase(Trim(arguments.channels[i].channel_category)) EQ "BANK">
				<cfset ArrayAppend(out, arguments.channels[i])>
			</cfif>
		<cfelse>
			<cfset ArrayAppend(out, arguments.channels[i])>
		</cfif>
	</cfloop>
	<cfif ArrayLen(out) EQ 0><cfreturn arguments.channels></cfif>
	<cfreturn out>
</cffunction>

<!--- Bank list from Xendit GET /payouts_channels only (no hardcoded fallback). --->
<cffunction name="pgLoadBanks" access="public" returntype="struct" output="false">
	<cfargument name="currency" type="string" required="false" default="IDR">
	<cfset var out = {ok=false, channels=ArrayNew(1), message="", httpStatus=0}>
	<cfset var cur = UCase(Trim(arguments.currency))>

	<cfif NOT StructKeyExists(REQUEST, "xendit") OR NOT REQUEST.xendit.isConfigured>
		<cfset out.message = "Xendit API key not set (pgConfig.cfm).">
		<cfreturn out>
	</cfif>
	<cfif NOT REQUEST.xendit.isActive>
		<cfset out.message = "Xendit is disabled. Set pg_xendit_enabled = Y.">
		<cfreturn out>
	</cfif>

	<cftry>
		<cfset var resp = pgXenditHttp("GET", "/payouts_channels", "", "", "currency=" & UrlEncodedFormat(cur))>
		<cfset out.httpStatus = resp.httpStatus>
		<cfif resp.ok>
			<cfset var list = pgFilterBanks(pgAsArray(resp.data))>
			<cfif ArrayLen(list) GT 0>
				<cfset out.channels = list>
				<cfset out.ok = true>
			<cfelse>
				<cfset out.message = "Xendit returned no bank channels for #cur#.">
			</cfif>
		<cfelse>
			<cfset out.message = pgXenditErr(resp)>
			<cfif resp.httpStatus EQ 403>
				<cfset out.message = "Cannot load banks from Xendit (HTTP 403). Enable Money-out permission on your API key.">
			</cfif>
		</cfif>
		<cfcatch type="any">
			<cfset out.message = cfcatch.message>
		</cfcatch>
	</cftry>
	<cfreturn out>
</cffunction>

<cffunction name="pgXenditCreateAccount" access="public" returntype="struct" output="false">
	<cfargument name="email" type="string" required="true">
	<cfargument name="accountType" type="string" required="false" default="MANAGED">
	<cfargument name="businessName" type="string" required="true">
	<cfargument name="description" type="string" required="false" default="">
	<cfargument name="country" type="string" required="false" default="ID">
	<cfset var payload = {
		"email": Trim(arguments.email),
		"type": UCase(Trim(arguments.accountType)),
		"public_profile": { "business_name": Trim(arguments.businessName) }
	}>
	<cfif Len(Trim(arguments.description))><cfset payload.public_profile.description = Trim(arguments.description)></cfif>
	<cfif Len(Trim(arguments.country)) EQ 2><cfset payload.country = UCase(Trim(arguments.country))></cfif>
	<cfreturn pgXenditHttp("POST", "/v2/accounts", SerializeJSON(payload))>
</cffunction>

<cffunction name="pgXenditUpdateAccount" access="public" returntype="struct" output="false">
	<cfargument name="accountId" type="string" required="true">
	<cfargument name="businessName" type="string" required="false" default="">
	<cfargument name="description" type="string" required="false" default="">
	<cfset var payload = { "public_profile": StructNew() }>
	<cfif Len(Trim(arguments.businessName))><cfset payload.public_profile.business_name = Trim(arguments.businessName)></cfif>
	<cfif Len(Trim(arguments.description))><cfset payload.public_profile.description = Trim(arguments.description)></cfif>
	<cfreturn pgXenditHttp("PATCH", "/v2/accounts/" & UrlEncodedFormat(Trim(arguments.accountId)), SerializeJSON(payload))>
</cffunction>

<cffunction name="pgXenditSyncAccount" access="public" returntype="struct" output="false">
	<cfargument name="accountId" type="string" required="true">
	<cfset var resp = pgXenditHttp("GET", "/v2/accounts/" & UrlEncodedFormat(Trim(arguments.accountId)))>
	<cfset var out = {ok=false, status="", type=""}>
	<cfif resp.ok AND IsStruct(resp.data)>
		<cfset out.ok = true>
		<cfif StructKeyExists(resp.data, "status")><cfset out.status = resp.data.status></cfif>
		<cfif StructKeyExists(resp.data, "type")><cfset out.type = resp.data.type></cfif>
	</cfif>
	<cfreturn out>
</cffunction>

<cffunction name="pgGetMerchantProfile" access="public" returntype="struct" output="false">
	<cfargument name="dsn" type="string" required="true">
	<cfset var p = pgProfileDefaults()>
	<cfset var methods = ArrayNew(1)>
	<cfset var methodList = "">
	<cfset p.ready = false>
	<cfset p.xendit_ready = false>
	<cftry>
		<cfquery name="local.q" datasource="#arguments.dsn#">
			SELECT * FROM pg_payment_profile
			WHERE is_active = <cfqueryparam cfsqltype="cf_sql_char" value="Y">
			ORDER BY profile_id LIMIT 1
		</cfquery>
		<cfif local.q.recordCount>
			<cfset p = pgApplyQuery(p, local.q)>
			<cfset p.ready = true>
			<cfset methods = pgSafeJsonArray(p.payment_methods_enabled)>
			<cfset methodList = UCase(ArrayToList(methods))>
			<!--- If JSON methods exist, mirror legacy flags used by customer checkout. --->
			<cfif ArrayLen(methods) GT 0>
				<cfset p.enable_va = ListFindNoCase(methodList, "VIRTUAL_ACCOUNT") ? "Y" : "N">
				<cfset p.enable_ewallet = ListFindNoCase(methodList, "EWALLET") ? "Y" : "N">
				<cfset p.enable_qris = ListFindNoCase(methodList, "QRIS") ? "Y" : "N">
			<cfelse>
				<!--- Backward compatibility when JSON columns are still empty. --->
				<cfif UCase(Trim(ToString(p.enable_va))) NEQ "Y" AND UCase(Trim(ToString(p.enable_va))) NEQ "N"><cfset p.enable_va = "Y"></cfif>
				<cfif UCase(Trim(ToString(p.enable_ewallet))) NEQ "Y" AND UCase(Trim(ToString(p.enable_ewallet))) NEQ "N"><cfset p.enable_ewallet = "Y"></cfif>
				<cfif UCase(Trim(ToString(p.enable_qris))) NEQ "Y" AND UCase(Trim(ToString(p.enable_qris))) NEQ "N"><cfset p.enable_qris = "Y"></cfif>
				<cfif UCase(Trim(ToString(p.enable_card))) NEQ "Y" AND UCase(Trim(ToString(p.enable_card))) NEQ "N"><cfset p.enable_card = "N"></cfif>
			</cfif>
			<cfset p.payment_active = (p.enable_va EQ "Y" OR p.enable_ewallet EQ "Y" OR p.enable_qris EQ "Y" OR p.enable_card EQ "Y") ? 1 : 0>
			<!--- Direct master mode does not require xendit_account_id. --->
			<cfset p.xendit_ready = UCase(Trim(p.xendit_status)) EQ "LIVE">
		</cfif>
		<cfcatch type="any"></cfcatch>
	</cftry>
	<cfreturn p>
</cffunction>

<cffunction name="pgVaBankCode" access="public" returntype="string" output="false">
	<cfargument name="payoutChannelCode" type="string" required="true">
	<cfset var c = UCase(Trim(arguments.payoutChannelCode))>
	<cfif Left(c, 3) EQ "ID_"><cfset c = Right(c, Len(c) - 3)></cfif>
	<cfif c EQ "MANDIRI"><cfreturn "MANDIRI_VIRTUAL_ACCOUNT"></cfif>
	<cfif c EQ "BCA"><cfreturn "BCA_VIRTUAL_ACCOUNT"></cfif>
	<cfif c EQ "BNI"><cfreturn "BNI_VIRTUAL_ACCOUNT"></cfif>
	<cfif c EQ "BRI"><cfreturn "BRI_VIRTUAL_ACCOUNT"></cfif>
	<cfif c EQ "PERMATA"><cfreturn "PERMATA_VIRTUAL_ACCOUNT"></cfif>
	<cfif FindNoCase("_VIRTUAL_ACCOUNT", c)><cfreturn c></cfif>
	<cfreturn c & "_VIRTUAL_ACCOUNT">
</cffunction>

<cffunction name="pgParsePayActions" access="public" returntype="struct" output="false">
	<cfargument name="data" required="true">
	<cfset var out = {redirectUrl="", qrString="", vaNumber="", deeplink="", rawActions=ArrayNew(1)}>
	<cfset var pm = StructNew()>
	<cfset var pmType = "">
	<cfset var qrCode = StructNew()>
	<cfset var qrProps = StructNew()>
	<cfset var vaObj = StructNew()>
	<cfset var vaProps = StructNew()>
	<cfset var ewalletObj = StructNew()>
	<cfset var ewalletProps = StructNew()>
	<cfset var actionsObj = StructNew()>
	<cfif NOT IsStruct(arguments.data) OR NOT StructKeyExists(arguments.data, "actions") OR NOT IsArray(arguments.data.actions)>
		<cfset out.rawActions = ArrayNew(1)>
	<cfelse>
		<cfset out.rawActions = arguments.data.actions>
		<cfset var i = 0>
		<cfset var a = "">
		<cfloop from="1" to="#ArrayLen(arguments.data.actions)#" index="i">
			<cfset a = arguments.data.actions[i]>
			<cfif NOT IsStruct(a)><cfcontinue></cfif>
			<cfif StructKeyExists(a, "descriptor") AND StructKeyExists(a, "value")>
				<cfif FindNoCase("QR", a.descriptor)>
					<cfset out.qrString = a.value>
				</cfif>
				<cfif FindNoCase("VIRTUAL_ACCOUNT", a.descriptor) OR FindNoCase("ACCOUNT", a.descriptor)>
					<cfset out.vaNumber = a.value>
				</cfif>
				<cfif NOT len(out.redirectUrl) AND UCase(Trim(ToString(a.descriptor))) EQ "WEB_URL">
					<cfset out.redirectUrl = ToString(a.value)>
				</cfif>
				<cfif NOT len(out.deeplink) AND UCase(Trim(ToString(a.descriptor))) EQ "DEEPLINK_URL">
					<cfset out.deeplink = ToString(a.value)>
				</cfif>
			</cfif>
			<cfif StructKeyExists(a, "type") AND UCase(Trim(ToString(a.type))) EQ "REDIRECT_CUSTOMER" AND StructKeyExists(a, "url") AND NOT len(out.redirectUrl)>
				<cfset out.redirectUrl = ToString(a.url)>
			</cfif>
		</cfloop>
	</cfif>

	<!--- Legacy / alternate shape: actions as object with checkout urls. --->
	<cfif StructKeyExists(arguments.data, "actions") AND IsStruct(arguments.data.actions)>
		<cfset actionsObj = arguments.data.actions>
		<cfif NOT len(out.redirectUrl)>
			<cfif StructKeyExists(actionsObj, "mobile_web_checkout_url") AND Len(Trim(ToString(actionsObj.mobile_web_checkout_url)))>
				<cfset out.redirectUrl = Trim(ToString(actionsObj.mobile_web_checkout_url))>
			<cfelseif StructKeyExists(actionsObj, "desktop_web_checkout_url") AND Len(Trim(ToString(actionsObj.desktop_web_checkout_url)))>
				<cfset out.redirectUrl = Trim(ToString(actionsObj.desktop_web_checkout_url))>
			<cfelseif StructKeyExists(actionsObj, "web_url") AND Len(Trim(ToString(actionsObj.web_url)))>
				<cfset out.redirectUrl = Trim(ToString(actionsObj.web_url))>
			</cfif>
		</cfif>
		<cfif NOT len(out.deeplink)>
			<cfif StructKeyExists(actionsObj, "mobile_deeplink_checkout_url") AND Len(Trim(ToString(actionsObj.mobile_deeplink_checkout_url)))>
				<cfset out.deeplink = Trim(ToString(actionsObj.mobile_deeplink_checkout_url))>
			<cfelseif StructKeyExists(actionsObj, "deeplink_url") AND Len(Trim(ToString(actionsObj.deeplink_url)))>
				<cfset out.deeplink = Trim(ToString(actionsObj.deeplink_url))>
			</cfif>
		</cfif>
	</cfif>

	<!--- Fallback parsing for Payment Request response shapes without actions[] --->
	<cfif StructKeyExists(arguments.data, "payment_method") AND IsStruct(arguments.data.payment_method)>
		<cfset pm = arguments.data.payment_method>
		<cfif StructKeyExists(pm, "type")><cfset pmType = UCase(Trim(ToString(pm.type)))></cfif>

		<cfif pmType EQ "QR_CODE" AND StructKeyExists(pm, "qr_code") AND IsStruct(pm.qr_code)>
			<cfset qrCode = pm.qr_code>
			<cfif NOT len(out.qrString) AND StructKeyExists(qrCode, "qr_string") AND Len(Trim(ToString(qrCode.qr_string)))>
				<cfset out.qrString = Trim(ToString(qrCode.qr_string))>
			</cfif>
			<cfif StructKeyExists(qrCode, "channel_properties") AND IsStruct(qrCode.channel_properties)>
				<cfset qrProps = qrCode.channel_properties>
				<cfif NOT len(out.qrString) AND StructKeyExists(qrProps, "qr_string") AND Len(Trim(ToString(qrProps.qr_string)))>
					<cfset out.qrString = Trim(ToString(qrProps.qr_string))>
				</cfif>
			</cfif>
		</cfif>

		<cfif pmType EQ "VIRTUAL_ACCOUNT" AND StructKeyExists(pm, "virtual_account") AND IsStruct(pm.virtual_account)>
			<cfset vaObj = pm.virtual_account>
			<cfif NOT len(out.vaNumber) AND StructKeyExists(vaObj, "account_number") AND Len(Trim(ToString(vaObj.account_number)))>
				<cfset out.vaNumber = Trim(ToString(vaObj.account_number))>
			</cfif>
			<cfif StructKeyExists(vaObj, "channel_properties") AND IsStruct(vaObj.channel_properties)>
				<cfset vaProps = vaObj.channel_properties>
				<cfif NOT len(out.vaNumber) AND StructKeyExists(vaProps, "virtual_account_number") AND Len(Trim(ToString(vaProps.virtual_account_number)))>
					<cfset out.vaNumber = Trim(ToString(vaProps.virtual_account_number))>
				</cfif>
			</cfif>
		</cfif>

		<cfif pmType EQ "EWALLET" AND StructKeyExists(pm, "ewallet") AND IsStruct(pm.ewallet)>
			<cfset ewalletObj = pm.ewallet>
			<cfif StructKeyExists(ewalletObj, "channel_properties") AND IsStruct(ewalletObj.channel_properties)>
				<cfset ewalletProps = ewalletObj.channel_properties>
				<cfif NOT len(out.redirectUrl) AND StructKeyExists(ewalletProps, "mobile_web_checkout_url") AND Len(Trim(ToString(ewalletProps.mobile_web_checkout_url)))>
					<cfset out.redirectUrl = Trim(ToString(ewalletProps.mobile_web_checkout_url))>
				</cfif>
			</cfif>
		</cfif>
	</cfif>

	<cfif NOT len(out.redirectUrl) AND StructKeyExists(arguments.data, "checkout_url") AND Len(Trim(ToString(arguments.data.checkout_url)))>
		<cfset out.redirectUrl = Trim(ToString(arguments.data.checkout_url))>
	</cfif>
	<cfif NOT len(out.qrString) AND StructKeyExists(arguments.data, "qr_string") AND Len(Trim(ToString(arguments.data.qr_string)))>
		<cfset out.qrString = Trim(ToString(arguments.data.qr_string))>
	</cfif>

	<cfreturn out>
</cffunction>

<cffunction name="pgCreatePaymentRequest" access="public" returntype="struct" output="false">
	<cfargument name="forUserId" type="string" required="true">
	<cfargument name="amount" type="numeric" required="true">
	<cfargument name="currency" type="string" required="false" default="IDR">
	<cfargument name="country" type="string" required="false" default="ID">
	<cfargument name="payMethod" type="string" required="true">
	<cfargument name="referenceId" type="string" required="true">
	<cfargument name="successReturnUrl" type="string" required="true">
	<cfargument name="failureReturnUrl" type="string" required="false" default="">
	<cfargument name="customerName" type="string" required="false" default="Customer">
	<cfargument name="ewalletChannel" type="string" required="false" default="">
	<cfargument name="ewalletMobile" type="string" required="false" default="">
	<cfargument name="vaBankCode" type="string" required="false" default="BRI">

	<cfset var amt = Int(Val(arguments.amount))>
	<cfif amt LT 1><cfset amt = 1></cfif>
	<cfset var payload = {
		"reference_id": arguments.referenceId,
		"type": "PAY",
		"request_amount": amt,
		"capture_method": "AUTOMATIC",
		"currency": UCase(Trim(arguments.currency)),
		"country": UCase(Trim(arguments.country))
	}>
	<cfset var method = LCase(Trim(arguments.payMethod))>
	<cfset var expiresAt = DateAdd("h", 24, Now())>
	<cfset var expIso = DateFormat(expiresAt, "yyyy-mm-dd") & "T" & TimeFormat(expiresAt, "HH:mm:ss") & "Z">
	<cfset var failUrl = Len(arguments.failureReturnUrl) ? arguments.failureReturnUrl : arguments.successReturnUrl>
	<cfset var cancelUrl = failUrl>
	<cfset var parts = ArrayNew(1)>
	<cfset var firstName = "Customer">
	<cfset var surname = "">
	<cfset var vaCode = "">
	<cfset var legacyPayload = StructNew()>

	<cfif method EQ "qris">
		<cfset payload.channel_code = "QRIS">
		<cfset payload.channel_properties = {
			"expires_at": expIso,
			"qr_string_type": "DYNAMIC"
		}>
	<cfelseif method EQ "ewallet">
		<cfset var ewCh = UCase(Trim(arguments.ewalletChannel))>
		<cfset var ewMobile = ReReplace(Trim(arguments.ewalletMobile), "[^0-9]", "", "all")>
		<cfset var ewProps = {
			"success_return_url": arguments.successReturnUrl,
			"failure_return_url": failUrl,
			"cancel_return_url": cancelUrl
		}>
		<cfif Left(ewCh, 3) EQ "ID_"><cfset ewCh = Right(ewCh, Len(ewCh) - 3)></cfif>
		<cfif ewCh EQ "GO_PAY"><cfset ewCh = "GOPAY"></cfif>
		<cfif NOT len(ewCh)><cfset ewCh = "OVO"></cfif>
		<cfif ewCh EQ "OVO">
			<cfif Left(ewMobile, 1) EQ "0">
				<cfset ewMobile = "62" & Mid(ewMobile, 2, Len(ewMobile) - 1)>
			<cfelseif Left(ewMobile, 2) NEQ "62">
				<cfset ewMobile = "62" & ewMobile>
			</cfif>
			<cfif len(ewMobile)>
				<cfset ewProps.mobile_number = ewMobile>
			</cfif>
		</cfif>
		<cfset payload.channel_code = ewCh>
		<cfset payload.channel_properties = ewProps>
	<cfelseif method EQ "va">
		<cfset vaCode = UCase(Trim(arguments.vaBankCode))>
		<cfif NOT len(vaCode)><cfset vaCode = "BRI_VIRTUAL_ACCOUNT"></cfif>
		<cfif Left(vaCode, 3) EQ "ID_">
			<cfset vaCode = Right(vaCode, Len(vaCode) - 3) & "_VIRTUAL_ACCOUNT">
		</cfif>
		<cfif NOT FindNoCase("_VIRTUAL_ACCOUNT", vaCode)>
			<cfset vaCode = vaCode & "_VIRTUAL_ACCOUNT">
		</cfif>
		<cfset payload.channel_code = vaCode>
		<cfset payload.channel_properties = {
			"customer_name": Left(Trim(arguments.customerName), 50),
			"expires_at": expIso
		}>
	<cfelseif method EQ "card">
		<cfset payload.channel_code = "CARDS">
		<cfset payload.channel_properties = {
			"success_return_url": arguments.successReturnUrl,
			"failure_return_url": failUrl,
			"cancel_return_url": cancelUrl
		}>
	<cfelse>
		<cfreturn {ok=false, httpStatus=0, message="Unknown payment method", data=StructNew(), actions=StructNew()}>
	</cfif>
	<cfif len(trim(arguments.customerName))>
		<cfset parts = ListToArray(ReReplace(trim(arguments.customerName), "\s+", " ", "all"), " ")>
		<cfif ArrayLen(parts) GTE 1><cfset firstName = Left(parts[1], 50)></cfif>
		<cfif ArrayLen(parts) GTE 2><cfset surname = Left(parts[2], 50)></cfif>
	</cfif>
	<cfset payload.customer = {
		"type": "INDIVIDUAL",
		"reference_id": arguments.referenceId,
		"individual_detail": {"given_names": firstName}
	}>
	<cfif len(surname)>
		<cfset payload.customer.individual_detail.surname = surname>
	</cfif>
	<cfif NOT StructKeyExists(payload, "channel_code") OR NOT len(Trim(ToString(payload.channel_code)))>
		<cfreturn {
			ok=false,
			httpStatus=0,
			message="Invalid request setup: channel_code is empty for method " & method,
			data=payload,
			actions=StructNew(),
			paymentRequestId=""
		}>
	</cfif>

	<cfset var resp = pgXenditHttp("POST", "/v3/payment_requests", SerializeJSON(payload), arguments.forUserId)>
	<cfif NOT resp.ok AND FindNoCase("Either channel_code or payment_token_id is required", pgXenditErr(resp))>
		<cfset legacyPayload = {
			"reference_id": arguments.referenceId,
			"amount": amt,
			"currency": UCase(Trim(arguments.currency)),
			"country": UCase(Trim(arguments.country))
		}>
		<cfif method EQ "qris">
			<cfset legacyPayload.payment_method = {
				"type": "QR_CODE",
				"reusability": "ONE_TIME_USE",
				"qr_code": { "channel_code": "QRIS" }
			}>
		<cfelseif method EQ "ewallet">
			<cfset legacyPayload.payment_method = {
				"type": "EWALLET",
				"reusability": "ONE_TIME_USE",
				"ewallet": {
					"channel_code": payload.channel_code,
					"channel_properties": payload.channel_properties
				}
			}>
		<cfelseif method EQ "va">
			<cfset legacyPayload.payment_method = {
				"type": "VIRTUAL_ACCOUNT",
				"reusability": "ONE_TIME_USE",
				"reference_id": arguments.referenceId & "-va",
				"virtual_account": {
					"channel_code": payload.channel_code,
					"channel_properties": payload.channel_properties
				}
			}>
		<cfelseif method EQ "card">
			<cfset legacyPayload.payment_method = {
				"type": "CARD",
				"reusability": "ONE_TIME_USE",
				"card": { "channel_properties": payload.channel_properties }
			}>
		</cfif>
		<cfset resp = pgXenditHttp("POST", "/payment_requests", SerializeJSON(legacyPayload), arguments.forUserId)>
	</cfif>
	<cfset var out = {ok=resp.ok, httpStatus=resp.httpStatus, message=pgXenditErr(resp), data=resp.data, actions=pgParsePayActions(resp.data), paymentRequestId=""}>
	<cfif IsStruct(resp.data) AND StructKeyExists(resp.data, "payment_request_id")>
		<cfset out.paymentRequestId = resp.data.payment_request_id>
	<cfelseif IsStruct(resp.data) AND StructKeyExists(resp.data, "id")>
		<cfset out.paymentRequestId = resp.data.id>
	</cfif>
	<cfreturn out>
</cffunction>

<cffunction name="pgGetPaymentRequest" access="public" returntype="struct" output="false">
	<cfargument name="forUserId" type="string" required="true">
	<cfargument name="paymentRequestId" type="string" required="true">
	<cfset var resp = pgXenditHttp("GET", "/v3/payment_requests/" & UrlEncodedFormat(Trim(arguments.paymentRequestId)), "", arguments.forUserId)>
	<cfset var st = "">
	<cfif IsStruct(resp.data) AND StructKeyExists(resp.data, "status")><cfset st = resp.data.status></cfif>
	<cfreturn {ok=resp.ok, httpStatus=resp.httpStatus, status=st, data=resp.data, isPaid=(UCase(st) EQ "SUCCEEDED")}>
</cffunction>

<!--- Step-2 service wrappers for Master Account mode. --->
<cffunction name="pgVerifyConnection" access="public" returntype="struct" output="false">
	<cfset var out = {connected=false, balance=0, currency="IDR"}>
	<cfset var resp = StructNew()>
	<cfif NOT StructKeyExists(REQUEST, "xendit") OR NOT REQUEST.xendit.isConfigured>
		<cfreturn out>
	</cfif>
	<cfset resp = pgXenditHttp("GET", "/balance")>
	<cfif resp.ok>
		<cfset out.connected = true>
		<cfif IsStruct(resp.data)>
			<cfif StructKeyExists(resp.data, "balance")><cfset out.balance = Val(resp.data.balance)></cfif>
			<cfif StructKeyExists(resp.data, "currency") AND Len(Trim(ToString(resp.data.currency)))><cfset out.currency = UCase(Trim(ToString(resp.data.currency)))></cfif>
		</cfif>
	</cfif>
	<cfreturn out>
</cffunction>

<cffunction name="pgThrowReadableXenditError" access="public" returntype="void" output="false">
	<cfargument name="message" type="string" required="true">
	<cfthrow type="PaymentGateway.XenditError" message="#arguments.message#">
</cffunction>

<cffunction name="pgCreateVirtualAccount" access="public" returntype="struct" output="false">
	<cfargument name="payload" type="struct" required="true">
	<cfset var out = StructNew()>
	<cfset var amount = Int(Val(arguments.payload.amount))>
	<cfset var x = StructNew()>
	<cfset var actions = StructNew()>
	<cfif amount LT 1><cfset pgThrowReadableXenditError("Nominal Virtual Account tidak valid.")></cfif>
	<cfif NOT StructKeyExists(arguments.payload, "reference_id") OR NOT Len(Trim(ToString(arguments.payload.reference_id)))>
		<cfset pgThrowReadableXenditError("reference_id wajib diisi untuk Virtual Account.")>
	</cfif>
	<cfset x = pgCreatePaymentRequest(
		"",
		amount,
		"IDR",
		"ID",
		"va",
		Trim(ToString(arguments.payload.reference_id)),
		"",
		"",
		StructKeyExists(arguments.payload, "customer_name") ? Trim(ToString(arguments.payload.customer_name)) : "Customer",
		"",
		"",
		StructKeyExists(arguments.payload, "bank_code") ? Trim(ToString(arguments.payload.bank_code)) : "BRI"
	)>
	<cfif NOT x.ok>
		<cfset pgThrowReadableXenditError("Gagal membuat Virtual Account: " & x.message)>
	</cfif>
	<cfset actions = pgParsePayActions(x.data)>
	<cfset out = {
		"payment_request_id" = x.paymentRequestId,
		"va_number" = actions.vaNumber,
		"expires_at" = "",
		"raw" = x.data
	}>
	<cfif IsStruct(x.data) AND StructKeyExists(x.data, "channel_properties") AND IsStruct(x.data.channel_properties) AND StructKeyExists(x.data.channel_properties, "expires_at")>
		<cfset out.expires_at = ToString(x.data.channel_properties.expires_at)>
	</cfif>
	<cfreturn out>
</cffunction>

<cffunction name="pgCreateEwalletCharge" access="public" returntype="struct" output="false">
	<cfargument name="payload" type="struct" required="true">
	<cfset var out = StructNew()>
	<cfset var amount = Int(Val(arguments.payload.amount))>
	<cfset var x = StructNew()>
	<cfset var actions = StructNew()>
	<cfif amount LT 1><cfset pgThrowReadableXenditError("Nominal e-wallet tidak valid.")></cfif>
	<cfif NOT StructKeyExists(arguments.payload, "reference_id") OR NOT Len(Trim(ToString(arguments.payload.reference_id)))>
		<cfset pgThrowReadableXenditError("reference_id wajib diisi untuk e-wallet.")>
	</cfif>
	<cfif NOT StructKeyExists(arguments.payload, "channel_code") OR NOT Len(Trim(ToString(arguments.payload.channel_code)))>
		<cfset pgThrowReadableXenditError("channel_code e-wallet wajib diisi.")>
	</cfif>
	<cfset x = pgCreatePaymentRequest(
		"",
		amount,
		"IDR",
		"ID",
		"ewallet",
		Trim(ToString(arguments.payload.reference_id)),
		StructKeyExists(arguments.payload, "success_redirect_url") ? Trim(ToString(arguments.payload.success_redirect_url)) : "",
		"",
		StructKeyExists(arguments.payload, "customer_name") ? Trim(ToString(arguments.payload.customer_name)) : "Customer",
		Trim(ToString(arguments.payload.channel_code)),
		StructKeyExists(arguments.payload, "mobile_number") ? Trim(ToString(arguments.payload.mobile_number)) : "",
		""
	)>
	<cfif NOT x.ok>
		<cfset pgThrowReadableXenditError("Gagal membuat charge e-wallet: " & x.message)>
	</cfif>
	<cfset actions = pgParsePayActions(x.data)>
	<cfset out = {
		"payment_request_id" = x.paymentRequestId,
		"checkout_url" = Len(actions.redirectUrl) ? actions.redirectUrl : actions.deeplink,
		"raw" = x.data
	}>
	<cfreturn out>
</cffunction>

<cffunction name="pgCreateQrisCharge" access="public" returntype="struct" output="false">
	<cfargument name="payload" type="struct" required="true">
	<cfset var out = StructNew()>
	<cfset var amount = Int(Val(arguments.payload.amount))>
	<cfset var x = StructNew()>
	<cfset var actions = StructNew()>
	<cfif amount LT 1><cfset pgThrowReadableXenditError("Nominal QRIS tidak valid.")></cfif>
	<cfif NOT StructKeyExists(arguments.payload, "reference_id") OR NOT Len(Trim(ToString(arguments.payload.reference_id)))>
		<cfset pgThrowReadableXenditError("reference_id wajib diisi untuk QRIS.")>
	</cfif>
	<cfset x = pgCreatePaymentRequest(
		"",
		amount,
		"IDR",
		"ID",
		"qris",
		Trim(ToString(arguments.payload.reference_id)),
		"",
		"",
		"Customer",
		"",
		"",
		""
	)>
	<cfif NOT x.ok>
		<cfset pgThrowReadableXenditError("Gagal membuat charge QRIS: " & x.message)>
	</cfif>
	<cfset actions = pgParsePayActions(x.data)>
	<cfset out = {
		"payment_request_id" = x.paymentRequestId,
		"qr_string" = actions.qrString,
		"qr_image_url" = Len(actions.qrString) ? ("https://api.qrserver.com/v1/create-qr-code/?size=260x260&data=" & UrlEncodedFormat(actions.qrString)) : "",
		"raw" = x.data
	}>
	<cfreturn out>
</cffunction>

<cffunction name="pgGetPaymentStatusById" access="public" returntype="struct" output="false">
	<cfargument name="paymentRequestId" type="string" required="true">
	<cfset var x = StructNew()>
	<cfif NOT Len(Trim(arguments.paymentRequestId))>
		<cfset pgThrowReadableXenditError("payment_request_id wajib diisi.")>
	</cfif>
	<cfset x = pgGetPaymentRequest("", Trim(arguments.paymentRequestId))>
	<cfif NOT x.ok>
		<cfset pgThrowReadableXenditError("Gagal mengambil status pembayaran: HTTP " & x.httpStatus)>
	</cfif>
	<cfreturn {
		"status" = UCase(Trim(x.status)),
		"is_paid" = x.isPaid,
		"details" = x.data
	}>
</cffunction>

<cffunction name="pgValidateWebhookToken" access="public" returntype="boolean" output="false">
	<cfargument name="callbackToken" type="string" required="true">
	<cfargument name="receivedToken" type="string" required="true">
	<cfset var expected = Trim(arguments.callbackToken)>
	<cfset var actual = Trim(arguments.receivedToken)>
	<cfif NOT Len(expected)><cfreturn false></cfif>
	<cfif NOT Len(actual)><cfreturn false></cfif>
	<cfreturn expected EQ actual>
</cffunction>

<!--- Aliases with generic service naming from implementation checklist. --->
<cffunction name="verifyConnection" access="public" returntype="struct" output="false">
	<cfreturn pgVerifyConnection()>
</cffunction>

<cffunction name="createVirtualAccount" access="public" returntype="struct" output="false">
	<cfargument name="payload" type="struct" required="true">
	<cfreturn pgCreateVirtualAccount(arguments.payload)>
</cffunction>

<cffunction name="createEwalletCharge" access="public" returntype="struct" output="false">
	<cfargument name="payload" type="struct" required="true">
	<cfreturn pgCreateEwalletCharge(arguments.payload)>
</cffunction>

<cffunction name="createQrisCharge" access="public" returntype="struct" output="false">
	<cfargument name="payload" type="struct" required="true">
	<cfreturn pgCreateQrisCharge(arguments.payload)>
</cffunction>

<cffunction name="getPaymentStatus" access="public" returntype="struct" output="false">
	<cfargument name="payment_request_id" type="string" required="true">
	<cfreturn pgGetPaymentStatusById(arguments.payment_request_id)>
</cffunction>

<cffunction name="validateWebhook" access="public" returntype="boolean" output="false">
	<cfargument name="callbackToken" type="string" required="true">
	<cfargument name="receivedToken" type="string" required="true">
	<cfreturn pgValidateWebhookToken(arguments.callbackToken, arguments.receivedToken)>
</cffunction>

<cffunction name="pgStatus" access="public" returntype="struct" output="false">
	<cfargument name="qProfile" required="false" default="#QueryNew('profile_id')#">
	<cfset var s = {api=false, xp=false, bank=false, linked=false, live=false}>
	<cfif StructKeyExists(REQUEST, "xendit") AND REQUEST.xendit.isActive>
		<cfset var ping = pgXenditHttp("GET", "/balance")>
		<cfset s.api = (ping.httpStatus EQ 200 OR ping.httpStatus EQ 403)>
		<cfset var xp = pgXenditHttp("GET", "/v2/accounts", "", "", "limit=1")>
		<cfset s.xp = (xp.httpStatus EQ 200)>
	</cfif>
	<cfif arguments.qProfile.recordCount>
		<cfif Len(Trim(arguments.qProfile.payout_channel_code)) AND Len(Trim(arguments.qProfile.payout_account_number))>
			<cfset s.bank = true>
		</cfif>
		<cfif Len(Trim(arguments.qProfile.xendit_account_id))>
			<cfset s.linked = true>
			<cfif UCase(Trim(arguments.qProfile.xendit_status)) EQ "LIVE"><cfset s.live = true></cfif>
		</cfif>
	</cfif>
	<cfreturn s>
</cffunction>
