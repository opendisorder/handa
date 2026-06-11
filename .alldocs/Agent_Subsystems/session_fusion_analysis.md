# Skill: Session Fusion Analysis

## Purpose
This skill fuses raw multimodal session data — audio, video frames, MediaPipe face landmarks, and conversation transcript — into a single unified JSON analysis object. Its job is temporal alignment: events from the audio channel at 00:45 should be matched to the video frame captured at 00:45 and the face landmark data from the same moment, then cross-validated so the background agent can reason about *why* the patient struggled or succeeded at a specific moment, not just *that* they did.

## Context
Use this skill immediately after a therapy session ends and raw data has been saved to disk. It is the first step in the background analysis pipeline. Output from this skill feeds directly into `brain_region_updater.md`, `emotional_arc_extractor.md`, and `speech_metrics_calculator.md`. Do not run this before all recording files are finalised and closed.

## Prerequisites
- Python 3.10+
- `pip install google-genai numpy scipy pillow`
- Audio blob saved as `.wav` (16kHz, 16-bit, mono)
- 15–30 JPEG frames extracted from session video (see `session_recording_storage.md`)
- Face landmark timeline saved as `face_landmarks.json`
- Transcript saved as `transcript.json` (from Gemini Live transcript events)
- Function call log saved as `function_calls.json`
- All files share a common `session_id` prefix

## Step-by-Step Instructions

1. **Validate inputs** — check all five files exist and are non-empty before proceeding.
2. **Load all data** — parse JSON files into Python dicts; load audio with `scipy.io.wavfile`; load frames as PIL images.
3. **Build the master timeline** — create a list of time-stamped events from every source. Every event must carry `t_ms` (milliseconds from session start), `source` (audio/video/face/transcript/function_call), and `payload`.
4. **Align timestamps** — normalise all timestamps to the same epoch (session start = 0). Transcript events already have `t_ms` from Gemini; face landmarks use the video frame index × frame_interval_ms; audio events are derived from energy analysis.
5. **Create 5-second windows** — group events into overlapping 5-second windows. Within each window, collect: face struggle level, audio energy/pitch, transcript words, active exercise.
6. **Detect signal agreement vs. conflict** within each window using the rules in the Data Schemas section.
7. **Annotate key moments** — tag windows as SUCCESS, STRUGGLE, NEUTRAL, or CONFLICT.
8. **Produce the fused output JSON** — see schema below.
9. **Handle errors** gracefully — see Error Handling section.

## Code Patterns

