# Skill: Relationship Tree Updater

## Purpose
This skill maintains the patient's social and emotional relationship map across two layers: per-person markdown files (rich narrative) and a graph JSON (queryable structure). After every session, it adds new interaction evidence, adjusts emotional weights, creates new relationship nodes when new people are mentioned, and maintains a living picture of who matters to the patient, what they trigger, and how the AI should approach each relationship in therapy.

## Context
Run after `brain_region_updater.md` as part of the background agent pipeline. Triggered whenever the session transcript contains names, relationship references, or emotional reactions tied to a person. Output feeds `memory_injection_generator.md` (for session summaries) and is queried live by the AI via `graph_memory_search` function calls during sessions.

## Prerequisites
- Python 3.10+
- `pip install networkx`
- Folder structure: `/aura-brain/relationships/{category}/{person}.md`
- Graph file: `/aura-brain/relationships/relationship_graph.json`
- Fused analysis JSON from `session_fusion_analysis.md`

## Folder Structure

```
/aura-brain/relationships/
├── relationship_graph.json       ← queryable graph
├── family/
│   ├── wife_kamala.md
│   ├── son_nuwan.md
│   └── daughter_ishara.md
├── friends/
│   └── childhood_friend_ranjith.md
├── caregivers/
│   └── physio_dr_fernando.md
└── community/
    └── neighbour_uncle_silva.md
```

## Step-by-Step Instructions

1. **Scan transcript** for named entities and relationship references using `extract_relationship_mentions()`.
2. **For each mentioned person:**
   a. Look up their file; create if first mention.
   b. Append the new interaction evidence with timestamp.
   c. Update emotional weight based on patient's emotional state during the mention.
3. **Update the graph JSON:**
   a. Add new nodes for new people.
   b. Add/update edges with new weight.
   c. Update cluster assignments.
4. **Save graph atomically** — write to `.tmp`, verify, rename.

## Code Patterns

