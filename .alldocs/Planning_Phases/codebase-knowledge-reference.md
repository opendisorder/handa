# AURA (Handa) — Complete Codebase Knowledge Reference

> **Generated**: 2026-06-10  
> **Purpose**: Single source of truth for all codebase findings. Prevents context loss during compaction.  
> **Scope**: gemini_live Dart package internals, Vertex AI Live protocol, Handa project structure, test results, fork plan.

---

## Table of Contents
1. [Project Structure](#1-project-structure)
2. [gemini_live Package (v2026.6.6) — Full Internal Map](#2-gemini_live-package-v202666--full-internal-map)
3. [Vertex AI Live Protocol Reference](#3-vertex-ai-live-protocol-reference)
4. [Test Results & Empirical Findings](#4-test-results--empirical-findings)
5. [Agent Builder Reference Implementation](#5-agent-builder-reference-implementation)
6. [Fork Plan — Summary of ALL Changes Needed](#6-fork-plan--summary-of-all-changes-needed)
7. [AURA Architecture Guide](#7-aura-architecture-guide)
8. [Decision Log](#8-decision-log)

---

## 1. Project Structure

```
/home/jay/Workspace/Therapy/
├── lib/
│   ├── main.dart                           # Flutter entry point
│   ├── app/
│   │   └── app.dart                        # MaterialApp widget
│   ├── core/
│   │   ├── constants/
│   │   │   └── app_constants.dart          # API keys, models, URLs, theme
│   │   ├── errors/
│   │   │   └── app_exceptions.dart         # Custom exception classes
│   │   ├── extensions/
│   │   │   └── theme_extensions.dart       # Theme extension methods
│   │   ├── theme/
│   │   │   ├── app_colors.dart             # Color palette
│   │   │   └── app_theme.dart              # ThemeData factory
│   │   └── utils/
│   │       └── levenshtein.dart            # String distance for scoring
│   ├── data/
│   │   ├── database/                       # Floor ORM (sqflite)
│   │   │   ├── handa_database.dart         # DB definition
│   │   │   ├── handa_database.g.dart       # Generated
│   │   │   ├── daos/                       # Data Access Objects
│   │   │   ├── tables/                     # Table definitions
│   │   ├── datasources/
│   │   │   └── remote/
│   │   │       └── gemini_api_client.dart  # HTTP REST client (scoring + conversation)
│   │   ├── repositories/                   # Repository implementations
│   │   └── services/
│   │       ├── live_api_service.dart       # Gemini Live service wrapper
│   │       └── report_service.dart         # Session report generation
│   ├── domain/
│   │   ├── models/                         # Domain models
│   │   ├── repositories/                   # Repository interfaces
│   │   └── services/
│   │       └── scoring_engine.dart         # Score calculation logic
│   └── presentation/
│       ├── providers/                      # Riverpod providers
│       │   ├── database_provider.dart
│       │   ├── gemini_provider.dart
│       │   └── live_api_provider.dart
│       ├── router/
│       │   └── app_router.dart
│       ├── screens/                        # 11 screens
│       └── widgets/                        # Shared widgets
├── docs/                                   # Planning artifacts (24 files)
├── Project Plan/                           # Phase planning
└── test/                                   # Unit tests (empty)
```

### Key Interfaces

**`GeminiApiClient`** (lib/data/datasources/remote/gemini_api_client.dart):
- `evaluatePictureNaming()` — POST scoring to `{baseUrl}/models/{model}:generateContent?key={apiKey}`
- `liveConversation()` — POST streaming to `{baseUrl}/models/{model}:streamGenerateContent?alt=sse&key={apiKey}`
- `healthCheck()` — GET `{baseUrl}/models?key={apiKey}`
- Uses `GeminiApiKey` (`AIzaSyAoFNLv00RmHoJOmtzrQgIoEash3-CaEdI`)
- Base URL: `https://generativelanguage.googleapis.com/v1beta`
- Model: `gemini-2.5-flash-001`

**`LiveApiService`** (lib/data/services/live_api_service.dart):
- Wraps `GoogleGenAI` from the `gemini_live` package
- `connect()` — creates session with model, config, VAD, transcription, callbacks
- `sendText()`, `sendRealtimeText()`, `sendAudio()`, etc. — delegates to `LiveSession`
- Uses `AppConstants.geminiApiKey` and `AppConstants.liveApiModel`

**Current `AppConstants` outgoing config:**
- `geminiApiKey` = `'AIzaSyAoFNLv00RmHoJOmtzrQgIoEash3-CaEdI'` (Developer API key)
- `liveApiModel` = `'gemini-3.1-flash-live-preview'` (OUTDATED — should be `gemini-live-2.5-flash-native-audio`)
- `geminiApiBaseUrl` = `'https://generativelanguage.googleapis.com/v1beta'`

---

## 2. gemini_live Package (v2026.6.6) — Full Internal Map

**Location**: `/home/jay/.pub-cache/hosted/pub.dev/gemini_live-2026.6.6/`  
**Total**: 12 Dart source files, 3,574 lines

### 2.1 File Inventory

| File | Lines | Purpose |
|------|-------|---------|
| `lib/gemini_live.dart` | ~10 | Barrel re-export |
| `lib/src/google_genai.dart` | 85 | Top-level API class entry point |
| `lib/src/live_service.dart` | 551 | WebSocket lifecycle, message building, session management |
| `lib/src/client/api_client.dart` | 95 | HTTP POST client (Gemini API only) |
| `lib/src/model/models.dart` | 1546 | All model classes (44 snake_case, 5 camelCase, 19 incoming) |
| `lib/src/model/models.g.dart` | 1283 | Generated JSON serialization code |
| `lib/src/platform/web_socket_service_io.dart` | 16 | Native WebSocket connector (dart:io) |
| `lib/src/platform/web_socket_service_web.dart` | - | Web platform connector |
| `lib/src/platform/web_socket_service_stub.dart` | - | Stub for unimplemented platforms |
| `lib/src/platform/runtime_info_io.dart` | - | Dart version info |
| `lib/src/platform/runtime_info_web.dart` | - | Web runtime info |
| `lib/src/platform/runtime_info_stub.dart` | - | Stub |
| `lib/src/utils/wav_header.dart` | 60 | WAV header generator (adds 44-byte RIFF/WAV header to PCM) |

### 2.2 `GoogleGenAI` (google_genai.dart)

```dart
class GoogleGenAI {
  final String apiKey;
  final String apiVersion;     // default 'v1beta'
  final http.Client? httpClient;
  late final ApiClient _apiClient;
  late final LiveService live;
}
```

**Constructor**: Creates `ApiClient` + `LiveService` with `apiKey`.  
**No Vertex AI mode** — no `accessToken`, `baseUrl`, `project`, `location` params.

### 2.3 `LiveService` (live_service.dart)

**Fields:**
- `apiKey` (String)
- `apiVersion` (String, default `'v1beta'`)
- `logger` (Function?)
- `_connector` (WebSocketConnector — injected for platform)
- `_setupTimeout` (Duration, default 10s)

**`connect(LiveConnectParameters)` flow:**
1. Check if `apiKey.startsWith('auth_tokens/')` → uses Ephemeral token mode (v1alpha)
2. Build WebSocket URI:
   - Normal: `wss://generativelanguage.googleapis.com/ws/google.ai.generativelanguage.{version}.GenerativeService.BidiGenerateContent?key={apiKey}`
   - Ephemeral: `wss://...BidiGenerateContentConstrained?access_token={apiKey}`
3. Build headers: `Content-Type`, `x-goog-api-key`, `x-goog-api-client`, `user-agent`
4. Connect via `_connector(uri, headers)` → returns `WebSocketChannel`
5. Listen to `channel.stream`:
   - Calls `_handleWebSocketData(data, callbacks)` for each frame
   - On `data is String` → decode directly
   - On `data is List<int>` → `utf8.decode(data)`
   - Parses via `LiveServerMessage.fromJson(json)`
6. After connection, send setup via `session.sendMessage(setupMessage)`
7. Wait for `setupCompleter.future` (completed by first message) with timeout

**`_handleWebSocketData(dynamic data, LiveCallbacks callbacks)`**
- `data is String` → `jsonData = data`
- `data is List<int>` → `jsonData = utf8.decode(data)` (CURRENT — WILL FAIL on raw PCM audio)
- `else` → error callback
- Then: `jsonDecode(jsonData)` → `LiveServerMessage.fromJson(json)` → `callbacks.onMessage`

**`buildSetupMessage(LiveConnectParameters)` — Validation checks:**
- ❌ `sessionResumption.transparent == true` → throws
- ❌ `explicitVadSignal != null` → throws
- ❌ `inputAudioTranscription?.languageCodes != null` → throws `UnsupportedError("languageCodes parameter is not supported in Gemini API.")`
- ❌ `outputAudioTranscription?.languageCodes != null` → same throw
- ❌ `safetySettings.any(setting.method != null)` → throws
- ✅ Everything else → builds `LiveClientMessage(setup: LiveClientSetup(...))`
- `model` gets prefixed: `params.model` → `'models/{params.model}'`

**`_normalizeGenerationConfig(GenerationConfig?)`**
- If `responseModalities` is non-empty → use config as-is
- Else → add `responseModalities: [Modality.AUDIO]` as default

**`LiveSession` methods:**
- `sendMessage(LiveClientMessage)` → `jsonEncode(message.toJson())` → `_channel.sink.add(jsonString)` (TEXT FRAME)
- `sendText(String)` → builds `LiveClientMessage(clientContent: LiveClientContent(turns: [...], turnComplete: true))`
- `sendAudio(List<int>)` → base64 encodes → `realtimeInput.audio`
- `sendVideo(List<int>)` → base64 encodes → `realtimeInput.video`
- `sendRealtimeText(String)` → `realtimeInput.text`
- `sendClientContent({turns, turnComplete})`
- `sendToolResponse({functionResponses})`
- `sendFunctionResponse({id, name, response})`
- `sendActivityStart()` / `sendActivityEnd()`
- `sendAudioStreamEnd()`

### 2.4 `ApiClient` (api_client.dart)

```dart
class ApiClient {
  final String apiKey;
  final String? baseUrl;      // default: https://generativelanguage.googleapis.com
  final String apiVersion;    // default: 'v1beta'
  final http.Client _httpClient;
}
```

- `_buildUri(path)`: `{baseUrl}/{apiVersion}/{path}?key={apiKey}`
- `post(path, body)`: POST with `Content-Type: application/json`
- **No Bearer token support**, no `X-Goog-User-Project` header

### 2.5 `web_socket_service_io.dart`

```dart
Future<WebSocketChannel> connect(Uri uri, Map<String, dynamic> headers) async {
  final webSocket = await WebSocket.connect(uri.toString(), headers: headers);
  return IOWebSocketChannel(webSocket);
}
```

- **Already supports custom headers** ✅
- Connects via `WebSocket.connect(uri, headers: headers)` which sends HTTP Upgrade with headers

### 2.6 Model Serialization Analysis

**44 classes with `fieldRename: FieldRename.snake`** → output snake_case JSON keys (WRONG for Vertex AI)

**5 classes with NO fieldRename (camelCase default)** → output camelCase JSON (CORRECT for Vertex AI):
- `Part` (line 357) — camelCase ✅
- `Blob` (line 397) — camelCase ✅
- `LiveClientMessage` (line 1204) — camelCase ✅ (top-level wrapper)
- `ExecutableCode` (line 1252) — camelCase ✅
- `CodeExecutionResult` (line 1267) — camelCase ✅

**19 incoming-only classes with `createToJson: false` + no fieldRename** → read camelCase (CORRECT):
- `LiveServerSetupComplete` — `sessionId`
- `Transcription` — `text`, `finished`
- `LiveServerContent` — `modelTurn`, `turnComplete`, `interrupted`, `inputTranscription`, `outputTranscription`, etc.
- `LiveServerToolCall` — `functionCalls`
- `LiveServerToolCallCancellation` — `ids`
- `LiveServerGoAway` — `timeLeft`, `reason`
- `LiveServerSessionResumptionUpdate` — `newHandle`, `resumable`, `lastConsumedClientMessageIndex`
- `VoiceActivityDetectionSignal` — `vadSignalType`
- `VoiceActivity` — `voiceActivityType`
- `ModalityTokenCount` — `modality`, `tokenCount`
- `UsageMetadata` — `promptTokenCount`, `cachedContentTokenCount` (note: uses `@JsonKey` for individual fields!)
- `LiveServerMessage` — `setupComplete`, `serverContent`, `usageMetadata`, etc.

**Critical snake_case outputs (WRONG for Vertex AI):**
| Class | Dart Field → Output JSON key |
|-------|------------------------------|
| `GenerationConfig` | `responseModalities` → `response_modalities` |
| `SpeechConfig` | `voiceConfig` → `voice_config` |
| `VoiceConfig` | `prebuiltVoiceConfig` → `prebuilt_voice_config` |
| `PrebuiltVoiceConfig` | `voiceName` → `voice_name` |
| `AudioTranscriptionConfig` | `languageCodes` → `language_codes` |
| `RealtimeInputConfig` | `automaticActivityDetection` → `automatic_activity_detection` |
| `AutomaticActivityDetection` | `startOfSpeechSensitivity` → `start_of_speech_sensitivity` |
| `LiveClientSetup` | `generationConfig` → `generation_config` |
| `LiveClientContent` | `turnComplete` → `turn_complete` |
| `Content` | `parts` → `parts` (already camelCase) |
| `FunctionDeclaration` | `parameters` → `parameters` (already camelCase) |
| ... and 30+ more |

### 2.7 wav_header.dart

```dart
Uint8List addWavHeader(Uint8List pcmBytes, {sampleRate, numChannels=1, bitsPerSample=16})
```

Builds standard 44-byte RIFF/WAV header. Used to wrap raw PCM for local playback.

---

## 3. Vertex AI Live Protocol Reference

### 3.1 Endpoints

| Component | URL |
|-----------|-----|
| WebSocket | `wss://{LOCATION}-aiplatform.googleapis.com/ws/google.cloud.aiplatform.v1beta1.LlmBidiService/BidiGenerateContent` |
| REST scoring | `https://{LOCATION}-aiplatform.googleapis.com/v1beta1/projects/{PROJECT}/locations/{LOCATION}/publishers/google/models/{MODEL}:generateContent` |
| REST streaming | `https://{LOCATION}-aiplatform.googleapis.com/v1beta1/projects/{PROJECT}/locations/{LOCATION}/publishers/google/models/{MODEL}:streamGenerateContent` |

### 3.2 Correct Models

| Model | Purpose | Notes |
|-------|---------|-------|
| `gemini-live-2.5-flash-native-audio` | Live voice (WebSocket) | Audio-native — no TEXT modality. Used by Agent Builder. **THIS IS THE CORRECT MODEL.** |
| `gemini-3.1-flash-lite-preview` | Text scoring (HTTP REST) | For `evaluatePictureNaming`. Confirmed working at `global` location. |
| ~~`gemini-3.1-flash-live-preview`~~ | Live voice | OLD model — deprecated in Agent Builder code |
| ~~`gemini-3.1-flash-live-001`~~ | Live voice | Rejected by server |

### 3.3 Full Model Path (for Vertex AI WS)

```
projects/biz-studio-1779528000/locations/us-central1/publishers/google/models/gemini-live-2.5-flash-native-audio
```

### 3.4 Auth (WebSocket)

```
Headers:
  Authorization: Bearer {oauth2_token}
  X-Goog-User-Project: biz-studio-1779528000    ← billing project (required!)
  Content-Type: application/json
  x-goog-api-client: google-genai-sdk/2.6.0 dart/3.x
```

**Token source**: `gcloud auth application-default print-access-token`  
**Token lifetime**: ~1 hour (60 min). Need auto-refresh.  
**ADC quota project**: `gcloud auth application-default set-quota-project biz-studio-1779528000`

### 3.5 Wire Protocol

**Framing**: ALL messages are **binary WebSocket frames (opcode 2)**. No text frames.

**Content detection** (by first byte 0x7b = `{`):
- JSON messages start with `{` → UTF-8 decode → `LiveServerMessage.fromJson()`
- Audio data starts with non-`{` → raw PCM (16-bit LE, 24kHz, mono)

**Audio format** (per official docs):
- **Input** (client → server): 16-bit PCM, 16000 Hz, little-endian, mono
- **Output** (server → client): 16-bit PCM, 24000 Hz, little-endian, mono

### 3.6 Client Messages (camelCase)

**Setup** (first message after connection):
```json
{
  "setup": {
    "model": "projects/{PROJECT}/locations/{LOCATION}/publishers/google/models/{MODEL}",
    "generationConfig": {
      "responseModalities": ["AUDIO"],
      "temperature": 0.7,
      "speechConfig": {
        "voiceConfig": {
          "prebuiltVoiceConfig": {
            "voiceName": "puck"
          }
        }
      }
    },
    "systemInstruction": {
      "parts": [{"text": "You are Thilina..."}]
    },
    "tools": [...],
    "realtimeInputConfig": {
      "automaticActivityDetection": {
        "disabled": false,
        "startOfSpeechSensitivity": "START_SENSITIVITY_HIGH",
        "endOfSpeechSensitivity": "END_SENSITIVITY_LOW",
        "prefixPaddingMs": 300,
        "silenceDurationMs": 600
      },
      "activityHandling": "START_OF_ACTIVITY_INTERRUPTS"
    },
    "inputAudioTranscription": {},
    "outputAudioTranscription": {}
  }
}
```

**`clientContent`** (send text as a user turn):
```json
{
  "clientContent": {
    "turns": [{"parts": [{"text": "Hello"}], "role": "user"}],
    "turnComplete": true
  }
}
```

**`realtimeInput`** (send audio/text chunks):
```json
{
  "realtimeInput": {
    "audio": {"mimeType": "audio/pcm;rate=16000", "data": "{base64}"}
  }
}
```

**`realtimeInput` with text** (injects text into user turn without stopping audio):
```json
{
  "realtimeInput": {
    "text": "context: patient is struggling with /r/ sounds"
  }
}
```

**`toolResponse`** (function call result):
```json
{
  "toolResponse": {
    "functionResponses": [{
      "id": "{callId}",
      "name": "show_breathing_widget",
      "response": {"status": "success"}
    }]
  }
}
```

### 3.7 Server Messages (camelCase)

**`setupComplete`**:
```json
{"setupComplete": {"sessionId": "..."}}
```

**`serverContent` with inline audio (JSON mode — auto-response)**:
```json
{
  "serverContent": {
    "modelTurn": {
      "parts": [{
        "inlineData": {
          "mimeType": "audio/wav",
          "data": "{base64-encoded-audio}"
        }
      }]
    }
  }
}
```

**`serverContent` with text**:
```json
{
  "serverContent": {
    "modelTurn": {
      "parts": [{"text": "Hello, how can I help?"}]
    }
  }
}
```

**`serverContent` turn completion**:
```json
{
  "serverContent": {
    "turnComplete": true
  }
}
```

**`serverContent` with transcription (when outputAudioTranscription enabled)**:
```json
{
  "serverContent": {
    "outputTranscription": {"text": "Hello world", "finished": true}
  }
}
```

**`toolCall`** (function call request):
```json
{
  "toolCall": {
    "functionCalls": [{"id": "...", "name": "show_breathing_widget", "args": {...}}]
  }
}
```

**`usageMetadata`**:
```json
{
  "usageMetadata": {
    "promptTokenCount": 42,
    "responseTokenCount": 128,
    "totalTokenCount": 170
  }
}
```

### 3.8 Response Modes

Two distinct modes observed:

**Mode 1 — JSON mode** (auto-response to system instruction):
- The model speaks first (triggered by system instruction)
- Audio is embedded as base64 in `serverContent.modelTurn.parts[].inlineData`
- All messages are binary JSON frames
- No separate raw audio frames

**Mode 2 — Binary mode** (response to `clientContent`):
- The model responds after receiving `clientContent` with `turnComplete: true`
- Audio is sent as separate raw binary frames (PCM)
- `serverContent` JSON messages bookend the audio: one at start (with `modelTurn` describing), one at end (with `turnComplete`)
- Audio frames CANNOT be decoded as JSON (they're raw binary)

### 3.9 Transcription Config Issues

**`outputAudioTranscription: {}`** (empty object):
- ✅ Server accepts
- ❌ Server stops sending `serverContent` JSON messages entirely
- Only raw audio binary frames received
- Hypothesis: transcription changes the output format completely — server uses different message types

**`outputAudioTranscription: { languageCodes: ["en-US"] }`**:
- ❌ Entire setup rejected with error mentioning "model"
- Root cause unknown — may need different API version or config nesting

**Official docs**: `AudioTranscriptionConfig` type has "no fields" per the API reference
**SDK shows**: `languageCodes` (array of strings)
**Field name guess**: `languageCodes` (plural camelCase) vs `language_code` (singular snake_case) vs `languageCodes` as documented by SDK type

### 3.10 VAD Configuration

Key sensitivity mapping needs correction:
- `startOfSpeechSensitivity`: `START_SENSITIVITY_HIGH` = 0 (most sensitive / easiest to trigger)
- `endOfSpeechSensitivity`: `END_SENSITIVITY_LOW` = 0 (least sensitive / hardest to trigger / waits longer)

---

## 4. Test Results & Empirical Findings

### 4.1 ADC Auth Discovery

**Problem**: All API calls were returning 403/401 despite valid API key  
**Root cause**: Active gcloud account was `rahaneyt@gmail.com` (zero IAM permissions)  
**Owner account**: `mamanniggajay@gmail.com` (`roles/owner` on `biz-studio-1779528000`)  
**Fix**: `gcloud auth application-default set-quota-project biz-studio-1779528000`

### 4.2 WebSocket Connection Test (test_correct.js)

**What worked**:
- WebSocket connection to `wss://us-central1-aiplatform.googleapis.com/ws/google.cloud.aiplatform.v1beta1.LlmBidiService/BidiGenerateContent`
- Bearer token auth with `Authorization` + `X-Goog-User-Project` headers
- `setupComplete` received as binary JSON frame
- `clientContent` with `turns` + `turnComplete: true` triggers model response
- Model outputs raw PCM audio as binary frames

**Frame analysis**:
- All frames are binary (opcode 2)
- JSON starts with `{` (byte 0x7b = 123 decimal)
- Audio frames vary in size (4KB-16KB+)

**Supported setup fields** (camelCase):
- `model` ✅
- `generationConfig` ✅  
- `systemInstruction` ✅
- `tools` ✅
- `realtimeInputConfig` ✅
- `responseModalities` → NOT at setup level (goes under `generationConfig`)

**Rejected setup fields**:
- `responseModalities` at setup root (should be in `generationConfig`)
- `outputAudioTranscription: { languageCodes: ["en-US"] }` — entire setup rejected

### 4.3 API Key vs Bearer Token

| Method | Status | Notes |
|--------|--------|-------|
| API key in query param (`?key=`) | ❌ | Vertex AI doesn't accept |
| API key in header | ❌ | Vertex AI doesn't accept |
| Bearer token | ✅ | Requires `X-Goog-User-Project` |
| Vertex AI Express | ❌ | Requires console signup |
| gcloud ADC | ✅ | `gcloud auth application-default print-access-token` |

### 4.4 Server Locations

| Location | REST Status | WS Status |
|----------|-------------|-----------|
| `global` | ✅ (`gemini-3.1-flash-lite-preview`) | ❌ (rejected) |
| `us-central1` | — | ✅ (Agent Builder rewrites global → us-central1) |

---

## 5. Agent Builder Reference Implementation

**Source**: `/home/jay/Downloads/gemini-voice-chat.zip` → extracted to `/tmp/gemini-voice-chat/`

### 5.1 Backend (`/tmp/gemini-voice-chat/backend/server.js`)

```javascript
// WebSocket proxy: /api/live → Vertex AI Live
app.get('/api/live', (req, res) => {
  // Rewrites `global` to `us-central1` for Live endpoint
  const targetHost = 'us-central1-aiplatform.googleapis.com';
  
  // URL rewrites to full model path with OAuth2
  const targetUrl = rewriteUrl(
    originalUrl,
    `/ws/google.cloud.aiplatform.v1beta1.LlmBidiService/BidiGenerateContent`,
    { project, location, model }
  );
  
  // Adds Bearer token + User-Project header
  proxy.web(req, res, {
    target: `wss://${targetHost}`,
    headers: {
      'Authorization': `Bearer ${token}`,
      'X-Goog-User-Project': projectId,
      'Content-Type': 'application/json'
    }
  });
});
```

**Model**: `gemini-live-2.5-flash-native-audio`  
**No `responseModalities`** in the setup — model defaults to audio output when this model is used.

### 5.2 Frontend TypeScript SDK (`/tmp/gemini-voice-chat/frontend/services/geminiLive.ts`)

```typescript
import { GoogleGenAI } from '@google/genai';

const ai = new GoogleGenAI({ 
  apiKey: '...',
  vertexai: true,  // ← Enables Vertex AI mode in JS SDK
  project: 'biz-studio-1779528000',
  location: 'us-central1'
});
```

Uses camelCase field names throughout.

---

## 6. Fork Plan — Summary of ALL Changes Needed

### 6.1 Overview

Fork `gemini_live` v2026.6.6 into `lib/data/services/gemini_live_fork/` and modify 6 files:

| File | Change | Complexity |
|------|--------|-----------|
| `google_genai.dart` | Add `accessToken`, `baseUrl`, `project`, `location` params | Low |
| `live_service.dart` | Binary frame handler, OAuth2 auth, Vertex URL, camelCase conversion | High |
| `api_client.dart` | Bearer token auth, Vertex endpoint | Medium |
| `models.dart` | Remove `fieldRename: FieldRename.snake` from 44 classes | Medium |
| `models.g.dart` | Change all snake_case JSON keys to camelCase (1283 lines) | High |
| `wav_header.dart` | No change needed | None |

### 6.2 Detailed Changes

#### `google_genai.dart`
```dart
class GoogleGenAI {
  final String? accessToken;        // NEW
  final String? baseUrl;            // NEW — Vertex AI base
  final String? project;            // NEW — GCP project ID
  final String? location;           // NEW — GCP location
  final String apiKey;              // existing — optional for Vertex mode
  
  GoogleGenAI({
    String? accessToken,            // NEW
    String? baseUrl,                // NEW
    String? project,                // NEW  
    String? location,               // NEW
    String? apiKey,                 // now optional
    ... 
  }) {
    _apiClient = ApiClient(
      accessToken: accessToken,     // NEW
      baseUrl: baseUrl,             // NEW
      apiKey: apiKey,
      ...
    );
    live = LiveService(
      accessToken: accessToken,     // NEW
      baseUrl: baseUrl,             // NEW
      project: project,             // NEW
      location: location,           // NEW
      apiKey: apiKey,
      ...
    );
  }
}
```

#### `live_service.dart` — 4 major changes:

**Change 1: Connect URL**
```dart
if (_accessToken != null) {
  // Vertex AI mode
  websocketUri = Uri(
    scheme: 'wss',
    host: '$_location-aiplatform.googleapis.com',
    path: '/ws/google.cloud.aiplatform.v1beta1.LlmBidiService/BidiGenerateContent',
  );
} else {
  // Original Gemini mode
  websocketUri = Uri(...keyName: apiKey...);
}
```

**Change 2: Headers**
```dart
final headers = <String, String>{...};
if (_accessToken != null) {
  headers['Authorization'] = 'Bearer $_accessToken';
  headers['X-Goog-User-Project'] = _project!;
}
headers['x-goog-api-key'] = apiKey;  // keep for Gemini mode
```

**Change 3: Binary frame handler**
```dart
void _handleWebSocketData(dynamic data, LiveCallbacks callbacks) {
  if (data is List<int>) {
    if (data.isNotEmpty && data[0] == 0x7b) {  // JSON starts with '{'
      // It's a JSON message
      final jsonString = utf8.decode(data);
      try {
        final json = jsonDecode(jsonString);
        final message = LiveServerMessage.fromJson(json);
        callbacks.onMessage?.call(message);
      } catch (e, st) { callbacks.onError?.call(e, st); }
    } else {
      // It's raw PCM audio — forward to audio callback
      _onAudioData?.call(data);
    }
  } else {
    // Original String handling for Gemini API
    ...tryParseJson...
  }
}
```

**Change 4: Model name**
```dart
if (_accessToken != null) {
  modelName = 'projects/$_project/locations/$_location/publishers/google/models/$model';
} else {
  modelName = model.startsWith('models/') ? model : 'models/$model';
}
```

**Change 5: camelCase JSON conversion in `sendMessage`**
```dart
void sendMessage(LiveClientMessage message) {
  final jsonMap = message.toJson();
  final camelCaseJson = _convertKeysToCamelCase(jsonMap);  // NEW
  final jsonString = jsonEncode(camelCaseJson);
  _channel.sink.add(jsonString);
}

// Recursive snake_case → camelCase key converter
Map<String, dynamic> _convertKeysToCamelCase(Map<String, dynamic> map) {
  final result = <String, dynamic>{};
  for (final entry in map.entries) {
    final camelKey = entry.key.replaceAllMapped(
      RegExp(r'_([a-z])'),
      (m) => m.group(1)!.toUpperCase(),
    );
    final value = entry.value;
    if (value is Map<String, dynamic>) {
      result[camelKey] = _convertKeysToCamelCase(value);
    } else if (value is List) {
      result[camelKey] = value.map((e) {
        if (e is Map<String, dynamic>) return _convertKeysToCamelCase(e);
        return e;
      }).toList();
    } else {
      result[camelKey] = value;
    }
  }
  return result;
}
```

**Change 6: Audio data callback**
```dart
class LiveService {
  void Function(List<int> audioData)? onAudioData;  // NEW
  
  // In connect():
  streamSubscription = channel.stream.listen((data) {
    if (data is List<int> && data.isNotEmpty && data[0] != 0x7b) {
      // Raw audio frame — forward directly
      onAudioData?.call(data);
      return;
    }
    _handleWebSocketData(data, params.callbacks);
  });
}
```

**Change 7: Remove `languageCodes` error throw**
```dart
// Remove or conditionalize:
if (params.inputAudioTranscription?.languageCodes != null) {
  if (_accessToken == null) throw _unsupportedAudioTranscriptionLanguageCodesError();
  // For Vertex AI, allow languageCodes
}
```

#### `api_client.dart`

```dart
class ApiClient {
  final String? accessToken;
  final String? project;
  final String? location;
  
  Uri _buildUri(String path) {
    if (accessToken != null) {
      // Vertex AI endpoint
      return Uri.parse(
        'https://$location-aiplatform.googleapis.com/$apiVersion/projects/$project/locations/$location/$path'
      );
    } else {
      final base = baseUrl ?? 'https://generativelanguage.googleapis.com';
      return Uri.parse('$base/$apiVersion/$path?key=$apiKey');
    }
  }
  
  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final uri = _buildUri(path);
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
      headers['X-Goog-User-Project'] = project!;
    }
    final response = await _httpClient.post(uri, headers: headers, body: jsonEncode(body));
    ...
  }
}
```

#### `models.dart` + `models.g.dart`

**For models.dart**: Remove `fieldRename: FieldRename.snake` from all 44 annotations:
```diff
- @JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
+ @JsonSerializable(includeIfNull: false)
```

**For models.g.dart**: Change all JSON key strings from snake_case to camelCase.
- `'response_modalities'` → `'responseModalities'`
- `'voice_name'` → `'voiceName'`
- `'generation_config'` → `'generationConfig'`
- `'system_instruction'` → `'systemInstruction'`
- `'turn_complete'` → `'turnComplete'`
- `'input_audio_transcription'` → `'inputAudioTranscription'`
- `'output_audio_transcription'` → `'outputAudioTranscription'`
- `'realtime_input_config'` → `'realtimeInputConfig'`
- `'automatic_activity_detection'` → `'automaticActivityDetection'`
- `'start_of_speech_sensitivity'` → `'startOfSpeechSensitivity'`
- ... (40+ more key renames)

**Alternative**: Instead of editing `.g.dart`, use runtime key conversion in `sendMessage()` (see Change 5 above). This avoids touching `.g.dart` entirely but adds runtime overhead of key walking on every send.

**Recommended approach**: Use BOTH:
1. Fix `.g.dart` for static correctness (compile-time guarantee)
2. Keep runtime converter as safety net for any missed keys

### 6.3 OAuth2 Token Provider

Service to auto-refresh tokens (since they expire ~60 min):

```dart
class AccessTokenProvider {
  Timer? _refreshTimer;
  String? _currentToken;
  DateTime? _expiresAt;
  
  Future<String> getToken() async {
    if (_currentToken != null && _expiresAt != null && DateTime.now().isBefore(_expiresAt!)) {
      return _currentToken!;
    }
    return _refresh();
  }
  
  Future<String> _refresh() async {
    final result = await Process.run(
      'gcloud', ['auth', 'application-default', 'print-access-token'],
    );
    _currentToken = result.stdout.toString().trim();
    _expiresAt = DateTime.now().add(const Duration(minutes: 55));
    _scheduleRefresh(Duration(minutes: 50));
    return _currentToken!;
  }
}
```

Alternative: Use `googleapis_auth` Dart package for proper OAuth2 client credentials flow.

### 6.4 Vertex AI REST Scoring Path

For `GeminiApiClient.evaluatePictureNaming()`:

```
POST https://us-central1-aiplatform.googleapis.com/v1beta1/projects/biz-studio-1779528000/locations/us-central1/publishers/google/models/gemini-2.5-flash-001:generateContent
Authorization: Bearer {token}
X-Goog-User-Project: biz-studio-1779528000
```

---

## 7. AURA Architecture Guide

**Source**: `/home/jay/Downloads/AURA_Vertex_AI_Implementation_Guide.md`

### 7.1 System Prompt (Thilina Persona)

```
You are Thilina (තිළිණ), a friendly speech therapy companion from Sri Lanka.
You speak Sinhala (සිංහල) with patients. You're patient, encouraging, and warm.
Your patient is recovering from a stroke and has aphasia/apraxia.

Core rules:
1. Speak slowly, use simple sentences, pause often
2. One question at a time
3. Always praise effort before correction
4. Never say "wrong" or "incorrect"
5. If you don't understand, gently ask them to repeat
6. Use the patient's name and remember their progress
```

### 7.2 Function Declarations (11 total)

| Function | Purpose |
|----------|---------|
| `show_breathing_widget` | Start 4-7-8 box breathing exercise |
| `show_naming_exercise` | Show picture naming exercise (image + cue) |
| `provide_cue` | Provide a cue from the cueing ladder (verbal/phonemic/syllabic/visual) |
| `show_text_display` | Show text content (instructions, encouragement) |
| `show_report` | Display session summary report |
| `play_audio_example` | Play correct pronunciation example |
| `record_attempt` | Record patient's attempt for scoring |
| `update_session_memory` | Update long-term memory (patient progress, struggles) |
| `adjust_difficulty` | Increase/decrease exercise difficulty |
| `call_caregiver_alert` | Notify caregiver of distress or significant progress |
| `end_session` | End the session and generate report |

### 7.3 Background Agent Design

A secondary, silent agent runs in parallel to:
1. Maintain session context (patient's emotional state, fatigue, progress)
2. Inject contextual cues via `realtimeInput.text` (invisible to patient)
3. Track function call history and response patterns
4. Suggest next actions to the main agent via memory updates

Implementation: A separate `clientContent` stream with `role: "system"` or injected via `realtimeInput.text`.

### 7.4 Cueing Ladder (4 levels)

| Level | Name | Description |
|-------|------|-------------|
| 0 | No cue | Let patient try independently |
| 1 | Verbal | "It starts with the sound /k/..." |
| 2 | Phonemic | Say the first syllable |
| 3 | Syllabic | Break word into syllables |
| 4 | Visual | Show image or mouth movement |

### 7.5 Breathing Protocol (4-7-8)

| Phase | Duration | Action |
|-------|----------|--------|
| Inhale | 4 seconds | Breathe in through nose |
| Hold | 7 seconds | Hold breath |
| Exhale | 8 seconds | Breathe out through mouth |

---

## 8. Decision Log

| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-06-10 | Use `gemini-live-2.5-flash-native-audio` | Agent Builder reference uses it. Audio-native avoids `responseModalities` issues. |
| 2026-06-10 | Use `us-central1` location | Agent Builder rewrites `global` → `us-central1`. `global` WS rejected. |
| 2026-06-10 | OAuth2 Bearer token auth (not API key) | Vertex AI requires ADC/OAuth2. API key rejected. `X-Goog-User-Project` mandatory. |
| 2026-06-10 | CamelCase JSON wire format | Server sends `setupComplete` (not `setup_complete`). All official docs use camelCase. |
| 2026-06-10 | Fork `gemini_live` package (don't use as-is) | 3 breaking mismatches: snake_case serialization, text frames expectation, languageCodes error |
| 2026-06-10 | Binary frame protocol for Vertex AI | All WS messages are binary (opcode 2). JSON detected by `{` first byte. |
| 2026-06-10 | `outputAudioTranscription: {}` works but changes response format | Empty config accepted but server stops sending `serverContent` JSON during streaming |
| 2026-06-10 | Model split: Live for voice, REST for scoring | `gemini-live-2.5-flash-native-audio` is audio-native, can't do text. Text REST is reliable. |
| 2026-06-10 | No `responseModalities` in setup | Audio-native model defaults to audio. Omission works; inclusion may cause issues. |

---

## 9. Complete pubspec.yaml & Dependency Analysis

**File**: `/home/jay/Workspace/Therapy/pubspec.yaml` (105 lines)

### 9.1 App Metadata
```yaml
name: handa
description: "Handa (හඬ) - Stroke speech rehabilitation app for Sinhala speakers"
version: 1.0.0+1
environment:
  sdk: ^3.7.2
```

### 9.2 Dependencies by Category

**State Management**:
| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_riverpod` | ^2.6.1 | Reactive state management |
| `riverpod_annotation` | ^2.6.1 | Code-gen for Riverpod |

**Navigation**:
| Package | Version | Purpose |
|---------|---------|---------|
| `go_router` | ^14.8.1 | Declarative routing |

**Database (SQLite via Drift/floor)**:
| Package | Version | Purpose |
|---------|---------|---------|
| `drift` | ^2.25.1 | SQLite ORM (used over floor) |
| `sqlite3_flutter_libs` | ^0.5.28 | Native sqlite3 libs |
| `path_provider` | ^2.1.5 | File paths for DB storage |
| `sqlite3` | ^2.7.4 | SQLite dart bindings |

**Networking**:
| Package | Version | Purpose |
|---------|---------|---------|
| `http` | ^1.3.0 | HTTP client (Gemini REST API) |
| `web_socket_channel` | ^3.0.2 | WebSocket abstraction |
| `connectivity_plus` | ^6.1.2 | Network status detection |

**Serialization**:
| Package | Version | Purpose |
|---------|---------|---------|
| `json_annotation` | ^4.12.0 | JSON serialization annotations |
| `uuid` | ^4.5.1 | UUID generation |
| `equatable` | ^2.0.7 | Value equality |
| `collection` | ^1.19.1 | Collection utilities |

**Charts**:
| Package | Version | Purpose |
|---------|---------|---------|
| `fl_chart` | ^0.70.2 | Flutter charting library |

**PDF Export**:
| Package | Version | Purpose |
|---------|---------|---------|
| `pdf` | ^3.11.2 | PDF generation |
| `printing` | ^5.14.2 | PDF printing |
| `share_plus` | ^10.1.4 | Share sheet integration |

**Audio**:
| Package | Version | Purpose |
|---------|---------|---------|
| `record` | ^5.2.0 | Microphone recording |
| `flutter_tts` | ^4.2.2 | Text-to-speech |
| `audioplayers` | ^6.4.0 | Audio playback |

**Live API**:
| Package | Version | Purpose |
|---------|---------|---------|
| `gemini_live` | ^2026.6.6 | **THE PACKAGE WE'RE FORKING** |

**Security**:
| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_secure_storage` | ^9.2.4 | Secure credential storage |
| `crypto` | ^3.0.6 | Hashing utilities |

**UI Helpers**:
| Package | Version | Purpose |
|---------|---------|---------|
| `scroll_to_hide` | ^1.0.2 | Hide UI on scroll |

### 9.3 Dependency Overrides
```yaml
dependency_overrides:
  json_annotation: ^4.12.0
  record_linux: 1.3.1
  record_platform_interface: 1.5.0
  flutter_tts: 4.2.0
```

### 9.4 Dev Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `drift_dev` | ^2.25.1 | Drift code generator |
| `build_runner` | ^2.4.15 | Dart code gen runner |
| `json_serializable` | ^6.9.4 | JSON code gen |
| `riverpod_generator` | ^2.6.3 | Riverpod code gen |
| `flutter_lints` | ^5.0.0 | Lint rules |
| `mocktail` | ^1.0.4 | Mocking for tests |

### 9.5 Assets & Fonts
```yaml
assets:
  - assets/images/
  - assets/audio/
  - assets/categories/

fonts:
  - family: NotoSansSinhala
    fonts:
      - asset: assets/fonts/NotoSansSinhala[wdth,wght].ttf
        weight: 400
      - asset: assets/fonts/NotoSansSinhala[wdth,wght].ttf
        weight: 700
```

### 9.6 Key Version Constraints
- `gemini_live` v2026.6.6 depends on: `web_socket_channel ^3.0.0`, `http ^1.0.0`, `json_annotation ^4.0.0`, `web ^1.0.0`
- `record` v5.2.0 depends on: `record_linux 1.3.1` (overridden), `record_platform_interface 1.5.0` (overridden)
- `flutter_tts` pinned to 4.2.0 (overridden due to 4.3.x incompatibility)

---

## 10. Floor Database Schema (Drift ORM)

**File**: `/home/jay/Workspace/Therapy/lib/data/database/`

### 10.1 Tables Overview

| Table | File | Columns | Primary Key | Foreign Keys |
|-------|------|---------|-------------|--------------|
| `Sessions` | `sessions_table.dart` | 7 | `id` (auto-increment) | — |
| `Attempts` | `attempts_table.dart` | 9 | `id` (auto-increment) | `sessionId → Sessions`, `exerciseId → Exercises` |
| `Exercises` | `exercises_table.dart` | 8 | `id` (auto-increment) | `categoryId → Categories` |
| `Categories` | `categories_table.dart` | 9 | `id` (auto-increment) | — |
| `LiveConversations` | `live_conversations_table.dart` | 8 | `id` (auto-increment) | `sessionId → Sessions` |
| `AppSettings` | `settings_table.dart` | 3 | `key` (text, composite) | — |
| `SyncLog` | `sync_log_table.dart` | 6 | `id` (auto-increment) | — |

### 10.2 Sessions Table
```dart
class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get type => text()();                          // 'picture_naming' | 'conversation' | 'breathing'
  IntColumn get totalExercises => integer().withDefault(const Constant(0))();
  IntColumn get completedExercises => integer().withDefault(const Constant(0))();
  RealColumn get averageScore => real().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
```

### 10.3 Attempts Table
```dart
class Attempts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(Sessions, #id)();
  IntColumn get exerciseId => integer().references(Exercises, #id).nullable()();
  TextColumn get userResponse => text()();                  // STT transcript of user's spoken attempt
  TextColumn get expectedAnswer => text()();                // Correct target word
  RealColumn get scorePercentage => real()();               // 0.0–100.0
  TextColumn get scoreLevel => text()();                    // 'excellent'|'good'|'almost'|'try_again'
  IntColumn get responseTimeMs => integer().nullable()();
  BoolColumn get isOffline => boolean().withDefault(const Constant(false))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
```

### 10.4 Exercises Table
```dart
class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  TextColumn get imagePath => text()();                     // Local WebP image path
  TextColumn get targetWordSi => text()();                  // Sinhala target word
  TextColumn get targetWordTa => text()();                  // Tamil target word
  TextColumn get targetWordEn => text()();                  // English target word
  TextColumn get phoneticHint => text().nullable()();
  IntColumn get difficulty => integer().withDefault(const Constant(1))();  // 1–5
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
```

### 10.5 Categories Table
```dart
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nameSi => text()();                        // Sinhala name
  TextColumn get nameTa => text()();                        // Tamil name  
  TextColumn get nameEn => text()();                        // English name
  TextColumn get descriptionSi => text()();                 // Sinhala description
  TextColumn get descriptionTa => text()();                 // Tamil description
  TextColumn get descriptionEn => text()();                 // English description
  TextColumn get icon => text()();                          // Material icon name
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
```

### 10.6 LiveConversations Table
```dart
class LiveConversations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(Sessions, #id)();
  TextColumn get exerciseType => text()();                  // 'category_naming' | 'letter_fluency'
  IntColumn get durationSeconds => integer()();
  TextColumn get userTranscript => text()();                // User's speech transcript
  TextColumn get aiFeedback => text()();                    // AI response text
  RealColumn get score => real().nullable()();              // Optional score
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
```

### 10.7 AppSettings Table (key-value)
```dart
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  @override Set<Column> get primaryKey => {key};
}
```

### 10.8 SyncLog Table
```dart
class SyncLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text()();                    // 'session'|'attempt'|'live_conversation'
  IntColumn get recordId => integer()();
  TextColumn get action => text()();                        // 'insert' | 'update' | 'delete'
  DateTimeColumn get syncedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get status => text().withDefault(const Constant('pending'))();  // 'pending'|'synced'|'failed'
}
```

### 10.9 Database Definition
**File**: `/home/jay/Workspace/Therapy/lib/data/database/handa_database.dart`
```dart
@DriftDatabase(tables: [
  Sessions, Attempts, Exercises, Categories, LiveConversations, AppSettings, SyncLog
])
class HandaDatabase extends _$HandaDatabase { ... }
```

### 10.10 DAOs

| DAO | File | Key Operations |
|-----|------|----------------|
| `SessionDao` | `session_dao.dart` | `createSession`, `completeSession`, `getSessionById`, `getSessionsByDateRange` |
| `AttemptDao` | `attempt_dao.dart` | `saveAttempt`, `getAttemptsBySession`, `getAttemptsByExercise` |
| `ExerciseDao` | `exercise_dao.dart` | `getExercisesByCategory`, `getExerciseById` |
| `CategoryDao` | `category_dao.dart` | `getAllCategories`, `getCategoryById` |
| `LiveConversationDao` | `live_conversation_dao.dart` | `saveConversation`, `getConversationsBySession` |
| `SettingsDao` | `settings_dao.dart` | `getSetting`, `setSetting`, `getAllSettings` |

---

## 11. All Domain Models

### 11.1 Session
```dart
class Session {
  final int id;
  final DateTime startedAt;
  final DateTime? completedAt;
  final String type;           // 'picture_naming' | 'conversation' | 'breathing'
  final int totalExercises;
  final int completedExercises;
  final double? averageScore;
  final bool isSynced;
  bool get isCompleted => completedAt != null;
  Duration get duration => (completedAt ?? DateTime.now()).difference(startedAt);
}
```

### 11.2 Attempt
```dart
class Attempt {
  final int id, sessionId,? exerciseId;
  final String userResponse;     // What user actually said (STT)
  final String expectedAnswer;   // Correct target word
  final double scorePercentage;  // 0–100
  final String scoreLevel;       // 'excellent'|'good'|'almost'|'try_again'
  final int? responseTimeMs;
  final bool isOffline, isSynced;
  final DateTime createdAt;
  bool get isPassing => !isTryAgain;
}
```

### 11.3 Exercise
```dart
class Exercise {
  final int id, categoryId, difficulty;
  final String imagePath;        // Local WebP
  final String targetWordSi, targetWordTa, targetWordEn;
  final String? phoneticHint;
  final bool isActive;
  String targetWordIn(String languageCode);  // Returns target word by language
}
```

### 11.4 Category
```dart
class Category {
  final int id, sortOrder;
  final String nameSi, nameTa, nameEn;
  final String descriptionSi, descriptionTa, descriptionEn;
  final String icon;
  final bool isActive;
  String nameIn(String languageCode);
  String descriptionIn(String languageCode);
}
```

### 11.5 AppSetting
```dart
class AppSetting {
  final String key;
  final String value;
  final DateTime updatedAt;
}
```

### 11.6 LiveConversation
```dart
class LiveConversation {
  final int id, sessionId, durationSeconds;
  final String exerciseType;     // 'category_naming' | 'letter_fluency'
  final String userTranscript;
  final String aiFeedback;
  final double? score;
  final bool isSynced;
  final DateTime createdAt;
}
```

### 11.7 Scoring Engine

**File**: `/home/jay/Workspace/Therapy/lib/domain/services/scoring_engine.dart` (101 lines)

**Two modes**:
1. **Online**: Score from Gemini API → `evaluatePictureNaming()` returns 0–100 score
2. **Offline**: Levenshtein string similarity via `LevenshteinDistance.similarity()`

**Key Methods**:
```dart
static ScoreResult evaluate({
  required String userResponse,       // What user said (STT)
  required String expectedAnswer,     // Target word
  double? geminiScore,                // Optional — takes precedence if provided
  int? responseTimeMs,
}) -> ScoreResult(scorePercentage, scoreLevel, method: 'online'|'offline')

static bool isMastered(List<Attempt> attempts)
  // Requires >= AppConstants.attemptsForMastery (3) recent attempts
  // ALL must be >= AppConstants.masteryThreshold (70%)

static String encouragementPhrase(String scoreLevel)
  // Returns Sinhala encouragement based on level ('excellent' → 'විශිෂ්ටයි!')

static String breathingEncouragement(int daysCompleted)
  // Returns Sinhala encouragement for breathing milestones (7, 14, 21, 30 days)
```

**Score Levels**:
| Level | Threshold | Sinhala Encouragement |
|-------|-----------|----------------------|
| excellent | >= 90% | විශිෂ්ටයි! ඔබට පුදුමාකාර කුසලතා තියෙනවා! |
| good | >= 75% | හොඳයි! ඔබ හොඳින් ඉගෙන ගන්නවා! |
| almost | >= 60% | බොහෝ දුරට හරි! තව ටිකක් උත්සාහ කරමු! |
| try_again | < 60% | කරදරයක් නෑ, නැවත උත්සාහ කරමු! |

---

## 12. Screen & Routing Map

### 12.1 Route Table

| Route | Screen | File | Description |
|-------|--------|------|-------------|
| `/` | Splash | `splash_screen.dart` | App launch screen |
| `/home` | Home | `home_screen.dart` | Main menu (exercises, conversation, breathing, dashboard) |
| `/exercise` | Exercise | `exercise_screen.dart` | Picture naming (category grid → exercise flow → results) |
| `/session` | Session | `session_screen.dart` | Full therapy session (8 shuffled exercises with Live API) |
| `/results` | Results | `results_screen.dart` | Session results review |
| `/conversation` | Conversation | `conversation_screen.dart` | Free-form chat with Gemini Live |
| `/breathing` | Breathing | `breathing_screen.dart` | 4-7-8 box breathing exercise |
| `/dashboard` | Dashboard | `dashboard_screen.dart` | Patient progress charts |
| `/settings` | Settings | `settings_screen.dart` | App configuration |
| `/onboarding` | Onboarding | `onboarding_screen.dart` | First-time user setup |
| `/caregiver-dashboard` | Caregiver | `caregiver_dashboard_screen.dart` | Caregiver progress view |

**Router**: `go_router` with `GoRouter` instance via `appRouterProvider` (Riverpod).

### 12.2 Screen Architecture

**Exercise Screen** (755 lines — most complex):
- **Phase 1 — Category Grid**: Shows `ExerciseCategory.sampleCategories()` as 2-column grid
  - Categories: Animals (සතුන්), Food (ආහාර), Body (ශරීරය), Home (නිවස)
  - Each has 6 `ExerciseItem` objects with `(sinhala, english, emoji)`
- **Phase 2 — Exercise Flow**: Per-exercise view showing emoji, phase indicator, transcriptions, mic button
  - States: `connecting → asking → listening → evaluating → result → completed`
  - Mic uses push-to-talk (tap down = start, tap up = stop)
  - Sends `sendAudioStreamEnd()` to signal turn completion
- **Phase 3 — Results Summary**: Score badge, per-item list with emoji + feedback

**Session Screen** (638 lines — therapy session):
- Creates DB session on init via `SessionDao.createSession()`
- 8 exercises selected randomly from all categories
- Uses `LiveApiService` for real-time voice interaction
- `_handleMessage` processes:
  - `message.data` → audio playback (base64 inlineData from JSON mode)
  - `message.serverContent?.outputTranscription` → model's speech-to-text
  - `message.serverContent?.inputTranscription` → user's speech-to-text
  - `turnComplete || generationComplete` → state advance
- Score extracted via regex `[(\d+)]` from model response text
- Sinhala enum: `connecting → asking → listening → evaluating → result → completed`

**Conversation Screen** (432 lines — free chat):
- Simplest Live API integration — just sends/receives text messages
- Mic streaming with push-to-talk + `sendAudioStreamEnd()`
- Supports both `sendText()` and `sendRealtimeText()`
- Sinhala suggestion chips: "ආයුබෝවන්! කොහොමද?", "අද කාලගුණය හොඳයි", "මම අද උදේ ආහාර ගත්තා"

### 12.3 Provider Architecture

```
liveApiServiceProvider (Provider<LiveApiService>)
  ├── singleton (Riverpod)
  └── dispose() → service.dispose()

geminiApiClientProvider (Provider<GeminiApiClient>)
  └── singleton
  
geminiHealthProvider (FutureProvider<bool>)
  └── watches geminiApiClientProvider → calls healthCheck()

geminiModelInfoProvider (Provider<String>)
  └── returns 'Gemini 2.5 Flash'

_connectionStateProvider (StateProvider) [screen-local]
_messagesProvider (StateProvider<List<ChatMessage>>) [screen-local]
_sessionStepProvider (StateProvider<int>) [screen-local]
_sessionExercisesProvider (Provider) [screen-local]
_sessionResultsProvider (StateProvider) [screen-local]
```

### 12.4 Audio Player (live_audio_player.dart)

```dart
class LiveAudioPlayer {
  final AudioPlayer _player;
  final List<int> _pcmBytes = [];
  
  appendBase64Chunk(String base64Chunk)  // Accumulates PCM from base64
  playBufferedAudio()                    // Adds WAV header @24kHz, plays via audioplayers
  stop() / clear() / dispose()
  
  static Uint8List _addWavHeader(Uint8List pcmBytes, {sampleRate: 24000})
  // Builds 44-byte WAV header for the accumulated PCM bytes
}
```

**Critical:** This player expects `message.data` (base64 from `inlineData` in JSON mode). It does NOT handle raw binary PCM frames from binary mode. The fork MUST add raw binary PCM → WAV conversion.

---

## 13. Complete Test Script Catalog (22 scripts, 2070 lines)

All scripts in `/tmp/test_*.js`. Common structure:
```javascript
// 1. Get OAuth2 token via gcloud
// 2. Connect to wss://us-central1-aiplatform.googleapis.com/ws/...
// 3. Bearer token + X-Goog-User-Project headers
// 4. Send setup with model = projects/.../publishers/google/models/gemini-live-2.5-flash-native-audio
// 5. Listen for messages (binary frames, detect JSON by first byte 0x7b)
// 6. Timeout after 10–35s
```

### 13.1 Script Index

| # | Script | Lines | Purpose | Key Finding |
|---|--------|-------|---------|-------------|
| 1 | `test_live_ws.js` | 123 | **First successful connection** | Bearer token + `us-central1` + full model path = ✅ setupComplete. Initial discovery of binary frames. |
| 2 | `test_live_ws2.js` | — | Variant | — |
| 3 | `test_live_ws3.js` | — | Variant | — |
| 4 | `test_live_ws4.js` | — | Variant | — |
| 5 | `test_live_ws5.js` | — | Check `responseModalities` at setup root | **Rejected** — should be in `generationConfig` |
| 6 | `test_live_ws6.js` | — | Variant | — |
| 7 | `test_live_ws7.js` | — | Variant | — |
| 8 | `test_live_ws8.js` | — | Variant | — |
| 9 | `test_raw.js` | 59 | Binary frame hex dump analysis | **ALL frames are binary (opcode 2)**. No length-prefix framing. First byte `0x7b` = JSON, rest = audio. |
| 10 | `test_bincheck.js` | 69 | Minimal setup, detect small binary messages | Auto-response from system instruction → JSON mode (audio in `serverContent.modelTurn.parts[].inlineData`). |
| 11 | `test_correct.js` | 142 | **Definitive test** — camelCase + `languageCodes` + binary routing | `outputAudioTranscription: { languageCodes: ["en-US"] }` caused **entire setup rejection**. `outputAudioTranscription: {}` works but silences JSON. |
| 12 | `test_detailed.js` | 118 | Full 35s test with transcription tracking | Detailed timing. Setup with `outputAudioTranscription`, multiple prompts. Tracks all JSON messages. |
| 13 | `test_transcription.js` | 86 | Transcription-focused test (snake_case keys) | Used snake_case `output_audio_transcription` — server accepted empty object. No text frames returned. |
| 14 | `test_clean.js` | — | Clean minimal test | — |
| 15 | `test_client_content.js` | — | `clientContent` send format | Confirmed `clientContent.turns[].parts[].text` + `turnComplete` triggers audio response |
| 16 | `test_live_text.js` | — | Text-only input | — |
| 17 | `test_live_input.js` | — | `realtimeInput` format | — |
| 18 | `test_live_full.js` | — | Full session simulation | — |
| 19 | `test_live_transcribe.js` | — | Transcription variant | — |
| 20 | `test_official.js` | — | Official SDK test | — |
| 21 | `test_grpc_decode.js` | — | gRPC-Web framing decode | Confirmed **NO gRPC-Web framing** — just raw binary |
| 22 | `test_reenable.js` | — | Reconnection test | — |

### 13.2 Critical Empirical Discoveries From Tests

**Test 3 (test_raw.js) — Binary Frame Discovery:**
```
#1 BINARY (48B):
  hex: 7b227365747570436f6d706c657465223a...  ← starts with 0x7b = '{'
  asc: {"setupComplete":{...                   ← It's JSON!
```

**Test 4 (test_bincheck.js) — Two Response Modes:**
1. Auto-response (no `clientContent`): Audio in `serverContent.modelTurn.parts[].inlineData` as base64 (JSON mode)
2. Response to clientContent: Raw binary audio frames (binary mode)

**Test 11 (test_correct.js) — transcriptionConfig field name failure:**
```
Setup: { ..., outputAudioTranscription: { languageCodes: ["en-US"] } }
Server error: "Unknown name \"model\" at..."  
→ Entire setup rejected. Likely cascading parse failure from unknown field in AudioTranscriptionConfig.
```

**Test 12 (test_detailed.js) — outputAudioTranscription: {} behavior:**
```
- Setup with outputAudioTranscription: {} → accepted
- After clientContent prompt → raw audio binary frames ONLY
- NO serverContent JSON messages during streaming
- Transcription field names expected: `outputTranscription`, but server never sent any
- Hypothesis: empty object changes response mode entirely
```

### 13.3 Summary of All Errors Encountered

| Error | Cause | Fix |
|-------|-------|-----|
| `404` on WS connect | Wrong model name or location | Use `gemini-live-2.5-flash-native-audio` at `us-central1` |
| `401` on WS connect | Token expired or wrong project | Refresh token, check `X-Goog-User-Project` |
| `403` on WS connect | Wrong gcloud account | Use `mamanniggajay@gmail.com` (owner), not `rahaneyt@gmail.com` |
| `"Unknown name \"model\""` | `responseModalities` at setup root | Move under `generationConfig`, or omit (audio-native model defaults) |
| `"Unknown name \"model\""` cascading | `languageCodes` in `outputAudioTranscription` | Field may not be supported, or different API version needed |
| `Utf8Decoder` error on binary audio | Package decodes ALL binary as UTF-8 | Must detect first byte `0x7b` before decoding |
| `TimeoutException: 10s` | setupCompleter never fires | Server needs `clientContent` to respond; setup response timing varies |

---

## 14. Complete models.g.dart Key Mapping Table

**File**: `/home/jay/.pub-cache/hosted/pub.dev/gemini_live-2026.6.6/lib/src/model/models.g.dart` (1283 lines)

### 14.1 All snake_case → camelCase Renames Needed

These are all the JSON keys in the generated file that use snake_case (due to `fieldRename: snake` on the source class). Each must be changed to camelCase for Vertex AI compatibility.

| Line ~ | Current Key | Target Key | Class |
|--------|------------|------------|-------|
| 102 | `'start_offset'` | `'startOffset'` | VideoMetadata |
| 103 | `'end_offset'` | `'endOffset'` | VideoMetadata |
| 113 | `'num_tokens'` | `'numTokens'` | PartMediaResolution |
| 120 | `'num_tokens'` | `'numTokens'` | PartMediaResolution (toJson) |
| 148 | `'voice_name'` | `'voiceName'` | PrebuiltVoiceConfig |
| 152 | `'voice_name'` | `'voiceName'` | PrebuiltVoiceConfig (toJson) |
| — | `'display_name'` | `'displayName'` | FileData |
| — | `'file_uri'` | `'fileUri'` | FileData |
| — | `'mime_type'` | `'mimeType'` | FileData (toJson) |
| — | `'video_metadata'` | `'videoMetadata'` | Part |
| — | `'code_execution_result'` | `'codeExecutionResult'` | Part |
| — | `'executable_code'` | `'executableCode'` | Part |
| — | `'inline_data'` | `'inlineData'` | Part (already camelCase in source!) |
| — | `'function_call'` | `'functionCall'` | Part (toJson) |
| — | `'function_response'` | `'functionResponse'` | Part (toJson) |
| — | `'tool_call'` | `'toolCall'` | Part |
| — | `'tool_response'` | `'toolResponse'` | Part |
| — | `'part_metadata'` | `'partMetadata'` | Part (toJson) |
| — | `'function_declarations'` | `'functionDeclarations'` | Tool |
| — | `'google_search_retrieval'` | `'googleSearchRetrieval'` | Tool |
| — | `'code_execution'` | `'codeExecution'` | Tool |
| — | `'response_modalities'` | `'responseModalities'` | GenerationConfig |
| — | `'media_resolution'` | `'mediaResolution'` | GenerationConfig |
| — | `'speech_config'` | `'speechConfig'` | GenerationConfig |
| — | `'thinking_config'` | `'thinkingConfig'` | GenerationConfig |
| — | `'enable_affective_dialog'` | `'enableAffectiveDialog'` | GenerationConfig |
| — | `'stream_translation_config'` | `'streamTranslationConfig'` | GenerationConfig |
| — | `'voice_config'` | `'voiceConfig'` | SpeechConfig |
| — | `'prebuilt_voice_config'` | `'prebuiltVoiceConfig'` | VoiceConfig |
| — | `'generation_config'` | `'generationConfig'` | LiveClientSetup |
| — | `'system_instruction'` | `'systemInstruction'` | LiveClientSetup |
| — | `'realtime_input_config'` | `'realtimeInputConfig'` | LiveClientSetup |
| — | `'session_resumption'` | `'sessionResumption'` | LiveClientSetup |
| — | `'context_window_compression'` | `'contextWindowCompression'` | LiveClientSetup |
| — | `'input_audio_transcription'` | `'inputAudioTranscription'` | LiveClientSetup |
| — | `'output_audio_transcription'` | `'outputAudioTranscription'` | LiveClientSetup |
| — | `'avatar_config'` | `'avatarConfig'` | LiveClientSetup |
| — | `'safety_settings'` | `'safetySettings'` | LiveClientSetup |
| — | `'turn_complete'` | `'turnComplete'` | LiveClientContent |
| — | `'function_responses'` | `'functionResponses'` | LiveClientToolResponse |
| — | `'automatic_activity_detection'` | `'automaticActivityDetection'` | RealtimeInputConfig |
| — | `'activity_handling'` | `'activityHandling'` | RealtimeInputConfig |
| — | `'turn_coverage'` | `'turnCoverage'` | RealtimeInputConfig |
| — | `'heuristic_activity_detection'` | `'heuristicActivityDetection'` | RealtimeInputConfig |
| — | `'end_of_speech_sensitivity'` | `'endOfSpeechSensitivity'` | AutomaticActivityDetection |
| — | `'start_of_speech_sensitivity'` | `'startOfSpeechSensitivity'` | AutomaticActivityDetection |
| — | `'prefix_padding_ms'` | `'prefixPaddingMs'` | AutomaticActivityDetection |
| — | `'silence_duration_ms'` | `'silenceDurationMs'` | AutomaticActivityDetection |
| — | `'minimum_audio_duration_ms'` | `'minimumAudioDurationMs'` | AutomaticActivityDetection |
| — | `'language_codes'` | `'languageCodes'` | AudioTranscriptionConfig |
| — | `'media_chunks'` | `'mediaChunks'` | LiveClientRealtimeInput |
| — | `'audio_stream_end'` | `'audioStreamEnd'` | LiveClientRealtimeInput |
| — | `'activity_start'` | `'activityStart'` | LiveClientRealtimeInput |
| — | `'activity_end'` | `'activityEnd'` | LiveClientRealtimeInput |
| — | `'new_handle'` | `'newHandle'` | SessionResumptionConfig |
| — | `'compression_ratio'` | `'compressionRatio'` | ContextWindowCompressionConfig |
| — | `'activity_start'` | `'activityStart'` | ProactivityConfig |
| — | `'avatar_mode'` | `'avatarMode'` | AvatarConfig |
| — | ... and ~20 more function/tool/safety settings |

**Total**: ~75+ key renames needed across the generated file.

### 14.2 Incoming Classes (No changes needed)

These parse camelCase from the server — already correct:
- `LiveServerMessage`: `setupComplete`, `serverContent`, `usageMetadata`, `toolCall`, `toolCallCancellation`, `goAway`, `sessionResumptionUpdate`, `voiceActivityDetectionSignal`, `voiceActivity`
- `LiveServerContent`: `modelTurn`, `turnComplete`, `interrupted`, `groundingMetadata`, `inputTranscription`, `outputTranscription`, `generationComplete`, `urlContextMetadata`, `turnCompleteReason`, `waitingForInput`
- `Transcription`: `text`, `finished`
- `UsageMetadata`: `promptTokenCount`, `cachedContentTokenCount`, `responseTokenCount`, `toolUsePromptTokenCount`, `thoughtsTokenCount`, `totalTokenCount`, `promptTokensDetails`, `cacheTokensDetails`, `responseTokensDetails`, `toolUsePromptTokensDetails`, `trafficType`

---

## 15. AURA Guide Key Points & Build Plan

**Source**: `/home/jay/Downloads/AURA_Vertex_AI_Implementation_Guide.md` (895 lines)

### 15.1 Full System Prompt (Thilina Persona)

The complete Thilina system prompt orchestrates all therapeutic interactions:

```
You are Thilina (තිළිණ), a friendly speech therapy companion from Sri Lanka.
You speak Sinhala (සිංහල) with patients. You're patient, encouraging, and warm.
Your patient is recovering from a stroke and has aphasia/apraxia.

[Core Interaction Rules — 6 rules]
[Session Structure — 3 phases: Check-in → Exercise → Cool-down]
[Cueing Protocol — 4 levels of cues, escalate only when needed]
[Scoring Guidelines — 0-100 scale, generous for speech therapy]
[Widget Control — 10 function declarations for UI state changes]
[Background Agent — Silent context manager runs in parallel]
[Session Memory Format — Structured JSON for long-term memory]
```

### 15.2 11 Function Declarations (Full JSON Schema)

Each function has JSON Schema for args. Key schemas:

**`show_breathing_widget`**:
```json
{
  "name": "show_breathing_widget",
  "description": "Display the 4-7-8 box breathing exercise with animated circle and haptic feedback",
  "parameters": {
    "type": "object",
    "properties": {
      "rounds": { "type": "integer", "description": "Number of breathing rounds (default 5)" },
      "inhale": { "type": "integer", "description": "Inhale duration in seconds (default 4)" },
      "hold": { "type": "integer", "description": "Hold duration in seconds (default 7)" },
      "exhale": { "type": "integer", "description": "Exhale duration in seconds (default 8)" }
    }
  }
}
```

**`show_naming_exercise`**:
```json
{
  "name": "show_naming_exercise",
  "parameters": {
    "type": "object",
    "properties": {
      "imageUrl": { "type": "string" },
      "targetWord": { "type": "string" },
      "language": { "type": "string", "enum": ["si", "ta", "en"] },
      "difficulty": { "type": "integer", "minimum": 1, "maximum": 5 }
    }
  }
}
```

**`provide_cue`**:
```json
{
  "name": "provide_cue",
  "parameters": {
    "type": "object",
    "properties": {
      "level": { "type": "integer", "enum": [0, 1, 2, 3, 4] },
      "cueType": {
        "type": "string",
        "enum": ["verbal", "phonemic", "syllabic", "visual"]
      },
      "cueContent": { "type": "string" }
    }
  }
}
```

**`update_session_memory`**:
```json
{
  "name": "update_session_memory",
  "parameters": {
    "type": "object",
    "properties": {
      "patientName": {},
      "mood": { "type": "string", "enum": ["happy", "frustrated", "tired", "neutral", "anxious"] },
      "energyLevel": { "type": "integer", "minimum": 1, "maximum": 10 },
      "struggleWords": { "type": "array", "items": { "type": "string" } },
      "masteredWords": { "type": "array", "items": { "type": "string" } },
      "notes": { "type": "string" }
    }
  }
}
```

### 15.3 Session Flow (3 Phases)

```
CHECK-IN PHASE (2-3 min):
  1. Greeting + mood check
  2. Review previous session highlights
  3. Set today's goal

EXERCISE PHASE (12-15 min):
  4. Picture Naming (5-7 exercises)
  5. Cueing ladder escalation (verbal → phonemic → syllabic → visual)
  6. Scoring + encouragement

COOL-DOWN PHASE (3-5 min):
  7. Review achievements
  8. Breathing exercise (if needed)
  9. Goodbye + set next session expectation
```

### 15.4 Background Agent Implementation

Two parallel agent streams:
1. **Main agent** (Thilina) — visible voice interaction with patient
2. **Background agent** — invisible, injects context via `realtimeInput.text`

```javascript
// Background agent injection (invisible to patient)
session.send(JSON.stringify({
  realtimeInput: {
    text: "CONTEXT_UPDATE: Patient energy dropped from 7 to 4. " +
          "Struggling with /r/ sounds. " +
          "Suggest easier words and more encouragement."
  }
}));
```

The background agent tracks:
- Patient's emotional state over time (mood trend line)
- Which words are mastered vs struggling (per-session memory)
- Fatigue level (tracked via response time + accuracy trend)
- Optimal time for breathing break (after 3+ wrong attempts)
- Session pacing (adjust difficulty based on remaining time)

### 15.5 Build Plan (from AURA Guide)

```
WEEK 1: Foundation
  Day 1-2: Project scaffold + package fork
  Day 3-4: Core WebSocket integration with binary frame handler
  Day 5-7: Function declarations + widget routing

WEEK 2: Voice Pipeline
  Day 8-9: Microphone streaming (16kHz PCM) + audio playback (24kHz PCM)
  Day 10-11: VAD tuning + turn management
  Day 12-14: Transcription + evaluation loop

WEEK 3: Therapy Content
  Day 15-16: Cueing ladder implementation
  Day 17-18: Scoring engine + database persistence
  Day 19-21: Session memory + background agent

WEEK 4: Polish
  Day 22-23: Error handling + reconnection
  Day 24-25: UI refinement + accessibility
  Day 26-28: Testing + deployment
```

### 15.6 Key Design Decisions from AURA Guide

1. **Single Widget Container**: All UI is controlled by the AI. The app has a single screen that renders whatever widget the model calls. No navigation bar during exercise.
2. **Cueing Ladder**: 4 levels (0=no cue, 1=verbal, 2=phonemic, 3=syllabic, 4=visual). The model chooses the level, not the UI.
3. **Emotional Regulation**: If the patient shows frustration (Level 3-4 struggle on MediaPipe face mesh), the model should: pause, validate feelings, offer breathing break.
4. **MediaPipe Face Mesh**: Runs locally at 1fps. Detects 4 struggle levels via facial tension (brow furrow, lip tension, jaw clench).
5. **Background Agent**: Runs as a parallel "whisper" stream — injects memory context, suggests actions, tracks session analytics. Invisible to the patient.
6. **API Split**: `gemini-live-2.5-flash-native-audio` for voice (WebSocket), separate model for text scoring (REST).
7. **Token Usage**: ~$0.07 per 20-min session. $300 credits ≈ 4,285 sessions. $2.40/month at 30 sessions.

