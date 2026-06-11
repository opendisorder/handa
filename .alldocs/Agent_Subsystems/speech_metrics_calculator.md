# Skill: Speech Metrics Calculator

## Purpose
Calculates all quantitative speech therapy metrics from session exercise logs. These numbers tell the therapist (and the AI) exactly how the patient performed: word accuracy, phoneme difficulty, cue dependency, and what the difficulty level should be next session. Every metric has an exact formula.

## Context
Run during background agent processing. Input is the `function_calls.json` exercise log. Output is stored in `last_session_summary.json` and used by `therapeutic_insight_extractor.md` for recommendations. Also feeds the `broca_area.md` and `cerebellum.md` updates in `brain_region_updater.md`.

## Prerequisites
- `function_calls.json` with `log_exercise` entries (see schema below)
- Python 3.10+, stdlib only

## Cue Level Scale
| Level | Meaning |
|---|---|
| 0 | Spontaneous — no cue needed |
| 1 | Phonemic cue — first sound provided |
| 2 | Partial word — first syllable provided |
| 3 | Full repetition — complete word modelled |
| 4 | Failed — patient could not produce even with full cue |

## Difficulty Level Scale
| Level | Meaning |
|---|---|
| 1 | Simple — 2-syllable common nouns |
| 2 | Moderate — 3-syllable or less-frequent words |
| 3 | Hard — polysyllabic, abstract, or emotionally loaded |

## Step-by-Step Instructions

1. **Filter** function calls for `log_exercise` entries only.
2. **Group** by exercise type (naming, repetition, reading, conversation).
3. **Calculate global metrics** using all exercise entries.
4. **Calculate per-word metrics** for each unique target word.
5. **Calculate phoneme metrics** by decomposing words into phonemes.
6. **Determine mastery classification** for each word.
7. **Generate difficulty recommendations** for next session.
8. **Return** metrics JSON.

## Code Patterns

