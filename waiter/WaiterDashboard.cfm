<cfprocessingdirective pageencoding="UTF-8">
<cfsetting enablecfoutputonly="false">
<cfsetting showdebugoutput="false">

<cffunction name="esc" output="false" returntype="string">
    <cfargument name="v" required="false" default="">
    <cfset var s = "">
    <cfif NOT isNull(arguments.v)><cfset s = toString(arguments.v)></cfif>
    <cfreturn HTMLEditFormat(s)>
</cffunction>

<cffunction name="normTableStatus" output="false" returntype="string">
    <cfargument name="s" type="string" required="true">
    <cfset var x = lCase(trim(arguments.s))>
    <cfswitch expression="#x#">
        <cfcase value="available,free,open"><cfreturn "available"></cfcase>
        <cfcase value="reserved,booked"><cfreturn "reserved"></cfcase>
        <cfdefaultcase><cfreturn "occupied"></cfdefaultcase>
    </cfswitch>
</cffunction>

<cfset flashMsg = "">
<cfset flashErr = "">
<cfif structKeyExists(url, "msg") AND len(trim(url.msg))><cfset flashMsg = trim(url.msg)></cfif>
<cfif structKeyExists(url, "err") AND len(trim(url.err))><cfset flashErr = trim(url.err)></cfif>

<cfset hasQrTokenColumn = false>
<cfif isDefined("dts") AND len(trim(dts))>
    <cftry>
        <cfquery name="qQrCol" datasource="#dts#">
            SELECT COUNT(*) AS col_count
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'app_tables'
              AND COLUMN_NAME = 'qr_token'
        </cfquery>
        <cfif val(qQrCol.col_count) gt 0><cfset hasQrTokenColumn = true></cfif>
        <cfcatch type="any"><cfset hasQrTokenColumn = false></cfcatch>
    </cftry>
</cfif>

<cfif isDefined("form.form_action") AND form.form_action eq "add_table" AND isDefined("dts") AND len(trim(dts))>
    <cfset tableNum = left(trim(toString(form.table_number)), 20)>
    <cfset seatsVal = int(val(form.seats))>

    <cfif NOT len(tableNum)>
        <cfset flashErr = "Table number is required.">
    <cfelseif seatsVal lte 0>
        <cfset flashErr = "Seats must be greater than zero.">
    <cfelse>
        <cftry>
            <cfquery name="qDup" datasource="#dts#">
                SELECT COUNT(*) AS row_count
                FROM app_tables
                WHERE table_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tableNum#">
            </cfquery>

            <cfif val(qDup.row_count) gt 0>
                <cfset flashErr = "Table number already exists.">
            <cfelse>
                <cfif hasQrTokenColumn>
                    <cfquery datasource="#dts#">
                        INSERT INTO app_tables (table_number, seats, qr_token, status)
                        VALUES (
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#tableNum#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#seatsVal#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(replace(createUUID(), "-", "", "all"), 100)#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="Available">
                        )
                    </cfquery>
                <cfelse>
                    <cfquery datasource="#dts#">
                        INSERT INTO app_tables (table_number, seats, status)
                        VALUES (
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#tableNum#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#seatsVal#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="Available">
                        )
                    </cfquery>
                </cfif>
                <cfset flashMsg = "Table " & tableNum & " added.">
            </cfif>
            <cfcatch type="any">
                <cfset errText = lCase(trim(cfcatch.message & " " & toString(cfcatch.detail)))>
                <cfif find("denied", errText) OR find("access denied", errText)>
                    <cfset flashErr = "MySQL permission issue. Grant SELECT and INSERT on app_tables for datasource user.">
                <cfelse>
                    <cfset flashErr = "Add table failed: " & left(trim(cfcatch.message & " " & toString(cfcatch.detail)), 300)>
                </cfif>
            </cfcatch>
        </cftry>
    </cfif>

    <cfif len(flashErr)>
        <cflocation url="WaiterDashboard.cfm?err=#URLEncodedFormat(flashErr)#" addtoken="false">
    <cfelse>
        <cflocation url="WaiterDashboard.cfm?msg=#URLEncodedFormat(flashMsg)#" addtoken="false">
    </cfif>
</cfif>

<cfset qErr = "">
<cfset qTables = queryNew("table_id")>
<cfset rows = []>
<cfset stats = {
    "total" = 0,
    "available" = 0,
    "occupied" = 0,
    "reserved" = 0
}>

<cfif isDefined("dts") AND len(trim(dts))>
    <cftry>
        <cfquery name="qTables" datasource="#dts#">
            SELECT table_id, table_number, seats, status
            FROM app_tables
            ORDER BY table_number ASC
        </cfquery>

        <cfset stats["total"] = qTables.recordCount>
        <cfloop query="qTables">
            <cfset st = normTableStatus(qTables.status)>
            <cfset stats[st] = stats[st] + 1>
            <cfset arrayAppend(rows, {
                "table_id" = val(qTables.table_id),
                "table_number" = trim(toString(qTables.table_number)),
                "seats" = val(qTables.seats),
                "status" = st
            })>
        </cfloop>
        <cfcatch type="any">
            <cfset qErr = "Load failed: " & left(trim(cfcatch.message & " " & toString(cfcatch.detail)), 320)>
        </cfcatch>
    </cftry>
