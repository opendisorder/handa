# Phase 13 — Progress Tracker: Handa (හඬ)

> **Project:** Handa (හඬ) — Stroke Speech Therapy Android App
> **Date:** 2026-06-10
> **Status:** LIVE (updated every phase)

---

## Overall Progress

| Phase | Status | Progress | Artifact | Extension |
|-------|--------|----------|----------|-----------|
| 1 — Intent Discovery | ✅ COMPLETE | 100% | `docs/intent-report.md` | — |
| 2 — Gap Analysis | ✅ COMPLETE | 100% | `docs/gap-analysis-report.md` | — |
| 3 — Contradiction Detection | ✅ COMPLETE | 100% | `docs/conflict-report.md` | — |
| 4 — Research | ✅ EXTENDED | 100% | `docs/research-report.md` | `docs/research-update-reference-implementation.md` |
| 5 — Requirements | ✅ EXTENDED | 100% | `docs/requirements-document.md` | `docs/requirements-extension-psychology-cueing.md`, `docs/requirements-update-reference.md` |
| 6 — Product Definition | ✅ EXTENDED | 100% | `docs/product-definition.md` | `docs/product-definition-extension-psychology.md` |
| 7 — UX Planning | ✅ EXTENDED | 100% | `docs/ux-plan.md` | `docs/ux-extension-session-structure.md` |
| 8 — Architecture | ✅ EXTENDED | 100% | `docs/architecture-document.md` | `docs/architecture-extension-memory-agents.md`, `docs/architecture-update-reference.md` |
| 9 — Device Analysis | ✅ COMPLETE | 100% | `docs/device-analysis.md` | — |
| 10 — Dependency Mapping | ✅ EXTENDED | 100% | `docs/dependency-map.md` | `docs/dependency-map-update-reference.md` |
| 11 — Priority Matrix | ✅ EXTENDED | 100% | `docs/priority-matrix.md` | `docs/priority-matrix-extension.md` |
| 12 — Implementation Roadmap | ✅ EXTENDED | 100% | `docs/implementation-roadmap.md` | `docs/roadmap-extension.md` |
| 13 — Progress Tracker | 🔵 LIVE | 100% | `docs/progress-tracker.md` | — |
| 14 — Validation Gate | ✅ COMPLETE | 100% | `docs/validation-gate-report.md` | (updated below) |
| 15 — Coding Order | ✅ EXTENDED | 100% | `docs/coding-order.md` | `docs/coding-order-update-reference.md` |

**Overall completion: 15/15 phases (100%) + 5 reference update documents (Phase 4, 5, 8, 10, 15). Plan enriched with web reference implementation (20 files from Google Vertex AI Studio export).**

---

## Completed Phases

### Phase 1 — Intent Discovery
- Asked and answered all 7 intent questions
- Identified core need: Sinhala stroke speech therapy for user's father
- Key constraint: No login, no monetization, <$20/month, offline-first

### Phase 2 — Gap Analysis
- Identified 30 gaps across 10 categories
- 10 critical gaps resolved (Sinhala TTS, streaming STT, image licensing, etc.)
- Key finding: Vosk has no Sinhala model — need custom training or Google STT

### Phase 3 — Contradiction Detection
- Found 11 conflicts, resolved 10, 1 ongoing (offline Vosk STT viability)
- Key resolution: Hybrid online/offline strategy (Google STT when online, custom Vosk when offline)

### Phase 4 — Research
- Researched: Gemini APIs, STT options, TTS options, databases, Cloudflare Workers, audio streaming
- Key findings: Gemini 2.5 Flash ($0.30/1M input), Live API ($0.005/min input, $0.018/min output)
- Piper TTS has Sinhala model (UNICEF, ONNX, offline)
- Drift (SQLite) best for relational therapy data
- Firestore free tier sufficient (50K reads/day)
- **[NEW] Reference Implementation Deep-Dive** (2026-06-10):
  - Acquired Google Vertex AI Studio exported project (React/TypeScript/Node.js — 20 files)
  - **Critical discovery:** Empty `{}` for transcription configs (reference uses `{}`, not `{languageCodes: [...]}`)
  - Audio pipeline: ScriptProcessor 4096 buffer → Int16 PCM → base64 → sendRealtimeInput
  - Widget mapping: 4 components (Conversation, Breathing, Exercise, Report) with direct Flutter equivalents
  - Proxy backend pattern: Node.js Express + ws with ADC OAuth2 token injection
  - 11 tools vs reference's 4 tools — our suite is more complete
  - Full analysis: `docs/research-update-reference-implementation.md`