```python
import json
from pathlib import Path
from collections import defaultdict
from dataclasses import dataclass, asdict
from typing import Optional
import re

@dataclass
class ExerciseEntry:
    t_ms: int
    word: str
    exercise_type: str      # "naming" | "repetition" | "reading" | "conversation"
    difficulty: int         # 1-3
    correct: bool
    cue_level: int          # 0-4
    onset_latency_ms: int   # time from prompt to first sound
    self_corrected: bool
    phonemes: list[str]     # IPA or romanised phoneme list

def parse_exercise_log(function_calls_path: str) -> list[ExerciseEntry]:
    """Parse function_calls.json and extract log_exercise entries."""
    data = json.loads(Path(function_calls_path).read_text(encoding="utf-8"))
    entries = []
    for call in data.get("calls", []):
        if call["name"] != "log_exercise":
            continue
        args = call.get("args", {})
        entries.append(ExerciseEntry(
            t_ms=call["t_ms"],
            word=args.get("word", ""),
            exercise_type=args.get("exercise_type", "naming"),
            difficulty=int(args.get("difficulty", 1)),
            correct=bool(args.get("correct", False)),
            cue_level=int(args.get("cue_level", 0)),
            onset_latency_ms=int(args.get("onset_latency_ms", 0)),
            self_corrected=bool(args.get("self_corrected", False)),
            phonemes=args.get("phonemes", []),
        ))
    return entries

# ─── Global Metrics ───────────────────────────────────────────────────────────

def accuracy_percent(entries: list[ExerciseEntry]) -> float:
    """Percentage of attempts that were correct (with or without cue)."""
    if not entries:
        return 0.0
    return round(sum(1 for e in entries if e.correct) / len(entries) * 100, 1)

def mean_cue_level(entries: list[ExerciseEntry]) -> float:
    """Average cue level needed (0=best, 4=worst)."""
    if not entries:
        return 0.0
    return round(sum(e.cue_level for e in entries) / len(entries), 2)

def mean_onset_latency_ms(entries: list[ExerciseEntry]) -> float:
    """Average time from prompt to patient's first sound, in ms."""
    valid = [e.onset_latency_ms for e in entries if e.onset_latency_ms > 0]
    return round(sum(valid) / len(valid), 0) if valid else 0.0

def self_correction_count(entries: list[ExerciseEntry]) -> int:
    return sum(1 for e in entries if e.self_corrected)

def words_per_minute(entries: list[ExerciseEntry], session_duration_ms: int) -> float:
    """Total words produced / session minutes."""
    if session_duration_ms <= 0:
        return 0.0
    total_words = sum(len(e.word.split()) for e in entries if e.correct)
    minutes = session_duration_ms / 60000
    return round(total_words / minutes, 1)

# ─── Per-Word Metrics ─────────────────────────────────────────────────────────

def per_word_metrics(entries: list[ExerciseEntry]) -> dict:
    """Calculate accuracy, cue level, and mastery for each word."""
    word_data = defaultdict(list)
    for e in entries:
        word_data[e.word].append(e)
    result = {}
    for word, word_entries in word_data.items():
        attempts = len(word_entries)
        correct  = sum(1 for e in word_entries if e.correct)
        avg_cue  = sum(e.cue_level for e in word_entries) / attempts
        result[word] = {
            "attempts": attempts,
            "correct":  correct,
            "accuracy": round(correct / attempts * 100, 1),
            "avg_cue_level": round(avg_cue, 2),
            "difficulty": word_entries[-1].difficulty,
            "mastery": classify_mastery(word_entries),
        }
    return result

def classify_mastery(entries: list[ExerciseEntry]) -> str:
    """
    mastered:   3+ correct with cue_level 0 in last 3 attempts
    learning:   mixed results
    struggling: needs cue ≥ 2 every time, or failed
    """
    last3 = entries[-3:]
    if len(last3) >= 3 and all(e.correct and e.cue_level == 0 for e in last3):
        return "mastered"
    if all(e.cue_level >= 2 for e in last3):
        return "struggling"
    return "learning"

# ─── Phoneme Metrics ─────────────────────────────────────────────────────────

def phoneme_accuracy(entries: list[ExerciseEntry]) -> dict:
    """Accuracy rate per phoneme across all exercises."""
    phoneme_stats = defaultdict(lambda: {"correct": 0, "total": 0})
    for e in entries:
        for ph in e.phonemes:
            phoneme_stats[ph]["total"] += 1
            if e.correct:
                phoneme_stats[ph]["correct"] += 1
    return {
        ph: {
            "accuracy": round(s["correct"] / s["total"] * 100, 1),
            "needs_drill": s["correct"] / s["total"] < 0.6,
        }
        for ph, s in phoneme_stats.items() if s["total"] > 0
    }

# ─── Difficulty Recommendations ───────────────────────────────────────────────

def recommend_difficulty(
    global_accuracy: float,
    mean_cue: float,
    current_difficulty: int
) -> dict:
    """
    Level up:   accuracy > 85% AND mean_cue < 0.5 for 2+ sessions
    Level down: accuracy < 50% OR mean_cue > 2.5
    Hold:       everything else
    """
    if global_accuracy > 85.0 and mean_cue < 0.5:
        return {"action": "level_up",   "new_difficulty": min(3, current_difficulty + 1),
                "reason": f"Accuracy {global_accuracy}% with minimal cuing"}
    if global_accuracy < 50.0 or mean_cue > 2.5:
        return {"action": "level_down", "new_difficulty": max(1, current_difficulty - 1),
                "reason": f"Accuracy {global_accuracy}% or high cue dependency ({mean_cue:.1f})"}
    return {"action": "hold", "new_difficulty": current_difficulty,
            "reason": f"Accuracy {global_accuracy}% — within target range"}

# ─── Main ─────────────────────────────────────────────────────────────────────

def calculate_speech_metrics(
    function_calls_path: str,
    session_duration_ms: int
) -> dict:
    """Main entry point."""
    entries = parse_exercise_log(function_calls_path)
    if not entries:
        return {"error": "no_exercise_data"}
    global_acc  = accuracy_percent(entries)
    avg_cue     = mean_cue_level(entries)
    avg_latency = mean_onset_latency_ms(entries)
    wpm         = words_per_minute(entries, session_duration_ms)
    corrections = self_correction_count(entries)
    per_word    = per_word_metrics(entries)
    phonemes    = phoneme_accuracy(entries)
    current_diff = entries[-1].difficulty if entries else 1
    difficulty_rec = recommend_difficulty(global_acc, avg_cue, current_diff)
    mastered   = [w for w, d in per_word.items() if d["mastery"] == "mastered"]
    learning   = [w for w, d in per_word.items() if d["mastery"] == "learning"]
    struggling = [w for w, d in per_word.items() if d["mastery"] == "struggling"]
    drill_phonemes = [ph for ph, d in phonemes.items() if d.get("needs_drill")]
    return {
        "global": {
            "accuracy_percent":       global_acc,
            "mean_cue_level":         avg_cue,
            "mean_onset_latency_ms":  avg_latency,
            "words_per_minute":       wpm,
            "self_correction_count":  corrections,
            "total_attempts":         len(entries),
        },
        "per_word": per_word,
        "phoneme_accuracy": phonemes,
        "mastery": {
            "mastered":   mastered,
            "learning":   learning,
            "struggling": struggling,
        },
        "phonemes_needing_drill": drill_phonemes,
        "difficulty_recommendation": difficulty_rec,
    }
```

