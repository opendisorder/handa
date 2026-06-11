# Phase 5 — Requirements Update: Reference Implementation Findings

> **Project:** Handa (හඬ) — Stroke Speech Therapy Android App
> **Date:** 2026-06-10
> **Status:** COMPLETE
> **Base document:** `docs/requirements-document.md`

---

## New Functional Requirements from Reference

### FR-19: Audio Output Queue with Interruption Support
**As a** patient, **I want** audio output to play sequentially without overlapping, **so that** I can hear Thilina's speech clearly without glitches.

**Acceptance Criteria:**
- Audio chunks received from Live API are queued sequentially
- Each chunk plays only after the previous one completes
- When `serverContent.interrupted` is received, all queued audio stops immediately
- The queue resets on interruption
- No overlapping audio ever plays

### FR-20: Audio Input Chunking (ScriptProcessor Pattern)
**As a** patient, **I want** my voice to be captured in real-time chunks, **so that** Thilina can hear me without delay.

**Acceptance Criteria:**
- Mic audio is captured in ~256ms chunks (4096 samples at 16kHz)
- Each chunk is encoded as Int16 PCM → base64
- Chunks are sent via `sendRealtimeInput` immediately
- No gaps between chunks
- Capture resumes automatically after interruption

### FR-21: Widget Routing Based on Function Calls (Screen Controller)
**As a** patient, **I want** the screen to change automatically when Thilina calls a function, **so that** I see the right widget at the right time.

**Acceptance Criteria:**
- `show_conversation_widget()` → Conversation screen with avatar + subtitles
- `show_breathing_widget(cycles)` → Breathing animation with cycle counter
- `show_exercise_widget(imageUrl, targetWord)` → Image naming exercise
- `end_session(wins)` → Session report with wins list
- Widget transitions are animated (slide-in)
- Error state: unknown function → stay on current widget

### FR-22: Sequential Audio Queue (Replaces Concurrent Playback)
**As a** patient, **I want** audio to be scheduled sequentially without gaps, **so that** speech sounds continuous.

**Acceptance Criteria:**
- Each received audio chunk is decoded and scheduled to play after the previous chunk
- A `nextStartTime` accumulator tracks the schedule
- Audio chunks that arrive during playback are appended to the queue
- The queue handles interruption by stopping all sources and resetting the timer

### FR-23: Empty Transcription Config (Override Requirement)
**As a** developer, **I want** to use `{}` (empty object) for both `outputAudioTranscription` and `inputAudioTranscription`, **so that** the Live API sends transcription data reliably.

**Acceptance Criteria:**
- Config uses `outputAudioTranscription: {}` (not `{languageCodes: [...]}`)
- Config uses `inputAudioTranscription: {}` (not `{enabled: true}`)
- Server sends `serverContent` messages with `outputTranscription.text`
- Server sends `serverContent` messages with `inputTranscription.text`
- No server errors result from transcription config

### FR-24: Widget Idle Animation States
**As a** patient, **I want** visual feedback when waiting, **so that** I know the system is still active.

**Acceptance Criteria:**
- Conversation widget shows 3-dot bouncing animation when no subtitle text
- User transcript area shows idle dots when not speaking
- Breathing widget shows animated expanding circle during exercise
- All animations are calm and non-distracting (suitable for post-stroke)

---

## New Non-Functional Requirements

### NFR-11: TCP-Level Backend Proxy Option
**For optional Node.js proxy path:**
- Express server with rate limiting (100 req/15min minimum)
- WebSocket upgrade handler for `/ws-proxy`
- Hardcoded upstream host allowlist for SSRF protection
- ADC token injection on every upstream request
- `setup.model` rewrite to full Vertex path
- Payload size limit: 7MB minimum
- Production: Deploy on Cloud Run or as Cloudflare Worker

### NFR-12: Audio Timing Precision
- Audio output scheduling accuracy: within ±50ms of scheduled time
- Audio chunk processing latency: <100ms from receive to schedule
- Capture chunk interval: consistent 256ms ±10ms
- Interruption response time: <50ms from receiving interrupted flag to audio stop

---

## Requirement Updates to Existing FRs

### FR-10 (Live Conversation): Add Widget Switching
Update FR-10 acceptance criteria to include:
- Screen transitions between 4 widget states based on function calls
- Each widget correctly renders its parameters (cycles, imageUrl, wins)
- Widget state resets when a new function is called

### FR-11 (Session Summary): Align with ReportWidget Pattern
Update FR-11 to use the "Today's Wins" list pattern from the reference:
- Display wins as a list with checkmark icons
- Show "Session Complete" heading with award icon
- "See you tomorrow" button to close

---

## Validation Gate

| Requirement | Status | Evidence |
|-------------|--------|----------|
| FR-19 Audio Output Queue | ✅ NEW | Reference useGeminiLive.ts lines 163-191 |
| FR-20 Audio Input Chunking | ✅ NEW | Reference audioUtils.ts + useGeminiLive.ts lines 104-115 |
| FR-21 Widget Routing | ✅ NEW | Reference App.tsx switch statement |
| FR-22 Sequential Audio Queue | ✅ NEW | Reference useGeminiLive.ts nextStartTimeRef pattern |
| FR-23 Empty Transcription Config | ✅ NEW | Reference constants.ts empty `{}` |
| FR-24 Widget Idle Animations | ✅ NEW | Reference ConversationWidget 3-dot animation |
| NFR-11 Backend Proxy | ✅ NEW | Reference server.js (468 lines) |
| NFR-12 Audio Timing | ✅ NEW | Extracted from reference implementation |
| FR-10 Update | ✅ UPDATED | Widget switching added |
| FR-11 Update | ✅ UPDATED | ReportWidget pattern |

**All requirements backed by reference implementation evidence.**
