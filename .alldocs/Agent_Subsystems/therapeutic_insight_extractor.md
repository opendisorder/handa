# Skill: Therapeutic Insight Extractor

## Purpose
Synthesises everything — speech metrics, emotional arc, relationship data, brain updates — into actionable clinical insights and a concrete plan for the next session. It answers the questions every therapist needs: what worked, what didn't, why, and what should Thilina do differently next time. It also flags red flags requiring caregiver or human clinician attention.

## Context
Final synthesis step of the background agent. Runs after all other background skills have completed. Output is stored in `last_session_summary.json` and partially injected into the next session memory block. The AI reads the strategic recommendations section before every session.

## Prerequisites
- Speech metrics JSON from `speech_metrics_calculator.md`
- Emotional arc JSON from `emotional_arc_extractor.md`
- Relationship graph summary from `relationship_tree_updater.md`
- Fused analysis JSON from `session_fusion_analysis.md`
- Python 3.10+

## Red Flag Triggers (ALWAYS check these)
- Any transcript text containing: suicide, kill myself, no point, hopeless, want to die
- Face struggle_level = 4 for more than 3 consecutive minutes
- Session abandoned by patient (patient turns off device or leaves)
- Patient mentions medication explicitly with negation: "not taking", "stopped", "don't want"
- Physical complaint mentioned ≥ 3 times: "pain", "headache", "chest", "dizzy"

## Step-by-Step Instructions

1. **Check for red flags** first — if any found, generate alert immediately.
2. **Classify what worked** — high-accuracy exercise types, successful cue strategies, topics that engaged.
3. **Classify what didn't** — words that failed consistently, topics that triggered distress, pace mismatches.
4. **Apply causal reasoning** — link failures to brain state and relationship triggers.
5. **Generate strategic recommendations** for the next session AI prompt.
6. **Produce natural language summary** for caregiver notification.
7. **Return** full insights JSON.

## Code Patterns

