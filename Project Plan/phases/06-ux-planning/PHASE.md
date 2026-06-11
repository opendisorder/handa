# Phase 7/15 — UX Planning

**Status:** COMPLETE ✅

## User Goals → User Tasks

| User Goal | User Task | UI Component |
|-----------|-----------|-------------|
| Start therapy session | Tap "Start Session" or say "Hello" | ChatWidget (auto-launches) |
| Practice word pronunciation | See picture, try to name it | ExerciseWidget (Picture Naming) |
| Get help when stuck | AI detects struggle → cues | ExerciseWidget (Cueing Ladder) |
| Calm down when frustrated | AI triggers breathing exercise | BreathingWidget |
| Track progress | View end-of-session report | ReportWidget |
| Have natural conversation | Talk to AI about daily life | ChatWidget |
| Avoid shame topics | AI routes away from money/visitors | ChatWidget (entity-aware routing) |

## User Flow — 6-Phase Session

```
Phase 0: Check-in   → AI greets, senses mood, adjusts tone
Phase 1: Warm-up    → Breathing exercise, 2 easy wins
Phase 2: Core Work  → Picture naming with cueing ladder
Phase 3: Break      → Conversation, cricket topic (joy anchor)
Phase 4: Core Work  → More naming, harder words if >80% accuracy
Phase 5: Cool-down  → Breathing, 3 wins review, containment
```

## Information Architecture — Widgets (No Navigation)

The app has NO navigation bars. Content changes via AI function calls:

```
WidgetContainer (manages visible widget)
├── ChatWidget        ← Default. Real-time conversation + AI speech
├── BreathingWidget   ← 4-7-8 box breathing with haptic + visual
├── ExerciseWidget    ← Picture naming with cueing ladder overlay
├── TextDisplayWidget ← Show word/phrase for patient to read
└── ReportWidget      ← End-of-session summary with wins
```

Each widget appears/disappears via `show_*` function calls from Gemini.

## Digital Brain UX Implications

- **Before session:** System prompt gets DIGITAL BRAIN SUMMARY injection (invisible to patient)
- **During session:** AI uses amygdala data to avoid triggers, Broca data to adjust cue difficulty
- **After session:** Background agent updates brain files (invisible to patient)
- **Next session:** AI references previous session wins automatically ("Last time you mastered 'cat'!")

## Interaction Patterns

| Pattern | Implementation |
|---------|---------------|
| Voice-first | Patient speaks, AI responds (Gemini Live bidirectional audio) |
| Visual support | Picture appears on screen for naming exercises |
| Struggle detection | MediaPipe Face Mesh reads facial tension (Levels 0-4) |
| Cue escalation | No cue → Semantic → Phonemic → Syllable → Direct (based on struggle level) |
| Breathing override | AI can trigger breathing widget mid-session when frustration detected |
| Win celebration | Confetti/checkmark animation when word mastered |
| Topic routing | AI avoids high-shame entities (money), leans into joy (cricket) |

## Feedback Loops

| Loop | Mechanism | Signal |
|------|-----------|--------|
| Word correct | Checkmark + "Great!" + AI positive tone | Immediate positive reinforcement |
| Word incorrect | Cue escalation (no shame, next level cue) | Immediate corrective feedback |
| Struggle detected | Breathing widget or easier word | Immediate de-escalation |
| Session complete | Report widget with win count | End-of-session summary |
| Weekly improvement | Caregiver report with trends | Cross-session progress |

**Gate:** Every UI component has a corresponding user task ✅
