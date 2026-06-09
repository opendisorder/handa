# Phase 1: Intent Discovery — Report

## Stroke Speech Rehabilitation App ("Handa" - හඬ)

**Date:** 2026-06-09 | **Status:** ✅ Complete

---

## 1. What does the user want? (Surface Request)

A **personal Android mobile application** for **stroke speech rehabilitation** — specifically for the user's father who has **aphasia** (difficulty speaking/pronouncing words) after a brain stroke.

The app must deliver **two core therapy modes**:

### Mode 1: Picture Naming Therapy
- Show a picture (fruit, vegetable, object, family member)
- Father speaks the name aloud
- App captures speech via microphone
- AI (Gemini) evaluates pronunciation using **fuzzy similarity scoring** (not exact match)
- **Four-level graded feedback**: Excellent / Good / Almost / Try Again
- Each correct → animated encouragement + vibration + **breathing micro-break**
- Each attempt → tracked per-word for progress analytics
- Auto-advances through cards with mid-session breaks and session-end summaries

### Mode 2: Live Conversation Therapy (Gemini Live)
- **8 interactive exercises**: Category Naming, Letter Fluency, Memory Recall, Object Description, Daily Sentences, Opposites, Story Completion, Breathing + Speech
- Real-time voice conversation with Gemini acting as **AI speech therapist**
- Continuous audio streaming — Gemini listens, tracks, coaches, adapts in real time
- Tracks answers live, provides breathing breaks, generates personalized session notes

### Emotional & Physical Design Requirements
- **Breathing exercises** before sessions, after every correct answer, at mid-session, and at end
- **Haptic feedback** (different vibration patterns per outcome)
- **Animations** (green glow, checkmark bounce, confetti, breathing circle)
- **Multilingual**: Sinhala (primary) → Tamil → English with progressive unlocking
- **Large, high-contrast UI** (28sp minimum font, warm colors, no harsh red)
- **Calm, non-judgmental tone** throughout — never says "wrong"

### Secondary Features
- **Caregiver dashboard** (PIN-protected): weekly overview, word performance table, session history, PDF export for doctors
- **Adaptive difficulty system**: tracks word mastery levels, auto-composes sessions (40% mastered / 40% practicing / 20% new)
- **Offline mode**: graceful degradation when no internet — local speech recognition (Vosk), local scoring
- **Data sync**: store locally, sync when online

---

## 2. Why do they want it? (Underlying Motivation)

The user's father suffered a **brain stroke** that damaged the neural pathways between his brain and his mouth. He **knows exactly what he wants to say** but cannot articulate it properly. This creates:

- **Deep frustration** — knowing the word but unable to speak it
- **Emotional distress** — feeling trapped in his own mind
- **Loss of confidence** — avoiding conversations, withdrawing from family
- **Dependence** — relying on others for communication
- **Slowed recovery** — without daily practice, neural pathways heal slower

Clinical speech therapy is expensive, infrequent, and often inaccessible. The user wants to:

1. **Give his father daily, accessible speech therapy at home**
2. **Create a safe, calm, shame-free environment** for practice
3. **Objectively track progress** to see improvement over weeks/months
4. **Provide data to doctors** (neurologists, speech therapists) for better clinical decisions
5. **Restore his father's confidence and dignity** — the ability to communicate with family again

**The emotional core:**
> "Every interaction should leave your father feeling more capable than before it started — not less."

---

## 3. Who will use it? (Target Audience)

### Primary User — The Patient (User's Father)
| Attribute | Detail |
|-----------|--------|
| Age | Elderly (60+, likely 65-75) |
| Condition | Stroke survivor, aphasia, word retrieval difficulty |
| Native Language | **Sinhala** (Sri Lankan) |
| Secondary Languages | Tamil, English (some knowledge) |
| Tech Savviness | **Low** — needs extremely simple, large-button UI |
| Vision | May have age-related or stroke-related visual changes |
| Motor Control | May have reduced fine motor control |
| Emotional State | Frustrated, anxious about speaking, reduced confidence |
| Daily Routine | Morning practice ideal (~7:30 AM daily, ~26 min sessions) |

### Secondary User — The Caregiver (User)
| Attribute | Detail |
|-----------|--------|
| Role | Son/daughter managing father's recovery |
| Needs | Progress data, difficulty analysis, export for doctors |
| Tech Savviness | Moderate to High |
| Access | PIN-protected dashboard |

### Tertiary Users
- **Speech Therapists & Neurologists** — receive monthly PDF progress reports
- **Other Family Members** — may assist with setup or encouragement

---

## 4. What problem does it solve? (Pain Point)