```python
import json
import numpy as np
from pathlib import Path
from scipy.io import wavfile
from PIL import Image
from dataclasses import dataclass, asdict
from typing import Optional

@dataclass
class Event:
    t_ms: int
    source: str  # "audio" | "video" | "face" | "transcript" | "function_call"
    payload: dict

def load_session_data(session_dir: str) -> dict:
    """Load all five session artefacts into memory."""
    base = Path(session_dir)
    with open(base / "transcript.json") as f:
        transcript = json.load(f)
    with open(base / "face_landmarks.json") as f:
        face_data = json.load(f)
    with open(base / "function_calls.json") as f:
        function_calls = json.load(f)
    sample_rate, audio = wavfile.read(base / "audio.wav")
    frames = sorted(base.glob("frame_*.jpg"))
    return {
        "transcript": transcript,
        "face_data": face_data,
        "function_calls": function_calls,
        "audio": audio,
        "sample_rate": sample_rate,
        "frames": frames,
    }

def build_master_timeline(data: dict, frame_interval_ms: int = 3000) -> list[Event]:
    events = []
    # Transcript events
    for turn in data["transcript"].get("turns", []):
        events.append(Event(
            t_ms=turn["t_ms"],
            source="transcript",
            payload={"speaker": turn["speaker"], "text": turn["text"]}
        ))
    # Face landmark events (one per frame)
    for i, frame_record in enumerate(data["face_data"].get("frames", [])):
        events.append(Event(
            t_ms=frame_record.get("t_ms", i * frame_interval_ms),
            source="face",
            payload={
                "struggle_level": frame_record.get("struggle_level", 0),
                "brow_furrow": frame_record.get("brow_furrow", False),
                "smile": frame_record.get("smile", False),
                "jaw_tension": frame_record.get("jaw_tension", False),
            }
        ))
    # Function call events
    for fc in data["function_calls"].get("calls", []):
        events.append(Event(
            t_ms=fc["t_ms"],
            source="function_call",
            payload={"name": fc["name"], "args": fc.get("args", {})}
        ))
    # Audio energy events (sample every 5 seconds)
    audio = data["audio"]
    sr = data["sample_rate"]
    chunk_size = sr * 5  # 5-second chunks
    for i in range(0, len(audio), chunk_size):
        chunk = audio[i:i+chunk_size].astype(np.float32)
        energy = float(np.sqrt(np.mean(chunk**2)))
        events.append(Event(
            t_ms=(i * 1000) // sr,
            source="audio",
            payload={"energy": energy}
        ))
    events.sort(key=lambda e: e.t_ms)
    return events

def create_windows(events: list[Event], window_ms: int = 5000, step_ms: int = 2500) -> list[dict]:
    if not events:
        return []
    max_t = max(e.t_ms for e in events)
    windows = []
    t = 0
    while t < max_t:
        window_events = [e for e in events if t <= e.t_ms < t + window_ms]
        if window_events:
            windows.append({"t_start_ms": t, "t_end_ms": t + window_ms, "events": [asdict(e) for e in window_events]})
        t += step_ms
    return windows

def classify_window(window: dict) -> str:
    """
    Agreement rules:
    - STRUGGLE: face_struggle_level >= 3 AND (low audio energy OR negative transcript words)
    - SUCCESS: face smile AND positive transcript words AND AI logged correct response
    - CONFLICT: face says frustrated (brow_furrow) BUT transcript is positive — investigate
    - NEUTRAL: everything else
    """
    face_events = [e for e in window["events"] if e["source"] == "face"]
    audio_events = [e for e in window["events"] if e["source"] == "audio"]
    transcript_events = [e for e in window["events"] if e["source"] == "transcript"]
    NEGATIVE_WORDS = {"cannot", "can't", "difficult", "hard", "wrong", "mistake", "useless", "fail"}
    POSITIVE_WORDS = {"good", "correct", "great", "yes", "thank", "nice", "excellent"}
    avg_struggle = np.mean([e["payload"]["struggle_level"] for e in face_events]) if face_events else 0
    avg_energy = np.mean([e["payload"]["energy"] for e in audio_events]) if audio_events else 0
    patient_text = " ".join(
        e["payload"]["text"].lower() for e in transcript_events
        if e["payload"].get("speaker") == "patient"
    )
    has_negative = any(w in patient_text for w in NEGATIVE_WORDS)
    has_positive = any(w in patient_text for w in POSITIVE_WORDS)
    has_brow_furrow = any(e["payload"].get("brow_furrow") for e in face_events)
    if avg_struggle >= 3 and (avg_energy < 0.01 or has_negative):
        return "STRUGGLE"
    if any(e["payload"].get("smile") for e in face_events) and has_positive:
        return "SUCCESS"
    if has_brow_furrow and has_positive:
        return "CONFLICT"
    return "NEUTRAL"

def fuse_session(session_dir: str) -> dict:
    """Main entry point. Returns the unified fused analysis JSON."""
    data = load_session_data(session_dir)
    timeline = build_master_timeline(data)
    windows = create_windows(timeline)
    annotated = []
    for w in windows:
        w["classification"] = classify_window(w)
        annotated.append(w)
    struggle_windows = [w for w in annotated if w["classification"] == "STRUGGLE"]
    conflict_windows = [w for w in annotated if w["classification"] == "CONFLICT"]
    success_windows  = [w for w in annotated if w["classification"] == "SUCCESS"]
    session_duration_ms = max((e.t_ms for e in timeline), default=0)
    return {
        "session_id": Path(session_dir).name,
        "duration_ms": session_duration_ms,
        "total_windows": len(annotated),
        "windows": annotated,
        "summary": {
            "struggle_count": len(struggle_windows),
            "success_count": len(success_windows),
            "conflict_count": len(conflict_windows),
            "struggle_timestamps_ms": [w["t_start_ms"] for w in struggle_windows],
            "success_timestamps_ms": [w["t_start_ms"] for w in success_windows],
            "conflict_windows": conflict_windows,
        },
        "raw_event_count": len(timeline),
    }
```

