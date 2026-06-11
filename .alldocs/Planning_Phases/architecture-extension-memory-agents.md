# Architecture Extension: Two-Layer Memory & Background Agent System

> **Extends:** `docs/architecture-document.md`
> **Based on:** `docs/reference-memory-psychology-architecture.md`, `docs/reference-speech-therapy-framework.md`
> **Date:** 2026-06-10 | **Status:** ✅ EXTENDS Phase 8

---

## Overview: Why This Extension Exists

The original architecture assumed Gemini Live could handle everything within a session. **It cannot.** Gemini Live has no persistent memory across sessions. Each session starts blank. This extension adds the **two-layer architecture** required for true therapeutic continuity:

```
LAYER 1: GEMINI LIVE (Real-Time)         ─── Talks, sees, cues, calls functions
LAYER 2: BACKGROUND AGENT (Post-Session) ─── Analyzes recording, extracts memory, stores
LAYER 3: ON-DEVICE DETECTORS (Always)    ─── Silence, facial tension, head turning
```

---

## 1. Extended Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      AURA EXTENDED ARCHITECTURE                              │
│                 (Original Clean Architecture + 3 New Subsystems)             │
└─────────────────────────────────────────────────────────────────────────────┘

                          ┌──────────────────┐
                          │   GEMINI API     │
                          │  (Google Cloud)  │
                          │                  │
                          │  Live (WSS)      │
                          │  Flash (REST)    │
                          └──────┬───────────┘
                                 │
     ┌───────────────────────────┼───────────────────────────┐
     │                           │                           │
     ▼                           │                           ▼
┌──────────────┐                 │                 ┌──────────────────┐
│  GEMINI LIVE │                 │                 │ BACKGROUND AGENT │
│  (Layer 1)   │                 │                 │ (Layer 2)        │
│              │                 │                 │                  │
│ Real-time    │                 │                 │ Gemini Flash     │
│ audio/video  │                 │                 │ batch process    │
│ streaming    │                 │                 │ session audio    │
│ function     │                 │                 │ + sampled frames │
│ calls        │                 │                 │ output: JSON     │
└──────┬───────┘                 │                 └────────┬─────────┘
       │                         │                          │
       ▼                         ▼                          ▼
┌──────────────────────────────────────────────────────────────┐
│                   HANDA FLUTTER APP (Android)                  │
│                                                               │
│  ┌───────────────────────────────────────────────────────┐    │
│  │  ORIGINAL CLEAN ARCHITECTURE                           │    │
│  │  (Presentation / Domain / Data layers unchanged)       │    │
│  └───────────────────────────────────────────────────────┘    │
│                                                               │
│  ┌───────────────────────────────────────────────────────┐    │
│  │  NEW SUBSYSTEM 1: ON-DEVICE DETECTORS (Layer 3)       │    │
│  │  ┌──────────────┐  ┌──────────────┐  ┌────────────┐  │    │
│  │  │ MediaPipe    │  │ Silence      │  │ Head/Motion│  │    │
│  │  │ Face Mesh    │  │ Detector     │  │ Detector   │  │    │
│  │  │ (facial      │  │ (audio gaps) │  │ (camera    │  │    │
│  │  │  tension)    │  │              │  │  turning)  │  │    │
│  │  └──────┬───────┘  └──────┬───────┘  └──────┬─────┘  │    │
│  │         │                 │                  │        │    │
│  │         └─────────┬───────┴──────────┐       │        │    │
│  │                   ▼                  ▼       │        │    │
│  │           ┌──────────────┐   ┌────────────┐  │        │    │
│  │           │  Struggle    │   │ Audio      │  │        │    │
│  │           │  Classifier  │   │ Recorder   │  │        │    │
│  │           └──────┬───────┘   └──────┬─────┘  │        │    │
│  │                  │                  │        │        │    │
│  │                  ▼                  ▼        │        │    │
│  │           ┌────────────────────────────────┐ │        │    │
│  │           │  Function Call to Gemini Live   │ │        │    │
│  │           │  ("Patient silent 8s, cue now")│ │        │    │
│  │           └────────────────────────────────┘ │        │    │
│  └──────────────────────────────────────────────┘        │    │
│                                                           │    │
│  ┌───────────────────────────────────────────────────┐    │    │
│  │  NEW SUBSYSTEM 2: MEMORY & PRELOAD                 │    │    │
│  │                                                    │    │    │
│  │  ┌──────────────┐     ┌──────────────────────┐    │    │    │
│  │  │ Memory Store │     │ System Prompt        │    │    │    │
│  │  │ (Firestore)  │◄───►│ Builder              │    │    │    │
│  │  │              │     │ (injects memory into  │    │    │    │
│  │  │ sessions/    │     │  Gemini Live prompt)  │    │    │    │
│  │  │ psychological│     └──────────────────────┘    │    │    │
│  │  │ /memory_for_ │                                │    │    │
│  │  │  next_session│                                │    │    │
│  │  └──────────────┘                                │    │    │
│  └──────────────────────────────────────────────────┘    │    │
│                                                           │    │
│  ┌───────────────────────────────────────────────────┐    │    │
│  │  NEW SUBSYSTEM 3: BACKGROUND AGENT ORCHESTRATOR    │    │    │
│  │                                                    │    │    │
│  │  1. Session ends → App uploads audio + frames      │    │    │
│  │  2. Agent processes → outputs structured JSON      │    │    │
│  │  3. App saves to Firestore                          │    │    │
│  │  4. App generates caregiver report                  │    │    │
│  │  5. Memory preload prepared for next session        │    │    │
│  └──────────────────────────────────────────────────┘    │    │
│                                                           │    │
└───────────────────────────────────────────────────────────┘
                                   │
                                   ▼
                          ┌────────────────┐
                          │   FIRESTORE    │
                          │  (Cloud Sync)  │
                          │                │
                          │  sessions/     │
                          │  patients/     │
                          │  reports/      │
                          └────────────────┘
                                   │
                                   ▼
                          ┌────────────────┐
                          │ CLOUD STORAGE  │
                          │ (Recordings)   │
                          └────────────────┘
