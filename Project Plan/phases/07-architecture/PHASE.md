# Phase 8/15 — System Architecture

**Goal:** Design the system structure with Digital Brain integration.

**Status:** IN PROGRESS 🔄

---

## 8A. Frontend Architecture (Flutter)

### Existing
- Flutter Web PWA
- `lib/` with models, services, UI widgets, providers
- 4 widgets: Chat, Breathing, Exercise, Report
- WidgetContainer state management via function calls
- Thilina persona system prompt

### Digital Brain Additions

**New Data Models (lib/data/memory/):**
```
lib/data/memory/
├── brain_region_model.dart     ← 10 region data structures
├── brain_region_store.dart     ← Firestore CRUD for brain regions
├── relationship_graph.dart     ← Weighted graph (nodes, edges, clusters)
├── relationship_person.dart    ← Per-person SAYS/FEELS/DOES
├── entity_graph.dart           ← Topic emotional valence
├── pattern_repository.dart     ← Cross-session patterns
├── therapeutic_state.dart      ← Goals, difficulty, mastery
├── word_mastery_tracker.dart   ← Per-word progression
├── memory_injection_builder.dart ← 200-300 word summary
└── session_log_store.dart      ← Session transcripts
```

**New Background Agent Modules (lib/data/background_agent/):**
```
lib/data/background_agent/
├── relationship_updater.dart   ← Weight adjustment (±0.05)
├── brain_region_updater.dart   ← Append insights
└── entity_updater.dart         ← Update emotional valence
```

## 8B. Backend Architecture

### Data Flow — Digital Brain Update Cycle
```
┌─────────────────────────────────────────────────────────┐
│                    Session End                           │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│  Background Agent Orchestrator (7-step protocol)         │
│                                                          │
│  Step 1: ReadBrain — load all 10 regions + graph + state │
│  Step 2: Analyze — session fusion (audio+video+text)     │
│  Step 3: AppendInsights — timestamped region updates     │
│  Step 4: AdjustWeights — ±0.05 relationship graph       │
│  Step 5: UpdateMastery — word progression tracking      │
│  Step 6: FlagTriggers — new emotional triggers/patterns  │
│  Step 7: GenerateInjection — 200-300 word summary        │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│  Firestore Updates                                       │
│  ├── /patients/{id}/brain/{region}  ← Region documents  │
│  ├── /patients/{id}/relationships   ← Graph JSON         │
│  ├── /patients/{id}/entities/{name} ← Entity valence     │
│  ├── /patients/{id}/patterns/{type} ← Pattern data       │
│  └── /patients/{id}/sessions/{date} ← Session log        │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│  Next Session Start                                      │
│  ├── Memory Injection → prepend to system prompt         │
│  └── AI sees "DIGITAL BRAIN SUMMARY" before first word   │
└─────────────────────────────────────────────────────────┘
```

### Firestore Schema — Digital Brain Collections
```
/patients/{patientId}/
├── profile/
├── brain/
│   ├── prefrontal_cortex: {region, insights[], lastUpdated}
│   ├── hippocampus: {region, memoryPatterns[], recallAccuracy, lastUpdated}
│   ├── amygdala: {triggers[], joyAnchors[], deEscalationTools[], lastUpdated}
│   ├── broca_area: {masteredWords{}, approximateWords{}, phonemes{}, speedAccuracy, lastUpdated}
│   ├── wernicke_area: {comprehensionLevel, understandingPatterns[], lastUpdated}
│   ├── motor_cortex: {facialPatterns{}, struggleSignatures[], lastUpdated}
│   ├── temporal_lobe: {auditoryResponses, musicPreferences, lastUpdated}
│   ├── cerebellum: {rhythmCoordination, breathingControl, timingData, lastUpdated}
│   ├── brainstem: {energyPatterns, bestSessionTimes, arousalLevels, lastUpdated}
│   └── corpus_callosum: {logicEmotionBalance, integrationPatterns, lastUpdated}
├── relationships/
│   ├── graph: {nodes[], edges[], clusters[], lastUpdated}
│   └── people/
│       ├── {personId}: {name, importance, valence, says[], feels[], does[], insights[], lastUpdated}
│       └── ...
├── entities/
│   ├── cricket: {valence: "joy", strength: 0.75, lastUpdated}
│   ├── money: {valence: "shame", strength: 0.90, lastUpdated}
│   └── ...
├── patterns/
│   ├── speech: {trends[], lastUpdated}
│   ├── emotional: {frequency{}, lastUpdated}
│   ├── cognitive: {attentionSpan[], lastUpdated}
│   └── behavioral: {defenseMechanisms[], lastUpdated}
├── therapeutic_state/
│   ├── currentGoals: [{goal, status, progress}]
│   ├── difficultyLevels: {word:{}, exercise:{}}
│   └── wordMastery: {word:{status, firstSeen, lastPracticed}}
└── sessions/
    ├── 2026-06-10: {transcript, functionCalls[], frameData[], insights[], wins[]}
    └── ...
```

## 8C. Database Architecture
- **Primary:** Firestore (cloud-synced patient data)
- **Local cache:** SQLite/Isar for offline session continuity
- **Brain regions:** Stored as Firestore documents in `/brain/{region}` subcollection
- **Relationship graph:** Single JSON document for atomic reads (edges + nodes + clusters)
- **Entity graph:** Subcollection under `/entities/{entityName}` for dynamic expansion

## 8D. Infrastructure Architecture
- **Hosting:** Firebase Hosting + Cloud Functions (background agent trigger)
- **AI Backend:** Google Cloud Vertex AI — Gemini Live API + Batch API
- **Storage:** Firestore (patient data), Cloud Storage (session recordings)
- **CI/CD:** GitHub Actions → Firebase Deploy
- **Monitoring:** Firebase Crashlytics + Performance Monitoring

---

## Gate Check: ✅ PASS
- All 13 new modules have locations in the codebase
- Firestore schema designed for all Digital Brain data
- 7-step background agent protocol integrated into orchestrator
- Architecture addresses all NFRs (latency, privacy, token efficiency, persistence, extensibility)
