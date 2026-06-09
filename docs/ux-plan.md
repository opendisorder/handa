# Phase 7 — UX Planning: Handa (හඬ)

> **Project:** Handa (හඬ) — Stroke Speech Therapy Android App
> **Date:** 2026-06-09
> **Status:** COMPLETE

---

## 1. Information Architecture

```
Handa (හඬ) — App Map
═══════════════════════════════════════════════════════

SPLASH SCREEN (3s, auto-advance)
│
├── HOME SCREEN (Patient Mode)
│   ├── Greeting: "ආයුබෝවන්, සුනිල්!" (Good morning, Sunil!)
│   ├── Large "START SESSION" button (center, 80% width)
│   ├── Today's progress summary (sessions done / stars earned)
│   ├── Streak indicator (days in a row)
│   ├── "Switch to Caregiver" link (bottom-right, small)
│   └── Settings gear icon (top-right, accessible by long-press only)
│
├── SESSION FLOW
│   ├── WELCOME → Exercise name shown, "Ready?" button
│   ├── BREATHING EXERCISE (mandatory first 30 days)
│   │   ├── Animated breathing circle (4s in / 4s hold / 6s out)
│   │   ├── Audio guide in Sinhala
│   │   ├── Haptic pulses
│   │   └── Skip button (after 30s) → "I'm ready" confirmation
│   │
│   ├── PICTURE NAMING (auto-composed items)
│   │   ├── Show image (large, centered)
│   │   ├── "What is this?" text + audio prompt
│   │   ├── Mic button (hold to record, release to submit)
│   │   ├── Recording indicator (pulsing circle + waveform)
│   │   ├── Processing indicator (gentle animation, ≤5s)
│   │   ├── SCORE REVEAL
│   │   │   ├── Badge animation (Excellent/Good/Almost/Try Again)
│   │   │   ├── Feedback text in Sinhala
│   │   │   ├── Audio feedback (TTS)
│   │   │   ├── Target word shown (for "Almost" and "Try Again")
│   │   │   └── Auto-advance (4s) → next image
│   │   └── Progress bar (item 3/10)
│   │
│   ├── SHORT BREAK (after Picture Naming portion)
│   │   ├── "Great work! Take a short break."
│   │   ├── 15s timer (auto-advance)
│   │   ├── "Reset" breathing button (optional)
│   │   └── "Continue" button (skip timer)
│   │
│   ├── LIVE CONVERSATION (online only, if enabled)
│   │   ├── Exercise type intro screen
│   │   ├── "Tap to Start Speaking" button
│   │   ├── Live conversation UI
│   │   │   ├── Waveform visualization (user voice)
│   │   │   ├── Live transcription (Sinhala text)
│   │   │   ├── AI speaking indicator (when AI is talking)
│   │   │   ├── Timer (elapsed / total)
│   │   │   └── End call button
│   │   ├── Session end
│   │   └── Score summary for conversation
│   │
│   └── SESSION SUMMARY
│       ├── Overall score badge (animated)
│       ├── Items completed (X/Y)
│       ├── Stars earned (★★★☆☆)
│       ├── "Excellent work today!" message
│       ├── Share/export button
│       └── "Back to Home" button
│
├── SETTINGS (patient side, minimal)
│   ├── Font size: Default / Large / Extra Large
│   ├── Breathing exercise on/off (after 30 days)
│   └── App version info
│
└── CAREGIVER DASHBOARD (PIN-protected)
    ├── PIN ENTRY (4-digit, 5 attempts)
    ├── DASHBOARD HOME
    │   ├── Usage overview (sessions today/this week)
    │   ├── Score trend (7-day mini chart)
    │   ├── Quick stats (mastered words, streak)
    │   └── Sync status indicator
    ├── SESSIONS
    │   ├── Session history list
    │   ├── Session detail (items, scores, audio replay)
    │   └── Filters (date, type, score range)
    ├── ANALYTICS
    │   ├── Score trends (7/30/90 days)
    │   ├── Category breakdown (radar chart)
    │   ├── Mastered vs struggling words
    │   └── Language progress
    ├── CONTENT
    │   ├── Image categories (built-in)
    │   ├── Add custom photo (camera/gallery)
    │   └── Exercise management
    ├── SETTINGS
    │   ├── Session composition (mastered/practicing/new)
    │   ├── Session length
    │   ├── Language override
    │   ├── Breathing toggle
    │   ├── Haptic feedback toggle
    │   ├── Sync settings
    │   └── Export data / PDF
    └── EXPORT
        ├── PDF report generation
        ├── Date range selector
        └── Share / Save
```