```python
import json
import re
import shutil
import networkx as nx
from pathlib import Path
from datetime import datetime, timezone
from typing import Optional

RELATIONSHIPS_DIR = Path("/aura-brain/relationships")
GRAPH_PATH = RELATIONSHIPS_DIR / "relationship_graph.json"
CATEGORIES = ["family", "friends", "caregivers", "community"]

# ─── Relationship File Template ───────────────────────────────────────────────

RELATIONSHIP_TEMPLATE = """# Relationship: {name}

## Identity
- **Name:** {name}
- **Category:** {category}
- **Role:** {role}
- **First mentioned:** {first_seen}
- **Emotional valence:** neutral  <!-- positive | negative | ambivalent | neutral -->

## Emotional Weight
importance: 0.5
valence: 0.0   <!-- -1.0 (fear/hatred) to +1.0 (love/trust) -->
sessions_referenced: 0
last_referenced: never

## Interaction History
<!-- Timestamped evidence from sessions -->

## What Patient Says vs Feels vs Does
- **Says:** (update from sessions)
- **Feels:** (inferred from face + audio signals)
- **Does:** (behavioural patterns observed)

## Triggers
- **Positive triggers:** (topics/words that bring positive emotion when this person is mentioned)
- **Negative triggers:** (topics/words that cause distress)

## Strategic Insights for AI
<!-- How Thilina should approach topics involving this person -->

## Raw Session References
<!-- Verbatim quotes from sessions mentioning this person -->
"""

def get_or_create_person_file(name: str, category: str, role: str = "unknown") -> Path:
    """Find or create a relationship file for a person."""
    safe_name = re.sub(r"[^\w]", "_", name.lower().strip())
    cat_dir = RELATIONSHIPS_DIR / category
    cat_dir.mkdir(parents=True, exist_ok=True)
    # Search existing files for this name
    for f in cat_dir.glob("*.md"):
        if safe_name in f.stem:
            return f
    # Create new file
    path = cat_dir / f"{safe_name}.md"
    content = RELATIONSHIP_TEMPLATE.format(
        name=name, category=category, role=role,
        first_seen=datetime.now(timezone.utc).date().isoformat()
    )
    path.write_text(content, encoding="utf-8")
    return path

def append_interaction(path: Path, session_id: str, quote: str,
                       face_struggle: float, emotion_label: str):
    """Append a new interaction record to a relationship file."""
    content = path.read_text(encoding="utf-8")
    ts = datetime.now(timezone.utc).isoformat()
    block = f"""
### [{ts}] session={session_id}
- **Quote:** "{quote}"
- **Patient emotion during mention:** {emotion_label} (face_struggle={face_struggle:.2f})
"""
    content = content.replace(
        "<!-- Timestamped evidence from sessions -->",
        f"<!-- Timestamped evidence from sessions -->{block}"
    )
    # Update sessions_referenced counter
    content = re.sub(
        r"sessions_referenced:\s*(\d+)",
        lambda m: f"sessions_referenced: {int(m.group(1))+1}",
        content
    )
    content = re.sub(
        r"last_referenced:\s*\S+",
        f"last_referenced: {datetime.now(timezone.utc).date().isoformat()}",
        content
    )
    path.write_text(content, encoding="utf-8")

# ─── Relationship Extraction ──────────────────────────────────────────────────

def extract_relationship_mentions(transcript: list[dict], known_people: dict) -> list[dict]:
    """
    Scan transcript turns for known people or generic relationship words.
    known_people: {"Kamala": {"category": "family", "role": "wife"}, ...}
    Returns list of {name, quote, t_ms, category, role}
    """
    GENERIC_LABELS = {
        "බිරිය": ("family", "wife"),
        "wife": ("family", "wife"),
        "පුතා": ("family", "son"),
        "son": ("family", "son"),
        "දුව": ("family", "daughter"),
        "daughter": ("family", "daughter"),
        "ළමා": ("family", "child"),
    }
    mentions = []
    for turn in transcript:
        text = turn.get("text", "")
        t_ms = turn.get("t_ms", 0)
        for name, info in known_people.items():
            if name.lower() in text.lower():
                mentions.append({"name": name, "quote": text, "t_ms": t_ms, **info})
        for label, (cat, role) in GENERIC_LABELS.items():
            if label in text:
                mentions.append({"name": label, "quote": text, "t_ms": t_ms,
                                  "category": cat, "role": role})
    return mentions

# ─── Graph I/O ────────────────────────────────────────────────────────────────

EMPTY_GRAPH = {
    "nodes": [],
    "edges": [],
    "clusters": {
        "pain": [],
        "joy": [],
        "therapeutic": [],
        "neutral": []
    },
    "last_updated": None
}

def load_graph() -> dict:
    if not GRAPH_PATH.exists():
        return EMPTY_GRAPH.copy()
    return json.loads(GRAPH_PATH.read_text(encoding="utf-8"))

def save_graph_atomic(graph: dict):
    """Write graph to .tmp, verify JSON, then rename — prevents corruption."""
    tmp = GRAPH_PATH.with_suffix(".tmp")
    graph["last_updated"] = datetime.now(timezone.utc).isoformat()
    tmp.write_text(json.dumps(graph, ensure_ascii=False, indent=2), encoding="utf-8")
    # Verify
    json.loads(tmp.read_text())
    shutil.move(str(tmp), str(GRAPH_PATH))

def update_graph(graph: dict, name: str, category: str, role: str,
                 valence_delta: float, session_id: str) -> dict:
    """Add or update a node and its patient edge in the graph."""
    # Find existing node
    node = next((n for n in graph["nodes"] if n["id"] == name), None)
    if not node:
        node = {"id": name, "category": category, "role": role,
                "importance": 0.5, "valence": 0.0, "sessions": []}
        graph["nodes"].append(node)
    # Update valence (clamp ±0.05 per session)
    delta = max(-0.05, min(0.05, valence_delta))
    node["valence"] = round(max(-1.0, min(1.0, node["valence"] + delta)), 3)
    if session_id not in node["sessions"]:
        node["sessions"].append(session_id)
    node["importance"] = min(1.0, round(node["importance"] + 0.02, 3))
    # Add/update edge to patient node
    edge = next((e for e in graph["edges"]
                 if set([e["from"], e["to"]]) == {"PATIENT", name}), None)
    if not edge:
        edge = {"from": "PATIENT", "to": name, "relation": role,
                "weight": 0.5, "last_session": session_id}
        graph["edges"].append(edge)
    else:
        edge["weight"] = min(1.0, round(edge["weight"] + abs(delta), 3))
        edge["last_session"] = session_id
    # Update clusters
    if node["valence"] < -0.3 and name not in graph["clusters"]["pain"]:
        graph["clusters"]["pain"].append(name)
    elif node["valence"] > 0.3 and name not in graph["clusters"]["joy"]:
        graph["clusters"]["joy"].append(name)
    return graph

def query_graph(question: str, graph: dict) -> list[dict]:
    """
    Natural-language-style graph query.
    Examples:
      "what triggers shame?" → nodes with valence < -0.5
      "what brings joy?" → nodes with valence > 0.5
      "most important people?" → nodes sorted by importance desc
    """
    q = question.lower()
    nodes = graph.get("nodes", [])
    if "shame" in q or "fear" in q or "sad" in q or "trigger" in q:
        return sorted([n for n in nodes if n["valence"] < -0.3],
                      key=lambda n: n["valence"])
    if "joy" in q or "happy" in q or "positive" in q:
        return sorted([n for n in nodes if n["valence"] > 0.3],
                      key=lambda n: -n["valence"])
    if "important" in q or "close" in q:
        return sorted(nodes, key=lambda n: -n["importance"])[:5]
    return nodes

def get_relationship_summary(graph: dict, max_nodes: int = 10) -> str:
    """Returns a concise text summary for memory injection."""
    lines = []
    top = sorted(graph.get("nodes", []), key=lambda n: -n["importance"])[:max_nodes]
    for n in top:
        valence_word = "positive" if n["valence"] > 0.2 else ("negative" if n["valence"] < -0.2 else "neutral")
        lines.append(f"- {n['id']} ({n['role']}): {valence_word} (weight={n['valence']:.2f})")
    return "\n".join(lines)

# ─── Main Orchestrator ────────────────────────────────────────────────────────

def update_relationship_tree(fused_analysis: dict, known_people: dict) -> dict:
    """
    Main entry point.
    known_people: {"Kamala": {"category": "family", "role": "wife"}, ...}
    Returns summary of updates made.
    """
    RELATIONSHIPS_DIR.mkdir(parents=True, exist_ok=True)
    session_id = fused_analysis.get("session_id", "unknown")
    transcript = []
    for w in fused_analysis.get("windows", []):
        transcript += [e for e in w.get("events", []) if e.get("source") == "transcript"]
    mentions = extract_relationship_mentions(transcript, known_people)
    graph = load_graph()
    # Ensure PATIENT node exists
    if not any(n["id"] == "PATIENT" for n in graph["nodes"]):
        graph["nodes"].append({"id": "PATIENT", "category": "self", "role": "patient",
                                "importance": 1.0, "valence": 0.0, "sessions": []})
    updated = []
    for mention in mentions:
        name = mention["name"]
        cat  = mention.get("category", "community")
        role = mention.get("role", "unknown")
        quote = mention.get("quote", "")
        t_ms  = mention.get("t_ms", 0)
        # Infer emotional valence from surrounding window
        window = next((w for w in fused_analysis.get("windows", [])
                       if w["t_start_ms"] <= t_ms <= w["t_end_ms"]), None)
        face_struggle = 0.0
        emotion_label = "neutral"
        valence_delta = 0.0
        if window:
            cls = window.get("classification", "NEUTRAL")
            if cls == "STRUGGLE":
                face_struggle = 3.0; emotion_label = "frustrated"; valence_delta = -0.03
            elif cls == "SUCCESS":
                face_struggle = 0.5; emotion_label = "engaged"; valence_delta = +0.03
            elif cls == "CONFLICT":
                face_struggle = 2.0; emotion_label = "ambivalent"; valence_delta = 0.0
        path = get_or_create_person_file(name, cat, role)
        append_interaction(path, session_id, quote, face_struggle, emotion_label)
        graph = update_graph(graph, name, cat, role, valence_delta, session_id)
        updated.append(name)
    save_graph_atomic(graph)
    return {"session_id": session_id, "people_updated": updated, "graph_node_count": len(graph["nodes"])}
```

