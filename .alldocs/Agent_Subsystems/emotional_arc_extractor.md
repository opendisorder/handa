# Skill: Emotional Arc Extractor

## Purpose
This skill tracks the patient's emotional state at every moment of a session and extracts an arc — start mood → middle mood → end mood — along with the specific triggers that caused each shift. Output feeds the amygdala brain file update and provides the AI with patterns like "patient is always frustrated at the 10-minute mark during naming exercises."

## Context
Run during background agent processing, consuming fused analysis JSON. The arc is appended to `amygdala.md` and stored in `last_session_summary.json`. The next session's Thilina will receive this arc as part of the memory injection.

## Prerequisites
- Fused analysis JSON from `session_fusion_analysis.md`
- Face landmark timeline with `struggle_level` (0–4) per frame
- Transcript with `speaker` and `t_ms` fields
- Python 3.10+, `pip install numpy`

## Step-by-Step Instructions

1. **Assign mood score (1–5) to each 5-second window** from face + audio + transcript signals.
2. **Smooth the arc** using a 3-window rolling average to remove jitter.
3. **Identify mood transitions** — windows where score changes by ≥ 1.5 points.
4. **Label trigger** for each transition — what event preceded the shift.
5. **Extract the arc** — start (first 60s average), middle (midpoint ±60s average), end (last 60s average).
6. **Identify recurring patterns** across sessions (requires historical arc data).
7. **Return** emotional arc JSON.

## Code Patterns

```python
import json
import numpy as np
from pathlib import Path
from datetime import datetime, timezone

SESSIONS_DIR = Path("/aura-brain/sessions")

# ─── Mood Scale ───────────────────────────────────────────────────────────────
# 1 = Distressed   (high struggle, negative words, silence)
# 2 = Frustrated   (moderate struggle, slow response, head turns)
# 3 = Neutral      (baseline, normal energy, no strong signals)
# 4 = Calm         (low struggle, steady pace, positive body language)
# 5 = Engaged      (smile, fast responses, positive words, forward lean)

NEGATIVE_WORDS = {"cannot", "can't", "difficult", "hard", "wrong", "mistake", "useless", "fail", "pain"}
POSITIVE_WORDS = {"good", "correct", "great", "yes", "thank", "nice", "excellent", "easy"}

def score_window_mood(window: dict) -> float:
    """Score a single window 1–5."""
    face_events = [e for e in window["events"] if e["source"] == "face"]
    audio_events = [e for e in window["events"] if e["source"] == "audio"]
    transcript_events = [e for e in window["events"] if e["source"] == "transcript"]
    # Face signals
    avg_struggle = np.mean([e["payload"]["struggle_level"] for e in face_events]) if face_events else 2.0
    has_smile = any(e["payload"].get("smile") for e in face_events)
    has_brow = any(e["payload"].get("brow_furrow") for e in face_events)
    # Audio signals
    avg_energy = np.mean([e["payload"]["energy"] for e in audio_events]) if audio_events else 0.5
    # Text signals
    patient_words = " ".join(
        e["payload"]["text"].lower() for e in transcript_events
        if e["payload"].get("speaker") == "patient"
    )
    neg_score = sum(1 for w in NEGATIVE_WORDS if w in patient_words)
    pos_score = sum(1 for w in POSITIVE_WORDS if w in patient_words)
    # Composite score
    base = 3.0
    base -= avg_struggle * 0.4     # 0–4 struggle → -0 to -1.6
    base -= neg_score * 0.3
    base += pos_score * 0.3
    base += 0.5 if has_smile else 0
    base -= 0.3 if has_brow else 0
    if avg_energy < 0.005:
        base -= 0.5  # near-silence = distress
    return float(np.clip(base, 1.0, 5.0))

def smooth_arc(scores: list[float], window: int = 3) -> list[float]:
    """Rolling average to remove noise."""
    if len(scores) < window:
        return scores
    smoothed = []
    for i in range(len(scores)):
        lo = max(0, i - window // 2)
        hi = min(len(scores), i + window // 2 + 1)
        smoothed.append(float(np.mean(scores[lo:hi])))
    return smoothed

def detect_transitions(windows: list[dict], scores: list[float], threshold: float = 1.5) -> list[dict]:
    """Identify mood shifts and their triggers."""
    transitions = []
    for i in range(1, len(scores)):
        delta = scores[i] - scores[i-1]
        if abs(delta) >= threshold:
            trigger = infer_trigger(windows[i])
            transitions.append({
                "t_ms": windows[i]["t_start_ms"],
                "from_mood": round(scores[i-1], 2),
                "to_mood": round(scores[i], 2),
                "direction": "up" if delta > 0 else "down",
                "trigger": trigger,
            })
    return transitions

def infer_trigger(window: dict) -> str:
    """Infer what caused a mood shift from window events."""
    fc_events = [e for e in window["events"] if e["source"] == "function_call"]
    transcript = [e for e in window["events"] if e["source"] == "transcript"]
    if fc_events:
        last_fc = fc_events[-1]["payload"]["name"]
        return f"exercise_started: {last_fc}"
    if transcript:
        last_text = transcript[-1]["payload"].get("text", "")[:60]
        return f"word_spoken: '{last_text}'"
    return "unknown"

def mood_label(score: float) -> str:
    if score < 1.5: return "distressed"
    if score < 2.5: return "frustrated"
    if score < 3.5: return "neutral"
    if score < 4.5: return "calm"
    return "engaged"

def extract_emotional_arc(fused_analysis: dict) -> dict:
    """Main entry point. Returns emotional arc JSON."""
    windows = fused_analysis.get("windows", [])
    if not windows:
        return {"error": "no_windows"}
    scores_raw = [score_window_mood(w) for w in windows]
    scores = smooth_arc(scores_raw)
    transitions = detect_transitions(windows, scores)
    # Arc segments
    n = len(scores)
    start_score  = float(np.mean(scores[:max(1, n//6)]))   # first ~1/6
    middle_score = float(np.mean(scores[n//3: 2*n//3]))     # middle 1/3
    end_score    = float(np.mean(scores[max(0, 5*n//6):])) # last ~1/6
    # Recurring pattern: find most common trigger for downward transitions
    down_triggers = [t["trigger"] for t in transitions if t["direction"] == "down"]
    most_common_trigger = max(set(down_triggers), key=down_triggers.count) if down_triggers else "none"
    return {
        "session_id": fused_analysis.get("session_id"),
        "arc": {
            "start": {"score": round(start_score, 2), "label": mood_label(start_score)},
            "middle": {"score": round(middle_score, 2), "label": mood_label(middle_score)},
            "end":   {"score": round(end_score, 2),   "label": mood_label(end_score)},
        },
        "score_timeline": [round(s, 2) for s in scores],
        "transitions": transitions,
        "most_common_trigger": most_common_trigger,
        "amygdala_notes": generate_amygdala_notes(transitions, most_common_trigger),
    }

def generate_amygdala_notes(transitions: list[dict], common_trigger: str) -> str:
    """Narrative for amygdala.md update."""
    down = [t for t in transitions if t["direction"] == "down"]
    up   = [t for t in transitions if t["direction"] == "up"]
    notes = []
    if down:
        notes.append(f"Emotional dips: {len(down)} instances. Most common trigger: {common_trigger}.")
    if up:
        notes.append(f"Recoveries: {len(up)} instances — patient showed resilience.")
    if not transitions:
        notes.append("Stable emotional arc — no significant mood shifts detected.")
    return " ".join(notes)
```

