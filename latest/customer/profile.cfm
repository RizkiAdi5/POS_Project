<!---
    /latest/customer/profile.cfm
    Loyalty profile page.
    Only accessible to logged-in loyalty customers (not guests).
--->
<cfinclude template="../../application.cfm">

<!--- Guest / not-logged-in guard --->
<cfif NOT len(trim(SESSION.emenu_table_id))>
    <cflocation url="/latest/customer/qr_error.cfm" addtoken="false">
</cfif>
<cfif SESSION.emenu_is_guest eq "Yes" OR SESSION.emenu_loggedin neq "Yes" OR NOT len(trim(SESSION.emenu_custno))>
    <cflocation url="/latest/customer/account_choice.cfm" addtoken="false">
</cfif>

<!--- ── Fetch customer data ── --->
<cfquery name="qCust" datasource="#dts#">
    SELECT CUSTNO, NAME, E_MAIL, PHONE,
           COALESCE(POINT_BF, 0)  AS pts,
           COALESCE(face_token,'') AS face_token,
           app_created_at
    FROM   arcust
    WHERE  CUSTNO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SESSION.emenu_custno#">
    LIMIT  1
</cfquery>
<cfif NOT qCust.recordCount>
    <cflocation url="/latest/customer/logout.cfm" addtoken="false">
</cfif>

<cfset custPts   = val(qCust.pts)>
<cfset hasFace   = len(trim(qCust.face_token)) gt 0>

<!--- Tier thresholds --->
<cfif custPts gte 2000>
    <cfset tierName  = "Platinum">
    <cfset tierNext  = "">
    <cfset tierMax   = 2000>
    <cfset tierMin   = 1000>
<cfelseif custPts gte 1000>
    <cfset tierName  = "Gold">
    <cfset tierNext  = "Platinum (2,000 pts)">
    <cfset tierMax   = 2000>
    <cfset tierMin   = 1000>
<cfelseif custPts gte 500>
    <cfset tierName  = "Silver">
    <cfset tierNext  = "Gold (1,000 pts)">
    <cfset tierMax   = 1000>
    <cfset tierMin   = 500>
<cfelse>
    <cfset tierName  = "Bronze">
    <cfset tierNext  = "Silver (500 pts)">
    <cfset tierMax   = 500>
    <cfset tierMin   = 0>
</cfif>

<cfset tierPct = (tierName neq "Platinum") ? int(((custPts - tierMin) / (tierMax - tierMin)) * 100) : 100>
<cfif tierPct gt 100><cfset tierPct = 100></cfif>
<cfif tierPct lt 0><cfset tierPct = 0></cfif>

<!--- Points stats from ledger --->
<cfset totalEarned   = 0>
<cfset totalRedeemed = 0>
<cftry>
    <cfquery name="qStats" datasource="#dts#">
        SELECT type, COALESCE(SUM(points),0) AS total
        FROM   points_transactions
        WHERE  custno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SESSION.emenu_custno#">
        GROUP  BY type
    </cfquery>
    <cfloop query="qStats">
        <cfif lCase(qStats.type) eq "earned">
            <cfset totalEarned = val(qStats.total)>
        <cfelseif lCase(qStats.type) eq "redeemed">
            <cfset totalRedeemed = val(qStats.total)>
        </cfif>
    </cfloop>
    <cfcatch type="any"></cfcatch>
</cftry>

<!--- Recent activity (last 5) --->
<cftry>
    <cfquery name="qTxn" datasource="#dts#">
        SELECT transaction_id, type, points, order_number, created_at
        FROM   points_transactions
        WHERE  custno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SESSION.emenu_custno#">
        ORDER  BY created_at DESC
        LIMIT  5
    </cfquery>
    <cfcatch type="any">
        <cfset qTxn = queryNew("transaction_id,type,points,order_number,created_at")>
    </cfcatch>
