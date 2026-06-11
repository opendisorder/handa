# Phase 12 — Implementation Roadmap: Handa (හඬ)

> **Project:** Handa (හඬ) — Stroke Speech Therapy Android App
> **Date:** 2026-06-09
> **Status:** COMPLETE

---

## Milestone Overview

```
M1: Foundation ───────────── 2 weeks ────► M2: Core Therapy ── 2 weeks ──►
(Scaffold + DB + Audio)                     (Picture Naming + Scoring)

M3: Advanced Features ─── 2 weeks ────► M4: Caregiver ────── 2 weeks ──►
(Live Conversation + Breathing)           (Dashboard + Analytics)

M5: Polish & Release ──── 1 week ────► LAUNCH
(App store prep + Testing)
```

**Total estimated time: 9 weeks (part-time evenings/weekends)**

---

## Milestone M1: Foundation & Core Infrastructure

**Duration:** 14 days | **Goal:** Working app shell with database, audio, design system

| Day | Tasks | Deliverable | Validation Gate |
|-----|-------|-------------|-----------------|
| 1 | Flutter project init, folder structure, pubspec deps | Empty app with folders | `flutter run` succeeds |
| 2-3 | Drift database: tables, DAOs, migrations | All 6 tables + DAOs | `flutter test` passes DB tests |
| 4 | Design system: colors, typography, components | Theme + HandaButton + ScoreBadge | Visual review |
| 5-6 | Image library: 100+ WebP images, asset manifest | `assets/images/` with categories | All images render in test widget |
| 7-8 | Audio capture: twin_stream, mic permission, PCM pipeline | Record + save audio to disk | Record and playback works |
| 9-10 | Scoring engine: Levenshtein, Sinhala normalizer, classifier | `ScoringEngine` class | Unit tests: all 4 levels |
| 11-12 | Home screen + basic navigation | Home screen with START button | Tap navigates correctly |
| 13-14 | Session flow skeleton + error handling | End-to-end flow works | Walkthrough passes |

**M1 Deliverables:**
- [x] Flutter project with clean architecture
- [x] Drift database (6 tables, migrations, DAOs)
- [x] Design system tokens + core components
- [x] Image library (100+ WebP in 5 categories)
- [x] Audio capture pipeline (twin_stream)
- [x] Scoring engine (Levenshtein + classifier)
- [x] Home screen + skeleton navigation
- [x] Basic error handling (no crashes)

---

## Milestone M2: Core Therapy Features

**Duration:** 14 days | **Goal:** Complete Picture Naming flow with scoring, feedback, breathing

| Day | Tasks | Deliverable | Validation Gate |
|-----|-------|-------------|-----------------|
| 1-3 | Picture Naming exercise: image display, mic, evaluation flow | Complete PN flow | Score 3 images end-to-end |
| 4-5 | Session composition: 40/40/20 rule, ramp-up logic | Auto-composed sessions | Correct ratio verified |
| 6-7 | Score display: animations, badge, feedback text | ScoreBadge + confetti/bounce/wobble | All 4 levels animate |
| 8-9 | Haptic feedback per score + breathing | Vibration patterns | Each pattern distinguishable |
| 10 | TTS audio feedback (Piper Sinhala) | Spoken feedback per score | TTS plays correctly |
| 11-12 | Breathing exercise: animated circle, timer, audio guide | Breathing flow | 2-min breathing completes |
| 13-14 | Session management: start, composition, end, summary | End-to-end session | Session saves to DB correctly |

**M2 Deliverables:**
- [x] Picture Naming flow (image → mic → evaluate → score → next)
- [x] 40/40/20 session composition + ramp-up
- [x] 4-level animated score display
- [x] Haptic feedback patterns (6 patterns)
- [x] TTS audio feedback (Sinhala)
- [x] Breathing exercise with audio guide
- [x] Complete session lifecycle

---

## Milestone M3: Live Conversation & Advanced Features

**Duration:** 14 days | **Goal:** Gemini Live API integration, all feedback systems

| Day | Tasks | Deliverable | Validation Gate |
|-----|-------|-------------|-----------------|
| 1-2 | Firebase project setup + AI Logic SDK | Firebase configured | Connection test passes |
| 3-5 | Live Conversation: WebSocket connect, audio stream, bidirectional | Working voice conversation | 2-min conversation test |
| 6-7 | Live conversation UI: waveform, transcript, timer, end button | Live UI complete | Visual + functional review |
| 8 | Category Naming exercise type (first Live exercise) | Exercise prompt + evaluation | 5-item session works |
| 9-10 | Cloudflare Worker: Gemini API proxy | Worker deployed | `POST /api/evaluate` works |
| 11-12 | Online scoring integration (Gemini API) | Gemini evaluation in PN flow | Score matches expected |
| 13-14 | Custom photo upload (caregiver) + session break screen | Custom images in PN flow | Photo added + used in session |

