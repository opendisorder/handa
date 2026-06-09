# Phase 8 — System Architecture: Handa (හඬ)

> **Project:** Handa (හඬ) — Stroke Speech Therapy Android App
> **Date:** 2026-06-09
> **Status:** COMPLETE

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          HANDA SYSTEM ARCHITECTURE                      │
│                              (High-Level)                               │
└─────────────────────────────────────────────────────────────────────────┘

                            ┌──────────────────┐
                            │   GEMINI API     │
                            │  (Google Cloud)  │
                            │                  │
                            │  REST (Flash)    │
                            │  WSS (Live)      │
                            └──────┬───────────┘
                                   │
                    ┌──────────────┼──────────────┐
                    │              │              │
                    ▼              │              ▼
            ┌──────────────┐      │      ┌──────────────┐
            │  CLOUDFLARE  │      │      │   FIREBASE   │
            │   WORKER     │      │      │  AI LOGIC    │
            │ (API Proxy)  │      │      │  (Live SDK)  │
            │  REST only   │      │      │  WSS direct  │
            └──────┬───────┘      │      └──────┬───────┘
                   │              │              │
                   ▼              │              ▼
            ┌──────────────────────────────────────────┐
            │         HANDA FLUTTER APP (Android)       │
            │                                            │
            │  ┌────────────────────────────────────┐    │
            │  │         PRESENTATION LAYER          │    │
            │  │  (Widgets, Pages, Animations, UX)   │    │
            │  └────────────────┬───────────────────┘    │
            │                   │                         │
            │  ┌────────────────▼───────────────────┐    │
            │  │         DOMAIN LAYER                │    │
            │  │  (Use Cases, Scoring, Validation)   │    │
            │  └────────────────┬───────────────────┘    │
            │                   │                         │
            │  ┌────────────────▼───────────────────┐    │
            │  │         DATA LAYER                  │    │
            │  │  (Drift DB, Firestore, Gemini API,  │    │
            │  │   Audio Capture, TTS, Haptics)      │    │
            │  └────────────────────────────────────┘    │
            │                                            │
            │  ┌────────────────────────────────────┐    │
            │  │  LOCAL STORAGE                      │    │
            │  │  ┌──────┐ ┌──────┐ ┌──────────┐   │    │
            │  │  │DRIFT │ │WEBP  │ │AUDIO     │   │    │
            │  │  │SQLite│ │Images│ │Recordings│   │    │
            │  │  └──────┘ └──────┘ └──────────┘   │    │
            │  └────────────────────────────────────┘    │
            └──────────────────────────────────────────┘
                                   │
                                   ▼
                            ┌──────────────┐
                            │  FIRESTORE   │
                            │  (Cloud Sync) │
                            └──────────────┘
