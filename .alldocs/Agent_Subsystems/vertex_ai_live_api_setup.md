# Skill: Vertex AI Live API Setup

## Purpose
Complete, copy-paste-ready guide for connecting to the Vertex AI Gemini Live API for real-time bidirectional voice conversation. This skill assumes you have a Google Cloud project and want to run the AURA therapy session in Python. After following this skill, you will have a working audio session with Thilina speaking Sinhala.

## Context
Use this skill at the very beginning of any AURA coding session. Every other Vertex AI skill depends on the connection pattern established here. Read this first, `function_call_handler.md` second.

## Prerequisites
- Google Cloud project created — note your `PROJECT_ID`
- Vertex AI API enabled: `gcloud services enable aiplatform.googleapis.com`
- Service account created with role `roles/aiplatform.user`
- Service account key JSON downloaded (or ADC configured)
- Python 3.11+ recommended (asyncio improvements)
- Node.js NOT required for Python path

## Step-by-Step Instructions

### Step 1 — Install the SDK
```bash
pip install google-genai==1.9.0
# Pin to 1.9.0 — earlier versions lack LiveConnectConfig.tools
# Later versions may change async API — test before upgrading
```

### Step 2 — Set Authentication

**Option A: Application Default Credentials (recommended for development)**
```bash
gcloud auth application-default login
export GOOGLE_CLOUD_PROJECT="your-project-id"
```

**Option B: Service Account JSON**
```bash
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account.json"
export GOOGLE_CLOUD_PROJECT="your-project-id"
```

**Option C: Explicit in code (production)**
```python
import os
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "/path/to/sa.json"
os.environ["GOOGLE_CLOUD_PROJECT"] = "your-project-id"
```

### Step 3 — Select Region
Use `us-east4` first. If unavailable, fall back to `us-central1`.
**Do NOT use** `us-west1` or `europe-west4` — Live API model is not available there.

### Step 4 — Connect
See code pattern below. Key points:
- Always use `vertexai=True` when constructing the client
- The `model` string uses the full resource path
- `response_modalities=["AUDIO"]` is required for voice
- System prompt injected via `system_instruction`

### Step 5 — Send and Receive in a loop
Two async tasks run concurrently: one sends audio chunks, one receives audio + function calls.

## Code Patterns

