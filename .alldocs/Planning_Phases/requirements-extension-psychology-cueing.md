# Requirements Extension: Psychological Framework, Cueing Ladder & Session Structure

> **Extends:** `docs/requirements-document.md`
> **Based on:** `docs/reference-memory-psychology-architecture.md`, `docs/reference-speech-therapy-framework.md`
> **Date:** 2026-06-10 | **Status:** ✅ EXTENDS Phase 5

---

## Overview

The original requirements defined core functional features (picture naming, live conversation, breathing) but did NOT include:
- The **psychological framework** — why the patient can't receive encouragement from family, how AI must position itself
- The **cueing ladder** — the progressive 5-level scaffolding algorithm that IS the therapy
- The **background agent** — post-session processing for memory extraction
- The **6-phase session structure** — the actual therapeutic flow
- The **red flag system** — when AI should escalate to caregiver

This extension adds these critical requirements.

---

## FR19: Background Agent Post-Session Processing

**Description:** After every session, a background AI agent (Gemini Flash) processes the full session recording to extract structured data — speech metrics, emotional state, struggle patterns, and therapeutic insights.

**User Story:**
> As a caregiver, I want the app to automatically analyze each session so that I can track both speech progress and psychological trends without listening to every recording.

**Acceptance Criteria:**
- [ ] Upon session end, app uploads full audio recording + 10-20 sampled video frames to Cloud Storage
- [ ] App sends session data to Gemini Flash with structured analysis prompt
- [ ] Agent returns valid JSON with: speech_metrics, psychological_markers, therapeutic_insights
- [ ] Results saved to Firestore under `/patients/{id}/sessions/{sessionId}`
- [ ] Agent generates `memory_for_next_session` (3-sentence summary)
- [ ] Processing completes within 60 seconds of session end
- [ ] If agent fails → retry 2x, then notify caregiver to process manually later

**Backend:**
- Called via Gemini REST API (not Live), not WebSocket
- Use Gemini 1.5 Flash (cheaper, sufficient for analysis)
- API key proxied through Cloudflare Worker

**Exception Handling:**
- If audio upload fails → queue for retry on next wifi connection
- If agent returns malformed JSON → retry with stricter prompt
- If agent times out (>60s) → mark for manual caregiver review

---

## FR20: Memory Preload System

**Description:** Before each session, the app loads the previous session's memory from Firestore and injects it into the Gemini Live system prompt, so the AI "remembers" the patient from prior sessions.

**User Story:**
> As a patient, I want the AI to remember what we did yesterday, so that our sessions feel continuous and personal.

**Acceptance Criteria:**
- [ ] Before connecting to Gemini Live, app reads `memory_for_next_session` from most recent session
- [ ] App prebuilds system prompt with: patient name, yesterday's wins, struggles, emotional state, today's strategy
- [ ] Session starts with AI demonstrating memory (e.g., "Last time you named elephant. Let's try harder words today.")
- [ ] Memory format stored as structured `SessionMemory` object (see architecture extension)
- [ ] If no prior session exists → use default introduction prompt
- [ ] If memory retrieval fails → start session with default prompt, log error

---

## FR21: Cueing Ladder (5-Level Progressive Scaffolding)

**Description:** The AI must follow a strict progressive cueing protocol during speech exercises. The patient's struggle itself IS the therapy — neural pathways strengthen during effortful retrieval. Never skip to the answer.

**User Story:**
> As a patient, I want the AI to give me time and progressively helpful cues, so that I can find the word myself rather than being told the answer.

**Acceptance Criteria:**

| Level | Condition | AI Behavior | Wait Time |
|-------|-----------|-------------|-----------|
| **0** | No struggle | Normal interaction, full praise | — |
| **1** | Early (3-5s silence, slight tension) | Stay silent. No interruption. Just wait. | 3-5s |
| **2** | Moderate (5-8s, false starts) | Phonemic cue: "It starts with 't'... t-t-t" | 5-8s |
| **3** | Significant (8-12s, frustration) | Semantic cue: "You eat it. It's orange..." | 8-12s |
| **4** | Severe (12s+, giving up) | Full word + immediate reset + breathing | 12s+ |
| **5** | Emotional distress (sighing, "I can't") | Switch to emotional support mode → consider ending session | Immediate |

- [ ] Cueing levels are triggered by **client-side silence detection**, not AI self-awareness
- [ ] App sends function call to AI: `struggle_level: 3, cue_needed: "phonemic"`
- [ ] AI must follow the ladder — never skip from Level 1 to Level 4
- [ ] After Level 4, AI MUST trigger a breathing cycle before next exercise
- [ ] After Level 5, AI switches to emotional support mode: "This is hard work. You are doing hard work. Let's take a break."
- [ ] Cueing ladder is used for ALL exercise types (naming, repetition, fluency, etc.)