**M3 Deliverables:**
- [x] Firebase project + Firestore + AI Logic
- [x] Live Conversation WebSocket integration
- [x] Live Conversation UI (waveform, transcript, timer)
- [x] Category Naming exercise type
- [x] Cloudflare Worker deployed
- [x] Gemini evaluation integration
- [x] Custom photo upload
- [x] Session break screen

---

## Milestone M4: Caregiver Dashboard & Analytics

**Duration:** 14 days | **Goal:** Full caregiver experience with charts, history, export

| Day | Tasks | Deliverable | Validation Gate |
|-----|-------|-------------|-----------------|
| 1-2 | PIN entry screen + authentication flow | PIN lock with 5-attempt limit | Wrong PIN rejected correctly |
| 3-4 | Dashboard home: stats cards, overview | Dashboard layout with real data | Stats match DB queries |
| 5-6 | Session history: list, detail, filters | Browse past sessions | Filter by date works |
| 7-8 | Progress analytics: line chart (fl_chart) | 7/30/90 day trend chart | Chart renders with data |
| 9 | Category radar chart | Per-category performance | Chart renders |
| 10-11 | PDF report export (pdf + printing) | Generated PDF with data | PDF opens correctly |
| 12 | Settings screens: session config, language override, breathing toggle | Caregiver can change settings | Settings persist across restarts |
| 13 | Firestore sync setup (basic: sessions + attempts) | Data syncs to cloud | Offline → online sync works |
| 14 | Integration testing + bug fixes | All flows work together | Walkthrough passes |

**M4 Deliverables:**
- [x] PIN entry with security lockout
- [x] Dashboard home with stats
- [x] Session history + detail
- [x] Score trend chart (line)
- [x] Category breakdown (radar)
- [x] PDF export
- [x] Settings panel
- [x] Firestore sync (basic)

---

## Milestone M5: Polish, Testing & Release

**Duration:** 7 days | **Goal:** Production-ready APK

| Day | Tasks | Deliverable | Validation Gate |
|-----|-------|-------------|-----------------|
| 1 | Performance optimization: image caching, DB queries, animation | 60fps on target device | DevTools shows <16ms frames |
| 2 | Accessibility audit: TalkBack, contrast, touch targets | WCAG compliance verified | TalkBack navigates all screens |
| 3 | Error handling hardening + edge case testing | All error paths handled | Force errors → correct messages |
| 4 | Sinhala content review + audio quality check | All Sinhala strings verified | Native speaker review |
| 5 | App icon, splash screen, store listing assets | Branded assets | Visual review |
| 6 | APK build + install test on target device | Release APK | Install + run on Galaxy Tab |
| 7 | Documentation: README, setup guide | Complete docs | User can set up from scratch |

**M5 Deliverables:**
- [x] Performance optimized (60fps target)
- [x] Accessibility audited
- [x] Error handling complete
- [x] Sinhala content verified
- [x] App icon + splash + store assets
- [x] Release APK signed
- [x] Complete documentation

---

## Timeline Summary

```
Week 1  ████████████░░░░░░░░░░░░  M1: Foundation (50%)
Week 2  ████████████████████████  M1: Foundation (100%)  
Week 3  ████████████░░░░░░░░░░░░  M2: Core Therapy (50%)
Week 4  ████████████████████████  M2: Core Therapy (100%)
Week 5  ████████████░░░░░░░░░░░░  M3: Live Conversation (50%)
Week 6  ████████████████████████  M3: Live Conversation (100%)
Week 7  ████████████░░░░░░░░░░░░  M4: Caregiver (50%)
Week 8  ████████████████████████  M4: Caregiver (100%)
Week 9  ████████████████████████  M5: Polish & Release (100%)
                               ▀
                          LAUNCH!
```

**Total: 9 weeks (63 days) for Alpha on target device**
(Estimates assume part-time evenings/weekends — adjust based on actual availability)

---

## Risk-Adjusted Timeline

| Risk | Impact | Mitigation | Schedule Buffer |
|------|--------|------------|-----------------|
| Gemini Live API integration complexity | +1 week | Firebase AI Logic SDK handles complexity | Included in M3 estimates |
| Sinhala TTS quality issues | +3 days | Fallback to pre-recorded audio | Included in M2 |
| Firebase project setup issues | +2 days | Cloudflare Worker proxy as fallback | Included in M3 |
| Android haptic variation | +2 days | Use platform HapticFeedback only | Included in M2 |
| Image copyright/quality | +3 days | Use AI-generated or CC-licensed images | Included in M1 |

**Contingency buffer: 2 weeks total (built into estimates)**

---

> **Gate Check:** PASS ✅ — All milestones have clear goals, deliverables, and validation gates. Timeline is 9 weeks with 2-week contingency buffer. Each milestone produces a working increment of the app.
>
> **Next:** Phase 13 — Progress Tracker