```

---

## 1. Frontend Architecture (Flutter)

### 1.1 Tech Stack

| Layer | Technology | Version | Rationale |
|-------|-----------|---------|-----------|
| **Framework** | Flutter | 3.22+ | Cross-platform, Sinhala text rendering, Material 3 |
| **Language** | Dart | 3.4+ | Sound null safety, pattern matching, records |
| **State management** | Riverpod | 2.5+ | Compile-safe, testable, integrates with Drift streams |
| **Routing** | GoRouter | 14+ | Declarative, deep link support, redirect guards |
| **Local DB** | Drift (SQLite) | 2.18+ | Type-safe SQL, migrations, reactive streams (`watch()`) |
| **Cloud DB** | Firestore (Firebase) | — | Offline-first sync, generous free tier |
| **Audio capture** | `twin_stream` | 0.3+ | Solves Android mic lock, Vosk integration |
| **Audio playback** | `audioplayers` | 6+ | WAV/MP3/Opus playback with controls |
| **Charts** | `fl_chart` | 0.69+ | Beautiful charts, accessible colors |
| **PDF generation** | `pdf` + `printing` | — | Server-side-free, local PDF rendering |
| **Haptics** | `flutter_services` (HapticFeedback) | Built-in | Native, no extra deps |
| **TTS** | Piper TTS (ONNX) | Plugin | Offline Sinhala TTS |
| **Image caching** | `cached_network_images` + local | — | WebP support, memory-efficient |
| **Localization** | Flutter ARB + `intl` | — | Sinhala, Tamil, English |
| **API client** | `dio` or `http` | — | Gemini REST calls, retry, timeout |

### 1.2 Clean Architecture Layers

```
lib/
├── main.dart                           # App entry, providers setup
├── app.dart                            # MaterialApp, theme, router
│
├── core/
│   ├── constants/                      # App constants, color tokens
│   │   ├── app_colors.dart             # Design token colors
│   │   ├── app_dimensions.dart         # Spacing, radius, sizes
│   │   ├── app_durations.dart          # Animation durations
│   │   └── app_strings.dart            # String constants (Sinhala/Tamil/En)
│   ├── errors/                         # Error types, handlers
│   │   ├── failures.dart               # Failure sealed class hierarchy
│   │   └── error_handler.dart          # Global error handler
│   ├── theme/                          # Theme configuration
│   │   ├── app_theme.dart              # Light theme (no dark mode for patient)
│   │   └── app_typography.dart         # 28sp+ bold typography
│   ├── utils/                          # Utilities
│   │   ├── scoring_engine.dart         # Levenshtein + normalization
│   │   ├── sinhala_normalizer.dart     # Sinhala Unicode normalization
│   │   └── audio_utils.dart            # PCM conversion, silence detection
│   └── extensions/                     # Dart extension methods
│
├── data/
│   ├── database/                       # Drift database
│   │   ├── app_database.dart           # Database definition, migrations
│   │   ├── tables/                     # Table definitions
│   │   │   ├── exercises_table.dart
│   │   │   ├── sessions_table.dart
│   │   │   ├── attempts_table.dart
│   │   │   ├── images_table.dart
│   │   │   ├── categories_table.dart
│   │   │   └── settings_table.dart
│   │   └── daos/                       # Data Access Objects
│   │       ├── exercise_dao.dart
│   │       ├── session_dao.dart
│   │       └── settings_dao.dart
│   ├── datasources/                    # External data sources
│   │   ├── local/                      # Local data implementations
│   │   │   ├── drift_local_source.dart
│   │   │   └── audio_storage_source.dart
│   │   ├── remote/                     # Remote/cloud data
│   │   │   ├── gemini_api_source.dart       # REST API (Picture Naming)
│   │   │   ├── gemini_live_source.dart      # WebSocket (Live Conversation)
│   │   │   ├── firestore_source.dart        # Cloud sync
│   │   │   └── cloudflare_proxy_source.dart # API key proxy
│   │   └── platform/                   # Hardware/platform
│   │       ├── audio_capture_source.dart    # Microphone via twin_stream
│   │       ├── haptic_feedback_source.dart  # Vibration patterns
│   │       └── tts_source.dart             # Text-to-speech
│   └── models/                         # Data models (DTOs)
│       ├── exercise_model.dart
│       ├── session_model.dart
│       ├── attempt_model.dart
│       ├── image_model.dart
│       ├── scoring_result_model.dart
│       └── sync_status_model.dart
│
├── domain/                             # Business logic
│   ├── entities/                       # Core domain entities
│   │   ├── exercise.dart
│   │   ├── session.dart
│   │   ├── attempt.dart
│   │   ├── image_item.dart
│   │   ├── score_level.dart            # Excellent/Good/Almost/TryAgain enum
│   │   └── language.dart               # Sinhala/Tamil/English enum
│   ├── repositories/                   # Repository interfaces
│   │   ├── exercise_repository.dart
│   │   ├── session_repository.dart
│   │   ├── scoring_repository.dart
│   │   ├── audio_repository.dart
│   │   └── sync_repository.dart
│   └── usecases/                       # Application business rules
│       ├── evaluate_answer.dart        # Score a speech attempt
│       ├── compose_session.dart        # Build session from 40/40/20 rule
│       ├── track_progress.dart         # Update progress after attempt
│       ├── sync_data.dart              # Orchestrate cloud sync
│       └── manage_language_unlock.dart # Language progression logic
│
├── presentation/                       # UI layer
│   ├── router/
│   │   ├── app_router.dart             # GoRouter configuration
│   │   └── route_guards.dart           # Caregiver PIN guard
│   ├── providers/                      # Riverpod providers
│   │   ├── session_provider.dart
│   │   ├── exercise_provider.dart
│   │   ├── scoring_provider.dart
│   │   ├── settings_provider.dart
│   │   └── caregiver_provider.dart
│   ├── pages/                          # Full screens
│   │   ├── splash/
│   │   ├── home/
│   │   ├── session/
│   │   │   ├── breathing/
│   │   │   ├── picture_naming/
│   │   │   ├── live_conversation/
│   │   │   └── session_summary/
│   │   ├── caregiver/
│   │   │   ├── pin_entry/
│   │   │   ├── dashboard/
│   │   │   ├── sessions/
│   │   │   ├── analytics/
│   │   │   ├── content/
│   │   │   └── settings/
│   │   └── settings/                   # Patient settings
│   └── widgets/                        # Reusable widgets
│       ├── score_badge.dart
│       ├── hanada_button.dart
│       ├── mic_button.dart
│       ├── breathing_circle.dart
│       ├── waveform_visualizer.dart
│       ├── progress_dots.dart
│       ├── stat_card.dart
│       ├── confetti_effect.dart
│       └── feedback_toast.dart
│
└── l10n/                               # Localization
    ├── app_si.arb                       # Sinhala strings
    ├── app_ta.arb                       # Tamil strings
    └── app_en.arb                       # English strings
