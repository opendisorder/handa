# MAIN CHECKLIST — AURA Speech Therapy (Handa)

> **Overall Progress:** 100% (Planning) + M0-M15 Implemented
> **Last Updated:** 2026-06-10

---

## Phase 0: Project Plan Scaffold [100%]
- [x] Create 15-phase directory structure
- [x] Create [README.md](file:///home/jay/Workspace/Therapy/Project%20Plan/README.md) hub
- [x] Create [MAIN-CHECKLIST.md](file:///home/jay/Workspace/Therapy/Project%20Plan/MAIN-CHECKLIST.md)
- [x] Create [PROGRESS-DASHBOARD.md](file:///home/jay/Workspace/Therapy/Project%20Plan/PROGRESS-DASHBOARD.md)
- [x] Create [DECISIONS.md](file:///home/jay/Workspace/Therapy/Project%20Plan/DECISIONS.md)
- [x] Create [RISKS.md](file:///home/jay/Workspace/Therapy/Project%20Plan/RISKS.md)
- [x] Create [CHANGELOG.md](file:///home/jay/Workspace/Therapy/Project%20Plan/CHANGELOG.md)
- [x] Create [GLOSSARY.md](file:///home/jay/Workspace/Therapy/Project%20Plan/GLOSSARY.md)
- [x] Create [COMPLETION-CONTRACT.md](file:///home/jay/Workspace/Therapy/Project%20Plan/COMPLETION-CONTRACT.md)
- [x] Create [CUT-LIST.md](file:///home/jay/Workspace/Therapy/Project%20Plan/CUT-LIST.md)

## Phase 1: Intent Discovery [100%]
- [x] Answer 7 questions regarding stroke patient clinical voice rehabilitation
- [x] Document intent in [.alldocs/Planning_Phases/intent-report.md](file:///home/jay/Workspace/Therapy/.alldocs/Planning_Phases/intent-report.md)
- [x] Confirm project name and direction

## Phase 2: Gap Analysis [100%]
- [x] Check geography, auth, payment, data storage, and network latency constraints
- [x] Document gaps in [.alldocs/Planning_Phases/gap-analysis-report.md](file:///home/jay/Workspace/Therapy/.alldocs/Planning_Phases/gap-analysis-report.md)

## Phase 3: Contradiction Detection [100%]
- [x] Check for logical impossibilities or design gaps in product specs (e.g. offline fallback scoring vs online WebSocket API)
- [x] Document in [.alldocs/Planning_Phases/conflict-report.md](file:///home/jay/Workspace/Therapy/.alldocs/Planning_Phases/conflict-report.md)

## Phase 4: Research [100%]
- [x] Ingest Digital Brain Clone Architecture into .alldocs
- [x] Cross-reference against existing plan
- [x] Document research findings — 13 new modules identified
- [x] 5 integration points with existing services mapped
- [x] Documented in [.alldocs/Planning_Phases/research-report.md](file:///home/jay/Workspace/Therapy/.alldocs/Planning_Phases/research-report.md)

## Phase 5: Requirements [100%]
- [x] Write Functional Requirements (10 FRs: BRAIN-01/02, REL-01/02/03, ENT-01, PAT-01, TH-01, INJ-01, BG-01)
- [x] Write Non-Functional Requirements (5 NFRs: PERF-01/02, DATA-01, SEC-01, SCAL-01)
- [x] Documented in [.alldocs/Planning_Phases/requirements-document.md](file:///home/jay/Workspace/Therapy/.alldocs/Planning_Phases/requirements-document.md)

## Phase 6: Product Definition [100%]
- [x] Vision statement drafted
- [x] Mission statement drafted
- [x] Complete personas, KPIs, user journeys
- [x] Document in [.alldocs/Planning_Phases/product-definition.md](file:///home/jay/Workspace/Therapy/.alldocs/Planning_Phases/product-definition.md)

## Phase 7: UX Planning [100%]
- [x] User flows, wireframes, info architecture
- [x] Document in [.alldocs/Planning_Phases/ux-plan.md](file:///home/jay/Workspace/Therapy/.alldocs/Planning_Phases/ux-plan.md)

## Phase 8: Architecture [100%]
- [x] Original architecture docs (8 files in lib/)
- [x] Merged Digital Brain architecture: 13 modules across 5 layers
- [x] Firestore schema designed for all brain data
- [x] 7-step background agent protocol integrated
- [x] Documented in [.alldocs/Planning_Phases/architecture-document.md](file:///home/jay/Workspace/Therapy/.alldocs/Planning_Phases/architecture-document.md)

## Phase 9: Device Analysis [100%]
- [x] Device matrix, screen sizes, OS compatibility, and physical haptics capabilities
- [x] Document in [.alldocs/Planning_Phases/device-analysis.md](file:///home/jay/Workspace/Therapy/.alldocs/Planning_Phases/device-analysis.md)

## Phase 10: Dependency Mapping [100%]
- [x] Create 6-layer dependency tree (M0-M14)
- [x] No circular dependencies confirmed
- [x] All 5 integration points with existing services mapped
- [x] Documented in [.alldocs/Planning_Phases/dependency-map.md](file:///home/jay/Workspace/Therapy/.alldocs/Planning_Phases/dependency-map.md)

## Phase 11: Priority Matrix [100%]
- [x] MoSCoW categorization of features (Must-Have, Should-Have, Could-Have, Won't-Have)
- [x] Document in [.alldocs/Planning_Phases/priority-matrix.md](file:///home/jay/Workspace/Therapy/.alldocs/Planning_Phases/priority-matrix.md)

## Phase 12: Implementation Roadmap [100%]
- [x] Original 5-phase delivery plan exists
- [x] Convert to time-bound milestones
- [x] Document in [.alldocs/Planning_Phases/implementation-roadmap.md](file:///home/jay/Workspace/Therapy/.alldocs/Planning_Phases/implementation-roadmap.md)

## Phase 13: Progress Tracker [100%]
- [x] [PROGRESS-DASHBOARD.md](file:///home/jay/Workspace/Therapy/Project%20Plan/PROGRESS-DASHBOARD.md) created
- [x] Update tracker continuously to synchronize planning artifacts
- [x] Document in [.alldocs/Planning_Phases/progress-tracker.md](file:///home/jay/Workspace/Therapy/.alldocs/Planning_Phases/progress-tracker.md)

## Phase 14: Validation Gate [100%]
- [x] 12-document checklist audit
- [x] Document in [.alldocs/Planning_Phases/validation-gate-report.md](file:///home/jay/Workspace/Therapy/.alldocs/Planning_Phases/validation-gate-report.md)

## Phase 15: Coding Order [100%]
- [x] 6 batches sequenced by dependency tree
- [x] Foundation models parallelizable
- [x] Week-by-week implementation sequence mapped
- [x] Documented in [.alldocs/Planning_Phases/coding-order.md](file:///home/jay/Workspace/Therapy/.alldocs/Planning_Phases/coding-order.md)

---

## Technical Features Cataloged & Validated
- **Vertex AI Client Setup**: Modified `gemini_live` package fork (`gemini_live_fork`) to enforce camelCase JSON keys, matching the Vertex AI Live API requirements and preventing standard API snake_case rejections. See [live_service.dart](file:///home/jay/Workspace/Therapy/lib/data/services/gemini_live_fork/lib/src/live_service.dart).
- **Binary Sniffer Router**: Solved UTF-8 decoding crashes in `live_service.dart` by identifying JSON frames (starting with `{` or `0x7b`) and separating them from raw binary PCM frames. See [live_service.dart:337](file:///home/jay/Workspace/Therapy/lib/data/services/gemini_live_fork/lib/src/live_service.dart#L337).
- **PCM Audio WAV Prepend**: Enabled native audio playback in `live_audio_player.dart` by prepending a 44-byte WAV header configured for `24kHz/16-bit/mono PCM`. See [live_audio_player.dart:49](file:///home/jay/Workspace/Therapy/lib/presentation/widgets/common/live_audio_player.dart#L49).
- **Clinical Score Boundaries**: Configured `scoring_engine.dart` with a 4-tier model (Excellent >= 90%, Good >= 75%, Almost >= 60%, Try Again < 60%). See [scoring_engine.dart](file:///home/jay/Workspace/Therapy/lib/domain/services/scoring_engine.dart).
- **Therapy Mastery Criteria**: Set mastery thresholds in `app_constants.dart` requiring a score of >= 70% across 3 consecutive attempts. See [app_constants.dart:28](file:///home/jay/Workspace/Therapy/lib/core/constants/app_constants.dart#L28).
- **Sinhala Clinical Avatar Prompts**: Developed natural Colombo Sinhala dialect prompts for the "Thilina" persona in `thilina_prompt.dart`, offering warm encouragement phrases. See [thilina_prompt.dart](file:///home/jay/Workspace/Therapy/lib/data/services/thilina_prompt.dart).
- **Tactile Feedback Haptic Mapping**: Avoided clinical reject haptics, instead mapping to double heavy tap, medium tap, light tap, and light + selectionClick. See [theme_extensions.dart:21](file:///home/jay/Workspace/Therapy/lib/core/extensions/theme_extensions.dart#L21).
- **UI Layout Hardening**: Fixed settings screen text overflows (`infoRow` layout constraints) and onboarding completion view alignment (`Spacer` and alignment hardening). See [settings_screen.dart](file:///home/jay/Workspace/Therapy/lib/presentation/screens/settings/settings_screen.dart).
- **Gemini Tool Calling**: Function declarations for log_exercise, end_session, update_patient_state, show_breathing_widget, show_text_on_screen, play_sound. All 3 screens wire tool calls to BackgroundAgentOrchestrator.

---

## Digital Brain Implementation (M0-M15)

### Batch 1: Foundation Domain Models [100%]
- [x] M0: Brain Region Model — 10-region enum + BrainRegionState + region-specific metrics
- [x] M1: Relationship Graph Model — weighted graph with Pain/Joy/Therapeutic clusters
- [x] M2: Entity Graph Model — EntityNode + EmotionalValence (joy/shame/trigger/neutral/sadness/pride)
- [x] M3: Session Log Model — SessionLog + SessionSummary + StruggleEvent + TriggerMention
- [x] M4: Word Mastery Tracker — WordAttempt → WordProgress → WordMasteryIndex with auto-promotion
- [x] M5: Therapeutic State Model — TherapyGoal + DifficultyLevels + TherapeuticState
- [x] M6: Pattern Repository — 4-dimension trend analysis (speech, emotional, cognitive, behavioral)

### Batch 2: Storage Layer [100%]
- [x] Brain Region Store — FlutterSecureStorage CRUD + appendInsight for 10 regions
- [x] Relationship Store — save/load graph + per-person profiles
- [x] Entity Store — save/load + upsertNode + avoid/approach topic queries
- [x] Word Mastery Store — save/load + recordAttempt with auto-status-promotion
- [x] Therapeutic State Store — save/load + goal management
- [x] Session Log Store — save/load + date-range query + 90-day prune
- [x] Pattern Repository Store — cross-session trend persistence

### Batch 3: Background Agent Updaters [100%]
- [x] M9: Brain Region Updater — appends timestamped insights post-session
- [x] M10: Relationship Updater — ±0.05 weight adjustment per session
- [x] M11: Entity Updater — valence updates from win/flag analysis

### Batch 4: Memory Injection Builder [100%]
- [x] M12: Memory Injection Builder — ≤300-word DIGITAL BRAIN SUMMARY

### Batch 5: Background Agent Orchestrator [100%]
- [x] M13: 7-step post-session protocol (ReadBrain → Analyze → AppendInsights → AdjustWeights → UpdateMastery → FlagTriggers → GenerateInjection)
- [x] DigitalBrainService — high-level coordinator for all stores

### Batch 6: Prompt Pipeline Integration [100%]
- [x] M14: Riverpod providers (10 providers for all services)
- [x] Session screen — async memory block injection + tool call handling
- [x] Conversation screen — async memory block injection + tool call handling
- [x] Exercise screen — async memory block injection + tool call handling

### Batch 7: Tool Call Handler Integration [100%]
- [x] ToolCallHandlerService — routes Gemini function calls to BackgroundAgentOrchestrator
- [x] function_declarations.dart — 6 function declarations (log_exercise, end_session, etc.)
- [x] LiveApiService.connect() — accepts optional `tools` parameter
- [x] All 3 screens wire tool calls from _handleMessage → sendToolResponse

### Batch 8: P0/P1 Features (Exercise Content + Scoring + Cueing Ladder + Struggle Detection + Caregiver Report) [100%]
- [x] Exercise content library — 12 categories, 100+ items with imageUrl (`domain/models/exercise_content.dart`)
- [x] Offline fallback scoring — ScoringEngine + LevenshteinDistance wired into session_screen
- [x] CueingLadderService — 4-level progressive hint system (L0=L1=L2=L3)
- [x] Cueing ladder integrated into exercise_screen.dart + session_screen.dart (prompt, retry, badge UI)
- [x] StruggleDetectionService — behavioral signal analysis (response time + similarity + pattern)
- [x] Struggle badge shown in session_screen result phase
- [x] CaregiverReportService — A4 PDF weekly report with daily activity, word mastery, brain insights
- [x] Weekly report button on caregiver dashboard
- [x] caregiverReportServiceProvider in digital_brain_providers.dart
- [x] `flutter analyze`: 0 errors

### Remaining Work
- [x] Build Digital Brain visualization section in dashboard_screen.dart
- [x] Build exercise content library with real images
- [x] Add offline fallback scoring pipeline

## Legend
- `[x]` = Done
- `[ ]` = Pending
- `[~]` = In Progress
- Percentage = estimated completion of phase
