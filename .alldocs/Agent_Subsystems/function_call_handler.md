# Skill: Function Call Handler

## Purpose
Declares all AURA function tools to Gemini Live, handles incoming function call events in the receive loop, executes each function's app-side logic, and sends the result back to the session so Gemini can continue. Without this skill, Gemini will attempt to call functions and hang waiting for responses.

## Context
Depends on `vertex_ai_live_api_setup.md` — the session object and `send_client_content` pattern come from there. This skill is the bridge between Gemini's AI decisions and the Flutter/React app's UI state. Import and call `get_function_declarations()` when building `LiveConnectConfig`.

## Prerequisites
- Working Gemini Live session (see `vertex_ai_live_api_setup.md`)
- `widget_ui_state_manager.md` implemented — functions here trigger widget changes
- Python 3.11+

## Step-by-Step Instructions

1. **Declare** all functions using `get_function_declarations()` — pass the result to `LiveConnectConfig(tools=[...])`.
2. **In the receive loop**, check `response.tool_call` — if present, iterate over `response.tool_call.function_calls`.
3. **Dispatch** each function call to `dispatch_function_call(name, args)`.
4. **Execute** the appropriate handler function (UI update, data log, search, etc.).
5. **Return result** via `session.send_client_content(...)` with `turn_complete=False` so Gemini continues without waiting for patient voice.
6. **Never** call `send_client_content` with a function_response after a full turn boundary — only respond to the specific `function_call.id`.

## Code Patterns

