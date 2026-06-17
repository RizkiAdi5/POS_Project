<cfprocessingdirective pageencoding="UTF-8">
<cfinclude template="../../application.cfm">
<cfsetting showdebugoutput="false">

<!--- No table context — redirect --->
<cfif NOT len(trim(SESSION.emenu_table_id))>
    <cflocation url="/latest/customer/qr_error.cfm" addtoken="false">
</cfif>

<!--- Already logged in — go to menu --->
<cfif SESSION.emenu_loggedin eq "Yes" AND len(SESSION.emenu_custno)>
    <cflocation url="/latest/customer/menu.cfm" addtoken="false">
</cfif>

<!--- Flash messages from loginProcess --->
<cfparam name="url.error"  default="">
<cfparam name="url.tab"    default="login">
<cfset flashError = HTMLEditFormat(url.error)>
<cfset activeTab  = (url.tab eq "signup") ? "signup" : "login">
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
    <title>Loyalty Login</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: "Segoe UI", Arial, sans-serif;
            min-height: 100vh;
            background: #f9fafb;
        }

        /* ---- Header ---- */
        .header {
            background: linear-gradient(135deg, #F54900 0%, #D04000 100%);
            padding: 40px 24px 80px;
            text-align: center;
        }

        .back-btn {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #fff;
            text-decoration: none;
            font-size: 15px;
            margin-bottom: 24px;
            width: fit-content;
            opacity: .9;
            transition: opacity .15s;
        }
        .back-btn:hover { opacity: 1; }

        .header-icon {
            width: 80px;
            height: 80px;
            background: #fff;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
        }

        .header-icon svg { width: 40px; height: 40px; color: #F54900; }

        .header h1 { color: #fff; font-size: 24px; font-weight: 700; margin-bottom: 6px; }
        .header p  { color: rgba(255,255,255,.85); font-size: 14px; }

        /* ---- Card ---- */
        .card-wrap {
            padding: 0 16px 40px;
            margin-top: -52px;
        }

        .card {
            background: #fff;
            border-radius: 24px;
            box-shadow: 0 8px 32px rgba(0,0,0,.10);
            padding: 24px;
        }

        /* ---- Tabs ---- */
        .tabs {
            display: flex;
            gap: 8px;
            margin-bottom: 24px;
        }

        .tab-btn {
            flex: 1;
            padding: 12px;
            border: none;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: background .2s, color .2s;
            background: #f3f4f6;
            color: #6b7280;
        }

        .tab-btn.active {
            background: #F54900;
            color: #fff;
        }

        /* ---- Form fields ---- */
        .form-group { margin-bottom: 18px; }

        label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
        }

        .input-wrap {
            position: relative;
        }

        .input-wrap svg {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            width: 20px;
            height: 20px;
            color: #9ca3af;
            pointer-events: none;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"],
        input[type="tel"] {
            width: 100%;
            padding: 13px 14px 13px 42px;
            border: 1.5px solid #e5e7eb;
            border-radius: 12px;
            font-size: 15px;
            color: #111827;
            background: #f9fafb;
            outline: none;
            transition: border-color .2s;
        }

        input:focus { border-color: #F54900; background: #fff; }

        input.no-icon {
            padding-left: 14px;
        }

        /* ---- Buttons ---- */
        .btn-primary {
            width: 100%;
            padding: 15px;
            background: #F54900;
            color: #fff;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: opacity .2s;
            margin-top: 4px;
        }
        .btn-primary:hover { opacity: .9; }

        .btn-face {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #3b82f6, #7c3aed);
            color: #fff;
            border: none;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            transition: opacity .2s;
        }
        .btn-face:hover { opacity: .9; }
        .btn-face svg { width: 22px; height: 22px; }

        /* ---- Divider ---- */
        .divider {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 20px 0;
        }
        .divider-line { flex: 1; height: 1px; background: #e5e7eb; }
        .divider span { color: #9ca3af; font-size: 13px; }

        /* ---- Error banner ---- */
        .error-banner {
            background: #fef2f2;
            border: 1.5px solid #fca5a5;
            border-radius: 10px;
            padding: 12px 14px;
            color: #dc2626;
            font-size: 14px;
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .error-banner svg { width: 18px; height: 18px; flex-shrink: 0; }

        /* ---- Face info note ---- */
        .info-note {
            background: #f5f3ff;
            border: 1.5px solid #ddd6fe;
            border-radius: 10px;
            padding: 12px 14px;
            display: flex;
            align-items: flex-start;
            gap: 10px;
            margin-top: 16px;
        }
        .info-note svg { width: 20px; height: 20px; color: #7c3aed; flex-shrink: 0; margin-top: 1px; }
        .info-note p  { font-size: 13px; color: #5b21b6; line-height: 1.5; }

        .optional { color: #9ca3af; font-weight: 400; font-size: 12px; }

        /* ---- Tab panels ---- */
        .tab-panel { display: none; }
        .tab-panel.active { display: block; }
    </style>
</head>
<body>

<div class="header">
    <a href="/latest/customer/menu.cfm" class="back-btn">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
             stroke="currentColor" stroke-width="2" width="20" height="20">
            <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7"/>
        </svg>
        Back
    </a>

    <div class="header-icon">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
             stroke="currentColor" stroke-width="1.8">
            <path stroke-linecap="round" stroke-linejoin="round"
                  d="M11.48 3.499a.562.562 0 011.04 0l2.125 5.111a.563.563 0 00.475.345l5.518.442c.499.04.701.663.321.988l-4.204 3.602a.563.563 0 00-.182.557l1.285 5.385a.562.562 0 01-.84.61l-4.725-2.885a.563.563 0 00-.586 0L6.982 20.54a.562.562 0 01-.84-.61l1.285-5.386a.562.562 0 00-.182-.557l-4.204-3.602a.562.562 0 01.321-.988l5.518-.442a.563.563 0 00.475-.345L11.48 3.5z"/>
        </svg>
    </div>
    <h1>Loyalty Rewards</h1>
    <p>Earn points with every order</p>
</div>

<div class="card-wrap">
<div class="card">

    <!--- Tab switcher --->
    <div class="tabs">
        <button class="tab-btn <cfoutput>#(activeTab eq 'login') ? 'active' : ''#</cfoutput>"
                onclick="switchTab('login')">Login</button>
        <button class="tab-btn <cfoutput>#(activeTab eq 'signup') ? 'active' : ''#</cfoutput>"
                onclick="switchTab('signup')">Sign Up</button>
    </div>

    <!--- Error banner --->
    <cfif len(flashError)>
    <div class="error-banner">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round"
                  d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z"/>
        </svg>
        <cfoutput>#flashError#</cfoutput>
    </div>
    </cfif>

    <!--- =============== LOGIN TAB =============== --->
    <div id="panel-login" class="tab-panel <cfoutput>#(activeTab eq 'login') ? 'active' : ''#</cfoutput>">

        <form action="/latest/customer/loginProcess.cfm" method="post">
            <input type="hidden" name="action" value="login">

            <div class="form-group">
                <label>Email</label>
                <div class="input-wrap">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.8">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M21.75 6.75v10.5a2.25 2.25 0 01-2.25 2.25h-15a2.25 2.25 0 01-2.25-2.25V6.75m19.5 0A2.25 2.25 0 0019.5 4.5h-15a2.25 2.25 0 00-2.25 2.25m19.5 0v.243a2.25 2.25 0 01-1.07 1.916l-7.5 4.615a2.25 2.25 0 01-2.36 0L3.32 8.91a2.25 2.25 0 01-1.07-1.916V6.75"/>
                    </svg>
                    <input type="email" name="email" placeholder="your@email.com" required
                           autocomplete="email">
                </div>
            </div>

            <div class="form-group">
                <label>Password</label>
                <div class="input-wrap">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.8">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M16.5 10.5V6.75a4.5 4.5 0 10-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 002.25-2.25v-6.75a2.25 2.25 0 00-2.25-2.25H6.75a2.25 2.25 0 00-2.25 2.25v6.75a2.25 2.25 0 002.25 2.25z"/>
                    </svg>
                    <input type="password" name="password" placeholder="&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;"
                           required autocomplete="current-password">
                </div>
            </div>

            <button type="submit" class="btn-primary">Login to Account</button>
        </form>

        <div class="divider">
            <div class="divider-line"></div>
            <span>or</span>
            <div class="divider-line"></div>
        </div>

        <button type="button" class="btn-face" onclick="startFaceLogin()">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.8">
                <path stroke-linecap="round" stroke-linejoin="round"
                      d="M7.5 3.75H6A2.25 2.25 0 003.75 6v1.5M16.5 3.75H18A2.25 2.25 0 0120.25 6v1.5m0 9V18A2.25 2.25 0 0118 20.25h-1.5m-9 0H6A2.25 2.25 0 013.75 18v-1.5M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
            </svg>
            Login with Face Recognition
        </button>

    </div><!--- end login tab --->

    <!--- =============== SIGN UP TAB =============== --->
    <div id="panel-signup" class="tab-panel <cfoutput>#(activeTab eq 'signup') ? 'active' : ''#</cfoutput>">

        <form action="/latest/customer/loginProcess.cfm" method="post" id="signupForm">
            <input type="hidden" name="action" value="register">

            <div class="form-group">
                <label>Full Name</label>
                <div class="input-wrap">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.8">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z"/>
                    </svg>
                    <input type="text" name="fullname" placeholder="John Doe" required
                           autocomplete="name">
                </div>
            </div>

            <div class="form-group">
                <label>Email</label>
                <div class="input-wrap">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.8">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M21.75 6.75v10.5a2.25 2.25 0 01-2.25 2.25h-15a2.25 2.25 0 01-2.25-2.25V6.75m19.5 0A2.25 2.25 0 0019.5 4.5h-15a2.25 2.25 0 00-2.25 2.25m19.5 0v.243a2.25 2.25 0 01-1.07 1.916l-7.5 4.615a2.25 2.25 0 01-2.36 0L3.32 8.91a2.25 2.25 0 01-1.07-1.916V6.75"/>
                    </svg>
                    <input type="email" name="email" placeholder="your@email.com" required
                           autocomplete="email">
                </div>
            </div>

            <div class="form-group">
                <label>Password</label>
                <div class="input-wrap">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.8">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M16.5 10.5V6.75a4.5 4.5 0 10-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 002.25-2.25v-6.75a2.25 2.25 0 00-2.25-2.25H6.75a2.25 2.25 0 00-2.25 2.25v6.75a2.25 2.25 0 002.25 2.25z"/>
                    </svg>
                    <input type="password" name="password" placeholder="Min. 6 characters" required
                           autocomplete="new-password" minlength="6">
                </div>
            </div>

            <div class="form-group">
                <label>Phone <span class="optional">(optional)</span></label>
                <div class="input-wrap">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.8">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 6.75c0 8.284 6.716 15 15 15h2.25a2.25 2.25 0 002.25-2.25v-1.372c0-.516-.351-.966-.852-1.091l-4.423-1.106c-.44-.11-.902.055-1.173.417l-.97 1.293c-.282.376-.769.542-1.21.38a12.035 12.035 0 01-7.143-7.143c-.162-.441.004-.928.38-1.21l1.293-.97c.363-.271.527-.734.417-1.173L6.963 3.102a1.125 1.125 0 00-1.091-.852H4.5A2.25 2.25 0 002.25 6.75z"/>
                    </svg>
                    <input type="tel" name="phone" placeholder="+60 12-345 6789"
                           autocomplete="tel">
                </div>
            </div>

            <button type="submit" class="btn-primary">Create Account</button>
        </form>

        <div class="info-note">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.8">
                <path stroke-linecap="round" stroke-linejoin="round"
                      d="M7.5 3.75H6A2.25 2.25 0 003.75 6v1.5M16.5 3.75H18A2.25 2.25 0 0120.25 6v1.5m0 9V18A2.25 2.25 0 0118 20.25h-1.5m-9 0H6A2.25 2.25 0 013.75 18v-1.5M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
            </svg>
            <p>After creating your account you can optionally register your face for faster future logins!</p>
        </div>

    </div><!--- end signup tab --->

</div><!--- .card --->
</div><!--- .card-wrap --->

<!--- ================================================================
    FACE LOGIN MODAL
================================================================ --->
<div id="face-modal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.7);
     z-index:999; align-items:center; justify-content:center; padding:24px;">
    <div style="background:#fff; border-radius:20px; padding:24px; width:100%; max-width:380px; text-align:center;">

        <h3 style="font-size:18px; font-weight:700; color:#111827; margin-bottom:6px;">Face Recognition</h3>
        <p style="font-size:14px; color:#6b7280; margin-bottom:16px;">
            Look directly at the camera and hold still
        </p>

        <div style="position:relative; border-radius:16px; overflow:hidden; background:#000; margin-bottom:16px;">
            <video id="face-video" autoplay playsinline muted
                   style="width:100%; display:block; border-radius:16px;"></video>
            <canvas id="face-canvas" style="position:absolute; top:0; left:0; width:100%; height:100%;"></canvas>
            <div id="face-status" style="position:absolute; bottom:12px; left:0; right:0;
                 text-align:center; color:#fff; font-size:13px; font-weight:600;
                 text-shadow:0 1px 4px rgba(0,0,0,.6);">
                Initialising camera&hellip;
            </div>
        </div>

        <button onclick="closeFaceModal()" type="button"
                style="width:100%; padding:12px; background:#f3f4f6; border:none;
                       border-radius:10px; font-size:15px; color:#374151;
                       cursor:pointer; margin-top:4px;">
            Cancel
        </button>

    </div>
</div>

<!--- Hidden form — submitted programmatically after face match --->
<form id="face-login-form" action="/latest/customer/loginProcess.cfm" method="post" style="display:none;">
    <input type="hidden" name="action"      value="face_login">
    <input type="hidden" name="descriptor"  id="face-descriptor-input" value="">
</form>

<script>
/* ---- Tab switching ---- */
function switchTab(tab) {
    document.querySelectorAll('.tab-btn').forEach(function(b) { b.classList.remove('active'); });
    document.querySelectorAll('.tab-panel').forEach(function(p) { p.classList.remove('active'); });
    document.querySelector('#panel-' + tab).classList.add('active');
    event.currentTarget.classList.add('active');
}

/* ================================================================
   FACE RECOGNITION — face-api.js (CDN)
   Models loaded from jsDelivr CDN weights
================================================================ */
var faceApiReady   = false;
var faceStream     = null;
var faceDetecting  = false;

/* Load face-api.js lazily when modal opens */
function ensureFaceApi(callback) {
    if (window.faceapi) { callback(); return; }
    var s = document.createElement('script');
    s.src = 'https://cdn.jsdelivr.net/npm/face-api.js@0.22.2/dist/face-api.min.js';
    s.onload = function() {
        var MODEL_URL = '/latest/customer/models';
        Promise.all([
            faceapi.nets.tinyFaceDetector.loadFromUri(MODEL_URL),
            faceapi.nets.faceLandmark68Net.loadFromUri(MODEL_URL),
            faceapi.nets.faceRecognitionNet.loadFromUri(MODEL_URL)
        ]).then(function() {
            faceApiReady = true;
            setTimeout(callback, 0);
        }).catch(function(err) {
            setFaceStatus('Failed to load models: ' + err.message, '#ef4444');
        });
    };
    document.head.appendChild(s);
}

function setFaceStatus(msg, color) {
    var el = document.getElementById('face-status');
    if (el) { el.textContent = msg; el.style.color = color || '#fff'; }
}

function startFaceLogin() {
    document.getElementById('face-modal').style.display = 'flex';
    setFaceStatus('Loading face models\u2026');
    ensureFaceApi(function() {
        startCamera(function() {
            setFaceStatus('Look at the camera\u2026');
            faceDetecting = true;
            detectFaceLoop();
        });
    });
}

function startCamera(onReady) {
    if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        setFaceStatus('Camera unavailable — site must be opened over HTTPS', '#ef4444');
        return;
    }
    navigator.mediaDevices.getUserMedia({ video: { facingMode: 'user' } })
        .then(function(stream) {
            faceStream = stream;
            var video = document.getElementById('face-video');
            video.srcObject = stream;
            video.onloadedmetadata = function() { video.play(); onReady(); };
        })
        .catch(function(err) {
            setFaceStatus('Camera error: ' + err.message, '#ef4444');
        });
}

function stopCamera() {
    faceDetecting = false;
    if (faceStream) {
        faceStream.getTracks().forEach(function(t) { t.stop(); });
        faceStream = null;
    }
}

function closeFaceModal() {
    stopCamera();
    document.getElementById('face-modal').style.display = 'none';
}

var detectLoopCount = 0;
function detectFaceLoop() {
    if (!faceDetecting) return;
    var video = document.getElementById('face-video');
    faceapi.detectSingleFace(video, new faceapi.TinyFaceDetectorOptions())
        .withFaceLandmarks()
        .withFaceDescriptor()
        .then(function(detection) {
            detectLoopCount++;
            if (!detection) {
                setFaceStatus('No face detected \u2014 look at the camera');
                if (faceDetecting) setTimeout(detectFaceLoop, 600);
                return;
            }
            /* Got a descriptor — send to server for matching */
            setFaceStatus('Face detected! Verifying\u2026', '#86efac');
            faceDetecting = false;
            stopCamera();

            var descriptor = Array.from(detection.descriptor);
            document.getElementById('face-descriptor-input').value = JSON.stringify(descriptor);
            document.getElementById('face-login-form').submit();
        })
        .catch(function() {
            if (faceDetecting) setTimeout(detectFaceLoop, 600);
        });
}
</script>

</body>
</html>
