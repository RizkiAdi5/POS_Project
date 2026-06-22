<!---
    /PaymentGateway/paymentProfile.cfm
    Super: Xendit API credentials + fee settings.
    All users: manage disbursement bank accounts (multi-account).
--->
<cfset pageTitle   = "Payment Gateway Profile">
<cfset isSuperUser = (husergrpid eq "super")>

<!--- Super-only: Xendit gateway credentials --->
<cfif isSuperUser>
    <cfquery name="qGateway" datasource="#dts#">
        SELECT id, api_name, secret_key, public_key, webhook_token, is_active
        FROM   main.master_api
        WHERE  provider = <cfqueryparam cfsqltype="cf_sql_varchar" value="Xendit">
        LIMIT  1
    </cfquery>
    <cfset gatewayId      = (qGateway.recordCount ? trim(qGateway.id)            : "")>
    <cfset gatewayApiName = (qGateway.recordCount ? trim(qGateway.api_name)      : "Xendit")>
    <cfset gatewaySecret  = (qGateway.recordCount ? trim(qGateway.secret_key)    : "")>
    <cfset gatewayPublic  = (qGateway.recordCount ? trim(qGateway.public_key)    : "")>
    <cfset gatewayWebhook = (qGateway.recordCount ? trim(qGateway.webhook_token) : "")>
    <cfset gatewayActive  = (qGateway.recordCount ? trim(qGateway.is_active)     : "Y")>
</cfif>

<!--- All registered bank accounts for this client --->
<cfset migrationPending = false>
<cftry>
    <cfquery name="qAccounts" datasource="#dts#">
        SELECT id, bank_code, account_number, account_name,
               platform_fee_pct, absorb_gateway_fee, is_default, is_active
        FROM   main.client_payment_accounts
        WHERE  dts = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#">
        ORDER  BY is_default DESC, is_active DESC, id ASC
    </cfquery>
<cfcatch type="database">
    <cfset migrationPending = true>
</cfcatch>
</cftry>

<!--- Payment method config for this client --->
<cfset enabledMethods = "">
<cftry>
    <cfquery name="qMethods" datasource="#dts#">
        SELECT method_code FROM main.payment_method_config
        WHERE  dts        = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#">
          AND  is_enabled = 1
    </cfquery>
    <cfloop query="qMethods">
        <cfset enabledMethods = listAppend(enabledMethods, trim(qMethods.method_code))>
    </cfloop>
    <cfset methodsConfigured = (qMethods.recordCount gt 0)>
<cfcatch type="database">
    <cfset methodsConfigured = false>
</cfcatch>
</cftry>

<!--- Pre-fill edit modal from URL params --->
<cfset editId          = val(isDefined("url.edit_id")         ? url.edit_id         : 0)>
<cfset editBankCode    = trim(isDefined("url.edit_bank")      ? url.edit_bank       : "")>
<cfset editAcctNum     = trim(isDefined("url.edit_num")       ? url.edit_num        : "")>
<cfset editAcctName    = trim(isDefined("url.edit_name")      ? url.edit_name       : "")>
<cfset editFeePct      = trim(isDefined("url.edit_fee")       ? url.edit_fee        : "2.00")>
<cfset editAbsorb      = val(isDefined("url.edit_absorb")     ? url.edit_absorb     : 0)>
<cfset editActive      = val(isDefined("url.edit_active")     ? url.edit_active     : 1)>

<cfset successMsg = (isDefined("url.saved") AND url.saved eq "1") ? "Settings saved successfully." : "">
<cfset errorMsg   = (isDefined("url.err")   AND len(trim(url.err)))  ? trim(url.err)              : "">
<cfset xenditBanks = "BCA,BNI,BRI,MANDIRI,PERMATA,CIMB,DANAMON,BTN,OCBC,HSBC,MEGA,BUKOPIN,BSI,JAGO">

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