```python
"""
AURA — Vertex AI Gemini Live Connection
Run: python aura_session.py
"""
import asyncio
import os
import pyaudio
from google import genai
from google.genai import types
from google.genai.types import (
    LiveConnectConfig,
    SpeechConfig,
    VoiceConfig,
    PrebuiltVoiceConfig,
)

# ─── Configuration ────────────────────────────────────────────────────────────

PROJECT_ID = os.environ.get("GOOGLE_CLOUD_PROJECT", "your-project-id")
LOCATION   = "us-east4"   # fallback: us-central1
MODEL_ID   = "gemini-2.0-flash-live-001"  # as of 2025 — verify at cloud.google.com/vertex-ai/generative-ai/docs/live
MODEL_PATH = f"projects/{PROJECT_ID}/locations/{LOCATION}/publishers/google/models/{MODEL_ID}"

# Audio config — MUST match Gemini's expected input format
SEND_SAMPLE_RATE    = 16000   # Hz — input to Gemini
RECEIVE_SAMPLE_RATE = 24000   # Hz — output from Gemini
CHANNELS            = 1
CHUNK_SIZE          = 1024    # frames per buffer

# ─── System Prompt Template ───────────────────────────────────────────────────

def build_system_prompt(memory_injection: str = "") -> str:
    return f"""You are Thilina, a compassionate, patient speech therapist fluent in Colombo-dialect Sinhala.
You are speaking with a Sri Lankan male patient who had a stroke and is recovering speech.

CORE RULES:
1. Speak ONLY in Sinhala unless the patient uses English.
2. Speak slowly, clearly, with natural Colombo accent.
3. NEVER make the patient feel embarrassed. If they fail, encourage warmly.
4. Session length: maximum 12 minutes (warn at 10 min).
5. Always start with breathing exercises to calm the patient.
6. Use function calls to change the UI — do not describe UI changes in words.
7. Log every exercise attempt using log_exercise function call.

{memory_injection}

CURRENT SESSION GOALS:
- Warm up: 2 minutes breathing
- Naming exercises: difficulty level determined by previous session data above
- Conversational practice: 3 minutes free talk
- Close: breathing + positive summary
"""

# ─── Live Session ─────────────────────────────────────────────────────────────

async def run_therapy_session(memory_injection: str = "", function_declarations: list = None):
    """
    Main session coroutine.
    Connects to Vertex AI Gemini Live, streams microphone audio,
    plays back AI audio, and handles function calls.
    """
    # 1. Build client
    client = genai.Client(
        vertexai=True,
        project=PROJECT_ID,
        location=LOCATION,
    )
    # 2. Build config
    config = LiveConnectConfig(
        response_modalities=["AUDIO"],
        speech_config=SpeechConfig(
            voice_config=VoiceConfig(
                prebuilt_voice_config=PrebuiltVoiceConfig(voice_name="Kore")
            ),
            # Language code for Sinhala — Gemini Live will respond in this language
            # Note: system_instruction also enforces Sinhala
        ),
        system_instruction=types.Content(
            parts=[types.Part(text=build_system_prompt(memory_injection))],
            role="user",
        ),
        tools=function_declarations or [],
    )
    # 3. Setup PyAudio
    pa = pyaudio.PyAudio()
    mic_stream = pa.open(
        format=pyaudio.paInt16,
        channels=CHANNELS,
        rate=SEND_SAMPLE_RATE,
        input=True,
        frames_per_buffer=CHUNK_SIZE,
    )
    speaker_stream = pa.open(
        format=pyaudio.paInt16,
        channels=CHANNELS,
        rate=RECEIVE_SAMPLE_RATE,
        output=True,
        frames_per_buffer=CHUNK_SIZE,
    )
    print("Connecting to Vertex AI Gemini Live...")
    async with client.aio.live.connect(model=MODEL_PATH, config=config) as session:
        print("Connected. Session started.")

        async def send_audio():
            """Continuously read microphone and stream to Gemini."""
            while True:
                chunk = mic_stream.read(CHUNK_SIZE, exception_on_overflow=False)
                await session.send_realtime_input(
                    audio=types.Blob(data=chunk, mime_type="audio/pcm;rate=16000")
                )
                await asyncio.sleep(0)  # yield to event loop

        async def receive_and_handle():
            """Receive audio and function calls from Gemini."""
            async for response in session.receive():
                # Audio output — play through speaker
                if response.data:
                    speaker_stream.write(response.data)
                # Server content (transcripts, turn signals)
                if response.server_content:
                    if response.server_content.turn_complete:
                        print("[Thilina finished turn]")
                # Function calls — handle them
                if response.tool_call:
                    for fc in response.tool_call.function_calls:
                        print(f"[Function call] {fc.name}({dict(fc.args)})")
                        result = await handle_function_call(session, fc)
                        print(f"[Function result] {result}")

        # Run both tasks concurrently
        await asyncio.gather(send_audio(), receive_and_handle())

async def handle_function_call(session, function_call) -> str:
    """
    Stub — implement in function_call_handler.md.
    Must send result back to session via send_client_content.
    """
    from function_call_handler import dispatch_function_call
    result_text = await dispatch_function_call(function_call.name, dict(function_call.args))
    await session.send_client_content(
        turns=[types.Content(
            role="user",
            parts=[types.Part(
                function_response=types.FunctionResponse(
                    id=function_call.id,
                    name=function_call.name,
                    response={"result": result_text},
                )
            )]
        )],
        turn_complete=False,  # AI continues — does not wait for user to speak
    )
    return result_text

# ─── Entry Point ──────────────────────────────────────────────────────────────

if __name__ == "__main__":
    from memory_injection_generator import generate_memory_injection
    from function_call_handler import get_function_declarations
    memory = generate_memory_injection(patient_name="Mr. Perera")
    declarations = get_function_declarations()
    asyncio.run(run_therapy_session(memory, declarations))
```

## Config Schema Reference

```python
LiveConnectConfig(
    response_modalities=["AUDIO"],          # Required for voice
    speech_config=SpeechConfig(
        voice_config=VoiceConfig(
            prebuilt_voice_config=PrebuiltVoiceConfig(
                voice_name="Kore"           # or "Fenrir" or "Puck" — see below
            )
        )
    ),
    system_instruction=types.Content(...),  # Your system prompt
    tools=[...],                            # Function declarations
)
```

