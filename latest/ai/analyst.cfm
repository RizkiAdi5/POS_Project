<cfprocessingdirective pageencoding="UTF-8">
<cfsetting enablecfoutputonly="false">
<cfsetting showdebugoutput="false">

<!--- ?embed=1 strips the page title for use inside the floating drawer iframe --->
<cfset aiEmbedMode = (isDefined("url.embed") AND toString(url.embed) EQ "1")>

<!--- Admin-only AI Business Analyst chat page --->
<cfif NOT isDefined("session.isLogIn") OR session.isLogIn NEQ "Yes">
    <cflocation url="/latest/login/login.cfm" addtoken="no">
</cfif>
<!--- Allowed roles for the AI analyst. Edit this list to add more groups. --->
<cfset AI_ALLOWED_ROLES = "super,admin">

<cfif NOT isDefined("husergrpid") OR NOT listFindNoCase(AI_ALLOWED_ROLES, husergrpid)>
    <!--- Inside cfoutput, # in CSS hex must be ##. Railo 3.x does not support ? : inside #...#. --->
    <cfset _aiShowRole = "(none)">
    <cfif isDefined("husergrpid")><cfset _aiShowRole = toString(husergrpid)></cfif>
    <cfset _aiShowUser = "(unknown)">
    <cfif isDefined("HUserID")><cfset _aiShowUser = toString(HUserID)></cfif>
    <cfoutput>
    <h2 style="font-family:Segoe UI, Arial, sans-serif; padding:24px;">Access denied. Admin role required.</h2>
    <p style="font-family:Segoe UI, Arial, sans-serif; padding:0 24px; color:##6b7280;">
        Your role: <strong>#_aiShowRole#</strong><br>
        Allowed roles: <strong>#AI_ALLOWED_ROLES#</strong><br>
        User: #_aiShowUser#
    </p>
    </cfoutput>
    <cfabort>
