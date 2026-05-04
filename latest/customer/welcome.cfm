<cfprocessingdirective pageencoding="UTF-8">
<cfinclude template="../../application.cfm">
<cfsetting showdebugoutput="false">

<!--- Redirect to QR page if no table context --->
<cfif NOT len(trim(SESSION.emenu_table_id))>
    <cflocation url="/latest/customer/qr_error.cfm" addtoken="false">
</cfif>

<!--- Try to get restaurant name from gsetup --->
<cfset restaurantName = "Our Restaurant">
<cftry>
    <cfquery name="qSetup" datasource="#dts#">
        SELECT * FROM gsetup LIMIT 1
    </cfquery>
    <cfif qSetup.recordCount>
        <!--- Try common column names for company/restaurant name --->
        <cfif isDefined("qSetup.coname") AND len(trim(qSetup.coname))>
            <cfset restaurantName = trim(qSetup.coname)>
        <cfelseif isDefined("qSetup.companyname") AND len(trim(qSetup.companyname))>
            <cfset restaurantName = trim(qSetup.companyname)>
        <cfelseif isDefined("qSetup.company") AND len(trim(qSetup.company))>
            <cfset restaurantName = trim(qSetup.company)>
        </cfif>
    </cfif>
    <cfcatch type="any">
        <!--- fallback already set above --->
    </cfcatch>
</cftry>

<cfset tableDisplay = len(trim(SESSION.emenu_table_name)) ? SESSION.emenu_table_name : "Table " & SESSION.emenu_table_number>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
    <title>Welcome — <cfoutput>#HTMLEditFormat(restaurantName)#</cfoutput></title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: "Segoe UI", Arial, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #F54900 0%, #D04000 50%, #C04000 100%);
            padding: 24px;
        }

        .center {
            text-align: center;
            width: 100%;
            max-width: 360px;
        }

        .icon-wrap {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 96px;
            height: 96px;
            background: #fff;
            border-radius: 28px;
            margin-bottom: 32px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.18);
            animation: bounce 1.2s infinite;
        }

        .icon-wrap svg {
            width: 52px;
            height: 52px;
            color: #F54900;
        }

        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50%       { transform: translateY(-10px); }
        }

        h1 {
            color: #fff;
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .subtitle {
            color: rgba(255,255,255,0.85);
            font-size: 16px;
            margin-bottom: 36px;
        }

        .table-badge {
            display: inline-block;
            background: rgba(255,255,255,0.2);
            backdrop-filter: blur(8px);
            border-radius: 18px;
            padding: 20px 32px;
            margin-bottom: 40px;
        }

        .table-label {
            color: rgba(255,220,200,0.9);
            font-size: 14px;
            margin-bottom: 6px;
        }

        .table-number {
            color: #fff;
            font-size: 26px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .sparkle { font-size: 20px; }

        .loading {
            color: rgba(255,220,200,0.9);
            font-size: 15px;
            animation: pulse 1.5s infinite;
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50%       { opacity: 0.4; }
        }

        .progress-bar {
            width: 100%;
            height: 3px;
            background: rgba(255,255,255,0.2);
            border-radius: 2px;
            margin-top: 28px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            background: rgba(255,255,255,0.8);
            border-radius: 2px;
            animation: fill 2s linear forwards;
        }

        @keyframes fill {
            from { width: 0%; }
            to   { width: 100%; }
        }
    </style>
</head>
<body>
<div class="center">

    <div class="icon-wrap">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
             stroke="currentColor" stroke-width="1.8">
            <path stroke-linecap="round" stroke-linejoin="round"
                  d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-1.5 6h13L17 13M9 21a1 1 0 100-2 1 1 0 000 2zm6 0a1 1 0 100-2 1 1 0 000 2z"/>
        </svg>
    </div>

    <h1><cfoutput>#HTMLEditFormat(restaurantName)#</cfoutput></h1>
    <p class="subtitle">Digital Menu</p>

    <div class="table-badge">
        <p class="table-label">You're seated at</p>
        <div class="table-number">
            <cfoutput>#HTMLEditFormat(tableDisplay)#</cfoutput>
            <span class="sparkle">&#10024;</span>
        </div>
    </div>

    <p class="loading">Loading menu&hellip;</p>

    <div class="progress-bar">
        <div class="progress-fill"></div>
    </div>

</div>

<script>
    setTimeout(function() {
        window.location.href = '/latest/customer/account_choice.cfm';
    }, 2200);
</script>
</body>
</html>