## Voice Options

| Voice | Character | Best for |
|---|---|---|
| `Kore` | Warm, gentle, slightly feminine | **Thilina — use this** |
| `Fenrir` | Deep, calm, authoritative | Formal medical contexts |
| `Puck` | Bright, energetic | Not appropriate for therapy |

## Session Limits
- **Audio-only:** ~15 minutes per session
- **Audio + video:** ~2 minutes per session (video dramatically increases token consumption)
- **Solution:** Use session resumption OR split into 10-minute chunks with handoff

## Session Resumption Pattern
```python
# Save handle at session end:
session_handle = session.session_resumption_token
# On reconnect, pass to config:
config = LiveConnectConfig(
    ...,
    session_resumption=types.SessionResumptionConfig(handle=session_handle)
)
```

## Error Handling

| Error | Cause | Fix |
|---|---|---|
| `PERMISSION_DENIED` | Wrong IAM role | Add `roles/aiplatform.user` to service account |
| `NOT_FOUND: model` | Wrong model path or region | Verify model available in `us-east4`; check exact model ID |
| `INVALID_ARGUMENT` | Wrong audio format | Ensure PCM 16kHz 16-bit mono |
| `RESOURCE_EXHAUSTED` | Rate limit hit | Add exponential backoff; check Vertex AI quotas |
| Connection drops silently | Network timeout | Implement heartbeat ping every 30s |
| No audio output | `response_modalities` missing AUDIO | Add `["AUDIO"]` to config |
| Wrong language | System prompt not enforcing Sinhala | Add explicit "You MUST speak Sinhala" line |

```python
# Robust connection wrapper with retry
import asyncio
from google.api_core.exceptions import ServiceUnavailable, ResourceExhausted

async def connect_with_retry(max_retries=3):
    for attempt in range(max_retries):
        try:
            await run_therapy_session()
            break
        except ServiceUnavailable:
            if attempt < max_retries - 1:
                await asyncio.sleep(2 ** attempt)  # 1s, 2s, 4s
            else:
                raise
        except ResourceExhausted:
            print("Rate limit hit — waiting 60 seconds")
            await asyncio.sleep(60)
```

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| `ModuleNotFoundError: google.genai` | SDK not installed | `pip install google-genai==1.9.0` |
| Gemini speaks English despite prompt | Language code not set | Ensure system_instruction explicitly says "ONLY speak Sinhala" |
| Audio sounds robotic | Wrong output sample rate | Set `RECEIVE_SAMPLE_RATE=24000` in PyAudio output stream |
| Microphone not detected | PyAudio device index wrong | Run `python -c "import pyaudio; p=pyaudio.PyAudio(); [print(i, p.get_device_info_by_index(i)['name']) for i in range(p.get_device_count())]"` |
| Session hangs at start | Auth not configured | Run `gcloud auth application-default login` |
| `ValueError: LiveConnectConfig` | SDK version mismatch | Ensure `google-genai >= 1.5.0` |

## Testing
```python
# Minimal connection test (no audio hardware required)
async def test_connection():
    client = genai.Client(vertexai=True, project=PROJECT_ID, location=LOCATION)
    config = LiveConnectConfig(response_modalities=["TEXT"])
    async with client.aio.live.connect(model=MODEL_PATH, config=config) as session:
        await session.send_client_content(
            turns=[types.Content(role="user", parts=[types.Part(text="Hello")])],
            turn_complete=True
        )
        async for response in session.receive():
            if response.server_content and response.server_content.turn_complete:
                break
        print("Connection test PASSED")

asyncio.run(test_connection())
```

## References
- Vertex AI Live API docs: https://cloud.google.com/vertex-ai/generative-ai/docs/live
- google-genai SDK: https://github.com/googleapis/python-genai
- `function_call_handler.md` — function declaration and handling
- `vertex_ai_troubleshooting.md` — exhaustive error reference

## Version
- Created: 2025-01-15
- SDK: google-genai 1.9.0
- Model: gemini-2.0-flash-live-001
- Compatibility: Python 3.11+, PyAudio 0.2.14
