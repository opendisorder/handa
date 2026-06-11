# Skill: Brain Region Updater

## Purpose
After each therapy session, this skill appends new insights derived from the fused session analysis into the correct brain-region markdown file. It maintains a permanent, timestamped knowledge base of the patient's neurological state spread across ten specialised files. The golden rule: **never overwrite, always append, flag contradictions**.

## Context
This skill runs as the second step of the background agent pipeline, after `session_fusion_analysis.md` has produced its fused JSON. It reads that JSON, classifies insights by brain region, appends them with ISO timestamps, adjusts relationship importance weights (±0.05 per session max), and saves. It does NOT summarise across sessions — that is done by `memory_injection_generator.md`.

## Prerequisites
- Python 3.10+
- Brain files already initialised at `/aura-brain/regions/` (see Data Schemas below)
- Fused analysis JSON from `session_fusion_analysis.md`
- `pip install python-frontmatter`

## The 10 Brain Region Files

| File | What it tracks |
|---|---|
| `prefrontal_cortex.md` | Executive function, goal-setting, self-regulation, task initiation |
| `hippocampus.md` | Long-term memory access, new learning, word-context associations |
| `amygdala.md` | Emotional triggers, fear/frustration responses, emotional hijacks |
| `broca_area.md` | Speech production, word retrieval latency, articulation errors |
| `wernicke_area.md` | Language comprehension, instruction-following, word recognition |
| `motor_cortex.md` | Mouth motor control, lip/tongue coordination, articulation effort |
| `temporal_lobe.md` | Auditory processing, voice feedback processing, rhythm/prosody |
| `cerebellum.md` | Motor sequencing, timing of speech, coordination between sounds |
| `brainstem.md` | Fatigue indicators, autonomic stress signals, session endurance |
| `corpus_callosum.md` | Inter-hemisphere coordination, cross-modal processing |

## Step-by-Step Instructions

1. **Load fused analysis** — read the JSON produced by `session_fusion_analysis.md`.
2. **Extract per-region insights** — use the `classify_insight_to_region()` function to map each event/pattern to one or more brain regions.
3. **For each brain region file:**
   a. Read current content.
   b. Check for contradictions with new insights.
   c. Append new insight block with timestamp.
   d. Update the `weight` field if applicable.
   e. Write back.
4. **Merge similar insights** — if a new insight is semantically identical to one within the last 3 sessions, increment its `frequency` counter instead of adding a duplicate.
5. **Flag contradictions** — if new insight contradicts existing one, append both with `[CONTRADICTION]` tag and a reasoning note.

## Code Patterns