```

### 1.3 State Management Architecture

```
Riverpod Provider Architecture
═══════════════════════════════════════════

                    ┌──────────────────────┐
                    │   UI (Widgets)        │
                    │   (watch/read)        │
                    └────────┬─────────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
              ▼              ▼              ▼
     ┌────────────┐  ┌────────────┐  ┌────────────┐
     │StateNotifier│  │  Stream   │  │ Future/    │
     │  Providers │  │ Providers │  │ AsyncValue │
     │ (mutable)  │  │(Drift.    │  │ (one-shot) │
     │            │  │ watch())  │  │            │
     └────────────┘  └────────────┘  └────────────┘
           │               │               │
           └───────┬───────┘               │
                   │                       │
                   ▼                       │
          ┌─────────────────┐              │
          │  Service Layer  │◄─────────────┘
          │  (Repository)   │
          └────────┬────────┘
                   │
         ┌─────────┼─────────┐
         │         │         │
         ▼         ▼         ▼
     ┌────────┐┌────────┐┌────────┐
     │ Drift  ││Firestore││ Gemini │
     │ (SQLite)││ (Cloud) ││  API   │
     └────────┘└────────┘└────────┘
```

**Key Architectural Rule:** Widgets never access Drift or Firestore directly. They read from Riverpod providers that consume repository interfaces. This makes testing trivial (mock the repository).

---

### 1.4 Drift Database Schema

```sql
-- Categories
CREATE TABLE categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name_si TEXT NOT NULL,       -- Sinhala name
  name_ta TEXT,                -- Tamil name
  name_en TEXT,                -- English name
  icon_name TEXT NOT NULL,
  display_order INTEGER NOT NULL,
  language TEXT NOT NULL DEFAULT 'si',  -- si/ta/en
  is_builtin BOOLEAN NOT NULL DEFAULT 1,
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Exercises (Picture Naming items)
CREATE TABLE exercises (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  category_id INTEGER NOT NULL REFERENCES categories(id),
  target_word_si TEXT NOT NULL,    -- Sinhala target word
  target_word_ta TEXT,             -- Tamil target word
  target_word_en TEXT,             -- English target word
  image_path TEXT NOT NULL,        -- Local WebP path
  image_type TEXT NOT NULL DEFAULT 'builtin',  -- builtin / custom
  hint_text_si TEXT,               -- Sinhala hint
  hint_text_ta TEXT,               -- Tamil hint
  hint_text_en TEXT,               -- English hint
  difficulty INTEGER NOT NULL DEFAULT 1,  -- 1-5
  language TEXT NOT NULL DEFAULT 'si',
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Sessions
CREATE TABLE sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_type TEXT NOT NULL,       -- 'picture_naming' / 'live_conversation' / 'mixed'
  started_at TEXT NOT NULL,
  completed_at TEXT,
  duration_seconds INTEGER,
  total_items INTEGER NOT NULL,
  completed_items INTEGER NOT NULL DEFAULT 0,
  average_score REAL,
  star_count INTEGER NOT NULL DEFAULT 0,
  language TEXT NOT NULL DEFAULT 'si',
  breathing_completed BOOLEAN NOT NULL DEFAULT 0,
  sync_status TEXT NOT NULL DEFAULT 'pending',  -- pending / synced / failed
  last_modified TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Attempts (individual exercise attempts)
CREATE TABLE attempts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL REFERENCES sessions(id),
  exercise_id INTEGER REFERENCES exercises(id),
  attempt_number INTEGER NOT NULL DEFAULT 1,
  score REAL NOT NULL,               -- 0.0 - 100.0
  score_level TEXT NOT NULL,         -- excellent / good / almost / try_again
  user_transcript TEXT,              -- What was recognized (text)
  target_word TEXT NOT NULL,         -- Expected word
  audio_path TEXT,                   -- Path to recording
  evaluation_source TEXT NOT NULL,   -- 'gemini' / 'local_levenshtein'
  response_time_ms INTEGER,         -- How long user took to respond
  feedback_phrase_si TEXT,           -- Sinhala feedback shown
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Live Conversation Sessions (child of session)
CREATE TABLE live_conversations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL REFERENCES sessions(id),
  exercise_type TEXT NOT NULL,       -- 'category_naming' / 'letter_fluency' / etc.
  started_at TEXT NOT NULL,
  duration_seconds INTEGER,
  ai_transcript TEXT,                -- Full transcript (user + AI)
  fluency_score REAL,
  words_spoken INTEGER,
  turns_taken INTEGER,
  sync_status TEXT NOT NULL DEFAULT 'pending'
);