```

---

## 2. Layer 1: Gemini Live (Real-Time) — Enhanced

> **Implementation Note (2026-06-09):** We removed the `gemini_live` package dependency (requires Dart SDK ≥3.8.1; we have 3.7.2). Gemini Live is now implemented as a custom `GeminiLiveClient` that connects to **Vertex AI's BidiGenerateContent WebSocket endpoint** using OAuth2 tokens from Application Default Credentials (ADC). The `biz-studio-1779528000` project has been verified working with Vertex AI's `gemini-2.5-flash` model via ADC. The functional description below remains accurate.

### What It Does Now
- **Bidirectional audio streaming** with push-to-talk
- **Camera stream** for immediate facial expression detection
- **Function calls** to app: trigger breathing, show image, log events
- **Session context only** — this conversation, not previous ones

### New: Enhanced Real-Time Function Call Set
```dart
// Existing calls (from original architecture)
trigger_breathing_exercise()
show_image(url)
play_success_sound()
log_exercise_result(data)
escalate_to_caregiver(message)

// NEW calls from psychological framework
reinforce_identity()           // AI triggers identity reinforcement
validate_feeling()             // AI validates emotion without agreeing
contain_session()              // Session closure containment statement
log_psychological_event()      // Log a psychological observation
```

### New: Latency Management
Gemini Live has ~500ms-1s latency. **Do not rely on AI to notice silence.**
Use client-side timers:
```
- Client measures silence locally
- After 5s silence → function call: "Patient silent 5s"
- After 8s silence → function call: "Patient silent 8s, give phonemic cue"
- After 12s silence → function call: "Patient silent 12s, give semantic cue"
```

---

## 3. Layer 2: Background Agent (Post-Session Processing)

### 3.1 Pipeline

```
SESSION ENDS
    │
    ▼
