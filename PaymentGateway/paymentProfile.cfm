<!---
    /PaymentGateway/paymentProfile.cfm
    All users: Xendit API credentials (per-dts) + accepted payment methods.
--->
<cfset pageTitle = "Payment Gateway Profile">

<!--- Xendit credentials for this tenant --->
<cfquery name="qGateway" datasource="#dts#">
    SELECT id, api_name, secret_key, webhook_token, is_active
    FROM   master_api
    WHERE  provider = <cfqueryparam cfsqltype="cf_sql_varchar" value="Xendit">
    LIMIT  1
</cfquery>
<cfset gatewayId      = (qGateway.recordCount ? trim(qGateway.id)            : "")>
<cfset gatewayApiName = (qGateway.recordCount ? trim(qGateway.api_name)      : "Xendit")>
<cfset gatewaySecret  = (qGateway.recordCount ? trim(qGateway.secret_key)    : "")>
<cfset gatewayWebhook = (qGateway.recordCount ? trim(qGateway.webhook_token) : "")>
<cfset gatewayActive  = (qGateway.recordCount ? trim(qGateway.is_active)     : "Y")>

<!--- Payment method config for this client — select ALL rows (not just enabled ones) so we can
      tell "never configured this page" apart from "configured it and disabled everything".
      Using only is_enabled=1 rows here would make methodsConfigured false again the moment every
      method is deactivated, forcing every checkbox back to checked on reload. --->
<cfset enabledMethods = "">
<cftry>
    <cfquery name="qMethods" datasource="#dts#">
        SELECT method_code, is_enabled FROM payment_method_config
    </cfquery>
    <cfloop query="qMethods">
        <cfif val(qMethods.is_enabled) eq 1>
            <cfset enabledMethods = listAppend(enabledMethods, trim(qMethods.method_code))>
        </cfif>
    </cfloop>
    <cfset methodsConfigured = (qMethods.recordCount gt 0)>
<cfcatch type="database">
    <cfset methodsConfigured = false>
</cfcatch>
</cftry>

<cfset successMsg = (isDefined("url.saved") AND url.saved eq "1") ? "Settings saved successfully." : "">
<cfset errorMsg   = (isDefined("url.err")   AND len(trim(url.err)))  ? trim(url.err)              : "">
<!--- Resolve country code â€” use Xendit 2-letter code stored in userCty --->
<cfset countryCode = (isDefined("HUserCty") AND len(trim(HUserCty))) ? uCase(trim(HUserCty)) : "ID">
<cfif NOT listFindNoCase("ID,MY,PH,TH,VN", countryCode)><cfset countryCode = "ID"></cfif>
<cfset countryNames = {"ID"="Indonesia","MY"="Malaysia","PH"="Philippines","TH"="Thailand","VN"="Vietnam"}>
<cfset countryName  = structKeyExists(countryNames, countryCode) ? countryNames[countryCode] : countryCode>


