# Phase 10 — Dependency Mapping: Handa (හඬ)

> **Project:** Handa (හඬ) — Stroke Speech Therapy Android App
> **Date:** 2026-06-09
> **Status:** COMPLETE

---

## Dependency Tree (Top-Down: Parent → Children)

```
Phase 1: Foundation                        Phase 2: Core Features
══════════════════════════════             ══════════════════════════════

1. Flutter Project Scaffold                6. Picture Naming Exercise
   ├── pubspec.yaml deps                        ├── (1) Flutter project
   ├── Clean Architecture folders               ├── (2) Drift DB
   └── Riverpod providers setup                 ├── (3) Image library
                                                ├── (4) Audio capture
2. Drift Database Schema                        ├── (5) Gemini API proxy
   ├── Database definition                      ├── (8) Scoring engine
   ├── All 6 table definitions                  └── (6) HapticFeedback
   ├── Migration strategy
   └── DAO implementations                7. Session Management
                                               ├── (1) Flutter project
3. Image Library                               ├── (2) Drift DB
   ├── 100+ WebP images (5+ categories)        ├── (8) Scoring engine
   ├── Asset manifest                          └── (9) Session composition logic
   └── Image model + provider
                                          8. Scoring Engine
4. Audio Capture System                           ├── Levenshtein distance
   ├── twin_stream integration                    ├── Sinhala normalizer
   ├── Mic permission handling                    ├── Score level classifier
   ├── PCM audio pipeline                         └── Gemini AI integration (online)
   └── Audio storage to disk
                                          9. Session Composition Logic
5. Design System                                    ├── 40/40/20 rule
   ├── Color tokens                                ├── Ramp-up phase logic
   ├── Typography (28sp+ bold)                     └── Adaptive difficulty
   ├── Component library (HandaButton, etc.)
   └── Animation system

Phase 3: Advanced Features                 Phase 4: Caregiver
══════════════════════════════             ══════════════════════════════

10. Live Conversation                      13. Caregiver Dashboard
    ├── (1) Flutter project                     ├── (1) Flutter project
    ├── (4) Audio capture (twin_stream)         ├── (2) Drift DB
    ├── Firebase AI Logic setup                 ├── (8) Scoring engine
    ├── WebSocket session management            ├── PIN entry screen
    ├── Gemini Live API integration             └── Dashboard layout
    └── 8 exercise types                   
                                          14. Progress Analytics
11. Breathing Exercise                          ├── (2) Drift DB
    ├── (1) Flutter project                     ├── (8) Scoring engine
    ├── (6) HapticFeedback                      ├── fl_chart integration
    ├── Animated breathing circle               ├── Line chart (score trends)
    └── Audio guide (TTS)                       ├── Radar chart (categories)
                                                └── Stats cards
12. Haptic + Audio Feedback System
    ├── (6) HapticFeedback                 15. PDF Report Export
    ├── TTS integration                         ├── (2) Drift DB
    └── Score-level feedback patterns           ├── pdf package
                                                ├── printing package
                                                └── Chart image embedding
                                          16. Firestore Sync
                                               ├── (2) Drift DB
                                               ├── Firebase project setup
                                               ├── Sync queue service
                                               └── Offline queue + retry

Phase 5: Polish & Enhancements
══════════════════════════════

17. Session History & Review          19. Multi-Language System
    ├── (2) Drift DB                      ├── ARB files (si/ta/en)
    ├── (7) Session management            ├── Language unlock logic
    └── Audio playback                    └── UI toggle

18. Custom Image Upload              20. App Polish & Store
    ├── (3) Image library                 ├── App icon & splash
    ├── Camera/gallery permission         ├── Error monitoring
    └── Image processing                  ├── Performance optimization
                                          └── APK signing & release
```

## Dependency Rules

| Rule | Description |
|------|-------------|
| **R1** | A phase cannot start until ALL its dependency phases are complete |
| **R2** | Shared dependencies (marked with ├──(N)) must be built only once |
| **R3** | Leaf nodes (no children) can be parallelized |
| **R4** | Foundation (Phase 1) is entirely sequential |
| **R5** | Caregiver Dashboard (13) depends on actual data from Core Features (Phase 2) |

## Dependency Graph (Visual DAG)

```
1. Flutter Scaffold ──► 2. Drift DB ──► 3. Images ──► 5. Design System
                         │               │
                         │               │
                         ▼               ▼
                     4. Audio Capture ◄──┘
                         │
                         ▼
              ┌──────────┼──────────┐
              │          │          │
              ▼          ▼          ▼
          6. Picture   8. Scoring  9. Session
             Naming     Engine     Composition
              │          │          │
              └─────┬────┘──────────┘
                    │
                    ▼
              7. Session Management
                    │
          ┌─────────┼─────────┐
          │         │         │
          ▼         ▼         ▼
       10. Live    11.       12. Haptic/
        Conv.    Breathing     Audio
          │         │         │
          └─────┬───┘         │
                │             │
                ▼             │
          ┌────────────┐      │
          │ 13-16.     │◄─────┘
          │ Caregiver  │
          └────────────┘
                │
                ▼
          ┌────────────┐
          │ 17-20.     │
          │ Polish &   │
          │ Release    │
          └────────────┘
```

---

> **Gate Check:** PASS ✅ — All dependencies mapped. No circular dependencies. Foundation phase is entirely sequential. Caregiver features depend on core data being available.
>
> **Next:** Phase 11 — Priority Matrix