<cfif migrationPending AND isSuperUser>
    <div class="alert alert-warning">
        <strong>Migration required:</strong> Run the SQL below first.
        <pre style="margin-top:8px;font-size:11px;background:##f5f5f5;padding:10px;border-radius:4px">CREATE TABLE IF NOT EXISTS main.client_payment_accounts (
  id                  INT AUTO_INCREMENT PRIMARY KEY,
  dts                 VARCHAR(50)   NOT NULL,
  bank_code           VARCHAR(20)   NOT NULL,
  account_number      VARCHAR(30)   NOT NULL,
  account_name        VARCHAR(100)  NOT NULL,
  platform_fee_pct    DECIMAL(5,2)  NOT NULL DEFAULT 2.00,
  absorb_gateway_fee  TINYINT(1)    NOT NULL DEFAULT 0,
  is_default          TINYINT(1)    NOT NULL DEFAULT 0,
  is_active           TINYINT(1)    NOT NULL DEFAULT 1,
  created_at          TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
  updated_at          TIMESTAMP     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_dts_account (dts, account_number)
);</pre>
    </div>
</cfif>

<div class="panel-group">

    <!--- ── Panel 1: Xendit API Credentials — SUPER ONLY ── --->
    <cfif isSuperUser>
    <div class="panel panel-default">
        <div class="panel-heading" data-toggle="collapse" href="##xenditPanel" style="cursor:pointer">
            <h4 class="panel-title accordion-toggle">
                Xendit API Credentials
                <small class="text-muted" style="font-size:11px;font-weight:normal"> — operator only</small>
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
                            <label for="gatewayPublic" class="col-sm-4 control-label">Public Key</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control input-sm"
                                       id="gatewayPublic" name="gatewayPublic"
                                       value="#HTMLEditFormat(gatewayPublic)#"
                                       placeholder="xnd_public_development_..." maxlength="200">
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
    </cfif>

    <!--- ── Panel 2: Disbursement Bank Accounts ── --->
    <cfif NOT migrationPending>
    <div class="panel panel-default">
        <div class="panel-heading">
            <h4 class="panel-title">Disbursement Bank Accounts</h4>
        </div>
        <div class="panel-body">
            <p class="text-muted" style="font-size:12px;margin-bottom:12px">
                Payout requests from the Withdrawal page will be sent to the <strong>default</strong> account.
                You can register multiple accounts and switch the default at any time.
            </p>

            <!--- Accounts table --->
            <cfif qAccounts.recordCount gt 0>
            <table class="table table-condensed table-bordered table-accts">
                <thead>
                    <tr>
                        <th>Bank</th>
                        <th>Account No.</th>
                        <th>Account Name</th>
                        <cfif isSuperUser><th>Fee %</th><th>Absorb Fee</th></cfif>
                        <th>Default</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <cfloop query="qAccounts">
                    <tr class="<cfif NOT qAccounts.is_active>text-muted</cfif>">
                        <td><strong>#HTMLEditFormat(qAccounts.bank_code)#</strong></td>
                        <td><code>#HTMLEditFormat(qAccounts.account_number)#</code></td>
                        <td>#HTMLEditFormat(qAccounts.account_name)#</td>
                        <cfif isSuperUser>
                        <td>#numberFormat(val(qAccounts.platform_fee_pct),"9,990.00")#%</td>
                        <td>#(qAccounts.absorb_gateway_fee ? "Yes" : "No")#</td>
                        </cfif>
                        <td>
                            <cfif qAccounts.is_default>
                                <span class="label label-default-acct">DEFAULT</span>
                            <cfelse>
                                <form method="post" action="paymentProfileProcess.cfm" style="display:inline">
                                    <input type="hidden" name="action"     value="set_default">
                                    <input type="hidden" name="account_id" value="#qAccounts.id#">
                                    <button type="submit" class="btn btn-xs btn-default">Set Default</button>
                                </form>
                            </cfif>
                        </td>
                        <td>
                            <span class="label label-#(qAccounts.is_active ? 'success' : 'default')#">
                                #(qAccounts.is_active ? 'Active' : 'Inactive')#
                            </span>
                        </td>
                        <td style="white-space:nowrap">
                            <!--- Edit button — passes values via URL for modal pre-fill --->
                            <a href="paymentProfile.cfm?edit_id=#qAccounts.id#&edit_bank=#URLEncodedFormat(qAccounts.bank_code)#&edit_num=#URLEncodedFormat(qAccounts.account_number)#&edit_name=#URLEncodedFormat(qAccounts.account_name)#&edit_fee=#URLEncodedFormat(qAccounts.platform_fee_pct)#&edit_absorb=#qAccounts.absorb_gateway_fee#&edit_active=#qAccounts.is_active###editModal"
                               class="btn btn-xs btn-info" data-toggle="modal" data-target="##editModal">
                                Edit
                            </a>
                            <!--- Toggle active --->
                            <form method="post" action="paymentProfileProcess.cfm" style="display:inline">
                                <input type="hidden" name="action"     value="toggle_active">
                                <input type="hidden" name="account_id" value="#qAccounts.id#">
                                <button type="submit" class="btn btn-xs btn-#(qAccounts.is_active ? 'warning' : 'success')#">
                                    #(qAccounts.is_active ? 'Deactivate' : 'Activate')#
                                </button>
                            </form>
                            <!--- Delete (not if default and only account) --->
                            <cfif NOT (qAccounts.is_default AND qAccounts.recordCount eq 1)>
                            <form method="post" action="paymentProfileProcess.cfm" style="display:inline"
                                  onsubmit="return confirm('Delete this account?')">
                                <input type="hidden" name="action"     value="delete_account">
                                <input type="hidden" name="account_id" value="#qAccounts.id#">
                                <button type="submit" class="btn btn-xs btn-danger">Delete</button>
                            </form>
                            </cfif>
                        </td>
                    </tr>
                    </cfloop>
                </tbody>
            </table>
            </cfif>

            <!--- Add new account button --->
            <button type="button" class="btn btn-success btn-sm" data-toggle="modal" data-target="##addModal">
                <span class="glyphicon glyphicon-plus"></span> Add Bank Account
            </button>
        </div>
    </div>
    </cfif>

    <!--- ── Panel 3: Payment Methods ── --->
        <div class="panel panel-default">
            <div class="panel-heading" data-toggle="collapse" href="##methodsPanel" style="cursor:pointer">
                <h4 class="panel-title accordion-toggle">
                    Accepted Payment Methods
                    <small class="text-muted" style="font-size:11px;font-weight:normal">
                        — controls what customers see on the Xendit payment page
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

                        <cfset allMethods = [
                            {group="QRIS",             code="QRIS",          label="QRIS (QR Code)"},
                            {group="Virtual Account",  code="BCA",           label="BCA Virtual Account"},
                            {group="Virtual Account",  code="BNI",           label="BNI Virtual Account"},
                            {group="Virtual Account",  code="BRI",           label="BRI Virtual Account"},
                            {group="Virtual Account",  code="MANDIRI",       label="Mandiri Virtual Account"},
                            {group="Virtual Account",  code="PERMATA",       label="Permata Virtual Account"},
                            {group="Virtual Account",  code="BSI",           label="BSI Virtual Account"},
                            {group="Virtual Account",  code="CIMB",          label="CIMB Virtual Account"},
                            {group="Virtual Account",  code="BJB",           label="BJB Virtual Account"},
                            {group="Virtual Account",  code="BNC",           label="BNC Virtual Account"},
                            {group="E-Wallet",         code="OVO",           label="OVO"},
                            {group="E-Wallet",         code="DANA",          label="DANA"},
                            {group="E-Wallet",         code="SHOPEEPAY",     label="ShopeePay"},
                            {group="E-Wallet",         code="LINKAJA",       label="LinkAja"},
                            {group="E-Wallet",         code="ASTRAPAY",      label="AstraPay"},
                            {group="E-Wallet",         code="GOPAY",         label="GoPay"},
                            {group="E-Wallet",         code="JENIUSPAY",     label="Jenius Pay"},
                            {group="Credit Card",      code="CREDIT_CARD",   label="Credit / Debit Card"},
                            {group="Retail Outlet",    code="ALFAMART",      label="Alfamart"},
                            {group="Retail Outlet",    code="INDOMARET",     label="Indomaret"}
                        ]>

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