</cftry>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1">
    <title>My Profile</title>
    <style>
        *{box-sizing:border-box;margin:0;padding:0;}
        body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;background:#f3f4f6;min-height:100vh;}
        a{text-decoration:none;}

        /* ── Header ── */
        .prof-header{
            background:linear-gradient(135deg,#F54900 0%,#D04000 60%,#C04000 100%);
            padding:32px 20px 80px;
            border-radius:0 0 48px 48px;
        }
        .back-btn{display:flex;align-items:center;gap:6px;color:#fff;font-size:14px;margin-bottom:24px;background:none;border:none;cursor:pointer;}
        .back-btn svg{width:20px;height:20px;}
        .avatar-wrap{text-align:center;}
        .avatar-circle{
            width:80px;height:80px;background:#fff;border-radius:50%;
            display:inline-flex;align-items:center;justify-content:center;margin-bottom:12px;
        }
        .avatar-circle svg{width:40px;height:40px;color:#F54900;}
        .prof-name{color:#fff;font-size:22px;font-weight:700;margin-bottom:4px;}
        .prof-email{color:rgba(255,255,255,.8);font-size:13px;margin-bottom:24px;}
        .points-card{
            background:rgba(255,255,255,.2);backdrop-filter:blur(8px);
            border-radius:24px;padding:20px;
        }
        .points-row{display:flex;align-items:center;justify-content:center;gap:8px;margin-bottom:4px;}
        .points-row svg{width:32px;height:32px;color:rgba(255,220,150,1);}
        .points-num{font-size:36px;font-weight:800;color:#fff;}
        .points-label{color:rgba(255,255,255,.9);font-size:14px;text-align:center;}
        .points-equiv{margin-top:12px;padding-top:12px;border-top:1px solid rgba(255,255,255,.25);
            color:rgba(255,255,255,.85);font-size:13px;text-align:center;}

        /* ── Body cards ── */
        .body{padding:0 16px 32px;margin-top:-52px;}
        .card{background:#fff;border-radius:24px;padding:20px;margin-bottom:16px;
              box-shadow:0 1px 4px rgba(0,0,0,.06);border:1px solid #f0f0f0;}
        .card-title{font-size:15px;font-weight:700;color:#111;margin-bottom:16px;}

        /* Tier */
        .tier-bronze{background:linear-gradient(to right,#fef3c7,#fed7aa);border:2px solid #f59e0b;}
        .tier-silver{background:linear-gradient(to right,#f3f4f6,#e5e7eb);border:2px solid #9ca3af;}
        .tier-gold  {background:linear-gradient(to right,#fff4ed,#ffead9);border:2px solid #F54900;}
        .tier-platinum{background:linear-gradient(to right,#f5f3ff,#ede9fe);border:2px solid #7c3aed;}
        .tier-row{display:flex;align-items:center;gap:12px;margin-bottom:12px;}
        .tier-icon{width:56px;height:56px;border-radius:16px;display:flex;align-items:center;justify-content:center;flex-shrink:0;}
        .tier-icon svg{width:28px;height:28px;color:#fff;}
        .icon-bronze  {background:linear-gradient(135deg,#f59e0b,#ea580c);}
        .icon-silver  {background:linear-gradient(135deg,#9ca3af,#6b7280);}
        .icon-gold    {background:linear-gradient(135deg,#F54900,#D04000);}
        .icon-platinum{background:linear-gradient(135deg,#7c3aed,#4f46e5);}
        .tier-label{font-size:17px;font-weight:700;color:#111;}
        .tier-sub{font-size:12px;color:#555;margin-top:2px;}
        .progress-wrap{background:rgba(255,255,255,.5);border-radius:12px;padding:10px;}
        .progress-meta{display:flex;justify-content:space-between;font-size:12px;color:#666;margin-bottom:6px;}
        .progress-bar{height:8px;background:rgba(0,0,0,.1);border-radius:99px;overflow:hidden;}
        .progress-fill{height:100%;border-radius:99px;transition:width .4s;}
        .fill-bronze  {background:linear-gradient(to right,#f59e0b,#ea580c);}
        .fill-silver  {background:linear-gradient(to right,#9ca3af,#6b7280);}
        .fill-gold    {background:linear-gradient(to right,#F54900,#D04000);}
        .fill-platinum{background:linear-gradient(to right,#7c3aed,#4f46e5);}

        /* Stats grid */
        .stats-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:16px;}
        .stat-card{background:#fff;border-radius:16px;padding:16px;
                   box-shadow:0 1px 3px rgba(0,0,0,.05);border:1px solid #f0f0f0;}
        .stat-top{display:flex;align-items:center;gap:6px;margin-bottom:8px;}
        .stat-top svg{width:18px;height:18px;}
        .stat-top span{font-size:12px;color:#6b7280;}
        .stat-val{font-size:18px;font-weight:700;color:#111;}

        /* Account info rows */
        .info-row{display:flex;align-items:center;gap:14px;padding:14px 0;border-bottom:1px solid #f3f4f6;}
        .info-row:last-child{border-bottom:none;padding-bottom:0;}
        .info-icon{width:44px;height:44px;background:#f3f4f6;border-radius:12px;
                   display:flex;align-items:center;justify-content:center;flex-shrink:0;}
        .info-icon svg{width:20px;height:20px;color:#6b7280;}
        .info-label{font-size:12px;color:#9ca3af;margin-bottom:2px;}
        .info-val{font-size:14px;color:#111;font-weight:500;}

        /* Security */
        .face-box{border-radius:16px;padding:16px;margin-bottom:12px;}
        .face-box-registered{background:#f0fdf4;border:1px solid #bbf7d0;}
        .face-box-empty     {background:#eff6ff;border:1px solid #bfdbfe;}
        .face-top{display:flex;align-items:flex-start;gap:12px;margin-bottom:14px;}
        .face-top-icon{width:40px;height:40px;border-radius:12px;display:flex;align-items:center;justify-content:center;flex-shrink:0;}
        .face-icon-reg  {background:#dcfce7;}
        .face-icon-empty{background:#dbeafe;}
        .face-top-icon svg{width:20px;height:20px;}
        .face-title{font-size:13px;font-weight:600;margin-bottom:3px;}
        .face-title-reg  {color:#14532d;}
        .face-title-empty{color:#1e3a8a;}
        .face-sub{font-size:12px;}
        .face-sub-reg  {color:#15803d;}
        .face-sub-empty{color:#1d4ed8;}
        .face-btns{display:flex;gap:8px;}
        .btn-face-action{flex:1;padding:10px;border-radius:12px;border:1px solid;font-size:13px;font-weight:600;cursor:pointer;text-align:center;background:#fff;}
        .btn-face-remove{color:#dc2626;border-color:#fecaca;}
        .btn-face-rereg {color:#15803d;border-color:#bbf7d0;}
        .btn-face-reg   {width:100%;padding:12px;border-radius:12px;border:none;
                         background:linear-gradient(to right,#3b82f6,#7c3aed);
                         color:#fff;font-size:14px;font-weight:600;cursor:pointer;
                         display:flex;align-items:center;justify-content:center;gap:8px;}
        .btn-face-reg svg{width:18px;height:18px;}
        .security-note{background:#f9fafb;border-radius:12px;padding:12px;font-size:12px;color:#6b7280;line-height:1.6;}

        /* Transactions */
        .txn-row{display:flex;align-items:center;justify-content:space-between;
                 padding:12px 0;border-bottom:1px solid #f3f4f6;}
        .txn-row:last-child{border-bottom:none;}
        .txn-left{display:flex;align-items:center;gap:12px;}
        .txn-icon{width:36px;height:36px;border-radius:10px;display:flex;align-items:center;justify-content:center;}
        .txn-icon-earned  {background:#dcfce7;}
        .txn-icon-redeemed{background:#dbeafe;}
        .txn-icon svg{width:16px;height:16px;}
        .txn-type{font-size:13px;font-weight:600;color:#111;}
        .txn-meta{font-size:11px;color:#9ca3af;margin-top:2px;}
        .txn-pts-earned  {font-size:15px;font-weight:700;color:#16a34a;}
        .txn-pts-redeemed{font-size:15px;font-weight:700;color:#2563eb;}

        /* Rewards info */
        .rewards-box{background:#fff7ed;border:1px solid #fed7aa;border-radius:16px;padding:20px;margin-bottom:16px;}
        .rewards-title{font-size:15px;font-weight:700;color:#111;margin-bottom:12px;}
        .rewards-list{font-size:13px;color:#6b7280;line-height:2;}

        /* Logout */
        .logout-btn{
            width:100%;padding:16px;border-radius:14px;
            background:#fff;border:2px solid #fecaca;
            color:#dc2626;font-size:15px;font-weight:700;
            cursor:pointer;display:flex;align-items:center;justify-content:center;gap:8px;
        }
        .logout-btn svg{width:20px;height:20px;}
        .no-txn{text-align:center;color:#9ca3af;font-size:13px;padding:20px 0;}
    </style>
</head>
<body>
<cfoutput>
<!--- ── Header ── --->
<div class="prof-header">
    <a href="/latest/customer/menu.cfm" class="back-btn">
        <svg fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7"/>
        </svg>
        Back to Menu
    </a>
    <div class="avatar-wrap">
        <div class="avatar-circle">
            <svg fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
                <path stroke-linecap="round" stroke-linejoin="round"
                      d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z"/>
            </svg>
        </div>
        <div class="prof-name">#HTMLEditFormat(qCust.NAME)#</div>
        <div class="prof-email">#HTMLEditFormat(qCust.E_MAIL)#</div>

        <div class="points-card">
            <div class="points-row">
                <svg viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
                </svg>
                <span class="points-num">#numberFormat(custPts,'9,999')#</span>
            </div>
            <div class="points-label">Loyalty Points</div>
            <div class="points-equiv">= RM #numberFormat(custPts/100,'9.00')# in rewards</div>
        </div>
    </div>
</div>

<div class="body">

    <!--- ── Tier card ── --->
    <div class="card tier-#lCase(tierName)#">
        <div class="tier-row">
            <div class="tier-icon icon-#lCase(tierName)#">
                <svg fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round"
                          d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z"/>
                </svg>
            </div>
            <div>
                <div class="tier-label">#tierName# Member</div>
                <div class="tier-sub">
                    <cfif len(tierNext)>Next tier: #tierNext#<cfelse>Highest tier reached!</cfif>
                </div>
            </div>
        </div>
        <cfif len(tierNext)>
            <div class="progress-wrap">
                <div class="progress-meta">
                    <span>Progress to next tier</span>
                    <span>#numberFormat(custPts,'9,999')# / #numberFormat(tierMax,'9,999')#</span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill fill-#lCase(tierName)#" style="width:#tierPct#%;"></div>
                </div>
            </div>
        </cfif>
    </div>

    <!--- ── Stats ── --->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-top">
                <svg fill="none" viewBox="0 0 24 24" stroke="##22c55e" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/>
                </svg>
                <span>Total Earned</span>
            </div>
            <div class="stat-val">#numberFormat(totalEarned,'9,999')# pts</div>
        </div>
        <div class="stat-card">
            <div class="stat-top">
                <svg fill="none" viewBox="0 0 24 24" stroke="##3b82f6" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round"
                          d="M12 8v13m0-13V6a2 2 0 112 2h-2zm0 0V5.5A2.5 2.5 0 109.5 8H12zm-7 4h14M5 12a2 2 0 110-4h14a2 2 0 110 4M5 12v7a2 2 0 002 2h10a2 2 0 002-2v-7"/>
                </svg>
                <span>Redeemed</span>
            </div>
            <div class="stat-val">#numberFormat(totalRedeemed,'9,999')# pts</div>
        </div>
    </div>

    <!--- ── Account Info ── --->
    <div class="card">
        <div class="card-title">Account Information</div>
        <div class="info-row">
            <div class="info-icon">
                <svg fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
                    <path stroke-linecap="round" stroke-linejoin="round"
                          d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z"/>
                </svg>
            </div>
            <div>
                <div class="info-label">Full Name</div>
                <div class="info-val">#HTMLEditFormat(qCust.NAME)#</div>
            </div>
        </div>
        <div class="info-row">
            <div class="info-icon">
                <svg fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
                    <path stroke-linecap="round" stroke-linejoin="round"
                          d="M21.75 6.75v10.5a2.25 2.25 0 01-2.25 2.25h-15a2.25 2.25 0 01-2.25-2.25V6.75m19.5 0A2.25 2.25 0 0019.5 4.5h-15a2.25 2.25 0 00-2.25 2.25m19.5 0v.243a2.25 2.25 0 01-1.07 1.916l-7.5 4.615a2.25 2.25 0 01-2.36 0L3.32 8.91a2.25 2.25 0 01-1.07-1.916V6.75"/>
                </svg>
            </div>
            <div>
                <div class="info-label">Email Address</div>
                <div class="info-val">#HTMLEditFormat(qCust.E_MAIL)#</div>
            </div>
        </div>
        <cfif len(trim(qCust.PHONE))>
        <div class="info-row">
            <div class="info-icon">
                <svg fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
                    <path stroke-linecap="round" stroke-linejoin="round"
                          d="M2.25 6.75c0 8.284 6.716 15 15 15h2.25a2.25 2.25 0 002.25-2.25v-1.372c0-.516-.351-.966-.852-1.091l-4.423-1.106c-.44-.11-.902.055-1.173.417l-.97 1.293c-.282.376-.769.542-1.21.38a12.035 12.035 0 01-7.143-7.143c-.162-.441.004-.928.38-1.21l1.293-.97c.363-.271.527-.734.417-1.173L6.963 3.102a1.125 1.125 0 00-1.091-.852H4.5A2.25 2.25 0 002.25 4.5v2.25z"/>
                </svg>
            </div>
            <div>
                <div class="info-label">Phone</div>
                <div class="info-val">#HTMLEditFormat(qCust.PHONE)#</div>
            </div>
        </div>
        </cfif>
    </div>

    <!--- ── Security & Privacy ── --->
    <div class="card">
        <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:16px;">
            <span class="card-title" style="margin-bottom:0;">Security &amp; Privacy</span>
            <svg fill="none" viewBox="0 0 24 24" stroke="##3b82f6" stroke-width="2" width="20" height="20">
                <path stroke-linecap="round" stroke-linejoin="round"
                      d="M9 12.75L11.25 15 15 9.75m-3-7.036A11.959 11.959 0 013.598 6 11.99 11.99 0 003 9.749c0 5.592 3.824 10.29 9 11.623 5.176-1.332 9-6.03 9-11.622 0-1.31-.21-2.571-.598-3.751h-.152c-3.196 0-6.1-1.248-8.25-3.285z"/>
            </svg>
        </div>

        <cfif hasFace>
        <div class="face-box face-box-registered">
            <div class="face-top">
                <div class="face-top-icon face-icon-reg">
                    <svg fill="none" viewBox="0 0 24 24" stroke="##16a34a" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round"
                              d="M7.5 3.75H6A2.25 2.25 0 003.75 6v1.5M16.5 3.75H18A2.25 2.25 0 0120.25 6v1.5m0 9V18A2.25 2.25 0 0118 20.25h-1.5m-9 0H6A2.25 2.25 0 013.75 18v-1.5M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                    </svg>
                </div>
                <div>
                    <div class="face-title face-title-reg">Face Recognition Login</div>
                    <div class="face-sub face-sub-reg">Your biometric data is securely registered</div>
                </div>
            </div>
            <div class="face-btns">
                <form method="post" action="/latest/customer/face_remove.cfm" style="flex:1;">
                    <button type="submit" class="btn-face-action btn-face-remove" style="width:100%;">Remove Face Data</button>
                </form>
                <a href="/latest/customer/face_register.cfm" class="btn-face-action btn-face-rereg" style="display:flex;align-items:center;justify-content:center;">Re-register Face</a>
            </div>
        </div>
        <cfelse>
        <div class="face-box face-box-empty">
            <div class="face-top">
                <div class="face-top-icon face-icon-empty">
                    <svg fill="none" viewBox="0 0 24 24" stroke="##2563eb" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round"
                              d="M7.5 3.75H6A2.25 2.25 0 003.75 6v1.5M16.5 3.75H18A2.25 2.25 0 0120.25 6v1.5m0 9V18A2.25 2.25 0 0118 20.25h-1.5m-9 0H6A2.25 2.25 0 013.75 18v-1.5M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                    </svg>
                </div>
                <div>
                    <div class="face-title face-title-empty">Face Recognition Login</div>
                    <div class="face-sub face-sub-empty">Enable fast and secure login with your face</div>
                </div>
            </div>
            <a href="/latest/customer/face_register.cfm" class="btn-face-reg">
                <svg fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round"
                          d="M7.5 3.75H6A2.25 2.25 0 003.75 6v1.5M16.5 3.75H18A2.25 2.25 0 0120.25 6v1.5m0 9V18A2.25 2.25 0 0118 20.25h-1.5m-9 0H6A2.25 2.25 0 013.75 18v-1.5M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                </svg>
                Register Your Face
            </a>
        </div>
        </cfif>

        <div class="security-note">
            &##128274; Your biometric data is encrypted and stored securely. It is only used for authentication and never shared with third parties.
        </div>
    </div>

    <!--- ── Recent Activity ── --->
    <div class="card">
        <div class="card-title">Recent Activity</div>
        <cfif qTxn.recordCount>
            <cfloop query="qTxn">
                <cfset isEarned = (lCase(qTxn.type) eq "earned")>
                <div class="txn-row">
                    <div class="txn-left">
                        <div class="txn-icon #(isEarned ? 'txn-icon-earned' : 'txn-icon-redeemed')#">
                            <cfif isEarned>
                            <svg fill="none" viewBox="0 0 24 24" stroke="##16a34a" stroke-width="2">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/>
                            </svg>
                            <cfelse>
                            <svg fill="none" viewBox="0 0 24 24" stroke="##2563eb" stroke-width="2">
                                <path stroke-linecap="round" stroke-linejoin="round"
                                      d="M12 8v13m0-13V6a2 2 0 112 2h-2zm0 0V5.5A2.5 2.5 0 109.5 8H12zm-7 4h14M5 12a2 2 0 110-4h14a2 2 0 110 4M5 12v7a2 2 0 002 2h10a2 2 0 002-2v-7"/>
                            </svg>
                            </cfif>
                        </div>
                        <div>
                            <div class="txn-type">#(isEarned ? 'Points Earned' : 'Points Redeemed')#</div>
                            <div class="txn-meta">
                                #dateFormat(qTxn.created_at,'mmm d, yyyy')#
                                <cfif len(trim(qTxn.order_number))>&bull; #HTMLEditFormat(qTxn.order_number)#</cfif>
                            </div>
                        </div>
                    </div>
                    <div class="#(isEarned ? 'txn-pts-earned' : 'txn-pts-redeemed')#">
                        #(isEarned ? '+' : '-')##numberFormat(abs(val(qTxn.points)),'9,999')#
                    </div>
                </div>
            </cfloop>
        <cfelse>
            <div class="no-txn">No activity yet. Start ordering to earn points!</div>
        </cfif>
    </div>

    <!--- ── How Rewards Work ── --->
    <div class="rewards-box">
        <div class="rewards-title">How Rewards Work</div>
        <div class="rewards-list">
            &bull; Earn 10 points for every RM 1 spent<br>
            &bull; Redeem 100 points for RM 1 off<br>
            &bull; Points never expire<br>
            &bull; Earn bonus points on your birthday
        </div>
    </div>

    <!--- ── Logout ── --->
    <a href="/latest/customer/logout.cfm" class="logout-btn">
        <svg fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round"
                  d="M15.75 9V5.25A2.25 2.25 0 0013.5 3h-6a2.25 2.25 0 00-2.25 2.25v13.5A2.25 2.25 0 007.5 21h6a2.25 2.25 0 002.25-2.25V15M12 9l-3 3m0 0l3 3m-3-3h12.75"/>
        </svg>
        Logout
    </a>

</div>
</cfoutput>
</body>
</html>