## Data Schemas

### Input: `function_calls.json` (log_exercise entries)
```json
{
  "calls": [
    {
      "t_ms": 45000,
      "name": "log_exercise",
      "args": {
        "word": "ලකාර",
        "exercise_type": "naming",
        "difficulty": 2,
        "correct": true,
        "cue_level": 1,
        "onset_latency_ms": 2300,
        "self_corrected": false,
        "phonemes": ["l", "a", "k", "aa", "r", "a"]
      }
    }
  ]
}
```

### Output: Metrics JSON
```json
{
  "global": {
    "accuracy_percent": 72.5,
    "mean_cue_level": 1.3,
    "mean_onset_latency_ms": 2100,
    "words_per_minute": 14.2,
    "self_correction_count": 3,
    "total_attempts": 40
  },
  "mastery": {
    "mastered":   ["ගල", "රළ"],
    "learning":   ["ලකාර", "කඩේ"],
    "struggling": ["carrot", "hospital"]
  },
  "phonemes_needing_drill": ["r", "l"],
  "difficulty_recommendation": {
    "action": "hold",
    "new_difficulty": 2,
    "reason": "Accuracy 72.5% — within target range"
  }
}
```

## Error Handling

| Problem | Fix |
|---|---|
| No `log_exercise` entries | Return `{"error": "no_exercise_data"}` — session may have been exploratory |
| Missing `onset_latency_ms` field | Default to 0; exclude from mean calculation |
| Single attempt per word | Mastery classification returns "learning" (not enough data) |
| `session_duration_ms` is 0 | WPM returned as 0.0 |

## Testing

**Test 1:** 10 entries, 8 correct, all `cue_level: 0`. Expect `accuracy_percent: 80.0`, `mean_cue_level: 0.0`, `difficulty_recommendation.action: hold` or `level_up`.

**Test 2:** 3 entries for word "carrot", all `cue_level: 4`. Expect `mastery["struggling"]: ["carrot"]`.

**Test 3:** Empty function_calls.json. Expect `{"error": "no_exercise_data"}`.

## References
- `session_fusion_analysis.md` — provides session context
- `therapeutic_insight_extractor.md` — uses metrics for strategy recommendations
- `brain_region_updater.md` — `broca_area` and `cerebellum` updated from these results

## Version
- Created: 2025-01-15
- Compatibility: Python 3.10+
