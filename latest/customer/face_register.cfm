<cfprocessingdirective pageencoding="UTF-8">
<cfinclude template="../../application.cfm">
<cfsetting showdebugoutput="false">

<cfif NOT len(trim(SESSION.emenu_table_id))>
    <cflocation url="/latest/customer/qr_error.cfm" addtoken="false">
</cfif>
<cfif SESSION.emenu_loggedin neq "Yes">
    <cflocation url="/latest/customer/login.cfm" addtoken="false">
</cfif>

<!--- ?debug=1 shows the measured distance for every pose, so the
      same-person threshold can be set from real readings rather than
      guessed. Off unless explicitly requested. --->
<cfparam name="url.debug" default="0">
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
    <title>Register Your Face</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: "Segoe UI", Arial, sans-serif;
            min-height: 100vh;
            display: flex; align-items: center; justify-content: center;
            background: #f9fafb; padding: 24px;
        }
        .card {
            background: #fff; border-radius: 24px;
            box-shadow: 0 8px 32px rgba(0,0,0,.1);
            padding: 36px 28px; max-width: 400px; width: 100%; text-align: center;
        }
        .icon { font-size: 52px; margin-bottom: 16px; }
        h2 { font-size: 22px; font-weight: 700; color: #111827; margin-bottom: 10px; }
        p  { font-size: 15px; color: #6b7280; line-height: 1.6; margin-bottom: 28px; }
        .btn {
            display: block; width: 100%; padding: 14px;
            border-radius: 12px; font-size: 15px; font-weight: 700;
            cursor: pointer; border: none; margin-bottom: 12px; text-decoration: none;
        }
        .btn-primary { background: linear-gradient(135deg,#3b82f6,#7c3aed); color: #fff; }
        .btn-skip    { background: #f3f4f6; color: #374151; }

        /* ---- capture modal ---- */
        #face-modal {
            display: none; position: fixed; inset: 0; background: rgba(0,0,0,.85);
            z-index: 999; align-items: center; justify-content: center; padding: 20px;
        }
        .cap-box {
            background: #fff; border-radius: 20px; padding: 22px;
            width: 100%; max-width: 400px; text-align: center;
        }
        .cap-steps { display: flex; gap: 6px; justify-content: center; margin-bottom: 14px; }
        .cap-dot {
            width: 44px; height: 5px; border-radius: 3px; background: #e5e7eb;
            transition: background .3s;
        }
        .cap-dot.done   { background: #22c55e; }
        .cap-dot.active { background: #3b82f6; }
        .cap-title { font-size: 17px; font-weight: 700; color: #111827; margin-bottom: 4px; }
        .cap-sub   { font-size: 13px; color: #6b7280; margin-bottom: 14px; min-height: 34px; }
        .cap-stage {
            position: relative; border-radius: 16px; overflow: hidden;
            background: #000; margin-bottom: 14px; aspect-ratio: 4 / 3;
        }
        .cap-stage video {
            width: 100%; height: 100%; object-fit: cover; display: block;
        }
        .cap-stage svg { position: absolute; inset: 0; width: 100%; height: 100%; }
        .cap-status {
            position: absolute; bottom: 10px; left: 0; right: 0; text-align: center;
            color: #fff; font-size: 13px; font-weight: 600;
            text-shadow: 0 1px 5px rgba(0,0,0,.8); padding: 0 12px;
        }
        .cap-cancel {
            width: 100%; padding: 12px; background: #f3f4f6; border: none;
            border-radius: 10px; font-size: 15px; cursor: pointer; color: #374151;
        }
    </style>
</head>
<body>
<div class="card">
    <cfif val(url.debug) gt 0>
        <div style="background:#fef3c7; border:1.5px solid #fbbf24; border-radius:10px;
                    padding:10px 12px; margin-bottom:16px; font-size:13px; color:#92400e;
                    text-align:left; line-height:1.5;">
            <strong>DEBUG PANEL ON</strong><br>
            Gate readings are shown on screen during capture. Your face
            <strong>is still saved normally</strong> — readings upload on every
            enrolment now, with or without this flag.
        </div>
    </cfif>

    <div class="icon">&#x1F9EC;</div>
    <h2>Register Your Face</h2>
    <p>
        Hi <cfoutput>#HTMLEditFormat(SESSION.emenu_name)#</cfoutput>! Your account is ready.<br><br>
        Register your face for faster logins next time. It takes three quick
        poses and about ten seconds. You can always skip this step.
    </p>

    <button class="btn btn-primary" onclick="startFaceReg()">Register Face Now</button>
    <a href="/latest/customer/menu.cfm" class="btn btn-skip">Skip for Now</a>
</div>

<div id="face-modal">
    <div class="cap-box">
        <div class="cap-steps">
            <div class="cap-dot" id="dot-0"></div>
            <div class="cap-dot" id="dot-1"></div>
            <div class="cap-dot" id="dot-2"></div>
        </div>
        <div class="cap-title" id="cap-title">Getting ready&hellip;</div>
        <div class="cap-sub"   id="cap-sub">Loading face models</div>

        <div class="cap-stage">
            <video id="face-video" autoplay playsinline muted></video>
            <svg viewBox="0 0 100 100" preserveAspectRatio="none">
                <!--- guide oval: enforces distance + centring, and makes the
                      customer the unambiguously largest face in frame --->
                <ellipse id="guide-bg" cx="50" cy="48" rx="27" ry="36"
                         fill="none" stroke="rgba(255,255,255,.45)"
                         stroke-width="1.2" stroke-dasharray="3 3"
                         vector-effect="non-scaling-stroke"></ellipse>
                <!--- progress ring: fills as consecutive good frames stack up --->
                <ellipse id="guide-fill" cx="50" cy="48" rx="27" ry="36"
                         pathLength="100" fill="none" stroke="#22c55e"
                         stroke-width="2.4" stroke-dasharray="100"
                         stroke-dashoffset="100" transform="rotate(-90 50 48)"
                         vector-effect="non-scaling-stroke"
                         style="transition:stroke-dashoffset .15s linear"></ellipse>
            </svg>
            <div class="cap-status" id="cap-status"></div>
        </div>

        <div id="cap-debug" style="display:none; text-align:left; font-family:monospace;
             font-size:11px; line-height:1.5; background:#111827; color:#a7f3d0;
             border-radius:8px; padding:8px 10px; margin-bottom:12px;
             max-height:150px; overflow-y:auto;"></div>

        <div id="cap-upload" style="display:none; font-family:monospace; font-size:11px;
             color:#6b7280; margin-bottom:10px; text-align:left;"></div>

        <button type="button" class="cap-cancel" onclick="closeFaceModal()">Cancel</button>
    </div>
</div>

<form id="face-save-form" action="/latest/customer/face_save.cfm" method="post" style="display:none;">
    <input type="hidden" name="descriptor" id="face-descriptor-input" value="">
</form>

<script src="/latest/customer/inc_face_capture.js"></script>
<script>
/* Three poses. Slight turns only — a full profile can't be landmark-aligned
   and its descriptor sits far enough from the frontal one that storing it
   would widen the match region and cause false accepts. */
var POSES = [
    { pose: 'center', title: 'Look straight ahead',
      hint:  'Line your face up inside the oval' },
    { pose: 'left',   title: 'Turn slightly to your LEFT',
      hint:  'Turn your head a little further to your left' },
    { pose: 'right',  title: 'Turn slightly to your RIGHT',
      hint:  'Turn your head a little further to your right' }
];

/* Max distance a later pose may sit from the first pose and still be
   accepted as the same person.

   PROVISIONAL. 0.55 was set from frontal-to-frontal impostor readings, but
   these are cross-pose comparisons (centre vs turned), where genuine
   distance is larger and the impostor gap is correspondingly narrower — a
   real impostor cleared 0.55 in testing. Load this page with ?debug=1 to
   read the measured distance for each pose, then set this from your own
   numbers: comfortably above your own worst solo pose, comfortably below
   your lowest impostor reading. */
var SAME_PERSON_MAX = 0.45;

/* Diagnostics are collected and uploaded on EVERY enrolment while the gate
   thresholds are being tuned, so an ordinary QR-scan run produces readings
   without anyone needing a special URL. Enrolment saves exactly as normal.
   ?debug=1 only adds the on-screen panel.
   TEMPORARY — drop DIAG_ON to false (and delete face_debug_log.cfm) once the
   thresholds are settled. */
var DIAG_ON    = true;
var SHOW_PANEL = <cfoutput>#(val(url.debug) gt 0) ? "true" : "false"#</cfoutput>;

var lastDiagAt = 0;
var diagBuffer = [];
var uploadedLines = 0;

function setUploadStatus(msg) {
    if (!SHOW_PANEL) { return; }
    var el = document.getElementById('cap-upload');
    if (el) { el.style.display = 'block'; el.textContent = 'debug log: ' + msg; }
}

function debugLog(line) {
    if (!DIAG_ON) { return; }
    diagBuffer.push(line);
    if (!SHOW_PANEL) { return; }
    var el = document.getElementById('cap-debug');
    if (!el) { return; }
    el.style.display = 'block';
    el.innerHTML += line + '<br>';
    el.scrollTop = el.scrollHeight;
}

/* The readings scroll past faster than anyone can read while posing, so
   they are also shipped to face_debug_log.cfm for review afterwards.

   final=true is used when the page is about to navigate. It sends via
   sendBeacon, which the browser hands off and forgets. A fetch() started
   as the page unloads is not guaranteed to be delivered, and over a
   tunnel with few concurrent connections it can leave the navigation
   queued behind it — which showed up as registration appearing to hang
   until the page was refreshed by hand. */
var DIAG_URL = '/latest/customer/face_debug_log.cfm';

function flushDiag(final) {
    if (!DIAG_ON || diagBuffer.length === 0) { return; }
    var count = diagBuffer.length;
    var body = 'lines=' + encodeURIComponent(diagBuffer.join('\n'));
    diagBuffer = [];

    if (final) {
        try {
            if (navigator.sendBeacon) {
                navigator.sendBeacon(DIAG_URL, new Blob([body],
                    { type: 'application/x-www-form-urlencoded' }));
            }
        } catch (e) { /* diagnostics must never hold up navigation */ }
        return;
    }

    /* Report the upload result on screen — otherwise a silently failing
       fetch looks identical to never having run at all. */
    try {
        fetch(DIAG_URL, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: body,
            credentials: 'same-origin'
        }).then(function (r) {
            return r.text();
        }).then(function (txt) {
            uploadedLines += count;
            setUploadStatus(txt.indexOf('ok') > -1
                ? 'uploaded ' + uploadedLines + ' lines'
                : 'UPLOAD REJECTED: ' + txt);
        }).catch(function (e) {
            setUploadStatus('UPLOAD FAILED: ' + e.message);
        });
    } catch (e) {
        setUploadStatus('UPLOAD FAILED: ' + e.message);
    }
}

var diagTimer = setInterval(flushDiag, 2000);
window.addEventListener('beforeunload', function () { flushDiag(true); });

/* Set from the centre pose; the turned poses are judged relative to it. */
var neutralYaw  = null;

var capStream   = null;
var capActive   = false;
var capIndex    = 0;
var capTemplates = [];

function isActive() { return capActive; }

function setSub(t)    { document.getElementById('cap-sub').textContent = t; }
function setTitle(t)  { document.getElementById('cap-title').textContent = t; }
function setStatus(t) { document.getElementById('cap-status').textContent = t || ''; }

function setRing(pct) {
    document.getElementById('guide-fill')
            .setAttribute('stroke-dashoffset', String(100 - pct));
}

function setDots() {
    for (var i = 0; i < 3; i++) {
        var d = document.getElementById('dot-' + i);
        d.className = 'cap-dot' + (i < capIndex ? ' done' : (i === capIndex ? ' active' : ''));
    }
}

function startFaceReg() {
    document.getElementById('face-modal').style.display = 'flex';
    capIndex = 0; capTemplates = []; capActive = false; neutralYaw = null;
    debugLog('===== run started ' + new Date().toISOString() +
             ' | SAME_PERSON_MAX ' + SAME_PERSON_MAX + ' =====');
    setDots(); setRing(0);
    setTitle('Getting ready…'); setSub('Loading face models'); setStatus('');

    FaceCapture.ensureReady(function () {
        FaceCapture.startCamera(document.getElementById('face-video'), function (stream) {
            capStream = stream;
            capActive = true;
            runPose();
        }, failCapture);
    }, failCapture);
}

function failCapture(msg) {
    setTitle('Something went wrong');
    setSub(msg);
    setStatus('');
}

function runPose() {
    if (!capActive) { return; }
    var step = POSES[capIndex];
    setDots();
    setRing(0);
    setTitle(step.title);
    setSub(step.hint);

    FaceCapture.collectTemplate({
        video:     document.getElementById('face-video'),
        pose:      step.pose,
        neutral:   neutralYaw,
        frames:    5,
        isActive:  isActive,
        poseHint:  step.hint,
        holdHint:  'Hold still…',
        onProgress: function (done, needed, message) {
            setRing(Math.round((done / needed) * 100));
            setStatus(message);
        },
        onDiag: function (g, wantPose, streak) {
            /* Throttled so the panel stays readable at ~5 fps of detection. */
            if (!DIAG_ON) { return; }
            var now = Date.now();
            if (now - lastDiagAt < 700) { return; }
            lastDiagAt = now;
            if (!g.m) { debugLog('want ' + wantPose + ' | no face detected'); return; }
            var m = g.m;
            debugLog(
                'want ' + wantPose + ' | got ' + m.pose +
                ' yaw ' + m.yaw.toFixed(3) +
                (m.neutral === null || m.neutral === undefined
                    ? '' : ' (neutral ' + m.neutral.toFixed(3) + ')') +
                ' | score ' + m.score.toFixed(2) + '/' + m.needScore +
                ' size ' + m.ratio.toFixed(2) +
                ' cx ' + m.cx.toFixed(2) + ' cy ' + m.cy.toFixed(2) +
                ' lum ' + Math.round(m.luma) +
                (m.drift === null ? '' : ' drift ' + m.drift.toFixed(3)) +
                ' | ' + (g.ok ? 'OK ' + streak + '/5' : g.reason)
            );
        },
        onDone: function (result) {
            /* Every pose must be the SAME person as the first one. Without
               this, poses could be captured from different faces, producing
               an account that holds two identities — which then matches
               neither of them cleanly at login. Same person at a different
               angle lands around 0.35-0.45; two different people sit at 0.6+,
               so 0.55 separates them with room to spare. */
            if (capTemplates.length > 0) {
                var d = FaceCapture.distance(capTemplates[0].d, result.descriptor);
                debugLog('pose ' + (capIndex + 1) + ' (' + step.pose + ') vs pose 1 = ' +
                         d.toFixed(4) + (d > SAME_PERSON_MAX ? '  REJECT' : '  accept') +
                         '  [limit ' + SAME_PERSON_MAX + ']');
                if (d > SAME_PERSON_MAX) {
                    setRing(0);
                    setStatus('');
                    setTitle('Different face detected');
                    setSub('That does not look like the same person as the first pose. ' +
                           'Registration restarted — please capture all three poses yourself.');
                    capIndex = 0;
                    capTemplates = [];
                    neutralYaw = null;
                    setDots();
                    setTimeout(runPose, 2600);
                    return;
                }
            }

            if (capTemplates.length === 0) {
                neutralYaw = result.yaw;
                debugLog('neutral yaw calibrated to ' + neutralYaw.toFixed(3) +
                         ' (turn target +/-' + FaceCapture.YAW.delta + ')');
            }

            capTemplates.push({ pose: step.pose, d: result.descriptor, yaw: result.yaw });
            setRing(100);
            setStatus('Captured');
            capIndex++;
            if (capIndex >= POSES.length) {
                setTimeout(finishCapture, 350);
            } else {
                setTimeout(runPose, 600);
            }
        }
    });
}

function finishCapture() {
    capActive = false;
    FaceCapture.stopStream(capStream);
    capStream = null;
    setDots();

    /* Liveness: the head must genuinely have turned between the left and
       right poses. A printed photo or a face on a screen cannot do this. */
    var yaws = capTemplates.map(function (t) { return t.yaw; });
    var spread = Math.max.apply(null, yaws) - Math.min.apply(null, yaws);

    if (DIAG_ON) {
        debugLog('--- all pairwise distances ---');
        for (var x = 0; x < capTemplates.length; x++) {
            for (var y = x + 1; y < capTemplates.length; y++) {
                debugLog(capTemplates[x].pose + ' vs ' + capTemplates[y].pose + ' = ' +
                    FaceCapture.distance(capTemplates[x].d, capTemplates[y].d).toFixed(4));
            }
        }
        debugLog('yaw spread = ' + spread.toFixed(4) + '  [min 0.12]');
        debugLog('yaws: ' + yaws.map(function (v) { return v.toFixed(3); }).join(', '));
    }
    /* Left and right bands are 0.16 apart at minimum, so this must sit below
       that or an honest enrolment would be rejected as a spoof. */
    if (spread < 0.12) {
        setTitle('Could not verify');
        setSub('We could not detect real head movement. Please try again in good light.');
        setStatus('');
        return;
    }

    /* Stop the periodic upload and hand the remaining lines to sendBeacon
       before navigating, so no diagnostic request is competing with the
       form POST or with the redirect that follows it. */
    clearInterval(diagTimer);
    flushDiag(true);

    setTitle('All done');
    setSub('Saving your face profile…');

    var payload = {
        v: 2,
        templates: capTemplates.map(function (t) {
            return { pose: t.pose, d: t.d };
        }),
        yaw_spread: Number(spread.toFixed(4))
    };
    document.getElementById('face-descriptor-input').value = JSON.stringify(payload);
    document.getElementById('face-save-form').submit();
}

function closeFaceModal() {
    capActive = false;
    FaceCapture.stopStream(capStream);
    capStream = null;
    document.getElementById('face-modal').style.display = 'none';
}
</script>
</body>
</html>