---

## 2. User Flows

### Flow 1: Daily Session (Patient)

```
Home Screen
  │
  ├─[auto]─→ Greeting animation plays
  │
  ├─[tap START SESSION]─→ Session Intro Screen
  │                         │
  │                         ├─ [auto/3s] → Breathing Exercise
  │                         │                │
  │                         │                ├─ [complete] → Picture Naming
  │                         │                ├─ [skip] → Confirm → Picture Naming
  │                         │                └─ [30s timer] → Skip available
  │                         │
  │                         ├──→ Picture Naming (loop for each item)
  │                         │       │
  │                         │       ├─ Show Image (fade in)
  │                         │       ├─ "What is this?" (voice + text)
  │                         │       ├─ [hold mic] → Record (max 10s)
  │                         │       ├─ [release] → Send for evaluation
  │                         │       ├─ Processing animation (≤5s)
  │                         │       ├─ Score Reveal (animated)
  │                         │       │   ├─ Excellent → 🎉 confetti + ⭐⭐⭐
  │                         │       │   ├─ Good → 👍 bounce + ⭐⭐
  │                         │       │   ├─ Almost → 💪 wobble + ⭐
  │                         │       │   └─ Try Again → 🔄 soft fade
  │                         │       ├─ Feedback text (3s visible)
  │                         │       ├─ [auto 4s] → Next Image
  │                         │       └─ [item 10/10] → Break Screen
  │                         │
  │                         ├──→ Short Break (15s)
  │                         │       ├─ [auto] → Live Conversation intro
  │                         │       ├─ [skip] → Live Conversation intro
  │                         │       └─ [reset breathing] → Breathing
  │                         │
  │                         ├──→ Live Conversation (if online)
  │                         │       ├─ Exercise intro (3s)
  │                         │       ├─ [tap start] → Begin speaking
  │                         │       ├─ Live conversation (5 min default)
  │                         │       ├─ [tap end] / [auto 5min] → Session end
  │                         │       └─ Score summary
  │                         │
  │                         └──→ Session Summary
  │                                 ├─ Score badge
  │                                 ├─ Stars (★★★☆☆)
  │                                 ├─ Encouraging message
  │                                 └─ [tap] → Return to Home
```

### Flow 2: Caregiver Access

```
Home Screen → [tap "Caregiver" → small link bottom-right]
  │
  ├──→ PIN Entry Screen
  │       ├─ [correct PIN] → Caregiver Dashboard
  │       ├─ [wrong PIN ×5] → Lockout 30s
  │       └─ [forgot PIN] → App reinstall required (security)
  │
  └──→ Dashboard Home
          ├─ [View Sessions] → Session History → Session Detail
          ├─ [View Analytics] → Charts & Trends
          ├─ [Manage Content] → Category Browser → Add Photo
          ├─ [Export] → Date Range → PDF Preview → Share
          └─ [Settings] → Configuration Panel
```

---

## 3. Screen Inventory

