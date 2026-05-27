<cfprocessingdirective pageencoding="UTF-8">
<cfinclude template="../../application.cfm">
<cfsetting enablecfoutputonly="false">
<cfsetting showdebugoutput="false">

<cfset aiEmbedMode = (isDefined("url.embed") AND toString(url.embed) EQ "1")>

<cfif NOT len(trim(SESSION.emenu_table_id))>
    <cflocation url="/latest/customer/qr_error.cfm" addtoken="false">
</cfif>
<cfif SESSION.emenu_loggedin neq "Yes" AND SESSION.emenu_is_guest neq "Yes">
    <cflocation url="/latest/customer/account_choice.cfm" addtoken="false">
</cfif>

<cfset _tableLabel = len(trim(SESSION.emenu_table_name)) ? trim(SESSION.emenu_table_name) : (
    len(trim(SESSION.emenu_table_number)) ? "Table " & trim(SESSION.emenu_table_number) : "Your table"
)>
<cfset _guestLabel = len(trim(SESSION.emenu_name)) ? trim(SESSION.emenu_name) : "Guest">
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
    <title>Menu Assistant</title>
    <style>
    html, body { height:100%; margin:0; }
    body {
        background:#f9fafb;
        font-family:"Segoe UI", Arial, sans-serif;
        color:#111827;
        -webkit-font-smoothing:antialiased;
    }
    .wrap { max-width:900px; margin:20px auto; padding:0 14px; }
    .wrap.embed { margin:0; padding:8px 10px; max-width:none; height:100%; box-sizing:border-box; display:flex; flex-direction:column; }
    .wrap.embed .chatbox { flex:1; display:flex; flex-direction:column; box-shadow:none; border-radius:0; border:none; }
    .wrap.embed .messages { flex:1; height:auto; min-height:120px; }

    .title { font-size:24px; font-weight:700; color:#F54900; margin:0 0 4px; }
    .subtitle { color:#6b7280; font-size:13px; margin:0 0 12px; }

    .chatbox {
        border:1px solid #e5e7eb; border-radius:16px; background:#fff;
        box-shadow:0 4px 16px rgba(0,0,0,0.06);
        overflow:hidden; display:flex; flex-direction:column;
    }

    .messages {
        padding:16px 14px 12px; height:460px; overflow-y:auto;
        background:linear-gradient(180deg, #fff7f3 0%, #f9fafb 100%);
    }
    .messages::-webkit-scrollbar { width:6px; }
    .messages::-webkit-scrollbar-thumb { background:#fdba74; border-radius:6px; }

    .row { display:flex; align-items:flex-end; gap:8px; margin-bottom:12px; animation:fadeUp .25s ease both; }
    .row.user { justify-content:flex-end; }
    @keyframes fadeUp { from{ opacity:0; transform:translateY(5px);} to{ opacity:1; transform:none;} }

    .avatar {
        width:30px; height:30px; flex-shrink:0; border-radius:50%;
        display:flex; align-items:center; justify-content:center;
        background:linear-gradient(135deg, #F54900, #D04000);
        color:#fff; box-shadow:0 2px 6px rgba(245,73,0,0.25);
    }
    .avatar svg { width:16px; height:16px; }

    .bubble {
        max-width:82%; padding:10px 14px; font-size:14px; line-height:1.5;
        border-radius:18px; word-wrap:break-word; white-space:pre-wrap;
    }
    .row.bot .bubble {
        background:#fff; border:1px solid #fed7aa; color:#1f2937;
        border-top-left-radius:6px;
        box-shadow:0 2px 6px rgba(245,73,0,0.06);
    }
    .row.user .bubble {
        background:#F54900; color:#fff;
        border-top-right-radius:6px;
        box-shadow:0 3px 10px rgba(245,73,0,0.28);
    }
    .row.bot.error .bubble { background:#fef2f2; border-color:#fca5a5; color:#991b1b; }
    .row.bot .meta {
        display:block; margin-top:6px; font-size:10px; color:#9ca3af;
        border-top:1px dashed #fed7aa; padding-top:5px;
    }

    .typing {
        display:inline-flex; gap:4px; padding:12px 14px;
        background:#fff; border:1px solid #fed7aa; border-radius:18px;
        border-top-left-radius:6px;
    }
    .typing span {
        width:6px; height:6px; border-radius:50%; background:#F54900; opacity:.35;
        animation:dotBounce 1.2s infinite ease-in-out both;
    }
    .typing span:nth-child(2){ animation-delay:.15s; }
    .typing span:nth-child(3){ animation-delay:.3s; }
    @keyframes dotBounce {
        0%,80%,100%{ transform:translateY(0); opacity:.35; }
        40%{ transform:translateY(-4px); opacity:1; }
    }

    .suggest, .followups {
        display:flex; flex-direction:column; gap:8px;
        padding:12px; border-top:1px solid #f3f4f6; background:#fff;
        transition:max-height .3s ease, opacity .2s ease, padding .2s ease;
    }
    .suggest.hidden, .followups.hidden {
        max-height:0; padding-top:0; padding-bottom:0; opacity:0;
        overflow:hidden; pointer-events:none; border-top-color:transparent;
    }
    .followups { margin:0 8px 10px 38px; padding:0; border:none; background:transparent; }
    .sgHint, .ftHint {
        font-size:10px; color:#9ca3af; text-transform:uppercase;
        letter-spacing:.08em; font-weight:600; padding-left:2px;
    }
    .suggest button, .followups button {
        display:block; width:100%; text-align:left;
        background:#fff7f3; border:1px solid #fed7aa; color:#374151;
        border-radius:12px; padding:10px 12px; font-size:13px;
        cursor:pointer; transition:background .15s, border-color .15s;
    }
    .suggest button:hover, .followups button:hover {
        background:#fff; border-color:#F54900;
    }

    .composer {
        display:flex; gap:8px; align-items:flex-end;
        padding:10px 12px; border-top:1px solid #f3f4f6; background:#fff;
    }
    .composer textarea {
        flex:1; resize:none; border:1px solid #e5e7eb; border-radius:14px;
        padding:10px 12px; font:14px "Segoe UI",Arial,sans-serif;
        min-height:42px; max-height:120px; outline:none; background:#f9fafb;
    }
    .composer textarea:focus {
        border-color:#F54900; background:#fff;
        box-shadow:0 0 0 3px rgba(245,73,0,0.12);
    }
    .composer button {
        width:42px; height:42px; border:0; border-radius:50%; flex-shrink:0;
        background:linear-gradient(135deg, #F54900, #D04000);
        color:#fff; cursor:pointer;
        display:flex; align-items:center; justify-content:center;
        box-shadow:0 3px 10px rgba(245,73,0,0.3);
    }
    .composer button[disabled] { background:#d1d5db; box-shadow:none; cursor:not-allowed; }
    .composer button svg { width:17px; height:17px; }
    </style>
</head>
<body>
<cfoutput>
<div class="wrap<cfif aiEmbedMode> embed</cfif>">
    <cfif NOT aiEmbedMode>
        <h1 class="title">Menu Assistant</h1>
        <p class="subtitle">Hi #HTMLEditFormat(_guestLabel)# &mdash; ask about the menu, your order, or payment. #HTMLEditFormat(_tableLabel)#</p>
    </cfif>

    <div class="chatbox">
        <div id="messages" class="messages" role="log" aria-live="polite"></div>

        <div class="suggest" id="suggest">
            <div class="sgHint">Try asking</div>
            <button type="button" data-q="What affordable dishes are on the menu?">Budget dishes</button>
            <button type="button" data-q="What are the restaurant opening hours?">Opening hours</button>
            <button type="button" data-q="I am allergic to nuts — what can I eat?">Nut allergy</button>
            <button type="button" data-q="What halal dishes do you recommend?">Halal recommendations</button>
            <button type="button" data-q="Where is my order right now?">My order status</button>
            <button type="button" data-q="How do I pay my bill?">How to pay</button>
        </div>

        <form id="composer" class="composer" autocomplete="off">
            <textarea id="q" placeholder="Ask about menu, order, payment..." maxlength="2000" rows="1"></textarea>
            <button id="send" type="submit" aria-label="Send">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"><line x1="22" y1="2" x2="11" y2="13"/><polygon points="22 2 15 22 11 13 2 9 22 2"/></svg>
            </button>
        </form>
    </div>
</div>
</cfoutput>

<script>
(function(){
    var elMsgs = document.getElementById('messages');
    var elForm = document.getElementById('composer');
    var elInput = document.getElementById('q');
    var elSend = document.getElementById('send');
    var elSuggest = document.getElementById('suggest');
    var asked = new Set();

    var BOT_AVATAR = '<div class="avatar" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2a3 3 0 0 0-3 3v1H6a2 2 0 0 0-2 2v11a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-3V5a3 3 0 0 0-3-3z"/></svg></div>';

    function esc(s){ return String(s).replace(/[&<>"']/g,function(c){return({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'})[c];}); }
    function md(t){
        var o = esc(t);
        o = o.replace(/\*\*(.+?)\*\*/g,'<strong>$1</strong>');
        o = o.replace(/(^|\n)[\-\*]\s+(.+)/g,'$1&bull; $2');
        return o.replace(/\n/g,'<br>');
    }
    function norm(q){ return String(q||'').trim().toLowerCase().replace(/\s+/g,' '); }

    function addMsg(text, who, meta, isErr){
        var row = document.createElement('div');
        row.className = 'row ' + who + (isErr ? ' error' : '');
        if (who === 'bot') {
            row.innerHTML = BOT_AVATAR;
            var b = document.createElement('div');
            b.className = 'bubble';
            b.innerHTML = md(text);
            if (meta){ var m = document.createElement('span'); m.className='meta'; m.textContent=meta; b.appendChild(m); }
            row.appendChild(b);
        } else {
            var bu = document.createElement('div');
            bu.className = 'bubble';
            bu.textContent = text;
            row.appendChild(bu);
        }
        elMsgs.appendChild(row);
        elMsgs.scrollTop = elMsgs.scrollHeight;
    }

    function addTyping(){
        var row = document.createElement('div');
        row.className = 'row bot typing-row';
        row.innerHTML = BOT_AVATAR + '<div class="typing"><span></span><span></span><span></span></div>';
        elMsgs.appendChild(row);
        elMsgs.scrollTop = elMsgs.scrollHeight;
        return row;
    }

    function hideSuggest(){
        if (elSuggest && !elSuggest.classList.contains('hidden')) elSuggest.classList.add('hidden');
    }

    function addFollowups(items){
        if (!items || !items.length) return;
        var fresh = items.filter(function(it){ return it && it.question && !asked.has(norm(it.question)); }).slice(0,4);
        if (!fresh.length) return;
        var box = document.createElement('div');
        box.className = 'followups';
        var hint = document.createElement('div');
        hint.className = 'ftHint';
        hint.textContent = 'You might also ask';
        box.appendChild(hint);
        fresh.forEach(function(it){
            var btn = document.createElement('button');
            btn.type = 'button';
            btn.setAttribute('data-q', it.question);
            btn.textContent = it.label || it.question;
            box.appendChild(btn);
        });
        elMsgs.appendChild(box);
        elMsgs.scrollTop = elMsgs.scrollHeight;
    }

    function setBusy(on){ elSend.disabled = on; elInput.disabled = on; }

    async function ask(question){
        asked.add(norm(question));
        hideSuggest();
        addMsg(question, 'user');
        elInput.value = '';
        setBusy(true);
        var typing = addTyping();
        try {
            var resp = await fetch('/latest/ai/customerproxy.cfm', {
                method: 'POST',
                credentials: 'include',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ question: question })
            });
            var data = null;
            try { data = await resp.json(); } catch(e) {}
            typing.remove();
            if (!resp.ok || !data || !data.ok) {
                var err = (data && (data.error || data.detail)) || ('HTTP ' + resp.status);
                addMsg('Sorry, I could not answer that: ' + err, 'bot', null, true);
                return;
            }
            var meta = data.skill_used + (data.cached ? ' · cached' : '') + ' · ' + data.latency_ms + ' ms';
            addMsg(data.answer_markdown || '(no answer)', 'bot', meta);
            addFollowups(data.followups);
        } catch(e) {
            typing.remove();
            addMsg('Network error: ' + e.message, 'bot', null, true);
        } finally {
            setBusy(false);
            elInput.focus();
        }
    }

    elForm.addEventListener('submit', function(e){
        e.preventDefault();
        var q = elInput.value.trim();
        if (q) ask(q);
    });
    elInput.addEventListener('keydown', function(e){
        if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); elForm.requestSubmit(); }
    });
    elSuggest.addEventListener('click', function(e){
        var b = e.target.closest('button[data-q]');
        if (b) ask(b.getAttribute('data-q'));
    });
    elMsgs.addEventListener('click', function(e){
        var b = e.target.closest('.followups button[data-q]');
        if (b) ask(b.getAttribute('data-q'));
    });

    addMsg('Hello! I can help you pick dishes, check your order, or explain how to pay. What would you like to know?', 'bot');
})();
</script>
</body>
</html>