<!--- ── Add Account Modal ── --->
<div class="modal fade" id="addModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <form class="form-horizontal" method="post" action="paymentProfileProcess.cfm">
                <input type="hidden" name="action" value="add_account">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">Add Bank Account</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label class="col-sm-4 control-label">Bank</label>
                        <div class="col-sm-7">
                            <select class="form-control input-sm" name="bankCode" required>
                                <option value="">-- Select --</option>
                                <cfloop list="#xenditBanks#" index="b">
                                    <option value="#b#">#b#</option>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-4 control-label">Account Number</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control input-sm" name="accountNumber"
                                   placeholder="Bank account number" maxlength="30" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-4 control-label">Account Name</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control input-sm" name="accountName"
                                   placeholder="As registered with bank" maxlength="100" required>
                        </div>
                    </div>
                    <cfif isSuperUser>
                    <div class="form-group">
                        <label class="col-sm-4 control-label">Platform Fee %</label>
                        <div class="col-sm-4">
                            <div class="input-group input-group-sm">
                                <input type="number" class="form-control" name="platformFeePct"
                                       value="2.00" min="0" max="100" step="0.01">
                                <span class="input-group-addon">%</span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-4 control-label">Disburse Fee</label>
                        <div class="col-sm-7">
                            <div class="checkbox" style="margin-top:5px">
                                <label>
                                    <input type="checkbox" name="absorbFee" value="1">
                                    Client absorbs Xendit fee (Rp 5,000)
                                </label>
                            </div>
                        </div>
                    </div>
                    </cfif>
                    <div class="form-group">
                        <label class="col-sm-4 control-label">Set as Default</label>
                        <div class="col-sm-7">
                            <div class="checkbox" style="margin-top:5px">
                                <label>
                                    <input type="checkbox" name="setAsDefault" value="1"
                                           <cfif qAccounts.recordCount eq 0>checked</cfif>>
                                    Use as default payout account
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-success">Add Account</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!--- ── Edit Account Modal ── --->
<div class="modal fade" id="editModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <form class="form-horizontal" method="post" action="paymentProfileProcess.cfm">
                <input type="hidden" name="action"     value="edit_account">
                <input type="hidden" name="account_id" id="editAccountId" value="#editId#">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">Edit Bank Account</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label class="col-sm-4 control-label">Bank</label>
                        <div class="col-sm-7">
                            <select class="form-control input-sm" name="bankCode" id="editBankCode" required>
                                <option value="">-- Select --</option>
                                <cfloop list="#xenditBanks#" index="b">
                                    <option value="#b#" <cfif editBankCode eq b>selected</cfif>>#b#</option>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-4 control-label">Account Number</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control input-sm" name="accountNumber"
                                   id="editAcctNum" value="#HTMLEditFormat(editAcctNum)#"
                                   placeholder="Bank account number" maxlength="30" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-4 control-label">Account Name</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control input-sm" name="accountName"
                                   id="editAcctName" value="#HTMLEditFormat(editAcctName)#"
                                   placeholder="As registered with bank" maxlength="100" required>
                        </div>
                    </div>
                    <cfif isSuperUser>
                    <div class="form-group">
                        <label class="col-sm-4 control-label">Platform Fee %</label>
                        <div class="col-sm-4">
                            <div class="input-group input-group-sm">
                                <input type="number" class="form-control" name="platformFeePct"
                                       id="editFeePct" value="#HTMLEditFormat(editFeePct)#"
                                       min="0" max="100" step="0.01">
                                <span class="input-group-addon">%</span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-4 control-label">Disburse Fee</label>
                        <div class="col-sm-7">
                            <div class="checkbox" style="margin-top:5px">
                                <label>
                                    <input type="checkbox" name="absorbFee" value="1"
                                           id="editAbsorb" <cfif editAbsorb>checked</cfif>>
                                    Client absorbs Xendit fee (Rp 5,000)
                                </label>
                            </div>
                        </div>
                    </div>
                    </cfif>
                    <div class="form-group">
                        <label class="col-sm-4 control-label">Status</label>
                        <div class="col-sm-4">
                            <select class="form-control input-sm" name="acctActive" id="editActive">
                                <option value="1" <cfif editActive eq 1>selected</cfif>>Active</option>
                                <option value="0" <cfif editActive eq 0>selected</cfif>>Inactive</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

</cfoutput>
<script>
$(document).ready(function() {
    <cfif editId gt 0>
    $('#editModal').modal('show');
    </cfif>
});
</script>
</body>
</html>
