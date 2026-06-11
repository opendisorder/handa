# AURA / Handa Speech Therapy — Detailed Developer Implementation Plan

This document provides a comprehensive, chunk-by-chunk technical blueprint for implementing the remaining 15 Digital Brain modules (**M0** to **M14**) in the Handa (හඬ) codebase. It is designed to guide developer agents with 99%-confidence through the implementation sequence.

---

## 🏛️ Architectural Framework

All modules follow **Clean Architecture** and **Domain-Driven Design (DDD)** principles to ensure isolation, testability, and clear dependency boundaries:

```
┌────────────────────────────────────────────────────────────────────────┐
│                          PRESENTATION LAYER                            │
│           (Riverpod Providers, Screens, Custom Widgets)                 │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│                            DOMAIN LAYER                                │
│       (Pure Data Models, Value Objects, Repository Interfaces)        │
└───────────────────────────────────▲────────────────────────────────────┘
                                    │
                                    │ implements
                                    │
┌────────────────────────────────────────────────────────────────────────┐
│                              DATA LAYER                                │
│      (Firestore Data Stores, Local Drift DB Caches, Agent Updaters)    │
└────────────────────────────────────────────────────────────────────────┘
```

1. **Domain Isolation:** Models (`lib/domain/models/` or local memory directories) are pure Dart objects. They must contain serialization methods (`fromJson`/`toJson`) and must not have direct references to Flutter or Firestore framework libraries.
2. **Repository Pattern:** Storage layers decouple database operations from business logic. State persistence maps strictly to Firestore subcollections under the `/patients/{patientId}/` path.
3. **Background Agent Orchestrator:** Operates as a sequential, transactional pipeline that executes a 7-step post-session data-fusion protocol before uploading results to the cloud.

---

## 📦 Batch-by-Batch Module Details

### Batch 1: Foundation Models (No Dependencies)
*These modules represent pure domain-level models and data structures with no external dependencies.*

#### M0: Brain Region Model (`brain_region_model.dart`)
- **Path:** `lib/data/memory/brain_region_model.dart`
- **Purpose:** Represents the biological cognitive status of the 10 distinct brain regions defined by the AURA architecture.
- **Expected Classes/Interfaces:**
  - `abstract class BrainRegion`
  - `class PrefrontalCortex extends BrainRegion` (fields: `List<String> insights`, `DateTime lastUpdated`)
  - `class Amygdala extends BrainRegion` (fields: `List<String> triggers`, `List<String> joyAnchors`, `List<String> deEscalationTools`)
  - `class BrocaArea extends BrainRegion` (fields: `Map<String, String> wordMastery` [word -> status], `Map<String, double> phonemes`, `double speedAccuracyRatio`)
  - *Note:* Also define models for `WernickeArea`, `MotorCortex`, `TemporalLobe`, `Cerebellum`, `Brainstem`, and `CorpusCallosum`.
- **Serialization:** Implement standard `Map<String, dynamic> toJson()` and factory `fromJson(Map<String, dynamic> json)` mappings for each region. Enforce camelCase JSON keys.
- **Integration Boundary:** Acts as the data schema representing the patient's neurological state.

#### M1: Relationship Graph Model (`relationship_graph.dart`)
- **Path:** `lib/data/memory/relationship_graph.dart`
- **Purpose:** Represents the emotional relationship tree of the patient using a mathematical graph topology.
- **Expected Classes/Interfaces:**
  - `class GraphNode` (fields: `String id`, `String label`, `double importance`, `double valence`)
  - `class GraphEdge` (fields: `String sourceId`, `String targetId`, `double weight`)
  - `class GraphCluster` (fields: `String id`, `String name`, `List<String> nodeIds`, `String category` [e.g., 'Pain', 'Joy', 'Therapeutic'])
  - `class RelationshipGraph` (fields: `List<GraphNode> nodes`, `List<GraphEdge> edges`, `List<GraphCluster> clusters`, `DateTime lastUpdated`)
- **Serialization:** Full JSON serialization for the entire graph configuration to allow atomic reads and writes from a single Firestore document.
- **Integration Boundary:** Read by memory query services to discover relationship-related triggers.

#### M2: Entity Graph Model (`entity_graph.dart`)
- **Path:** `lib/data/memory/entity_graph.dart`
- **Purpose:** Maps specific conversation topics (entities) to emotional valences to track interests and triggers.
- **Expected Classes/Interfaces:**
  - `class EntityTopic` (fields: `String name`, `String valence` [e.g., 'joy', 'shame', 'neutral'], `double strength`, `DateTime lastUpdated`)
- **Serialization:** `fromJson`/`toJson` mappings.
- **Integration Boundary:** Represents individual subcollection records in Firestore.

