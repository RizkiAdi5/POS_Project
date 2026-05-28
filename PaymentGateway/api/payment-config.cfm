<cfinclude template="/application.cfm">
<cfinclude template="/latest/customer/inc_xendit_pay.cfm">
<cfsetting showdebugoutput="false">
<cfcontent type="application/json; charset=utf-8" reset="true">

<cfif UCase(CGI.REQUEST_METHOD) NEQ "GET">
	<cfheader statuscode="405" statustext="Method Not Allowed">
	<cfoutput>#SerializeJSON({"success":false,"error":"method_not_allowed"})#</cfoutput>
	<cfabort>
</cfif>

<cftry>
	<cfset pgProf = emenuPgProfile(dts)>
	<cfset channels = ArrayNew(1)>
	<cfset vaBanks = pgSafeJsonArray(pgProf.va_banks_enabled)>
	<cfset methodList = UCase(ArrayToList(pgSafeJsonArray(pgProf.payment_methods_enabled)))>

	<cfif ListFindNoCase(methodList, "VIRTUAL_ACCOUNT") OR pgProf.enable_va EQ "Y">
		<cfif ArrayLen(vaBanks) EQ 0>
			<cfset vaBanks = ["BRI","BNI","MANDIRI","PERMATA"]>
		</cfif>
		<cfset ArrayAppend(channels, {"method":"VIRTUAL_ACCOUNT","channels":vaBanks})>
	</cfif>
	<cfif ListFindNoCase(methodList, "EWALLET") OR pgProf.enable_ewallet EQ "Y">
		<cfset ArrayAppend(channels, {"method":"EWALLET","channels":["OVO","DANA","SHOPEEPAY"]})>
	</cfif>
	<cfif ListFindNoCase(methodList, "QRIS") OR pgProf.enable_qris EQ "Y">
		<cfset ArrayAppend(channels, {"method":"QRIS","channels":["QRIS"]})>
	</cfif>
	<cfif pgProf.enable_card EQ "Y">
		<cfset ArrayAppend(channels, {"method":"CARD","channels":["CARDS"]})>
	</cfif>

	<cfoutput>#SerializeJSON({"success":true,"data":{"channels":channels,"currency":"IDR"}})#</cfoutput>
	<cfcatch type="any">
		<cfheader statuscode="500" statustext="Internal Server Error">
		<cfoutput>#SerializeJSON({"success":false,"error":"Gagal memuat konfigurasi payment."})#</cfoutput>
	</cfcatch>
</cftry>