## Data Schemas

### Input: `transcript.json`
```json
{
  "turns": [
    {"t_ms": 5200, "speaker": "therapist", "text": "ලකාර කියන්න"},
    {"t_ms": 8100, "speaker": "patient",   "text": "ල... ලකාර"}
  ]
}
```

### Input: `face_landmarks.json`
```json
{
  "frames": [
    {
      "t_ms": 0,
      "struggle_level": 1,
      "brow_furrow": false,
      "smile": false,
      "jaw_tension": false,
      "landmarks_468": [[x, y, z], ...]
    }
  ]
}
```

### Input: `function_calls.json`
```json
{
  "calls": [
    {"t_ms": 12000, "name": "show_exercise_widget", "args": {"word": "ලකාර", "difficulty": 2}},
    {"t_ms": 45000, "name": "log_exercise", "args": {"word": "ලකාර", "correct": true, "cue_level": 1}}
  ]
}
```

### Output: Fused Analysis JSON
```json
{
  "session_id": "session_2025-01-15_143000_patient001",
  "duration_ms": 720000,
  "total_windows": 288,
  "summary": {
    "struggle_count": 12,
    "success_count": 34,
    "conflict_count": 3,
    "struggle_timestamps_ms": [45000, 90000],
    "conflict_windows": [...]
  },
  "windows": [
    {
      "t_start_ms": 0,
      "t_end_ms": 5000,
      "classification": "NEUTRAL",
      "events": [...]
    }
  ]
}
```

## Error Handling

| Problem | Cause | Fix |
|---|---|---|
| `FileNotFoundError` | Session files not saved yet | Check `session_recording_storage.md` — confirm upload completed |
| Audio is all zeros / silent | Microphone not captured | Flag session as AUDIO_CORRUPTED; proceed with face+transcript only; set `audio_quality: "missing"` in output |
| Video frames folder empty | Camera denied or recording failed | Proceed without video; set `video_quality: "missing"`; all windows get `classification: "NO_VIDEO"` |
| `face_landmarks.json` has no detections | Face not in frame / dark room | Set all `struggle_level: null`; log `face_quality: "not_detected"` |
| JSON parse error | File corruption | Try UTF-8 re-read; if fails, mark file as CORRUPT and log to `session_errors.log` |
| Session under 60 seconds | Patient stopped early | Still produce output; set `session_status: "incomplete"` |

```python
def safe_fuse_session(session_dir: str) -> dict:
    """Fault-tolerant wrapper for fuse_session."""
    try:
        return fuse_session(session_dir)
    except FileNotFoundError as e:
        return {"error": "missing_files", "detail": str(e), "session_id": session_dir}
    except Exception as e:
        return {"error": "fusion_failed", "detail": str(e), "session_id": session_dir}
```

## Testing

**Test case 1 — Happy path**
Create a `test_session/` folder with all five files populated. Call `fuse_session("test_session")`. Expect output JSON with `total_windows > 0` and `summary.struggle_count >= 0`.

**Test case 2 — Missing audio**
Remove `audio.wav`. Call `safe_fuse_session`. Expect `{"error": "missing_files", ...}` — no crash.

**Test case 3 — All struggle**
Populate `face_landmarks.json` with all frames having `struggle_level: 4` and `brow_furrow: true`. Populate transcript with patient saying "I can't". Expect `summary.struggle_count > 0`.

**Test case 4 — Conflict detection**
Set face to `brow_furrow: true` but transcript patient text to "yes, good". Expect at least one window with `classification: "CONFLICT"`.

## References
- `emotional_arc_extractor.md` — uses this output for mood analysis
- `brain_region_updater.md` — consumes the fused JSON to update brain files
- `session_recording_storage.md` — describes how the input files are created
- Vertex AI Gemini Live transcript format: https://cloud.google.com/vertex-ai/generative-ai/docs/live

## Version
- Created: 2025-01-15
- Compatibility: Python 3.10+, google-genai 1.x, scipy 1.11+
