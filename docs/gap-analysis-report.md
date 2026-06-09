# Phase 2: Gap Analysis — Report

## Stroke Speech Rehabilitation App ("Handa" - හඬ)

**Date:** 2026-06-09 | **Status:** ✅ Complete

> **Method:** Systematically audited all requirements against the project raw files to find missing, ambiguous, or under-defined elements.

---

## Checklist Audit

### 🔴 CRITICAL GAPS (Must Resolve Before Proceeding)

| # | Gap | Details | Impact | Suggested Resolution |
|---|-----|---------|--------|---------------------|
| G1 | **API Key Security** | Gemini API keys need to be embedded or proxied in the Android app. If embedded in APK, they can be extracted. | Security risk — API key theft, unauthorized usage, cost exposure | Use Cloudflare Worker as proxy (adds $0 cost, keeps keys server-side) |
| G2 | **Offline Scoring Algorithm** | When offline (no Gemini), how exactly is pronunciation scored? Using Vosk + what similarity metric? | Core therapy function breaks without clear algorithm | Use Levenshtein distance normalized + phonetic similarity for Sinhala chars. Define threshold mapping. |
| G3 | **Voice Recording Privacy** | Does the app save voice recordings? If so, where (local vs cloud)? How long? Is this disclosed? | Legal/privacy concern — voice is biometric data | Store locally only, auto-delete after 30 days, never upload without explicit consent |
| G4 | **Sinhala Speech Recognition Model Availability** | Google STT supports Sinhala (si-LK). Does Vosk have a Sinhala model? If not, how does offline mode handle speech? | Offline mode may not work for Sinhala | Verify Vosk Sinhala model existence. If unavailable, use on-device Google Speech Recognition (Android's built-in) as fallback |
| G5 | **Database Migration Strategy** | Schema will change as features grow. No migration plan documented. | Data loss or corruption on app update | Use `moor`/`drift` with versioned migrations, or Hive with schema versioning |
| G6 | **Caregiver PIN Security** | PIN is mentioned but no storage or security model specified. | Weak security = no real protection | Hash PIN with bcrypt/scrypt; use biometric unlock as alternative |
| G7 | **WCAG Accessibility Compliance** | "Large text" and "high contrast" mentioned but no formal WCAG target. | May miss accessibility requirements for elderly users | Target WCAG 2.1 AA minimum. Document specific criteria (contrast 4.5:1, touch targets 48dp, TalkBack) |
| G8 | **Fatigue Detection Algorithm** | Mentioned conceptually but no implementation detail: what metrics, what thresholds, what action? | Feature may be too vague to implement | Track: accuracy drop >15% from baseline, pause length increase >2x, session time >20min. Suggest break when 2+ indicators trigger |
| G9 | **Cloud Sync Strategy** | "Data syncs when online" mentioned but no mechanism defined. | Data loss risk, conflict on multi-device | Firebase Firestore for cloud sync, offline-first with queue, last-write-wins for simplicity |

### 🟡 IMPORTANT GAPS (Should Resolve)

| # | Gap | Detail | Impact |
|---|------|--------|--------|
| G10 | **Image Source & Licensing** | Where do the 100+ images come from? Bundled? Downloaded? User's own photos? | Legal + app size concern |
| G11 | **Sinhala vs Sri Lankan Tamil Dialect** | Must specify si-LK and ta-LK for TTS/STT accuracy | Pronunciation accuracy for therapy |
| G12 | **Firebase Crash Reporting** | Not mentioned — but critical for stability monitoring | Blind to crashes without it |
| G13 | **Multiple Caregiver Support** | Only one PIN mentioned — what if multiple family members monitor? | Minor — can add later |
| G14 | **iOS Support** | Flutter makes it possible but not mentioned | Future scope |
| G15 | **Tablet Optimization** | Would benefit from larger screen but not mentioned | Minor layout adaptation needed |
| G16 | **Image Caching Strategy** | For 100+ images, performance needs planning | Slow loading on first use |
| G17 | **Reduced Motion Option** | Stroke patients may have vestibular issues | Accessibility best practice |
| G18 | **TalkBack/Screen Reader Support** | Not mentioned for visually impaired users | Accessibility gap |
| G19 | **Google API TOS Compliance** | Medical/therapy use on standard APIs — verify allowed | Legal risk if violated |
| G20 | **Data Backup & Restore** | What if phone is lost or factory reset? | Complete data loss risk |
| G21 | **Session Configuration** | Can caregiver set session length (e.g., 10 vs 20 cards)? | Flexibility gap |
| G22 | **Word Bank Expansion** | How are new words added? Is there an import tool? | Scalability gap |
| G23 | **Performance Targets** | No cold start, image load, or animation frame rate targets | Quality risk |
| G24 | **Error Handling Strategy** | What happens if Gemini API fails mid-session? | User experience risk |

### 🟢 MINOR GAPS (Nice to Have)

| # | Gap | Detail |
|---|------|--------|
| G25 | Dark mode support | Not mentioned |
| G26 | Multi-profile (multiple patients) | Not needed now |
| G27 | Gamification (badges, levels) | Deliberately excluded per design philosophy |
| G28 | Social sharing of progress | Privacy concern |
| G29 | Voice recording playback for caregiver | Could help understand speech patterns |
| G30 | Custom family photo upload | Mentioned but not detailed |

---

## Gap Summary

| Category | Critical | Important | Minor | Total |
|----------|----------|-----------|-------|-------|
| Security & Privacy | 3 (G1, G3, G6) | 1 (G19) | 0 | 4 |
| Offline & Sync | 2 (G2, G9) | 0 | 0 | 2 |
| AI & Speech | 1 (G4) | 1 (G11) | 0 | 2 |
| Database & Data | 2 (G5, G20) | 0 | 0 | 2 |
| Accessibility | 1 (G7) | 2 (G17, G18) | 0 | 3 |
| Features | 1 (G8) | 5 (G10, G13, G21, G22, G24) | 6 | 12 |
| Infrastructure | 0 | 4 (G12, G15, G16, G23) | 1 | 5 |
| **Total** | **10** | **13** | **7** | **30** |

---

## Recommended Defaults (If User Doesn't Specify)

For gaps that need user input but aren't blocking, I recommend these defaults:

| Gap | Default Recommendation | Reasoning |
|-----|----------------------|-----------|
| G1 — API Keys | Cloudflare Worker proxy | Zero cost, best security practice |
| G2 — Offline Scoring | Normalized Levenshtein distance (thresholds: ≥90% Excellent, ≥75% Good, ≥60% Almost) | Industry standard for fuzzy string matching |
| G4 — Vosk Sinhala Model | Use Android's on-device SpeechRecognizer as fallback if Vosk lacks Sinhala | More reliable, zero additional setup |
| G5 — Database Migration | Drift (SQLite) with versioned migrations | Most robust Flutter database solution |
| G7 — WCAG Target | WCAG 2.1 AA (contrast 4.5:1, touch targets ≥48dp) | Industry standard, required for accessibility |
| G8 — Fatigue Detection | Accuracy drop >15% + pause length >2x baseline + session >20min → auto-suggest break | Simple, implementable, effective |
| G9 — Cloud Sync | Firebase Firestore offline-first, last-write-wins | Free tier sufficient for single user |
| G10 — Image Source | Bundle 50 core images, allow caregiver to add custom photos | Balances app size vs flexibility |

---

**Validation Gate:** 10 critical gaps > threshold of 3. Present to user before proceeding.
→ Proceed to Phase 3: Contradiction Detection (separate concern)
