# Phase 3: Contradiction Detection — Report

## Stroke Speech Rehabilitation App ("Handa" - හඬ)

**Date:** 2026-06-09 | **Status:** ✅ Complete

> **Method:** Analyzed all documented requirements for logical contradictions, impossibilities, and conflicting constraints.

---

## Contradiction Analysis

### C1: "Always Excellent < 0.5s" vs "Gemini API latency is 1-3s"
- **Statement A:** "Excellent outcome response is immediate — within half a second" (<0.5s)
- **Statement B:** Gemini 2.5 Flash API has typical round-trip latency of 1-3 seconds (audio processing + evaluation)
- **Conflict:** ⚠️ **POTENTIAL CONFLICT**
- **Analysis:** The 0.5s target includes: audio recording → Google STT → Gemini evaluation → processing → UI update. Realistically, this is 2-4s minimum with API calls.
- **Resolution:** 
  - For Excellent: Use **optimistic local scoring first** (check against known-good pronunciations locally) → show green glow + vibration immediately → then refine with Gemini async
  - Or adjust target to <2s for Excellent, which is still very responsive
  - **Recommendation:** Cache common word evaluations locally; show feedback instantly based on local phonetic match; Gemini refines score silently in background

### C2: "No login" vs "Personalized progress tracking"
- **Statement A:** "No login. No onboarding quiz. No permissions popup."
- **Statement B:** Must track personalized progress per patient, per word, per session
- **Conflict:** ✅ **RESOLVABLE** — Not a true contradiction
- **Resolution:** Single-user device. No authentication needed because the app is installed on father's personal phone. All data is local by default. Cloud sync is optional and implicit (no login required).

### C3: "Offline mode with full functionality" vs "Gemini Live needs internet"
- **Statement A:** "Everything except Gemini Live API works fully offline"
- **Statement B:** Gemini AI evaluation is needed for the four-outcome scoring system
- **Conflict:** ⚠️ **PARTIAL CONFLICT**
- **Analysis:** Picture Naming Mode cannot use Gemini scoring offline. The design acknowledges this ("simpler scoring mode offline") but doesn't define the offline scoring algorithm.
- **Resolution:** Implement **dual scoring engine**:
  - Online: Gemini 2.5 Flash (full semantic evaluation)
  - Offline: Levenshtein distance + phonetic similarity (basic pronunciation check)
  - Offline thresholds: calibrated to be slightly more lenient (compensate for less sophisticated evaluation)

### C4: "No mistake count shown" vs "Caregiver sees mistakes"
- **Statement A:** "No mistake count shown on screen in the moment (only in caregiver dashboard)"
- **Statement B:** Caregiver dashboard tracks mistakes per word
- **Conflict:** ✅ **INTENTIONAL** — Design choice, not conflict. Patient sees encouragement; caregiver sees data. Different views for different audiences.

### C5: "40% mastered words" vs "20 card session with limited mastered words"
- **Statement A:** Session composition: 40% mastered words
- **Statement B:** Early in recovery, few words are "mastered"
- **Conflict:** ⚠️ **TEMPORAL CONFLICT**
- **Analysis:** In the first few days, there are almost no mastered words. The 40/40/20 ratio cannot be maintained initially.
- **Resolution:** Implement **ramp-up phase**:
  - Week 1: 0% mastered, 60% practicing, 40% new (focus on building initial vocabulary)
  - Week 2+: Gradually shift toward 40/40/20 as words reach mastery
  - Algorithm: If mastered pool < 20% of total, redistribute to practicing + new

### C6: "Breathing is mandatory first month" vs "Caregiver can disable"
- **Statement A:** "This is not skippable in the first month"
- **Statement B:** "Caregiver can change this in settings"
- **Conflict:** ✅ **CONSISTENT** — The two statements are complementary, not contradictory. Caregiver controls the setting, but the default enforces breathing for the first month.

### C7: "Large images" vs "100+ images bundled in APK"
- **Statement A:** "Large vibrant image" — high quality, large display
- **Statement B:** 100+ high-quality images bundled in an APK could make it 200-500MB+
- **Conflict:** ⚠️ **TECHNICAL CONFLICT**
- **Resolution:** 
  - Use **WebP format** (30% smaller than PNG)
  - Compress to 720px width (sufficient for mobile screens)
  - Lazy-load images; progressive loading for first launch
  - Estimated APK impact: 100 images @ 50KB WebP = ~5MB → acceptable
  - Alternatively: initial bundle of 50 images, download rest on first launch