┌─────────────────────────────────────────────┐
│ 1. Upload session data                      │
│    ├── Full audio recording (MP3/Opus)      │
│    ├── 10-20 sampled video frames           │
│    ├── Event log (timestamps, cues given,   │
│    │   function calls, struggle levels)     │
│    └── Transcript (if available from Live)  │
└────────────────┬────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────┐
│ 2. Background Agent (Gemini Flash)           │
│    Prompt: "Analyze this session...output   │
│    JSON with speech metrics, psychological  │
│    markers, therapeutic notes"              │
└────────────────┬────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────┐
│ 3. Structured JSON output                   │
│    ├── speech_metrics (accuracy, latency,   │
│    │   cueing_level)                        │
│    ├── psychological_markers (mood,         │
│    │   negative/positive statements,        │
│    │   rumination_topics, red_flags)        │
│    └── therapeutic_insights (what_worked,   │
│        what_to_avoid, next_strategy)        │
└────────────────┬────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────┐
│ 4. Save to Firestore                         │
│    /patients/{id}/sessions/{sessionId}      │
│    /patients/{id}/psychological_history/    │
└────────────────┬────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────┐
│ 5. Generate caregiver report                │
│    (weekly summary with speech progress     │
│    + psychological trends)                  │
└─────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────┐
│ 6. Prepare memory_for_next_session          │
│    (compact JSON to inject into Gemini      │
│    Live system prompt next session)         │
└─────────────────────────────────────────────┘
```

### 3.2 Background Agent Prompt

The background agent (Gemini Flash, REST API) receives this system prompt:

```
You are a clinical documentation assistant for speech therapy. 
Analyze this session recording and extract structured data.

EXERCISE RESULTS:
- For each exercise: target_word, response, accuracy (0-1),
  cueing_level (0-4), word_onset_ms

STRUGGLE PATTERNS:
- Hardest words? Phonemic patterns?
- When did frustration peak? What triggered it?

EMOTIONAL STATE:
- Mood at start/middle/end (1-5)
- Negative statements (quote them)
- Positive statements (quote them)
- Topics causing reaction (family, money, past, visitors)

SPEECH METRICS:
- Total words attempted, correct, approximate
- Average response time
- Self-corrections count

THERAPEUTIC NOTES:
- What encouragement worked?
- What triggered frustration?
- Personal mentions?
- Red flags for caregiver?
- Next session strategy recommendation

Output as valid JSON only. Include "memory_for_next_session" field
with a 3-sentence summary for the AI to preload next session.
```

### 3.3 Output Schema

```dart
class SessionAnalysis {
  final String sessionId;
  final SpeechMetrics speechMetrics;
  final PsychologicalMarkers psychologicalMarkers;
  final TherapeuticInsights therapeuticInsights;
  final String memoryForNextSession;  // 3-sentence preload
}

class SpeechMetrics {
  final double accuracyPct;
  final double avgWordOnsetMs;
  final double avgCueingLevel;
  final int totalAttempted;
  final int totalCorrect;
  final int selfCorrections;
}

class PsychologicalMarkers {
  final int moodStart;       // 1-5
  final int moodEnd;         // 1-5
  final List<String> negativeStatements;
  final List<String> positiveStatements;
  final List<String> ruminationTopics;
  final int frustrationEvents;
  final double engagementLevel;  // 0.0-1.0
  final bool sleepMentioned;
  final List<String> redFlags;
}

class TherapeuticInsights {
  final List<String> whatWorked;
  final List<String> whatToAvoid;
  final String nextSessionStrategy;
}
```

---

## 4. Layer 3: On-Device Detectors (Real-Time, Zero Latency)

### 4.1 Detector Pipeline

```
┌────────────────────────────────────────────────────────────┐
│  ON-DEVICE DETECTION (Local, Zero Latency)                  │
│                                                             │
│  Audio Stream                              Camera Stream    │
│      │                                          │           │
│      ▼                                          ▼           │
│  ┌──────────┐                            ┌────────────┐    │
│  │ Silence  │                            │ MediaPipe  │    │
│  │ Detector │                            │ Face Mesh  │    │
│  │          │                            │            │    │
│  │ Measures │                            │ Detects:   │    │
│  │ gaps >3s │                            │ - Brow     │    │
│  │ after AI │                            │   furrow   │    │
│  │ prompt   │                            │ - Jaw      │    │
│  └────┬─────┘                            │   clench   │    │
│       │                                  │ - Lip      │    │
│       │   ┌──────────────────────┐       │   movement │    │
│       │   │  Struggle Classifier │       │ - Head     │    │
│       ├──►│                      │◄──────│   turning  │    │
│       │   │  Combines:           │       │ - Eye      │    │
│       │   │  - Silence duration  │       │   widening │    │
│       │   │  - Facial tension    │       └────────────┘    │
│       │   │  - Head movement     │                         │
│       │   │  - False starts      │    ┌────────────┐       │
│       │   │                      │    │  Motion    │       │
│       │   │  Output: struggle    │    │  Detector  │       │
│       │   │  level 0-5           │    │            │       │
│       │   └──────────┬───────────┘    │  Detects   │       │
│       │              │                │  head      │       │
│       │              ▼                │  shaking   │       │
│       │   ┌────────────────────┐      │  or turning│       │
│       │   │  FUNCTION CALL     │      │  away      │       │
│       └──►│  TO GEMINI LIVE    │◄─────┘            │       │
│           │                    │       └────────────┘       │
│           │  "struggle_level:  │                            │
│           │   3, type: silence,│                            │
│           │   duration: 8s,    │                            │
│           │   cue_needed:      │                            │
│           │   phonemic"        │                            │
│           └────────────────────┘                            │
└────────────────────────────────────────────────────────────┘
```

### 4.2 Struggle Level Detection (Combined)

```dart
enum StruggleLevel {
  none(0),        // Normal interaction
  early(1),       // 3-5s silence, slight tension
  moderate(2),    // 5-8s silence, false starts
  significant(3), // 8-12s, visible frustration
  severe(4),      // 12s+, giving up
  distress(5);    // Emotional distress, "I can't"
}

