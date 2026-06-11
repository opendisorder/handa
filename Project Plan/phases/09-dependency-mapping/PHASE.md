# Phase 10/15 — Dependency Mapping

**Goal:** Create implementation order based on actual dependencies.

**Status:** IN PROGRESS 🔄

---

## Dependency Tree (Digital Brain Modules)

### Layer 0: Foundation (No Dependencies)
```
M0  - Brain Region Model (brain_region_model.dart)
M1  - Relationship Graph Model (relationship_graph.dart)
M2  - Entity Graph Model (entity_graph.dart)
M3  - Session Log Store (session_log_store.dart)
M4  - Word Mastery Tracker (word_mastery_tracker.dart)
```
These are pure data models — no dependencies on other modules.

### Layer 1: Storage Layer (Depends on Layer 0)
```
M5  - Brain Region Store (brain_region_store.dart)
     Depends on: M0 (Brain Region Model)
     
M6  - Relationship Person Model (relationship_person.dart)
     Depends on: M1 (Relationship Graph Model)
     
M7  - Therapeutic State (therapeutic_state.dart)
     Depends on: M0, M4 (Brain Region, Word Mastery)
     
M8  - Pattern Repository (pattern_repository.dart)
     Depends on: M0, M6 (Brain Region, Relationship Person)
```

### Layer 2: Background Agent Updaters (Depends on Layer 1)
```
M9  - Brain Region Updater (brain_region_updater.dart)
     Depends on: M5 (Brain Region Store)
     
M10 - Relationship Updater (relationship_updater.dart)
     Depends on: M1, M6 (Graph Model, Person Model)
     
M11 - Entity Updater (entity_updater.dart)
     Depends on: M2 (Entity Graph Model)
```

### Layer 3: Integration (Depends on Layer 2)
```
M12 - Memory Injection Builder (memory_injection_builder.dart)
     Depends on: M5, M7, M8, M10, M11 (all updaters + state)
     Also depends on: Existing SessionAnalyzer service
```

### Layer 4: Background Agent Orchestrator (Depends on Layer 3)
```
M13 - Background Agent 7-Step Protocol
     Depends on: M9, M10, M11, M12 (all updaters + injection)
     Also depends on: Existing BackgroundAgentOrchestrator
```

### Layer 5: Prompt Integration (Depends on Layer 4)
```
M14 - Memory Injection → System Prompt Pipeline
     Depends on: M12, M13 (Injection Builder + Agent)
     Also depends on: Existing prompt_builder.dart, thilina_prompt.dart
```

---

## Visual Dependency Graph

```
                    ┌──────────────────────────────┐
                    │  Layer 0: Foundation          │
                    │  M0 M1 M2 M3 M4              │
                    └──────────┬───────────────────┘
                               │
                    ┌──────────▼───────────────────┐
                    │  Layer 1: Storage             │
                    │  M5 M6 M7 M8                 │
                    └──────────┬───────────────────┘
                               │
                    ┌──────────▼───────────────────┐
                    │  Layer 2: Agent Updaters      │
                    │  M9 M10 M11                  │
                    └──────────┬───────────────────┘
                               │
                    ┌──────────▼───────────────────┐
                    │  Layer 3: Integration         │
                    │  M12 (Injection Builder)      │
                    └──────────┬───────────────────┘
                               │
                    ┌──────────▼───────────────────┐
                    │  Layer 4: Orchestrator        │
                    │  M13 (7-Step Protocol)        │
                    └──────────┬───────────────────┘
                               │
                    ┌──────────▼───────────────────┐
                    │  Layer 5: Prompt Pipeline     │
                    │  M14 (System Prompt Inject)   │
                    └──────────────────────────────┘
```

## Integration with Existing System

The Digital Brain modules integrate into existing services:

| Existing Service | Digital Brain Integration |
|-----------------|--------------------------|
| `websocket_handler.dart` | No change — session audio unaffected |
| `mediapipe_service.dart` | No change — struggle detection independent |
| `session_manager.dart` | Triggers background agent on session end |
| `background_agent_orchestrator.dart` | Hosts 7-step protocol (M13) |
| `prompt_builder.dart` | Injects DIGITAL BRAIN SUMMARY before system prompt |
| `thilina_prompt.dart` | memoryBlock parameter populated from M12 |
| `widget_container.dart` | No change — widgets driven by function calls |
| `function_call_handler.dart` | No change — function calls independent |
| `red_flag_detector.dart` | Amygdala insights feed into detection |

---

## Gate Check: ✅ PASS
- No circular dependencies
- Foundation layer (Layer 0) can be built in parallel
- All 5 integration points with existing services identified
- Updaters (Layer 2) depend on storage (Layer 1); injection builder depends on all updaters