```python
import json
from pathlib import Path
from datetime import datetime, timezone

RED_FLAG_WORDS = {
    "suicidal": ["suicide", "kill myself", "want to die", "end my life", "no reason to live"],
    "depression": ["hopeless", "no point", "useless", "burden", "can't go on"],
    "medication": ["not taking", "stopped medication", "don't want medicine", "threw away"],
    "physical": ["chest pain", "can't breathe", "dizzy", "headache", "arm hurts"],
}

def check_red_flags(transcript_turns: list[dict]) -> list[dict]:
    """Scan all patient turns for red flag phrases."""
    flags = []
    patient_text = " ".join(
        t.get("text", "").lower() for t in transcript_turns
        if t.get("speaker") == "patient"
    )
    for category, phrases in RED_FLAG_WORDS.items():
        for phrase in phrases:
            if phrase in patient_text:
                flags.append({
                    "category": category,
                    "phrase": phrase,
                    "severity": "HIGH" if category in ["suicidal", "physical"] else "MEDIUM",
                    "action_required": "Notify caregiver immediately" if category == "suicidal"
                                      else "Review at next clinician check-in",
                })
    return flags

def classify_what_worked(metrics: dict, arc: dict) -> dict:
    """Identify which conditions produced the best outcomes."""
    worked = {
        "exercise_types": [],
        "cue_strategies": [],
        "engagement_topics": [],
        "timing": [],
    }
    # Exercise success
    per_word = metrics.get("per_word", {})
    mastered = [w for w, d in per_word.items() if d["mastery"] == "mastered"]
    if mastered:
        worked["exercise_types"].append(f"Naming exercises: mastered {', '.join(mastered)}")
    # Cue strategy success
    global_m = metrics.get("global", {})
    mean_cue = global_m.get("mean_cue_level", 2)
    if mean_cue < 1.0:
        worked["cue_strategies"].append("Patient responding to phonemic cues (level 1) — minimal cueing needed")
    elif mean_cue < 0.5:
        worked["cue_strategies"].append("Spontaneous recall improving — reduce cueing further")
    # Timing: when was the patient most calm?
    transitions = arc.get("transitions", [])
    up_transitions = [t for t in transitions if t["direction"] == "up"]
    if up_transitions:
        best_t = min(up_transitions, key=lambda t: t["t_ms"])
        worked["timing"].append(f"Patient mood improved after t={best_t['t_ms']}ms — likely due to {best_t['trigger']}")
    return worked

def classify_what_didnt(metrics: dict, arc: dict) -> dict:
    """Identify failure patterns."""
    didnt = {
        "struggling_words": [],
        "frustration_triggers": [],
        "pace_issues": [],
    }
    per_word = metrics.get("per_word", {})
    struggling = [w for w, d in per_word.items() if d["mastery"] == "struggling"]
    if struggling:
        didnt["struggling_words"] = struggling
    # Frustration triggers from arc
    down_transitions = [t for t in arc.get("transitions", []) if t["direction"] == "down"]
    triggers = list(set(t["trigger"] for t in down_transitions))
    if triggers:
        didnt["frustration_triggers"] = triggers
    # Pace: if onset latency > 3 seconds consistently
    latency = metrics.get("global", {}).get("mean_onset_latency_ms", 0)
    if latency > 3000:
        didnt["pace_issues"].append(f"High onset latency ({latency:.0f}ms) — patient is processing slowly, reduce pace")
    return didnt

def apply_causal_reasoning(
    didnt: dict,
    arc: dict,
    relationships: dict
) -> list[str]:
    """Link failures to brain region states and relationship triggers."""
    causal = []
    # Struggling words → check if they are emotionally loaded
    for word in didnt.get("struggling_words", []):
        word_lower = word.lower()
        # Check if any relationship has negative valence and word matches theme
        neg_relationships = [
            n for n in relationships.get("nodes", [])
            if n.get("valence", 0) < -0.2 and n["id"].lower() in word_lower
        ]
        if neg_relationships:
            name = neg_relationships[0]["id"]
            causal.append(
                f"'{word}' may trigger amygdala response — associated with '{name}' "
                f"(negative valence {neg_relationships[0]['valence']:.2f}). "
                f"Broca's area shutdown pattern matches amygdala hijack."
            )
        else:
            causal.append(
                f"'{word}' failed — likely phoneme complexity or difficulty mismatch. "
                f"Recommend isolation drill for phonemes in this word."
            )
    # High frustration during naming exercises
    if any("show_exercise_widget" in t for t in didnt.get("frustration_triggers", [])):
        causal.append(
            "Frustration peaks during naming exercises → consider using semantic hints "
            "before phonemic cues. Show_semantic_hint_widget before show_exercise_widget."
        )
    return causal

def generate_recommendations(
    worked: dict,
    didnt: dict,
    causal: list[str],
    metrics: dict,
) -> list[str]:
    """Concrete instructions for the next session's Thilina prompt."""
    recs = []
    diff_rec = metrics.get("difficulty_recommendation", {})
    if diff_rec.get("action") == "level_up":
        recs.append(f"DIFFICULTY: Increase to level {diff_rec['new_difficulty']} — {diff_rec['reason']}")
    elif diff_rec.get("action") == "level_down":
        recs.append(f"DIFFICULTY: Reduce to level {diff_rec['new_difficulty']} — {diff_rec['reason']}")
    struggling = didnt.get("struggling_words", [])
    if struggling:
        recs.append(f"FOCUS WORDS: Start session with low-pressure warm-up before attempting: {', '.join(struggling[:3])}")
    phonemes = metrics.get("phonemes_needing_drill", [])
    if phonemes:
        recs.append(f"PHONEME DRILLS: Isolate and drill these phonemes first: {', '.join(phonemes)}")
    for c in causal[:2]:
        recs.append(f"CAUSAL: {c}")
    if worked.get("timing"):
        recs.append(f"TIMING: {worked['timing'][0]}")
    return recs

def generate_caregiver_summary(
    metrics: dict,
    arc: dict,
    red_flags: list[dict],
    session_id: str
) -> str:
    """Natural language summary for caregiver notification."""
    acc = metrics.get("global", {}).get("accuracy_percent", 0)
    start_mood = arc.get("arc", {}).get("start", {}).get("label", "unknown")
    end_mood   = arc.get("arc", {}).get("end",   {}).get("label", "unknown")
    mastered   = metrics.get("mastery", {}).get("mastered", [])
    lines = [
        f"Session {session_id} completed.",
        f"Overall accuracy: {acc}%. Started {start_mood}, ended {end_mood}.",
    ]
    if mastered:
        lines.append(f"New words mastered: {', '.join(mastered)}.")
    if red_flags:
        flag_cats = list(set(f["category"] for f in red_flags))
        lines.append(f"⚠️ ATTENTION NEEDED: Concerns detected — {', '.join(flag_cats)}. Please review.")
    return " ".join(lines)

def extract_therapeutic_insights(
    fused_analysis: dict,
    metrics: dict,
    arc: dict,
    graph: dict,
    session_id: str = ""
) -> dict:
    """Main entry point."""
    # Flatten transcript
    transcript_turns = []
    for w in fused_analysis.get("windows", []):
        transcript_turns += [e["payload"] for e in w.get("events", []) if e.get("source") == "transcript"]
    red_flags = check_red_flags(transcript_turns)
    worked  = classify_what_worked(metrics, arc)
    didnt   = classify_what_didnt(metrics, arc)
    causal  = apply_causal_reasoning(didnt, arc, graph)
    recs    = generate_recommendations(worked, didnt, causal, metrics)
    summary = generate_caregiver_summary(metrics, arc, red_flags, session_id)
    result = {
        "session_id": session_id,
        "red_flags": red_flags,
        "what_worked": worked,
        "what_didnt": didnt,
        "causal_reasoning": causal,
        "strategic_recommendations": recs,
        "caregiver_summary": summary,
        "next_session_prompt_addendum": "\n".join(recs[:5]),
    }
    # Save to sessions dir
    sessions_dir = Path("/aura-brain/sessions")
    sessions_dir.mkdir(parents=True, exist_ok=True)
    out_path = sessions_dir / f"{session_id}_insights.json"
    out_path.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    return result
```

