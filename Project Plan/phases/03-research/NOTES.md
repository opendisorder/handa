# Research Phase Notes — Digital Brain Integration

## Cross-Reference Analysis

### What the Digital Brain Clone ADDS (NEW)
1. **10 biological brain regions** — prefrontal_cortex, hippocampus, amygdala, broca_area, wernicke_area, motor_cortex, temporal_lobe, cerebellum, brainstem, corpus_callosum
2. **Relationship Tree with weighted graph** — JSON format with nodes, edges, clusters; SAYS/FEELS/DOES per-person profiles
3. **Entity Knowledge Graph** — topics with emotional valence (cricket=joy, money=shame)
4. **Pattern Repository** — 4 dimensions: speech, emotional, cognitive, behavioral
5. **Therapeutic State** — goals, difficulty levels, word mastery
6. **7-step Background Agent Protocol** — deterministic post-session update sequence
7. **Memory Injection Format** — structured DIGITAL BRAIN SUMMARY (200-300 words)

### What Already Exists (in current lib/)
- Session manager, background agent orchestrator
- 4 UI widgets, function call system
- MediaPipe integration, Thilina persona
- Red flag detection, prompt builder

### New Modules Identified: 13
All additive — no breaking changes to existing code.

### Integration Points: 5 existing services
- session_manager → triggers background agent
- background_agent_orchestrator → hosts 7-step protocol
- prompt_builder → injects DIGITAL BRAIN SUMMARY
- thilina_prompt → memoryBlock from injection builder
- red_flag_detector → amygdala insights feed in

### Key Design Decisions
- Store brain regions as Firestore docs (queryable), not .md files
- Relationship graph as single JSON doc (atomic reads)
- Memory injection: 200-300 words max (token ceiling)
- Weight adjustments: ±0.05 per session (prevents oscillation)
