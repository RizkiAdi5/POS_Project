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
		payout_channel_code="", payout_channel_name="", payout_account_number="", payout_account_holder="",
		enable_qris="Y", enable_ewallet="Y", enable_va="Y", enable_card="N", is_active="Y", notes=""
	}>
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
			<cfset p.xendit_ready = Len(Trim(p.xendit_account_id)) GT 0 AND UCase(Trim(p.xendit_status)) EQ "LIVE">
		</cfif>
		<cfcatch type="any"></cfcatch>
	</cftry>
	<cfreturn p>
</cffunction>

<cffunction name="pgVaBankCode" access="public" returntype="string" output="false">
	<cfargument name="payoutChannelCode" type="string" required="true">
	<cfset var c = UCase(Trim(arguments.payoutChannelCode))>
	<cfif Left(c, 3) EQ "ID_"><cfset c = Right(c, Len(c) - 3)></cfif>
	<cfif c EQ "MANDIRI"><cfreturn "MANDIRI"></cfif>
	<cfreturn c>
</cffunction>

<cffunction name="pgParsePayActions" access="public" returntype="struct" output="false">
	<cfargument name="data" required="true">
	<cfset var out = {redirectUrl="", qrString="", vaNumber="", deeplink="", rawActions=ArrayNew(1)}>
	<cfif NOT IsStruct(arguments.data) OR NOT StructKeyExists(arguments.data, "actions") OR NOT IsArray(arguments.data.actions)>
		<cfreturn out>
	</cfif>
	<cfset out.rawActions = arguments.data.actions>
	<cfset var i = 0>
	<cfset var a = "">
	<cfloop from="1" to="#ArrayLen(arguments.data.actions)#" index="i">
		<cfset a = arguments.data.actions[i]>
		<cfif NOT IsStruct(a)><cfcontinue></cfif>
		<cfif StructKeyExists(a, "type") AND UCase(a.type) EQ "REDIRECT_CUSTOMER" AND StructKeyExists(a, "url")>
			<cfset out.redirectUrl = a.url>
		</cfif>
		<cfif StructKeyExists(a, "type") AND UCase(a.type) EQ "DEEPLINK" AND StructKeyExists(a, "url")>
			<cfset out.deeplink = a.url>
		</cfif>
		<cfif StructKeyExists(a, "descriptor") AND StructKeyExists(a, "value")>
			<cfif FindNoCase("QR", a.descriptor)>
				<cfset out.qrString = a.value>
			</cfif>
			<cfif FindNoCase("VIRTUAL_ACCOUNT", a.descriptor) OR FindNoCase("ACCOUNT", a.descriptor)>
				<cfset out.vaNumber = a.value>
			</cfif>
		</cfif>
	</cfloop>
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
	<cfargument name="vaBankCode" type="string" required="false" default="BCA">

	<cfset var amt = Int(Val(arguments.amount))>
	<cfif amt LT 1><cfset amt = 1></cfif>
	<cfset var payload = {
		"reference_id": arguments.referenceId,
		"amount": amt,
		"currency": UCase(Trim(arguments.currency)),
		"country": UCase(Trim(arguments.country))
	}>
	<cfset var method = LCase(Trim(arguments.payMethod))>
	<cfset var expiresAt = DateAdd("h", 24, Now())>
	<cfset var expIso = DateFormat(expiresAt, "yyyy-mm-dd") & "T" & TimeFormat(expiresAt, "HH:mm:ss") & "Z">

	<cfif method EQ "qris">
		<cfset payload.payment_method = {
			"type": "QR_CODE",
			"reusability": "ONE_TIME_USE",
			"qr_code": { "channel_code": "QRIS" }
		}>
	<cfelseif method EQ "ewallet">
		<cfset var ewCh = UCase(Trim(arguments.ewalletChannel))>
		<cfif Left(ewCh, 3) EQ "ID_"><cfset ewCh = Right(ewCh, Len(ewCh) - 3)></cfif>
		<cfset payload.payment_method = {
			"type": "EWALLET",
			"reusability": "ONE_TIME_USE",
			"ewallet": {
				"channel_code": ewCh,
				"channel_properties": { "success_return_url": arguments.successReturnUrl }
			}
		}>
	<cfelseif method EQ "va">
		<cfset payload.payment_method = {
			"type": "VIRTUAL_ACCOUNT",
			"reusability": "ONE_TIME_USE",
			"reference_id": arguments.referenceId & "-va",
			"virtual_account": {
				"channel_code": UCase(Trim(arguments.vaBankCode)),
				"channel_properties": {
					"customer_name": Left(Trim(arguments.customerName), 50),
					"expires_at": expIso
				}
			}
		}>
	<cfelseif method EQ "card">
		<cfset payload.payment_method = {
			"type": "CARD",
			"reusability": "ONE_TIME_USE",
			"card": {
				"channel_properties": {
					"success_return_url": arguments.successReturnUrl,
					"failure_return_url": Len(arguments.failureReturnUrl) ? arguments.failureReturnUrl : arguments.successReturnUrl
				}
			}
		}>
	<cfelse>
		<cfreturn {ok=false, httpStatus=0, message="Unknown payment method", data=StructNew(), actions=StructNew()}>
	</cfif>

	<cfset var resp = pgXenditHttp("POST", "/payment_requests", SerializeJSON(payload), arguments.forUserId)>
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
	<cfset var resp = pgXenditHttp("GET", "/payment_requests/" & UrlEncodedFormat(Trim(arguments.paymentRequestId)), "", arguments.forUserId)>
	<cfset var st = "">
	<cfif IsStruct(resp.data) AND StructKeyExists(resp.data, "status")><cfset st = resp.data.status></cfif>
	<cfreturn {ok=resp.ok, httpStatus=resp.httpStatus, status=st, data=resp.data, isPaid=(UCase(st) EQ "SUCCEEDED")}>
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