</cfif>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AI Business Analyst</title>
    <link rel="stylesheet" type="text/css" href="/latest/css/bootstrap/bootstrap.min.css" />
    <style>
    html, body { height:100%; }
    body {
        background:#F5F7FB;
        font-family:"Segoe UI", Verdana, Arial, sans-serif;
        color:#1F2937; margin:0;
        -webkit-font-smoothing:antialiased;
    }
    .wrap { max-width: 900px; margin: 22px auto; padding: 0 16px; }
    .wrap.embed { margin:0; padding:10px 12px; max-width:none; height:100%; box-sizing:border-box; display:flex; flex-direction:column; }
    .wrap.embed .chatbox { flex:1; display:flex; flex-direction:column; box-shadow:none; }
    .wrap.embed .messages { flex:1; height:auto; }

    .title { font-family:"Franklin Gothic Demi","Segoe UI",sans-serif; font-size:28px; font-weight:700; color:#454E59; margin:0 0 4px; }
    .subtitle { color:#6b7280; margin:0 0 14px; font-size:13px; }

    .chatbox {
        border:1px solid #E5E7EB; border-radius:14px; background:#FFFFFF;
        box-shadow:0 4px 18px rgba(69,78,89,0.06);
        overflow:hidden; display:flex; flex-direction:column;
    }

    /* ============ MESSAGE LIST ============ */
    .messages {
        padding:18px 16px 14px; height:480px; overflow-y:auto;
        background:
            radial-gradient(circle at 0% 0%, rgba(207,93,93,0.04), transparent 40%),
            radial-gradient(circle at 100% 100%, rgba(69,78,89,0.04), transparent 40%),
            #FBFAF8;
    }
    .messages::-webkit-scrollbar { width:8px; }
    .messages::-webkit-scrollbar-thumb { background:#D9D6D2; border-radius:8px; }
    .messages::-webkit-scrollbar-thumb:hover { background:#B5B0A9; }

    /* ============ ROW ============ */
    .row {
        display:flex; align-items:flex-end; gap:8px; margin-bottom:14px;
        animation:rowIn .26s cubic-bezier(.2,.8,.2,1) both;
    }
    .row.user { justify-content:flex-end; }
    @keyframes rowIn {
        from { opacity:0; transform:translateY(6px); }
        to   { opacity:1; transform:translateY(0); }
    }

    /* ============ AVATAR ============ */
    .avatar {
        width:32px; height:32px; flex-shrink:0; border-radius:50%;
        display:flex; align-items:center; justify-content:center;
        font-family:"Franklin Gothic Demi","Segoe UI",sans-serif;
        font-size:12px; font-weight:700; letter-spacing:.02em;
        color:#FFFFFF;
        box-shadow:0 2px 6px rgba(0,0,0,0.12);
    }
    .avatar.bot {
        background:linear-gradient(135deg, #CF5D5D 0%, #B84F4F 100%);
    }
    .avatar.bot svg { width:18px; height:18px; }

    /* ============ BUBBLES ============ */
    .bubble {
        max-width:78%; padding:11px 16px;
        font-size:14px; line-height:1.55;
        border-radius:20px;
        word-wrap:break-word; white-space:pre-wrap;
        position:relative;
    }
    .bubble strong { font-weight:700; }
    .bubble em { font-style:italic; color:inherit; }

    /* Bot bubble — soft white card on the left */
    .row.bot .bubble {
        background:#FFFFFF;
        border:1px solid #EEDFD5;
        color:#1F2937;
        border-top-left-radius:6px;
        box-shadow:0 2px 8px rgba(207,93,93,0.06);
    }
    .row.bot .meta {
        display:inline-block;
        margin-top:8px;
        font-size:11px; color:#9A8E85;
        font-family:"Franklin Gothic Book","Segoe UI",sans-serif;
        letter-spacing:.02em;
        border-top:1px dashed #EEDFD5; padding-top:6px;
    }

    /* User bubble — solid brick red pill on the right */
    .row.user .bubble {
        background:#CF5D5D;
        color:#FFFFFF;
        border-top-right-radius:6px;
        box-shadow:0 4px 12px rgba(207,93,93,0.28);
    }

    /* Error / system bot message */
    .row.bot.error .bubble {
        background:#FEF2F2; border-color:#FCA5A5; color:#991B1B;
    }

    /* ============ TYPING INDICATOR ============ */
    .typing {
        display:inline-flex; gap:4px; padding:13px 16px;
        background:#FFFFFF; border:1px solid #EEDFD5; border-radius:20px;
        border-top-left-radius:6px;
        box-shadow:0 2px 8px rgba(207,93,93,0.06);
    }
    .typing span {
        width:7px; height:7px; border-radius:50%;
        background:#CF5D5D; opacity:.4;
        animation:typingBounce 1.2s infinite ease-in-out both;
    }
    .typing span:nth-child(2){ animation-delay:.18s; }
    .typing span:nth-child(3){ animation-delay:.36s; }
    @keyframes typingBounce {
        0%, 80%, 100% { transform:translateY(0); opacity:.35; }
        40%           { transform:translateY(-5px); opacity:1; }
    }

    /* ============ QUICK STARTS + FOLLOW-UP CARDS (shared card style) ============ */
    .suggest {
        display:flex; flex-direction:column; gap:10px;
        padding:18px 14px 14px;
        margin-top:10px;
        background:#FFFFFF;
        border-top:1px solid #F1EAE3;
        overflow:hidden;
        transition:max-height .35s ease, opacity .25s ease, padding .25s ease, border-color .25s ease;
    }
    .suggest.hidden {
        max-height:0;
        padding-top:0; padding-bottom:0;
        opacity:0;
        border-top-color:transparent;
        pointer-events:none;
    }
    .suggest .sgHint {
        font-size:10.5px; color:#9A8E85;
        font-family:"Franklin Gothic Demi","Segoe UI",sans-serif;
        letter-spacing:.10em; text-transform:uppercase;
        margin-bottom:2px; padding-left:4px;
    }
    .followups {
        margin:22px 4px 18px 40px;
        display:flex; flex-direction:column; gap:10px;
        animation:rowIn .26s cubic-bezier(.2,.8,.2,1) both;
        overflow:hidden;
        transition:max-height .35s ease, opacity .25s ease, margin .25s ease;
    }
    .followups.hidden {
        max-height:0; margin-top:0; margin-bottom:0;
        opacity:0; pointer-events:none;
    }
    .followups .ftHint {
        font-size:10.5px; color:#9A8E85;
        font-family:"Franklin Gothic Demi","Segoe UI",sans-serif;
        letter-spacing:.10em; text-transform:uppercase;
        margin-bottom:2px; padding-left:4px;
    }
    .suggest button, .followups button {
        display:flex; align-items:center; gap:12px;
        width:100%; text-align:left;
        background:#FBF6F0;
        border:1px solid #EFE2D5;
        color:#3F362E;
        border-radius:14px;
        padding:12px 14px;
        font-size:13px; line-height:1.4;
        font-family:"Segoe UI",Verdana,Arial,sans-serif;
        cursor:pointer;
        transition:background .15s ease, border-color .15s ease, transform .12s ease, box-shadow .15s ease;
    }
    .suggest button:hover, .followups button:hover {
        background:#FFFFFF;
        border-color:#CF5D5D;
        box-shadow:0 4px 12px rgba(207,93,93,0.10);
        transform:translateY(-1px);
    }
    .suggest button:active, .followups button:active { transform:translateY(0); }
    .suggest button .ftIcon, .followups button .ftIcon {
        flex-shrink:0; width:30px; height:30px; border-radius:8px;
        background:#FFFFFF;
        border:1px solid #EFE2D5;
        display:flex; align-items:center; justify-content:center;
        color:#CF5D5D;
        transition:background .15s ease, border-color .15s ease;
    }
    .suggest button:hover .ftIcon, .followups button:hover .ftIcon {
        background:linear-gradient(135deg, #FDECE3 0%, #FAD9CB 100%);
        border-color:#F0BFA8;
    }
    .suggest button .ftIcon svg, .followups button .ftIcon svg { width:15px; height:15px; }
    .suggest button .ftText, .followups button .ftText { flex:1; min-width:0; }
    .suggest button .ftTitle {
        display:block; font-weight:600; font-size:13px; color:#3F362E;
    }
    .suggest button .ftSub {
        display:block; font-size:11px; line-height:1.35; color:#9A8E85;
        margin-top:3px; font-weight:normal;
    }

    /* ============ COMPOSER ============ */
    .composer {
        display:flex; gap:8px; align-items:flex-end;
        padding:12px 14px; border-top:1px solid #F1EAE3; background:#FFFFFF;
    }
    .composer textarea {
        flex:1; resize:none;
        border:1px solid #E2D5CB; border-radius:14px;
        padding:10px 14px;
        font:14px "Segoe UI",Verdana,Arial,sans-serif;
        color:#1F2937;
        min-height:44px; max-height:140px;
        background:#FBFAF8;
        transition:border-color .15s ease, box-shadow .15s ease, background .15s ease;
        outline:none;
    }
    .composer textarea:focus {
        border-color:#CF5D5D; background:#FFFFFF;
        box-shadow:0 0 0 3px rgba(207,93,93,0.12);
    }
    .composer button {
        background:linear-gradient(135deg, #CF5D5D 0%, #B84F4F 100%);
        color:#FFFFFF; border:0; border-radius:50%;
        width:44px; height:44px; flex-shrink:0;
        cursor:pointer;
        display:flex; align-items:center; justify-content:center;
        box-shadow:0 4px 10px rgba(207,93,93,0.32);
        transition:transform .12s ease, box-shadow .12s ease, opacity .15s ease;
    }
    .composer button:hover { transform:translateY(-1px); box-shadow:0 6px 14px rgba(207,93,93,0.42); }
    .composer button:active { transform:translateY(0); }
    .composer button[disabled] {
        background:#C9C2BB; box-shadow:none; cursor:not-allowed; opacity:.7;
        transform:none;
    }
    .composer button svg { width:18px; height:18px; }

    /* ============ EXCEL EXPORT BAR ============ */
    .export-bar {
        margin: 0 4px 14px 40px;
        animation: rowIn .26s cubic-bezier(.2,.8,.2,1) both;
    }
    .export-bar a {
        display: inline-flex;
        align-items: center;
        gap: 10px;
        padding: 10px 16px;
        background: linear-gradient(135deg, #FDECE3 0%, #FAD9CB 100%);
        border: 1px solid #E8B4A0;
        border-radius: 12px;
        color: #7F1D1D;
        font-size: 13px;
        font-weight: 600;
        text-decoration: none;
        box-shadow: 0 2px 8px rgba(207,93,93,0.12);
        transition: background .15s ease, border-color .15s ease, transform .12s ease;
    }
    .export-bar a:hover {
        background: #FFFFFF;
        border-color: #CF5D5D;
        transform: translateY(-1px);
    }
    .export-bar a svg { width: 18px; height: 18px; flex-shrink: 0; color: #CF5D5D; }
    .export-bar .exportHint {
        display: block;
        margin-top: 6px;
        font-size: 11px;
        color: #9A8E85;
        padding-left: 4px;
    }
    </style>
</head>
<body>
<cfoutput>
<div class="wrap<cfif aiEmbedMode> embed</cfif>">
    <cfif NOT aiEmbedMode>
        <h1 class="title">AI Business Analyst</h1>
        <p class="subtitle">Ask anything about e-menu orders, sales, top items, cancellations, tables. Branch: <strong>#dts#</strong></p>
    </cfif>

    <div class="chatbox">
        <div id="messages" class="messages" role="log" aria-live="polite" aria-label="Chat messages">
        </div>

        <div class="suggest" id="suggest" data-context="">
            <button type="button" data-q="Give me my daily business briefing — yesterday, today, and week vs last week.">Daily briefing</button>
            <button type="button" data-q="Give me a full weekly executive brief with forecast and action items.">Executive brief</button>
            <button type="button" data-q="Are there any unusual patterns or alerts I should know about right now?">Anomaly alerts</button>
            <button type="button" data-q="How is e-menu performing today by orders, revenue, and basket size?">Sales today</button>
            <button type="button" data-q="How does this week compare to last week in revenue, order count, and average basket?">Week vs last</button>
            <button type="button" data-q="What e-menu revenue and order count should we expect next week?">Next week forecast</button>
            <button type="button" data-q="Which 10 menu items are bringing the most revenue this month and how concentrated is the mix?">Top items</button>
            <button type="button" data-q="What is the current status of all tables — how many available, occupied, and reserved, and total seat capacity?">Tables</button>
        </div>

        <form id="composer" class="composer" autocomplete="off">
            <textarea id="q" placeholder="Ask anything about your e-menu sales, items, or tables..." maxlength="2000"></textarea>
            <button id="send" type="submit" aria-label="Send">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="22" y1="2" x2="11" y2="13"></line><polygon points="22 2 15 22 11 13 2 9 22 2"></polygon></svg>
            </button>
        </form>
    </div>
</div>
</cfoutput>

<script>
(function () {
    var elMsgs    = document.getElementById('messages');
    var elForm    = document.getElementById('composer');
    var elInput   = document.getElementById('q');
    var elSend    = document.getElementById('send');
    var elSuggest = document.getElementById('suggest');

    function getUrlParam(name) {
        var m = new RegExp('[?&]' + name + '=([^&]*)').exec(window.location.search);
        return m ? decodeURIComponent(m[1].replace(/\+/g, ' ')) : '';
    }

    var pageContext = getUrlParam('context');

    var CONTEXT_STARTS = {
        overview: [
            { title: 'Daily briefing', q: 'Give me my daily business briefing — yesterday, today, and week vs last week.' },
            { title: 'Executive brief', q: 'Give me a full weekly executive brief with forecast and action items.' },
            { title: 'Anomaly alerts', q: 'Are there any unusual patterns or alerts I should know about right now?' },
            { title: 'Explain sales trend', q: 'Explain the Last 5 Month Sales chart — what trend do you see and what should I watch?' },
            { title: 'Next week forecast', q: 'What e-menu revenue and order count should we expect next week?' },
            { title: 'Peak hours next week', q: 'What peak ordering hours should we expect next week and when should we add staff?' }
        ],
        menu: [
            { title: 'Top items', q: 'Which 10 menu items are bringing the most revenue this month and how concentrated is the mix?' },
            { title: 'Slow movers', q: 'Which menu items are bringing the least revenue this month and might be candidates to remove or promote?' },
            { title: 'Menu demand forecast', q: 'Which menu items are likely to be top sellers next week?' },
            { title: 'Cancellation risk', q: 'Which items have the highest cancellation risk next week?' }
        ],
        tables: [
            { title: 'Tables now', q: 'What is the current status of all tables — how many available, occupied, and reserved, and total seat capacity?' },
            { title: 'Peak hours', q: 'Which hours of the day drive the most orders in the last 14 days?' },
            { title: 'Peak hours next week', q: 'What peak ordering hours should we expect next week and when should we add staff?' },
            { title: 'Sales today', q: 'How is e-menu performing today by orders, revenue, and basket size?' }
        ]
    };

    function applyContextStarts() {
        var items = CONTEXT_STARTS[pageContext];
        if (!items || !elSuggest) return;
        elSuggest.setAttribute('data-context', pageContext);
        elSuggest.innerHTML = '';
        items.forEach(function (it) {
            var b = document.createElement('button');
            b.type = 'button';
            b.setAttribute('data-q', it.q);
            b.textContent = it.title;
            elSuggest.appendChild(b);
        });
        elSuggest.removeAttribute('data-enhanced');
        initQuickStarts();
    }

    function escapeHtml(s) {
        return String(s).replace(/[&<>"']/g, function (c) {
            return ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c];
        });
    }

    function renderMarkdown(md) {
        // tiny, deliberately minimal: escape, then convert simple **bold**, *italic*, lists, line breaks.
        var out = escapeHtml(md);
        out = out.replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>');
        out = out.replace(/(^|[^*])\*(?!\s)([^*\n]+?)\*(?!\*)/g, '$1<em>$2</em>');
        out = out.replace(/^|\n/g, function (m) { return m; });
        // bullet lists
        out = out.replace(/(^|\n)[\-\*\u2022]\s+(.+)/g, '$1&bull; $2');
        out = out.replace(/\n/g, '<br>');
        return out;
    }

    var BOT_AVATAR_HTML =
        '<div class="avatar bot" aria-hidden="true">' +
            '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">' +
                '<path d="M21 15a2 2 0 0 1-2 2H8l-4 4V5a2 2 0 0 1 2-2h13a2 2 0 0 1 2 2z"></path>' +
                '<path d="M9 11h.01"></path><path d="M13 11h.01"></path><path d="M17 11h.01"></path>' +
            '</svg>' +
        '</div>';

    function addMsg(text, who, meta, isError) {
        var row = document.createElement('div');
        row.className = 'row ' + who + (isError ? ' error' : '');

        if (who === 'bot') {
            row.innerHTML = BOT_AVATAR_HTML;
            var bubble = document.createElement('div');
            bubble.className = 'bubble';
            bubble.innerHTML = renderMarkdown(text);
            if (meta) {
                var m = document.createElement('span');
                m.className = 'meta';
                m.textContent = meta;
                bubble.appendChild(m);
            }
            row.appendChild(bubble);
        } else {
            var bubbleU = document.createElement('div');
            bubbleU.className = 'bubble';
            bubbleU.textContent = text;
            row.appendChild(bubbleU);
        }
        elMsgs.appendChild(row);
        elMsgs.scrollTop = elMsgs.scrollHeight;
    }

    /* ----- Follow-up icons (Feather-style line SVGs, picked by label keywords) ----- */
    var FT_SVG = {
        compare:    '<polyline points="3 17 9 11 13 15 21 7"></polyline><polyline points="14 7 21 7 21 14"></polyline>',
        trendUp:    '<polyline points="3 17 9 11 13 15 21 7"></polyline><polyline points="14 7 21 7 21 14"></polyline>',
        trendDown:  '<polyline points="3 7 9 13 13 9 21 17"></polyline><polyline points="14 17 21 17 21 10"></polyline>',
        star:       '<polygon points="12 2 15.1 8.6 22 9.6 17 14.5 18.2 21.5 12 18.2 5.8 21.5 7 14.5 2 9.6 8.9 8.6 12 2"></polygon>',
        clock:      '<circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline>',
        calendar:   '<rect x="3" y="4" width="18" height="18" rx="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line>',
        grid:       '<rect x="3" y="3" width="7" height="7" rx="1"></rect><rect x="14" y="3" width="7" height="7" rx="1"></rect><rect x="3" y="14" width="7" height="7" rx="1"></rect><rect x="14" y="14" width="7" height="7" rx="1"></rect>',
        ban:        '<circle cx="12" cy="12" r="10"></circle><line x1="5" y1="5" x2="19" y2="19"></line>',
        sun:        '<circle cx="12" cy="12" r="4"></circle><line x1="12" y1="2" x2="12" y2="4"></line><line x1="12" y1="20" x2="12" y2="22"></line><line x1="2" y1="12" x2="4" y2="12"></line><line x1="20" y1="12" x2="22" y2="12"></line><line x1="5" y1="5" x2="6.5" y2="6.5"></line><line x1="17.5" y1="17.5" x2="19" y2="19"></line><line x1="5" y1="19" x2="6.5" y2="17.5"></line><line x1="17.5" y1="6.5" x2="19" y2="5"></line>',
        check:      '<path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline>',
        layout:     '<rect x="3" y="3" width="18" height="18" rx="2"></rect><line x1="3" y1="9" x2="21" y2="9"></line><line x1="9" y1="21" x2="9" y2="9"></line>',
        bag:        '<path d="M6 2 L3 6 V20 a2 2 0 0 0 2 2 h14 a2 2 0 0 0 2 -2 V6 L18 2 Z"></path><line x1="3" y1="6" x2="21" y2="6"></line><path d="M16 10a4 4 0 0 1 -8 0"></path>',
        arrow:      '<line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline>'
    };
    function pickFollowupIcon(label) {
        var s = String(label || '').toLowerCase();
        if (/cancel|drop|stop/.test(s))           return FT_SVG.ban;
        if (/slow|movers|low/.test(s))            return FT_SVG.trendDown;
        if (/compare|vs|versus/.test(s))          return FT_SVG.compare;
        if (/peak|hour|time/.test(s))             return FT_SVG.clock;
        if (/weekend|weekday|day of/.test(s))     return FT_SVG.calendar;
        if (/month|to date|mtd/.test(s))          return FT_SVG.calendar;
        if (/table/.test(s))                      return FT_SVG.grid;
        if (/today|now/.test(s))                  return FT_SVG.sun;
        if (/status|pending|completed/.test(s))   return FT_SVG.check;
        if (/overview|snap|summary/.test(s))      return FT_SVG.layout;
        if (/basket|average|avg/.test(s))         return FT_SVG.bag;
        if (/top|item|best|menu|popular/.test(s)) return FT_SVG.star;
        if (/trend|sales|revenue|growth/.test(s)) return FT_SVG.trendUp;
        return FT_SVG.arrow;
    }

    /* Turn bottom pill buttons into the same card style as follow-ups */
    (function initQuickStarts() {
        var wrap = document.getElementById('suggest');
        if (!wrap || wrap.getAttribute('data-enhanced') === '1') return;
        wrap.setAttribute('data-enhanced', '1');
        var hint = document.createElement('div');
        hint.className = 'sgHint';
        hint.textContent = 'Quick starts';
        wrap.insertBefore(hint, wrap.firstChild);
        [].slice.call(wrap.querySelectorAll('button[data-q]')).forEach(function (b) {
            var q = b.getAttribute('data-q') || '';
            var title = (b.textContent || '').trim();
            var iconPaths = pickFollowupIcon(title + ' ' + q);
            b.innerHTML =
                '<span class="ftIcon" aria-hidden="true">' +
                '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">' + iconPaths + '</svg>' +
                '</span>' +
                '<span class="ftText">' +
                '<span class="ftTitle">' + escapeHtml(title) + '</span>' +
                '<span class="ftSub">' + escapeHtml(q) + '</span>' +
                '</span>';
        });
    })();

    /* Track every question the user has already asked so we don't suggest it again. */
    var askedQuestions = new Set();
    function normQ(q) { return String(q || '').trim().toLowerCase().replace(/\s+/g, ' '); }

    /* Remember the last successful analyst skill so export follow-ups can reuse it. */
    var lastChatContext = { skill: null, params: {} };

    /* Drop any quick-start cards that match an already-asked question. */
    function filterQuickStarts() {
        if (!elSuggest) return;
        [].slice.call(elSuggest.querySelectorAll('button[data-q]')).forEach(function (b) {
            if (askedQuestions.has(normQ(b.getAttribute('data-q')))) {
                b.remove();
            }
        });
        var remaining = elSuggest.querySelectorAll('button[data-q]').length;
        if (remaining === 0) hideQuickStarts();
    }

    /* Smoothly collapse a previous followups block (used when a new question is sent). */
    function collapseFollowups(box) {
        if (!box || box.classList.contains('hidden')) return;
        var h = box.scrollHeight;
        box.style.maxHeight = h + 'px';
        requestAnimationFrame(function () {
            box.classList.add('hidden');
            box.style.maxHeight = '0px';
        });
    }
    function collapseAllFollowups() {
        [].slice.call(elMsgs.querySelectorAll('.followups:not(.hidden)')).forEach(collapseFollowups);
    }

    function addExportDownload(exportInfo) {
        if (!exportInfo || !exportInfo.available || !exportInfo.token) return;
        var bar = document.createElement('div');
        bar.className = 'export-bar';
        var href = '/latest/ai/aiexport.cfm?token=' + encodeURIComponent(exportInfo.token);
        var label = exportInfo.title || 'Download Excel report';
        var fname = exportInfo.filename || 'report.xlsx';
        bar.innerHTML =
            '<a href="' + href + '" download="' + escapeHtml(fname) + '">' +
                '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">' +
                    '<path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>' +
                    '<polyline points="7 10 12 15 17 10"></polyline>' +
                    '<line x1="12" y1="15" x2="12" y2="3"></line>' +
                '</svg>' +
                '<span>Download Excel — ' + escapeHtml(label) + '</span>' +
            '</a>' +
            '<span class="exportHint">Includes summary sheets and detailed rows · link expires in ~20 min</span>';
        elMsgs.appendChild(bar);
        elMsgs.scrollTop = elMsgs.scrollHeight;
    }

    function addFollowups(items) {
        if (!Array.isArray(items) || items.length === 0) return;
        var fresh = items.filter(function (it) {
            return it && it.question && !askedQuestions.has(normQ(it.question));
        }).slice(0, 4);
        if (fresh.length === 0) return;

        var box = document.createElement('div');
        box.className = 'followups';
        var hint = document.createElement('div');
        hint.className = 'ftHint';
        hint.textContent = 'You might also want to know';
        box.appendChild(hint);
        fresh.forEach(function (it) {
            var b = document.createElement('button');
            b.type = 'button';
            b.setAttribute('data-q', it.question);
            var displayText = it.question || it.label || '';
            var iconPaths = pickFollowupIcon(it.label || it.question);
            b.innerHTML =
                '<span class="ftIcon" aria-hidden="true">' +
                    '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">' + iconPaths + '</svg>' +
                '</span>' +
                '<span class="ftText"></span>';
            b.querySelector('.ftText').textContent = displayText;
            box.appendChild(b);
        });
        elMsgs.appendChild(box);
        elMsgs.scrollTop = elMsgs.scrollHeight;
    }

    function addTyping() {
        var row = document.createElement('div');
        row.className = 'row bot typing-row';
        row.innerHTML = BOT_AVATAR_HTML +
            '<div class="typing" aria-label="Thinking"><span></span><span></span><span></span></div>';
        elMsgs.appendChild(row);
        elMsgs.scrollTop = elMsgs.scrollHeight;
        return row;
    }

    function setSending(on) {
        elSend.disabled = on;
        elInput.disabled = on;
    }

    function hideQuickStarts() {
        if (!elSuggest || elSuggest.classList.contains('hidden')) return;
        var h = elSuggest.scrollHeight;
        elSuggest.style.maxHeight = h + 'px';
        requestAnimationFrame(function () {
            elSuggest.classList.add('hidden');
            elSuggest.style.maxHeight = '0px';
        });
    }

    async function ask(question, opts) {
        opts = opts || {};
        askedQuestions.add(normQ(question));
        filterQuickStarts();
        collapseAllFollowups();
        hideQuickStarts();
        addMsg(question, 'user');
        elInput.value = '';
        setSending(true);
        var typing = addTyping();
        var body = { question: question };
        if (lastChatContext.skill) {
            body.context = {
                last_skill: lastChatContext.skill,
                last_params: lastChatContext.params || {}
            };
        }
        if (opts.force_skill) {
            body.force_skill = opts.force_skill;
            body.force_params = opts.force_params || {};
        }
        try {
            var resp = await fetch('/latest/ai/aiproxy.cfm', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(body)
            });
            var data = null;
            try { data = await resp.json(); } catch (e) { data = null; }
            typing.remove();
            if (!resp.ok || !data || !data.ok) {
                var err = (data && (data.error || data.detail)) || ('HTTP ' + resp.status);
                addMsg('Sorry, the analyst could not answer: ' + err, 'bot', null, true);
                return;
            }
            var meta = data.skill_used
                + (data.cached ? '  ·  cached' : '')
                + '  ·  ' + data.latency_ms + ' ms';
            addMsg(data.answer_markdown || '(no answer)', 'bot', meta);
            if (data.skill_used && data.skill_used !== 'none') {
                lastChatContext.skill = data.skill_used;
                lastChatContext.params = data.params || {};
            }
            if (data.export) addExportDownload(data.export);
            addFollowups(data.followups);
        } catch (e) {
            typing.remove();
            addMsg('Network error: ' + e.message, 'bot', null, true);
        } finally {
            setSending(false);
            elInput.focus();
        }
    }

    elForm.addEventListener('submit', function (e) {
        e.preventDefault();
        var q = elInput.value.trim();
        if (!q) return;
        ask(q);
    });

    elInput.addEventListener('keydown', function (e) {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            elForm.requestSubmit();
        }
    });

    elSuggest.addEventListener('click', function (e) {
        var b = e.target.closest('button[data-q]');
        if (!b) return;
        ask(b.getAttribute('data-q'));
    });

    /* delegated handler so dynamically inserted .followups buttons work too */
    elMsgs.addEventListener('click', function (e) {
        var b = e.target.closest('.followups button[data-q]');
        if (!b) return;
        ask(b.getAttribute('data-q'));
    });

    applyContextStarts();
    initQuickStarts();

    window.addEventListener('message', function (e) {
        var d = e.data;
        if (!d || d.type !== 'ai-ask' || !d.question) return;
        ask(d.question, {
            force_skill: d.force_skill || '',
            force_params: d.force_params || {}
        });
    });

    var bootQ = getUrlParam('q');
    if (bootQ && getUrlParam('autask') === '1') {
        setTimeout(function () { ask(bootQ); }, 400);
    } else if (bootQ) {
        elInput.value = bootQ;
    }
})();
</script>
</body>
</html>
