# UX Extension: 6-Phase Session Structure & Multimodal Struggle Detection

> **Extends:** `docs/ux-plan.md`
> **Based on:** `docs/reference-speech-therapy-framework.md` Sections 4-7
> **Date:** 2026-06-10 | **Status:** ✅ EXTENDS Phase 7

---

## 1. Updated Session Flow

The original UX plan defined screens but not the detailed therapeutic flow within a session. This extension adds the 6-phase structure and struggle detection UX.

```
┌─────────────────────────────────────────────────────────────────┐
│                    SESSION START                                  │
│  ┌─────────────────────────────────────────────────────────┐     │
│  │  PRE-SESSION: MEMORY LOAD                                │     │
│  │  • Load memory_for_next_session from Firestore           │     │
│  │  • Build system prompt with yesterday's context          │     │
│  │  • Prepare exercise list (40% mastered / 40% practice /  │     │
│  │    20% new — from original plan)                        │     │
│  └─────────────────────────────────────────────────────────┘     │
│                              │                                    │
│                              ▼                                    │
│  ┌─────────────────────────────────────────────────────────┐     │
│  │  PHASE 1: WARM-UP (3 min)                                │     │
│  │                                                          │     │
│  │  [Breathing Circle Animation]                            │     │
│  │  AI: "[Name], good morning. Let's breathe together."     │     │
│  │                                                          │     │
│  │  Visual: Large expanding/contracting circle              │     │
│  │  Haptic: Gentle vibration rising/falling with breath     │     │
│  │  Audio: Soft breath guide (inhale 4s / hold 4s /        │     │
│  │          exhale 6s)                                      │     │
│  │                                                          │     │
│  │  → 3 cycles of box breathing                            │     │
│  │  → 2 easy wins (high-confidence exercises from history)  │     │
│  └─────────────────────────────────────────────────────────┘     │
│                              │                                    │
│                              ▼                                    │
│  ┌─────────────────────────────────────────────────────────┐     │
│  │  PHASE 2: NAMING BLOCK (8 min)                           │     │
│  │                                                          │     │
│  │  [Full-screen image + mic button]                        │     │
│  │  AI: "What is this?" + waits 8s before cueing           │     │
│  │                                                          │     │
│  │  Struggle Detection Active → Cueing Ladder               │     │
│  │  Level 0: ✅ Normal → "Good work, [Name]!"              │     │
│  │  Level 1: ⏳ Silent wait (no UI change)                  │     │
│  │  Level 2: 💡 Phonemic cue shown as text                  │     │
│  │  Level 3: 📝 Semantic cue shown as hint text             │     │
│  │  Level 4: 🫁 Full word + breathing trigger               │     │
│  │  Level 5: 🚨 Emotional support → consider ending early   │     │
│  │                                                          │     │
│  │  Between exercises: mini breathing cycle (1 round)       │     │
│  └─────────────────────────────────────────────────────────┘     │
│                              │                                    │
│                              ▼                                    │
│  ┌─────────────────────────────────────────────────────────┐     │
│  │  PHASE 3: REPETITION BLOCK (5 min)                       │     │
│  │                                                          │     │
│  │  [Audio waveform visualizer]                             │     │
│  │  AI demonstrates syllable → patient repeats              │     │
│  │  Visual: Mouth animation or syllable cards               │     │
│  └─────────────────────────────────────────────────────────┘     │
│                              │                                    │
│                              ▼                                    │
│  ┌─────────────────────────────────────────────────────────┐     │
│  │  PHASE 4: FLUENCY BLOCK (5 min)                          │     │
│  │                                                          │     │
│  │  [Metronome visual + pulsing circle for each syllable]   │     │
│  │  AI: "Let's be turtles. Slooooow."                      │     │
│  │  Haptic: Tap per syllable for metronome speech           │     │
│  └─────────────────────────────────────────────────────────┘     │
│                              │                                    │
│                              ▼                                    │
│  ┌─────────────────────────────────────────────────────────┐     │
│  │  PHASE 5: FUNCTIONAL / PERSONAL (5 min)                  │     │
│  │                                                          │     │
│  │  [Conversation mode — no exercises, just dialogue]       │     │
│  │  AI asks about patient's day, family, or role-play       │     │
│  │  Script: "Ordering tea" or "Tell me about your work"    │     │
│  └─────────────────────────────────────────────────────────┘     │
│                              │                                    │
│                              ▼                                    │
│  ┌─────────────────────────────────────────────────────────┐     │
│  │  PHASE 6: COOL-DOWN (3 min)                              │     │
│  │                                                          │     │
│  │  [Breathing Circle Animation]                            │     │
│  │  AI: "Let's breathe. Here are 3 things you did well:    │     │
│  │        1. Named elephant without help                    │     │
│  │        2. Completed breathing every time                 │     │
│  │        3. Tried even when it was hard"                   │     │
│  │                                                          │     │
│  │  → 3 cycles breathing + containment statement            │     │
│  │  → "Same time tomorrow, [Name]?"                         │     │
│  └─────────────────────────────────────────────────────────┘     │
│                              │                                    │
│                              ▼                                    │
│  ┌─────────────────────────────────────────────────────────┐     │
│  │  POST-SESSION (Invisible)                                │     │
│  │  • Upload recording to Cloud Storage                     │     │
│  │  • Trigger background agent processing                   │     │
│  │  • Save memory_for_next_session                          │     │
│  │  • Update caregiver dashboard                            │     │
│  └─────────────────────────────────────────────────────────┘     │
│                              │                                    │
│                              ▼                                    │
│                    SESSION END                                    │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. Struggle Detection UX

### On-Device Detection Indicators (Invisible to Patient)

These sensors run silently in the background:

```
┌─────────────────────────────────────────────┐
│  STRUGGLE DETECTION ENGINE                   │
│  (No UI — runs in background)                │
│                                              │
│  Audio Monitor:                              │
│  ┌────┐  ┌────┐  ┌────┐  ┌────┐  ┌────┐    │
│  │Mic │→ │3s  │→ │5s  │→ │8s  │→ │12s │    │
│  │    │  │sil │  │sil │  │sil │  │sil │    │
│  └────┘  └────┘  └────┘  └────┘  └────┘    │
│                          │                  │
│  Camera Monitor:         │                  │
│  ┌────────┐    ┌───────┐│                  │
│  │MediaPipe│───►│Tension││                  │
│  │Face Mesh│    │Score  ││                  │
│  └────────┘    └───────┘│                  │
│                          ▼                  │
│                    ┌──────────┐             │
│                    │ Struggle │             │
│                    │Level (0-5)│             │
│                    └────┬─────┘             │
│                         │                   │
│                         ▼                   │
│              ┌─────────────────────┐        │
│              │ Function Call to AI │        │
│              │ "struggle_level: 3, │        │
│              │  cue: phonemic"    │        │
│              └─────────────────────┘        │
└─────────────────────────────────────────────┘
```

### Visual Feedback for Cueing (Visible to Patient)

| Cue Level | Visual | Audio | Haptic |
|-----------|--------|-------|--------|
| **0: None** | Green glow on image | "Good work!" | Short pleasant buzz |
| **1: Early** | Nothing changes | Silence | None (don't alert patient) |
| **2: Phonemic** | First letter appears on screen | "It starts with 't...'" | Gentle single tap |
| **3: Semantic** | Hint text appears: "You eat it" | "You eat it. It's orange..." | Two taps |
| **4: Full word** | Word displayed + breathing circle | "It's a carrot. Let's breathe." | Rising vibration (breathing) |
| **5: Distress** | Calming gradient | "This is hard work. Let's rest." | Long steady vibration |

---

## 3. Breathing Integration Points

```
SESSION PHASE           BREATHING PROTOCOL
─────────────           ─────────────────
PHASE 1: Warm-Up        3 cycles box breathing (4-4-6)
Between exercises       1 cycle (if previous was effortful)
After Level 4 cue       1 cycle BEFORE retrying
PHASE 6: Cool-Down      3 cycles box breathing
```

**Breathing UI:**
- Large circle on screen that expands (inhale) / holds / contracts (exhale)
- Color shifts: blue (inhale) → green (hold) → warm orange (exhale)
- Phone vibrates with breath rhythm
- AI voice guides: "Breathe in... hold... slow out..."
- Duration: ~60 seconds for 3 cycles

---

## 4. Micro-Interactions

| Interaction | Feedback | Purpose |
|-------------|----------|---------|
| Correct answer | Green glow + checkmark bounce + confetti | Celebration, dopamine |
| Self-correction | "Good catch!" + subtle blue pulse | Encourages self-monitoring |
| Approximate answer | Yellow glow + "Almost!" + gentle haptic | Encourages persistence |
| Wrong answer | Warm orange pulse (NOT red) + "Let's try together" | Safety, no shame |
| Silence >3s | Nothing (no feedback) | Gives patient time |
| Breathing complete | Expanding circle burst + chime | Completeness reward |
| Session end | Star accumulation + "See you tomorrow" | Anticipation, continuity |

---

*Extension to UX Planning Phase (Phase 7) — Session Structure & Struggle Detection*