-- Settings (key-value for flexibility)
CREATE TABLE settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL,
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Sync Log
CREATE TABLE sync_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  table_name TEXT NOT NULL,
  record_id INTEGER NOT NULL,
  action TEXT NOT NULL,              -- 'create' / 'update' / 'delete'
  attempted_at TEXT NOT NULL,
  succeeded_at TEXT,
  retry_count INTEGER NOT NULL DEFAULT 0,
  error_message TEXT
);

-- Indexes for performance
CREATE INDEX idx_exercises_category ON exercises(category_id);
CREATE INDEX idx_exercises_language ON exercises(language);
CREATE INDEX idx_attempts_session ON attempts(session_id);
CREATE INDEX idx_attempts_exercise ON attempts(exercise_id);
CREATE INDEX idx_sessions_date ON sessions(started_at);
CREATE INDEX idx_sessions_sync ON sessions(sync_status);
CREATE INDEX idx_sync_pending ON sync_log(succeeded_at) WHERE succeeded_at IS NULL;
```

---

## 2. Backend Architecture

### 2.1 Cloudflare Worker (API Proxy)

**Purpose:** Protect Gemini API key. The Android app never knows the API key.

```
┌─────────────┐     POST /api/gemini     ┌──────────────┐     POST https://generativelanguage.googleapis.com
│  Handa App  │ ──────────────────────►  │  Cloudflare  │ ──────────────────────────────────────────────►
│  (Flutter)  │                          │   Worker     │     GET https://generativelanguage.googleapis.com
│             │ ◄────────────────────── │  (Free plan) │ ◄──────────────────────────────────────────────
└─────────────┘     JSON Response        └──────────────┘     Gemini API Response
```

**Worker Endpoints:**

| Method | Path | Description | Request | Response |
|--------|------|-------------|---------|----------|
| POST | `/api/evaluate` | Evaluate Picture Naming | `{image_base64, prompt, target_word}` | `{score, level, feedback, target_word}` |
| GET | `/health` | Health check | — | `{status: "ok", version: "1.0.0"}` |

**Worker Logic:**
```typescript
// Cloudflare Worker — Gemini API Proxy
// Free plan: ~100K requests/day, 10ms CPU — sufficient for this app

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    // CORS for all origins (dev only; restrict in production)
    if (request.method === 'OPTIONS') {
      return new Response(null, { headers: corsHeaders });
    }

    const url = new URL(request.url);

    // Health check
    if (url.pathname === '/health') {
      return new Response(JSON.stringify({ status: 'ok', version: '1.0.0' }), {
        headers: { ...jsonHeaders, ...corsHeaders },
      });
    }

    // Evaluate endpoint
    if (url.pathname === '/api/evaluate' && request.method === 'POST') {
      const body = await request.json();

      // Forward to Gemini API with server-side API key
      const geminiResponse = await fetch(
        `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${env.GEMINI_API_KEY}`,
        {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(buildGeminiPrompt(body)),
        }
      );

      const geminiData = await geminiResponse.json();
      const parsed = parseGeminiResponse(geminiData);

      return new Response(JSON.stringify(parsed), {
        headers: { ...jsonHeaders, ...corsHeaders },
      });
    }

    return new Response('Not Found', { status: 404 });
  },
};
```

**Security:**
- API key stored as `env.GEMINI_API_KEY` (Workers secret, never in code)
- CORS restricted to app origin in production
- Request validation: reject malformed payloads
- Rate limiting: optional (KV-based, not critical for single-user)

**Cost:** $0/month (Free plan: 100K requests/day)

### 2.2 Firebase Integration

| Service | Purpose | Usage |
|---------|---------|-------|
| **Firebase AI Logic** | Gemini Live API SDK | Official Flutter SDK for Live Conversation WebSocket |
| **Firestore** | Cloud data sync | Backup sessions, scores, settings |
| **Firebase Anonymous Auth** | Device identity | Unique UID per device without login |

**Firestore Security Rules:**
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow access only with Anonymous Auth
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null 
                        && request.auth.uid == userId;
    }
  }
}
```

