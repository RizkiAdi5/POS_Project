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
        /* Detector cutoff. Kept at the library default on purpose: raising it
           here makes detectAllFaces return NOTHING for a turned head, because
           tinyFaceDetector is frontal-biased and its confidence falls off with
           yaw. Confidence is judged below instead, where it can be logged and
           varied per pose. */
        detectScore:    0.50,
        minScore:       0.70, /* required confidence facing the camera */
        minScoreTurned: 0.55, /* turned poses legitimately score lower */
        minBoxRatio:    0.22, /* face width vs frame width — too far away */
        maxBoxRatio:    0.75, /* too close, crop clips the face */
        centerXMin:     0.20, /* a turned head shifts the box sideways */
        centerXMax:     0.80,
        centerYMin:     0.18,
        centerYMax:     0.85,
        minLuma:        55,   /* mean brightness of the face crop (0-255) */
        maxLuma:        210,
        maxDriftRatio:  0.07, /* box movement vs previous frame — motion blur */
        secondFaceMax:  0.60  /* reject if another face is >60% of primary's area */
    };

    /* Yaw bands from 68-landmark geometry (see estimateYaw).

       The nose-between-jaw-edges ratio is a compressed measure — a natural
       20-30 degree turn only moves it to roughly 0.40 / 0.60, nowhere near
       the 0.38 / 0.62 this used to demand. Asking for more turn than that
       also pushes the face past the point where the landmark model can
       align it. Bands are set to what a comfortable turn actually produces;
       left and right stay far enough apart to keep the liveness check
       meaningful (guaranteed spread >= 0.16). */
    var YAW = { centerLo: 0.44, centerHi: 0.56, rightMax: 0.42, leftMin: 0.58 };

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

    /* Returns { ok, reason, det, box, yaw, pose, m } where m carries every
       measured value so a caller can report exactly which gate is blocking
       rather than guessing at thresholds. */
    function gradeFrame(video, dets, prevBox, minScore) {
        if (!dets || dets.length === 0) {
            return { ok: false, reason: 'No face detected — look at the camera', m: null };
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
        var box = primary.detection.box;
        var vw  = video.videoWidth || 640;
        var vh  = video.videoHeight || 480;

        var ratio = box.width / vw;
        var cx    = (box.x + box.width / 2) / vw;
        var cy    = (box.y + box.height / 2) / vh;
        var luma  = faceLuma(video, box);
        var yaw   = estimateYaw(primary.landmarks);
        var need  = minScore || GATE.minScore;

        /* Every metric is collected before any verdict, so diagnostics show
           the full picture even when an early gate fails. */
        var m = {
            score: primary.detection.score, needScore: need,
            ratio: ratio, cx: cx, cy: cy, luma: luma, yaw: yaw,
            pose: poseOf(yaw), faces: dets.length, drift: null
        };

        if (prevBox) {
            m.drift = Math.sqrt(
                Math.pow((box.x + box.width / 2) - (prevBox.x + prevBox.width / 2), 2) +
                Math.pow((box.y + box.height / 2) - (prevBox.y + prevBox.height / 2), 2)
            ) / vw;
        }

        if (crowded) {
            return { ok: false, m: m,
                     reason: 'More than one face in frame — please step forward alone' };
        }
        if (m.score < need) {
            return { ok: false, m: m, reason: 'Hold steady — face not clear enough' };
        }
        if (ratio < GATE.minBoxRatio) { return { ok: false, m: m, reason: 'Move closer to the camera' }; }
        if (ratio > GATE.maxBoxRatio) { return { ok: false, m: m, reason: 'Move back a little' }; }
        if (cx < GATE.centerXMin || cx > GATE.centerXMax ||
            cy < GATE.centerYMin || cy > GATE.centerYMax) {
            return { ok: false, m: m, reason: 'Line your face up inside the oval' };
        }
        if (luma < GATE.minLuma) { return { ok: false, m: m, reason: 'Too dark — move to better light' }; }
        if (luma > GATE.maxLuma) { return { ok: false, m: m, reason: 'Too bright — avoid backlight' }; }

        if (m.drift !== null && m.drift > GATE.maxDriftRatio) {
            return { ok: false, m: m, reason: 'Hold still' };
        }

        return { ok: true, m: m, det: primary, box: box, yaw: yaw, pose: m.pose };
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

        var onDiag = opts.onDiag || function () {};
        /* A turned head scores lower on a frontal-biased detector, so the
           confidence bar is relaxed for the left/right poses. */
        var minScore = (wantPose && wantPose !== 'center')
                     ? GATE.minScoreTurned : GATE.minScore;

        var buf = [], prevBox = null, yawSum = 0;
        var detOpts = new faceapi.TinyFaceDetectorOptions({
            inputSize: 416, scoreThreshold: GATE.detectScore
        });

        function tick() {
            if (!isActive()) { return; }
            faceapi.detectAllFaces(video, detOpts)
                .withFaceLandmarks()
                .withFaceDescriptors()
                .then(function (dets) {
                    if (!isActive()) { return; }
                    var g = gradeFrame(video, dets, prevBox, minScore);

                    if (!g.ok) {
                        buf = []; prevBox = null; yawSum = 0;   /* must be CONSECUTIVE */
                        onDiag(g, wantPose, buf.length);
                        onProgress(0, needed, g.reason);
                        setTimeout(tick, 200);
                        return;
                    }

                    if (wantPose && g.pose !== wantPose) {
                        buf = []; prevBox = g.box; yawSum = 0;
                        onDiag({ ok: false, m: g.m,
                                 reason: 'wrong pose (' + g.pose + ')' }, wantPose, 0);
                        onProgress(0, needed, opts.poseHint || 'Adjust your head position');
                        setTimeout(tick, 200);
                        return;
                    }

                    onDiag(g, wantPose, buf.length + 1);

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

    /* Euclidean distance between two raw 128-float descriptors. Same scale
       the server matcher uses — descriptors are not unit-normalised. */
    function distance(a, b) {
        var s = 0;
        for (var i = 0; i < 128; i++) {
            var d = a[i] - b[i];
            s += d * d;
        }
        return Math.sqrt(s);
    }

    return {
        ensureReady:      ensureReady,
        startCamera:      startCamera,
        stopStream:       stopStream,
        collectTemplate:  collectTemplate,
        distance:         distance,
        YAW:              YAW
    };
})();