## Data Schemas

### Graph JSON Schema
```json
{
  "nodes": [
    {"id": "PATIENT",  "category": "self",   "role": "patient", "importance": 1.0, "valence": 0.0,  "sessions": ["s1", "s2"]},
    {"id": "Kamala",   "category": "family", "role": "wife",    "importance": 0.9, "valence": 0.75, "sessions": ["s1"]},
    {"id": "Nuwan",    "category": "family", "role": "son",     "importance": 0.7, "valence": 0.4,  "sessions": ["s2"]}
  ],
  "edges": [
    {"from": "PATIENT", "to": "Kamala", "relation": "wife",     "weight": 0.9, "last_session": "s2"},
    {"from": "PATIENT", "to": "Nuwan",  "relation": "son",      "weight": 0.7, "last_session": "s2"}
  ],
  "clusters": {
    "pain":         [],
    "joy":          ["Kamala"],
    "therapeutic":  ["Dr. Fernando"],
    "neutral":      ["Uncle Silva"]
  },
  "last_updated": "2025-01-15T14:32:00+00:00"
}
```

### Person Markdown File (populated)
```markdown
# Relationship: Kamala

## Identity
- **Name:** Kamala
- **Category:** family
- **Role:** wife
- **First mentioned:** 2025-01-10
- **Emotional valence:** positive

## Emotional Weight
importance: 0.9
valence: 0.75
sessions_referenced: 5
last_referenced: 2025-01-15

## Interaction History
### [2025-01-15T14:32:00+00:00] session=session_2025-01-15
- **Quote:** "බිරිය ආවා"
- **Patient emotion during mention:** engaged (face_struggle=0.30)

## What Patient Says vs Feels vs Does
- **Says:** Asks about her during most sessions
- **Feels:** Positive, calming effect on voice
- **Does:** Smiles when her name is mentioned

## Strategic Insights for AI
- Mention Kamala to calm patient when anxiety spikes
- Do NOT connect Kamala to money stress topics
```

