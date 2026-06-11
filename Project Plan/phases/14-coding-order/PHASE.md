# Phase 15/15 — Coding Order

**Goal:** Determine exactly what to code and in what order.

**Status:** IN PROGRESS 🔄

---

## Build Order (Digital Brain Modules)

Based on dependency map (Phase 10) + priority matrix + roadmap:

### Batch 1: Foundation Models (No Dependencies)
Priority: MUST — These are leaf dependencies that everything else needs.

```
1. M0 - Brain Region Model (brain_region_model.dart)
2. M1 - Relationship Graph Model (relationship_graph.dart)
3. M2 - Entity Graph Model (entity_graph.dart)
4. M3 - Session Log Store (session_log_store.dart)
5. M4 - Word Mastery Tracker (word_mastery_tracker.dart)
```

**Can build in parallel:** All 5 are independent data models.

### Batch 2: Storage Layer
Priority: MUST — These provide persistence.

```
6. M5 - Brain Region Store (brain_region_store.dart)
7. M6 - Relationship Person Model (relationship_person.dart)
8. M7 - Therapeutic State (therapeutic_state.dart)
9. M8 - Pattern Repository (pattern_repository.dart)
```

**Note:** M6 depends on M1; M7 depends on M0+M4; M8 depends on M0+M6

### Batch 3: Background Agent Updaters
Priority: SHOULD — Core automation.

```
10. M9 - Brain Region Updater (brain_region_updater.dart)
11. M10 - Relationship Updater (relationship_updater.dart)
12. M11 - Entity Updater (entity_updater.dart)
```

**Note:** M9 depends on M5; M10 depends on M1+M6; M11 depends on M2

### Batch 4: Integration Layer
Priority: SHOULD — Brings everything together.

```
13. M12 - Memory Injection Builder (memory_injection_builder.dart)
```

### Batch 5: Orchestrator Integration
Priority: SHOULD — The 7-step protocol in the background agent.

```
14. M13 - Background Agent 7-Step Integration
     (Merge into existing BackgroundAgentOrchestrator)
```

### Batch 6: Prompt Pipeline
Priority: SHOULD — Inject brain summary into AI prompt.

```
15. M14 - Memory Injection → System Prompt Pipeline
     (Modify existing prompt_builder.dart + thilina_prompt.dart)
```

---

## Integration With Existing Build Order

The existing build order (from Phase 1 Prototype) is:

**Existing Phase 1 tasks:**
```
1. Initialize Flutter project (handa)                  ← ALREADY DONE
2. WebSocket connection to Gemini Live API              ← ALREADY DONE
3. MediaPipe Face Mesh integration                      ← ALREADY DONE
4. WidgetContainer state management                     ← ALREADY DONE
5. Core UI Widgets (Chat, Breathing, Exercise, Report)  ← ALREADY DONE
6. Function Call declarations                           ← ALREADY DONE
7. Thilina persona system prompt                        ← ALREADY DONE
```

**Digital Brain modules integrate AFTER existing Phase 1:**
```
After existing Phase 1 (Prototype) completes:
  8. Digital Brain Foundation Models (Batch 1)
  9. Digital Brain Storage Layer (Batch 2)
 10. Background Agent Updaters (Batch 3)
 11. Memory Injection Builder (Batch 4)
 12. Orchestrator Integration (Batch 5)
 13. Prompt Pipeline (Batch 6)
```

This builds after Phase 1 prototype but can start alongside Phase 2 automation work.

---

## Suggested Implementation Sequence

```
Week 1-2: Phase 1 Prototype (existing) + Batch 1 Foundation Models
  - Models have zero UI impact, can be built in parallel
  - No risk of blocking the main prototype

Week 3-4: Batch 2 Storage Layer
  - Firestore schema changes required
  - Must be done before background agent

Week 5-6: Batch 3 + Batch 4 (Updaters + Injection Builder)
  - Core of Phase 2 automation
  - Replaces manual prompt injection

Week 7-8: Batch 5 + Batch 6 (Orchestrator + Prompt Pipeline)
  - Full automation loop complete
  - End-to-end: session → background agent → memory injection → next session
```

---

## Gate Check: ✅ PASS
- Build order respects dependency tree
- Foundation models have zero dependencies — can parallelize with existing Phase 1
- No circular dependencies
- Integration points with existing services identified
- All 13 new modules have clear positions in implementation sequence
