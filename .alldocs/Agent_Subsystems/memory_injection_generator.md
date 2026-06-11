# Skill: Memory Injection Generator

## Purpose
This skill compresses the entire digital brain — 10 brain-region files + relationship graph + last session summary — into a 200–300 word memory block that is injected into Thilina's system prompt at the start of every session. The goal: give the AI everything it needs to personalise therapy without exceeding context limits.

## Context
Final step of the background agent pipeline, run after all brain files and the relationship graph are updated. Produces a string that is directly concatenated into the Gemini Live system prompt before `client.aio.live.connect()` is called. If the memory block exceeds 350 words, apply the cut priority rules below.

## Prerequisites
- All 10 brain region files populated at `/aura-brain/regions/`
- `relationship_graph.json` at `/aura-brain/relationships/`
- `last_session_summary.json` at `/aura-brain/sessions/`
- Python 3.10+

## Step-by-Step Instructions

1. **Load all 10 brain files** — extract the most recent 2 observation blocks from each.
2. **Load relationship graph** — get top 5 nodes by importance, with valence labels.
3. **Load last session summary** — get session date, total duration, top successes, top struggles.
4. **Compress** each section using the rules below.
5. **Assemble** into the fixed-format injection string.
6. **Count words** — if > 350, apply the cut priority list.
7. **Return** the injection string.

## Code Patterns

```python
import json
import re
from pathlib import Path
from datetime import datetime

BRAIN_DIR = Path("/aura-brain/regions")
GRAPH_PATH = Path("/aura-brain/relationships/relationship_graph.json")
SESSIONS_DIR = Path("/aura-brain/sessions")
REGIONS = [
    "prefrontal_cortex", "hippocampus", "amygdala", "broca_area",
    "wernicke_area", "motor_cortex", "temporal_lobe", "cerebellum",
    "brainstem", "corpus_callosum"
]

REGION_LABELS = {
    "prefrontal_cortex": "Goal setting & self-control",
    "hippocampus":       "Memory & learning",
    "amygdala":          "Emotional responses",
    "broca_area":        "Speech production",
    "wernicke_area":     "Language comprehension",
    "motor_cortex":      "Mouth motor control",
    "temporal_lobe":     "Auditory processing",
    "cerebellum":        "Timing & coordination",
    "brainstem":         "Fatigue & endurance",
    "corpus_callosum":   "Cross-modal processing",
}

def extract_recent_observations(region_path: Path, max_obs: int = 2) -> list[str]:
    """Extract the last N timestamped observation blocks."""
    content = region_path.read_text(encoding="utf-8")
    blocks = re.findall(r"### \[.*?\].*?\n(.*?)(?=###|\Z)", content, re.DOTALL)
    recent = [b.strip() for b in blocks[-max_obs:] if b.strip()]
    return recent

def get_weight(region_path: Path) -> float:
    content = region_path.read_text(encoding="utf-8")
    m = re.search(r"importance:\s*([\d.]+)", content)
    return float(m.group(1)) if m else 1.0

def summarise_region(region: str) -> str | None:
    path = BRAIN_DIR / f"{region}.md"
    if not path.exists():
        return None
    obs = extract_recent_observations(path)
    if not obs:
        return None
    label = REGION_LABELS[region]
    summary = "; ".join(obs[:1])[:120]  # max 120 chars per region
    return f"[{label}] {summary}"

def summarise_relationships(max_nodes: int = 5) -> str:
    if not GRAPH_PATH.exists():
        return ""
    graph = json.loads(GRAPH_PATH.read_text(encoding="utf-8"))
    nodes = sorted(
        [n for n in graph.get("nodes", []) if n["id"] != "PATIENT"],
        key=lambda n: -n["importance"]
    )[:max_nodes]
    lines = []
    for n in nodes:
        valence = "positive" if n["valence"] > 0.2 else ("negative" if n["valence"] < -0.2 else "neutral")
        lines.append(f"{n['id']} ({n['role']}, {valence})")
    return "Key relationships: " + ", ".join(lines) if lines else ""

def summarise_last_session() -> str:
    sessions = sorted(SESSIONS_DIR.glob("*.json")) if SESSIONS_DIR.exists() else []
    if not sessions:
        return "No previous session data."
    last = json.loads(sessions[-1].read_text(encoding="utf-8"))
    date = last.get("date", "recent")
    successes = last.get("top_successes", [])
    struggles = last.get("top_struggles", [])
    lines = [f"Last session ({date}):"]
    if successes:
        lines.append(f"Succeeded: {', '.join(successes[:3])}")
    if struggles:
        lines.append(f"Struggled: {', '.join(struggles[:3])}")
    return " ".join(lines)

CUT_PRIORITY = [
    "corpus_callosum", "temporal_lobe", "cerebellum",
    "motor_cortex", "wernicke_area", "hippocampus",
    "prefrontal_cortex", "brainstem", "amygdala", "broca_area"
]  # cut corpus_callosum first, broca_area last

def generate_memory_injection(patient_name: str = "Patient") -> str:
    """Main entry point. Returns the memory injection string."""
    sections = []
    # Section 1: Brain status
    region_lines = []
    for region in REGIONS:
        summary = summarise_region(region)
        if summary:
            region_lines.append(summary)
    if region_lines:
        sections.append("## Brain Status\n" + "\n".join(region_lines))
    # Section 2: Relationships
    rel_summary = summarise_relationships()
    if rel_summary:
        sections.append("## Relationships\n" + rel_summary)
    # Section 3: Last session
    session_summary = summarise_last_session()
    sections.append("## Recent History\n" + session_summary)
    # Combine
    full = "\n\n".join(sections)
    # Trim if too long
    words = full.split()
    if len(words) > 350:
        # Remove low-priority regions one by one
        for region in CUT_PRIORITY:
            label = REGION_LABELS[region]
            pattern = rf"\[{re.escape(label)}\][^\n]*\n?"
            full = re.sub(pattern, "", full)
            if len(full.split()) <= 320:
                break
    return f"### PATIENT MEMORY ({patient_name})\n{full.strip()}\n### END MEMORY"

def count_words(text: str) -> int:
    return len(text.split())
```