### 2.3 Gemini API Integration

#### Picture Naming (REST — via Cloudflare Proxy)

**Prompt Template (Sinhala):**
```
You are a compassionate Sinhala speech therapy assistant for a stroke patient 
with aphasia. The patient was shown an image of a {target_word} and was asked 
"What is this?" The patient said: "{user_speech}".

Evaluate the patient's response. Consider:
1. Did they say the correct word? (exact match = excellent)
2. Did they say something similar? (phonetically close = good/almost)
3. Did they say something unrelated? (try again)

CRITICAL RULES:
- NEVER say "wrong" or "incorrect"
- Always be encouraging
- Respond in Sinhala

Respond with JSON only:
{
  "score": 0-100,
  "level": "excellent|good|almost|try_again",
  "target_word": "{target_word}",
  "feedback_si": "Sinhala feedback phrase",
  "phonetic_notes": "optional notes on pronunciation"
}
```

#### Live Conversation (WebSocket — Firebase AI Logic SDK)

**Direct from Flutter app via Firebase AI Logic:**
```dart
final liveModel = FirebaseAI.googleAI().liveGenerativeModel(
  model: 'gemini-live-2.5-flash-native-audio',
  liveGenerationConfig: LiveGenerationConfig(
    responseModalities: [ResponseModalities.audio],
    speechConfig: SpeechConfig(voiceName: 'Puck'),
    systemInstruction: Content.system(
      'You are a compassionate Sinhala speech therapy assistant...'
    ),
  ),
);

final session = await liveModel.connect();
await session.startAudioConversation();
```

---

## 3. Data Flow Diagrams

### 3.1 Picture Naming Flow

```
User taps mic       Audio recorded      Send to API        Display Score
    │                    │                   │                   │
    ▼                    ▼                   ▼                   ▼
┌────────┐    ┌────────────────┐    ┌──────────────┐    ┌──────────────┐
│ Hold   │───►│ twin_stream    │───►│ Cloudflare   │───►│ ScoreBadge   │
│ Mic    │    │ captures PCM   │    │ Worker →     │    │ animation    │
│ Button │    │ (16kHz, mono)  │    │ Gemini API   │    │ + TTS        │
└────────┘    └────────────────┘    └──────────────┘    └──────────────┘
                   │                                        │
                   ▼                                        ▼
              ┌────────────┐                          ┌───────────┐
              │ Save audio │                          │ Save to   │
              │ to local   │                          │ Drift DB  │
              │ storage    │                          │ (attempt) │
              └────────────┘                          └───────────┘
```

### 3.2 Offline Picture Naming Flow

```
User taps mic       Audio recorded      Vosk STT (local)     Levenshtein Scoring
    │                    │                   │                      │
    ▼                    ▼                   ▼                      ▼
┌────────┐    ┌────────────────┐    ┌──────────────┐    ┌──────────────────┐
│ Hold   │───►│ twin_stream    │───►│ Vosk         │───►│ sinhala_normalizer│
│ Mic    │    │ captures PCM   │    │ recognize    │    │ → edit_distance  │
└────────┘    └────────────────┘    └──────┬───────┘    └────────┬─────────┘
                                           │                     │
                                           ▼                     ▼
                                      ┌──────────┐        ┌────────────┐
                                      │ Text     │        │ Score 0-100│
                                      │ (user's  │        │ + Level    │
                                      │ speech)  │        └────────────┘
                                      └──────────┘              │
                                                                 ▼
                                                            ┌───────────┐
                                                            │ Save to   │
                                                            │ Drift DB  │
                                                            └───────────┘
```

### 3.3 Sync Flow

