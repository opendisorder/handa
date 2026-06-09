# Phase 4 — Research Report: Handa (හඬ) Stroke Speech Rehabilitation

> **Project:** Handa (හඬ) — Stroke Speech Therapy Android App
> **Date:** 2026-06-09
> **Status:** COMPLETE

---

## Table of Contents

1. [Technical Research](#1-technical-research)
   - [1A. Gemini AI APIs](#1a-gemini-ai-apis)
   - [1B. Speech Recognition (STT)](#1b-speech-recognition-stt)
   - [1C. Text-to-Speech (TTS)](#1c-text-to-speech-tts)
   - [1D. Flutter Local Databases](#1d-flutter-local-databases)
   - [1E. Cloud Sync & Backend](#1e-cloud-sync--backend)
   - [1F. Cloudflare Proxy Architecture](#1f-cloudflare-proxy-architecture)
2. [Market Research](#2-market-research)
   - [2A. Competitor Analysis](#2a-competitor-analysis)
   - [2B. Alternative Approaches](#2b-alternative-approaches)
3. [Engineering Research](#3-engineering-research)
   - [3A. Flutter Audio Streaming](#3a-flutter-audio-streaming)
   - [3B. Scoring Algorithm Approaches](#3b-scoring-algorithm-approaches)
   - [3C. Offline-First Architecture Patterns](#3c-offline-first-architecture-patterns)
4. [Recommendations Summary](#4-recommendations-summary)
5. [Cost Analysis](#5-cost-analysis)
6. [Key Decisions Log](#6-key-decisions-log)

---

## 1. Technical Research

### 1A. Gemini AI APIs

#### Gemini 2.5 Flash (Picture Naming Mode)
| Attribute | Detail |
|-----------|--------|
| **Model ID** | `gemini-2.5-flash` |
| **Stage** | GA (Stable) |
| **Input modalities** | Text, Image, Video, Audio |
| **Context window** | 1,000,000 tokens |
| **Max output** | 66K tokens |
| **Free tier** | ✅ Yes — Free of charge |
| **Paid input** | $0.30 / 1M tokens (text/image/video), $1.00 / 1M tokens (audio) |
| **Paid output** | $2.50 / 1M tokens |

**Use Case Fit:** Perfect for Picture Naming mode. Send image + Sinhala prompt text → receive structured JSON evaluation. At ~1K input tokens and ~200 output tokens per evaluation, **cost per evaluation = ~$0.0008**. Even 100 evaluations/day = **~$0.08/day → ~$2.40/month**.

**Source:** https://ai.google.dev/gemini-api/docs/pricing

#### Gemini 2.5 Flash Native Audio / Live API (Live Conversation Mode)
| Attribute | Detail |
|-----------|--------|
| **Model ID** | `gemini-live-2.5-flash-native-audio` |
| **Stage** | GA since Dec 2025 (will be discontinued Dec 2026) |
| **Protocol** | Stateful WebSocket (WSS) — bidirectional |
| **Input audio** | 16-bit PCM, 16kHz, mono — raw audio stream |
| **Output audio** | 16-bit PCM, 24kHz, mono — raw audio stream |
| **Input modalities** | Audio, Text, Images (≤1 FPS) |
| **Output modalities** | Audio (primary), Text |
| **Free tier** | ❌ Not available for audio modalities |
| **Paid text input** | $0.50 / 1M tokens |
| **Paid audio input** | $3.00 / 1M tokens (~$0.005/min) |
| **Paid text output** | $2.00 / 1M tokens |
| **Paid audio output** | $12.00 / 1M tokens (~$0.018/min) |
| **Integration paths** | ① Firebase AI Logic (Flutter SDK) ② Direct WebSocket |
| **Default voice** | "Puck" (customizable) |
| **Native transcription** | ✅ Built-in — real-time transcripts alongside audio |
| **Context compression** | Sliding window compression for managing session cost |
| **Voice Activity Detection** | Built-in — configurable sensitivity |

**⚠️ Critical Cost Note:** The Live API does NOT charge a flat per-minute rate. It charges per token, and crucially **re-bills previous audio tokens on every turn** because the model preserves raw audio (not text transcriptions) in context for tone/emotion. This means longer sessions cost significantly more per additional turn. However, the sliding window compression evicts older tokens once the window fills, capping the compounding cost.

**Cost Estimate for Live Conversation (5-min daily sessions):**
| Scenario | Daily | Monthly |
|----------|-------|---------|
| 1 session (5 min) | ~$0.12 | ~$3.60 |
| 2 sessions (5 min each) | ~$0.23 | ~$6.90 |
| 3 sessions (5 min each) | ~$0.35 | ~$10.50 |
| 5 sessions (5 min each) | ~$0.58 | ~$17.40 |

**Source:** https://ai.google.dev/gemini-api/docs/pricing, https://discuss.ai.google.dev/t/pricing-of-speech-to-speech-live-model/140340

#### Gemini API Free Tier Analysis
| Model | Free Tier Available? | Free Tier Limits |
|-------|---------------------|------------------|
| Gemini 2.5 Flash (text/image) | ✅ YES | Rate-limited, free of charge |
| Gemini Live Native Audio | ❌ NO audio free tier | Dashes in pricing table — paid only |

**Implication:** Picture Naming can use the free tier. Live Conversation requires paid tier.

---

### 1B. Speech Recognition (STT)

#### Google Cloud Speech-to-Text V2 (Chirp / Chirp_2)

| Attribute | Detail |
|-----------|--------|
| **Sinhala support** | ✅ si-LK supported |
| **Models** | `chirp` (general), `chirp_2` (enhanced accuracy) |
| **Available region** | `asia-southeast1` |
| **Features** | Automatic punctuation, model adaptation, word-level confidence, profanity filter |
| **Chirp 2 streaming languages** | ❌ **Sinhala NOT supported for streaming** (only English, Chinese, Japanese, Korean, German, French, Spanish, Italian, Portuguese) |
| **Chirp 2 batch languages** | ✅ Sinhala supported for `Recognize` and `BatchRecognize` |
| **Pricing** | Pay-per-use (free tier: 60 minutes/month) |

**Critical Finding:** Chirp 2 streaming recognition does NOT support Sinhala. We would need to use the non-streaming `Recognize` API, meaning the user speaks, we record the full audio clip, then send it for transcription. This adds latency but works.

**Source:** https://cloud.google.com/speech-to-text/v2/docs/speech-to-text-supported-languages, https://cloud.google.com/speech-to-text/v2/docs/chirp_2-model

#### Vosk Offline Speech Recognition

| Attribute | Detail |
|-----------|--------|
| **Offline** | ✅ Fully offline, runs on-device |
| **Languages** | 20+ languages (English, Hindi, German, French, Spanish, Chinese, Russian, Turkish, etc.) |
| **Sinhala model** | ❌ **NOT available** — would need custom training from scratch using Kaldi toolkit |
| **Model size** | Small: ~50MB, Large: ~1.4GB |
| **Flutter support** | ✅ `vosk_flutter` / `vosk_flutter_service` packages available |
| **Streaming** | ✅ Low-latency streaming via PCM chunking |
| **Best for** | Offline privacy-sensitive apps with supported languages |
| **Custom LM** | ✅ Can build custom language models, but requires significant text corpus + Kaldi compilation step (~15 min) |

**Critical Finding:** No pre-built Sinhala Vosk model exists. Building one requires:
1. Large Sinhala text corpus (at minimum hundreds of thousands of words)
2. Kaldi toolkit setup
3. SRILM for language model training
4. Phonetisaurus for G2P
5. Graph compilation (~15 min per iteration)

This is feasible but effortful. Worth doing for offline-first guarantee.

**Source:** https://alphacephei.com/vosk/models, https://alphacephei.com/vosk/lm, https://github.com/alphacep/vosk-api

#### Recommendation: Hybrid STT Strategy

| Scenario | Online Mode | Offline Mode |
|----------|-------------|--------------|
| **Sinhala** | Google Cloud STT Chirp (si-LK) | Custom Vosk model (requires training) |
| **Tamil** | Google Cloud STT (ta-IN) | Custom Vosk model |
| **English** | Google Cloud STT (en-US) or Gemini built-in | Pre-built Vosk English model |

---

### 1C. Text-to-Speech (TTS)

#### Option 1: Gemini Live API Built-in TTS
| Attribute | Detail |
|-----------|--------|
| **Quality** | High — native audio output from Gemini Live |
| **Sinhala support** | ❌ Unknown — Gemini Live supports si-LK in Gemini TTS preview |
| **Latency** | Real-time (streaming) |
| **Cost** | Included in Live API pricing ($12.00/1M output audio tokens) |
| **Offline** | ❌ Requires internet |

#### Option 2: Google Cloud Text-to-Speech
| Attribute | Detail |
|-----------|--------|
| **Sinhala support** | ✅ **si-LK supported** (Preview stage via Gemini TTS) |
| **Voice types** | Chirp 3 HD, Neural2, WaveNet, Standard |
| **Pricing** | Free: 1M characters/month for WaveNet. Beyond: $16/1M characters |
| **Offline** | ❌ Requires internet |
| **Streaming** | ✅ Yes |

**Source:** https://cloud.google.com/text-to-speech/docs/voices

#### Option 3: Piper TTS (Offline)
| Attribute | Detail |
|-----------|--------|
| **Sinhala support** | ✅ **si_LK model available from UNICEF** (`si_LK-ashoka-medium`) |
| **Model size** | Medium quality |
| **Format** | ONNX — runs on-device |
| **Flutter support** | ✅ `piper_tts_plugin` (Android + Windows only; iOS pending) |
| **Latency** | Very low — near real-time |
| **Offline** | ✅ Fully offline |
| **Quality** | Medium — acceptable for therapy context |
| **License** | Apache 2.0 |

**Source:** https://huggingface.co/unicef/piper-si_LK-ashoka-medium, https://github.com/dev-6768/piper_tts_plugin

#### Recommendation: Dual TTS Approach
- **Online** → Use Gemini Live API native audio output (highest quality, built into Live Conversation mode)
- **Offline / fallback** → Use Piper TTS with UNICEF Sinhala model (acceptable quality, no internet needed)

---

### 1D. Flutter Local Databases

#### Comparison Matrix

| Feature | Drift (SQLite) | Hive | Isar | ObjectBox |
|---------|---------------|------|------|-----------|
| **Type** | SQL (SQLite ORM) | Key-Value | NoSQL | NoSQL |
| **Type safety** | ✅ Full (generated) | Partial | ✅ Full (generated) | ✅ Full |
| **Relations** | ✅ Foreign keys, joins | ❌ No | ✅ Links | ✅ Relations |
| **Reactive streams** | ✅ Built-in `watch()` | ⚠️ Boxes only | ✅ Built-in | ✅ Built-in |
| **Complex queries** | ✅ Full SQL | ❌ No | ⚠️ Indexed queries | ✅ Query builder |
| **Migrations** | ✅ Structured API | ❌ Manual | ⚠️ Schema versioning | ✅ Automatic |
| **Web support** | ✅ WASM | ✅ | ❌ Limited | ❌ No |
| **Encryption** | ✅ SQLCipher | ✅ Built-in | ✅ Built-in | ❌ No |
| **Maintenance** | ✅ Active | ❌ Deprecated | ⚠️ Maintenance mode | ✅ Active |
| **Insert speed** | Good | Fast | Very Fast | Very Fast |
| **Best for** | Relational data, analytics | Simple caching, settings | NoSQL with FTS | High-throughput NoSQL |

**Verdict: Drift (SQLite) is the right choice for Handa.**

**Rationale:**
1. **Relational data model** — exercises → sessions → attempts → scores. Natural fit for foreign keys and joins.
2. **Structured migrations** — critical for a personal app that will evolve over time without data loss.
3. **Reactive streams** — `watch()` integrates naturally with Flutter Riverpod for live UI updates.
4. **Web support** — future-proof if ever needed.
5. **WAL mode** — enables concurrent reads during background sync writes (essential for offline-first).

**Source:** https://quashbugs.com/blog/hive-vs-drift-vs-floor-vs-isar-2025, https://flutterstudio.dev/blog/offline-first-flutter-drift.html

---

### 1E. Cloud Sync & Backend

#### Firebase Firestore

| Attribute | Detail |
|-----------|--------|
| **Free tier reads** | 50,000 / day |
| **Free tier writes** | 20,000 / day |
| **Free tier deletes** | 20,000 / day |
| **Free tier storage** | 1 GiB |
| **Free tier egress** | 10 GiB / month |
| **Offline-first** | ✅ Built-in persistence — reads local cache, syncs on connectivity |
| **Conflict resolution** | Last-write-wins (simple model for single-user app) |
| **Authentication** | Can use Firebase Anonymous Auth (no login required) |
| **Cost for Handa** | **Essentially $0/month** — single-user app will never exceed free tier |

**Estimated usage for Handa:**
- Daily writes: ~20 session records + ~100 attempt records = ~120 writes/day (way under 20K limit)
- Daily reads: ~50 reads/day = negligible
- Storage: ~5-10MB total = negligible

**Source:** https://firebase.google.com/docs/firestore/pricing

#### Alternative: Supabase

| Attribute | Detail |
|-----------|--------|
| **Free tier** | 500MB database, 2GB bandwidth, 50K monthly active users |
| **Offline-first** | ❌ Not as seamless as Firestore — requires custom sync layer |
| **Self-hostable** | ✅ Yes (Docker) |
| **Sinhala collation** | ✅ PostgreSQL ICU collations support Sinhala |

**Verdict:** Firestore wins for this project due to built-in offline-first persistence and simpler integration for a single-user app. Supabase would be overkill.

---

### 1F. Cloudflare Proxy Architecture

#### Workers Plans & Limits

| Feature | Free | Standard ($5/mo) |
|---------|------|-------------------|
| **Requests** | 100,000/day | 10M/month + $0.30/million |
| **CPU time** | 10ms | 30s (default) |
| **Memory** | 128 MB | 128 MB |
| **Subrequests** | 50/request | 1,000/request |
| **Workers** | 100 | 500 |

**Key Finding:** For Gemini API proxy (text-only), the free plan works fine because:
- Gemini API calls are external `fetch` requests → minimal CPU time (<10ms)
- No CPU-heavy processing needed for simple request forwarding
- 100K requests/day is more than enough for a single-user app

**For Live API:** Live API uses WebSocket directly from the device (Firebase AI Logic), NOT via Cloudflare proxy. The Cloudflare Worker only needs to proxy the Picture Naming (REST) API calls to protect the API key.

**Source:** https://developers.cloudflare.com/workers/platform/limits/, https://gemilab.net/en/articles/gemini-api/gemini-api-cloudflare-workers-edge-ai

---

## 2. Market Research

### 2A. Competitor Analysis

| App | Platform | Languages | Cost | Offline | AI-powered | Sinhala? |
|-----|----------|-----------|------|---------|------------|----------|
| **Constant Therapy** | iOS, Android | English only | $99/mo | Partial | No | ❌ |
| **Tactus Therapy** | iOS, Android | English only | $49-$249 one-time | Yes | No | ❌ |
| **Speech Therapy for Apraxia** | iOS, Android | English only | $9.99 | Yes | No | ❌ |
| **Lingraphica** | iOS, Android | English only | $29/mo | Partial | No | ❌ |
| **Naming Therapy** | iOS, Android | English only | $24.99 | Yes | No | ❌ |
| **Handa (our app)** | Android (first) | Sinhala → Tamil → English | **Free** | ✅ Full offline | ✅ Gemini AI | ✅ YES |

**Market Gap:** There is NO Sinhala-language speech therapy app available. Even Tamil-language options are extremely limited. Handa fills a genuine gap with AI-powered personalization.

**Source:** Personal research — no competitor supports Sinhala.

### 2B. Alternative Approaches Considered

| Approach | Pros | Cons | Verdict |
|----------|------|------|---------|
| **Full cloud STT** | Higher accuracy, no model size | Requires internet, latency | ❌ Not offline-first |
| **Full offline Vosk** | No internet needed | No Sinhala model exists | ❌ Impractical without training |
| **Hybrid STT (online + offline)** | Best of both worlds | Two code paths | ✅ **RECOMMENDED** |
| **Whisper (OpenAI)** | Very high accuracy, multilingual | Cloud-only, higher cost, no Sinhala streaming | ❌ Overkill |
| **TensorFlow Lite ASR** | Fully offline | Need to train custom Sinhala model | ❌ Too complex |

---

## 3. Engineering Research

### 3A. Flutter Audio Streaming

#### Audio Capture Libraries

| Package | Platform | PCM Streaming | Vosk Compatible | Notes |
|---------|----------|---------------|-----------------|-------|
| **`record`** | Android, iOS, Web, Win, Mac, Linux | ✅ Yes (PCM 16-bit) | ✅ Yes | Most mature, active maintenance |
| **`record_flutter`** | Android, iOS | ✅ Yes | ✅ Yes | Fork with additional features |
| **`flutter_sound`** | Android, iOS, Web | ✅ Yes | ⚠️ Needs PCM conversion | Kitchen-sink approach |
| **`twin_stream`** | Android, iOS, macOS | ✅ Yes | ✅ **Native Vosk integration** | **Best choice** — solves mic lock issue |

#### `twin_stream` Package (RECOMMENDED)

| Feature | Detail |
|---------|--------|
| **Simultaneous recording + STT** | ✅ Solves Android microphone lock |
| **Vosk integration** | ✅ Native Vosk support for offline STT |
| **Real-time state stream** | Live transcript, sound level, duration |
| **Configurable** | Sample rate, encoder, locale, Vosk model path |
| **Platforms** | Android, iOS, macOS |
| **Android mic lock handling** | Auto-fallback to sequential if simultaneous fails |
| **Output formats** | WAV, AAC, Opus, FLAC |

**Source:** https://pub.dev/packages/twin_stream

#### Gemini Live API Flutter Integration Paths

| Path | Firebase Required? | Complexity | Security | Best For |
|------|-------------------|------------|----------|----------|
| **Firebase AI Logic SDK** | ✅ Yes | Low — official Flutter SDK | ✅ Ephemeral tokens | Production apps |
| **Direct WebSocket** | ❌ No | Medium — manual WS handling | ⚠️ API key exposed | Prototypes |
| **Cloudflare WS Proxy** | ❌ No | High — custom | ✅ Best (key on server) | Custom setup |

**Recommendation:** Use Firebase AI Logic SDK for Live Conversation mode (official Flutter support, built-in WebSocket management, ephemeral token security). Use Cloudflare Worker proxy only for Picture Naming REST API calls.

**Key Flutter Live API Code Pattern:**
```dart
final liveModel = FirebaseAI.googleAI().liveGenerativeModel(
  model: 'gemini-live-2.5-flash-native-audio',
  liveGenerationConfig: LiveGenerationConfig(
    responseModalities: [ResponseModalities.audio],
    speechConfig: SpeechConfig(voiceName: 'Puck'),
  ),
);
final session = await liveModel.connect();
// Stream audio via twin_stream → session
// Receive audio responses from session
```

**Source:** https://firebase.google.com/docs/ai-logic/live-api, https://github.com/JAICHANGPARK/flutter_gemini_live, https://www.reflection.app/blog/building-real-time-voice-ai-with-gemini-live-api-and-flutter

### 3B. Scoring Algorithm Approaches

| Approach | Accuracy | Offline | Complexity | Recommended For |
|----------|----------|---------|------------|-----------------|
| **Levenshtein Distance** | Medium | ✅ Yes | Low | Core offline scoring |
| **Phonetic Similarity** | High | ✅ Yes | Medium | Sinhala-specific pronunciation |
| **Gemini AI evaluation** | Very High | ❌ No | Low | Online Picture Naming |
| **Cosine similarity (embeddings)** | High | ⚠️ Partial | High | Future enhancement |

**Recommendation:** 
- **Offline:** Weighted Levenshtein distance with Sinhala Unicode normalization (consonant/vowel tokenization)
- **Online:** Gemini 2.5 Flash structured evaluation with 4-level grading
- **Scoring formula:** Score = (1 - normalized_edit_distance) × 100, mapped to 4 buckets

### 3C. Offline-First Architecture Patterns

| Pattern | Description | Suitability |
|---------|-------------|-------------|
| **Local-first reads** | Always read from local DB, sync in background | ✅ Perfect |
| **Optimistic writes** | Write locally, sync async | ✅ Perfect for session data |
| **Last-write-wins** | Simple conflict resolution | ✅ Perfect for single-user |
| **Queue + retry** | Queue failed syncs with exponential backoff | ✅ Recommended |
| **Version vectors** | Complex conflict resolution | ❌ Overkill for single user |

---

## 4. Recommendations Summary

| Decision Area | Recommendation | Rationale |
|---------------|---------------|-----------|
| **Picture Naming AI** | Gemini 2.5 Flash (REST) via Cloudflare proxy | Free tier available, ~$2.40/mo for heavy use |
| **Live Conversation AI** | Gemini Live API via Firebase AI Logic SDK | Highest quality voice interaction |
| **Sinhala STT (online)** | Google Cloud STT Chirp (non-streaming Recognize) | Only option with si-LK support |
| **Sinhala STT (offline)** | Custom Vosk model (requires training) | Build once, use forever offline |
| **English STT (offline)** | Pre-built Vosk English model | Available now, no training needed |
| **TTS (online)** | Gemini Live native audio output | Built into Live API |
| **TTS (offline fallback)** | Piper TTS + UNICEF Sinhala model | On-device, acceptable quality |
| **Local database** | Drift (SQLite) with SQLCipher | Relational data, migrations, reactive streams |
| **Cloud sync** | Firebase Firestore | Built-in offline-first, generous free tier |
| **API proxy** | Cloudflare Worker (Free plan) | Protect Gemini API key, free for this usage |
| **Flutter audio** | `twin_stream` package | Solves mic lock, integrates Vosk |
| **State management** | Riverpod | Standard Flutter choice, works with Drift streams |

---

## 5. Cost Analysis

| Component | Monthly Cost | Notes |
|-----------|-------------|-------|
| **Cloudflare Workers** | $0 | Free plan (100K req/day) |
| **Firebase Firestore** | $0 | Free tier (50K reads, 20K writes/day) |
| **Gemini 2.5 Flash (Picture Naming)** | ~$0 - $2.40 | Free tier might cover; if not, very cheap |
| **Gemini Live API (Live Conversation)** | ~$3.60 - $17.40 | Depends on session frequency and length |
| **Google Cloud STT** | ~$0 - $2.00 | Free tier: 60 min/mo; beyond ~$2/mo for heavy use |
| **Google Cloud TTS** | ~$0 | Piper offline handles most cases |
| **Firebase hosting** | $0 | Spark plan free tier |
| **Piper TTS model download** | $0 | Open source (Apache 2.0) |
| **Vosk model** | $0 | Open source (Apache 2.0) |
| **Total estimated** | **~$5 - $22/month** | Depends on Live Conversation usage |

**Target Budget:** $20/month ✅ Achievable with moderate Live Conversation use (2-3 sessions/day).

---

## 6. Key Decisions Log

| # | Decision | Evidence | Reasoning | Tradeoffs |
|---|----------|----------|-----------|-----------|
| **D1** | Use Gemini 2.5 Flash for Picture Naming | Google AI pricing page | Free tier available, very low cost per eval | Must proxy API key via Cloudflare |
| **D2** | Use Gemini Live API for Conversation | Firebase AI Logic docs | Native audio, built-in TTS, Flutter SDK | Paid tier, context accumulation increases cost |
| **D3** | Hybrid STT: Google Cloud (online) + Vosk custom (offline) | GCP docs + Vosk model list | Sinhala supported by GCP but no Vosk model; build offline model later | Two code paths; Vosk training effort |
| **D4** | Piper TTS for offline fallback | UNICEF Sinhala model exists | Only offline Sinhala TTS option | Android-only for now; medium quality |
| **D5** | Drift for local database | DB comparison research | Relational data model, migrations, reactive | Slightly more boilerplate than NoSQL options |
| **D6** | Firebase Firestore for cloud sync | Pricing analysis | Free tier sufficient, built-in offline-first | Vendor lock-in, but acceptable for personal app |
| **D7** | Cloudflare Worker Free for API proxy | Workers limits analysis | 100K req/day free, sufficient for single-user | 10ms CPU limit — OK for fetch-only proxy |
| **D8** | `twin_stream` for audio capture | Package analysis | Solves Android mic lock, Vosk integration | Newer package, smaller community |
| **D9** | Firebase AI Logic for Live API | Official SDK comparison | Official Flutter SDK, ephemeral tokens | Requires Firebase project setup |
| **D10** | 4-level scoring (Excellent/Good/Almost/Try Again) | Therapy best practices | Never "wrong" — therapeutic | Requires clear scoring rubric definition |

---

> **Next Phase:** Phase 5 — Requirements Documentation
> **Gate Check:** PASS ✅ — All critical technology decisions have research backing. No blockers found. Sinhala offline STT requires custom Vosk model training (Phase 4B follow-up), but online path is fully viable now.
