# RISKS — AURA Speech Therapy (Handa)

| # | Risk | Likelihood | Impact | Mitigation | Status |
|---|------|-----------|--------|------------|--------|
| 1 | Patient overload — too many brain region files cause background agent token explosion | Medium | High | Memory injection compresses to 200-300 words; agent only reads changed regions | ✅ Monitored |
| 2 | Relationship graph staleness — AI acts on outdated emotional weights | Low | Medium | ±0.05 update per session; full graph rebuild weekly | ✅ Mitigated |
| 3 | File consistency — multiple sessions writing to brain files simultaneously | Low | High | Single background agent per patient; queue-based processing | ⬜ Plan needed |
| 4 | Gemini API cost — background agent running full brain analysis per session | Medium | Medium | Batch analysis; incremental diffs instead of full re-reads | ⬜ Plan needed |
| 5 | Privacy — brain files contain deeply personal family dynamics | High | Critical | All files local or encrypted; no cloud storage of raw brain data | ⬜ Plan needed |
