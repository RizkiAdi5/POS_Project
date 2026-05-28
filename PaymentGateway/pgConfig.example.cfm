<!--- Copy to pgConfig.cfm and set your Xendit keys. Restart app pool after change. --->
<cfset APPLICATION.pg_xendit_enabled = "Y">
<cfset APPLICATION.pg_xendit_secret_key = "xnd_development_YOUR_SECRET_KEY">
<cfset APPLICATION.pg_xendit_public_key = "xnd_public_development_YOUR_PUBLIC_KEY">
<cfset APPLICATION.pg_xendit_webhook_token = "YOUR_WEBHOOK_TOKEN">