## Error Handling

| Problem | Fix |
|---|---|
| Graph JSON corrupted | GRAPH_PATH.with_suffix(".bak") exists as fallback; copy back |
| Person file has encoding issues | Always write `encoding="utf-8"` |
| NetworkX import error | `pip install networkx`; alternatively use pure dict-based graph |
| `known_people` dict is empty | Extract names from previous sessions' files as fallback |

## Testing

**Test 1:** Call `get_or_create_person_file("Kamala", "family", "wife")` twice. Verify only one file created.

**Test 2:** Call `update_graph({...}, "Kamala", "family", "wife", -0.03, "s1")`. Verify valence decreased and edge weight updated.

**Test 3:** Call `query_graph("what brings joy?", graph)` where Kamala has `valence: 0.75`. Expect Kamala in results.

**Test 4:** Corrupt `relationship_graph.json` by writing `{broken`. Call `load_graph()`. Expect `EMPTY_GRAPH` returned, not a crash.

## References
- `session_fusion_analysis.md` — provides input fused JSON
- `memory_injection_generator.md` — calls `get_relationship_summary()` for session prompts
- `therapeutic_insight_extractor.md` — provides named emotional pattern analysis

## Version
- Created: 2025-01-15
- Compatibility: Python 3.10+, networkx 3.x