<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><cfoutput>#pageTitle#</cfoutput></title>
    <link rel="stylesheet" type="text/css" href="/latest/css/bootstrap/bootstrap.css">
    <link rel="stylesheet" type="text/css" href="/latest/css/maintenance/target.css">
    <script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="/latest/js/bootstrap/bootstrap.min.js"></script>
    <style>
        .table-accts td, .table-accts th { font-size:12px; vertical-align:middle !important; }
        .label-default-acct { background:##5cb85c; }
    </style>
</head>
<body class="container">
<cfoutput>

<div class="page-header"><h3>#pageTitle#</h3></div>

<cfif len(successMsg)>
    <div class="alert alert-success">#HTMLEditFormat(successMsg)#</div>
</cfif>
<cfif len(errorMsg)>
    <div class="alert alert-danger">#HTMLEditFormat(errorMsg)#</div>
</cfif>


<div class="panel-group">

    <!--- â”€â”€ Panel 1: Xendit API Credentials â”€â”€ --->
    <div class="panel panel-default">
        <div class="panel-heading" data-toggle="collapse" href="##xenditPanel" style="cursor:pointer">
            <h4 class="panel-title accordion-toggle">
                Xendit API Credentials
                <small class=”text-muted” style=”font-size:11px;font-weight:normal”> &mdash; your Xendit account keys</small>
            </h4>
        </div>
        <div id="xenditPanel" class="panel-collapse collapse <cfif NOT len(gatewayId)>in</cfif>">
            <div class="panel-body">
                <form class="form-horizontal" method="post" action="paymentProfileProcess.cfm">
                    <input type="hidden" name="action"    value="save_gateway">
                    <input type="hidden" name="gatewayId" value="#HTMLEditFormat(gatewayId)#">
                    <div class="row"><div class="col-sm-9">

                        <div class="form-group">
                            <label for="gatewayApiName" class="col-sm-4 control-label">API Name</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control input-sm"
                                       id="gatewayApiName" name="gatewayApiName"
                                       value="#HTMLEditFormat(gatewayApiName)#"
                                       placeholder="e.g. Xendit Production" maxlength="100">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="gatewaySecret" class="col-sm-4 control-label">Secret Key</label>
                            <div class="col-sm-8">
                                <input type="password" class="form-control input-sm"
                                       id="gatewaySecret" name="gatewaySecret"
                                       value="#HTMLEditFormat(gatewaySecret)#"
                                       placeholder="xnd_production_..." maxlength="200" autocomplete="new-password">
                                <span class="help-block" style="font-size:11px">Never share this.</span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="gatewayWebhook" class="col-sm-4 control-label">Callback Token</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control input-sm"
                                       id="gatewayWebhook" name="gatewayWebhook"
                                       value="#HTMLEditFormat(gatewayWebhook)#"
                                       placeholder="Xendit webhook verification token" maxlength="200">
                                <span class="help-block" style="font-size:11px">
                                    Must match <em>x-callback-token</em> sent to
                                    <code>/latest/customer/xenditWebhook.cfm</code>
                                </span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="gatewayActive" class="col-sm-4 control-label">Status</label>
                            <div class="col-sm-4">
                                <select class="form-control input-sm" id="gatewayActive" name="gatewayActive">
                                    <option value="Y" <cfif gatewayActive eq "Y">selected</cfif>>Active</option>
                                    <option value="N" <cfif gatewayActive eq "N">selected</cfif>>Inactive</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-sm-offset-4 col-sm-8">
                                <button type="submit" class="btn btn-primary btn-sm">Save Credentials</button>
                            </div>
                        </div>

                    </div></div>
                </form>
            </div>
        </div>
    </div>

    <!--- â”€â”€ Panel 2: Payment Methods â”€â”€ --->
        <div class="panel panel-default">
            <div class="panel-heading" data-toggle="collapse" href="##methodsPanel" style="cursor:pointer">
                <h4 class="panel-title accordion-toggle">
                    Accepted Payment Methods
                    <small class="text-muted" style="font-size:11px;font-weight:normal">
                        &mdash; <cfoutput>#HTMLEditFormat(countryName)#</cfoutput> methods &middot; controls what customers see on the Xendit payment page
                    </small>
                </h4>
            </div>
            <div id="methodsPanel" class="panel-collapse collapse in">
                <div class="panel-body">
                    <p class="text-muted" style="font-size:12px;margin-bottom:15px">
                        Check all payment methods you want to offer your customers.
                        <strong>If none are saved, all methods enabled on your Xendit account are shown.</strong>
                    </p>
                    <form method="post" action="paymentProfileProcess.cfm">
                        <input type="hidden" name="action" value="save_payment_methods">

                        <cfif countryCode eq "ID">
                        <!--- Codes verified directly against Xendit's Invoice API (2026-08-02) — the
                              old *_VIRTUAL_ACCOUNT / CARDS names aren't real Xendit enum values; Xendit
                              silently drops whichever codes it doesn't recognize instead of erroring
                              when at least one other requested code is valid, which is why bank/card
                              options were vanishing from checkout even though this list "looked" enabled. --->
                        <cfset allMethods = [
                            {group="QR Code",          code="QRIS",                    label="QRIS"},
                            {group="Virtual Account",  code="BCA",                     label="BCA"},
                            {group="Virtual Account",  code="BNI",                     label="BNI"},
                            {group="Virtual Account",  code="BRI",                     label="BRI"},
                            {group="Virtual Account",  code="MANDIRI",                 label="Mandiri"},
                            {group="Virtual Account",  code="PERMATA",                 label="Permata"},
                            {group="Virtual Account",  code="BSI",                     label="BSI"},
                            {group="Virtual Account",  code="CIMB",                    label="CIMB"},
                            {group="Virtual Account",  code="BJB",                     label="BJB"},
                            {group="Virtual Account",  code="BNC",                     label="BNC"},
                            {group="E-Wallet",         code="OVO",                     label="OVO"},
                            {group="E-Wallet",         code="DANA",                    label="DANA"},
                            {group="E-Wallet",         code="SHOPEEPAY",               label="ShopeePay"},
                            {group="E-Wallet",         code="LINKAJA",                 label="LinkAja"},
                            {group="E-Wallet",         code="ASTRAPAY",                label="AstraPay"},
                            {group="E-Wallet",         code="GOPAY",                   label="GoPay"},
                            {group="E-Wallet",         code="JENIUSPAY",               label="Jenius Pay"},
                            {group="Card",             code="CREDIT_CARD",             label="Credit / Debit Card"}
                        ]>
                        <cfelseif countryCode eq "MY">
                        <cfset allMethods = [
                            {group="E-Wallet",          code="TOUCHNGO",               label="Touch 'n Go"},
                            {group="E-Wallet",          code="GRABPAY",                label="GrabPay"},
                            {group="E-Wallet",          code="SHOPEEPAY",              label="ShopeePay"},
                            {group="E-Wallet",          code="WECHATPAY",              label="WeChat Pay"},
                            {group="Card",              code="CARDS",                  label="Credit / Debit Card"},
                            {group="FPX Online Banking",code="MAYB2U_FPX",            label="Maybank"},
                            {group="FPX Online Banking",code="CIMB_FPX",              label="CIMB"},
                            {group="FPX Online Banking",code="PUBLIC_FPX",             label="Public Bank"},
                            {group="FPX Online Banking",code="HLB_FPX",               label="Hong Leong Bank"},
                            {group="FPX Online Banking",code="RHB_FPX",               label="RHB Bank"},
                            {group="FPX Online Banking",code="BSN_FPX",               label="BSN"},
                            {group="FPX Online Banking",code="AFFIN_FPX",             label="Affin Bank"},
                            {group="FPX Online Banking",code="ALLIANCE_FPX",          label="Alliance Bank"},
                            {group="FPX Online Banking",code="AMBANK_FPX",            label="AmBank"},
                            {group="FPX Online Banking",code="HSBC_FPX",              label="HSBC"},
                            {group="FPX Online Banking",code="OCBC_FPX",              label="OCBC"},
                            {group="FPX Online Banking",code="UOB_FPX",               label="UOB"},
                            {group="FPX Online Banking",code="ISLAM_FPX",             label="Bank Islam"},
                            {group="FPX Online Banking",code="MUAMALAT_FPX",          label="Bank Muamalat"},
                            {group="FPX Online Banking",code="RAKYAT_FPX",            label="Bank Rakyat"}
                        ]>
                        <cfelseif countryCode eq "PH">
                        <cfset allMethods = [
                            {group="E-Wallet",         code="GCASH",                   label="GCash"},
                            {group="E-Wallet",         code="PAYMAYA",                 label="Maya"},
                            {group="E-Wallet",         code="GRABPAY",                 label="GrabPay"},
                            {group="E-Wallet",         code="SHOPEEPAY",               label="ShopeePay"},
                            {group="QR Code",          code="QRPH",                    label="QR Ph"},
                            {group="Card",             code="CARDS",                   label="Credit / Debit Card"},
                            {group="Bank Transfer",    code="BANK_TRANSFER",           label="Bank Transfer"},
                            {group="Direct Debit",     code="BPI_DIRECT_DEBIT",        label="BPI"},
                            {group="Direct Debit",     code="UBP_DIRECT_DEBIT",        label="UnionBank"},
                            {group="Direct Debit",     code="RCBC_DIRECT_DEBIT",       label="RCBC"},
                            {group="OTC",              code="7ELEVEN",                 label="7-Eleven"},
                            {group="OTC",              code="CEBUANA",                 label="Cebuana"},
                            {group="OTC",              code="LBC",                     label="LBC"},
                            {group="OTC",              code="ECPAY",                   label="ECPay"},
                            {group="Pay Later",        code="BILLEASE",                label="BillEase"}
                        ]>
                        <cfelseif countryCode eq "TH">
                        <cfset allMethods = [
                            {group="QR Code",          code="PROMPTPAY",               label="PromptPay"},
                            {group="E-Wallet",         code="TRUEMONEY",               label="TrueMoney"},
                            {group="E-Wallet",         code="LINEPAY",                 label="LINE Pay"},
                            {group="E-Wallet",         code="SHOPEEPAY",               label="ShopeePay"},
                            {group="E-Wallet",         code="WECHATPAY",               label="WeChat Pay"},
                            {group="Card",             code="CARDS",                   label="Credit / Debit Card"},
                            {group="Mobile Banking",   code="KBANK_MOBILE_BANKING",    label="KBank"},
                            {group="Mobile Banking",   code="BBL_MOBILE_BANKING",      label="Bangkok Bank"},
                            {group="Mobile Banking",   code="SCB_MOBILE_BANKING",      label="SCB"},
                            {group="Mobile Banking",   code="KTB_MOBILE_BANKING",      label="Krungthai Bank"},
                            {group="Mobile Banking",   code="KRUNGSRI_MOBILE_BANKING", label="Krungsri"}
                        ]>
                        <cfelseif countryCode eq "VN">
                        <cfset allMethods = [
                            {group="E-Wallet",         code="MOMO",                    label="MoMo"},
                            {group="E-Wallet",         code="ZALOPAY",                 label="ZaloPay"},
                            {group="E-Wallet",         code="SHOPEEPAY",               label="ShopeePay"},
                            {group="E-Wallet",         code="VNPTWALLET",              label="VNPTWallet"},
                            {group="Card",             code="CARDS",                   label="Credit / Debit Card"},
                            {group="Virtual Account",  code="BIDV_VIRTUAL_ACCOUNT",    label="BIDV"},
                            {group="Virtual Account",  code="MSB_VIRTUAL_ACCOUNT",     label="MSB"},
                            {group="Virtual Account",  code="VPB_VIRTUAL_ACCOUNT",     label="VPBank"}
                        ]>
                        </cfif>

                        <cfset currentGroup = "">
                        <div class="row">
                        <cfloop array="#allMethods#" index="m">
                            <cfif m.group neq currentGroup>
                                <cfif len(currentGroup)></div><div style="height:8px"></div></cfif>
                                <div class="col-xs-12">
                                    <strong style="font-size:12px;color:##555;text-transform:uppercase;letter-spacing:.5px">
                                        #HTMLEditFormat(m.group)#
                                    </strong>
                                    <hr style="margin:4px 0 8px">
                                </div>
                                <cfset currentGroup = m.group>
                            </cfif>
                            <div class="col-sm-4 col-xs-6" style="margin-bottom:6px">
                                <label style="font-weight:normal;font-size:13px">
                                    <input type="checkbox" name="methods" value="#m.code#"
                                           <cfif NOT methodsConfigured OR listFindNoCase(enabledMethods, m.code)>checked</cfif>>
                                    &nbsp;#HTMLEditFormat(m.label)#
                                </label>
                            </div>
                        </cfloop>
                        </div>

                        <div style="margin-top:16px">
                            <button type="submit" class="btn btn-primary btn-sm">Save Payment Methods</button>
                            <span class="text-muted" style="font-size:11px;margin-left:10px">
                                Changes apply immediately to new customer invoices.
                            </span>
                        </div>
                    </form>
                </div>
            </div>
        </div>

    </div><!--- end panel-group --->

</cfoutput>
</body>
</html>