class StruggleDetector {
  // Combines audio + video signals
  StruggleLevel detect(
    Duration silenceDuration,
    double facialTensionScore,  // 0.0-1.0 from MediaPipe
    bool headTurnedAway,
    bool hasFalseStarts,
    bool verbalDistress,
  );
}
```

### 4.3 Required Dependencies

```yaml
# Add to pubspec.yaml
dependencies:
  google_mlkit_face_mesh: ^1.0.0   # MediaPipe Face Mesh for Flutter
  # OR
  mediapipe: ^0.10.0                 # If using generic MediaPipe
```

---

## 5. Memory Preload System

### 5.1 How It Works

```
SESSION N                          SESSION N+1
    │                                   │
    ▼                                   ▼
┌──────────────┐                 ┌──────────────┐
│ Background   │                 │ App loads    │
│ Agent        │                 │ memory_for_  │
│ produces:    │                 │ next_session │
│              │                 │ from         │
│ memory_for_  │───save to───►   │ Firestore    │
│ next_session │   Firestore     │              │
└──────────────┘                 │              │
                                 ▼              │
                          ┌──────────────┐      │
                          │ System Prompt│      │
                          │ Builder      │      │
                          │              │      │
                          │ Prepends     │      │
                          │ memory to    │      │
                          │ Gemini Live  │      │
                          │ system prompt◄──────┘
                          └──────┬───────┘
                                 │
                                 ▼
                          ┌──────────────┐
                          │ Gemini Live  │
                          │ "remembers"  │
                          │ yesterday    │
                          └──────────────┘
```

### 5.2 Memory Format

```dart
class SessionMemory {
  final String patientName;
  final String preferredLanguage;
  
  // Yesterday's performance
  final List<String> wins;           // "Named elephant without cue"
  final List<String> struggles;      // "Words starting with 'p'"
  final String emotionalState;       // "Calm but mentioned money worry"
  
  // What motivates
  final List<String> motivators;     // "References to children's success"
  final List<String> triggers;       // "Being rushed, food words"
  
  // Therapist strategy
  final String strategyForToday;     // "Start with easy wins, avoid 'p' words"
}
```

### 5.3 System Prompt Section (Injected Before Each Live Session)

```
PATIENT MEMORY (from previous sessions):
- Name: [Name]
- Preferred language: Sinhala
- Yesterday's wins: Named elephant without cue, completed 5 breathing cycles
- Yesterday's struggles: Words starting with 'p', category naming
- Emotional state at end: Calm but mentioned worry about money
- What motivates him: References to his children's success
- What triggers frustration: Being rushed, words about food
- Today's strategy: Start with 2 easy wins, use breathing before hard exercises
```

---

## 6. Extended Firestore Schema

```dart
// Collection: /patients/{patientId}
class PatientDocument {
  final String name;
  final String language;           // si/ta/en
  final String strokeDate;
  final List<String> conditions;   // ["anomia", "apraxia"]
  final String psychologistInfo;   // If seeing professional
  final PsychologicalProfile profile;
}

class PsychologicalProfile {
  final List<String> knownTriggers;
  final List<String> effectiveStrategies;
  final List<String> redFlagKeywords;     // Words that indicate distress
  final List<String> familyContextNotes;  // Non-clinical context
}

