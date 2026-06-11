# Phase 6 — Product Definition: Handa (හඬ)

> **Project:** Handa (හඬ) — Stroke Speech Therapy Android App
> **Date:** 2026-06-09
> **Status:** COMPLETE

---

## Product Identity

### App Name
**Handa** (හඬ)

| Detail | Value |
|--------|-------|
| **Word** | හඬ (haⁿda) |
| **Language** | Sinhala (සිංහල) |
| **Meaning** | Voice / Sound / Call |
| **Pronunciation** | /haⁿɖa/ — "handa" |
| **Significance** | Represents the restoration of voice after stroke — the core mission of the app |

### Tagline
> **ඔබේ හඬ නැවත සොයා ගන්න**
> *"Find your voice again"*

---

## Vision Statement

**To restore the gift of speech to every stroke survivor in Sri Lanka through AI-powered, culturally-rooted therapy that feels like a conversation, not a clinical exercise.**

---

## Mission Statement

**Handa provides personalized, compassionate speech rehabilitation for Sinhala-speaking stroke survivors by combining Gemini AI's conversational intelligence with therapeutic best practices — all in a warm, accessible, offline-capable mobile app designed specifically for elderly users.**

---

## Core Values

1. **Compassion First** — Never "wrong." Never discouraging. Every interaction builds confidence.
2. **Culturally Rooted** — Built for Sinhala (then Tamil, then English) — not a translation of a Western app.
3. **Simplicity** — Designed for a 70+ year-old who has never used a smartphone.
4. **Privacy & Dignity** — No accounts. No tracking. No monetization. Personal data stays personal.
5. **Progress, Not Perfection** — Celebrate every step forward, no matter how small.
6. **Family-Centered** — The caregiver is a co-pilot, not an afterthought.

---

## Target Audience

### Primary User
| Attribute | Detail |
|-----------|--------|
| **Patient** | Male, ~70+ years old |
| **Condition** | Post-stroke aphasia (expressive) |
| **Native language** | Sinhala |
| **Tech experience** | Minimal to none (first smartphone user) |
| **Setting** | Home environment, with caregiver assistance |
| **Device** | Shared family tablet or dedicated Android device |
| **Cognitive load** | Low — fatigues easily, needs simple interfaces |
| **Motivation** | Regain ability to communicate with family |

### Secondary User (Caregiver)
| Attribute | Detail |
|-----------|--------|
| **Relation** | Son/daughter of the patient |
| **Age** | 35-55 years old |
| **Tech experience** | Medium-high (smartphone user) |
| **Role** | Setup, monitor progress, customize therapy |
| **Concerns** | Is the therapy working? Is my father improving? |
| **Goal** | See measurable progress and share with doctors |

### Tertiary User (Speech Therapist)
| Attribute | Detail |
|-----------|--------|
| **Role** | Clinical advisor (may review reports) |
| **Need** | Objective data on patient progress |
| **Asset** | PDF reports with scores and trends |

---

## User Personas

### Persona 1: මහත්තයා — "Sir" (The Patient)

**Name:** සුනිල් (Sunil)
**Age:** 72
**Occupation:** Retired government teacher
**Location:** Colombo, Sri Lanka
**Family:** Lives with wife; son visits on weekends

**Background:**
Sunil suffered a stroke 8 months ago. He has expressive aphasia — he knows what he wants to say but struggles to find the words. His Sinhala is fluent (or was), and he's educated but has never used a smartphone. His daughter-in-law showed him how to use WhatsApp video calls, but he still struggles.

**Goals:**
- Say his grandchildren's names clearly
- Order tea at the local shop without frustration
- Participate in family conversations without anxiety

**Frustrations:**
- Speech therapy is expensive (Rs. 3000/session)
- Nearest therapist is 45 minutes away
- Western therapy apps feel foreign and overwhelming
- He feels embarrassed when he can't say simple words

**Tech Relationship:**
"I just press the green button when my son calls. All these symbols confuse me."

**What He Needs:**
- Huge buttons (not smaller than his thumb)
- Clear Sinhala text
- A gentle voice telling him what to do
- Never feeling stupid

---

### Persona 2: පුතා — "Son" (The Caregiver)

**Name:** රුවන් (Ruwan)
**Age:** 42
**Occupation:** IT manager at a Colombo bank
**Location:** Lives in Colombo, 15 min from father

**Background:**
Ruwan is technically proficient. He researched speech therapy apps extensively and found nothing for Sinhala speakers. He's the family's tech support and the one who will set up the app, add photos, and monitor progress.

**Goals:**
- Find an effective, affordable therapy solution for his father
- Track whether his father is actually improving
- Show concrete data to the family doctor
- Feel reassured that he's doing everything possible

**Frustrations:**
- No Sinhala therapy apps exist
- His father can't use complex interfaces
- He works full-time and can't supervise every session
- Current therapy is expensive and inconvenient

**Tech Relationship:**
Comfortable with technology. Uses smartphones, web dashboards, and expects clean data visualizations.

**What He Needs:**
- Quick setup (under 10 minutes)
- Dashboard with clear progress indicators
- Ability to add family photos as therapy images
- PDF reports for doctor visits

---

### Persona 3: Doctor/දොස්තර (The Speech Therapist)

**Name:** Dr. Kumari
**Age:** 38
**Specialty:** Speech-Language Pathology
**Location:** National Hospital of Sri Lanka, Colombo