```python
import json
import re
from pathlib import Path
from datetime import datetime, timezone

BRAIN_DIR = Path("/aura-brain/regions")
REGIONS = [
    "prefrontal_cortex", "hippocampus", "amygdala", "broca_area",
    "wernicke_area", "motor_cortex", "temporal_lobe", "cerebellum",
    "brainstem", "corpus_callosum"
]

# --- Insight Classification ---

REGION_KEYWORDS = {
    "broca_area":        ["word retrieval", "latency", "articulation", "pause before", "onset", "cue needed", "phoneme error"],
    "wernicke_area":     ["comprehension", "did not understand", "instruction ignored", "repeated back incorrectly"],
    "amygdala":          ["frustrated", "anxious", "shutdown", "emotional hijack", "avoidance", "CONFLICT", "distressed"],
    "hippocampus":       ["remembered", "forgot", "last session", "repeated word", "memory", "association"],
    "prefrontal_cortex": ["self-corrected", "initiated", "goal", "gave up", "persisted", "task switching"],
    "motor_cortex":      ["lip movement", "jaw tension", "motor", "mouth", "oral motor", "coordination"],
    "temporal_lobe":     ["auditory", "heard correctly", "volume", "rhythm", "prosody", "tone"],
    "cerebellum":        ["timing", "sequencing", "coordination", "onset latency", "speed"],
    "brainstem":         ["fatigue", "tired", "drowsy", "slow response", "yawning", "endurance"],
    "corpus_callosum":   ["cross-modal", "visual-audio", "read then speak", "gesture", "bilateral"],
}

def classify_insight_to_region(insight_text: str) -> list[str]:
    """Returns list of region names this insight belongs to."""
    text = insight_text.lower()
    matched = []
    for region, keywords in REGION_KEYWORDS.items():
        if any(kw in text for kw in keywords):
            matched.append(region)
    return matched if matched else ["prefrontal_cortex"]  # default fallback

# --- File Template Initialiser ---

def init_brain_file(region: str) -> str:
    """Creates initial content for a brain region file if it doesn't exist."""
    return f"""# {region.replace('_', ' ').title()}

## Summary
> Auto-updated by background agent. Do not manually edit the data blocks.

## Observations
<!-- Timestamped insights appended below -->

## Patterns
<!-- Recurring patterns identified across sessions -->

## Contradictions
<!-- Conflicting observations flagged here -->

## Weight
importance: 1.0
sessions_observed: 0
last_updated: never
"""

def ensure_brain_files():
    """Initialise any missing brain files."""
    BRAIN_DIR.mkdir(parents=True, exist_ok=True)
    for region in REGIONS:
        path = BRAIN_DIR / f"{region}.md"
        if not path.exists():
            path.write_text(init_brain_file(region))

# --- Insight Appender ---

def append_insight(region: str, insight: str, session_id: str, importance: float = 0.5):
    """Append a new insight to the correct brain file."""
    path = BRAIN_DIR / f"{region}.md"
    if not path.exists():
        path.write_text(init_brain_file(region))
    content = path.read_text(encoding="utf-8")
    ts = datetime.now(timezone.utc).isoformat()
    block = f"\n### [{ts}] session={session_id} importance={importance:.2f}\n{insight}\n"
    # Insert after ## Observations header
    content = content.replace("<!-- Timestamped insights appended below -->",
                               f"<!-- Timestamped insights appended below -->{block}")
    path.write_text(content, encoding="utf-8")

def flag_contradiction(region: str, old_insight: str, new_insight: str, session_id: str):
    """Append both insights with [CONTRADICTION] tag."""
    path = BRAIN_DIR / f"{region}.md"
    content = path.read_text(encoding="utf-8")
    ts = datetime.now(timezone.utc).isoformat()
    block = f"""
### [CONTRADICTION][{ts}] session={session_id}
**Previous observation:** {old_insight}
**New observation (conflicts):** {new_insight}
**Status:** Unresolved — requires review
"""
    content = content.replace("<!-- Conflicting observations flagged here -->",
                               f"<!-- Conflicting observations flagged here -->{block}")
    path.write_text(content, encoding="utf-8")

def adjust_weight(region: str, delta: float):
    """Adjust importance weight ±0.05 max per session."""
    delta = max(-0.05, min(0.05, delta))
    path = BRAIN_DIR / f"{region}.md"
    content = path.read_text(encoding="utf-8")
    match = re.search(r"importance:\s*([\d.]+)", content)
    if match:
        current = float(match.group(1))
        new_weight = round(min(2.0, max(0.1, current + delta)), 3)
        content = content.replace(f"importance: {match.group(1)}", f"importance: {new_weight}")
        # Increment session counter
        content = re.sub(r"sessions_observed:\s*(\d+)",
                         lambda m: f"sessions_observed: {int(m.group(1))+1}", content)
        content = re.sub(r"last_updated:\s*\S+",
                         f"last_updated: {datetime.now(timezone.utc).date().isoformat()}", content)
        path.write_text(content, encoding="utf-8")

# --- Main Orchestrator ---

def update_brain_regions(fused_analysis: dict) -> dict:
    """
    Main entry point. Takes fused analysis JSON, extracts insights,
    and updates all relevant brain region files.
    Returns a summary of what was updated.
    """
    ensure_brain_files()
    session_id = fused_analysis.get("session_id", "unknown")
    updates = {r: [] for r in REGIONS}
    # 1. Process struggle windows → likely broca + amygdala
    for w in fused_analysis.get("windows", []):
        cls = w.get("classification")
        t_ms = w.get("t_start_ms", 0)
        if cls == "STRUGGLE":
            insight = f"Patient struggled at t={t_ms}ms. Face showed high tension. Audio energy low."
            for region in ["broca_area", "amygdala", "brainstem"]:
                append_insight(region, insight, session_id, importance=0.8)
                adjust_weight(region, +0.03)
                updates[region].append(insight)
        elif cls == "SUCCESS":
            insight = f"Patient succeeded at t={t_ms}ms. Positive face signals. Clear speech."
            for region in ["broca_area", "prefrontal_cortex"]:
                append_insight(region, insight, session_id, importance=0.6)
                adjust_weight(region, -0.02)  # normalise importance as patient improves
                updates[region].append(insight)
        elif cls == "CONFLICT":
            insight = f"CONFLICT at t={t_ms}ms: face frustrated, transcript positive. Possible masking."
            for region in ["amygdala", "prefrontal_cortex", "corpus_callosum"]:
                append_insight(region, insight, session_id, importance=0.9)
                updates[region].append(insight)
    # 2. Process function calls for exercise-specific insights
    for fc in fused_analysis.get("summary", {}).get("struggle_timestamps_ms", []):
        note = f"Struggle cluster at {fc}ms — likely complex phoneme or emotional trigger."
        append_insight("broca_area", note, session_id, importance=0.75)
    return {"session_id": session_id, "updates": {k: len(v) for k, v in updates.items()}}
```

