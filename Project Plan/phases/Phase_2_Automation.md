# Phase 2: Background Agent Automation (Month 2)

## Goal
Automate the psychological and memory systems of AURA. Replace manual prompt injection with an autonomous background agent that updates the patient's "Digital Brain" after every session.

## Core Features
1. **Background Analysis Agent:**
   - Triggered post-session.
   - Fuses audio, video frame data, transcripts, and function call logs.
   - Extracts therapeutic insights, emotional arcs, and speech metrics.
2. **The Digital Brain:**
   - Auto-update 10 brain-region markdown files (e.g., Prefrontal cortex for identity, Broca's area for speech).
   - Update the relationship tree and knowledge graph.
3. **Memory Injection Automation:**
   - Generate the 200-300 word context block dynamically before the next session.
4. **Reporting:**
   - Auto-generate the Caregiver Weekly Report (wins, areas of work, therapist notes).

## Technical Tasks
- [ ] Setup Google Cloud Vertex AI Batch API for post-session analysis.
- [ ] Implement Firebase Cloud Functions to trigger the background agent.
- [ ] Design Firestore schema for Session Logs and Brain Region data.
- [ ] Implement auto-generation of Caregiver Reports (PDF or UI dashboard).

## Success Metrics
- Agent successfully updates brain files within 5 minutes of session end.
- Caregiver report accurately reflects frustration events and wins.