**Background:**
Dr. Kumari sees 15+ aphasia patients per week. She recommends home practice but has no good tools to offer Sinhala-speaking patients. She relies on printed worksheets and verbal exercises.

**Goals:**
- Give patients effective home practice tools
- Track patient progress between sessions
- Make data-driven therapy adjustments

**Frustrations:**
- No digital tools for Sinhala aphasia therapy
- Cannot monitor patient practice between visits
- Paper-based tracking is unreliable

**What She Needs:**
- Objective session data
- Trend reports over weeks/months
- Easy-to-interpret score summaries

---

## User Journey Map

### Day 1: Onboarding

```
Setup (Caregiver)                     →      First Session (Patient)
─────────────────────────────────────────────────────────────────────────
                                          
  1. Ruwan installs app                   
  2. Sets caregiver PIN                   
  3. Reviews quick tutorial               
  4. Optionally adds family photos        
  5. Selects therapy categories           
  6. Verifies Sinhala language            
  7. Hands device to father              

                                         →  8. Sunil sees welcome screen
                                          →  9. Hears Sinhala greeting
                                          → 10. Breathing exercise (2 min)
                                          → 11. First picture appears
                                          → 12. "What is this?" voice prompt
                                          → 13. Attempts word → Gets "Good! (78%)"
                                          → 14. Sesame ball animation
                                          → 15. Completes 10 items
                                          → 16. Session summary screen
                                          → 17. "Well done today!" + star count
```

### Typical Session Flow (Week 4+)

```
Welcome Screen (3s) 
  → Breathing Exercise (2 min, optional after day 30)
  → Exercise Selection (auto-composed)
  → Picture Naming (5-6 items: 2 mastered, 2 practicing, 1-2 new)
  → Short Break (15s, optional breathing "Reset" button)
  → Live Conversation (3-5 min, 1-2 exercise types)
  → Session Summary (scores, feedback, star count)
  → Back to Home Screen
```

---

## Key Performance Indicators (KPIs)

| KPI | Target | Measurement | Why It Matters |
|-----|--------|-------------|---------------|
| **Session completion rate** | ≥80% of started sessions | Completed / started ratio | Shows engagement |
| **Average session score trend** | Upward trend over 30 days | Weekly average scores | Shows improvement |
| **Mastery rate** | ≥5 new words mastered/week | Words reaching 90% across 3 attempts | Shows learning |
| **Daily active usage** | ≥5 sessions/week | Session count per week | Ensures consistency |
| **Breathing compliance** | ≥90% first month | Breathing completed / sessions | Foundation for therapy |
| **Caregiver engagement** | Dashboard visit ≥2x/week | Dashboard access count | Shows family involvement |
| **App crash rate** | <0.5% of sessions | Crash tracking | Reliability |
| **Offline resilience** | ≥99% of sessions complete offline | Sessions without internet | Accessibility |
| **Patient satisfaction** | "Enjoyed session" ≥4/5 | End-of-session rating (emoji scale) | Emotional wellbeing |
| **Cost compliance** | ≤$20/month | Monthly API billing | Sustainability |

---

## Success Metrics

### Definition of Success (3 Months)

| Metric | Target |
|--------|--------|
| Patient can name 50 new words correctly (≥90% score) | ✅ |
| Patient completes ≥60 sessions total | ✅ |
| Average session score improves by ≥15% from month 1 to month 3 | ✅ |
| Caregiver can generate and share PDF report | ✅ |
| Zero crash-related data loss | ✅ |
| Monthly API costs ≤$20 | ✅ |

### Definition of Success (6 Months)

| Metric | Target |
|--------|--------|
| Patient masters ≥200 words across all categories | ✅ |
| Patient uses Live Conversation comfortably (≥3 exercise types) | ✅ |
| Tamil language tier unlocked (if applicable) | ✅ |
| Caregiver can demonstrate progress trends to speech therapist | ✅ |
| App store rating ≥4.0 (if published) | ✅ |

---

## Product Boundaries

### What Handa IS
- A personal speech therapy companion for stroke survivors
- AI-powered with Gemini for intelligent evaluation and conversation
- Warm, encouraging, and therapeutic in tone
- Offline-capable for reliable daily use
- Controlled by family caregivers
- Free for the user (caregiver pays cloud costs)

### What Handa IS NOT
- A replacement for professional speech therapy
- A medical diagnostic tool
- A social media or communication platform
- A game (though it uses game-like elements)
- A commercial product (no monetization, no ads)
- A multi-patient platform (single user per install)

---

## Competitive Positioning

```
                            High AI Intelligence
                                  │
                                  │
                    Handa (හඬ) ●  │
                                  │
        Low Cost ───────────────┼────────────── High Cost
                                  │
                    ┃             │             ┃
                    ┃   ConstantTherapy ●        ┃
                    ┃   TactusTherapy  ●        ┃
                    ┃             │             ┃
                    ┃             │             ┃
                            Low AI Intelligence
```

Handa occupies the **sweet spot**: high intelligence (Gemini AI) + low cost (personal project, free).

---

> **Gate Check:** PASS ✅ — Vision, mission, personas, KPIs, and success metrics all defined.
> 
> **Next:** Phase 7 — UX Planning (user flows, wireframes, interaction patterns)