### Phase 5 — Requirements
- 18 functional requirements with acceptance criteria
- 10 non-functional requirements with measurable targets
- MVP defined: 10 Must-Haves, 4 Should-Haves, 6 Could-Haves
- Critical: 28sp minimum font, warm color palette, no red colors

### Phase 6 — Product Definition
- Name: Handa (හඬ) — "Voice" in Sinhala
- 3 user personas: Sunil (patient, 72), Ruwan (caregiver, 42), Dr. Kumari (therapist, 38)
- 10 KPIs defined with measurable targets
- Success metrics at 3 months and 6 months

### Phase 7 — UX Planning
- Complete information architecture (app map)
- 4 user flows defined (daily session, caregiver access, onboarding, typical week)
- 20 screens inventoried with key components
- Interaction patterns for all user actions with error recovery
- Sinhala feedback phrases for all 4 score levels
- 10 accessibility design decisions

### Phase 8 — Architecture
- Clean Architecture: data → domain → presentation layers
- Drift schema: 6 tables (categories, exercises, sessions, attempts, live_conversations, settings)
- Cloudflare Worker proxy for Gemini API key
- Firebase AI Logic for Live Conversation (WebSocket)
- Scoring engine: Levenshtein (offline) + Gemini (online)
- 10 Architecture Decision Records documented