// Collection: /patients/{patientId}/sessions/{sessionId}
class SessionDocument {
  // ...existing fields from original schema...
  
  // NEW: Psychological markers
  final PsychologicalMarkers psychology;
  final String memoryForNextSession;
  final List<String> redFlags;           // Passed to caregiver if any
  
  // NEW: Recording references
  final String audioRecordingUrl;       // Cloud Storage URL
  final List<String> sampledFrameUrls;  // 10-20 key frames
}

// Collection: /patients/{patientId}/reports/{reportId}
class WeeklyReport {
  final DateTime weekStart;
  final SpeechProgress speech;
  final PsychologicalTrend psychology;
  final String therapistNote;           // AI-generated
  final bool hasRedFlags;
}
```

---

## 7. Updated Data Layer Structure

```
lib/
├── data/
│   ├── database/                   # (unchanged)
│   ├── datasources/
│   │   ├── local/                  # (unchanged)
│   │   ├── remote/                 # (unchanged)
│   │   ├── platform/               # (unchanged)
│   │   └── NEW: detectors/         # On-device detection
│   │       ├── silence_detector.dart
│   │       ├── face_mesh_detector.dart
│   │       ├── struggle_classifier.dart
│   │       └── motion_detector.dart
│   ├── NEW: memory/                # Memory system
│   │   ├── memory_store.dart       # Firestore CRUD for memories
│   │   ├── prompt_builder.dart     # Builds system prompt with memory
│   │   └── memory_models.dart      # SessionMemory, etc.
│   ├── NEW: background_agent/      # Post-session processing
│   │   ├── agent_orchestrator.dart # Triggers background agent
│   │   ├── agent_prompt_builder.dart
│   │   ├── agent_response_parser.dart
│   │   └── report_generator.dart   # Caregiver weekly report
│   └── models/                     # (unchanged + new models)
│       ├── psychological_markers_model.dart
│       ├── session_memory_model.dart
│       └── weekly_report_model.dart
│
├── domain/
│   ├── entities/                   # (unchanged + new entities)
│   │   ├── struggle_level.dart
│   │   ├── session_analysis.dart
│   │   └── psychological_marker.dart
│   └── repositories/              # (unchanged)
│
└── presentation/
    ├── providers/                  # (unchanged + new providers)
    │   ├── session_provider.dart
    │   ├── memory_provider.dart
    │   └── report_provider.dart
    └── pages/
        ├── session/                # (unchanged)
        ├── caregiver/              # Enhanced with psychology tab
        │   ├── dashboard/
        │   ├── analytics/
        │   └── psychological/      # NEW: Psychology overview
        │       ├── mood_trend_chart.dart
        │       ├── red_flag_log.dart
        │       └── weekly_insights.dart
        └── settings/
```

---

## 8. Cost Implications

| Component | Model | Cost | Notes |
|-----------|-------|------|-------|
| **Real-Time** | Gemini Live (provisioned) | $0.005/min input, $0.018/min output | ~$0.50/30-min session |
| **Background Agent** | Gemini 1.5 Flash | $0.075/1M input, $0.30/1M output | ~$0.01/session |
| **On-Device** | MediaPipe (local) | Free | No cloud cost |
| **Storage** | Firebase (free tier) | Free up to 5GB | Audio recordings ~30MB/session |
| **Cloud Storage** | Firebase Storage | $0.026/GB | ~$0.78/30 sessions |

**Total: ~$0.51/session** (mostly Gemini Live runtime)

---

## 9. Key Design Decisions

| Decision | Choice | Reasoning |
|----------|--------|-----------|
| Background agent model | Gemini 1.5 Flash | Cheaper than Pro, sufficient for analysis |
| Background agent timing | After session, not live | Cheaper, more accurate, no real-time interference |
| On-device detection | MediaPipe Face Mesh | Zero latency, works offline, privacy-preserving |
| Memory injection | System prompt prepend | Simplest approach, no API changes needed |
| Recording storage | Firebase Storage | Same vendor as Firestore, easy integration |
| Struggle detection | Hybrid (local + cloud) | Local for speed, cloud for depth |
| Psychological analysis | Background agent only | Real-time AI should focus on speech therapy |

---

*Extension to Architecture Phase (Phase 8) — Memory & Background Agent System*  
*References: `docs/reference-memory-psychology-architecture.md` Part 1*
