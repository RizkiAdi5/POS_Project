<!---
    /latest/Waiter/inc_waiter_login.cfm
    Shared staff login gate for the Waiter POS flow (WaiterPOS.cfm + its Order/
    Payment process files). Same cashier login and SESSION.waiter_* variables
    as WaiterDashboard.cfm, so logging in/out from either place applies to both.
    Include this right after /application.cfm on every page in the flow —
    each is its own HTTP entry point (form posts / cflocations go straight to
    them), so the dashboard's own gate doesn't cover them.
--->
<cfparam name="SESSION.waiter_loggedin" default="No">
<cfparam name="SESSION.waiter_id"       default="">
<cfparam name="SESSION.waiter_name"     default="">
<cfparam name="SESSION.waiter_dts"      default="">

<cfset wposSelfUrl = CGI.SCRIPT_NAME>

<!--- ── Logout ── --->
<cfif isDefined("url.waiter_logout") AND url.waiter_logout EQ "1">
    <cfset SESSION.waiter_loggedin = "No">
    <cfset SESSION.waiter_id       = "">
    <cfset SESSION.waiter_name     = "">
    <cfset SESSION.waiter_dts      = "">
    <cflocation url="#wposSelfUrl#" addtoken="false">
</cfif>

<!--- ── Handle login form POST ── --->
<cfset wposLoginError = "">
<cfif isDefined("form.waiter_login_submit")>
    <cfif NOT len(trim(form.waiter_id))>
        <cfset wposLoginError = "Please select a cashier.">
    <cfelseif NOT len(trim(form.waiter_password))>
        <cfset wposLoginError = "Please enter your password.">
    <cfelse>
        <cfquery name="qWposCheckCashier" datasource="#dts#">
            SELECT cashierID, name
            FROM   cashier
            WHERE  cashierID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.waiter_id)#">
              AND  password  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.waiter_password)#">
        </cfquery>
        <cfif qWposCheckCashier.recordcount EQ 1>
            <cfset SESSION.waiter_loggedin = "Yes">
            <cfset SESSION.waiter_id       = qWposCheckCashier.cashierID>
            <cfset SESSION.waiter_name     = qWposCheckCashier.name>
            <cfset SESSION.waiter_dts      = dts>
            <cflocation url="#wposSelfUrl#" addtoken="false">
        <cfelse>
            <cfset wposLoginError = "Invalid cashier ID or password.">
        </cfif>
    </cfif>
</cfif>

<!--- ── Show login chooser if not authenticated for this branch ── --->
<cfif SESSION.waiter_loggedin NEQ "Yes" OR SESSION.waiter_dts NEQ dts>

    <cfquery name="qWposCashiers" datasource="#dts#">
        SELECT cashierID, name FROM cashier ORDER BY name
    </cfquery>

    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta http-equiv="cache-control" content="no-cache" />
        <title>Waiter POS</title>
        <link rel="stylesheet" href="/latest/css/bootstrap/bootstrap.min.css" />
        <style>
            body { margin:0; padding:0; background:#888; }
            .overlay { position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.55); display:flex; align-items:center; justify-content:center; z-index:9999; }
            .chooser-box { background:#fff; width:440px; border-radius:4px; overflow:hidden; box-shadow:0 4px 24px rgba(0,0,0,.35); }
            .chooser-header { background:#c0392b; color:#fff; text-align:center; padding:16px; font-size:18px; font-weight:bold; }
            .chooser-body { padding:24px 28px 20px; }
            .chooser-body table { width:100%; }
            .chooser-body td { padding:8px 6px; vertical-align:middle; }
            .chooser-body td:first-child { white-space:nowrap; padding-right:14px; font-size:14px; }
            .chooser-body select, .chooser-body input[type=password] { width:100%; padding:6px 10px; border:1px solid #ccc; border-radius:3px; font-size:14px; }
            .chooser-footer { text-align:center; padding:0 28px 20px; }
            .chooser-footer .btn-go { padding:7px 36px; background:#e8e8e8; border:1px solid #ccc; border-radius:3px; font-size:14px; cursor:pointer; }
            .chooser-footer .btn-go:hover { background:#d4d4d4; }
            .error-msg { color:#c0392b; font-size:13px; text-align:center; margin-bottom:8px; }
        </style>
    </head>
    <body>
    <cfoutput>
    <div class="overlay">
        <div class="chooser-box">
            <div class="chooser-header">Choose a Waiter</div>
            <form method="post" action="#wposSelfUrl#">
            <div class="chooser-body">
                <cfif len(wposLoginError)>
                    <p class="error-msg">#wposLoginError#</p>
                </cfif>
                <table>
                    <tr>
                        <td>Cashier :</td>
                        <td>
                            <select name="waiter_id" required>
                                <option value="">Choose a Cashier</option>
                                <cfloop query="qWposCashiers">
                                    <option value="#cashierID#">#cashierID# - #name#</option>
                                </cfloop>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>Password :</td>
                        <td><input type="password" name="waiter_password" /></td>
                    </tr>
                </table>
            </div>
            <div class="chooser-footer">
                <input type="hidden" name="waiter_login_submit" value="1" />
                <button type="submit" class="btn-go">Go</button>
            </div>
            </form>
        </div>
    </div>
    </cfoutput>
    </body>
    </html>
    <cfabort>
</cfif>
