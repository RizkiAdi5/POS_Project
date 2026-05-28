<!--- Customer Xendit checkout helpers (includes PaymentGateway config). --->
<cfinclude template="/PaymentGateway/auth.cfm">

<cffunction name="emenuPgProfile" output="false" returntype="struct">
	<cfargument name="dsn" type="string" required="true">
	<cfreturn pgGetMerchantProfile(arguments.dsn)>
</cffunction>

<cffunction name="emenuPayBaseUrl" output="false" returntype="string">
	<cfset var host = trim(CGI.HTTP_HOST)>
	<cfif NOT len(host)><cfset host = "localhost"></cfif>
	<cfset var scheme = (StructKeyExists(CGI, "HTTPS") AND (CGI.HTTPS EQ "on" OR CGI.HTTPS EQ 1)) ? "https" : "http">
	<cfreturn scheme & "://" & host>
</cffunction>

<cffunction name="emenuFinalizeOnlinePayment" output="false" returntype="boolean">
	<cfargument name="dsn" type="string" required="true">
	<cfargument name="orderId" type="numeric" required="true">
	<cfargument name="paymentId" type="numeric" required="false" default="0">
	<cfif arguments.orderId lte 0><cfreturn false></cfif>
	<cftry>
		<cfquery name="local.qPay" datasource="#arguments.dsn#">
			SELECT payment_id, status FROM app_payments
			WHERE order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.orderId#">
			<cfif arguments.paymentId gt 0>
				AND payment_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.paymentId#">
			</cfif>
			ORDER BY payment_id DESC LIMIT 1
		</cfquery>
		<cfif local.qPay.recordCount AND lCase(trim(local.qPay.status)) EQ "success">
			<cfreturn true>
		</cfif>
		<cfif arguments.paymentId gt 0>
			<cfquery datasource="#arguments.dsn#">
				UPDATE app_payments SET
					status = <cfqueryparam cfsqltype="cf_sql_varchar" value="success">,
					paid_at = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				WHERE payment_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.paymentId#">
			</cfquery>
		<cfelseif local.qPay.recordCount>
			<cfquery datasource="#arguments.dsn#">
				UPDATE app_payments SET
					status = <cfqueryparam cfsqltype="cf_sql_varchar" value="success">,
					paid_at = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				WHERE payment_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.qPay.payment_id#">
			</cfquery>
		</cfif>
		<cfquery name="local.qOrd" datasource="#arguments.dsn#">
			SELECT order_number, total_amount, status FROM app_orders
			WHERE order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.orderId#">
			LIMIT 1
		</cfquery>
		<cfif local.qOrd.recordCount AND lCase(trim(local.qOrd.status)) NEQ "paid">
			<cfquery datasource="#arguments.dsn#">
				UPDATE app_orders SET
					status = <cfqueryparam cfsqltype="cf_sql_varchar" value="paid">,
					completed_at = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				WHERE order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.orderId#">
			</cfquery>
		</cfif>
		<cfif isDefined("SESSION") AND val(arguments.orderId) EQ val(SESSION.emenu_order_id)>
			<cfset SESSION.emenu_cart_locked = true>
			<cfif SESSION.emenu_loggedin EQ "Yes" AND len(trim(SESSION.emenu_custno)) AND local.qOrd.recordCount>
				<cfset SESSION.emenu_points_earned = emenuAwardLoyaltyPoints(arguments.dsn, trim(SESSION.emenu_custno), local.qOrd.order_number, val(local.qOrd.total_amount))>
			</cfif>
		</cfif>
		<cfreturn true>
		<cfcatch type="any"><cfreturn false></cfcatch>
	</cftry>
</cffunction>
