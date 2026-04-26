<cfprocessingdirective pageencoding="UTF-8">
<cfinclude template="../../application.cfm">
<cfsetting showdebugoutput="false">

<cfif NOT len(trim(SESSION.emenu_table_id))>
    <cflocation url="/latest/customer/qr_error.cfm" addtoken="false">
</cfif>
<cfif SESSION.emenu_loggedin neq "Yes">
    <cflocation url="/latest/customer/login.cfm" addtoken="false">
</cfif>
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
    </style>
</head>
<body>
<div class="card">
    <div class="icon">&#x1F9EC;</div>
    <h2>Register Your Face</h2>
    <p>
        Hi <cfoutput>#HTMLEditFormat(SESSION.emenu_name)#</cfoutput>! Your account is ready.<br><br>
        Would you like to register your face for faster logins next time?
        You can always skip this step.
    </p>

    <button class="btn btn-primary" onclick="startFaceReg()">Register Face Now</button>
    <a href="/latest/customer/menu.cfm" class="btn btn-skip">Skip for Now</a>
</div>

<!--- Face registration modal --->
<div id="face-modal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.7);
     z-index:999; align-items:center; justify-content:center; padding:24px;">
    <div style="background:#fff; border-radius:20px; padding:24px; width:100%;
                max-width:380px; text-align:center;">
        <h3 style="font-size:18px; font-weight:700; margin-bottom:6px;">Registering Face</h3>
        <p style="font-size:14px; color:#6b7280; margin-bottom:16px;">
            Look at the camera and hold still
        </p>
        <div style="position:relative; border-radius:16px; overflow:hidden;
                    background:#000; margin-bottom:16px;">
            <video id="face-video" autoplay playsinline muted
                   style="width:100%; display:block;"></video>
            <canvas id="face-canvas" style="position:absolute;top:0;left:0;
                    width:100%;height:100%;"></canvas>
            <div id="face-status" style="position:absolute;bottom:12px;left:0;right:0;
                 text-align:center;color:#fff;font-size:13px;font-weight:600;
                 text-shadow:0 1px 4px rgba(0,0,0,.6);">
                Loading models&hellip;
            </div>
        </div>
        <button onclick="closeFaceModal()" type="button"
                style="width:100%;padding:12px;background:#f3f4f6;border:none;
                       border-radius:10px;font-size:15px;cursor:pointer;">
            Cancel
        </button>
    </div>
</div>

<form id="face-save-form" action="/latest/customer/face_save.cfm" method="post" style="display:none;">
    <input type="hidden" name="descriptor" id="face-descriptor-input" value="">
</form>

<script>
var faceStream = null;
var faceDetecting = false;

function setFaceStatus(msg, color) {
    var el = document.getElementById('face-status');
    if (el) { el.textContent = msg; el.style.color = color || '#fff'; }
}

function startFaceReg() {
    document.getElementById('face-modal').style.display = 'flex';
    setFaceStatus('Loading models\u2026');
    ensureFaceApi(function() {
        startCamera(function() {
            setFaceStatus('Look at the camera\u2026');
            faceDetecting = true;
            detectFaceLoop();
        });
    });
}

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
        ]).then(callback)
          .catch(function(e) { setFaceStatus('Model load error: ' + e.message, '#ef4444'); });
    };
    document.head.appendChild(s);
}

function startCamera(onReady) {
    navigator.mediaDevices.getUserMedia({ video: { facingMode: 'user' } })
        .then(function(stream) {
            faceStream = stream;
            var v = document.getElementById('face-video');
            v.srcObject = stream;
            v.onloadedmetadata = function() { v.play(); onReady(); };
        })
        .catch(function(e) { setFaceStatus('Camera error: ' + e.message, '#ef4444'); });
}

function stopCamera() {
    faceDetecting = false;
    if (faceStream) { faceStream.getTracks().forEach(function(t){t.stop();}); faceStream=null; }
}

function closeFaceModal() {
    stopCamera();
    document.getElementById('face-modal').style.display = 'none';
}

function detectFaceLoop() {
    if (!faceDetecting) return;
    var video = document.getElementById('face-video');
    faceapi.detectSingleFace(video, new faceapi.TinyFaceDetectorOptions())
        .withFaceLandmarks().withFaceDescriptor()
        .then(function(det) {
            if (!det) {
                setFaceStatus('No face detected \u2014 look at the camera');
                if (faceDetecting) setTimeout(detectFaceLoop, 600);
                return;
            }
            setFaceStatus('Face captured! Saving\u2026', '#86efac');
            faceDetecting = false;
            stopCamera();
            document.getElementById('face-descriptor-input').value =
                JSON.stringify(Array.from(det.descriptor));
            document.getElementById('face-save-form').submit();
        })
        .catch(function() { if (faceDetecting) setTimeout(detectFaceLoop, 600); });
}
</script>
</body>
</html>
