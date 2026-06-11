# DECISIONS — AURA Speech Therapy (Handa)

> Architecture Decision Records — append-only log

| # | Date | Decision | Context | Consequences | Status |
|---|------|----------|---------|--------------|--------|
| 1 | 2026-06-10 | Digital Brain Clone: 10 brain regions as living .md files updated by background agent | Patient needs biologically-mapped cognitive clone that learns across sessions | Enables deep personalization; requires file store + update protocol + injection builder | ✅ Accepted |
| 2 | 2026-06-10 | Relationship Tree: weighted graph JSON + per-person .md files with SAYS/FEELS/DOES quadrants | Patient has complex family dynamics (son 0.95 mixed, wife strained) | Graph enables query ("what triggers shame?"); quadrants give AI strategic insight | ✅ Accepted |
| 3 | 2026-06-10 | Entity Knowledge Graph: topics with emotional valence (cricket=joy, money=shame) | Patient has specific triggers that need tracking | Enables topic-sensitive conversation routing | ✅ Accepted |
| 4 | 2026-06-10 | Background Agent: 7-step post-session update protocol | Need autonomous brain file updates without manual work | Agent reads brain → analyzes → appends → adjusts weights → generates injection | ✅ Accepted |
| 5 | 2026-06-10 | Memory Injection: 200-300 word "DIGITAL BRAIN SUMMARY" prepended to system prompt | AI needs coherent context without reading all files | Minimizes token cost while preserving full context | ✅ Accepted |
