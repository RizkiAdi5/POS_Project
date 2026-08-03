<!---
    /PaymentGateway/paymentProfileProcess.cfm
    Multi-action handler for paymentProfile.cfm.
    Actions: save_gateway | add_account | edit_account | delete_account | set_default | toggle_active
--->

<cfif CGI.REQUEST_METHOD neq "POST">
    <cflocation url="paymentProfile.cfm" addtoken="false">
</cfif>

<cfset isSuperUser = (husergrpid eq "super")>
<cfset action      = lCase(trim(isDefined("FORM.action") ? FORM.action : ""))>

<cftry>

    <!--- ── save_gateway: Xendit credentials — per tenant ── --->
    <cfif action eq "save_gateway">
        <cfset gatewayId      = trim(isDefined("FORM.gatewayId")      ? FORM.gatewayId      : "")>
        <cfset gatewayApiName = trim(isDefined("FORM.gatewayApiName") ? FORM.gatewayApiName : "Xendit")>
        <cfset gatewaySecret  = trim(isDefined("FORM.gatewaySecret")  ? FORM.gatewaySecret  : "")>
<cfset gatewayWebhook = trim(isDefined("FORM.gatewayWebhook") ? FORM.gatewayWebhook : "")>
        <cfset gatewayActive  = (isDefined("FORM.gatewayActive") AND FORM.gatewayActive eq "N") ? "N" : "Y">

        <cfif len(gatewayId)>
            <cfquery datasource="#dts#">
                UPDATE master_api
                SET    api_name      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#gatewayApiName#">,
                       secret_key    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#gatewaySecret#">,
                       webhook_token = <cfqueryparam cfsqltype="cf_sql_varchar" value="#gatewayWebhook#">,
                       is_active     = <cfqueryparam cfsqltype="cf_sql_char"    value="#gatewayActive#">
                WHERE  id       = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(gatewayId)#">
                  AND  provider = <cfqueryparam cfsqltype="cf_sql_varchar" value="Xendit">
            </cfquery>
        <cfelse>
            <cfquery datasource="#dts#">
                INSERT INTO master_api
                    (api_name, provider, secret_key, webhook_token, is_active)
                VALUES (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#gatewayApiName#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="Xendit">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#gatewaySecret#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#gatewayWebhook#">,
                    <cfqueryparam cfsqltype="cf_sql_char"    value="#gatewayActive#">
                )
            </cfquery>
        </cfif>
        <cflocation url="paymentProfile.cfm?saved=1" addtoken="false">

    <!--- ── save_payment_methods ── --->
    <cfelseif action eq "save_payment_methods">
        <!--- Resolve country to validate against the correct method set --->
        <cfset countryCode = (isDefined("HUserCty") AND len(trim(HUserCty))) ? uCase(trim(HUserCty)) : "ID">
        <cfif NOT listFindNoCase("ID,MY,PH,TH,VN", countryCode)><cfset countryCode = "ID"></cfif>
        <cfif countryCode eq "ID">
            <!--- Codes verified directly against Xendit's Invoice API (2026-08-02) — must stay
                  in sync with the ID list in paymentProfile.cfm --->
            <cfset allowedCodes = "QRIS,BCA,BNI,BRI,MANDIRI,PERMATA,BSI,CIMB,BJB,BNC,OVO,DANA,SHOPEEPAY,LINKAJA,ASTRAPAY,GOPAY,JENIUSPAY,CREDIT_CARD">
        <cfelseif countryCode eq "MY">
            <cfset allowedCodes = "TOUCHNGO,GRABPAY,SHOPEEPAY,WECHATPAY,CARDS,MAYB2U_FPX,CIMB_FPX,PUBLIC_FPX,HLB_FPX,RHB_FPX,BSN_FPX,AFFIN_FPX,ALLIANCE_FPX,AMBANK_FPX,HSBC_FPX,OCBC_FPX,UOB_FPX,ISLAM_FPX,MUAMALAT_FPX,RAKYAT_FPX">
        <cfelseif countryCode eq "PH">
            <cfset allowedCodes = "GCASH,PAYMAYA,GRABPAY,SHOPEEPAY,QRPH,CARDS,BANK_TRANSFER,BPI_DIRECT_DEBIT,UBP_DIRECT_DEBIT,RCBC_DIRECT_DEBIT,7ELEVEN,CEBUANA,LBC,ECPAY,BILLEASE">
        <cfelseif countryCode eq "TH">
            <cfset allowedCodes = "PROMPTPAY,TRUEMONEY,LINEPAY,SHOPEEPAY,WECHATPAY,CARDS,KBANK_MOBILE_BANKING,BBL_MOBILE_BANKING,SCB_MOBILE_BANKING,KTB_MOBILE_BANKING,KRUNGSRI_MOBILE_BANKING">
        <cfelseif countryCode eq "VN">
            <cfset allowedCodes = "MOMO,ZALOPAY,SHOPEEPAY,VNPTWALLET,CARDS,BIDV_VIRTUAL_ACCOUNT,MSB_VIRTUAL_ACCOUNT,VPB_VIRTUAL_ACCOUNT">
        </cfif>
        <cfset submittedMethods = (isDefined("FORM.methods") ? FORM.methods : "")>

        <!--- Upsert every known method — enabled if submitted, disabled if not --->
        <cfloop list="#allowedCodes#" index="code">
            <cfset isEnabled = (listFindNoCase(submittedMethods, code) gt 0) ? 1 : 0>
            <cfquery datasource="#dts#">
                INSERT INTO payment_method_config (method_code, is_enabled)
                VALUES (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#code#">,
                    <cfqueryparam cfsqltype="cf_sql_tinyint" value="#isEnabled#">
                )
                ON DUPLICATE KEY UPDATE is_enabled = VALUES(is_enabled)
            </cfquery>
        </cfloop>
        <cflocation url="paymentProfile.cfm?saved=1" addtoken="false">

    <cfelse>
        <cflocation url="paymentProfile.cfm" addtoken="false">
    </cfif>

<cfcatch type="any">
    <cflog file="payment_gateway" type="error"
           text="paymentProfileProcess (#action#) error: #cfcatch.message# | #cfcatch.detail#">
    <cflocation url="paymentProfile.cfm?err=#URLEncodedFormat(cfcatch.message)#" addtoken="false">
</cfcatch>
</cftry>
