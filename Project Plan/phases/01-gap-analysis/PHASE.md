# Phase 2/15 — Gap Analysis

**Status:** COMPLETE ✅

## Gap Checklist

| Domain | Gap? | Status | Action |
|--------|------|--------|--------|
| Geography | Sri Lanka, Sinhala language | ✅ Covered | Gemini supports Sinhala |
| Auth method | None for MVP (single patient, manual launch) | ✅ No gap | Phase 3 adds Firebase Auth |
| Payment model | Free — therapeutic tool for father | ✅ No gap | No billing needed |
| Data storage | Firestore (cloud) + local cache (SQLite) | ✅ Covered | Architected in Phase 8 |
| Real-time vs async | Real-time via Gemini Live + background agent async | ✅ Covered | Both modes in design |
| Mobile vs desktop | Web PWA first, native Android/iOS in Phase 4 | ✅ Covered | Device analysis agrees |
| Offline support | Phase 4 target; offline exercises without AI | ✅ Accepted gap | Documented in CUT-LIST |
| Third-party integrations | Gemini Live, Firebase, MediaPipe | ✅ Covered | All wired in lib/ |
| Compliance (GDPR/HIPAA) | Not needed for single patient | ✅ Accepted gap | Phase 5 if clinical |
| Accessibility (WCAG) | Large touch targets, high contrast, voice-first | ⚠️ Partial | Needs explicit design pass |
| Performance (latency <1s) | Gemini Live target; on-device MediaPipe | ✅ Covered | Monitored |
| Security (brain data encryption) | Personal family dynamics in brain files | ⚠️ Gap | Need encryption at rest for Firestore brain docs |
| Scalability (multi-patient) | Phase 3 target | ✅ Accepted gap | Architecture supports it |
| AI/ML components | Gemini + MediaPipe + background agent (Vertex AI Batch) | ✅ Covered | All specified |

## Gaps Found (2)

1. **Accessibility design** — WCAG compliance needs explicit pass (contrast ratios, font sizes, screen reader support). Current design is voice-first but visual elements need review.
2. **Brain data encryption** — Relationship tree contains deeply personal family dynamics (son 0.95 mixed, wife strained). Must encrypt brain region docs at rest in Firestore.

**Gate:** 2 gaps found — both accepted with mitigation plans ✅
