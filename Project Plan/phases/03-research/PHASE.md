# Phase 4/15 — Research

**Goal:** Gather evidence before making decisions.

**Status:** IN PROGRESS 🔄

---

## Phase Content

### 4A. Technical Research — Digital Brain Clone Architecture

**Source Document:** [AURA_Digital_Brain_Clone_Architecture.md](../../.alldocs/AURA_Digital_Brain_Clone_Architecture.md)

This document introduces a biologically-mapped cognitive clone system that is NOT yet in our current architecture. Here's the research analysis:

#### Brain Region Module Analysis

| Topic | Evidence | Source | Recommendation | Tradeoffs |
|-------|----------|--------|----------------|-----------|
| 10 Brain Regions as `.md` files | Each region is a living document appended per session with timestamps | Digital Brain Clone doc | Implement as Firestore documents (not .md files) for queryability | .md = human-readable, Firestore = machine-queryable. Hybrid: store in Firestore, export to .md for reading |
| Prefrontal Cortex tracking | Identity, self-concept, goals — updates when patient shows identity shifts | Digital Brain Clone doc | New model: `BrainRegionModel` with fields for status, insights[], lastUpdated | Adds ~300 LOC to data layer |
| Amygdala emotional tracking | Fears, joys, triggers, de-escalation tools per timestamp | Digital Brain Clone doc | New model: `AmygdalaModel` with trigger list, joy anchors, de-escalation tools | Must integrate with existing red flag detection |
| Broca's Area speech tracking | Word mastery (mastered/approximate/difficult), phoneme difficulties, speed vs accuracy | Digital Brain Clone doc | New model: `BrocaAreaModel` with word mastery map, phoneme map, optimal speed range | Replaces simpler word tracking in current plan |
| Hippocampus memory tracking | What patient remembers/forgets, memory formation patterns | Digital Brain Clone doc | New model: `HippocampusModel` with recall accuracy, forgetting curve | New module, no prior equivalent |

#### Relationship Tree Analysis

| Topic | Evidence | Source | Recommendation | Tradeoffs |
|-------|----------|--------|----------------|-----------|
| Weighted relationship graph | JSON format with nodes (importance, valence), edges (weighted), clusters (Pain/Joy/Therapeutic) | Digital Brain Clone doc | New model: `RelationshipGraph` with Firestore JSON field | Graph queries require client-side processing; not Firestore-native |
| Per-person SAYS/FEELS/DOES quadrant | Each relationship file has What He SAYS/FEELS/DOES + Strategic Insight for AI | Digital Brain Clone doc | New model: `RelationshipPersonModel` with says[], feels[], does[], insights[] | Adds depth to persona system; requires more background agent processing |
| Emotional weight adjustments (±0.05/session) | Weights update dynamically based on session content | Digital Brain Clone doc | Background agent task: adjust weights, re-cluster after N sessions | Prevents stale graphs; risk of oscillation if too sensitive |

#### Background Agent Protocol Analysis

| Topic | Evidence | Source | Recommendation | Tradeoffs |
|-------|----------|--------|----------------|-----------|
| 7-step post-session update protocol | Read brain → analyze → append insights → adjust weights → update mastery → flag triggers → generate injection | Digital Brain Clone doc | Merge into existing BackgroundAgentOrchestrator as ordered pipeline | Makes background agent deterministic; 7 steps = ~2x processing time |
| Memory injection format | DIGITAL BRAIN SUMMARY: per-region summary, relationships, today's strategy (200-300 words) | Digital Brain Clone doc | Replace existing `memoryBlock` parameter with structured injection | More structured = more token-efficient; less flexible |

---

### 4B. Market Research
- **Primary user:** Single patient (father)
- **Competition:** Stepwise (app), Naming Therapy (app), Constant Therapy (app)
- **Differentiator:** AI-driven real-time adaptation via Gemini Live + biological brain mapping

### 4C. UX Research
- Existing analysis: 6-phase session structure, cueing ladder, breathing protocol
- Digital Brain adds: AI should adapt session strategy based on current brain region state (e.g., start with easy wins if amygdala shows stress)

### 4D. Engineering Research
- **Existing:** Flutter + Gemini Live API + MediaPipe + Firebase
- **New from Digital Brain:**
  - Need file store (local) for brain region data
  - Need background queue for 7-step update protocol
  - Need injection builder for DIGITAL BRAIN SUMMARY
  - Need relationship graph query engine
  - Need word mastery progression tracker

---

## New Modules Identified (from Digital Brain research)

| # | Module | File | Description | Dependencies |
|---|--------|------|-------------|-------------|
| M1 | Brain Region Model | `lib/data/memory/brain_region_model.dart` | Data structures for all 10 brain regions | None (data model) |
| M2 | Brain Region Store | `lib/data/memory/brain_region_store.dart` | CRUD for brain region Firestore docs | M1 |
| M3 | Relationship Graph Model | `lib/data/memory/relationship_graph.dart` | Weighted graph with nodes, edges, clusters | None |
| M4 | Relationship Person Model | `lib/data/memory/relationship_person.dart` | Per-person SAYS/FEELS/DOES + insights | M3 |
| M5 | Entity Knowledge Graph | `lib/data/memory/entity_graph.dart` | Topics with emotional valence | None |
| M6 | Pattern Repository | `lib/data/memory/pattern_repository.dart` | Speech/emotional/cognitive/behavioral patterns | M1, M4 |
| M7 | Therapeutic State | `lib/data/memory/therapeutic_state.dart` | Goals, difficulty levels, word mastery | M1 |
| M8 | Word Mastery Tracker | `lib/data/memory/word_mastery_tracker.dart` | Per-word mastery progression (mastered/learning/struggling) | None |
| M9 | Relationship Updater | `lib/data/background_agent/relationship_updater.dart` | Adjusts weights ±0.05 per session | M3, M4 |
| M10 | Brain Region Updater | `lib/data/background_agent/brain_region_updater.dart` | Appends insights to brain regions | M1, M2 |
| M11 | Memory Injection Builder | `lib/data/memory/memory_injection_builder.dart` | Compresses brain into 200-300 word DIGITAL BRAIN SUMMARY | M1-M7 |
| M12 | Session Log Store | `lib/data/memory/session_log_store.dart` | Writes session transcripts to history | None |
| M13 | Entity Graph Updater | `lib/data/background_agent/entity_updater.dart` | Updates topic emotional valence | M5 |

---

## Research Gate Check: ✅ PASS
- All 13 new modules identified with dependencies
- Cross-reference against existing plan complete
- No blockers found (all additions are additive, not breaking)
