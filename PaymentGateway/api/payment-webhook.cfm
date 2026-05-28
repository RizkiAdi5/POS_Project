<cfinclude template="/application.cfm">
<cfinclude template="/latest/customer/inc_emenu_order.cfm">
<cfinclude template="/latest/customer/inc_xendit_pay.cfm">
<cfsetting showdebugoutput="false">
<cfcontent type="application/json; charset=utf-8" reset="true">

<cfset reqData = GetHttpRequestData()>
<cfset token = "">
<cfset raw = ToString(reqData.content)>
<cfset evt = StructNew()>
<cfset data = StructNew()>
<cfset prId = "">
<cfset refId = "">
<cfset payStatus = "">
<cfset payIdFromRef = 0>

<cfif IsStruct(reqData) AND StructKeyExists(reqData, "headers") AND IsStruct(reqData.headers)>
	<cfif StructKeyExists(reqData.headers, "x-callback-token")><cfset token = reqData.headers["x-callback-token"]></cfif>
	<cfif NOT Len(token) AND StructKeyExists(reqData.headers, "X-Callback-Token")><cfset token = reqData.headers["X-Callback-Token"]></cfif>
</cfif>

<!--- Always return HTTP 200 so Xendit does not keep retrying. --->
<cfif Len(REQUEST.xendit.webhookToken) AND NOT validateWebhook(REQUEST.xendit.webhookToken, token)>
	<cfoutput>#SerializeJSON({"success":false,"error":"invalid_callback_token"})#</cfoutput>
	<cfabort>
</cfif>

<cftry>
	<cfset evt = DeserializeJSON(raw)>
	<cfcatch type="any">
		<cfoutput>#SerializeJSON({"success":true,"data":{"ignored":true}})#</cfoutput>
		<cfabort>
	</cfcatch>
</cftry>

<cfif IsStruct(evt) AND StructKeyExists(evt, "data") AND IsStruct(evt.data)>
	<cfset data = evt.data>
<cfelseif IsStruct(evt)>
	<cfset data = evt>
</cfif>

<cfif StructKeyExists(data, "payment_request_id")><cfset prId = Trim(ToString(data.payment_request_id))></cfif>
<cfif StructKeyExists(data, "reference_id")><cfset refId = Trim(ToString(data.reference_id))></cfif>
<cfif StructKeyExists(data, "status")><cfset payStatus = UCase(Trim(ToString(data.status)))></cfif>
<cfif Len(refId) AND Left(refId, 4) EQ "ord-">
	<cfset payIdFromRef = Val(ListGetAt(refId, 3, "-"))>
</cfif>

<cftry>
	<cfquery name="qPay" datasource="#dts#">
		SELECT payment_id, order_id, status
		FROM app_payments
		WHERE gateway_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="xendit">
		<cfif Len(prId)>
			AND gateway_transaction_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#prId#">
		<cfelseif payIdFromRef GT 0>
			AND payment_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#payIdFromRef#">
		<cfelse>
			AND 1 = 0
		</cfif>
		ORDER BY payment_id DESC
		LIMIT 1
	</cfquery>

	<cfif qPay.recordCount>
		<cfif payStatus EQ "SUCCEEDED">
			<cfset emenuFinalizeOnlinePayment(dts, Val(qPay.order_id), Val(qPay.payment_id))>
			<cfquery datasource="#dts#">
				UPDATE payment_transactions
				SET status = <cfqueryparam cfsqltype="cf_sql_varchar" value="PAID">,
					paid_at = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					webhook_received_at = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				WHERE xendit_payment_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#prId#" null="#NOT Len(prId)#">
				   OR reference_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#refId#" null="#NOT Len(refId)#">
			</cfquery>
		<cfelseif payStatus EQ "FAILED" OR payStatus EQ "EXPIRED">
			<cfquery datasource="#dts#">
				UPDATE app_payments
				SET status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCase(payStatus)#">
				WHERE payment_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Val(qPay.payment_id)#">
			</cfquery>
			<cfquery datasource="#dts#">
				UPDATE payment_transactions
				SET status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#payStatus#">,
					<cfif payStatus EQ "EXPIRED">expired_at = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,</cfif>
					webhook_received_at = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				WHERE xendit_payment_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#prId#" null="#NOT Len(prId)#">
				   OR reference_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#refId#" null="#NOT Len(refId)#">
			</cfquery>
		</cfif>
	</cfif>
	<cfcatch type="any"></cfcatch>
</cftry>

<cfoutput>#SerializeJSON({"success":true,"data":{"received":true}})#</cfoutput>