**Exception Handling:**
- If patient self-corrects → Level 0, full praise for self-correction
- If patient says "I don't know" immediately → treat as Level 1 (wait, don't give answer)
- If patient asks for hint → give one semantic cue (Level 3), no more

---

## FR22: Exercise Type Taxonomy (5 Exercise Categories)

**Description:** The app must support 5 distinct exercise types covering anomia therapy, apraxia therapy, fluency, comprehension, and functional communication.

**User Story:**
> As a patient, I want varied exercises that challenge different aspects of my speech, so that I improve comprehensively.

**Exercise Types:**

### Type A: Naming & Word Retrieval
- Object Naming: Show image → "What is this?"
- Category Naming: "Name 3 vegetables"
- Semantic Feature Analysis: "What color? What do you do with it?"
- Responsive Naming: "What do you use to cut paper?"
- Famous Faces: Show family photo → "Who is this?"

### Type B: Repetition & Motor Speech
- Syllable Drilling: "Say ba-ba-ba... pa-pa-pa"
- Word Repetition: AI says slowly, patient repeats
- Progressive Phrases: "Good morning" → "Good morning, doctor" → ...
- Melodic Intonation: Singing phrases to engage right hemisphere

### Type C: Fluency & Pacing
- Turtle Mode: Extremely slow speaking, patient mirrors
- Metronome Speech: One syllable per beat (visual pacer on screen)
- Pause Training: AI inserts deliberate pauses in sentences
- Breath-Sync Speech: Inhale → speak → exhale

### Type D: Comprehension & Cognitive Load
- Yes/No Questions: "Is an elephant bigger than a mouse?"
- Command Following: "Touch your nose, then clap" (1→2→3 step)
- Story Recall: AI tells 3-sentence story, "What happened?"
- Same/Different: Phonemic discrimination

### Type E: Functional Communication
- Script Practice: Ordering food, asking for help, greeting
- Emergency Phrases: "I need help," "Call my son"
- Personal Narrative: "Tell me about your day"

**Exception Handling:**
- AI should adapt difficulty based on patient performance
- If patient struggles with Type A → drop to easier targets within same type
- If patient excels (>80% accuracy for 3 sessions) → auto-increase difficulty

---

## FR23: Psychological Red Flag Detection & Escalation

**Description:** The AI must detect psychological red flags during conversation and escalate to the caregiver when appropriate. The AI does NOT diagnose — it detects language patterns and alerts.

**Red Flag Categories (from reference-memory-psychology-architecture.md Part 4.3):**

| Type | Phrases to Detect | Action |
|------|------------------|--------|
| **Suicidal ideation** | "Don't want to live," "better off dead," "burden" | End session gently, push notification to caregiver, log incident |
| **Severe depression** | Crying throughout, "I can't" to everything | End session early, log mood trend, notify caregiver |
| **Family conflict escalation** | Agitated talking about family conflicts | Stay neutral, pivot to breathing, end session if escalating |
| **Physical symptoms** | Chest pain, severe headache, new stroke-like symptoms | STOP session, instruct to seek medical help, notify caregiver |
| **Medication non-compliance** | Refusing to take prescribed meds | Log, notify caregiver, do NOT give medical advice |

**Acceptance Criteria:**
- [ ] AI detects key phrases during conversation and logs via `escalate_to_caregiver()` function call
- [ ] If red flag detected → AI stays calm, does NOT acknowledge it directly (e.g., does NOT say "you sound suicidal")
- [ ] App sends push notification to caregiver with: session ID, red flag type, quote
- [ ] Incident logged in Firestore under `/patients/{id}/red_flags/`
- [ ] Red flag log visible in caregiver dashboard
- [ ] Caregiver can configure which red flags trigger notifications
- [ ] False positive rate expected <10% — caregiver reviews before action

---

## FR24: AI Persona System (Thilina — The Therapist)

**Description:** The AI must present as a specific therapeutic persona — "Thilina," a compassionate speech therapist from Sri Lanka — not as a generic AI assistant.

**User Story:**
> As a patient, I want to feel like I'm working with a real therapist who knows me, so that I trust the process and take it seriously.

**Acceptance Criteria:**

### Core Persona Rules
- [ ] Name: "Thilina" (Sinhala name, professional title: speech therapist)
- [ ] Speaks in patient's preferred language (Sinhala primary)
- [ ] Speaking pace: 20% slower than normal, deliberate pauses
- [ ] Silence tolerance: minimum 8 seconds before cueing
- [ ] Uses patient's name at least once every 3 sentences
- [ ] Celebrates effort, not just correctness: "I can see you working hard"
- [ ] Never says "wrong," "no," "incorrect," or "hurry"
- [ ] After every attempt, says something positive about effort
- [ ] Voice: slightly lower pitch (calming, authoritative but gentle), soft volume, warm emotion

### Psychological Techniques (Hardcoded)
- [ ] **Identity Reinforcement** (not praise): "You are a father who raised three educated children. Those qualities are still in you."
- [ ] **Validation Without Agreement**: "It is painful when people don't show up. That disappointment is real." THEN pivot: "But your children are here. That is also real."
- [ ] **The "We" Frame**: "WE are doing this together" (speech exercises), "YOU are doing the hard work" (identity)
- [ ] **Breathing as Reset** (not punishment): "That was hard work. Let's reset together." NOT "You got it wrong, breathe first."
- [ ] **Session Closure as Containment**: Name 3 wins, acknowledge 1 hard thing, then: "We will continue tomorrow. You don't have to carry this alone."

### What the AI NEVER Does
- [ ] Never says "hurry," "quickly," "fast," "come on"
- [ ] Never gives direct praise ("You're so smart" → sounds like pity)
- [ ] Never dismisses negative thoughts ("Don't think that way")
- [ ] Never takes sides in family conflict
- [ ] Never diagnoses depression or gives medical advice

---

## FR25: 6-Phase Session Structure

**Description:** Every session follows a 6-phase therapeutic structure, calibrated to 20-30 minutes total.

```
PHASE 1: WARM-UP (3 min)
├── Greeting by name
├── "How are you feeling today?"
├── 3 cycles box breathing
└── 2 easy wins (high-confidence exercises)

PHASE 2: NAMING BLOCK (8 min)
├── 5 object naming exercises
├── AI detects struggle → applies cueing ladder
├── Breathing cycle between each if needed
└── Category naming (2 items)

PHASE 3: REPETITION BLOCK (5 min)
├── Syllable drilling (ba/pa/ma)
├── Word repetition (3 words)
└── Progressive phrase (2→3→4 words)

PHASE 4: FLUENCY BLOCK (5 min)
├── Turtle mode sentence
├── Metronome speech
└── Pause training

PHASE 5: FUNCTIONAL / PERSONAL (5 min)
├── Script practice OR personal narrative
└── Self-modeling playback (if recordings exist)

PHASE 6: COOL-DOWN (3 min)
├── 3 cycles box breathing
├── AI summarizes 3 wins from session
├── "You did good work, [Name]. Same time tomorrow?"
└── Background agent trigger
```

**Acceptance Criteria:**
- [ ] Session structure is configurable per patient (phase durations adjustable in settings)
- [ ] AI knows which phase it's in and adapts behavior accordingly
- [ ] Phase transitions are smooth (no abrupt "NOW WE MOVE TO PHASE 2")
- [ ] Breathing integration points: PHASE 1 (opening), between exercises, after struggle, PHASE 6 (closing)
- [ ] If patient is having a good session → extend PHASE 2 (naming) since it's most therapeutic
- [ ] If patient is struggling → shorten PHASE 2, extend PHASE 1 (breathing + easy wins)
- [ ] Session auto-ends after 30 minutes; AI initiates cool-down regardless of position

---

## NFR11: Red Flag Notification Latency

- [ ] Red flag detection → caregiver notification must arrive within 30 seconds
- [ ] Achieved via Firebase Cloud Messaging push notification
- [ ] Notification includes: patient name, red flag type, quote, timestamp, session ID

---

## NFR12: Background Agent Processing SLA

- [ ] Post-session analysis must complete within 60 seconds
- [ ] If >60s → retry once, then defer to next app launch
- [ ] Results available in caregiver dashboard within 90 seconds of session end

---

## NFR13: AI Persona Consistency

- [ ] The AI must maintain a consistent persona (Thilina) across ALL sessions
- [ ] Personality drift detection: if AI deviates from persona rules, caregiver receives alert
- [ ] System prompt must be version-controlled (see `docs/ai-persona-prompt-v1.md`)

---

## Updated MVP Definition

Based on these new requirements, the MVP must be updated:

### Must Have (P0) — New Additions
- FR21: Cueing Ladder (this IS the therapy — it's P0)
- FR24: AI Persona System (the entire interaction model — P0)
- FR25: 6-Phase Session Structure (P0)

### Should Have (P1) — New Additions
- FR19: Background Agent Processing (important but can start without analytics)
- FR20: Memory Preload System (important but AI can work without memory initially)

### Could Have (P2) — New Additions
- FR22: Full Exercise Type Taxonomy (start with Type A naming, add others)
- FR23: Psychological Red Flag Detection (manual caregiver review first)

---

*Extension to Requirements Phase (Phase 5) — Psychological Framework & Clinical Protocol*  
*References: `docs/reference-memory-psychology-architecture.md` Parts 2-4, `docs/reference-speech-therapy-framework.md` Sections 4-7*