```
Background Sync Worker (Runs on connectivity change + periodically)
═══════════════════════════════════════════════════════════════════

┌──────────┐     ┌──────────────┐     ┌──────────────┐     ┌───────────┐
│Drift DB  │────►│ Read pending │────►│ Write to     │────►│ Mark as   │
│(local)   │     │ records from │     │ Firestore    │     │ synced    │
│          │     │ sync_log     │     │              │     │           │
└──────────┘     └──────────────┘     └──────────────┘     └───────────┘
                                                                   
              Failed ──► Retry queue (30s → 2min → 5min → 30min)
```

---

## 4. Scoring Engine Design

### 4.1 Levenshtein Distance (Offline)

```dart
class ScoringEngine {
  /// Calculate normalized similarity score (0-100) between user speech and target word.
  /// Uses weighted Levenshtein distance with Sinhala-specific normalization.
  double calculateScore(String userSpeech, String targetWord) {
    final normalizedSpeech = SinhalaNormalizer.normalize(userSpeech);
    final normalizedTarget = SinhalaNormalizer.normalize(targetWord);
    
    final distance = levenshteinDistance(normalizedSpeech, normalizedTarget);
    final maxLen = max(normalizedSpeech.length, normalizedTarget.length);
    final similarity = 1.0 - (distance / maxLen);
    
    return (similarity * 100).roundToDouble();
  }

  ScoreLevel classifyScore(double score) {
    if (score >= 90) return ScoreLevel.excellent;
    if (score >= 75) return ScoreLevel.good;
    if (score >= 60) return ScoreLevel.almost;
    return ScoreLevel.tryAgain;
  }
}

class SinhalaNormalizer {
  /// Normalize Sinhala text: remove diacritics for comparison,
  /// normalize Unicode, handle common stroke-speech variations.
  static String normalize(String input) {
    return input
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^\u0D80-\u0DFF]'), '') // Keep only Sinhala chars
        .normalizeUnicode();
  }
}
```

### 4.2 Gemini AI Scoring (Online)

```dart
class GeminiScoringService {
  Future<ScoringResult> evaluateAttempt({
    required Uint8List audioPcm,
    required String targetWord,
    required String language,
  }) async {
    // Send via Cloudflare Worker proxy
    final response = await http.post(
      Uri.parse('$workerUrl/api/evaluate'),
      body: jsonEncode({
        'audio_base64': base64Encode(audioPcm),
        'target_word': targetWord,
        'language': language,
      }),
    );
    
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return ScoringResult(
      score: data['score'],
      level: ScoreLevel.fromString(data['level']),
      feedbackPhrase: data['feedback_si'],
    );
  }
}
```

---

## 5. Infrastructure Architecture

### 5.1 Deployment Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                        PRODUCTION INFRASTRUCTURE                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌──────────────────┐     ┌───────────────────┐     ┌───────────┐   │
│  │ Cloudflare        │     │ Firebase          │     │ Google    │   │
│  │ Workers           │     │ Project           │     │ Cloud     │   │
│  │ (Free)            │     │ (Spark/Blaze)     │     │ AI APIs   │   │
│  │                   │     │                   │     │           │   │
│  │ • Gemini Proxy    │     │ • Firestore       │     │ • Gemini  │   │
│  │ • Health Check    │     │ • AI Logic (Live) │     │ • STT     │   │
│  │                   │     │ • Anonymous Auth  │     │ • TTS     │   │
│  └──────────────────┘     └───────────────────┘     └───────────┘   │
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐     │
│  │                    ANDROID DEVICE                              │     │
│  │  ┌───────────────────────────────────────────────────────┐   │     │
│  │  │  Handa Flutter App                                      │   │     │
│  │  │  • Drift SQLite  • Audio Storage  • Image Cache        │   │     │
│  │  │  • twin_stream   • Piper TTS     • Vosk (future)       │   │     │
│  │  └───────────────────────────────────────────────────────┘   │     │
│  └─────────────────────────────────────────────────────────────┘     │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### 5.2 CI/CD (Minimal — Personal Project)

| Stage | Tool | Frequency |
|-------|------|-----------|
| **Lint** | `dart analyze` | Every save |
| **Test** | `flutter test` | Every commit |
| **Build APK** | `flutter build apk --release` | Manual |
| **Deploy Worker** | `wrangler deploy` | Manual |
| **Deploy Firestore Rules** | `firebase deploy --only firestore:rules` | When changed |

No CI server needed for a personal project. All builds done locally.