## Data Schemas

### Output: Insights JSON
```json
{
  "session_id": "session_2025-01-15_143000",
  "red_flags": [],
  "what_worked": {
    "exercise_types": ["Naming exercises: mastered ගල, රළ"],
    "cue_strategies": ["Phonemic cues effective — patient responding well"],
    "timing": ["Mood improved after 20 minutes once breathing widget used"]
  },
  "what_didnt": {
    "struggling_words": ["carrot", "hospital"],
    "frustration_triggers": ["exercise_started: show_exercise_widget"],
    "pace_issues": []
  },
  "causal_reasoning": [
    "'hospital' may trigger amygdala — associated with his stroke event. Broca shutdown pattern matches amygdala hijack."
  ],
  "strategic_recommendations": [
    "FOCUS WORDS: Start with warm-up before attempting: carrot, hospital",
    "CAUSAL: Use semantic hint before phonemic cue for emotionally loaded words"
  ],
  "caregiver_summary": "Session completed. Accuracy 72%. Ended calmer than started. New words mastered: ගල."
}
```

## Error Handling

| Problem | Fix |
|---|---|
| Red flag detected | Always include in output AND log to `/aura-brain/alerts/` directory |
| All inputs empty | Return `{"error": "insufficient_data"}` |
| Session insights file already exists | Overwrite — latest analysis is always preferred |

## Testing

**Test 1:** Include "I want to die" in patient transcript. Verify `red_flags` contains item with `category: "suicidal"`.

**Test 2:** Set accuracy to 90% and mean_cue to 0.3. Verify `difficulty_recommendation.action == "level_up"` appears in recommendations.

**Test 3:** Include word "hospital" in struggling_words and graph node "hospital event" with negative valence. Verify causal reasoning mentions amygdala.

## References
- All other background agent skills — this is the final synthesis step
- `background_agent_orchestrator.md` — shows how this skill's output flows to the caregiver

## Version
- Created: 2025-01-15
- Compatibility: Python 3.10+
