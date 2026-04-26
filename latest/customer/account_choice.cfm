<cfprocessingdirective pageencoding="UTF-8">
<cfinclude template="../../application.cfm">
<cfsetting showdebugoutput="false">

<!--- Redirect to QR page if no table context --->
<cfif NOT len(trim(SESSION.emenu_table_id))>
    <cflocation url="/latest/customer/qr_error.cfm" addtoken="false">
</cfif>

<!--- Already logged in — go straight to menu --->
<cfif SESSION.emenu_loggedin eq "Yes" AND len(SESSION.emenu_custno)>
    <cflocation url="/latest/customer/menu.cfm" addtoken="false">
</cfif>

<cfset tableDisplay = len(trim(SESSION.emenu_table_name)) ? SESSION.emenu_table_name : "Table " & SESSION.emenu_table_number>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
    <title>How would you like to order?</title>
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

        .container {
            width: 100%;
            max-width: 400px;
        }

        .header {
            text-align: center;
            margin-bottom: 32px;
        }

        .header h1 {
            color: #fff;
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .header p {
            color: rgba(255,255,255,0.85);
            font-size: 15px;
        }

        /* ---- Cards ---- */
        .card {
            background: #fff;
            border-radius: 24px;
            padding: 24px;
            margin-bottom: 16px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.12);
            cursor: pointer;
            text-decoration: none;
            display: block;
            transition: transform .15s, box-shadow .15s;
        }

        .card:hover, .card:active {
            transform: scale(1.02);
            box-shadow: 0 12px 40px rgba(0,0,0,0.18);
        }

        .card-row {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 16px;
        }

        .card-icon {
            width: 64px;
            height: 64px;
            border-radius: 18px;
            background: #F54900;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .card-icon svg {
            width: 32px;
            height: 32px;
            color: #fff;
        }

        .card-text { flex: 1; }

        .card-title {
            font-size: 18px;
            font-weight: 700;
            color: #111827;
            margin-bottom: 4px;
        }

        .card-desc {
            font-size: 14px;
            color: #6b7280;
        }

        .card-arrow {
            width: 24px;
            height: 24px;
            color: #F54900;
            flex-shrink: 0;
        }

        .points-strip {
            background: #fff7ed;
            border-radius: 12px;
            padding: 12px 16px;
            display: flex;
            align-items: center;
            justify-content: space-around;
        }

        .pts-item { text-align: center; }

        .pts-value {
            font-size: 15px;
            font-weight: 700;
            color: #F54900;
        }

        .pts-label {
            font-size: 12px;
            color: #6b7280;
            margin-top: 2px;
        }

        .divider {
            width: 1px;
            height: 32px;
            background: #fed7aa;
        }

        /* Guest card — semi-transparent */
        .card-guest {
            background: rgba(255,255,255,0.18);
            backdrop-filter: blur(8px);
            border: 2px solid rgba(255,255,255,0.6);
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }

        .card-guest .card-title { color: #fff; }
        .card-guest .card-desc  { color: rgba(255,255,255,0.8); }
        .card-guest .card-icon  { background: rgba(255,255,255,0.25); }
        .card-guest .card-arrow { color: #fff; }

        .footer-note {
            text-align: center;
            color: rgba(255,220,200,0.85);
            font-size: 13px;
            margin-top: 8px;
        }
    </style>
</head>
<body>
<div class="container">

    <div class="header">
        <h1>Welcome!</h1>
        <p>How would you like to order?</p>
    </div>

    <!--- Loyalty Account --->
    <a href="/latest/customer/login.cfm" class="card">
        <div class="card-row">
            <div class="card-icon">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                     stroke="currentColor" stroke-width="1.8">
                    <path stroke-linecap="round" stroke-linejoin="round"
                          d="M11.48 3.499a.562.562 0 011.04 0l2.125 5.111a.563.563 0 00.475.345l5.518.442c.499.04.701.663.321.988l-4.204 3.602a.563.563 0 00-.182.557l1.285 5.385a.562.562 0 01-.84.61l-4.725-2.885a.563.563 0 00-.586 0L6.982 20.54a.562.562 0 01-.84-.61l1.285-5.386a.562.562 0 00-.182-.557l-4.204-3.602a.562.562 0 01.321-.988l5.518-.442a.563.563 0 00.475-.345L11.48 3.5z"/>
                </svg>
            </div>
            <div class="card-text">
                <div class="card-title">Loyalty Account</div>
                <div class="card-desc">Earn points &amp; get rewards</div>
            </div>
            <svg class="card-arrow" xmlns="http://www.w3.org/2000/svg" fill="none"
                 viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7"/>
            </svg>
        </div>

        <div class="points-strip">
            <div class="pts-item">
                <div class="pts-value">Earn</div>
                <div class="pts-label">Points per order</div>
            </div>
            <div class="divider"></div>
            <div class="pts-item">
                <div class="pts-value">Redeem</div>
                <div class="pts-label">Points for discount</div>
            </div>
        </div>
    </a>

    <!--- Guest --->
    <a href="/latest/customer/guest_login.cfm" class="card card-guest">
        <div class="card-row">
            <div class="card-icon">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                     stroke="currentColor" stroke-width="1.8">
                    <path stroke-linecap="round" stroke-linejoin="round"
                          d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z"/>
                </svg>
            </div>
            <div class="card-text">
                <div class="card-title">Continue as Guest</div>
                <div class="card-desc">Order without an account</div>
            </div>
            <svg class="card-arrow" xmlns="http://www.w3.org/2000/svg" fill="none"
                 viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7"/>
            </svg>
        </div>
    </a>

    <p class="footer-note">You can always create an account later</p>

</div>
</body>
</html>