## Data Schemas

### Memory Injection Output (example)
```
### PATIENT MEMORY (Mr. Perera)
## Brain Status
[Speech production] Patient struggled at t=45000ms. Face showed high tension.
[Emotional responses] CONFLICT at t=90000ms: face frustrated, transcript positive.
[Fatigue & endurance] Fatigue markers appeared after 40 minutes.
[Memory & learning] Patient remembered word "carrot" from last session.

## Relationships
Key relationships: Kamala (wife, positive), Nuwan (son, positive), Dr. Fernando (physiotherapist, neutral)

## Recent History
Last session (2025-01-14): Succeeded: ලකාර, රළ, ගල. Struggled: carrot, money, hospital.
### END MEMORY
```

### Cut Priority (highest to lowest importance, never cut last):
1. corpus_callosum
2. temporal_lobe
3. cerebellum
4. motor_cortex
5. wernicke_area
6. hippocampus
7. prefrontal_cortex
8. brainstem
9. **amygdala** (emotional — keep)
10. **broca_area** (speech — always keep)

## Error Handling

| Problem | Fix |
|---|---|
| Brain files don't exist yet | Return generic starter memory block |
| Output > 350 words after all cuts | Hard-truncate at 350 words; add `[TRUNCATED]` tag |
| Relationship graph missing | Skip relationships section |
| Sessions directory empty | Return "First session — no prior history." |

## Testing

**Test 1:** Populate 3 brain files with 2 observations each. Call `generate_memory_injection()`. Verify output contains `### PATIENT MEMORY` header and `### END MEMORY` footer.

**Test 2:** Add 30 region observations to force > 350 words. Call `generate_memory_injection()`. Verify output ≤ 350 words and `broca_area` section is still present.

**Test 3:** Empty all files. Verify function returns starter memory, not a crash.

## References
- `brain_region_updater.md` — writes the files this skill reads
- `relationship_tree_updater.md` — writes the graph this skill summarises
- `vertex_ai_live_api_setup.md` — shows where to inject the output (system_instruction)

## Version
- Created: 2025-01-15
- Compatibility: Python 3.10+
