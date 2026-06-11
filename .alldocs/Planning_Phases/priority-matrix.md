# Phase 11 — Priority Matrix: Handa (හඬ)

> **Project:** Handa (හඬ) — Stroke Speech Therapy Android App
> **Date:** 2026-06-09
> **Status:** COMPLETE

---

## MoSCoW Classification

### M — Must Have (P0) — 17 items (37%)

| # | Feature | Dependency | Effort | Value | Rationale |
|---|---------|------------|--------|-------|-----------|
| M1 | Flutter project scaffold + clean architecture | None | 1 day | Foundation | Everything depends on this |
| M2 | Design system (colors, typography, components) | M1 | 2 days | Visual identity | All screens need consistent styling |
| M3 | Drift database schema + migrations | M1 | 2 days | Data layer | All features persist data |
| M4 | Image library (100+ WebP, 5+ categories) | M1 | 2 days | Core content | Picture Naming requires images |
| M5 | Audio capture (twin_stream + permissions) | M1 | 2 days | Input | Core input mechanism |
| M6 | Scoring engine (Levenshtein + classifier) | M1 | 1 day | Evaluation | Must score attempts |
| M7 | Picture Naming exercise (single item flow) | M3, M4, M5, M6 | 3 days | Core feature | Primary therapy mode |
| M8 | Session management (start/composition/end) | M3, M7 | 2 days | Workflow | Organizes exercises |
| M9 | Session composition logic (40/40/20 + ramp-up) | M3, M8 | 1 day | Intelligence | Adaptive therapy |
| M10 | 4-level score display (Excellent/Good/Almost/Try Again) | M6, M7 | 1 day | Feedback | Therapeutic grading |
| M11 | Haptic feedback per score level | M1, M10 | 1 day | Feedback | Tactile confirmation |
| M12 | Breathing exercise (animated circle + timer) | M1, M11 | 2 days | Foundation | Mandatory first month |
| M13 | Sinhala UI text + feedback phrases | M1 | 2 days | Localization | Primary language |
| M14 | Home screen + session flow navigation | M7, M8, M9 | 2 days | UX | Patient journey |
| M15 | Basic error handling (no crashes, retry) | M1 | 1 day | Reliability | Must not crash |
| M16 | Offline scoring (Levenshtein fallback) | M6 | 1 day | Resilience | Works without internet |
| M17 | Local-only session storage (no cloud) | M3, M8 | 1 day | Persistence | Data never lost |

**Must Have total: 17 items | 28 days**

---

### S — Should Have (P1) — 8 items (17%)

| # | Feature | Dependency | Effort | Value | Rationale |
|---|---------|------------|--------|-------|-----------|
| S1 | Caregiver PIN entry + basic read-only dashboard | M3, M7, M8 | 2 days | Monitoring | Caregiver needs visibility |
| S2 | TTS audio feedback per score level | M1 | 2 days | Feedback | Audio confirmation |
| S3 | Live Conversation (Category Naming only) | M5, M1 | 4 days | Advanced | Gemini Live voice practice |
| S4 | Session summary screen with stars | M7, M8 | 1 day | Motivation | End-of-session reward |
| S5 | Custom photo upload (gallery/camera) | M4 | 2 days | Personalization | Family photos in therapy |
| S6 | Session break screen (15s rest) | M7 | 1 day | UX | Prevents fatigue |
| S7 | Progress dots during Picture Naming | M7 | 1 day | UX | Shows position in session |
| S8 | App icon, splash screen, branding | M1 | 1 day | Identity | Professional finish |

**Should Have total: 8 items | 14 days**

---

### C — Could Have (P2) — 12 items (26%)

| # | Feature | Dependency | Effort | Value | Rationale |
|---|---------|------------|--------|-------|-----------|
| C1 | Full caregiver dashboard (analytics, charts) | M3, M8, M6 | 3 days | Analytics | Detailed progress visibility |
| C2 | Progress trend line chart (fl_chart) | M3, M8, C1 | 2 days | Visualization | See improvement over time |
| C3 | Category performance radar chart | M3, C1 | 1 day | Visualization | Category strengths/weaknesses |
| C4 | Firebase Firestore cloud sync | M3, M8 | 3 days | Backup | Cloud backup of session data |
| C5 | PDF report export | M3, C2, C3 | 2 days | Sharing | Doctor-ready reports |
| C6 | Session history list + detail view | M3, M8 | 2 days | Review | Browse past sessions |
| C7 | Audio recording playback in history | M5, C6 | 1 day | Review | Listen to past attempts |
| C8 | Tamil language UI + content | M13 | 3 days | Expansion | Second language tier |
| C9 | All 8 Live Conversation exercise types | S3 | 3 days | Completeness | Full exercise suite |
| C10 | Reduced motion / animation intensity settings | M1 | 1 day | Accessibility | For sensitive users |
| C11 | Dark mode (caregiver dashboard only) | M1 | 1 day | Comfort | Evening use |
| C12 | Patient settings screen (font size, breathing toggle) | M1 | 1 day | Config | Basic preferences |

**Could Have total: 12 items | 23 days**

---

### W — Won't Have (W3) — 9 items (20%)

| # | Feature | Rationale |
|---|---------|-----------|
| W1 | iOS version | Android-only for MVP (target device is Android tablet) |
| W2 | Web version | Not needed — dedicated app is better for audio |
| W3 | Vosk custom Sinhala model | Requires 2-4 weeks of training; online STT sufficient for now |
| W4 | Multiple patient profiles | Single-user app (user's father) |
| W5 | Bluetooth headset optimization | Standard Android audio routing works |
| W6 | Speech therapy game modes | Keep focus on therapeutic exercises, not gamification |
| W7 | English language unlock | Lower priority; Sinhala + Tamil first |
| W8 | Remote caregiver web dashboard | Local dashboard sufficient for MVP |
| W9 | Sentry/Firebase crash reporting | Local logging sufficient; opt-in later if needed |

**Won't Have total: 9 items**

---

## Distribution Check

```
Must Have:   17 items (37%)  ✅ ≤40%
Should Have:  8 items (17%)
Could Have:  12 items (26%)
Won't Have:   9 items (20%)
─────────────────────────────────
Total:       46 items (100%)
```

**Gate:** PASS ✅ — Must Haves are 37% of total scope, under the 40% threshold.

---

## Effort Summary

| Priority | Items | Estimated Days | Cumulative Days | Release |
|----------|-------|---------------|-----------------|---------|
| Must Have (P0) | 17 | 28 | 28 | Phase 1 — MVP |
| Should Have (P1) | 8 | 14 | 42 | Phase 2 |
| Could Have (P2) | 12 | 23 | 65 | Phase 3 |
| **Total** | **37 (active)** | **65** | — | — |

---

> **Gate Check:** PASS ✅ — Must Haves (37%) are under 40% threshold. Full MoSCoW classification documented with effort estimates.
>
> **Next:** Phase 12 — Implementation Roadmap
