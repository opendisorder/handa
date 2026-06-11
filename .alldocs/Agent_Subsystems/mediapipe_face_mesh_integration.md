# Skill: MediaPipe Face Mesh Integration

## Purpose
Integrates Google MediaPipe Face Mesh on the patient's Android device to continuously detect facial cues — brow furrow, jaw tension, smile, eye widening — and compute a real-time struggle level (0–4). All processing stays on device. No face data is sent to the cloud. The struggle level feeds into the session recording for post-session analysis by the background agent.

## Context
This runs on the Flutter Android app (or Web if PWA). Runs independently of the Vertex AI session — it is a parallel data stream. The face data is written to local storage and timestamped, then included in the background analysis. It does NOT feed live data to Gemini during the session (for latency and privacy reasons).

## Prerequisites
- Flutter 3.10+ OR JavaScript (Web) — both paths covered below
- **Flutter path:** `camera` and `google_ml_kit` packages (MediaPipe via ML Kit)
- **JavaScript path:** `@mediapipe/face_mesh` CDN or npm package
- Device with front-facing camera
- Patient consent obtained (face processed entirely on-device)

## Step-by-Step Instructions

1. **Request camera permission** at app launch — deny gracefully if refused.
2. **Initialise Face Mesh** with correct config (maxNumFaces=1 for single patient).
3. **Run calibration flow** during onboarding — capture neutral, smile, brow raise, jaw open.
4. **Start real-time detection loop** — sample at 10fps (not 30fps — battery optimisation).
5. **Map landmarks to struggle signals** using calibrated baselines.
6. **Compute struggle level** (0–4) from composite signals.
7. **Buffer and save** to `face_landmarks.json` every 3 seconds (not every frame).
8. **Stop on session end** and close camera stream.

## Code Patterns

### JavaScript (Web / React Native Web)

```html
<!-- Include MediaPipe CDN -->
<script src="https://cdn.jsdelivr.net/npm/@mediapipe/face_mesh/face_mesh.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@mediapipe/camera_utils/camera_utils.js"></script>
```

```javascript
// face_mesh_controller.js
import { FaceMesh } from "@mediapipe/face_mesh";
import { Camera } from "@mediapipe/camera_utils";

// ─── Landmark Indices (MediaPipe 468-point model) ─────────────────────────────
const LANDMARKS = {
  leftBrow:        [70, 63, 105, 66, 107],  // left eyebrow
  rightBrow:       [336, 296, 334, 293, 300],
  leftEye:         [33, 160, 158, 133, 153, 144],
  rightEye:        [362, 385, 387, 263, 373, 380],
  upperLip:        [61, 185, 40, 39, 37, 0],
  lowerLip:        [146, 91, 181, 84, 17, 314],
  jaw:             [152, 377, 400, 378, 379],
  noseTip:         [4],
};

// ─── Calibration State ────────────────────────────────────────────────────────
let calibration = {
  neutral_brow_distance: null,
  neutral_jaw_distance: null,
  smile_lip_distance: null,
  calibrated: false,
};

function getLandmarkPoint(landmarks, index) {
  return { x: landmarks[index].x, y: landmarks[index].y, z: landmarks[index].z };
}

function euclidean(a, b) {
  return Math.sqrt((a.x-b.x)**2 + (a.y-b.y)**2);
}

function measureBrowHeight(landmarks) {
  const brow = getLandmarkPoint(landmarks, LANDMARKS.leftBrow[2]);  // brow peak
  const eye  = getLandmarkPoint(landmarks, LANDMARKS.leftEye[0]);   // eye corner
  return euclidean(brow, eye);
}

function measureJawOpen(landmarks) {
  const upper = getLandmarkPoint(landmarks, LANDMARKS.upperLip[3]);
  const lower = getLandmarkPoint(landmarks, LANDMARKS.lowerLip[1]);
  return euclidean(upper, lower);
}

function measureSmile(landmarks) {
  const leftCorner  = getLandmarkPoint(landmarks, 61);
  const rightCorner = getLandmarkPoint(landmarks, 291);
  const noseTip     = getLandmarkPoint(landmarks, 4);
  return euclidean(leftCorner, rightCorner) / euclidean(noseTip, getLandmarkPoint(landmarks, 152));
}

// ─── Struggle Level Computation ───────────────────────────────────────────────
function computeStruggleLevel(landmarks) {
  if (!calibration.calibrated) return 0;
  const browH   = measureBrowHeight(landmarks);
  const jawOpen = measureJawOpen(landmarks);
  const smile   = measureSmile(landmarks);
  let score = 0;
  // Brow furrow: if brow height < 80% of neutral baseline → furrowed
  const browRatio = browH / calibration.neutral_brow_distance;
  if (browRatio < 0.80) score += 1.5;
  else if (browRatio < 0.90) score += 0.5;
  // Jaw tension: jaw less open than neutral → clenching
  const jawRatio = jawOpen / calibration.neutral_jaw_distance;
  if (jawRatio < 0.7) score += 1.0;
  // Smile: if smile active → reduce score
  const smileRatio = smile / calibration.smile_lip_distance;
  if (smileRatio > 1.1) score -= 1.5;
  return Math.max(0, Math.min(4, Math.round(score)));
}

// ─── Main Controller ──────────────────────────────────────────────────────────
let faceDataBuffer = [];
let sessionStartTime = Date.now();

export function initFaceMesh(videoElement) {
  const faceMesh = new FaceMesh({
    locateFile: (file) => `https://cdn.jsdelivr.net/npm/@mediapipe/face_mesh/${file}`,
  });
  faceMesh.setOptions({
    maxNumFaces: 1,
    refineLandmarks: true,
    minDetectionConfidence: 0.5,
    minTrackingConfidence: 0.5,
  });
  faceMesh.onResults(onResults);
  const camera = new Camera(videoElement, {
    onFrame: async () => {
      await faceMesh.send({ image: videoElement });
    },
    width: 640,
    height: 480,
    facingMode: "user",
  });
  camera.start();
  return { faceMesh, camera };
}

