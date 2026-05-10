<!---
  AI Business Analyst floating launcher.
  Drop this into any admin page with:
      <cfinclude template="/latest/ai/launcher.cfm">
  Renders nothing for users whose role is not in AI_ALLOWED_ROLES.
  Visual style: Bootstrap 3 (Glyphicons font + panel/btn conventions).
  All hashes inside <cfoutput> are escaped (##) for Railo.
--->
<cfset AI_ALLOWED_ROLES = "super,suser">
<cfset aiCanUse = false>
<cfif isDefined("session.isLogIn") AND session.isLogIn EQ "Yes" AND isDefined("husergrpid") AND listFindNoCase(AI_ALLOWED_ROLES, husergrpid)>
    <cfset aiCanUse = true>
</cfif>

<cfif aiCanUse>
<cfoutput>
<style>
/* ---- Glyphicons (just the font, not full Bootstrap, so we don't disturb the host page) ---- */
@font-face {
    font-family: 'AI Glyphicons';
    src: url('/latest/fonts/glyphicons-halflings-regular.eot');
    src: url('/latest/fonts/glyphicons-halflings-regular.eot?##iefix') format('embedded-opentype'),
         url('/latest/fonts/glyphicons-halflings-regular.woff') format('woff'),
         url('/latest/fonts/glyphicons-halflings-regular.ttf') format('truetype'),
         url('/latest/fonts/glyphicons-halflings-regular.svg##glyphicons_halflingsregular') format('svg');
    font-weight: normal; font-style: normal;
}
.aiGlyph{
    font-family: 'AI Glyphicons';
    font-style: normal; font-weight: normal;
    line-height: 1; display: inline-block;
    -webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale;
    font-feature-settings: "liga" 0;
    speak: none;
}

/* ---- FAB (floating button) ---- */
.aiFab{
    position:fixed; right:24px; bottom:24px; z-index:9998;
    width:60px; height:60px; border-radius:50%;
    background:linear-gradient(135deg, ##CF5D5D 0%, ##B84F4F 100%);
    color:##FFFFFF; border:0; cursor:pointer; padding:0;
    box-shadow:0 8px 22px rgba(207,93,93,0.40), 0 2px 6px rgba(0,0,0,0.18);
    display:flex; align-items:center; justify-content:center;
    transform-origin:100% 100%;
    transition:transform .35s cubic-bezier(.16,1,.3,1),
               opacity .25s ease,
               box-shadow .2s ease;
}
.aiFab:hover{
    box-shadow:0 12px 28px rgba(207,93,93,0.50), 0 4px 10px rgba(0,0,0,0.22);
}
.aiFab .aiFabIcon{ width:28px; height:28px; display:block; }
.aiFab .aiFabBadge{
    position:absolute; top:-4px; right:-4px;
    background:##454E59; color:##FFFFFF;
    font:700 10px/1 "Franklin Gothic Demi","Segoe UI",sans-serif;
    letter-spacing:.04em; padding:3px 7px; border-radius:999px;
    box-shadow:0 2px 6px rgba(0,0,0,0.22); border:2px solid ##FFFFFF;
}
.aiFab .aiFabPulse{
    position:absolute; inset:0; border-radius:50%;
    box-shadow:0 0 0 0 rgba(207,93,93,0.55);
    animation: aiPulseRing 2.4s cubic-bezier(.4,0,.6,1) infinite;
    pointer-events:none;
}
@keyframes aiPulseRing{
    0%   { box-shadow:0 0 0 0 rgba(207,93,93,0.45); }
    70%  { box-shadow:0 0 0 16px rgba(207,93,93,0); }
    100% { box-shadow:0 0 0 0 rgba(207,93,93,0); }
}
.aiFab .aiFabTip{
    position:absolute; right:74px; top:50%; transform:translateY(-50%);
    background:##454E59; color:##FFFFFF;
    font:600 12px/1 "Franklin Gothic Medium","Segoe UI",sans-serif;
    padding:7px 11px; border-radius:6px; white-space:nowrap;
    opacity:0; pointer-events:none; transition:opacity .15s ease;
    box-shadow:0 4px 10px rgba(0,0,0,0.22);
}
.aiFab .aiFabTip:after{
    content:""; position:absolute; right:-5px; top:50%; transform:translateY(-50%);
    border:5px solid transparent; border-left-color:##454E59;
}
.aiFab:hover .aiFabTip{ opacity:1; }

/* When chat is open the FAB collapses into the panel's origin point */
body.aiOpen .aiFab{
    transform:scale(0);
    opacity:0;
    pointer-events:none;
}
body.aiOpen .aiFab .aiFabPulse{ display:none; }

/* ---- Panel (chat window) ---- */
.aiPanel{
    position:fixed; right:24px; bottom:24px; z-index:10000;
    width:400px; height:620px;
    max-width:calc(100vw - 48px);
    max-height:calc(100vh - 48px);
    background:##FFFFFF;
    border-radius:18px;
    box-shadow:0 20px 50px rgba(69,78,89,0.28),
               0 6px 18px rgba(0,0,0,0.10);
    overflow:hidden;
    display:flex; flex-direction:column;
    transform-origin:100% 100%;
    transform:scale(0);
    opacity:0;
    pointer-events:none;
    transition:transform .42s cubic-bezier(.16,1,.3,1),
               opacity .28s ease,
               border-radius .42s cubic-bezier(.16,1,.3,1);
    font-family:"Segoe UI",Verdana,Arial,sans-serif;
}
body.aiOpen .aiPanel{
    transform:scale(1);
    opacity:1;
    pointer-events:auto;
}

/* Bootstrap-3-style panel-heading (just the look, not the framework) */
.aiPanelHeader{
    background:linear-gradient(135deg, ##CF5D5D 0%, ##B84F4F 100%);
    color:##FFFFFF;
    padding:12px 14px 12px 16px;
    display:flex; align-items:center; gap:12px;
    flex-shrink:0;
    border-bottom:1px solid rgba(0,0,0,0.06);
}
.aiPanelHeader .aiHeaderIcon{
    width:34px; height:34px; border-radius:50%;
    background:rgba(255,255,255,0.18);
    display:flex; align-items:center; justify-content:center;
    flex-shrink:0;
}
.aiPanelHeader .aiHeaderIcon .aiGlyph{ font-size:16px; }
.aiPanelHeader .aiHeaderText{ flex:1; min-width:0; line-height:1.2; }
.aiPanelHeader .aiHeaderTitle{
    font-family:"Franklin Gothic Demi","Segoe UI",sans-serif;
    font-size:16px; letter-spacing:.01em;
}
.aiPanelHeader .aiHeaderSub{
    display:block; margin-top:2px;
    font:normal 11px/1.3 "Franklin Gothic Book","Segoe UI",sans-serif;
    opacity:.85;
    overflow:hidden; text-overflow:ellipsis; white-space:nowrap;
}
.aiPanelHeader .aiHeaderSub strong{ font-weight:700; }
.aiPanelHeader .aiBtnClose{
    background:rgba(255,255,255,0.16);
    color:##FFFFFF; border:0; cursor:pointer;
    width:32px; height:32px; border-radius:50%;
    display:flex; align-items:center; justify-content:center;
    transition:background .15s ease, transform .15s ease;
    flex-shrink:0;
}
.aiPanelHeader .aiBtnClose .aiGlyph{ font-size:11px; }
.aiPanelHeader .aiBtnClose:hover{ background:rgba(255,255,255,0.30); transform:rotate(90deg); }

.aiPanelBody{
    flex:1; min-height:0;
    background:##F5F7FB;
}
.aiPanelBody iframe{
    width:100%; height:100%; border:0; display:block;
    background:##F5F7FB;
}

/* ---- Mobile ---- */
@media (max-width: 520px){
    .aiFab{ right:16px; bottom:16px; width:56px; height:56px; }
    .aiPanel{
        right:12px; bottom:12px;
        width:calc(100vw - 24px);
        height:calc(100vh - 96px);
    }
}
</style>

<button type="button" class="aiFab" id="aiLauncherBtn" aria-label="Open AI Business Analyst">
    <span class="aiFabPulse" aria-hidden="true"></span>
    <svg class="aiFabIcon" viewBox="0 0 32 32" fill="none" stroke="##FFFFFF" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
        <path d="M27 16c0 5.523-4.925 10-11 10-1.69 0-3.291-.347-4.726-.967L6 27l1.4-4.466C5.913 20.79 5 18.498 5 16 5 10.477 9.925 6 16 6s11 4.477 11 10z"></path>
        <circle cx="11.5" cy="16" r="1.1" fill="##FFFFFF" stroke="none"></circle>
        <circle cx="16" cy="16" r="1.1" fill="##FFFFFF" stroke="none"></circle>
        <circle cx="20.5" cy="16" r="1.1" fill="##FFFFFF" stroke="none"></circle>
    </svg>
    <span class="aiFabBadge">AI</span>
    <span class="aiFabTip">Ask the AI Analyst</span>
</button>

<div class="aiPanel" id="aiPanel" role="dialog" aria-modal="false" aria-labelledby="aiPanelTitle">
    <div class="aiPanelHeader">
        <div class="aiHeaderIcon" aria-hidden="true">
            <span class="aiGlyph">&##xe185;</span>
        </div>
        <div class="aiHeaderText">
            <div class="aiHeaderTitle" id="aiPanelTitle">AI Business Analyst</div>
            <span class="aiHeaderSub">Branch <strong>#dts#</strong> &middot; Insights from your e-menu</span>
        </div>
        <button type="button" class="aiBtnClose" id="aiCloseBtn" aria-label="Close">
            <span class="aiGlyph" aria-hidden="true">&##xe014;</span>
        </button>
    </div>
    <div class="aiPanelBody">
        <iframe id="aiFrame" title="AI Business Analyst chat" src="about:blank" loading="lazy"></iframe>
    </div>
</div>

<script>
(function(){
    var btn      = document.getElementById('aiLauncherBtn');
    var panel    = document.getElementById('aiPanel');
    var closeBtn = document.getElementById('aiCloseBtn');
    var frame    = document.getElementById('aiFrame');
    var loaded   = false;

    function openPanel(){
        if (!loaded){
            frame.src = '/latest/ai/analyst.cfm?embed=1';
            loaded = true;
        }
        document.body.classList.add('aiOpen');
    }
    function closePanel(){
        document.body.classList.remove('aiOpen');
    }
    function isOpen(){ return document.body.classList.contains('aiOpen'); }

    btn.addEventListener('click', openPanel);
    closeBtn.addEventListener('click', closePanel);
    document.addEventListener('keydown', function(e){
        if (e.key === 'Escape' && isOpen()) closePanel();
    });
})();
</script>
</cfoutput>
</cfif>
