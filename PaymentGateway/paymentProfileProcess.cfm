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

    <!--- ── save_gateway: Xendit credentials — super only ── --->
    <cfif action eq "save_gateway">
        <cfif NOT isSuperUser>
            <cflocation url="paymentProfile.cfm?err=#URLEncodedFormat("Access denied.")#" addtoken="false">
        </cfif>
        <cfset gatewayId      = trim(isDefined("FORM.gatewayId")      ? FORM.gatewayId      : "")>
        <cfset gatewayApiName = trim(isDefined("FORM.gatewayApiName") ? FORM.gatewayApiName : "Xendit")>
        <cfset gatewaySecret  = trim(isDefined("FORM.gatewaySecret")  ? FORM.gatewaySecret  : "")>
        <cfset gatewayPublic  = trim(isDefined("FORM.gatewayPublic")  ? FORM.gatewayPublic  : "")>
        <cfset gatewayWebhook = trim(isDefined("FORM.gatewayWebhook") ? FORM.gatewayWebhook : "")>
        <cfset gatewayActive  = (isDefined("FORM.gatewayActive") AND FORM.gatewayActive eq "N") ? "N" : "Y">

        <cfif len(gatewayId)>
            <cfquery datasource="#dts#">
                UPDATE main.master_api
                SET    api_name      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#gatewayApiName#">,
                       secret_key    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#gatewaySecret#">,
                       public_key    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#gatewayPublic#">,
                       webhook_token = <cfqueryparam cfsqltype="cf_sql_varchar" value="#gatewayWebhook#">,
                       is_active     = <cfqueryparam cfsqltype="cf_sql_char"    value="#gatewayActive#">
                WHERE  id       = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(gatewayId)#">
                  AND  provider = <cfqueryparam cfsqltype="cf_sql_varchar" value="Xendit">
            </cfquery>
        <cfelse>
            <cfquery datasource="#dts#">
                INSERT INTO main.master_api
                    (api_name, provider, secret_key, public_key, webhook_token, is_active)
                VALUES (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#gatewayApiName#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="Xendit">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#gatewaySecret#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#gatewayPublic#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#gatewayWebhook#">,
                    <cfqueryparam cfsqltype="cf_sql_char"    value="#gatewayActive#">
                )
            </cfquery>
        </cfif>
        <cflocation url="paymentProfile.cfm?saved=1" addtoken="false">

    <!--- ── add_account ── --->
    <cfelseif action eq "add_account">
        <cfset bankCode      = trim(isDefined("FORM.bankCode")      ? FORM.bankCode      : "")>
        <cfset accountNumber = trim(isDefined("FORM.accountNumber") ? FORM.accountNumber : "")>
        <cfset accountName   = trim(isDefined("FORM.accountName")   ? FORM.accountName   : "")>
        <cfset setAsDefault  = (isDefined("FORM.setAsDefault") AND FORM.setAsDefault eq "1") ? 1 : 0>

        <cfif NOT (len(bankCode) AND len(accountNumber) AND len(accountName))>
            <cflocation url="paymentProfile.cfm?err=#URLEncodedFormat("Bank, account number and account name are required.")#" addtoken="false">
        </cfif>

        <!--- Super sets fee config; clients get defaults --->
        <cfif isSuperUser>
            <cfset platformFeePct = val(isDefined("FORM.platformFeePct") ? FORM.platformFeePct : "2.00")>
            <cfset absorbFee      = (isDefined("FORM.absorbFee") AND FORM.absorbFee eq "1") ? 1 : 0>
        <cfelse>
            <!--- Inherit fee settings from the existing default account, or use system defaults --->
            <cfquery name="qFee" datasource="#dts#">
                SELECT platform_fee_pct, absorb_gateway_fee
                FROM   main.client_payment_accounts
                WHERE  dts = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#">
                ORDER  BY is_default DESC LIMIT 1
            </cfquery>
            <cfset platformFeePct = (qFee.recordCount ? val(qFee.platform_fee_pct) : 2.00)>
            <cfset absorbFee      = (qFee.recordCount ? val(qFee.absorb_gateway_fee) : 0)>
        </cfif>

        <cfif setAsDefault>
            <cfquery datasource="#dts#">
                UPDATE main.client_payment_accounts
                SET    is_default = 0
                WHERE  dts = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#">
            </cfquery>
        </cfif>

        <cfquery datasource="#dts#">
            INSERT INTO main.client_payment_accounts
                (dts, bank_code, account_number, account_name,
                 platform_fee_pct, absorb_gateway_fee, is_default, is_active)
            VALUES (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#bankCode#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#accountNumber#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#accountName#">,
                <cfqueryparam cfsqltype="cf_sql_decimal" value="#platformFeePct#" scale="2">,
                <cfqueryparam cfsqltype="cf_sql_tinyint" value="#absorbFee#">,
                <cfqueryparam cfsqltype="cf_sql_tinyint" value="#setAsDefault#">,
                1
            )
        </cfquery>
        <cflocation url="paymentProfile.cfm?saved=1" addtoken="false">

    <!--- ── edit_account ── --->
    <cfelseif action eq "edit_account">
        <cfset accountId    = val(isDefined("FORM.account_id")   ? FORM.account_id   : 0)>
        <cfset bankCode     = trim(isDefined("FORM.bankCode")     ? FORM.bankCode     : "")>
        <cfset accountNumber= trim(isDefined("FORM.accountNumber")? FORM.accountNumber: "")>
        <cfset accountName  = trim(isDefined("FORM.accountName")  ? FORM.accountName  : "")>
        <cfset acctActive   = (isDefined("FORM.acctActive") AND val(FORM.acctActive) eq 1) ? 1 : 0>

        <cfif accountId lte 0 OR NOT (len(bankCode) AND len(accountNumber) AND len(accountName))>
            <cflocation url="paymentProfile.cfm?err=#URLEncodedFormat("Invalid account data.")#" addtoken="false">
        </cfif>

        <!--- Only super may change fee fields --->
        <cfif isSuperUser>
            <cfset platformFeePct = val(isDefined("FORM.platformFeePct") ? FORM.platformFeePct : "2.00")>
            <cfset absorbFee      = (isDefined("FORM.absorbFee") AND FORM.absorbFee eq "1") ? 1 : 0>
            <cfquery datasource="#dts#">
                UPDATE main.client_payment_accounts
                SET    bank_code          = <cfqueryparam cfsqltype="cf_sql_varchar" value="#bankCode#">,
                       account_number     = <cfqueryparam cfsqltype="cf_sql_varchar" value="#accountNumber#">,
                       account_name       = <cfqueryparam cfsqltype="cf_sql_varchar" value="#accountName#">,
                       platform_fee_pct   = <cfqueryparam cfsqltype="cf_sql_decimal" value="#platformFeePct#" scale="2">,
                       absorb_gateway_fee = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#absorbFee#">,
                       is_active          = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#acctActive#">
                WHERE  id  = <cfqueryparam cfsqltype="cf_sql_integer" value="#accountId#">
                  AND  dts = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#">
            </cfquery>
        <cfelse>
            <cfquery datasource="#dts#">
                UPDATE main.client_payment_accounts
                SET    bank_code      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#bankCode#">,
                       account_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#accountNumber#">,
                       account_name   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#accountName#">,
                       is_active      = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#acctActive#">
                WHERE  id  = <cfqueryparam cfsqltype="cf_sql_integer" value="#accountId#">
                  AND  dts = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#">
            </cfquery>
        </cfif>
        <cflocation url="paymentProfile.cfm?saved=1" addtoken="false">

    <!--- ── set_default ── --->
    <cfelseif action eq "set_default">
        <cfset accountId = val(isDefined("FORM.account_id") ? FORM.account_id : 0)>
        <cfif accountId lte 0>
            <cflocation url="paymentProfile.cfm?err=#URLEncodedFormat("Invalid account.")#" addtoken="false">
        </cfif>
        <cfquery datasource="#dts#">
            UPDATE main.client_payment_accounts
            SET    is_default = 0
            WHERE  dts = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#">
        </cfquery>
        <cfquery datasource="#dts#">
            UPDATE main.client_payment_accounts
            SET    is_default = 1, is_active = 1
            WHERE  id  = <cfqueryparam cfsqltype="cf_sql_integer" value="#accountId#">
              AND  dts = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#">
        </cfquery>
        <cflocation url="paymentProfile.cfm?saved=1" addtoken="false">

    <!--- ── toggle_active ── --->
    <cfelseif action eq "toggle_active">
        <cfset accountId = val(isDefined("FORM.account_id") ? FORM.account_id : 0)>
        <cfif accountId lte 0>
            <cflocation url="paymentProfile.cfm?err=#URLEncodedFormat("Invalid account.")#" addtoken="false">
        </cfif>
        <cfquery name="qToggle" datasource="#dts#">
            SELECT is_active, is_default
            FROM   main.client_payment_accounts
            WHERE  id  = <cfqueryparam cfsqltype="cf_sql_integer" value="#accountId#">
              AND  dts = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#">
            LIMIT  1
        </cfquery>
        <cfif qToggle.recordCount AND NOT (val(qToggle.is_default) AND val(qToggle.is_active))>
            <!--- Cannot deactivate the default account --->
            <cfquery datasource="#dts#">
                UPDATE main.client_payment_accounts
                SET    is_active = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#(val(qToggle.is_active) ? 0 : 1)#">
                WHERE  id  = <cfqueryparam cfsqltype="cf_sql_integer" value="#accountId#">
                  AND  dts = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#">
            </cfquery>
        <cfelseif qToggle.recordCount AND val(qToggle.is_default)>
            <cflocation url="paymentProfile.cfm?err=#URLEncodedFormat("Cannot deactivate the default account. Set another account as default first.")#" addtoken="false">
        </cfif>
        <cflocation url="paymentProfile.cfm?saved=1" addtoken="false">

    <!--- ── delete_account ── --->
    <cfelseif action eq "delete_account">
        <cfset accountId = val(isDefined("FORM.account_id") ? FORM.account_id : 0)>
        <cfif accountId lte 0>
            <cflocation url="paymentProfile.cfm?err=#URLEncodedFormat("Invalid account.")#" addtoken="false">
        </cfif>
        <cfquery name="qDel" datasource="#dts#">
            SELECT is_default FROM main.client_payment_accounts
            WHERE  id  = <cfqueryparam cfsqltype="cf_sql_integer" value="#accountId#">
              AND  dts = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#">
            LIMIT  1
        </cfquery>
        <cfif qDel.recordCount AND val(qDel.is_default)>
            <cflocation url="paymentProfile.cfm?err=#URLEncodedFormat("Cannot delete the default account. Set another account as default first.")#" addtoken="false">
        </cfif>
        <cfquery datasource="#dts#">
            DELETE FROM main.client_payment_accounts
            WHERE  id  = <cfqueryparam cfsqltype="cf_sql_integer" value="#accountId#">
              AND  dts = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#">
              AND  is_default = 0
        </cfquery>
        <cflocation url="paymentProfile.cfm?saved=1" addtoken="false">

    <!--- ── save_payment_methods ── --->
    <cfelseif action eq "save_payment_methods">
        <!--- Collect checked methods from form (multi-value field) --->
        <cfset allowedCodes = "QRIS,BCA,BNI,BRI,MANDIRI,PERMATA,BSI,CIMB,BJB,BNC,OVO,DANA,SHOPEEPAY,LINKAJA,ASTRAPAY,GOPAY,JENIUSPAY,CREDIT_CARD,ALFAMART,INDOMARET">
        <cfset submittedMethods = (isDefined("FORM.methods") ? FORM.methods : "")>

        <!--- Upsert every known method — enabled if submitted, disabled if not --->
        <cfloop list="#allowedCodes#" index="code">
            <cfset isEnabled = (listFindNoCase(submittedMethods, code) gt 0) ? 1 : 0>
            <cfquery datasource="#dts#">
                INSERT INTO main.payment_method_config (dts, method_code, is_enabled)
                VALUES (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#">,
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