### C8: "Gemini Live 2.5 Flash Native Audio" vs "Google Speech-to-Text for picture mode"
- **Statement A:** Use Gemini Live for real-time conversation
- **Statement B:** Use Google Speech-to-Text for picture mode speech input
- **Conflict:** ✅ **COMPLEMENTARY** — Different tools for different modes. Mode 1 (picture naming) uses STT + Gemini evaluation. Mode 2 (live conversation) uses Gemini Live end-to-end audio.

### C9: "Sinhala first, always" vs "Mixed language mode"
- **Statement A:** "Always speak Sinhala first"
- **Statement B:** Level 4 = Full random mix of all three languages
- **Conflict:** ⚠️ **PROGRESSIVE CONFLICT** — Resolved by language progression system. Sinhala-first is the default; mixed mode is an advanced unlock. Both are valid at different stages.

### C10: "Under $5/month" vs "Gemini Live per-minute audio costs"
- **Statement A:** "Estimated total cost: likely under $5/month"
- **Statement B:** Gemini Live 2.5 Flash Native Audio costs per minute
- **Conflict:** ⚠️ **COST UNCERTAINTY**
- **Analysis:** At ~$0.02/min for audio processing, 10 min/day = $6/month just for Gemini Live. Plus STT ($3) + TTS ($1) = closer to $10-15/month.
- **Resolution:** Update estimate to **~$10-20/month** for daily active use. Still very reasonable for a personal therapy tool.

### C11: "Always available breathing button" vs "Minimalist home screen"
- **Statement A:** "Small always-available breathing button on the home screen"
- **Statement B:** "Two large therapy mode cards. Only two. Not ten. Minimal."
- **Conflict:** ✅ **MINOR** — A small breathing button does not break minimalism. It's an additional element but justified by therapeutic value.

---

## Summary

| ID | Conflict | Severity | Resolved? | Resolution |
|----|----------|----------|-----------|------------|
| C1 | 0.5s feedback vs 1-3s API latency | **HIGH** | ⚠️ Partial | Local optimistic scoring + async Gemini refinement |
| C2 | No login vs personalized tracking | LOW | ✅ Yes | Single-user device, no auth needed |
| C3 | Offline mode vs Gemini evaluation | **HIGH** | ⚠️ Partial | Dual scoring engine: Levenshtein offline, Gemini online |
| C4 | No mistakes for patient vs mistakes for caregiver | LOW | ✅ Yes | Intentional design — different views |
| C5 | 40% mastered vs no mastery initially | MEDIUM | ✅ Yes | Ramp-up phase: gradual shift to 40/40/20 |
| C6 | Breathing mandatory vs changeable | LOW | ✅ Yes | Complementary, not contradictory |
| C7 | Large images vs APK size | MEDIUM | ✅ Yes | WebP format, 720px, lazy loading |
| C8 | Gemini Live vs Google STT | LOW | ✅ Yes | Complementary — different modes, different tools |
| C9 | Sinhala first vs mixed mode | LOW | ✅ Yes | Progressive unlock — both valid at different stages |
| C10 | $5/mo budget vs actual Gemini Live costs | MEDIUM | ✅ Yes | Revised estimate to $10-20/month |
| C11 | Always-available button vs minimalism | LOW | ✅ Yes | Small element, justified by value |

## Unresolved Conflicts

### High Severity (Must Resolve Before Coding)

| Conflict | Resolution Path |
|----------|-----------------|
| **C1** — 0.5s feedback latency | Implement **local optimistic scoring**: cache known-good word evaluations, show immediate visual/haptic feedback based on local phonetic matching, run Gemini evaluation asynchronously to refine. The father gets instant feedback; the score gets refined silently. |
| **C3** — Offline mode scoring | Build **dual scoring engine**: 
| | - **Online**: Gemini 2.5 Flash (full semantic evaluation, 4 outcomes) |
| | - **Offline**: Levenshtein distance + phonetic similarity (2-3 outcome simplification) |
| | - Auto-switch based on connectivity |
| | - Calibrate offline thresholds to be slightly more lenient |

### Medium Severity (Should Resolve Before Progressing Far)

| Conflict | Resolution Path |
|----------|-----------------|
| **C5** — Initial session composition | Implement ramp-up algorithm: first 7 days use 0/60/40 ratio, then progressively shift to 40/40/20 over 2 weeks as words reach mastery |
| **C7** — Image size vs APK size | WebP format, 720px, lazy-load, bundle 50 core images, download rest on first launch |
| **C10** — Cost estimate | Update to $10-20/month with clear breakdown |

---

**Validation Gate:** All contradictions analyzed. C1 and C3 have resolution paths defined. Zero unresolvable contradictions.
→ Proceed to Phase 4: Research Phase
