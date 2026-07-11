<cfprocessingdirective pageencoding="UTF-8">
<cfinclude template="../../application.cfm">

<!--- ── Waiter session defaults ── --->
<cfparam name="SESSION.waiter_loggedin" default="No">
<cfparam name="SESSION.waiter_id"       default="">
<cfparam name="SESSION.waiter_name"     default="">
<cfparam name="SESSION.waiter_dts"      default="">

<!--- ── Logout ── --->
<cfif isDefined("url.waiter_logout") AND url.waiter_logout EQ "1">
    <cfset SESSION.waiter_loggedin = "No">
    <cfset SESSION.waiter_id       = "">
    <cfset SESSION.waiter_name     = "">
    <cfset SESSION.waiter_dts      = "">
    <cflocation url="WaiterDashboard.cfm" addtoken="false">
</cfif>

<!--- ── Handle login form POST ── --->
<cfset loginError = "">
<cfif isDefined("form.waiter_login_submit")>
    <cfif NOT len(trim(form.waiter_id))>
        <cfset loginError = "Please select a cashier.">
    <cfelseif NOT len(trim(form.waiter_password))>
        <cfset loginError = "Please enter your password.">
    <cfelse>
        <cfquery name="qCheckCashier" datasource="#dts#">
            SELECT cashierID, name
            FROM   cashier
            WHERE  cashierID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.waiter_id)#">
              AND  password  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.waiter_password)#">
        </cfquery>
        <cfif qCheckCashier.recordcount EQ 1>
            <cfset SESSION.waiter_loggedin = "Yes">
            <cfset SESSION.waiter_id       = qCheckCashier.cashierID>
            <cfset SESSION.waiter_name     = qCheckCashier.name>
            <cfset SESSION.waiter_dts      = dts>
            <cflocation url="WaiterDashboard.cfm" addtoken="false">
        <cfelse>
            <cfset loginError = "Invalid cashier ID or password.">
        </cfif>
    </cfif>
</cfif>

<!--- ── Show login page if not authenticated as waiter ── --->
<cfif SESSION.waiter_loggedin NEQ "Yes" OR SESSION.waiter_dts NEQ dts>

    <cfquery name="qCashiers" datasource="#dts#">
        SELECT cashierID, name FROM cashier ORDER BY name
    </cfquery>

    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Waiter Login</title>
        <link rel="stylesheet" href="/latest/css/bootstrap/bootstrap.min.css" />
        <style>
            body { background: #f5f5f5; }
            .login-card {
                max-width: 380px;
                margin: 80px auto;
                background: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 12px rgba(0,0,0,.12);
                padding: 32px 28px;
            }
            .login-card h3 { margin-top: 0; margin-bottom: 24px; text-align: center; }
            .login-card .form-group { margin-bottom: 16px; }
            .login-card .btn-block { margin-top: 20px; }
            .error-msg { color: #c0392b; font-size: 13px; margin-bottom: 12px; }
        </style>
    </head>
    <body>
    <cfoutput>
    <div class="login-card">
        <h3>Waiter Sign-In</h3>
        <cfif len(loginError)>
            <p class="error-msg">#loginError#</p>
        </cfif>
        <form method="post" action="WaiterDashboard.cfm">
            <div class="form-group">
                <label>Cashier</label>
                <select name="waiter_id" class="form-control" required>
                    <option value="">-- Select --</option>
                    <cfloop query="qCashiers">
                        <option value="#cashierID#">#cashierID# - #name#</option>
                    </cfloop>
                </select>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="waiter_password" class="form-control" required />
            </div>
            <input type="hidden" name="waiter_login_submit" value="1" />
            <button type="submit" class="btn btn-primary btn-block">Sign In</button>
        </form>
    </div>
    </cfoutput>
    </body>
    </html>
    <cfabort>
</cfif>

<!--- ── Authenticated — render dashboard ── --->
<cfset dashboardMode = true>
<cfinclude template="Tables.cfm">