#### M3: Session Log Store (`session_log_store.dart`)
- **Path:** `lib/data/memory/session_log_store.dart`
- **Purpose:** Captures detailed transcripts, structured outputs, and frame-by-frame exercise data during a speech session.
- **Expected Classes/Interfaces:**
  - `class SessionLog` (fields: `String sessionId`, `DateTime timestamp`, `List<TranscriptTurn> transcript`, `List<String> functionCalls`, `List<String> wins`, `List<String> insights`)
  - `class TranscriptTurn` (fields: `String speaker` [e.g., 'therapist', 'patient'], `String text`, `int timestampMs`)
- **Serialization:** JSON-compatible format.
- **Integration Boundary:** Saved immediately at session termination before running updaters.

#### M4: Word Mastery Tracker (`word_mastery_tracker.dart`)
- **Path:** `lib/data/memory/word_mastery_tracker.dart`
- **Purpose:** Measures vocabulary acquisition, difficulty progression, and pronunciation accuracy.
- **Expected Classes/Interfaces:**
  - `class WordMastery` (fields: `String word`, `String status` [e.g., 'mastered', 'learning', 'struggling'], `DateTime firstSeen`, `DateTime lastPracticed`, `int consecutiveSuccesses`)
- **Serialization:** standard serialization.
- **Integration Boundary:** Directly consumed by the session exercise planner.

---

### Batch 2: Storage Layer (Depends on Batch 1)
*These classes implement Firestore data stores and repositories to manage local persistence.*

#### M5: Brain Region Store (`brain_region_store.dart`)
- **Path:** `lib/data/memory/brain_region_store.dart`
- **Purpose:** Interacts with the Cloud Firestore API to perform transactional CRUD operations on neurological brain data.
- **Expected Classes/Interfaces:**
  - `class BrainRegionStore`
  - `Future<BrainRegion> getRegion(String patientId, String regionName)`
  - `Future<void> updateRegion(String patientId, BrainRegion region)`
- **Integration Boundary:** Connects directly to `/patients/{patientId}/brain/{regionName}`. Exposed as a Riverpod provider.

#### M6: Relationship Person Model (`relationship_person.dart`)
- **Path:** `lib/data/memory/relationship_person.dart`
- **Purpose:** Extends the relationship graph with descriptive qualitative insights for individual key contacts (e.g., spouse, doctor).
- **Expected Classes/Interfaces:**
  - `class RelationshipPerson` (fields: `String personId`, `String name`, `double importance`, `double valence`, `List<String> says`, `List<String> feels`, `List<String> does`, `List<String> insights`, `DateTime lastUpdated`)
- **Integration Boundary:** Connects to `/patients/{patientId}/relationships/people/{personId}` in Firestore.

#### M7: Therapeutic State (`therapeutic_state.dart`)
- **Path:** `lib/data/memory/therapeutic_state.dart`
- **Purpose:** Maintains active therapy milestones and calibration settings across exercises.
- **Expected Classes/Interfaces:**
  - `class TherapeuticGoal` (fields: `String goal`, `String status`, `double progress`)
  - `class TherapeuticState` (fields: `List<TherapeuticGoal> currentGoals`, `Map<String, double> difficultyLevels`, `DateTime lastUpdated`)
- **Integration Boundary:** Read at the start of a session to customize exercise challenges.

#### M8: Pattern Repository (`pattern_repository.dart`)
- **Path:** `lib/data/memory/pattern_repository.dart`
- **Purpose:** Aggregates behavioral patterns across sessions (e.g., fatiguing at the 4-minute mark).
- **Expected Classes/Interfaces:**
  - `class CognitivePattern` (fields: `String type` [e.g., 'speech', 'emotional'], `List<String> trends`, `DateTime lastUpdated`)
- **Integration Boundary:** Writes to `/patients/{patientId}/patterns/`.

---

### Batch 3: Background Agent Updaters (Depends on Batch 2)
*These modules encapsulate logical rules for updating metrics based on post-session inputs.*

#### M9: Brain Region Updater (`brain_region_updater.dart`)
- **Path:** `lib/data/background_agent/brain_region_updater.dart`
- **Purpose:** Appends timestamped insights to the Prefrontal Cortex, Broca's Area, etc., based on session metrics.
- **Expected Classes/Interfaces:**
  - `class BrainRegionUpdater`
  - `Future<void> updateRegionsFromSession(String patientId, SessionLog session)`
- **Integration Boundary:** Resolves updates on local entities before calling `BrainRegionStore` to commit them.

#### M10: Relationship Updater (`relationship_updater.dart`)
- **Path:** `lib/data/background_agent/relationship_updater.dart`
- **Purpose:** Adjusts node valence and edge weights (e.g., incrementing/decrementing weight by $0.05$ based on emotional cues).
- **Expected Classes/Interfaces:**
  - `class RelationshipUpdater`
  - `Future<void> adjustWeights(String patientId, List<TranscriptTurn> triggers)`
