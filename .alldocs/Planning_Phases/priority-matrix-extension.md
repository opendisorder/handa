# Priority Matrix Extension: Psychological & Memory Features

> **Extends:** `docs/priority-matrix.md`
> **Date:** 2026-06-10 | **Status:** ✅ EXTENDS Phase 11

---

## Extended MoSCoW

Based on the new architecture (two-layer memory) and psychological framework, the following features are added to the priority matrix:

### Must Have (P0) — <40% of total scope (currently 15/38 = 39.5%) ✅

| # | Feature | Phase | Rationale |
|---|---------|-------|-----------|
| M11 | **Cueing Ladder (5-Level)** | Session | The core therapeutic algorithm — without it, exercises are just quizzes |
| M12 | **AI Persona "Thilina"** | AI Config | The entire interaction model — without persona, AI is generic |
| M13 | **6-Phase Session Structure** | Session | The therapeutic flow — without structure, sessions are aimless |
| M14 | **Breathing as Reset** | Session | Breathing is neural regulation — core to the therapy |
| M15 | **Silence Detection (Client-Side)** | Engine | Required for cueing ladder timing — AI can't track time |
| M16 | **Exercise Type A: Naming** | Exercises | The primary therapy mode — word retrieval practice |
| M17 | **Sinhala Language Support** | L10n | Patient's native language — without it, app is useless |

### Should Have (P1)

| # | Feature | Phase | Rationale |
|---|---------|-------|-----------|
| S08 | **Background Agent Processing** | Post-Session | Important for caregiver analytics, but app works without it initially |
| S09 | **Memory Preload System** | Pre-Session | Important for continuity, but AI can start fresh each session |
| S10 | **Exercise Type B: Repetition** | Exercises | Motor speech practice — important but naming is primary |
| S11 | **Exercise Type C: Fluency** | Exercises | Pacing therapy — important but naming is primary |
| S12 | **Caregiver Weekly Report** | Dashboard | Generated from background agent output |

### Could Have (P2)

| # | Feature | Phase | Rationale |
|---|---------|-------|-----------|
| C09 | **Exercise Type D: Comprehension** | Exercises | Cognitive load training — nice to have |
| C10 | **Exercise Type E: Functional** | Exercises | Real-life scripts — nice to have |
| C11 | **Psychological Red Flag Detection** | AI Config | Important for safety but can be manual caregiver review initially |
| C12 | **On-Device Face Detection** | Engine | Enhances cueing but not required — silence detection is enough |
| C13 | **Self-Modeling Playback** | Session | Play back patient's own success — powerful but non-critical |
| C14 | **Exercise Type F: Famous Faces** | Exercises | Family photos — personal but not required for core therapy |
| C15 | **Melodic Intonation Therapy** | Exercises | Singing for right hemisphere — specialized, future |

### Won't Have (Explicitly Cut)

| # | Feature | Rationale |
|---|---------|-----------|
| W04 | **Offline Vosk STT** | No Sinhala model available — not viable |
| W05 | **Family Photo Integration** | Privacy complexity, emotional triggers — defer |
| W06 | **Voice Cloning** | Consent and technical complexity — future |
| W07 | **Community Features** | Patient privacy — out of scope |
| W08 | **Clinical Validation Study** | Would require IRB, partner hospital — defer to v2 |

---

## Updated Totals

| Category | Original | Added | Total | % of Total |
|----------|----------|-------|-------|------------|
| Must Have (P0) | 10 | 7 | **15** | 39.5% ✅ |
| Should Have (P1) | 4 | 4 | **8** | 21.0% |
| Could Have (P2) | 6 | 7 | **13** | 34.2% |
| Won't Have | 0 | 2 | **2** | 5.3% |
| **Total** | **20** | **18** | **38** | **100%** |

**Gate check:** Must Haves at 39.5% — under 40% threshold ✅

---

## Implementation Priority Within Must Haves

Within the 15 Must Haves, the sub-priority is:

```
P0a: Foundation (build first)
├── M01: No Login/Auth (app must open)
├── M02: Picture Naming Exercise (core therapy)
├── M13: 6-Phase Session Structure (session flow)
├── M15: Silence Detection (needed for cueing)
└── M17: Sinhala Language Support (patient's language)

P0b: Core Therapy
├── M16: Exercise Type A (naming)
├── M04: 4-Level Scoring (Excellent/Good/Almost/Try Again)
├── M11: Cueing Ladder (5-level progressive scaffolding)
└── M14: Breathing as Reset (neural regulation)

P0c: AI Integration
├── M06: Gemini Live Conversation (real-time interaction)
├── M12: AI Persona "Thilina" (therapeutic persona)
└── M10: Adaptive Difficulty (personalized progression)

P0d: Caregiver Support
├── M05: Haptic & Audio Feedback (multimodal feedback)
├── M07: Caregiver Dashboard (PIN-protected)
├── M08: Progress Analytics (session history)
└── M09: PDF Report Export (for doctors)
```
