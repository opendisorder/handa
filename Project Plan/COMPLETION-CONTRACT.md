# COMPLETION CONTRACT — AURA Speech Therapy (Handa)

> **Last Updated:** 2026-06-10

---

## Hard Deadline
- **Phase 1 (Web PWA Prototype):** 2 weeks from start
- **Phase 2 (Background Agent):** Month 2
- **Full 5-phase delivery:** Year 1

## MVP Definition (MoSCoW)

### Must Have (P0) — <40% of scope
- [ ] Real-time voice conversation via Gemini Live API
- [ ] 4-7-8 Breathing widget with haptic feedback
- [ ] Picture Naming widget with 4-level cueing ladder
- [ ] MediaPipe Face Mesh struggle detection (Levels 0-4)
- [ ] Thilina persona system prompt
- [ ] Single patient session support

### Should Have (P1)
- [ ] Background agent with brain region file updates
- [ ] Relationship tree with weighted graph
- [ ] Entity knowledge graph with emotional valence
- [ ] Memory injection (DIGITAL BRAIN SUMMARY)
- [ ] Caregiver weekly report

### Could Have (P2)
- [ ] Therapist dashboard
- [ ] Multi-patient profiles
- [ ] Mobile native deployment
- [ ] Offline mode

### Won't Have (W)
- [ ] Voice cloning
- [ ] Clinical trial infrastructure
- [ ] Community features

## Definition of Done
- [ ] Code compiles without errors (`flutter analyze` pass)
- [ ] All 4 widgets functional (Chat, Breathing, Exercise, Report)
- [ ] WebSocket connection to Gemini Live API established
- [ ] MediaPipe face mesh running at 1fps
- [ ] Cueing ladder correctly triggered by struggle levels
- [ ] Background agent updates brain files post-session
- [ ] Memory injection prepended to system prompt
- [ ] 20-minute end-to-end session completed successfully
- [ ] PWA deployment live on Firebase Hosting
- [ ] Caregiver weekly report exportable as PDF

## Definition of Success
- AI response latency < 1 second
- Struggle detection accurately triggers cueing ladder transitions
- Background agent updates brain files within 5 minutes of session end
- Relationship weights adjust ±0.05 per session
- Caregiver report accurately reflects frustration events and wins

## Lifecycle State
- **Current:** ACTIVE (All 15 Planning Phases Complete ✅)
- **Target:** IMPLEMENTATION (ongoing per coding-order.md)