| # | Screen | User | Purpose | Key Components |
|---|--------|------|---------|---------------|
| 1 | Splash | Patient | Brand intro, asset loading | Logo, app name, loading indicator (3s) |
| 2 | Home | Patient | Session start, motivation | Greeting, START button, streak, progress summary |
| 3 | Session Intro | Patient | Briefing before exercise | Exercise title, instruction text, "Ready?" button |
| 4 | Breathing | Patient | Guided breathing | Expanding circle, timer, audio guide, skip button |
| 5 | Picture Naming | Patient | Core exercise | Image, prompt text, mic button, progress bar |
| 6 | Score Reveal | Patient | Feedback after attempt | Score badge, animation, feedback text, audio feedback |
| 7 | Break | Patient | Rest between exercises | Timer, encouragement, reset breathing, continue button |
| 8 | Live Conversation | Patient | Real-time speech practice | Waveform, transcript, timer, end button |
| 9 | Live Summary | Patient | Conversation results | Score, duration, feedback, stars |
| 10 | Session Summary | Patient | End-of-session results | Overall score, items done, stars, message |
| 11 | PIN Entry | Caregiver | Secure dashboard access | Number pad (0-9), digit indicators, error message |
| 12 | Dashboard Home | Caregiver | Overview of all data | Stats cards, mini charts, quick action buttons |
| 13 | Session History | Caregiver | Browse past sessions | List with dates/scores, filters, search |
| 14 | Session Detail | Caregiver | Individual session review | Items list, scores, audio playback |
| 15 | Analytics | Caregiver | Progress visualization | Line chart, radar chart, stats cards |
| 16 | Content Browser | Caregiver | Manage image library | Category grid, add button, search |
| 17 | Add Photo | Caregiver | Upload custom image | Camera/gallery picker, name input, category select |
| 18 | Settings | Caregiver | Configure app | Toggle list, sliders, inputs |
| 19 | PDF Export | Caregiver | Generate reports | Date picker, preview, share button |
| 20 | Patient Settings | Patient | Basic preferences | Font size, breathing toggle, info |

---

## 4. Navigation Design

### Patient Mode
- **Navigation:** Single-screen sequential (wizard pattern)
- **Back:** NOT available during exercises (prevents accidental exit)
- **Exit:** Session can be paused via long-press → confirm dialog
- **Orientation:** Locked to portrait on phones, supports landscape on tablets
- **Bottom bar:** None (reduces cognitive load)
- **Top bar:** Minimal (just session progress indicator during exercises)

### Caregiver Mode
- **Navigation:** Standard bottom tab bar (5 tabs)
  - 📊 Dashboard | 📋 Sessions | 📈 Analytics | 🖼️ Content | ⚙️ Settings
- **Back:** Standard Android back button enabled
- **Orientation:** Portrait + landscape
- **Top bar:** Screen title + overflow menu

---

## 5. Component Inventory

### Core Components (Reusable)

| Component | Used On | Description |
|-----------|---------|-------------|
| `HandaButton` | All screens | Large, rounded, colored button (48dp min height) |
| `ScoreBadge` | Score Reveal, Summary | Animated level indicator with color + icon |
| `ProgressDots` | Picture Naming | Dots indicating items completed/total |
| `MicButton` | Picture Naming | Hold-to-record button with visual states |
| `BreathingCircle` | Breathing Exercise | Animated expanding/contracting SVG circle |
| `WaveformVisualizer` | Live Conversation | Real-time audio amplitude visualization |
| `StatCard` | Dashboard, Analytics | Tappable card with label + value + trend |
| `ImageCard` | Content Browser, Naming | WebP image in rounded card with optional label |
| `FeedbackToast` | Various | Gentle inline message (not intrusive snackbar) |
| `ConfettiEffect` | Excellent score | Particle celebration animation |

### Score Badge States

```
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│  ⭐⭐⭐          │  │  👍👍           │  │  💪             │  │  🔄             │
│                 │  │                 │  │                 │  │                 │
│   EXCELLENT     │  │     GOOD        │  │    ALMOST       │  │   TRY AGAIN     │
│                 │  │                 │  │                 │  │                 │
│    (92%)        │  │    (78%)        │  │    (65%)        │  │    (45%)        │
│                 │  │                 │  │                 │  │                 │
│   Teal #2A9D8F  │  │ Amber #E9C46A  │  │ Warm #F4A261   │  │ Peach #F5C5B0  │
└─────────────────┘  └─────────────────┘  └─────────────────┘  └─────────────────┘
```

---

## 6. Interaction Patterns

| Interaction | Pattern | Rationale |
|-------------|---------|-----------|
| Start session | Single tap on large button | Minimal friction |
| Record answer | Hold mic → speak → release | Familiar walkie-talkie pattern |
| View score | Automatic animation after processing | Passive receipt (no action needed) |
| Advance to next | Auto (4s after score) | Reduced cognitive load |
| Skip waiting | Tap anywhere during auto-advance countdown | Power user option |
| Pause session | Long-press on screen (3s) | Prevents accidental pause |
| Return home | Auto after session summary | No navigation decision needed |
| Access caregiver | Small text link (bottom-right) | Hidden from accidental taps |
| Enter PIN | Number pad (not keyboard) | Larger targets, no typing errors |
| Add photo | Camera/gallery sheet | Standard Android pattern |
| Export PDF | Bottom sheet with options | Grouped choices |

