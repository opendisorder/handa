# Phase 10 — Dependency Map Update: Reference Implementation Findings

> **Project:** Handa (හඬ) — Stroke Speech Therapy Android App
> **Date:** 2026-06-10
> **Status:** COMPLETE
> **Base document:** `docs/dependency-map.md`

---

## New Dependencies from Reference

### New Modules Added

```
AudioUtils (static utility)
  No dependencies. Pure functions.
  Required by: LiveSessionController, AudioOutputController

AudioOutputController
  Depends on: AudioUtils
  Required by: LiveSessionController

LiveSessionController
  Depends on: LiveApiService, AudioUtils, AudioOutputController, Riverpod
  Required by: ConversationWidget, BreathingWidget, ExerciseWidget, ReportWidget

Widget Screen Router (Riverpod provider)
  Depends on: LiveSessionController
  Required by: App shell (switch widget based on state)
```

### Updated Dependency Tree

```
▲ Existing Dependencies (from base document)
│
├── Foundation Layer ─────────────────────────────────────
│   ├── app_colors.dart              [no deps]
│   ├── app_dimensions.dart          [no deps]
│   ├── app_durations.dart           [no deps]
│   ├── app_typography.dart          → app_colors
│   ├── app_theme.dart               → colors, dimensions, durations, typography
│   ├── failures.dart                [no deps]
│   ├── error_handler.dart           → failures
│   ├── sinhala_normalizer.dart      [no deps]
│   ├── audio_utils.dart             [NEW — no deps] PCM encode/decode
│   └── audio_focus_controller.dart  → audio_utils
│
├── Core Layer ───────────────────────────────────────────
│   ├── app_database.dart            → all table definitions
│   ├── thilina_prompt.dart          [NEW — no deps] system prompt + tools
│   ├── vertex_ai_auth.dart          [no deps] ADC token
│   └── AudioOutputController [NEW]  → audio_utils
│
├── Live API Layer ───────────────────────────────────────
│   ├── gemini_live_fork             [vendored package]
│   ├── live_api_service.dart        → gemini_live_fork, AdcTokenProvider
│   └── LiveSessionController [NEW]  → live_api_service, AudioOutputController,
│                                      AudioUtils, Riverpod, thilina_prompt
│
├── Widget Layer ─────────────────────────────────────────
│   ├── ConversationWidget [REFERENCE] → LiveSessionController
│   ├── BreathingWidget   [REFERENCE] → LiveSessionController
│   ├── ExerciseWidget    [REFERENCE] → LiveSessionController
│   └── ReportWidget      [REFERENCE] → LiveSessionController
│
└── Proxy Layer (Optional) ───────────────────────────────
    └── Node.js Backend (server.js)  → ADC, Express, ws
                                      (only if deploying web version)
```

### New Dependency Rules

- **AudioUtils must be implemented first** in the Live API stack (no deps, used everywhere)
- **LiveSessionController is the single point of contact** for all widget interactions — no widget talks to LiveApiService directly
- **AudioOutputController is a leaf dependency** of LiveSessionController — can be tested in isolation
- **Thilina prompt & tools** can be defined as a static module — no runtime dependencies
- **Widgets are stateless** with respect to Live API — all state comes from the Riverpod provider

### No Circular Dependencies

```
AudioUtils → (nothing) → AudioUtils                ✅ No cycle
AudioOutputController → AudioUtils → (nothing)      ✅ No cycle
LiveSessionController → AudioOutputController        ✅ No cycle
LiveSessionController → LiveApiService               ✅ No cycle
Widgets → LiveSessionController (via Riverpod)       ✅ No cycle
```

### Implementation Order Within Live Layer

| Order | Component | Depends On | Est. Lines |
|-------|-----------|-----------|------------|
| 1 | `AudioUtils` | — | 50 |
| 2 | `AudioOutputController` | AudioUtils | 80 |
| 3 | `thilina_prompt.dart` (exists) | — | 120 |
| 4 | `LiveSessionController` | AudioUtils, AudioOutputController, LiveApiService | 300 |
| 5 | `Widget Screen Router (Riverpod)` | LiveSessionController | 60 |
| 6 | `ConversationWidget` (translate) | LiveSessionController | 80 |
| 7 | `BreathingWidget` (translate) | LiveSessionController | 80 |
| 8 | `ExerciseWidget` (translate) | LiveSessionController | 80 |
| 9 | `ReportWidget` (translate) | LiveSessionController | 80 |
