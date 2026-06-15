<!---
    /PaymentGateway/withdrawal.cfm
    Client payout withdrawal page.
    Shows pending balance, bank account selector, withdraw button, and history.
--->
<cfset pageTitle = "Payout Withdrawal">

<!--- Load all registered bank accounts for this client --->
<cfset migrationPending = false>
<cfset hasAccounts = false>
<cftry>
    <cfquery name="qAccounts" datasource="#dts#">
        SELECT id, bank_code, account_number, account_name,
               platform_fee_pct, absorb_gateway_fee, is_default, is_active
        FROM   main.client_payment_accounts
        WHERE  dts = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#">
        ORDER  BY is_default DESC, is_active DESC, id ASC
    </cfquery>
    <cfset hasAccounts = (qAccounts.recordCount gt 0)>

    <!--- Pending disbursements: sum of client's pending order payouts --->
    <cfquery name="qBalance" datasource="#dts#">
        SELECT COUNT(*)                AS pending_count,
               COALESCE(SUM(gross_amount),    0) AS total_gross,
               COALESCE(SUM(platform_fee),    0) AS total_platform_fee,
               COALESCE(SUM(disburse_amount), 0) AS available_balance
        FROM   main.disbursements
        WHERE  dts    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#">
          AND  status = 'pending'
    </cfquery>

    <!--- Recent pending orders detail (last 50) --->
    <cfquery name="qPending" datasource="#dts#">
        SELECT d.id, d.order_id, d.gross_amount, d.platform_fee, d.disburse_amount,
               d.created_at, o.order_number
        FROM   main.disbursements d
        LEFT   JOIN #dts#.app_orders o ON o.order_id = d.order_id
        WHERE  d.dts    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#">
          AND  d.status = 'pending'
        ORDER  BY d.created_at DESC
        LIMIT  50
    </cfquery>

<cfcatch type="database">
    <cfset migrationPending = true>
</cfcatch>
</cftry>

<!--- Withdrawal history — separate try so a missing table doesn't block the balance panel --->
<cfset qHistory = queryNew("id,account_id,total_gross,total_platform_fee,xendit_fee,total_disburse,xendit_disburse_id,status,requested_at,completed_at,notes,bank_code,account_number,account_name")>
<cftry>
    <cfquery name="qHistory" datasource="#dts#">
        SELECT b.id, b.account_id, b.total_gross, b.total_platform_fee,
               b.xendit_fee, b.total_disburse, b.xendit_disburse_id,
               b.status, b.requested_at, b.completed_at, b.notes,
               a.bank_code, a.account_number, a.account_name
        FROM   main.disbursement_batches b
        LEFT   JOIN main.client_payment_accounts a ON a.id = b.account_id
        WHERE  b.dts = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#">
        ORDER  BY b.requested_at DESC
        LIMIT  20
    </cfquery>
<cfcatch type="database"><!--- table not yet created — history stays empty --->
</cfcatch>
</cftry>

