/* ================================================================
   inc_face_capture.js — shared quality-gated face capture engine.

   Used by face_register.cfm (3-pose enrolment) and login.cfm
   (single frontal capture). Replaces the first-frame-wins logic
   that made matching unstable: a frame is only accepted when it
   passes every quality gate below, and a template is only emitted
   after N consecutive good frames are averaged together.

   Averaging cancels the per-frame noise that was pushing euclidean
   distances past the match threshold for legitimate users.
================================================================ */
var FaceCapture = (function () {

    var MODEL_URL = '/latest/customer/models';
    var CDN       = 'https://cdn.jsdelivr.net/npm/face-api.js@0.22.2/dist/face-api.min.js';

    /* Quality gates — a frame must pass ALL of these to count */
    var GATE = {
        minScore:      0.70,  /* detector confidence (lib default 0.5 is too loose) */
        minBoxRatio:   0.25,  /* face width vs frame width — too far away */
        maxBoxRatio:   0.70,  /* too close, crop clips the face */
        centerXMin:    0.28,  /* box centre must sit inside the guide oval */
        centerXMax:    0.72,
        centerYMin:    0.22,
        centerYMax:    0.80,
        minLuma:       60,    /* mean brightness of the face crop (0-255) */
        maxLuma:       205,
        maxDriftRatio: 0.05,  /* box movement vs previous frame — motion blur */
        secondFaceMax: 0.60   /* reject if another face is >60% of primary's area */
    };

    /* Yaw bands, derived from 68-landmark geometry (see estimateYaw) */
    var YAW = { centerLo: 0.42, centerHi: 0.58, rightMax: 0.38, leftMin: 0.62 };

    var lumaCanvas = null;

    /* ---------- model loading ---------- */
    function ensureReady(onReady, onError) {
        function loadNets() {
            Promise.all([
                faceapi.nets.tinyFaceDetector.loadFromUri(MODEL_URL),
                faceapi.nets.faceLandmark68Net.loadFromUri(MODEL_URL),
                faceapi.nets.faceRecognitionNet.loadFromUri(MODEL_URL)
            ]).then(function () { onReady(); })
              .catch(function (e) { onError('Model load error: ' + e.message); });
        }
        if (window.faceapi) { loadNets(); return; }
        var s = document.createElement('script');
        s.src = CDN;
        s.onload = loadNets;
        s.onerror = function () { onError('Could not load face library — check your connection'); };
        document.head.appendChild(s);
    }

    /* ---------- camera ---------- */
    function startCamera(video, onReady, onError) {
        if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
            onError('Camera unavailable — the site must be opened over HTTPS');
            return null;
        }
        navigator.mediaDevices.getUserMedia({
            video: { facingMode: 'user', width: { ideal: 640 }, height: { ideal: 480 } }
        }).then(function (stream) {
            video.srcObject = stream;
            video.onloadedmetadata = function () { video.play(); onReady(stream); };
        }).catch(function (e) { onError('Camera error: ' + e.message); });
    }

    function stopStream(stream) {
        if (stream) { stream.getTracks().forEach(function (t) { t.stop(); }); }
    }

    /* ---------- quality helpers ---------- */

    /* Mean luma of the detected face region only — a bright background
       behind a dark (backlit) face must not mask the problem. */
    function faceLuma(video, box) {
        try {
            if (!lumaCanvas) { lumaCanvas = document.createElement('canvas'); }
            var w = 32, h = 32;
            lumaCanvas.width = w; lumaCanvas.height = h;
            var ctx = lumaCanvas.getContext('2d');
            ctx.drawImage(video, box.x, box.y, box.width, box.height, 0, 0, w, h);
            var d = ctx.getImageData(0, 0, w, h).data, sum = 0;
            for (var i = 0; i < d.length; i += 4) {
                sum += 0.299 * d[i] + 0.587 * d[i + 1] + 0.114 * d[i + 2];
            }
            return sum / (d.length / 4);
        } catch (e) {
            return 128; /* canvas tainted or unreadable — don't block on it */
        }
    }

    /* Approximate yaw from the 68 landmarks: where the nose tip sits
       between the two jaw edges. 0.5 = facing straight at the camera.
       Video is NOT mirrored, so a lower ratio = turned to their own right. */
    function estimateYaw(landmarks) {
        var p = landmarks.positions;
        var leftEdge = p[0].x, rightEdge = p[16].x, nose = p[30].x;
        var span = rightEdge - leftEdge;
        if (span <= 0) { return 0.5; }
        return (nose - leftEdge) / span;
    }

    function poseOf(yaw) {
        if (yaw >= YAW.centerLo && yaw <= YAW.centerHi) { return 'center'; }
        if (yaw <= YAW.rightMax) { return 'right'; }
        if (yaw >= YAW.leftMin)  { return 'left'; }
        return 'between';
    }

    /* Returns { ok:true, det, yaw, pose } or { ok:false, reason:'...' } */
    function gradeFrame(video, dets, prevBox) {
        if (!dets || dets.length === 0) {
            return { ok: false, reason: 'No face detected — look at the camera' };
        }

        /* Largest box = closest to camera. detectSingleFace would instead pick
           the highest-confidence face, which in a lit dining room can be
           someone standing behind the customer. */
        var primary = dets[0], pArea = 0;
        dets.forEach(function (d) {
            var a = d.detection.box.width * d.detection.box.height;
            if (a > pArea) { pArea = a; primary = d; }
        });

        var crowded = dets.some(function (d) {
            if (d === primary) { return false; }
            var a = d.detection.box.width * d.detection.box.height;
            return (a / pArea) > GATE.secondFaceMax;
        });
        if (crowded) {
            return { ok: false, reason: 'More than one face in frame — please step forward alone' };
        }

        var box = primary.detection.box;
        var vw  = video.videoWidth || 640;
        var vh  = video.videoHeight || 480;

        if (primary.detection.score < GATE.minScore) {
            return { ok: false, reason: 'Hold steady — face not clear enough' };
        }

        var ratio = box.width / vw;
        if (ratio < GATE.minBoxRatio) { return { ok: false, reason: 'Move closer to the camera' }; }
        if (ratio > GATE.maxBoxRatio) { return { ok: false, reason: 'Move back a little' }; }

        var cx = (box.x + box.width / 2) / vw;
        var cy = (box.y + box.height / 2) / vh;
        if (cx < GATE.centerXMin || cx > GATE.centerXMax ||
            cy < GATE.centerYMin || cy > GATE.centerYMax) {
            return { ok: false, reason: 'Line your face up inside the oval' };
        }

        var luma = faceLuma(video, box);
        if (luma < GATE.minLuma) { return { ok: false, reason: 'Too dark — move to better light' }; }
        if (luma > GATE.maxLuma) { return { ok: false, reason: 'Too bright — avoid backlight' }; }

        if (prevBox) {
            var drift = Math.sqrt(
                Math.pow((box.x + box.width / 2) - (prevBox.x + prevBox.width / 2), 2) +
                Math.pow((box.y + box.height / 2) - (prevBox.y + prevBox.height / 2), 2)
            );
            if (drift / vw > GATE.maxDriftRatio) {
                return { ok: false, reason: 'Hold still' };
            }
        }

        var yaw = estimateYaw(primary.landmarks);
        return { ok: true, det: primary, box: box, yaw: yaw, pose: poseOf(yaw) };
    }

    /* Element-wise mean of N descriptors.

       Deliberately NOT re-normalised. face-api descriptors are raw, not unit
       vectors — measured norms on real enrolments are ~1.40-1.47 — and the
       0.5 match threshold is calibrated against that scale. Forcing them to
       unit length would shrink every new template and make it incomparable
       with descriptors already stored in arcust.face_token.

       Averaging several frames of the same face barely moves the norm while
       cancelling the per-frame noise, which is the whole point. */
    function averageDescriptors(list) {
        var n = list.length, out = new Array(128), i, k;
        for (i = 0; i < 128; i++) {
            var acc = 0;
            for (k = 0; k < n; k++) { acc += list[k][i]; }
            out[i] = acc / n;
        }
        return out;
    }

    /* ----------------------------------------------------------------
       Collect one template: keep sampling until `needed` CONSECUTIVE
       frames pass every gate (and match wantPose, if given), then
       average their descriptors into a single template.

       onProgress(done, needed, message) fires every frame so the caller
       can drive a progress ring and show why a frame was rejected.
    ---------------------------------------------------------------- */
    function collectTemplate(opts) {
        var video      = opts.video;
        var needed     = opts.frames || 5;
        var wantPose   = opts.pose || null;
        var onProgress = opts.onProgress || function () {};
        var onDone     = opts.onDone;
        var isActive   = opts.isActive || function () { return true; };

        var buf = [], prevBox = null, yawSum = 0;
        var detOpts = new faceapi.TinyFaceDetectorOptions({
            inputSize: 416, scoreThreshold: GATE.minScore
        });

        function tick() {
            if (!isActive()) { return; }
            faceapi.detectAllFaces(video, detOpts)
                .withFaceLandmarks()
                .withFaceDescriptors()
                .then(function (dets) {
                    if (!isActive()) { return; }
                    var g = gradeFrame(video, dets, prevBox);

                    if (!g.ok) {
                        buf = []; prevBox = null; yawSum = 0;   /* must be CONSECUTIVE */
                        onProgress(0, needed, g.reason);
                        setTimeout(tick, 200);
                        return;
                    }

                    if (wantPose && g.pose !== wantPose) {
                        buf = []; prevBox = g.box; yawSum = 0;
                        onProgress(0, needed, opts.poseHint || 'Adjust your head position');
                        setTimeout(tick, 200);
                        return;
                    }

                    buf.push(Array.from(g.det.descriptor));
                    yawSum += g.yaw;
                    prevBox = g.box;
                    onProgress(buf.length, needed, opts.holdHint || 'Hold still…');

                    if (buf.length >= needed) {
                        onDone({
                            descriptor: averageDescriptors(buf),
                            yaw: yawSum / buf.length
                        });
                        return;
                    }
                    setTimeout(tick, 150);
                })
                .catch(function () { if (isActive()) { setTimeout(tick, 250); } });
        }
        tick();
    }

    return {
        ensureReady:      ensureReady,
        startCamera:      startCamera,
        stopStream:       stopStream,
        collectTemplate:  collectTemplate,
        YAW:              YAW
    };
})();
