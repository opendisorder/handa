# Phase 8 — Architecture Update: Reference Implementation Insights

> **Project:** Handa (හඬ) — Stroke Speech Therapy Android App
> **Date:** 2026-06-10
> **Status:** COMPLETE
> **Base document:** `docs/architecture-document.md`

---

## 8E. Live API Session Controller (New Module)

Based on analysis of `useGeminiLive.ts` (266 lines — the reference's core hook), we introduce a new architecture component: the **Live Session Controller**.

### Architecture Pattern

```
┌─────────────────────────────────────────────────────────────┐
│                    Widget Screen Router                       │
│  (Driven by function call responses from Gemini)             │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ Conversation │  │  Breathing   │  │  Exercise    │      │
│  │   Widget     │  │   Widget     │  │   Widget     │      │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘      │
│         │                 │                 │               │
│  ┌──────┴─────────────────┴─────────────────┴───────┐      │
│  │            LiveSessionController                   │      │
│  │  ┌─────────────────────────────────────────────┐  │      │
│  │  │ Audio Input Pipeline                        │  │      │
│  │  │  (twin_stream capture → Int16 PCM →         │  │      │
│  │  │   base64 → sendRealtimeInput)               │  │      │
│  │  └─────────────────────────────────────────────┘  │      │
│  │  ┌─────────────────────────────────────────────┐  │      │
│  │  │ Audio Output Pipeline                       │  │      │
│  │  │  (base64 inlineData → decode → Int16 PCM →  │  │      │
│  │  │   Float32 → AudioBuffer → sequential queue) │  │      │
│  │  └─────────────────────────────────────────────┘  │      │
│  │  ┌─────────────────────────────────────────────┐  │      │
│  │  │ Function Call Handler                       │  │      │
│  │  │  (switch on fc.name → update widget state   │  │      │
│  │  │   → sendToolResponse)                       │  │      │
│  │  └─────────────────────────────────────────────┘  │      │
│  │  ┌─────────────────────────────────────────────┐  │      │
│  │  │ Transcription Accumulator                   │  │      │
│  │  │  (buffers inputTranscription.text +          │  │      │
│  │  │   outputTranscription.text, resets on        │  │      │
│  │  │   turnComplete)                              │  │      │
│  │  └─────────────────────────────────────────────┘  │      │
│  └────────────────────────────────────────────────────┘      │
│                                                              │
│  ┌────────────────────────────────────────────────────┐      │
│  │  LiveApiService (gemini_live_fork)                   │      │
│  │  - WebSocket connection to Vertex AI               │      │
│  │  - Session lifecycle (connect/disconnect)          │      │
│  │  - sendRealtimeInput, sendToolResponse             │      │
│  └────────────────────────────────────────────────────┘      │
└─────────────────────────────────────────────────────────────┘
```

### LiveSessionController Responsibilities

| Responsibility | Source Pattern | Flutter Implementation |
|---------------|---------------|----------------------|
| Mic audio capture | `createScriptProcessor(4096, 1, 1)` → `sendRealtimeInput({media: pcmBlob})` | `twin_stream` with 4096 buffer, encode in `AudioUtils.encodePcmToBase64()` |
| Audio output queue | `nextStartTimeRef` accumulator, `source.start(t)`, `source.stop()` on interrupt | Sequential `AudioPlayer` queue or custom `AudioOutputController` |
| Function call handling | `switch(fc.name)` → `updateState()` → `session.sendToolResponse()` | Riverpod state + `sendToolResponse()` via `LiveApiService` |
| Transcription accumulation | `currentOutputTranscriptionRef += text`, reset on `turnComplete` | Riverpod state updates per `onmessage` callback |
| Widget routing | `setState({ activeWidget: ... })` | Riverpod provider with `WidgetType` enum |
| Error handling | `onerror` → `updateState({error})`, `onclose` → `cleanup()` | `Either<Failure, T>` + error UI state |
| Cleanup | `cleanup()`: stop streams, close audio contexts, stop sessions | `dispose()` pattern with lifecycle awareness |

### Widget Routing State

```dart
enum AuraWidget {
  welcome,
  conversation,
  breathing,
  exercise,
  report,
}

class SessionState {
  final AuraWidget activeWidget;
  final Map<String, dynamic> widgetProps; // cycles, imageUrl, summaryWins etc.
  final String subtitles;          // Thilina's speech transcript
  final String userTranscript;     // Patient's speech transcript (last turn)
  final bool isConnected;
  final bool isConnecting;
  final String? error;
}
```

---

## 8F. Audio Output Queue Architecture

Replacing the simple "play audio immediately" approach with a **sequential audio queue**:

```dart
class AudioOutputController {
  double _nextStartTime = 0.0;
  final Set<AudioPlayer> _activePlayers = {};
  final AudioContext _context; // or just_audio Sequencer

  /// Schedule [pcmBytes] (Int16, 24kHz, mono) to play after previous chunks
  void enqueuePcm(List<int> pcmBytes) {
    final buffer = decodeToAudioBuffer(pcmBytes, sampleRate: 24000, channels: 1);
    final player = AudioPlayer();
    player.setSourceBuffer(buffer);
    player.setStartTime(_nextStartTime);
    player.play();
    _nextStartTime += buffer.duration;
    _activePlayers.add(player);
  }

  /// On serverContent.interrupted: stop all immediately, reset queue
  void interrupt() {
    for (final player in _activePlayers) {
      player.stop();
    }
    _activePlayers.clear();
    _nextStartTime = 0.0;
  }
}
```

### Audio Format Pipeline

```
Output (from Vertex AI):
  base64 inlineData → decode() → Int16 PCM bytes (24kHz, mono, 16-bit LE)

Output (to speaker):
  Int16 PCM → Float32 PCM → AudioBuffer → AudioPlayer

Input (from mic):
  twin_stream raw PCM (16kHz, mono, 16-bit LE) →
  Float32 PCM → encode to base64 → sendRealtimeInput({media: {data, mimeType}})
```

---

## 8G. AudioUtils Module (New)

Reference's `audioUtils.ts` translates directly to Dart:

```dart
class AudioUtils {
  /// Decode base64 string to Uint8List
  static Uint8List decode(String base64) => base64Decode(base64);

  /// Encode Uint8List to base64 string
  static String encode(Uint8List bytes) => base64Encode(bytes);

  /// Convert Float32 audio data to base64-encoded Int16 PCM blob
  static ({String data, String mimeType}) createBlob(Float32List samples) {
    final int16 = Int16List(samples.length);
    for (var i = 0; i < samples.length; i++) {
      int16[i] = (samples[i] * 32768).clamp(-32768, 32767).toInt();
    }
    return (
      data: base64Encode(int16.buffer.asUint8List()),
      mimeType: 'audio/pcm;rate=16000',
    );
  }

  /// Decode Int16 PCM bytes to Float32 audio buffer
  static Float32List decodePcmToFloat32(Uint8List pcmBytes) {
    final int16 = Int16List.view(pcmBytes.buffer, pcmBytes.offsetInBytes, pcmBytes.lengthInBytes ~/ 2);
    final float32 = Float32List(int16.length);
    for (var i = 0; i < int16.length; i++) {
      float32[i] = int16[i] / 32768.0;
    }
    return float32;
  }
}
```

---

## 8H. Updated Dependency Diagram

```
Vertex AI Live API (WebSocket, us-central1-aiplatform.googleapis.com)
  └── gemini_live_fork (vendored package)
       └── LiveApiService
            ├── AdcTokenProvider (dev) / BackendTokenProvider (prod)
            ├── AudioUtils
            ├── AudioOutputController (new — from reference)
            └── LiveSessionController (new — from reference)
                 ├── Widget Screen Router (Riverpod state)
                 │    ├── ConversationWidget
                 │    ├── BreathingWidget
                 │    ├── ExerciseWidget
                 │    └── ReportWidget
                 ├── Function Call Handler
                 └── Transcription Accumulator

Optionally:
  Node.js Backend Proxy (for web deployment / local dev)
  └── server.js (Express + ws)
       ├── /api-proxy → Vertex REST APIs (with ADC)
       └── /ws-proxy → Vertex WebSocket (with ADC + model path rewrite)
```

---

## Architecture Decision Records

### ADR-014: Audio Output Queue Pattern
- **Decision:** Use sequential audio queue with `nextStartTime` accumulator
- **Context:** Reference implementation queues audio chunks to prevent overlap, supports interruption
- **Consequence:** ~80 lines of code for `AudioOutputController`, eliminates audio overlap bugs
- **Source:** Reference `useGeminiLive.ts` lines 163-191

### ADR-015: Session Controller Pattern
- **Decision:** Single `LiveSessionController` manages all Live API state (widget routing, audio I/O, function calls, transcriptions)
- **Context:** Reference uses single `useGeminiLive` hook (266 lines) that manages everything
- **Consequence:** One cohesive module (~300 lines) instead of split providers
- **Source:** Reference `useGeminiLive.ts`

### ADR-016: AudioUtils as Pure Static Class
- **Decision:** PCM encode/decode as pure static methods (no state)
- **Context:** Reference's `audioUtils.ts` has 4 pure functions
- **Consequence:** Easy to test, no dependency injection needed, ~50 lines total
- **Source:** Reference `audioUtils.ts`

### ADR-017: Empty Transcription Config
- **Decision:** Use `{}` for both `outputAudioTranscription` and `inputAudioTranscription`
- **Context:** Reference uses empty objects; our previous `{languageCodes: [...]}` caused server to stop sending transcriptions
- **Consequence:** Change one line in `models.g.dart` default or in `live_api_service.dart` config
- **Source:** Reference `constants.ts` line 76

---

## Validation

| Component | Status | Reference Source |
|-----------|--------|-----------------|
| LiveSessionController | ✅ NEW | useGeminiLive.ts |
| AudioOutputController | ✅ NEW | useGeminiLive.ts lines 163-191 |
| AudioUtils | ✅ NEW | audioUtils.ts |
| Widget routing via function calls | ✅ NEW | App.tsx + useGeminiLive.ts |
| Sequential audio queue | ✅ NEW | useGeminiLive.ts nextStartTimeRef |
| Empty transcription config | ✅ NEW | constants.ts |
| Proxy backend option | ✅ NOTED | server.js (optional path) |
| ADR-014 through ADR-017 | ✅ NEW | Documented above |