### Phase 9 — Device Analysis
- Primary target: Android tablet (7-12")
- Minimum: Android 8.0 (API 26), 3GB RAM
- Screen size adaptation strategy with breakpoints (sw600dp)
- Device tier detection (low/mid/high) for animation complexity
- All Android permissions documented

### Phase 10 — Dependency Mapping
- 5-phase dependency tree (Foundation → Core → Advanced → Caregiver → Polish)
- Foundation is entirely sequential (no parallelization)
- No circular dependencies
- 5 dependency rules defined

### Phase 11 — Priority Matrix
- 17 Must Have (37%) ✅ under 40% threshold
- 8 Should Have (17%)
- 12 Could Have (26%)
- 9 Won't Have (20%)
- Total effort: 65 days for active items

### Phase 12 — Implementation Roadmap
- 5 milestones over 9 weeks
- M1: Foundation (2 wk) → M2: Core Therapy (2 wk) → M3: Live Conversation (2 wk) → M4: Caregiver (2 wk) → M5: Polish (1 wk)
- Risk-adjusted with 2-week contingency buffer
- Each milestone has validation gates

---

## Current Status

**Current Phase:** Phase 14 — Validation Gate (PASSED) / Phase 15 — Coding Order (EXTENDED with reference)
**Next Phase:** Implementation — M1: Foundation (Priority: Fix transcription config → AudioUtils → LiveSessionController → Widgets)
**Blockers:** ~~🔴 `gemini_live: ^2026.6.6` requires Dart SDK >= 3.8.1~~ **RESOLVED** — Package removed; using custom Vertex AI Bidi WebSocket with ADC (works on Dart 3.7.2)
**Decisions Made in Last Session:**
- Naming: Handa (හඬ) confirmed
- Architecture: Clean Architecture + Drift + Riverpod
- Audio: twin_stream for capture, Piper for offline TTS
- Scoring: Levenshtein + Gemini dual engine
- Cloud: Firestore for sync, Cloudflare Worker for API proxy
- **NEW:** Two-layer memory architecture (Live + Background Agent)
- **NEW:** AI persona: "Thilina" — Sinhala speech therapist
- **NEW:** Cueing ladder: 5-level progressive scaffolding
- **NEW:** 6-phase session structure (20-30 min therapeutic flow)
- **NEW:** On-device detectors: silence + MediaPipe Face Mesh
- **NEW:** Psychological red flag detection + caregiver escalation
- **NEW:** Memory preload system for cross-session continuity

**Decisions from Reference Implementation (2026-06-10):**
- **Transcript config: empty `{}` not `{languageCodes: [...]}`** — Critical change from reference analysis
- **LiveSessionController pattern** — Single controller (300 lines, modeled on useGeminiLive.ts) manages all Live I/O
- **AudioOutputController** — Sequential queue with `nextStartTime` accumulator + interruption support
- **AudioUtils** — Pure static PCM encode/decode class (50 lines, modeled on audioUtils.ts)
- **4 widget translations** — Conversation, Breathing, Exercise, Report from reference TSX → Dart
- **Widget routing via Riverpod state** — `activeWidget` enum drives screen switching

**Project Plan updates this session:**
- Created `thilina_prompt.dart` — Full Thilina persona + 11 function declarations (AURA guide-complete)
- Updated live_api_service.dart — Accepts systemInstruction param, full Vertex model path
- Created `adc_token_provider.dart` — AdcTokenProvider + BackendTokenProvider with auto-refresh
- Migrated GeminiApiClient to Vertex AI OAuth2 with API key fallback
- Wrote 5 reference-update documents (Phase 4, 5, 8, 10, 15)
- Extracted and analyzed reference implementation (20 files, 58KB zip)

---

## Key Metrics

| Metric | Value |
|--------|-------|
| Total phases completed | 15/15 (100%) + 5 reference updates |
| Documents written | 26 (13 original + 6 extensions + 2 reference docs + 5 reference-update docs) |
| Total pages of planning | ~300+ (including reference implementation analysis) |
| User stories documented | 30 FRs (18 original + 7 psychology + 5 reference) |
| Non-functional requirements | 14 (10 original + 3 psychology + 1 reference) |
| Database tables | 6 (+ 3 new collections in Firestore) |
| Components designed | 30+ (with 4 new widget translations) |
| Personas created | 3 (1 deepened with psychological profile) |
| Reference files analyzed | 20 files (13 frontend, 6 backend, 1 root config — 58KB exported from Vertex AI Studio) |
| Live API modules designed | 5 (LiveSessionController, AudioOutputController, AudioUtils, Widget Router, Session State Provider) |
| Widget translations from reference | 4 (Conversation, Breathing, Exercise, Report) |
| MVP Must-Haves | 15 (re-prioritized with cueing ladder as P0) |
| Estimated build time | 7 weeks (with memory + psychology) |
| Estimated monthly cost | $15-50 (Gemini Live + Background Agent + Storage) |
| Psychological techniques documented | 6 (identity reinforcement, validation, containment, etc.) |
| Exercise types | 5 (A: Naming, B: Repetition, C: Fluency, D: Comprehension, E: Functional) |

---

## Decisions Made (2026-06-09 Session)
- **ADC over API Key**: Using Vertex AI with OAuth2 tokens (project `biz-studio-1779528000`) instead of Generative Language API with API key
- **Custom WebSocket over package**: Removed `gemini_live: ^2026.6.6` — implementing custom `GeminiLiveClient` using `web_socket_channel` + Vertex AI Bidi endpoint
- **No Dart SDK upgrade needed**: Current Flutter 3.29.2 / Dart 3.7.2 is sufficient with custom implementation
- **Cloudflare Worker as token relay**: Worker proxies Vertex AI requests with ADC tokens, not API keys

## Next Actions

| Action | Owner | Due | Status |
|--------|-------|-----|--------|
| **🔴 Fix transcription config** — Change `{}` from `{languageCodes: [...]}` in live_api_service.dart | Developer | Immediate | ⏳ PRIORITY |
| **🔴 Implement `AudioUtils`** — PCM encode/decode, Float32↔Int16, base64 | Developer | Sprint 1 | ⏳ |
| **🔴 Implement `AudioOutputController`** — Sequential queue + interruption | Developer | Sprint 1 | ⏳ |
| **🔴 Implement `LiveSessionController`** — Single controller for all Live I/O | Developer | Sprint 1 | ⏳ |
| Begin M1 implementation (Sprint 1: constants, theme, database) | Developer | Sprint 1 | ⏳ |
| Implement `VertexAiAuth` (token acquisition + refresh) | Developer | Sprint 1 | ⏳ |
| Build Drift schema (6 tables) | Developer | Sprint 1-2 | ⏳ |
| Source 100+ WebP images | Developer | Sprint 1-2 | ⏳ |
| App shell + navigation | Developer | Sprint 1 | ⏳ |
| Translate 4 reference widgets to Flutter | Developer | Sprint 2 | ⏳ |
| Re-test ADC token after 1h to verify refresh | Developer | Before Sprint 6 | ⏳ |
| **Test empty transcription config** — Verify serverContent messages arrive | Developer | Immediate | ⏳ PRIORITY |

---

## Blockers & Risks

| Blocker | Impact | Status | Mitigation |
|---------|--------|--------|------------|
| ~~`gemini_live: ^2026.6.6` requires Dart SDK >= 3.8.1~~ | ~~Blocks ALL Gemini Live integration~~ | ✅ RESOLVED | Custom Vertex AI Bidi WebSocket client using ADC OAuth2 tokens. No SDK upgrade needed. |
| ADC token expiry (1 hour default) | Background agent fails after 1hr | 🟡 MONITOR | Implement token refresh in `VertexAiAuth` class — use refresh token from ADC JSON |
| ADC refresh token expires | Full auth failure | 🟡 MONITOR | ~7 day refresh window. `gcloud auth application-default login` re-auth needed |
| MediaPipe package compatibility | On-device detection delayed | 🟡 PENDING | Start with silence-only detection, add MediaPipe later |

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Gemini Live API cost higher than estimated | Medium | $15-50/mo | Use session duration limits, text-only fallback |
| Sinhala TTS quality (Piper) | Medium | User experience | Pre-recorded audio fallback |
| Android haptic variation across devices | Low | UX inconsistency | Use only platform HapticFeedback API |
| Time availability for build | Medium | Schedule slip | 7-week plan with buffer |
| Background agent latency >60s | Medium | User frustration | Use Gemini Flash (fastest), optimize upload |
| AI persona drift over time | Medium | Inconsistent experience | Version-controlled system prompt, consistency tests |
| Patient doesn't engage with AI | Medium | Product failure | Test early (Week 3), iterate persona based on father's reactions |

---

## Changelog (Recent)

| Date | Phase | Change |
|------|-------|--------|
| 2026-06-10 | 🔬 | Extracted & analyzed reference implementation from `aura-speech-therapy.zip` (20 files, 58KB) |
| 2026-06-10 | 4 REF | Created `docs/research-update-reference-implementation.md` — deep-dive of all 20 files |
| 2026-06-10 | 5 REF | Created `docs/requirements-update-reference.md` — 6 new FRs (widget routing, audio queue, empty transcription config) |
| 2026-06-10 | 8 REF | Created `docs/architecture-update-reference.md` — LiveSessionController, AudioOutputController, AudioUtils, 4 ADRs |
| 2026-06-10 | 10 REF | Created `docs/dependency-map-update-reference.md` — new dependency tree with AudioUtils → AudioOutputController → LiveSessionController |
| 2026-06-10 | 15 REF | Created `docs/coding-order-update-reference.md` — expanded Sprint 6 (12 files + 4 tests), ~1,100 new lines |
| 2026-06-10 | Impl | Created `lib/data/services/thilina_prompt.dart` — full Thilina persona + 11 function declarations |
| 2026-06-10 | Impl | Created `lib/data/services/adc_token_provider.dart` — AdcTokenProvider + BackendTokenProvider |
| 2026-06-10 | Impl | Rewrote `lib/data/services/live_api_service.dart` — uses gemini_live_fork + OAuth2 |
| 2026-06-10 | Impl | Updated `lib/core/constants/app_constants.dart` — GCP project, model split |
| 2026-06-10 | Impl | Migrated `lib/data/datasources/remote/gemini_api_client.dart` — Vertex AI OAuth2 |
| 2026-06-10 | Fork | Wrote `packages/gemini_live_fork/lib/src/model/models.g.dart` (1537 lines, camelCase keys) |
| 2026-06-10 | Fork | Moved package from `lib/data/services/gemini_live_fork` → `packages/gemini_live_fork` |
| 2026-06-10 | Fork | Updated `pubspec.yaml` with path dependency on vendored fork |
| 2026-06-10 | 🔬 | Saved `AURA_Vertex_AI_Implementation_Guide.md` (reference doc - Thilina prompt source) |
| 2026-06-10 | 🔬 | Saved `aura-speech-therapy.zip` — Google Vertex AI Studio exported project |
| 2026-06-09 | 1-13 | Original planning complete — 13/15 phases |
| 2026-06-09 | ADC | Setup ADC via `setup_adc.sh` — project `biz-studio-1779528000` |
| 2026-06-09 | Auth | Gemini API verified via Vertex AI — `gemini-2.5-flash` responds ✅ |
| 2026-06-09 | 🔧 | Removed `gemini_live` package. Replaced with custom Vertex AI Bidi WebSocket + ADC OAuth2 |
| 2026-06-09 | Config | Saved GCP config to `assets/config/gcp_config.json`, API key to `.env.example` |