- **Integration Boundary:** Reads, adjusts, and writes the `RelationshipGraph` document.

#### M11: Entity Updater (`entity_updater.dart`)
- **Path:** `lib/data/background_agent/entity_updater.dart`
- **Purpose:** Parses transcripts for mentioned topics and adjusts topic valence strength.
- **Expected Classes/Interfaces:**
  - `class EntityUpdater`
  - `Future<void> updateEntities(String patientId, List<TranscriptTurn> transcript)`
- **Integration Boundary:** Updates documents under `/patients/{patientId}/entities/`.

---

### Batch 4: Integration Layer
*Integrates local memory variables into a single formatted cognitive summary.*

#### M12: Memory Injection Builder (`memory_injection_builder.dart`)
- **Path:** `lib/data/memory/memory_injection_builder.dart`
- **Purpose:** Aggregates the state of all brain regions, relationship strengths, and active patterns, compiling them into a structured, highly compressed 200-300 word summary block (`DIGITAL BRAIN SUMMARY`).
- **Expected Classes/Interfaces:**
  - `class MemoryInjectionBuilder`
  - `Future<String> buildSummaryBlock(String patientId)`
- **Format of Output:**
  ```text
  === DIGITAL BRAIN SUMMARY ===
  [Prefrontal Cortex]: Patient shows positive identity shifts when discussing cricket.
  [Amygdala]: Active trigger discovered: high anxiety on word "hospital". Joy anchor: "grandchild".
  [Broca's Area]: Word mastery at 82%. Struggles with phoneme /l/.
  [Relationships]: Spouse valence: +0.85 (Joy/Support), Brother valence: -0.20 (Stress/Avoidance).
  [Strategy]: Start with easy visual cues, use the grandfather joy anchor if stress triggers are hit.
  =============================
  ```
- **Integration Boundary:** Fetches data from M5-M8 and returns the plain-text string.

---

### Batch 5: Orchestrator Integration
*Implements the background loop executing the 7-step data fusion pipeline.*

#### M13: Background Agent 7-Step Integration
- **Path:** `lib/data/background_agent/background_agent_orchestrator.dart`
- **Purpose:** Executes the ordered post-session protocol cleanly inside a transaction boundary.
- **Expected Execution Sequence:**
  1. **ReadBrain:** Retrieve all 10 regions, graphs, and settings.
  2. **Analyze:** Fuse audio transcripts, visual frames (struggle signatures), and response times.
  3. **AppendInsights:** Add insights to appropriate brain region structures.
  4. **AdjustWeights:** Apply updates ($\pm0.05$) to relationship elements.
  5. **UpdateMastery:** Adjust vocabulary mastery status.
  6. **FlagTriggers:** Scan for new cognitive or emotional warnings.
  7. **GenerateInjection:** Trigger the memory injection builder to refresh the system prompt payload.
- **Integration Boundary:** Invoked automatically by `SessionRepository` when a session is finalized.

---

### Batch 6: Prompt Pipeline
*Hooks the injected memory block directly into the live Gemini session.*

#### M14: Memory Injection -> System Prompt Pipeline
- **Path:** `lib/data/services/prompt_builder.dart` (or modifying `thilina_prompt.dart`)
- **Purpose:** Appends the freshly generated `DIGITAL BRAIN SUMMARY` payload directly into the therapist's core instructions.
- **Integration Details:**
  Modify `thilinaSystemPrompt({String memoryBlock = ''})` inside [thilina_prompt.dart](file:///home/jay/Workspace/Therapy/lib/data/services/thilina_prompt.dart):
  ```dart
  String thilinaSystemPrompt({String memoryBlock = ''}) {
    final brainSummary = memoryBlock.isNotEmpty ? '\n$memoryBlock\n' : '';
    return '''You are Thilina...
    $brainSummary
    ...''';
  }
  ```
- **Integration Boundary:** Connects `LiveApiService` directly to current data store outputs.

---

## 🛠️ Step-by-Step Developer Agent Guidelines

When executing these coding phases, developer agents should follow these best-practice guidelines:

### 1. Context Window Management
To avoid context bloat and token exhaustion:
- Do **not** load entire directories at once. Use targeted searches (`grep_search` and `find_by_name`).
- Read files incrementally. When analyzing code structures, limit output by specifying line ranges (e.g. `StartLine` and `EndLine` in `view_file`).

### 2. Surgical Patch Editing
- Always prefer target-specific edits via `replace_file_content` or `multi_replace_file_content` over overwriting entire source files.
- Ensure that you match leading whitespace and surrounding brackets exactly to prevent parsing errors.

### 3. Verification & Compilation Guard
- After creating or editing any dart model or service, execute the project analyzer to make sure there are no syntax or type mismatches:
  ```bash
  flutter analyze
  ```
- Run tests on serialization patterns to guarantee that all maps serialize into **camelCase** keys.
