# Phase 13 — Progress Tracker: Handa (හඬ)

> **Project:** Handa (හඬ) — Stroke Speech Therapy Android App
> **Date:** 2026-06-09
> **Status:** LIVE (updated every phase)

---

## Overall Progress

| Phase | Status | Progress | Artifact |
|-------|--------|----------|----------|
| 1 — Intent Discovery | ✅ COMPLETE | 100% | `docs/intent-report.md` |
| 2 — Gap Analysis | ✅ COMPLETE | 100% | `docs/gap-analysis-report.md` |
| 3 — Contradiction Detection | ✅ COMPLETE | 100% | `docs/conflict-report.md` |
| 4 — Research | ✅ COMPLETE | 100% | `docs/research-report.md` |
| 5 — Requirements | ✅ COMPLETE | 100% | `docs/requirements-document.md` |
| 6 — Product Definition | ✅ COMPLETE | 100% | `docs/product-definition.md` |
| 7 — UX Planning | ✅ COMPLETE | 100% | `docs/ux-plan.md` |
| 8 — Architecture | ✅ COMPLETE | 100% | `docs/architecture-document.md` |
| 9 — Device Analysis | ✅ COMPLETE | 100% | `docs/device-analysis.md` |
| 10 — Dependency Mapping | ✅ COMPLETE | 100% | `docs/dependency-map.md` |
| 11 — Priority Matrix | ✅ COMPLETE | 100% | `docs/priority-matrix.md` |
| 12 — Implementation Roadmap | ✅ COMPLETE | 100% | `docs/implementation-roadmap.md` |
| 13 — Progress Tracker | 🔵 LIVE | 100% | `docs/progress-tracker.md` |
| 14 — Validation Gate | ⏳ PENDING | 0% | — |
| 15 — Coding Order | ⏳ PENDING | 0% | — |

**Overall completion: 13/15 phases (86.7%)**

---

## Completed Phases

### Phase 1 — Intent Discovery
- Asked and answered all 7 intent questions
- Identified core need: Sinhala stroke speech therapy for user's father
- Key constraint: No login, no monetization, <$20/month, offline-first

### Phase 2 — Gap Analysis
- Identified 30 gaps across 10 categories
- 10 critical gaps resolved (Sinhala TTS, streaming STT, image licensing, etc.)
- Key finding: Vosk has no Sinhala model — need custom training or Google STT

### Phase 3 — Contradiction Detection
- Found 11 conflicts, resolved 10, 1 ongoing (offline Vosk STT viability)
- Key resolution: Hybrid online/offline strategy (Google STT when online, custom Vosk when offline)

### Phase 4 — Research
- Researched: Gemini APIs, STT options, TTS options, databases, Cloudflare Workers, audio streaming
- Key findings: Gemini 2.5 Flash ($0.30/1M input), Live API ($0.005/min input, $0.018/min output)
- Piper TTS has Sinhala model (UNICEF, ONNX, offline)
- Drift (SQLite) best for relational therapy data
- Firestore free tier sufficient (50K reads/day)

### Phase 5 — Requirements
- 18 functional requirements with acceptance criteria
- 10 non-functional requirements with measurable targets
- MVP defined: 10 Must-Haves, 4 Should-Haves, 6 Could-Haves
- Critical: 28sp minimum font, warm color palette, no red colors

### Phase 6 — Product Definition
- Name: Handa (හඬ) — "Voice" in Sinhala
- 3 user personas: Sunil (patient, 72), Ruwan (caregiver, 42), Dr. Kumari (therapist, 38)
- 10 KPIs defined with measurable targets
- Success metrics at 3 months and 6 months

### Phase 7 — UX Planning
- Complete information architecture (app map)
- 4 user flows defined (daily session, caregiver access, onboarding, typical week)
- 20 screens inventoried with key components
- Interaction patterns for all user actions with error recovery
- Sinhala feedback phrases for all 4 score levels
- 10 accessibility design decisions

### Phase 8 — Architecture
- Clean Architecture: data → domain → presentation layers
- Drift schema: 6 tables (categories, exercises, sessions, attempts, live_conversations, settings)
- Cloudflare Worker proxy for Gemini API key
- Firebase AI Logic for Live Conversation (WebSocket)
- Scoring engine: Levenshtein (offline) + Gemini (online)
- 10 Architecture Decision Records documented