<cfset successMsg = (isDefined("url.msg")   AND len(trim(url.msg)))   ? trim(url.msg)   : "">
<cfset errorMsg   = (isDefined("url.err")   AND len(trim(url.err)))   ? trim(url.err)   : "">

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
        .balance-card { background:##f0f9f0; border:1px solid ##c3e6cb; border-radius:6px; padding:20px 24px; margin-bottom:20px; }
        .balance-card .amount { font-size:32px; font-weight:700; color:##155724; margin:4px 0; }
        .balance-card .sub    { font-size:12px; color:##6c757d; }
        .badge-pending   { background:##f0ad4e; }
        .badge-disbursed { background:##5cb85c; }
        .badge-failed    { background:##d9534f; }
        .table-sm td, .table-sm th { font-size:12px; padding:5px 8px; }
    </style>
</head>
<body class="container">
<cfoutput>

<div class="page-header">
    <h3>#pageTitle#
        <small>Withdraw your accumulated online payment balance</small>
    </h3>
</div>

<cfif len(successMsg)>
    <div class="alert alert-success">#HTMLEditFormat(successMsg)#</div>
</cfif>
<cfif len(errorMsg)>
    <div class="alert alert-danger">#HTMLEditFormat(errorMsg)#</div>
</cfif>

<cfif migrationPending>
    <div class="alert alert-warning">
        <strong>Setup required.</strong>
        Run the database migration for <code>main.disbursements</code> and
        <code>main.disbursement_batches</code> first, then reload this page.
    </div>
    <cfabort>
</cfif>

<cfif NOT hasAccounts>
    <div class="alert alert-info">
        <strong>No bank account registered.</strong>
        Go to <a href="paymentProfile.cfm">Payment Gateway Profile</a> to add a disbursement bank account first.
    </div>
</cfif>

<!--- ── Balance summary ── --->
<div class="balance-card">
    <div class="row">
        <div class="col-sm-4">
            <div class="sub">Available Balance</div>
            <div class="amount">Rp #numberFormat(val(qBalance.available_balance), "9,990")#</div>
            <div class="sub">#val(qBalance.pending_count)# order(s) pending</div>
        </div>
        <div class="col-sm-4">
            <div class="sub">Total Gross</div>
            <div style="font-size:20px;font-weight:600;color:##333;margin:4px 0">
                Rp #numberFormat(val(qBalance.total_gross), "9,990")#
            </div>
            <div class="sub">before platform fee</div>
        </div>
        <div class="col-sm-4">
            <div class="sub">Platform Fee Deducted</div>
            <div style="font-size:20px;font-weight:600;color:##c0392b;margin:4px 0">
                &minus; Rp #numberFormat(val(qBalance.total_platform_fee), "9,990")#
            </div>
        </div>
    </div>
</div>

<!--- ── Withdraw form ── --->
<cfif hasAccounts AND val(qBalance.available_balance) gt 0>
<div class="panel panel-success">
    <div class="panel-heading"><h4 class="panel-title">Withdraw Now</h4></div>
    <div class="panel-body">
        <form class="form-horizontal" method="post" action="withdrawalProcess.cfm"
              onsubmit="return confirmWithdraw()">
            <div class="form-group">
                <label class="col-sm-3 control-label">Destination Account</label>
                <div class="col-sm-6">
                    <select class="form-control" name="account_id" required>
                        <cfloop query="qAccounts">
                            <cfif qAccounts.is_active>
                            <option value="#qAccounts.id#" <cfif qAccounts.is_default>selected</cfif>>
                                #HTMLEditFormat(qAccounts.bank_code)# — #HTMLEditFormat(qAccounts.account_number)# (#HTMLEditFormat(qAccounts.account_name)#)
                                <cfif qAccounts.is_default> [DEFAULT]</cfif>
                            </option>
                            </cfif>
                        </cfloop>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Amount to Withdraw</label>
                <div class="col-sm-4">
                    <div class="input-group">
                        <span class="input-group-addon">Rp</span>
                        <input type="text" class="form-control" readonly
                               value="#numberFormat(val(qBalance.available_balance), "9,990")#">
                    </div>
                    <span class="help-block" style="font-size:11px">
                        Full balance. Xendit disbursement fee (Rp 5,000) may be deducted
                        depending on your account settings.
                    </span>
                </div>
            </div>
            <div class="form-group">
                <div class="col-sm-offset-3 col-sm-6">
                    <button type="submit" class="btn btn-success btn-lg">
                        <span class="glyphicon glyphicon-arrow-right"></span>
                        Withdraw Rp #numberFormat(val(qBalance.available_balance), "9,990")#
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>
<cfelseif hasAccounts>
    <div class="alert alert-info" style="margin-bottom:20px">
        No pending balance to withdraw at this time.
    </div>
</cfif>

<!--- ── Pending orders detail (collapsible) ── --->
<cfif qPending.recordCount gt 0>
<div class="panel panel-default">
    <div class="panel-heading" style="cursor:pointer" data-toggle="collapse" href="##pendingPanel">
        <h4 class="panel-title">
            Pending Orders &nbsp;<span class="badge badge-pending">#qPending.recordCount#</span>
            <small class="pull-right text-muted" style="font-weight:normal;font-size:12px;margin-top:2px">click to expand</small>
        </h4>
    </div>
    <div id="pendingPanel" class="panel-collapse collapse">
        <div class="panel-body" style="padding:0">
            <table class="table table-condensed table-striped table-sm" style="margin:0">
                <thead>
                    <tr>
                        <th>Order</th>
                        <th class="text-right">Gross</th>
                        <th class="text-right">Platform Fee</th>
                        <th class="text-right">Net</th>
                        <th>Date Paid</th>
                    </tr>
                </thead>
                <tbody>
                    <cfloop query="qPending">
                    <tr>
                        <td>#HTMLEditFormat(qPending.order_number)#</td>
                        <td class="text-right">Rp #numberFormat(val(qPending.gross_amount), "9,990")#</td>
                        <td class="text-right text-danger">- Rp #numberFormat(val(qPending.platform_fee), "9,990")#</td>
                        <td class="text-right"><strong>Rp #numberFormat(val(qPending.disburse_amount), "9,990")#</strong></td>
                        <td>#dateFormat(qPending.created_at,"dd mmm yyyy")# #timeFormat(qPending.created_at,"HH:mm")#</td>
                    </tr>
                    </cfloop>
                </tbody>
                <tfoot>
                    <tr style="background:##e8f4e8;font-weight:bold">
                        <td>TOTAL</td>
                        <td class="text-right">Rp #numberFormat(val(qBalance.total_gross), "9,990")#</td>
                        <td class="text-right text-danger">- Rp #numberFormat(val(qBalance.total_platform_fee), "9,990")#</td>
                        <td class="text-right">Rp #numberFormat(val(qBalance.available_balance), "9,990")#</td>
                        <td></td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </div>
</div>
</cfif>

<!--- ── Withdrawal history ── --->
<div class="panel panel-default">
    <div class="panel-heading">
        <h4 class="panel-title">Withdrawal History</h4>
    </div>
    <div class="panel-body" style="padding:0">
        <cfif qHistory.recordCount eq 0>
            <p class="text-muted" style="padding:15px;margin:0">No withdrawals yet.</p>
        <cfelse>
            <table class="table table-condensed table-striped table-sm" style="margin:0">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Bank</th>
                        <th class="text-right">Gross</th>
                        <th class="text-right">Fee</th>
                        <th class="text-right">Disbursed</th>
                        <th>Xendit ID</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <cfloop query="qHistory">
                    <cfset statusBadge = "default">
                    <cfif qHistory.status eq "disbursed">  <cfset statusBadge = "success">
                    <cfelseif qHistory.status eq "pending"><cfset statusBadge = "warning">
                    <cfelseif qHistory.status eq "failed"> <cfset statusBadge = "danger">
                    </cfif>
                    <tr>
                        <td>#dateFormat(qHistory.requested_at,"dd mmm yyyy")# #timeFormat(qHistory.requested_at,"HH:mm")#</td>
                        <td>
                            <strong>#HTMLEditFormat(qHistory.bank_code)#</strong><br>
                            <small>#HTMLEditFormat(qHistory.account_number)#</small>
                        </td>
                        <td class="text-right">Rp #numberFormat(val(qHistory.total_gross), "9,990")#</td>
                        <td class="text-right text-danger">
                            <cfif val(qHistory.total_platform_fee) gt 0>
                                Rp #numberFormat(val(qHistory.total_platform_fee), "9,990")#
                            </cfif>
                            <cfif val(qHistory.xendit_fee) gt 0>
                                <br><small>+Rp #numberFormat(val(qHistory.xendit_fee), "9,990")# (Xendit)</small>
                            </cfif>
                        </td>
                        <td class="text-right"><strong>Rp #numberFormat(val(qHistory.total_disburse), "9,990")#</strong></td>
                        <td style="font-size:11px;word-break:break-all">
                            <cfif len(trim(qHistory.xendit_disburse_id))>
                                <code>#HTMLEditFormat(qHistory.xendit_disburse_id)#</code>
                            <cfelse>
                                <span class="text-muted">&mdash;</span>
                            </cfif>
                        </td>
                        <td><span class="label label-#statusBadge#">#HTMLEditFormat(qHistory.status)#</span></td>
                    </tr>
                    </cfloop>
                </tbody>
            </table>
        </cfif>
    </div>
</div>

</cfoutput>
<script>
function confirmWithdraw() {
    var btn = document.querySelector('button[type=submit]');
    if (btn) { btn.disabled = true; btn.textContent = 'Processing...'; }
    return confirm('Confirm withdrawal? Funds will be transferred to your registered bank account.');
}
</script>
</body>
</html>