---

## 6. Error Handling & Monitoring

### Error Hierarchy
```dart
sealed class AppFailure {
  final String message;
  final String userMessage;  // Message shown to patient (in Sinhala)
  const AppFailure(this.message, this.userMessage);
}

class NetworkFailure extends AppFailure { ... }
class ApiFailure extends AppFailure { ... }
class AudioFailure extends AppFailure { ... }
class DatabaseFailure extends AppFailure { ... }
class PermissionFailure extends AppFailure { ... }
class ScoringFailure extends AppFailure { ... }
```

### Error Handling Strategy
```
Every repository method returns:  Either<AppFailure, T>

Presentation layer:
  - Show userMessage to patient (Sinhala, gentle tone)
  - Log full message + stack trace locally
  - Provide retry action when appropriate
  - Never crash, never show raw error text
```

### Local Logging
```dart
class AppLogger {
  static const maxLogEntries = 100;
  static final List<LogEntry> _logs = [];
  
  static void log(LogLevel level, String message, [Object? error, StackTrace? stack]) {
    _logs.add(LogEntry(
      timestamp: DateTime.now(),
      level: level,
      message: message,
      error: error?.toString(),
    ));
    
    if (_logs.length > maxLogEntries) _logs.removeAt(0);
    
    // Also print to console in debug mode
    if (kDebugMode) debugPrint('[${level.name}] $message');
  }
  
  static List<LogEntry> getRecentLogs() => List.unmodifiable(_logs);
}
```

---

## 7. Offline Architecture

### Offline-First Principle
```
Every write goes to Drift (local) FIRST
If online → sync to Firestore in background
If offline → queue sync attempt → retry when online
```

### Sync Queue Mechanism
```dart
class SyncService {
  final DriftDatabase _localDb;
  final FirebaseFirestore _firestore;
  
  Future<void> processSyncQueue() async {
    final pendingItems = await _localDb.syncLogDao.getPendingItems();
    
    for (final item in pendingItems) {
      try {
        await _syncItem(item);
        await _localDb.syncLogDao.markSucceeded(item.id);
      } on FirebaseException catch (e) {
        await _localDb.syncLogDao.incrementRetry(item.id);
        if (item.retryCount >= 5) {
          await _localDb.syncLogDao.markFailed(item.id, e.message);
        }
      }
    }
  }
  
  Future<void> _syncItem(SyncLogItem item) async {
    switch (item.tableName) {
      case 'sessions':
        final session = await _localDb.sessionDao.getById(item.recordId);
        if (session != null) {
          await _firestore.collection('sessions').doc(session.id.toString()).set(session.toJson());
        }
        break;
      case 'attempts':
        final attempt = await _localDb.attemptDao.getById(item.recordId);
        if (attempt != null) {
          await _firestore.collection('attempts').doc(attempt.id.toString()).set(attempt.toJson());
        }
        break;
    }
  }
}
```

---

## Architecture Decision Records

| ADR | Decision | Rationale | Status |
|-----|----------|-----------|--------|
| **ADR-001** | Clean Architecture (3 layers) | Testability, separation of concerns | Accepted |
| **ADR-002** | Riverpod over BLoC | Less boilerplate, compile-safe, Drift integration | Accepted |
| **ADR-003** | Drift over sqflite | Type-safe queries, generated code, migrations | Accepted |
| **ADR-004** | Cloudflare Worker for API proxy | Free tier sufficient, API key protection | Accepted |
| **ADR-005** | Firebase AI Logic for Live API | Official Flutter SDK, ephemeral tokens | Accepted |
| **ADR-006** | `twin_stream` for audio capture | Solves Android mic lock, Vosk ready | Accepted |
| **ADR-007** | WebP for all images | ~30% smaller than PNG, sufficient quality | Accepted |
| **ADR-008** | Firestore over Supabase | Built-in offline-first, generous free tier | Accepted |
| **ADR-009** | No CI/CD server (local builds) | Personal project, not worth overhead | Accepted |
| **ADR-010** | Levenshtein for offline scoring | Simple, deterministic, no ML dependency | Accepted |

---

> **Gate Check:** PASS ✅ — Architecture addresses all NFRs (performance, offline, accessibility, security, reliability, cost). All ADRs documented with rationale. Database schema covers all entities. Data flows for online and offline modes are defined.
>
> **Next:** Phase 9 — Device Analysis (Android specifics, screen sizes, hardware constraints)