### Error Recovery Patterns

| Error | UX Response |
|-------|-------------|
| Mic not detected | "I can't hear you. Let's check the microphone." → settings link |
| Recording too short | "That was very quick. Try saying the word clearly." → retry |
| Network timeout | "I'm thinking... Give me a moment." → auto-retry once |
| Gemini API error | "The speech coach needs a moment. Let's try again." → retry button |
| Permission denied | Guided flow with OS settings link + Sinhala instructions |

---

## 7. Content & Tone

### Sinhala Feedback Phrases

| Score Level | Primary Phrase | Translation |
|-------------|---------------|-------------|
| **Excellent** | නියමයි! ඉතාම හොඳයි! | "Excellent! Very good!" |
| **Good** | හොඳයි! තව ටිකක් හොඳ කරමු! | "Good! Let's make it even better!" |
| **Almost** | ළඟයි! තව උත්සාහයක්! | "Close! One more try!" |
| **Try Again** | කමක් නැහැ. ආයෙ උත්සාහ කරමු! | "It's okay. Let's try again!" |
| **Session End** | අද ඉතාම හොඳට වැඩ කළා. ගොඩාක් ස්තුතියි! | "You worked very well today. Thank you so much!" |
| **Breathing Start** | ගැඹුරු හුස්මක් ගනිමු | "Let's take a deep breath" |

### Visual Tone
- **Warmth:** Off-white background (#FDF6EC) feels like paper, not a screen
- **Comfort:** Rounded corners everywhere (16-32dp)
- **Clarity:** High contrast text (#2D3436 on #FDF6EC)
- **Gentleness:** Soft shadows (not harsh drop shadows)
- **Safety:** No red colors. No alarming icons. No sudden movements.
- **Sinhala authenticity:** Hand-drawn style icons where possible, not generic emoji

---

## 8. Accessibility Design Decisions

| Decision | Rationale |
|----------|-----------|
| **28sp minimum font** | User may have vision impairment post-stroke |
| **Bold weight everywhere** | Improves legibility at large sizes |
| **1.5x line spacing** | Prevents letter crowding, aids reading |
| **No color-only indicators** | All scores have icon + text + color |
| **Touch targets ≥48dp** | Accommodates tremor or reduced motor control |
| **Hold-to-record (not tap-to-start)** | Prevents accidental recordings |
| **Auto-advance (no swipe)** | Swipe requires precision; auto-advance does not |
| **TalkBack descriptions** | Every image has alt text in Sinhala |
| **No parallax or depth effects** | Can cause dizziness in some patients |
| **Reduced motion setting** | Respects OS accessibility preference |

---

## 9. Pain Points & Mitigations

| Pain Point | Mitigation |
|------------|------------|
| **Patient fatigue** | Sessions limited to 10-15 min. Auto-breaks. |
| **Tapping difficulty** | Large targets. Hold-to-record reduces mis-taps. |
| **Understanding UI** | Voice-guided. Minimal text. Consistent layout. |
| **Network dependency** | Offline-first. Graceful degradation. Clear status. |
| **Caregiver time** | Setup under 10 min. Auto-composed sessions. |
| **Motivation over time** | Streaks, star rewards, encouraging tone. |
| **Accidental caregiver access** | Hidden link, PIN-protected, 5-attempt lockout. |
| **Audio recording privacy** | All recordings local. No cloud upload of raw audio. |
| **Session interruption** | Auto-save on every step. Resume capability. |
| **Cognitive overload** | One thing per screen. No choices during exercises. |

---

> **Gate Check:** PASS ✅ — Every UI component maps to a user task. Navigation patterns minimize cognitive load. All interaction patterns have corresponding error recovery. No component exists without a documented user need.
>
> **Next:** Phase 8 — System Architecture (frontend, backend, database, infrastructure)