<cfelse>
    <cfset qErr = "Datasource dts is not configured.">
</cfif>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Waiter Dashboard</title>
    <link rel="stylesheet" type="text/css" href="/latest/css/bootstrap/bootstrap.min.css" />
    <style type="text/css">
    body { background:#f5f7fb; font-family:"Segoe UI", Arial, sans-serif; color:#1f2937; }
    .container-top { margin-top:22px; margin-bottom:16px; }
    .title { font-size:30px; font-weight:700; margin:0; }
    .subtitle { color:#6b7280; margin:4px 0 0; }
    .panel-soft { border:1px solid #e5e7eb; border-radius:8px; box-shadow:0 1px 3px rgba(0,0,0,.04); }
    .stat-card { border:1px solid #e5e7eb; border-radius:8px; padding:12px; background:#fff; margin-bottom:12px; min-height:98px; }
    .stat-title { color:#6b7280; font-size:12px; font-weight:600; text-transform:uppercase; letter-spacing:.02em; margin:0 0 6px; }
    .stat-value { font-size:30px; font-weight:700; line-height:1; margin:0; }
    .table-card { border:1px solid #e5e7eb; border-radius:10px; background:#fff; padding:14px; margin-bottom:14px; }
    .table-card.available { border-color:#86efac; background:#f0fdf4; }
    .table-card.occupied { border-color:#fdba74; background:#fff7ed; }
    .table-card.reserved { border-color:#fde68a; background:#fefce8; }
    .table-h { margin:0; font-size:22px; font-weight:700; }
    .table-seat { color:#6b7280; font-size:12px; margin-bottom:8px; }
    .badge-soft { display:inline-block; font-size:11px; font-weight:700; border-radius:999px; padding:3px 9px; }
    .b-available { color:#166534; background:#dcfce7; }
    .b-occupied { color:#9a3412; background:#ffedd5; }
    .b-reserved { color:#854d0e; background:#fef9c3; }
    </style>
</head>
<body>
<cfoutput>
<div class="container container-top">
    <h1 class="title">Waiter Station Dashboard</h1>
    <p class="subtitle">Add table and monitor table status.</p>

    <cfif len(flashMsg)><div class="alert alert-success">#esc(flashMsg)#</div></cfif>
    <cfif len(flashErr)><div class="alert alert-danger">#esc(flashErr)#</div></cfif>
    <cfif len(qErr)><div class="alert alert-warning">#esc(qErr)#</div></cfif>

    <div class="panel panel-default panel-soft" style="margin-bottom:14px;">
        <div class="panel-heading"><strong>Add Table</strong></div>
        <div class="panel-body">
            <form method="post" action="WaiterDashboard.cfm" class="form-inline">
                <input type="hidden" name="form_action" value="add_table" />
                <div class="form-group" style="margin-right:8px;">
                    <label class="sr-only" for="table_number">Table Number</label>
                    <input type="text" class="form-control" id="table_number" name="table_number" maxlength="20" placeholder="Table Number (e.g. T-08)" required="required" />
                </div>
                <div class="form-group" style="margin-right:8px;">
                    <label class="sr-only" for="seats">Seats</label>
                    <input type="number" class="form-control" id="seats" name="seats" min="1" max="24" value="4" required="required" />
                </div>
                <button type="submit" class="btn btn-primary">Add</button>
            </form>
        </div>
    </div>

    <div class="row">
        <div class="col-md-3 col-sm-6 col-xs-6"><div class="stat-card"><p class="stat-title">Total Tables</p><p class="stat-value">#stats["total"]#</p></div></div>
        <div class="col-md-3 col-sm-6 col-xs-6"><div class="stat-card"><p class="stat-title">Available</p><p class="stat-value">#stats["available"]#</p></div></div>
        <div class="col-md-3 col-sm-6 col-xs-6"><div class="stat-card"><p class="stat-title">Occupied</p><p class="stat-value">#stats["occupied"]#</p></div></div>
        <div class="col-md-3 col-sm-6 col-xs-6"><div class="stat-card"><p class="stat-title">Reserved</p><p class="stat-value">#stats["reserved"]#</p></div></div>
    </div>

    <div class="row">
        <cfif arrayLen(rows) eq 0>
            <div class="col-xs-12"><div class="alert alert-info">No tables found.</div></div>
        <cfelse>
            <cfloop array="#rows#" index="r">
                <div class="col-lg-3 col-md-4 col-sm-6 col-xs-12">
                    <div class="table-card #r.status#">
                        <div class="clearfix">
                            <h3 class="table-h pull-left">Table #esc(r.table_number)#</h3>
                            <span class="pull-right">
                                <cfif r.status eq "available"><span class="badge-soft b-available">Available</span></cfif>
                                <cfif r.status eq "occupied"><span class="badge-soft b-occupied">Occupied</span></cfif>
                                <cfif r.status eq "reserved"><span class="badge-soft b-reserved">Reserved</span></cfif>
                            </span>
                        </div>
                        <p class="table-seat">#r.seats# seats</p>
                    </div>
                </div>
            </cfloop>
        </cfif>
    </div>
</div>
</cfoutput>
</body>
</html>