```python
"""
function_call_handler.py — All AURA function declarations and handlers
"""
import json
from google.genai import types
from typing import Any
import asyncio

# ─── Function Declarations ─────────────────────────────────────────────────────

def get_function_declarations() -> list:
    """
    Returns all function declarations for Gemini Live.
    Pass to LiveConnectConfig(tools=get_function_declarations())
    """
    return [types.Tool(function_declarations=[
        # ── UI Widgets ──────────────────────────────────────────────────────────
        types.FunctionDeclaration(
            name="show_breathing_widget",
            description="Show the breathing exercise widget with an expanding/contracting circle. "
                        "Use at session start, when patient is anxious, or to de-escalate frustration.",
            parameters=types.Schema(
                type=types.Type.OBJECT,
                properties={
                    "inhale_seconds": types.Schema(type=types.Type.INTEGER, description="Inhale duration. Default: 4"),
                    "hold_seconds":   types.Schema(type=types.Type.INTEGER, description="Hold duration. Default: 4"),
                    "exhale_seconds": types.Schema(type=types.Type.INTEGER, description="Exhale duration. Default: 6"),
                    "cycles":         types.Schema(type=types.Type.INTEGER, description="Number of breath cycles. Default: 3"),
                },
                required=[],
            )
        ),
        types.FunctionDeclaration(
            name="show_exercise_widget",
            description="Show a word/picture exercise card. The patient sees the image and attempts to name it.",
            parameters=types.Schema(
                type=types.Type.OBJECT,
                properties={
                    "word":       types.Schema(type=types.Type.STRING, description="Target word in Sinhala script"),
                    "image_url":  types.Schema(type=types.Type.STRING, description="URL of the item image"),
                    "difficulty": types.Schema(type=types.Type.INTEGER,
                                               description="1=easy, 2=medium, 3=hard",
                                               enum=[1, 2, 3]),
                },
                required=["word"],
            )
        ),
        types.FunctionDeclaration(
            name="show_conversation_widget",
            description="Show the default conversation view with therapist avatar and speech subtitles.",
            parameters=types.Schema(type=types.Type.OBJECT, properties={
                "show_subtitles": types.Schema(type=types.Type.BOOLEAN, description="Show Sinhala subtitles. Default: true"),
            })
        ),
        types.FunctionDeclaration(
            name="show_text_on_screen",
            description="Display large text on screen — word prompts, encouragement messages, or instructions.",
            parameters=types.Schema(
                type=types.Type.OBJECT,
                properties={
                    "text":      types.Schema(type=types.Type.STRING, description="Text to display (Sinhala or English)"),
                    "size":      types.Schema(type=types.Type.STRING, description="'large' | 'medium' | 'small'. Default: large"),
                    "highlight": types.Schema(type=types.Type.BOOLEAN, description="Highlight text in yellow. Default: false"),
                    "duration_seconds": types.Schema(type=types.Type.INTEGER, description="Auto-dismiss after N seconds. 0 = permanent."),
                },
                required=["text"],
            )
        ),
        types.FunctionDeclaration(
            name="show_counter_widget",
            description="Show a progress counter (e.g., '2 of 5 words done').",
            parameters=types.Schema(
                type=types.Type.OBJECT,
                properties={
                    "current": types.Schema(type=types.Type.INTEGER, description="Current count"),
                    "total":   types.Schema(type=types.Type.INTEGER, description="Total count"),
                    "label":   types.Schema(type=types.Type.STRING,  description="Label text, e.g. 'Words completed'"),
                },
                required=["current", "total"],
            )
        ),
        types.FunctionDeclaration(
            name="show_repetition_widget",
            description="Show the speech repetition widget with animated waveform and lip movement guide.",
            parameters=types.Schema(
                type=types.Type.OBJECT,
                properties={
                    "target_word": types.Schema(type=types.Type.STRING, description="Word patient should repeat"),
                    "show_lips":   types.Schema(type=types.Type.BOOLEAN, description="Show animated lip guide. Default: true"),
                },
                required=["target_word"],
            )
        ),
        types.FunctionDeclaration(
            name="show_yesno_widget",
            description="Show large Yes/No buttons for patient to tap their answer.",
            parameters=types.Schema(
                type=types.Type.OBJECT,
                properties={
                    "question":    types.Schema(type=types.Type.STRING, description="Question text to display"),
                    "yes_label":   types.Schema(type=types.Type.STRING, description="Custom yes label. Default: 'ඔව්'"),
                    "no_label":    types.Schema(type=types.Type.STRING, description="Custom no label. Default: 'නෑ'"),
                },
                required=["question"],
            )
        ),
        types.FunctionDeclaration(
            name="show_phrase_builder_widget",
            description="Show word-by-word phrase builder — reveals each word of a target phrase progressively.",
            parameters=types.Schema(
                type=types.Type.OBJECT,
                properties={
                    "phrase":            types.Schema(type=types.Type.STRING, description="Full target phrase"),
                    "reveal_word_count": types.Schema(type=types.Type.INTEGER,  description="How many words to reveal at once. Default: 1"),
                },
                required=["phrase"],
            )
        ),
        types.FunctionDeclaration(
            name="show_semantic_hint_widget",
            description="Show semantic hint boxes (colour, size, function) to help patient retrieve a word without giving the answer.",
            parameters=types.Schema(
                type=types.Type.OBJECT,
                properties={
                    "color_hint":    types.Schema(type=types.Type.STRING, description="e.g. 'orange'"),
                    "size_hint":     types.Schema(type=types.Type.STRING, description="e.g. 'small, fits in hand'"),
                    "function_hint": types.Schema(type=types.Type.STRING, description="e.g. 'you eat it'"),
                    "category_hint": types.Schema(type=types.Type.STRING, description="e.g. 'vegetable'"),
                },
                required=[],
            )
        ),
        types.FunctionDeclaration(
            name="play_sound",
            description="Play a sound effect — success chime, gentle bell, or encouragement audio.",
            parameters=types.Schema(
                type=types.Type.OBJECT,
                properties={
                    "sound_id": types.Schema(
                        type=types.Type.STRING,
                        description="Sound identifier",
                        enum=["success", "try_again", "session_start", "session_end", "breathing_bell"],
                    ),
                },
                required=["sound_id"],
            )
        ),
        # ── Data Logging ────────────────────────────────────────────────────────
        types.FunctionDeclaration(
            name="log_exercise",
            description="Log the outcome of a speech exercise attempt. Call EVERY time patient attempts a word.",
            parameters=types.Schema(
                type=types.Type.OBJECT,
                properties={
                    "word":             types.Schema(type=types.Type.STRING,  description="Target word"),
                    "exercise_type":    types.Schema(type=types.Type.STRING,
                                                     enum=["naming", "repetition", "reading", "conversation"]),
                    "difficulty":       types.Schema(type=types.Type.INTEGER, enum=[1, 2, 3]),
                    "correct":          types.Schema(type=types.Type.BOOLEAN, description="Did patient produce the word correctly?"),
                    "cue_level":        types.Schema(type=types.Type.INTEGER, enum=[0, 1, 2, 3, 4]),
                    "onset_latency_ms": types.Schema(type=types.Type.INTEGER, description="Ms from prompt to first sound"),
                    "self_corrected":   types.Schema(type=types.Type.BOOLEAN, description="Did patient self-correct?"),
                    "phonemes":         types.Schema(type=types.Type.ARRAY,
                                                     items=types.Schema(type=types.Type.STRING),
                                                     description="Phonemes in attempted word"),
                },
                required=["word", "correct", "cue_level"],
            )
        ),
        types.FunctionDeclaration(
            name="update_patient_state",
            description="Update patient's current emotional/energy state during session.",
            parameters=types.Schema(
                type=types.Type.OBJECT,
                properties={
                    "mood":        types.Schema(type=types.Type.STRING, enum=["distressed", "frustrated", "neutral", "calm", "engaged"]),
                    "energy":      types.Schema(type=types.Type.STRING, enum=["low", "medium", "high"]),
                    "note":        types.Schema(type=types.Type.STRING, description="Free text observation"),
                },
                required=["mood"],
            )
        ),
        types.FunctionDeclaration(
            name="update_difficulty_level",
            description="Adjust exercise difficulty for the remainder of this session.",
            parameters=types.Schema(
                type=types.Type.OBJECT,
                properties={
                    "new_level": types.Schema(type=types.Type.INTEGER, enum=[1, 2, 3]),
                    "reason":    types.Schema(type=types.Type.STRING),
                },
                required=["new_level"],
            )
        ),
        types.FunctionDeclaration(
            name="end_session",
            description="Signal that the therapy session is complete. Triggers recording save and background agent.",
            parameters=types.Schema(
                type=types.Type.OBJECT,
                properties={
                    "summary":    types.Schema(type=types.Type.STRING, description="Session summary in Sinhala for patient"),
                    "mood_final": types.Schema(type=types.Type.STRING, enum=["distressed", "frustrated", "neutral", "calm", "engaged"]),
                },
                required=["summary"],
            )
        ),
        # ── Memory & Search ─────────────────────────────────────────────────────
        types.FunctionDeclaration(
            name="graph_memory_search",
            description="Search the patient's relationship graph and brain knowledge for relevant information.",
            parameters=types.Schema(
                type=types.Type.OBJECT,
                properties={
                    "query": types.Schema(type=types.Type.STRING,
                                          description="Natural language query, e.g. 'what triggers shame?'"),
                },
                required=["query"],
            )
        ),
        types.FunctionDeclaration(
            name="teammate_search",
            description="Search the wiki brain files (10 brain region files + relationship tree) by keyword.",
            parameters=types.Schema(
                type=types.Type.OBJECT,
                properties={
                    "keywords": types.Schema(type=types.Type.ARRAY,
                                             items=types.Schema(type=types.Type.STRING)),
                    "region":   types.Schema(type=types.Type.STRING,
                                             description="Optional: restrict to one brain region file"),
                },
                required=["keywords"],
            )
        ),
    ])]

# ─── Handler Dispatch ──────────────────────────────────────────────────────────

# App state — update this in your actual app via callbacks
APP_STATE = {
    "current_widget": "conversation",
    "exercise_log": [],
    "patient_mood": "neutral",
    "difficulty_level": 2,
    "session_active": True,
}

async def dispatch_function_call(name: str, args: dict) -> str:
    """Route function call to the correct handler. Returns result string for Gemini."""
    handlers = {
        "show_breathing_widget":     handle_show_breathing_widget,
        "show_exercise_widget":      handle_show_exercise_widget,
        "show_conversation_widget":  handle_show_conversation_widget,
        "show_text_on_screen":       handle_show_text_on_screen,
        "show_counter_widget":       handle_show_counter_widget,
        "show_repetition_widget":    handle_show_repetition_widget,
        "show_yesno_widget":         handle_show_yesno_widget,
        "show_phrase_builder_widget":handle_show_phrase_builder_widget,
        "show_semantic_hint_widget": handle_show_semantic_hint_widget,
        "play_sound":                handle_play_sound,
        "log_exercise":              handle_log_exercise,
        "update_patient_state":      handle_update_patient_state,
        "update_difficulty_level":   handle_update_difficulty_level,
        "end_session":               handle_end_session,
        "graph_memory_search":       handle_graph_memory_search,
        "teammate_search":           handle_teammate_search,
    }
    handler = handlers.get(name)
    if not handler:
        return f"ERROR: Unknown function '{name}'"
    try:
        return await handler(args)
    except Exception as e:
        return f"ERROR in {name}: {str(e)}"

# ─── Individual Handlers ──────────────────────────────────────────────────────

async def handle_show_breathing_widget(args: dict) -> str:
    APP_STATE["current_widget"] = "breathing"
    # TODO: send event to Flutter/React app via WebSocket or state channel
    notify_app("SHOW_WIDGET", {"type": "breathing", **args})
    return "Breathing widget displayed. Patient is seeing the breathing circle."

async def handle_show_exercise_widget(args: dict) -> str:
    APP_STATE["current_widget"] = "exercise"
    notify_app("SHOW_WIDGET", {"type": "exercise", **args})
    return f"Exercise widget shown for word: {args.get('word')}. Patient is looking at the image."

async def handle_show_conversation_widget(args: dict) -> str:
    APP_STATE["current_widget"] = "conversation"
    notify_app("SHOW_WIDGET", {"type": "conversation", **args})
    return "Conversation view restored. Patient sees therapist avatar."

async def handle_show_text_on_screen(args: dict) -> str:
    notify_app("SHOW_WIDGET", {"type": "text", **args})
    return f"Text displayed: '{args.get('text')}'"

async def handle_show_counter_widget(args: dict) -> str:
    notify_app("SHOW_WIDGET", {"type": "counter", **args})
    return f"Counter: {args.get('current')} of {args.get('total')}"

async def handle_show_repetition_widget(args: dict) -> str:
    APP_STATE["current_widget"] = "repetition"
    notify_app("SHOW_WIDGET", {"type": "repetition", **args})
    return f"Repetition widget shown for: {args.get('target_word')}"

async def handle_show_yesno_widget(args: dict) -> str:
    APP_STATE["current_widget"] = "yesno"
    notify_app("SHOW_WIDGET", {"type": "yesno", **args})
    return "Yes/No buttons displayed. Waiting for patient tap."

async def handle_show_phrase_builder_widget(args: dict) -> str:
    notify_app("SHOW_WIDGET", {"type": "phrase_builder", **args})
    return f"Phrase builder started for: {args.get('phrase')}"

async def handle_show_semantic_hint_widget(args: dict) -> str:
    notify_app("SHOW_WIDGET", {"type": "semantic_hint", **args})
    return "Semantic hints displayed. Patient sees colour, size, and function clues."

async def handle_play_sound(args: dict) -> str:
    notify_app("PLAY_SOUND", args)
    return f"Sound played: {args.get('sound_id')}"

async def handle_log_exercise(args: dict) -> str:
    APP_STATE["exercise_log"].append(args)
    # Persist to session file
    import json; from pathlib import Path
    log_path = Path("/tmp/current_session_exercises.json")
    existing = json.loads(log_path.read_text()) if log_path.exists() else []
    existing.append(args)
    log_path.write_text(json.dumps(existing, ensure_ascii=False))
    return f"Exercise logged: word='{args.get('word')}' correct={args.get('correct')} cue={args.get('cue_level')}"

async def handle_update_patient_state(args: dict) -> str:
    APP_STATE["patient_mood"] = args.get("mood", "neutral")
    notify_app("STATE_UPDATE", args)
    return f"Patient state updated: {args}"

async def handle_update_difficulty_level(args: dict) -> str:
    APP_STATE["difficulty_level"] = args.get("new_level", 2)
    return f"Difficulty set to {args.get('new_level')} — {args.get('reason', '')}"

async def handle_end_session(args: dict) -> str:
    APP_STATE["session_active"] = False
    notify_app("END_SESSION", args)
    # Trigger background agent (async, non-blocking)
    asyncio.create_task(trigger_background_agent())
    return "Session ended. Background analysis starting."

async def handle_graph_memory_search(args: dict) -> str:
    from relationship_tree_updater import load_graph, query_graph
    graph = load_graph()
    results = query_graph(args.get("query", ""), graph)
    if not results:
        return "No relevant memory found."
    lines = [f"- {r['id']} ({r.get('role', '?')}): valence={r.get('valence', 0):.2f}" for r in results[:5]]
    return "Memory search results:\n" + "\n".join(lines)

async def handle_teammate_search(args: dict) -> str:
    from pathlib import Path; import re
    keywords = [k.lower() for k in args.get("keywords", [])]
    region = args.get("region")
    brain_dir = Path("/aura-brain/regions")
    results = []
    files = [brain_dir / f"{region}.md"] if region else brain_dir.glob("*.md")
    for f in files:
        if not f.exists():
            continue
        content = f.read_text(encoding="utf-8")
        for kw in keywords:
            if kw in content.lower():
                # Extract surrounding context
                idx = content.lower().find(kw)
                snippet = content[max(0, idx-100):idx+200].strip()
                results.append(f"[{f.stem}] ...{snippet}...")
                break
    return "\n\n".join(results[:3]) if results else "No results found in brain files."

async def trigger_background_agent():
    """Non-blocking background agent trigger — implement in background_agent_orchestrator.md."""
    await asyncio.sleep(1)
    print("[Background agent] Trigger fired — analysis starting...")

# ─── App Communication Bridge ──────────────────────────────────────────────────

def notify_app(event_type: str, data: dict):
    """
    Send event to the Flutter/React app.
    Implementation depends on your app architecture:
    - Flutter: use a MethodChannel call or EventChannel
    - React: emit via WebSocket or React state setter via callback
    - Web: postMessage to iframe or BroadcastChannel
    Replace this stub with your actual IPC mechanism.
    """
    import json
    print(f"[APP_EVENT] {event_type}: {json.dumps(data, ensure_ascii=False)}")
    # Example: write to a named pipe, WebSocket, or shared memory
    # ws.send(json.dumps({"type": event_type, "data": data}))
```

