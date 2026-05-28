<cfinclude template="/application.cfm">
<cfinclude template="/PaymentGateway/auth.cfm">
<cfsetting showdebugoutput="false">
<cfcontent type="application/json; charset=utf-8" reset="true">

<cfif UCase(CGI.REQUEST_METHOD) NEQ "POST">
	<cfheader statuscode="405" statustext="Method Not Allowed">
	<cfoutput>#SerializeJSON({"success":false,"error":"method_not_allowed"})#</cfoutput>
	<cfabort>
</cfif>

<cfif NOT StructKeyExists(SESSION, "isLogIn") OR SESSION.isLogIn NEQ "Yes">
	<cfheader statuscode="403" statustext="Forbidden">
	<cfoutput>#SerializeJSON({"success":false,"error":"forbidden"})#</cfoutput>
	<cfabort>
</cfif>

<cftry>
	<cfset info = verifyConnection()>
	<cfif info.connected>
		<cfoutput>#SerializeJSON({
			"success":true,
			"data":{
				"status":"connected",
				"balance":Val(info.balance),
				"currency":UCase(Trim(ToString(info.currency))),
				"message":"Koneksi Xendit aktif."
			}
		})#</cfoutput>
	<cfelse>
		<cfheader statuscode="400" statustext="Bad Request">
		<cfoutput>#SerializeJSON({
			"success":false,
			"error":"Koneksi Xendit gagal. Periksa API key."
		})#</cfoutput>
	</cfif>
	<cfcatch type="any">
		<cfheader statuscode="500" statustext="Internal Server Error">
		<cfoutput>#SerializeJSON({"success":false,"error":"Gagal verifikasi koneksi Xendit."})#</cfoutput>
	</cfcatch>
</cftry>
<cfinclude template="../../application.cfm">
<cfinclude template="../pgCore.cfm">
<cfinclude template="../auth.cfm">
<cfcontent type="application/json; charset=utf-8">
<cfset pgRequireAdmin()>

<cftry>
    <cfset info = pgVerifyConnection()>
    <cfoutput>#serializeJSON({
        success = true,
        data = {
            status = "connected",
            balance = info.balance,
            message = "Koneksi Xendit berhasil."
        }
    })#</cfoutput>
    <cfcatch type="any">
        <cfoutput>#serializeJSON({
            success = false,
            data = {
                status = "error",
                balance = 0,
                message = trim(cfcatch.message & " " & cfcatch.detail)
            },
            error = trim(cfcatch.message & " " & cfcatch.detail)
        })#</cfoutput>
    </cfcatch>
</cftry>
