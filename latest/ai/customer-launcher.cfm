<!---
  Customer dining assistant — floating launcher (orange theme).
  Include on customer e-menu pages:
      <cfinclude template="/latest/ai/customer-launcher.cfm">
--->
<cfset aiCustomerCanUse = false>
<cfif len(trim(SESSION.emenu_table_id))
    AND (SESSION.emenu_loggedin eq "Yes" OR SESSION.emenu_is_guest eq "Yes")>
    <cfset aiCustomerCanUse = true>
</cfif>

<cfif aiCustomerCanUse>
<cfset _aiTableLabel = len(trim(SESSION.emenu_table_name)) ? trim(SESSION.emenu_table_name) : (
    len(trim(SESSION.emenu_table_number)) ? "Table " & trim(SESSION.emenu_table_number) : "Your table"
)>
<cfoutput>
<style>
.cAiFab{
    position:fixed; right:16px; bottom:110px; z-index:9997;
    width:58px; height:58px; border-radius:50%;
    background:linear-gradient(135deg, ##F54900 0%, ##D04000 100%);
    color:##fff; border:0; cursor:pointer; padding:0;
    box-shadow:0 8px 22px rgba(245,73,0,0.38), 0 2px 6px rgba(0,0,0,0.15);
    display:flex; align-items:center; justify-content:center;
    transform-origin:100% 100%;
    transition:transform .35s cubic-bezier(.16,1,.3,1), opacity .25s ease, box-shadow .2s ease;
}
.cAiFab:hover{ box-shadow:0 12px 28px rgba(245,73,0,0.48); }
.cAiFab svg{ width:26px; height:26px; display:block; }
.cAiFab .cAiBadge{
    position:absolute; top:-3px; right:-3px;
    background:##111827; color:##fff;
    font:700 9px/1 "Segoe UI",sans-serif;
    letter-spacing:.04em; padding:3px 6px; border-radius:999px;
    border:2px solid ##fff;
}
.cAiFab .cAiPulse{
    position:absolute; inset:0; border-radius:50%;
    animation:cAiRing 2.4s cubic-bezier(.4,0,.6,1) infinite;
    pointer-events:none;
}
@keyframes cAiRing{
    0%{ box-shadow:0 0 0 0 rgba(245,73,0,0.45); }
    70%{ box-shadow:0 0 0 14px rgba(245,73,0,0); }
    100%{ box-shadow:0 0 0 0 rgba(245,73,0,0); }
}
.cAiFab .cAiTip{
    position:absolute; right:68px; top:50%; transform:translateY(-50%);
    background:##111827; color:##fff;
    font:600 12px/1 "Segoe UI",sans-serif;
    padding:7px 11px; border-radius:8px; white-space:nowrap;
    opacity:0; pointer-events:none; transition:opacity .15s;
}
.cAiFab:hover .cAiTip{ opacity:1; }
body.cAiOpen .cAiFab{ transform:scale(0); opacity:0; pointer-events:none; }
body.cAiOpen .cAiFab .cAiPulse{ display:none; }
/* When the cart drawer is open on menu.cfm, hide the launcher so it never covers cart actions */
body.emenuCartOpen .cAiFab{ transform:scale(0); opacity:0; pointer-events:none; }

.cAiPanel{
    position:fixed; right:20px; bottom:20px; z-index:10000;
    width:380px; height:580px;
    max-width:calc(100vw - 40px);
    max-height:calc(100vh - 40px);
    background:##fff; border-radius:20px;
    box-shadow:0 20px 50px rgba(0,0,0,0.18);
    overflow:hidden; display:flex; flex-direction:column;
    transform-origin:100% 100%;
    transform:scale(0); opacity:0; pointer-events:none;
    transition:transform .4s cubic-bezier(.16,1,.3,1), opacity .28s ease;
    font-family:"Segoe UI",Arial,sans-serif;
}
body.cAiOpen .cAiPanel{ transform:scale(1); opacity:1; pointer-events:auto; }

.cAiHead{
    background:linear-gradient(135deg, ##F54900, ##D04000);
    color:##fff; padding:14px 16px;
    display:flex; align-items:center; gap:12px; flex-shrink:0;
}
.cAiHeadIcon{
    width:36px; height:36px; border-radius:50%;
    background:rgba(255,255,255,0.2);
    display:flex; align-items:center; justify-content:center; flex-shrink:0;
}
.cAiHeadIcon svg{ width:20px; height:20px; }
.cAiHeadText{ flex:1; min-width:0; }
.cAiHeadTitle{ font-size:16px; font-weight:700; }
.cAiHeadSub{ font-size:11px; opacity:.9; margin-top:2px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
.cAiClose{
    background:rgba(255,255,255,0.18); border:0; color:##fff;
    width:32px; height:32px; border-radius:50%; cursor:pointer;
    display:flex; align-items:center; justify-content:center;
}
.cAiClose:hover{ background:rgba(255,255,255,0.32); }
.cAiBody{ flex:1; min-height:0; background:##f9fafb; }
.cAiBody iframe{ width:100%; height:100%; border:0; display:block; }

@media (max-width:520px){
    .cAiFab{ right:12px; bottom:110px; width:54px; height:54px; }
    .cAiPanel{ right:10px; bottom:10px; width:calc(100vw - 20px); height:calc(100vh - 80px); }
}
</style>

<button type="button" class="cAiFab" id="cAiOpenBtn" aria-label="Open menu assistant">
    <span class="cAiPulse" aria-hidden="true"></span>
    <svg viewBox="0 0 32 32" fill="none" stroke="##fff" stroke-width="2.2" stroke-linecap="round" aria-hidden="true">
        <path d="M16 4a4 4 0 0 1 4 4v1h2a3 3 0 0 1 3 3v10a3 3 0 0 1-3 3H10a3 3 0 0 1-3-3V12a3 3 0 0 1 3-3h2v-1a4 4 0 0 1 4-4z"/>
        <circle cx="12" cy="17" r="1.2" fill="##fff" stroke="none"/>
        <circle cx="16" cy="17" r="1.2" fill="##fff" stroke="none"/>
        <circle cx="20" cy="17" r="1.2" fill="##fff" stroke="none"/>
    </svg>
    <span class="cAiBadge">AI</span>
    <span class="cAiTip">Ask menu assistant</span>
</button>

<div class="cAiPanel" id="cAiPanel" role="dialog" aria-labelledby="cAiTitle">
    <div class="cAiHead">
        <div class="cAiHeadIcon" aria-hidden="true">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2a3 3 0 0 0-3 3v1H6a2 2 0 0 0-2 2v11a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-3V5a3 3 0 0 0-3-3z"/><path d="M9 14h.01M12 14h.01M15 14h.01"/></svg>
        </div>
        <div class="cAiHeadText">
            <div class="cAiHeadTitle" id="cAiTitle">Menu Assistant</div>
            <div class="cAiHeadSub">#HTMLEditFormat(_aiTableLabel)# &middot; menu &amp; order help</div>
        </div>
        <button type="button" class="cAiClose" id="cAiCloseBtn" aria-label="Close">&times;</button>
    </div>
    <div class="cAiBody">
        <iframe id="cAiFrame" title="Menu assistant chat" src="about:blank" loading="lazy"></iframe>
    </div>
</div>

<script>
(function(){
    var btn = document.getElementById('cAiOpenBtn');
    var closeBtn = document.getElementById('cAiCloseBtn');
    var frame = document.getElementById('cAiFrame');
    var loaded = false;
    function openPanel(){
        if (!loaded){ frame.src = '/latest/ai/customer.cfm?embed=1'; loaded = true; }
        document.body.classList.add('cAiOpen');
    }
    function closePanel(){ document.body.classList.remove('cAiOpen'); }
    btn.addEventListener('click', openPanel);
    closeBtn.addEventListener('click', closePanel);
    document.addEventListener('keydown', function(e){
        if (e.key === 'Escape' && document.body.classList.contains('cAiOpen')) closePanel();
    });
})();
</script>
</cfoutput>
</cfif>