### Phase 9 — Device Analysis
- Primary target: Android tablet (7-12")
- Minimum: Android 8.0 (API 26), 3GB RAM
- Screen size adaptation strategy with breakpoints (sw600dp)
- Device tier detection (low/mid/high) for animation complexity
- All Android permissions documented

### Phase 10 — Dependency Mapping
- 5-phase dependency tree (Foundation → Core → Advanced → Caregiver → Polish)
- Foundation is entirely sequential (no parallelization)
- No circular dependencies
- 5 dependency rules defined

### Phase 11 — Priority Matrix
- 17 Must Have (37%) ✅ under 40% threshold
- 8 Should Have (17%)
- 12 Could Have (26%)
- 9 Won't Have (20%)
- Total effort: 65 days for active items

### Phase 12 — Implementation Roadmap
- 5 milestones over 9 weeks
- M1: Foundation (2 wk) → M2: Core Therapy (2 wk) → M3: Live Conversation (2 wk) → M4: Caregiver (2 wk) → M5: Polish (1 wk)
- Risk-adjusted with 2-week contingency buffer
- Each milestone has validation gates

---

## Current Status

**Current Phase:** Phase 13 — Progress Tracker (just written)
**Next Phase:** Phase 14 — Validation Gate
**Blockers:** None
**Decisions Made in Last Session:**
- Naming: Handa (හඬ) confirmed
- Architecture: Clean Architecture + Drift + Riverpod
- Audio: twin_stream for capture, Piper for offline TTS
- Scoring: Levenshtein + Gemini dual engine
- Cloud: Firestore for sync, Cloudflare Worker for API proxy

---

## Key Metrics

| Metric | Value |
|--------|-------|
| Total phases completed | 13/15 |
| Documents written | 13 |
| Total pages of planning | ~120+ |
| User stories documented | 18 FRs |
| Non-functional requirements | 10 |
| Database tables | 6 |
| Components designed | 20+ |
| Personas created | 3 |
| MVP Must-Haves | 17 |
| Estimated build time | 9 weeks |
| Estimated monthly cost | $5-22 |

---

## Next Actions

| Action | Owner | Due | Status |
|--------|-------|-----|--------|
| Write Phase 14 — Validation Gate | Planning Engine | Now | ⏳ |
| Write Phase 15 — Coding Order | Planning Engine | After Phase 14 | ⏳ |
| Begin M1 implementation | Developer | After Phase 15 | ⏳ |
| Install Flutter + dependencies | Developer | Week 1 | ⏳ |
| Build Drift schema | Developer | Week 1-2 | ⏳ |
| Source 100+ WebP images | Developer | Week 1-2 | ⏳ |

---

## Blockers & Risks

| Blocker | Impact | Status | Mitigation |
|---------|--------|--------|------------|
| None currently | — | ✅ Clear | — |

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Gemini Live API cost higher than estimated | Medium | $10-20/mo | Use text-only fallback or limit session duration |
| Sinhala TTS quality (Piper) | Medium | User experience | Pre-recorded audio fallback |
| Android haptic variation across devices | Low | UX inconsistency | Use only platform HapticFeedback API |
| Time availability for build | Medium | Schedule slip | 2-week contingency buffer built in |

---

## Changelog (Recent)

| Date | Phase | Change |
|------|-------|--------|
| 2026-06-09 | 1 | Intent Discovery complete |
| 2026-06-09 | 2 | Gap Analysis complete — 30 gaps |
| 2026-06-09 | 3 | Contradiction Detection complete — 11 conflicts |
| 2026-06-09 | 4 | Research complete — Gemini, STT, TTS, DB, Workers |
| 2026-06-09 | 5 | Requirements documented — 18 FRs, 10 NFRs |
| 2026-06-09 | 6 | Product Definition complete — Handa branded |
| 2026-06-09 | 7 | UX Planning complete — 20 screens, 4 flows |
| 2026-06-09 | 8 | Architecture complete — 10 ADRs, full DB schema |
| 2026-06-09 | 9 | Device Analysis complete — Android tablet focus |
| 2026-06-09 | 10 | Dependency Map complete — 5 phases, no cycles |
| 2026-06-09 | 11 | Priority Matrix complete — 37% Must Have |
| 2026-06-09 | 12 | Implementation Roadmap complete — 9 weeks |
| 2026-06-09 | 13 | Progress Tracker created — 86.7% done |
| 2026-06-09 | 14 | **NEXT** — Validation Gate |
| 2026-06-09 | 15 | **NEXT** — Coding Order |
