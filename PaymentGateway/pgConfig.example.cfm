<!--- Copy to pgConfig.cfm and set your Xendit keys. Restart app pool after change. --->
<cfset APPLICATION.pg_xendit_enabled = "Y">
<cfset APPLICATION.pg_xendit_secret_key = "xnd_production_xxxxxxxxxx">
<cfset APPLICATION.pg_xendit_webhook_token = "xxxxxxxxxxxxxxxx">
<cfset APPLICATION.pg_xendit_api_base_url = "https://api.xendit.co">
<!--- Optional/public key (only needed for client-side tokenization flows). --->
<!--- <cfset APPLICATION.pg_xendit_public_key = "xnd_public_xxxxxxxxxx"> --->
<!---
	Alternative environment variables also supported:
	- XENDIT_SECRET_KEY / PG_XENDIT_SECRET_KEY
	- XENDIT_WEBHOOK_TOKEN / PG_XENDIT_WEBHOOK_TOKEN
	- XENDIT_BASE_URL / PG_XENDIT_BASE_URL
--->
