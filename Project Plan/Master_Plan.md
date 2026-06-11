# Master Project Plan: AURA Speech Therapy (Handa)

This master plan outlines the strategic phases for building the AURA Speech Therapy application, an AI-powered speech therapy companion designed for post-stroke patients with aphasia and apraxia.

The plan is divided into 5 phases, moving from a single-patient prototype to a clinically validated platform.

## Architecture & Core Technologies
- **Frontend:** Flutter (Web PWA for Phase 1, Native Mobile later).
- **AI Backend:** Google Cloud Vertex AI — Gemini Live API (`gemini-3.1-flash-live-preview`).
- **Vision/Face Analysis:** MediaPipe Face Mesh (running locally).
- **Therapeutic Approach:** Naming exercises, 4-7-8 breathing protocol, cueing ladders, and emotional regulation.

## Phases Overview
1. **Phase 1: Web PWA Prototype (Now)** - Focus on the core Gemini Live API integration, basic widgets, and a single patient.
2. **Phase 2: Background Agent Automation (Month 2)** - Automate the digital brain updates and session analysis.
3. **Phase 3: Multi-Patient Scale (Month 3)** - Add therapist dashboard and adaptive difficulty.
4. **Phase 4: Mobile App & Offline Mode (Month 6)** - Full Flutter mobile deployment, offline capabilities.
5. **Phase 5: Clinical Validation (Year 1)** - Hospital partnerships and scale.

Detailed phase documents are available in the `phases/` directory.
