# Phase 5/15 — Requirements Documentation

**Goal:** Separate what from how — functional + non-functional requirements.

**Status:** IN PROGRESS 🔄

---

## Functional Requirements (Digital Brain Modules)

### FR-BRAIN-01: Brain Region Storage
**Description:** The system shall store 10 brain region profiles that capture patient state across biological dimensions.
**Acceptance Criteria:**
- Each of 10 regions (prefrontal_cortex, hippocampus, amygdala, broca_area, wernicke_area, motor_cortex, temporal_lobe, cerebellum, brainstem, corpus_callosum) has a dedicated data document
- Each document supports timestamped insight appending (not overwriting)
- Each document is queryable by region name and date range

### FR-BRAIN-02: Brain Region Update
**Description:** The background agent shall update brain region documents after each session.
**Acceptance Criteria:**
- New insights are appended with `[YYYY-MM-DD]` timestamp
- Fields are structured per region (e.g., Broca: mastered_words[], approximate_words[], difficult_phonemes[])
- Word mastery transitions through states: learning → approximate → mastered
- Speed vs accuracy relationship is tracked per session

### FR-REL-01: Relationship Graph
**Description:** The system shall maintain a weighted relationship graph of all people in the patient's life.
**Acceptance Criteria:**
- Graph contains nodes with id, importance (0-1), valence (positive/negative/mixed)
- Edges have relation type and weight (0-1)
- Clusters group related nodes (Pain, Joy, Therapeutic)
- Graph supports query: "what triggers shame?", "what brings joy?"

### FR-REL-02: Per-Person Relationship Profile
**Description:** Each person in the relationship tree shall have a SAYS/FEELS/DOES profile.
**Acceptance Criteria:**
- What He SAYS: direct quotes categorized as Positive/Negative/Hidden
- What He FEELS: inferred emotional state with evidence
- What He DOES: behavioral patterns with defensive mechanisms
- Strategic Insight for AI: actionable guidance for the AI persona

### FR-REL-03: Weight Adjustment
**Description:** Relationship weights shall adjust dynamically per session.
**Acceptance Criteria:**
- Weights adjust ±0.05 per session based on sentiment analysis
- Re-clustering occurs after every 5 sessions
- Weight changes are logged with reason

### FR-ENT-01: Entity Knowledge Graph
**Description:** The system shall track topics/concepts with their emotional valence.
**Acceptance Criteria:**
- Entities include: cricket, money, vegetables, hospital, stroke, wedding
- Each entity has valence (joy, shame, trigger, neutral)
- AI uses entity valence for topic routing (avoid shame topics, lean into joy)
- New entities can be added dynamically when detected in session

### FR-PAT-01: Pattern Repository
**Description:** The system shall maintain cross-session pattern analysis across 4 dimensions.
**Acceptance Criteria:**
- Speech patterns: phoneme difficulty trends, speed trends, accuracy trends
- Emotional patterns: trigger frequency, joy anchor effectiveness, de-escalation success
- Cognitive patterns: comprehension changes, recall accuracy, attention span
- Behavioral patterns: session engagement, defense mechanism frequency, cooperation trends

### FR-TH-01: Therapeutic State
**Description:** The system shall maintain current therapeutic state including goals and word mastery.
**Acceptance Criteria:**
- Current goals are stored with status and progress
- Difficulty levels are tracked per word/exercise type
- Word mastery tracks per-word progression (mastered/learning/struggling)
- Therapeutic state is used by AI to adapt session difficulty

### FR-INJ-01: Memory Injection
**Description:** The system shall generate a compressed DIGITAL BRAIN SUMMARY before each session.
**Acceptance Criteria:**
- Summary is 200-300 words
- Covers: Identity (prefrontal), Emotional State (amygdala), Speech Status (broca), Key Relationships, Today's Strategy
- Summary is prepended to the AI system prompt
- Summary updates automatically after every background agent run

### FR-BG-01: Background Agent 7-Step Protocol
**Description:** The background agent shall execute a deterministic 7-step update after each session.
**Acceptance Criteria:**
1. Read entire brain (all region docs + graph + state)
2. Analyze session (transcript + function calls + frame data)
3. Append new insights with timestamps
4. Adjust relationship weights (±0.05)
5. Update word mastery (mastered/learning/struggling)
6. Flag new triggers or pattern changes
7. Generate memory injection (200-300 words)

---

## Non-Functional Requirements

### NFR-PERF-01: Latency
- AI response latency < 1 second for real-time conversation
- Background agent completes 7-step protocol within 5 minutes of session end

### NFR-PERF-02: Token Efficiency
- Memory injection must not exceed 300 words (to minimize system prompt token cost)
- Brain region files append-only to prevent re-processing

### NFR-DATA-01: Persistence
- Brain region data survives app restarts
- Relationship graph persists across sessions
- Session logs are retained for minimum 90 days

### NFR-SEC-01: Privacy
- Brain region data (deeply personal family dynamics) is encrypted at rest
- No raw brain data transmitted to third parties

### NFR-SCAL-01: Extensibility
- New brain regions can be added without code changes (data-driven schema)
- New entity types can be added dynamically
- Pattern repository supports additional dimensions without schema migration

---

## Gate Check: ✅ PASS
- All functional requirements have acceptance criteria
- All NFRs are measurable
- New modules from research phase are fully specified