## Data Schemas

### Function Response Format
```python
# CORRECT — always send via send_client_content with function_response
await session.send_client_content(
    turns=[types.Content(
        role="user",
        parts=[types.Part(
            function_response=types.FunctionResponse(
                id=function_call.id,        # MUST match the call's ID
                name=function_call.name,
                response={"result": "Exercise widget shown."},
            )
        )]
    )],
    turn_complete=False,  # AI continues without waiting for patient voice
)
```

## Error Handling

| Problem | Fix |
|---|---|
| Gemini calls a function that doesn't exist | Catch `KeyError` in dispatch; return `"Function not found"`; log for debugging |
| Function response not sent | Gemini will hang waiting — always send response, even on error |
| `turn_complete=True` used for function response | Gemini interprets as patient's turn ending — use `False` for function responses |
| Function call received but `id` is None | SDK version issue — upgrade to google-genai >= 1.5 |
| App state out of sync | Re-fetch state from app on each function call, not from cached APP_STATE |

## Testing

**Test 1 — Declaration check:** Call `get_function_declarations()`. Verify it returns a list with 1 Tool containing ≥ 15 FunctionDeclarations.

**Test 2 — Dispatch:** Call `asyncio.run(dispatch_function_call("play_sound", {"sound_id": "success"}))`. Expect `"Sound played: success"` return value without crash.

**Test 3 — Unknown function:** Call `asyncio.run(dispatch_function_call("nonexistent_func", {}))`. Expect `"ERROR: Unknown function 'nonexistent_func'"`.

## References
- `vertex_ai_live_api_setup.md` — session setup and `send_client_content` pattern
- `widget_ui_state_manager.md` — implements the actual UI transitions triggered here
- `session_recording_storage.md` — `log_exercise` data goes to session files

## Version
- Created: 2025-01-15
- SDK: google-genai 1.9.0
- Compatibility: Python 3.11+