## Data Schemas

### Brain Region File Structure (before/after example)

**Before:**
```markdown
# Broca Area

## Summary
> Auto-updated by background agent.

## Observations
<!-- Timestamped insights appended below -->

## Weight
importance: 1.0
sessions_observed: 0
```

**After session update:**
```markdown
# Broca Area

## Summary
> Auto-updated by background agent.

## Observations
<!-- Timestamped insights appended below -->

### [2025-01-15T14:32:00+00:00] session=session_2025-01-15 importance=0.80
Patient struggled at t=45000ms. Face showed high tension. Audio energy low.

### [2025-01-15T14:32:01+00:00] session=session_2025-01-15 importance=0.60
Patient succeeded at t=120000ms. Positive face signals. Clear speech.

## Weight
importance: 1.03
sessions_observed: 1
last_updated: 2025-01-15
```

### Update Return Schema
```json
{
  "session_id": "session_2025-01-15_143000",
  "updates": {
    "prefrontal_cortex": 2,
    "hippocampus": 0,
    "amygdala": 5,
    "broca_area": 8,
    "wernicke_area": 1,
    "motor_cortex": 3,
    "temporal_lobe": 0,
    "cerebellum": 2,
    "brainstem": 4,
    "corpus_callosum": 1
  }
}
```

## Error Handling

| Problem | Fix |
|---|---|
| Brain directory doesn't exist | Call `ensure_brain_files()` — it creates the directory and all 10 files |
| File encoding error | Always use `encoding="utf-8"` on all reads/writes |
| Weight goes below 0 or above 2 | Clamped in `adjust_weight()` — safe |
| Fused analysis is empty | Check `total_windows > 0` before calling; log and skip if 0 |
| Regex doesn't find `importance:` | Brain file was manually edited — re-initialise the file from template |

## Testing

**Test 1 — File initialisation:** Delete all brain files, call `ensure_brain_files()`. Expect all 10 `.md` files created with correct headers.

**Test 2 — Append insight:** Call `append_insight("broca_area", "Test insight", "test_001")`. Open `broca_area.md` and verify the timestamped block appears under `## Observations`.

**Test 3 — Weight adjustment:** Set `importance: 1.0`. Call `adjust_weight("broca_area", +0.05)`. Verify new importance is `1.05`.

**Test 4 — Full pipeline:** Run `update_brain_regions(sample_fused_json)`. Verify at least `broca_area` and `amygdala` were updated.

## References
- `session_fusion_analysis.md` — produces the input JSON
- `memory_injection_generator.md` — reads these files to generate session prompts
- `relationship_tree_updater.md` — updates the parallel relationship graph

## Version
- Created: 2025-01-15
- Compatibility: Python 3.10+, no external libraries beyond stdlib
