# Phase 1: Prototype (Immediate)

## Goal
Build the initial prototype of AURA Speech Therapy (`handa`) for a single patient (Sinhala-speaking male) focusing on core real-time interactions using the Gemini Live API.

## Core Features
1. **Real-Time Voice Conversation:**
   - Integrate Gemini Live API (`gemini-3.1-flash-live-preview`) via WebSockets.
   - Bidirectional audio streaming with Sinhala language focus.
2. **Camera Vision & Face Analysis:**
   - Implement MediaPipe Face Mesh for offline struggle detection (Levels 0-4).
   - 1 frame per second processing to detect tension, smiles, or avoidance.
3. **Dynamic Widget UI (Single Screen):**
   - No navigation bars. Content changes purely based on AI function calls.
   - **Widgets to Build:** Conversation, Breathing, Exercise (Picture Naming), Text Display, Report.
4. **Basic Exercises & Protocols:**
   - 4-7-8 Box Breathing sequence with haptic feedback.
   - Picture Naming with the 4-level Cueing Ladder.
5. **Memory System:**
   - Manual memory updates (injected directly into the system prompt before the session).

## Technical Tasks
- [ ] Initialize and clean Flutter project (`handa`).
- [ ] Establish WebSocket connection to Vertex AI Live API.
- [ ] Implement MediaPipe Face Mesh locally.
- [ ] Build `WidgetContainer` state management.
- [ ] Create the core UI Widgets.
- [ ] Register Function Declarations with Gemini (e.g., `show_breathing_widget`).
- [ ] Refine the "Thilina" persona system prompt.

## Success Metrics
- AI response latency < 1 second.
- Struggle detection accurately triggers the cueing ladder.
- Successful end-to-end 20-minute session.