## Data Schemas

### Output: Emotional Arc JSON
```json
{
  "session_id": "session_2025-01-15_143000",
  "arc": {
    "start":  {"score": 3.2, "label": "neutral"},
    "middle": {"score": 2.1, "label": "frustrated"},
    "end":    {"score": 3.8, "label": "calm"}
  },
  "score_timeline": [3.1, 3.0, 2.8, 1.9, 2.1, 2.5, 3.4, 3.8],
  "transitions": [
    {
      "t_ms": 600000,
      "from_mood": 2.8,
      "to_mood": 1.9,
      "direction": "down",
      "trigger": "exercise_started: show_exercise_widget"
    }
  ],
  "most_common_trigger": "exercise_started: show_exercise_widget",
  "amygdala_notes": "Emotional dips: 1 instance. Most common trigger: naming exercise."
}
```

## Error Handling

| Problem | Fix |
|---|---|
| No face data → all struggle_level 0 | Scoring falls back to audio + transcript only; flag `face_quality: missing` |
| All scores identical (no signal) | Return arc with `transitions: []` and note `signal_quality: low` |
| `fused_analysis` has empty windows | Return `{"error": "no_windows"}` |

## Testing

**Test 1:** Create windows where first 3 have high struggle, middle has smile, last has positive words. Verify arc start=frustrated, middle=neutral or calm, end=engaged.

**Test 2:** Set all windows to neutral. Verify `transitions` is empty.

**Test 3:** Trigger a large mood drop. Verify `detect_transitions` catches it and `trigger` is non-null.

## References
- `session_fusion_analysis.md` — source of window data
- `brain_region_updater.md` — `amygdala_notes` is appended to `amygdala.md`
- `therapeutic_insight_extractor.md` — uses arc for causal reasoning

## Version
- Created: 2025-01-15
- Compatibility: Python 3.10+, numpy 1.24+
