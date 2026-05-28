<cfinclude template="/application.cfm">
<cfinclude template="/latest/customer/inc_emenu_order.cfm">
<cfinclude template="/latest/customer/inc_xendit_pay.cfm">
<cfsetting showdebugoutput="false">
<cfcontent type="application/json; charset=utf-8" reset="true">

<cfif UCase(CGI.REQUEST_METHOD) NEQ "GET">
	<cfheader statuscode="405" statustext="Method Not Allowed">
	<cfoutput>#SerializeJSON({"success":false,"error":"method_not_allowed"})#</cfoutput>
	<cfabort>
</cfif>

<cfparam name="URL.payment_id" default="0">
<cfset paymentId = Val(URL.payment_id)>
<cfif paymentId LTE 0>
	<cfheader statuscode="400" statustext="Bad Request">
	<cfoutput>#SerializeJSON({"success":false,"error":"payment_id wajib valid."})#</cfoutput>
	<cfabort>
</cfif>

<cfquery name="qPay" datasource="#dts#">
	SELECT payment_id, order_id, payment_method, status, gateway_transaction_id, gateway_response, paid_at
	FROM app_payments
	WHERE payment_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#paymentId#">
	LIMIT 1
</cfquery>
<cfif qPay.recordCount EQ 0>
	<cfheader statuscode="404" statustext="Not Found">
	<cfoutput>#SerializeJSON({"success":false,"error":"Payment tidak ditemukan."})#</cfoutput>
	<cfabort>
</cfif>

<cfset statusNow = UCase(Trim(qPay.status))>
<cfset gatewayStatus = "">
<cfset gatewayData = StructNew()>

<cftry>
	<cfif ListFindNoCase("PENDING,PROCESSING", statusNow) AND Len(Trim(qPay.gateway_transaction_id))>
		<cfset chk = getPaymentStatus(Trim(qPay.gateway_transaction_id))>
		<cfset gatewayStatus = UCase(Trim(chk.status))>
		<cfset gatewayData = chk.details>

		<cfif gatewayStatus EQ "SUCCEEDED">
			<cfset emenuFinalizeOnlinePayment(dts, Val(qPay.order_id), paymentId)>
			<cfset statusNow = "PAID">
			<cfquery datasource="#dts#">
				UPDATE payment_transactions
				SET status = <cfqueryparam cfsqltype="cf_sql_varchar" value="PAID">,
					paid_at = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					payment_details = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#SerializeJSON(gatewayData)#">
				WHERE xendit_payment_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(qPay.gateway_transaction_id)#">
			</cfquery>
		<cfelseif gatewayStatus EQ "FAILED">
			<cfset statusNow = "FAILED">
			<cfquery datasource="#dts#">
				UPDATE app_payments
				SET status = <cfqueryparam cfsqltype="cf_sql_varchar" value="failed">
				WHERE payment_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#paymentId#">
			</cfquery>
			<cfquery datasource="#dts#">
				UPDATE payment_transactions
				SET status = <cfqueryparam cfsqltype="cf_sql_varchar" value="FAILED">,
					payment_details = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#SerializeJSON(gatewayData)#">
				WHERE xendit_payment_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(qPay.gateway_transaction_id)#">
			</cfquery>
		<cfelseif gatewayStatus EQ "EXPIRED">
			<cfset statusNow = "EXPIRED">
			<cfquery datasource="#dts#">
				UPDATE app_payments
				SET status = <cfqueryparam cfsqltype="cf_sql_varchar" value="expired">
				WHERE payment_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#paymentId#">
			</cfquery>
			<cfquery datasource="#dts#">
				UPDATE payment_transactions
				SET status = <cfqueryparam cfsqltype="cf_sql_varchar" value="EXPIRED">,
					expired_at = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					payment_details = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#SerializeJSON(gatewayData)#">
				WHERE xendit_payment_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(qPay.gateway_transaction_id)#">
			</cfquery>
		</cfif>
	</cfif>

	<cfif statusNow EQ "SUCCESS"><cfset statusNow = "PAID"></cfif>
	<cfif statusNow EQ "PROCESSING"><cfset statusNow = "PENDING"></cfif>

	<cfoutput>#SerializeJSON({
		"success":true,
		"data":{
			"payment_id":Val(qPay.payment_id),
			"order_id":Val(qPay.order_id),
			"method":UCase(Trim(qPay.payment_method)),
			"status":statusNow,
			"xendit_status":gatewayStatus,
			"paid_at":qPay.paid_at,
			"details":gatewayData
		}
	})#</cfoutput>
	<cfcatch type="any">
		<cfheader statuscode="500" statustext="Internal Server Error">
		<cfoutput>#SerializeJSON({"success":false,"error":"Gagal mengambil status payment."})#</cfoutput>
	</cfcatch>
</cftry>