function onResults(results) {
  if (!results.multiFaceLandmarks || results.multiFaceLandmarks.length === 0) return;
  const landmarks = results.multiFaceLandmarks[0];
  const t_ms = Date.now() - sessionStartTime;
  const struggleLevel = computeStruggleLevel(landmarks);
  const browFurrow  = measureBrowHeight(landmarks) / calibration.neutral_brow_distance < 0.85;
  const smile       = measureSmile(landmarks) / calibration.smile_lip_distance > 1.1;
  const jawTension  = measureJawOpen(landmarks) / calibration.neutral_jaw_distance < 0.7;
  // Buffer at 10fps but only save every 3 seconds
  faceDataBuffer.push({ t_ms, struggle_level: struggleLevel, brow_furrow: browFurrow, smile, jaw_tension: jawTension });
  // Flush buffer every 3 seconds
  if (faceDataBuffer.length >= 30) {
    saveFaceBuffer([...faceDataBuffer]);
    faceDataBuffer = [];
  }
}

function saveFaceBuffer(frames) {
  // Save to IndexedDB or post to local session storage
  const existingJson = localStorage.getItem("aura_face_data") || '{"frames":[]}';
  const existing = JSON.parse(existingJson);
  existing.frames.push(...frames);
  localStorage.setItem("aura_face_data", JSON.stringify(existing));
}

// ─── Calibration Flow ─────────────────────────────────────────────────────────
export async function runCalibration(faceMesh, videoElement) {
  console.log("Calibration: Show neutral face for 3 seconds...");
  await captureCalibrationFrame(faceMesh, videoElement, "neutral");
  console.log("Calibration: Now smile! Hold for 2 seconds...");
  await captureCalibrationFrame(faceMesh, videoElement, "smile");
  console.log("Calibration complete.");
  calibration.calibrated = true;
}

async function captureCalibrationFrame(faceMesh, videoElement, pose) {
  return new Promise((resolve) => {
    faceMesh.onResults((results) => {
      if (!results.multiFaceLandmarks?.length) { resolve(); return; }
      const lm = results.multiFaceLandmarks[0];
      if (pose === "neutral") {
        calibration.neutral_brow_distance = measureBrowHeight(lm);
        calibration.neutral_jaw_distance  = measureJawOpen(lm);
      } else if (pose === "smile") {
        calibration.smile_lip_distance = measureSmile(lm);
      }
      resolve();
    });
    setTimeout(resolve, 3000); // timeout safety
  });
}

export function exportFaceData() {
  return JSON.parse(localStorage.getItem("aura_face_data") || '{"frames":[]}');
}
```

## Data Schemas

### Face Landmarks JSON (saved every 3s)
```json
{
  "frames": [
    {
      "t_ms": 0,
      "struggle_level": 1,
      "brow_furrow": false,
      "smile": false,
      "jaw_tension": false
    },
    {
      "t_ms": 3000,
      "struggle_level": 3,
      "brow_furrow": true,
      "smile": false,
      "jaw_tension": true
    }
  ]
}
```

## Error Handling

| Problem | Fix |
|---|---|
| Camera permission denied | Show manual instructions; proceed without face data; mark `face_quality: "permission_denied"` |
| Face not detected (dark room) | Log `face_quality: "not_detected"`; struggle defaults to 0 |
| `@mediapipe/face_mesh` fails to load | Check CDN connectivity; use local package as fallback |
| Calibration not completed | Skip calibration-based scoring; use static thresholds |
| High battery drain | Reduce detection to 5fps on low-battery devices |

## Testing

**Test 1:** Point camera at a photo of a furrowed face. Verify `struggle_level >= 2`.

**Test 2:** Run calibration then show a smile. Verify `smile: true`.

**Test 3:** Deny camera permission. Verify app continues without crashing and face data is empty.

## References
- MediaPipe Face Mesh docs: https://developers.google.com/mediapipe/solutions/vision/face_landmarker
- `session_fusion_analysis.md` — reads the `face_landmarks.json` this skill writes
- `session_recording_storage.md` — how to export face data at session end

## Version
- Created: 2025-01-15
- MediaPipe: @mediapipe/face_mesh 0.4.x
- Compatibility: Chrome 90+, Android WebView, Flutter WebView