| Problem | How The App Solves It |
|---------|----------------------|
| No daily speech therapy access | Available 24/7 on father's phone |
| Expensive clinic visits | Free after initial build, minimal API costs (<$20/mo) |
| Frustration from inability to speak | Gentle 4-level scoring — never says "wrong," always encourages |
| Anxiety while speaking | Mandatory breathing exercises before/during/after sessions |
| No objective recovery tracking | Per-word analytics, weekly/monthly trends, PDF export |
| Language barrier (English-only apps) | Sinhala-first UI + voice, then Tamil, then English |
| One-size-fits-all exercises | Adaptive difficulty, auto-composed sessions per skill level |
| Cognitive fatigue | Mid-session breaks, micro-breathing, fatigue detection |
| Internet dependency | Full offline mode with local speech recognition |

---

## 5. How will success be measured? (KPIs)

| KPI | Target | Measurement |
|-----|--------|-------------|
| Daily session adherence | >80% of days | Streak counter, session log |
| Speech accuracy improvement | +5% month-over-month | Accuracy trend from word database |
| Word mastery rate | 50+ words mastered in 3 months | Word status tracking (Learning → Mastered) |
| Session consistency | 15-30 min/day, 5+ days/week | Session duration + frequency logs |
| Patient streak | >7 consecutive days | Automated streak tracking |
| Error rate reduction per word | 20% fewer mistakes per word monthly | Per-word attempt/correct ratio |
| Language progression | Level 2 (Tamil unlock) within 1 month | Accuracy thresholds met for 3+ days |
| Caregiver engagement | Dashboard viewed weekly | Access logs |
| Session completion rate | >85% of started sessions completed | Session drop-off tracking |
| App crash-free rate | >99.5% | Crash reporting |
| Speech evaluation latency | <1s for Excellent, <2s for others | API response time tracking |

---

## 6. What is the business model? (Revenue, Cost, Sustainability)

**Model:** Personal/Family Project — **Not commercial**

### Estimated Monthly Costs

| Service | Usage Pattern | Est. Monthly Cost |
|---------|--------------|-------------------|
| Gemini 2.5 Flash API | Evaluate 20-40 word attempts/day | ~$2-3 |
| Gemini Live 2.5 Flash Native Audio | ~10 min/day conversation therapy | ~$5-10 |
| Google Cloud Speech-to-Text | ~2 min audio/day for picture mode | ~$2-3 |
| Google Cloud Text-to-Speech | Word playback, minimal usage | <$1 |
| **Total Estimated** | **Daily practice (~30 min/day)** | **<$20/month** |

### Sustainability Strategy
- **Flutter** → single codebase reduces maintenance
- **Local SQLite/Hive** → no cloud database costs
- **Offline-first** → reduces API calls when not needed
- **Firebase free tier** → crash reporting, analytics if desired
- **Predictable costs** → flat usage pattern, no spikes

---

## 7. What is the timeline? (Urgency, Milestones)

| Phase | Milestone | Duration | Deliverables |
|-------|-----------|----------|-------------|
| **M1** | Picture Naming — Sinhala MVP | **2-3 weeks** | 20+ cards, breathing, vibration, scoring, basic progress |
| **M2** | Multi-language Expansion | **1 week** | Tamil + English words, language unlock logic |
| **M3** | Gemini Live Conversation | **2-3 weeks** | Category Naming exercise, live audio connection |
| **M4** | All 8 Live Exercises | **2 weeks** | Remaining exercises one by one |
| **M5** | Caregiver Dashboard | **1 week** | PIN access, analytics, word table, PDF export |
| **M6** | Offline Mode + Polish | **1-2 weeks** | Vosk integration, graceful degradation, sync |
| **M7** | Testing & Deployment | **1 week** | Accessibility audit, edge cases, performance |
| **Total** | **First Working Version** | **~10-12 weeks** | Fully functional rehabilitation app |

---

## Skills Required (Throughout Phases)

This is a **Flutter + Gemini AI** mobile app. Relevant skills:

| Phase | Skill | Purpose |
|-------|-------|---------|
| 4 (Research) | `android-mobile-dev`, `cloudflare` | Android specifics, API proxying if needed |
| 7 (UX) | `ui-ux-pro-max`, `mobile-design`, `godmode-ui` | Elderly-friendly UX, animations, haptics |
| 8 (Architecture) | `senior-architect`, `android-mobile-dev` | System design, Flutter architecture |
| 9 (Device) | `mobile-design`, `android-mobile-dev` | Device constraints, accessibility |
| 13-14 (Validation) | `quality-control`, `testing-strategy`, `code-reviewer` | Code quality, test planning |
| 15 (Coding) | `full-stack-implementation-flow`, `android-mobile-dev`, `ui-ux-pro-max` | Implementation order |

---

**Intent Discovery Complete. All 7 questions answered.**
→ Proceed to Phase 2: Gap Analysis
