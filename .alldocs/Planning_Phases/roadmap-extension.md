# Roadmap Extension: Memory & Psychology Milestones

> **Extends:** `docs/implementation-roadmap.md`
> **Date:** 2026-06-10 | **Status:** ✅ EXTENDS Phase 12

---

## Extended Milestones

The original roadmap had 5 milestones (M1-M5). We add M4a and M4b to incorporate the memory system and psychological features. M5 and M6 are renamed.

```
ORIGINAL ROADMAP:                      EXTENDED ROADMAP:
                                      ┌────────────────────┐
M1: Foundation (Week 1)               │ M1: Foundation     │
M2: Core Therapy (Week 2)             │ M2: Core Therapy   │
M3: AI Integration (Week 3-4)         │ M3: AI Integration │
M4: Caregiver & Polish (Week 4-5)     │ M3a: AI Persona    │  ← NEW
M5: Testing & Deploy (Week 5-6)       ├────────────────────┤
                                      │ M4: Memory System  │  ← NEW
                                      │ M5: Psychology     │  ← NEW
                                      │ M6: Caregiver      │
                                      │ M7: Testing/Deploy │
                                      └────────────────────┘
```

---

## M3a: AI Persona & Therapeutic Protocol (Week 3-4)

**Duration:** 5 days
**Goal:** Define and implement the "Thilina" AI persona and the 6-phase session structure

**Deliverables:**
- [ ] AI system prompt with full persona definition (Thilina)
- [ ] Behavioral rules hardcoded (silence tolerance, cueing ladder, no-rush rules)
- [ ] Psychological techniques: identity reinforcement, validation without agreement, containment
- [ ] 6-phase session structure (warm-up → naming → repetition → fluency → functional → cool-down)
- [ ] Breathing integration at all session phases
- [ ] Session auto-ending at 30 minutes
- [ ] Voice prosody instructions (pitch, volume, pauses, emphasis)

**Dependencies:** M3 (Gemini Live integration working)

## M4: Memory & Background Agent System (Week 4-5)

**Duration:** 7 days
**Goal:** Implement the two-layer memory architecture — background agent for post-session analysis and memory preload for next session

**Deliverables:**
- [ ] Background agent (Gemini Flash) prompt and integration
- [ ] Session recording upload to Cloud Storage
- [ ] Background agent response parser (JSON extraction)
- [ ] Firestore schema for psychological markers
- [ ] Memory preload system (build and inject system prompt)
- [ ] `memory_for_next_session` generation
- [ ] Session audio recorder (full session capture)

**Dependencies:** M3a (AI persona working), Cloud Storage set up

## M5: Psychological Features & Safety (Week 5-6)

**Duration:** 5 days
**Goal:** Implement psychological red flag detection, caregiver escalation, and weekly reports

**Deliverables:**
- [ ] Red flag keyword detection (suicidal ideation, severe depression, physical symptoms)
- [ ] Push notification to caregiver on red flag
- [ ] Red flag log in Firestore
- [ ] Firestore schema for psychological history
- [ ] Caregiver weekly report generator (speech + psychology)
- [ ] Psychological trends dashboard (mood chart, negative statements over time)
- [ ] What worked / what to avoid / next strategy suggestions

**Dependencies:** M4 (memory system providing data)

## M6: Caregiver Dashboard & Polish (Week 6)

**Duration:** 5 days
**Goal:** Complete caregiver dashboard with speech + psychology views, PDF export

**Deliverables:**
- [ ] (Existing) Caregiver PIN system
- [ ] (Existing) Dashboard with weekly overview
- [ ] (Existing) Word performance table
- [ ] (Existing) Session history
- [ ] (Existing) PDF export
- [ ] **NEW:** Psychological trends tab (mood, negative statements, red flags)
- [ ] **NEW:** Weekly insight report (speech + psychology combined)
- [ ] **NEW:** AI-generated therapist note for caregiver

## M7: Testing, Validation & Deployment (Week 6-7)

**Duration:** 7 days
**Goal:** Comprehensive testing and deployment

**Deliverables:**
- [ ] Unit tests for all services
- [ ] Integration tests for session flow
- [ ] Cueing ladder behavior validation
- [ ] AI persona consistency testing
- [ ] Memory system end-to-end test
- [ ] Performance optimization
- [ ] Play Store deployment (internal testing)
- [ ] Test with father (real user testing)

---

## Updated Timeline

| Milestone | Duration | Week |
|-----------|----------|------|
| M1: Foundation | 5 days | Week 1 |
| M2: Core Therapy | 5 days | Week 2 |
| M3: AI Integration | 7 days | Week 3 |
| M3a: AI Persona & Protocol | 5 days | Week 3-4 |
| M4: Memory & Background Agent | 7 days | Week 4-5 |
| M5: Psychological Features | 5 days | Week 5-6 |
| M6: Caregiver Dashboard | 5 days | Week 6 |
| M7: Testing & Deploy | 7 days | Week 6-7 |

**Total: ~7 weeks** (vs 6 weeks original — 1 extra week for memory and psychology)

## Key Risks

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Gemini Live SDK constraint (Dart 3.8) | High | Blocks M3 | Upgrade Flutter, OR use direct WebSocket, OR fork gemini_live |
| Background agent latency >60s | Medium | Blocks M4 | Use Gemini Flash (fastest model), optimize audio upload |
| AI persona drift | Medium | Blocks M3a | Hardcoded rules, version-controlled prompt, consistency tests |
| Patient doesn't engage with AI | Medium | Product risk | Test early with father (Week 3), iterate persona |
| Sinhala TTS quality | Low | Annoyance | Piper TTS ONNX (UNICEF model) — acceptable quality |
| MediaPipe Face Mesh on low-end Android | Medium | Degraded UX | Fallback to silence-only detection |
| Audio recording storage costs | Low | Cost | Auto-delete recordings after 30 days, compress audio |
