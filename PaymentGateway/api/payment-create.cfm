<cfinclude template="/application.cfm">
<cfinclude template="/latest/customer/inc_emenu_order.cfm">
<cfinclude template="/latest/customer/inc_xendit_pay.cfm">
<cfsetting showdebugoutput="false">
<cfcontent type="application/json; charset=utf-8" reset="true">

<cfif UCase(CGI.REQUEST_METHOD) NEQ "POST">
	<cfheader statuscode="405" statustext="Method Not Allowed">
	<cfoutput>#SerializeJSON({"success":false,"error":"method_not_allowed"})#</cfoutput>
	<cfabort>
</cfif>

<cfset raw = ToString(GetHttpRequestData().content)>
<cfset payload = StructNew()>
<cftry>
	<cfset payload = DeserializeJSON(raw)>
	<cfcatch type="any">
		<cfheader statuscode="400" statustext="Bad Request">
		<cfoutput>#SerializeJSON({"success":false,"error":"invalid_json"})#</cfoutput>
		<cfabort>
	</cfcatch>
</cftry>

<cfset orderId = StructKeyExists(payload, "order_id") ? Val(payload.order_id) : 0>
<cfset amount = StructKeyExists(payload, "amount") ? Int(Val(payload.amount)) : 0>
<cfset method = UCase(Trim(StructKeyExists(payload, "method") ? ToString(payload.method) : ""))>
<cfset channel = UCase(Trim(StructKeyExists(payload, "channel") ? ToString(payload.channel) : ""))>
<cfset customerName = Trim(StructKeyExists(payload, "customer_name") ? ToString(payload.customer_name) : "Customer")>
<cfset customerPhone = Trim(StructKeyExists(payload, "customer_phone") ? ToString(payload.customer_phone) : "")>
<cfset customerId = Trim(StructKeyExists(payload, "customer_id") ? ToString(payload.customer_id) : "")>
<cfset description = Trim(StructKeyExists(payload, "description") ? ToString(payload.description) : "")>

<cfif orderId LTE 0 OR amount LTE 0 OR NOT ListFindNoCase("VIRTUAL_ACCOUNT,EWALLET,QRIS", method)>
	<cfheader statuscode="400" statustext="Bad Request">
	<cfoutput>#SerializeJSON({"success":false,"error":"order_id, amount, method wajib valid."})#</cfoutput>
	<cfabort>
</cfif>

<cfquery name="qOrd" datasource="#dts#">
	SELECT order_id, status
	FROM app_orders
	WHERE order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">
	LIMIT 1
</cfquery>
<cfif qOrd.recordCount EQ 0>
	<cfheader statuscode="404" statustext="Not Found">
	<cfoutput>#SerializeJSON({"success":false,"error":"Order tidak ditemukan."})#</cfoutput>
	<cfabort>
</cfif>
<cfif emenuOrderIsPaid(dts, orderId, qOrd.status)>
	<cfheader statuscode="409" statustext="Conflict">
	<cfoutput>#SerializeJSON({"success":false,"error":"Order sudah dibayar."})#</cfoutput>
	<cfabort>
</cfif>

<cfset refId = "ord-" & orderId & "-" & DateFormat(Now(), "yyyymmdd") & TimeFormat(Now(), "HHmmssL")>
<cfset payResult = StructNew()>
<cfset payDetails = StructNew()>

<cftry>
	<cfif method EQ "VIRTUAL_ACCOUNT">
		<cfif NOT Len(channel)><cfset channel = "BRI"></cfif>
		<cfset payResult = createVirtualAccount({
			"reference_id" = refId,
			"amount" = amount,
			"customer_name" = customerName,
			"bank_code" = channel,
			"description" = description,
			"expires_at" = ""
		})>
		<cfset payDetails = {
			"reference_id" = refId,
			"xendit_payment_id" = payResult.payment_request_id,
			"method" = method,
			"channel" = channel,
			"va_number" = StructKeyExists(payResult, "va_number") ? payResult.va_number : "",
			"expires_at" = StructKeyExists(payResult, "expires_at") ? payResult.expires_at : ""
		}>
	<cfelseif method EQ "EWALLET">
		<cfif NOT Len(channel)>
			<cfheader statuscode="400" statustext="Bad Request">
			<cfoutput>#SerializeJSON({"success":false,"error":"channel e-wallet wajib diisi."})#</cfoutput>
			<cfabort>
		</cfif>
		<cfset payResult = createEwalletCharge({
			"reference_id" = refId,
			"amount" = amount,
			"channel_code" = channel,
			"success_redirect_url" = "",
			"mobile_number" = customerPhone
		})>
		<cfset payDetails = {
			"reference_id" = refId,
			"xendit_payment_id" = payResult.payment_request_id,
			"method" = method,
			"channel" = channel,
			"checkout_url" = StructKeyExists(payResult, "checkout_url") ? payResult.checkout_url : ""
		}>
	<cfelse>
		<cfset channel = "QRIS">
		<cfset payResult = createQrisCharge({
			"reference_id" = refId,
			"amount" = amount,
			"description" = description
		})>
		<cfset payDetails = {
			"reference_id" = refId,
			"xendit_payment_id" = payResult.payment_request_id,
			"method" = method,
			"channel" = channel,
			"qr_string" = StructKeyExists(payResult, "qr_string") ? payResult.qr_string : "",
			"qr_image_url" = StructKeyExists(payResult, "qr_image_url") ? payResult.qr_image_url : ""
		}>
	</cfif>

	<cfquery datasource="#dts#" result="insPay">
		INSERT INTO app_payments (
			order_id, payment_method, amount, status, gateway_name, gateway_transaction_id, gateway_response
		) VALUES (
			<cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#LCase(method)#">,
			<cfqueryparam cfsqltype="cf_sql_decimal" value="#amount#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="processing">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="xendit">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#payDetails.xendit_payment_id#" null="#NOT Len(payDetails.xendit_payment_id)#">,
			<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#SerializeJSON(payDetails)#">
		)
	</cfquery>
	<cfset paymentId = StructKeyExists(insPay, "generatedKey") ? Val(insPay.generatedKey) : 0>
	<cfif paymentId LTE 0 AND StructKeyExists(insPay, "GENERATEDKEY")><cfset paymentId = Val(insPay.GENERATEDKEY)></cfif>

	<cfquery datasource="#dts#">
		INSERT INTO payment_transactions (
			order_id, reference_id, xendit_payment_id, customer_id, amount, currency,
			payment_method, payment_channel, status, payment_details, expired_at
		) VALUES (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#ToString(orderId)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#refId#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#payDetails.xendit_payment_id#" null="#NOT Len(payDetails.xendit_payment_id)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#customerId#" null="#NOT Len(customerId)#">,
			<cfqueryparam cfsqltype="cf_sql_decimal" value="#amount#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="IDR">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#method#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#channel#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="PENDING">,
			<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#SerializeJSON(payDetails)#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#" null="true">
		)
	</cfquery>
	<cfset payDetails.payment_id = paymentId>
	<cfset payDetails.status = "PENDING">

	<cfoutput>#SerializeJSON({"success":true,"data":payDetails})#</cfoutput>
	<cfcatch type="any">
		<cfheader statuscode="500" statustext="Internal Server Error">
		<cfoutput>#SerializeJSON({"success":false,"error":"Gagal membuat payment request."})#</cfoutput>
	</cfcatch>
</cftry>
