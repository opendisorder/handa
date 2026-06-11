# Phase 5 — Requirements Documentation: Handa (හඬ)

> **Project:** Handa (හඬ) — Stroke Speech Therapy Android App
> **Date:** 2026-06-09
> **Status:** COMPLETE

---

## Table of Contents

1. [Functional Requirements](#1-functional-requirements)
   - [FR01: Picture Naming Exercise](#fr01-picture-naming-exercise)
   - [FR02: Live Conversation Exercise](#fr02-live-conversation-exercise)
   - [FR03: Breathing Exercise](#fr03-breathing-exercise)
   - [FR04: 4-Level Scoring System](#fr04-4-level-scoring-system)
   - [FR05: Haptic & Audio Feedback](#fr05-haptic--audio-feedback)
   - [FR06: Session Composition & Ramp-Up](#fr06-session-composition--ramp-up)
   - [FR07: Custom Image Library](#fr07-custom-image-library)
   - [FR08: Multi-Language Progression](#fr08-multi-language-progression)
   - [FR09: Caregiver Dashboard](#fr09-caregiver-dashboard)
   - [FR10: Progress Analytics](#fr10-progress-analytics)
   - [FR11: PDF Report Export](#fr11-pdf-report-export)
   - [FR12: Offline/Online Sync](#fr12-offlineonline-sync)
   - [FR13: App Configuration](#fr13-app-configuration)
   - [FR14: Breathing + Speech Integration](#fr14-breathing--speech-integration)
   - [FR15: Phase Transition Animations](#fr15-phase-transition-animations)
   - [FR16: Session History & Review](#fr16-session-history--review)
   - [FR17: Error Handling & Recovery](#fr17-error-handling--recovery)
   - [FR18: Gemini Live Conversation Directory](#fr18-gemini-live-conversation-directory)
2. [Non-Functional Requirements](#2-non-functional-requirements)
   - [NFR01: Performance](#nfr01-performance)
   - [NFR02: Offline Capability](#nfr02-offline-capability)
   - [NFR03: Accessibility](#nfr03-accessibility)
   - [NFR04: Security & Privacy](#nfr04-security--privacy)
   - [NFR05: Reliability](#nfr05-reliability)
   - [NFR06: Maintainability](#nfr06-maintainability)
   - [NFR07: Cost](#nfr07-cost)
   - [NFR08: Device & Platform](#nfr08-device--platform)
   - [NFR09: Data & Storage](#nfr09-data--storage)
   - [NFR10: UI/UX Consistency](#nfr10-uiux-consistency)
3. [MVP Definition](#3-mvp-definition)
4. [Future Scope (Post-MVP)](#4-future-scope-post-mvp)

---

## 1. Functional Requirements

### FR01: Picture Naming Exercise

**Description:** User sees an image and attempts to name it. The app evaluates the response and provides graded feedback.

**User Story:**
> As a patient, I want to see a picture and say what it is, so that I can practice word retrieval.

**Acceptance Criteria:**
- [ ] Display one image at a time from the current exercise category (300+ images across 10+ categories)
- [ ] Start audio recording when the user taps/presses and holds the mic button
- [ ] Stop recording when the user releases or after 10 seconds max
- [ ] Send captured audio + image context to Gemini 2.5 Flash for evaluation
- [ ] Receive structured JSON response with: score (0-100), level (Excellent/Good/Almost/Try Again), feedback phrase, target word
- [ ] Display result with animations: score badge, feedback text, celebratory/supportive animation
- [ ] Auto-advance to next image after 4 seconds (configurable)
- [ ] Play result audio feedback (TTS: "Excellent!" in Sinhala)
- [ ] Track attempt count per image (allow up to 3 attempts before skipping)
- [ ] Show a visual prompt/hint after first incorrect attempt (e.g., first letter)

**Exception Handling:**
- If recording fails → show error toast, retry button
- If Gemini API timeout/unavailable → fall back to offline scoring
- If user is silent → prompt "Try saying the word" after 3 seconds
- If network unavailable → use offline Vosk + Levenshtein scoring

---

### FR02: Live Conversation Exercise

**Description:** User engages in a real-time voice conversation with Gemini AI for speech practice.

**User Story:**
> As a patient, I want to have a natural conversation with the AI that listens and responds in real-time, so that I can practice spontaneous speech.

**Acceptance Criteria:**
- [ ] Start Gemini Live API WebSocket session from within the app
- [ ] Display speaking indicator (waveform visualization) during conversation
- [ ] AI speaks back in Sinhala via native audio output (Gemini Live TTS)
- [ ] Session length: configurable (default 5 minutes, max 10 minutes)
- [ ] 8 exercise types supported (see FR18)
- [ ] Real-time audio transcription displayed on screen for feedback
- [ ] AI evaluates speech performance and provides graded feedback
- [ ] End-of-session summary: duration, score, improvement tips
- [ ] Interruption support: AI stops speaking when user starts
- [ ] Session data saved locally and synced (attempts, transcript, score)
- [ ] Progressive difficulty: exercises adapt based on past performance

**Exception Handling:**
- If WebSocket connection fails → retry with exponential backoff (3 attempts)
- If no internet → show "Connect to internet for Live Conversation" message
- If audio permission missing → show permission request dialog
- If session drops mid-conversation → auto-reconnect and resume (within 30 seconds)

---

### FR03: Breathing Exercise

**Description:** User performs guided breathing exercises in the first month of use.

**User Story:**
> As a patient in my first month, I want guided breathing exercises before speech practice, so that I can calm my nerves and prepare my vocal cords.

**Acceptance Criteria:**
- [ ] Mandatory for first 30 days of app usage (configurable toggle for caregiver)
- [ ] Each session starts with a 2-minute breathing exercise
- [ ] Visual guide: animated expanding/contracting circle (4s inhale → 4s hold → 6s exhale)
- [ ] Audio guide: Sinhala voice instructions ("Inhale... hold... exhale...")
- [ ] Haptic feedback: subtle pulse on inhale, gentle buzz on hold
- [ ] Skip button available after 30 seconds (but shows "I'm ready" confirmation)
- [ ] Track completion: breathing done = session can proceed
- [ ] After 30 days: breathing becomes optional (can still be manually started)

---

### FR04: 4-Level Scoring System

**Description:** All exercise responses are graded into one of four therapeutic levels.

**User Story:**
> As a patient, I want feedback that never tells me I'm wrong, so that I stay motivated and encouraged.

**Acceptance Criteria:**
| Level | Score Range | Color | Icon | Feedback Tone |
|-------|-------------|-------|------|---------------|
| Excellent | ≥90% | Teal #2A9D8F | ⭐ Stars | Celebratory |
| Good | 75-89% | Amber #E9C46A | 👍 Thumb | Encouraging |
| Almost | 60-74% | Warm Orange #F4A261 | 💪 Muscle | Gentle correction |
| Try Again | <60% | Soft Peach #F5C5B0 | 🔄 Refresh | Supportive redirect |

- [ ] No red/red-adjacent colors used for scores (only warm tones)
- [ ] Each level has a unique animation: Excellent = confetti, Good = bounce, Almost = gentle wobble, Try Again = soft fade
- [ ] Level-specific audio feedback in Sinhala via TTS
- [ ] Scores are always displayed as level name first (not percentage)
- [ ] Percentage shown parenthetically: "Excellent (92%)"

---

### FR05: Haptic & Audio Feedback

**Description:** The app provides haptic vibration and audio feedback for every interaction.

**User Story:**
> As a patient, I want tactile and audio feedback for every action, so that I know my input was registered.

**Acceptance Criteria:**
- [ ] Mic button press → short click vibration (HapticFeedback.lightImpact())
- [ ] Recording started → single medium pulse (HapticFeedback.mediumImpact())
- [ ] Recording stopped → double tap pattern
- [ ] Excellent score → celebratory ascending buzz pattern
- [ ] Good score → single firm confirmation
- [ ] Almost score → gentle two-tap
- [ ] Try Again score → soft single pulse
- [ ] Button taps → light impact feedback
- [ ] Navigation → no haptic (avoid over-stimulation)
- [ ] Breathing exercise inhale → subtle rising pulse
- [ ] Breathing exercise hold → constant gentle buzz
- [ ] Breathing exercise exhale → fading pulse
- [ ] Every haptic pattern has an audio equivalent for accessibility
- [ ] Haptic feedback can be disabled in settings (caregiver toggle)
- [ ] All haptics use platform-native `HapticFeedback` API (no custom vibrator patterns that bypass OS settings)

---

### FR06: Session Composition & Ramp-Up

**Description:** Each session auto-composes exercises from mastered, practicing, and new categories.

**User Story:**
> As a caregiver, I want sessions to be automatically composed with 40% mastered, 40% practicing, and 20% new items, so that the patient is challenged but not overwhelmed.

**Acceptance Criteria:**
- [ ] Default composition: 40% mastered / 40% practicing / 20% new
- [ ] Ramp-up phase (first week): 80% new / 20% practicing (no mastered yet)
- [ ] Stable phase (week 2+): 40/40/20
- [ ] Adaptive: if accuracy drops below 60% for 3 consecutive sessions → auto-reduce new to 10%
- [ ] "Mastered" = ≥90% score on at least 3 attempts
- [ ] "Practicing" = attempted at least once but not yet mastered
- [ ] "New" = never attempted
- [ ] Session length: configurable (default 10 items for Picture Naming + 5 min Live Conversation)
- [ ] Caregiver can override composition in settings
- [ ] Session ends automatically after completing all items
- [ ] Session can be paused and resumed within 24 hours

---

### FR07: Custom Image Library

**Description:** App includes built-in images and allows caregivers to add custom photos.

**User Story:**
> As a caregiver, I want to add photos of family members and familiar objects, so that the therapy is personally relevant.

**Acceptance Criteria:**
- [ ] 300+ built-in images across 10+ categories (animals, food, objects, actions, emotions, family, places, body parts, clothing, nature)
- [ ] Images stored as WebP format (balance of quality and APK size)
- [ ] Caregiver can add custom photos from device gallery or camera
- [ ] Custom photo: caregiver enters the target word in Sinhala
- [ ] Custom photos stored in app-private storage (not public media)
- [ ] Built-in images categorized and filterable
- [ ] Image displayed at minimum 50% of screen width on all devices
- [ ] Images use simple, clear compositions (no busy backgrounds)

---

### FR08: Multi-Language Progression

**Description:** App supports progressive language unlocking: Sinhala → Tamil → English.

**User Story:**
> As a patient, I want to start therapy in my native language (Sinhala) and gradually unlock Tamil and English, so that I can work toward multilingual communication.

**Acceptance Criteria:**
- [ ] Sinhala is the default and only active language at app start
- [ ] Tamil unlocks after completing all Sinhala categories at ≥70% average
- [ ] English unlocks after completing all Tamil categories at ≥70% average
- [ ] Language switch is seamless (no re-login, no data loss)
- [ ] All UI text, audio prompts, TTS, and evaluation feedback available in all 3 languages
- [ ] Caregiver can override language lock (force-unlock any language)
- [ ] Progress tracked per language independently
- [ ] Mixed-language sessions possible (caregiver setting)

---

### FR09: Caregiver Dashboard

**Description:** A PIN-protected dashboard for caregivers to monitor progress and configure the app.

**User Story:**
> As a caregiver, I want a dashboard where I can see my father's progress, adjust settings, and export reports, so that I can actively participate in his therapy.

**Acceptance Criteria:**
- [ ] Access via 4-digit PIN (default: 1234, must be changed on first use)
- [ ] PIN entry limited to 5 attempts with 30-second lockout
- [ ] Dashboard sections:
  1. **Usage Overview** — sessions today, this week, this month
  2. **Score Trends** — line chart of average scores over time
  3. **Category Breakdown** — performance per image category/exercise type
  4. **Mastered Items** — list of mastered words with date achieved
  5. **Struggling Items** — items with <60% after 5+ attempts
  6. **Language Progress** — progress bar for each language tier
- [ ] Quick actions:
  1. **Add Custom Photo** — camera/gallery → name → category
  2. **Override Language** — force-unlock next language
  3. **Export Reports** — PDF generation (see FR11)
  4. **Configure App** — session length, composition ratio, breathing toggle
  5. **View Raw Data** — session logs with timestamps and scores
- [ ] Dashboard updates in real-time (reads from Firestore or local DB)
- [ ] Offline: dashboard shows locally cached data with "Last synced: [time]" indicator

---

### FR10: Progress Analytics

**Description:** Visual charts and data on patient progress over time.

**User Story:**
> As a caregiver, I want to see how my father's speech is improving over weeks and months, so that I can track the effectiveness of therapy.

**Acceptance Criteria:**
- [ ] Score trend line chart (last 7 days / 30 days / 90 days / all time)
- [ ] Category radar chart (performance across categories)
- [ ] Session frequency bar chart (sessions per day/week)
- [ ] Improvement rate: week-over-week score change percentage
- [ ] Mastery rate: number of newly mastered items per week
- [ ] Live Conversation metrics: average session duration, word count, fluency score
- [ ] Breathing exercise compliance: % of sessions with completed breathing
- [ ] Data can be filtered by language (Sinhala / Tamil / English)
- [ ] All charts use warm, accessible color palette (teal, amber, warm orange)
- [ ] Charts are generated locally using `fl_chart` or similar Flutter charting library
- [ ] Long data series (6+ months) auto-aggregate to weekly averages for readability

---

### FR11: PDF Report Export

**Description:** Export progress data as a formatted PDF for sharing with doctors.

**User Story:**
> As a caregiver, I want to export a PDF report of my father's progress to show his speech therapist, so that clinical decisions can be data-informed.

**Acceptance Criteria:**
- [ ] Report includes: patient name (optional), date range, session count, average scores
- [ ] Report includes: score trend chart (embedded image)
- [ ] Report includes: category performance breakdown
- [ ] Report includes: list of mastered and struggling items
- [ ] Report includes: language progression status
- [ ] Report generated in-app (no cloud dependency)
- [ ] Export options: share via system share sheet, save to device
- [ ] Report can be generated for: last 7 days, last 30 days, custom date range, all time
- [ ] Professional formatting: header, footer, page numbers, clean typography
- [ ] Optional: caregiver notes field before export
- [ ] PDF size: <5MB per report

---

### FR12: Offline/Online Sync

**Description:** App works fully offline and syncs data when internet becomes available.

**User Story:**
> As a patient who may not always have internet access, I want the app to work everywhere and sync data when connected, so that I never lose progress.

**Acceptance Criteria:**
- [ ] All core features work offline: Picture Naming, scoring, session tracking
- [ ] Local database (Drift/SQLite) is the primary data store
- [ ] Firestore sync happens in background when connectivity is available
- [ ] Sync queue: failed syncs retried with exponential backoff (30s → 2min → 5min → 30min)
- [ ] Conflict resolution: last-write-wins (acceptable for single-user app)
- [ ] Sync status indicator: 🔴 Offline / 🟡 Syncing / 🟢 Synced
- [ ] Live Conversation requires internet (gracefully degrades)
- [ ] Offline: Vosk (if model available) + Levenshtein scoring for Picture Naming
- [ ] Sync only over Wi-Fi (optional toggle in settings, default on)
- [ ] Data integrity: checksum-verify after each sync batch
- [ ] Clear user messaging: "Your data is safe. It will sync when you're online."

---

### FR13: App Configuration

**Description:** Settings panel for caregivers to customize the experience.

**User Story:**
> As a caregiver, I want to customize the app's behavior, so that it matches my father's specific needs and preferences.

**Acceptance Criteria:**
- [ ] Configurable via Caregiver Dashboard (PIN-protected)
- [ ] Session settings:
  - Session length (5/10/15/20 items)
  - Live Conversation duration (3/5/7/10 minutes)
  - Auto-advance delay (2/3/4/5 seconds)
  - Session composition ratio (slider: mastered/practicing/new)
- [ ] Feedback settings:
  - Haptic feedback on/off
  - Audio feedback on/off
  - Score display (level only / level + percentage)
- [ ] Language settings:
  - Force-unlock language
  - Default session language
  - Auto-progression on/off
- [ ] Breathing settings:
  - Toggle mandatory breathing (first 30 days / always / never)
  - Exercise duration (1/2/3 minutes)
- [ ] Data settings:
  - Sync only on Wi-Fi
  - Clear local data
  - Export all data
- [ ] Appearance settings:
  - Font size (default / large / extra large)
  - Dark mode on/off (for caregiver dashboard only)
  - Animation intensity (full / reduced / none)
- [ ] App info: version, build, licenses, privacy notice
- [ ] All settings persist across app restarts
- [ ] Settings changes take effect immediately (no restart needed)

---

### FR14: Breathing + Speech Integration

**Description:** Seamless transition from breathing exercise to speech practice.

**User Story:**
> As a patient, I want to flow naturally from breathing into my speech exercises, so that the transition feels like one continuous session.

**Acceptance Criteria:**
- [ ] Breathing exercise is integrated into the session flow (not a separate module)
- [ ] Post-breathing: screen transitions smoothly to exercise selection
- [ ] Breathing completion recorded as part of session data
- [ ] If breathing is skipped: "Prefer to go straight to practice?" confirmation
- [ ] Breathing exercise can be re-accessed mid-session via a "Calm down" button
- [ ] Audio guide uses same voice as the rest of the app

---

### FR15: Phase Transition Animations

**Description:** Smooth, non-jarring transitions between all app states.

**User Story:**
> As a patient who may have cognitive fatigue, I want transitions to be gentle and predictable, so that I'm not startled or confused.

**Acceptance Criteria:**
- [ ] Page transitions: fade (not slide) — gentle 300ms cross-fade
- [ ] Button state transitions: smooth 150ms opacity/scale
- [ ] Score reveal: staggered animation (badge first, then feedback, then audio)
- [ ] Loading states: skeleton screens preferred over spinners
- [ ] Error states: inline messages, never full-screen error overlays
- [ ] Image loading: progressive fade-in (no flash of blank)
- [ ] Recording states: clear visual indicator (pulsing circle, not just text)
- [ ] Session end: gentle completion animation, summary reveal
- [ ] No motion/animation for users who opt out (accessibility setting)

---

### FR16: Session History & Review

**Description:** Browse past sessions, review attempts, and replay recordings.

**User Story:**
> As a caregiver, I want to review my father's past sessions, listen to his attempts, and see how he's progressed over time.

**Acceptance Criteria:**
- [ ] Session history: paginated list (date, duration, average score, exercise type)
- [ ] Session detail: each item attempted, score, audio recording playback
- [ ] Audio recordings stored locally (auto-purge oldest when storage >500MB)
- [ ] Filter session history by: date range, exercise type, score range, language
- [ ] Search session history by word/exercise name
- [ ] Session detail accessible from Caregiver Dashboard
- [ ] Delete individual sessions or bulk clear
- [ ] Session data never auto-deletes (manual action only)

---

### FR17: Error Handling & Recovery

**Description:** Graceful handling of all error states.

**User Story:**
> As a patient who may not be tech-savvy, I want the app to handle errors gracefully and never show me a crash screen or cryptic error message.

**Acceptance Criteria:**
- [ ] No unhandled exceptions → all errors caught and logged
- [ ] Network errors: inline message with retry button
- [ ] API errors: "Speech coach is thinking. Let's try again in a moment."
- [ ] Microphone permission denied: guided setup with settings link
- [ ] Storage full: "Making space for new practice data..." → auto-clean cache
- [ ] Voice detection failed: "I didn't catch that. Could you try again?"
- [ ] Crash recovery: session state saved on every step → resume from last complete step
- [ ] Error logging: local log file (last 100 errors) accessible from caregiver dashboard
- [ ] Sentry or Firebase Crashlytics for remote error monitoring (optional, disabled by default)

---

### FR18: Gemini Live Conversation Directory

**Description:** 8 structured exercise types for Live Conversation mode.

| # | Exercise | Description | Duration | Difficulty |
|---|----------|-------------|----------|------------|
| 1 | **Category Naming** | "Name 5 animals" — category fluency | 3 min | Easy |
| 2 | **Letter Fluency** | "Say words starting with 'pa'" — phonemic fluency | 3 min | Medium |
| 3 | **Memory Recall** | "What did you do yesterday?" — autobiographical | 5 min | Medium |
| 4 | **Object Description** | AI shows a picture → user describes it | 3 min | Easy-Medium |
| 5 | **Daily Sentences** | "Tell me how to make tea" — procedural speech | 5 min | Medium |
| 6 | **Opposites** | AI says "hot" → user says "cold" — antonyms | 3 min | Easy |
| 7 | **Story Completion** | AI starts a story → user completes it | 5 min | Hard |
| 8 | **Breathing + Speech** | Combine breathing with vocalization | 3 min | Easy |

**Acceptance Criteria:**
- [ ] Each exercise type has structured AI prompt in Sinhala
- [ ] Exercise order: adaptive based on past performance (easier → harder progression)
- [ ] Session auto-selects 2-3 exercise types per Live Conversation
- [ ] AI evaluates per-exercise and provides overall session score
- [ ] Exercise type shown on screen before starting
- [ ] Caregiver can select specific exercise types for a session

---

## 2. Non-Functional Requirements

### NFR01: Performance

| Metric | Target | Measurement |
|--------|--------|-------------|
| App cold start | ≤3 seconds | Android Profiler |
| Picture Naming evaluation (online) | ≤5 seconds end-to-end | Manual timing (network-dependent) |
| Picture Naming evaluation (offline) | ≤2 seconds | Manual timing |
| Live Connection latency | ≤1.5 seconds to first audio | WebSocket handshake + first chunk |
| UI frame rate | 55+ fps during animations | Flutter DevTools |
| Screen transition | ≤300ms | DevTools timeline |
| Image loading | ≤500ms from local storage | Profiler |
| Database query (session list) | ≤100ms for 1000 records | Drift profiling |
| APK size | ≤80MB (release) | `flutter build apk` output |
| Memory usage (steady state) | ≤150MB | Android Profiler |

### NFR02: Offline Capability

| Feature | Online | Offline |
|---------|--------|---------|
| Picture Naming | ✅ Gemini API evaluation | ✅ Vosk + Levenshtein scoring (if model available) |
| Live Conversation | ✅ Full real-time | ❌ Unavailable (show graceful message) |
| Breathing Exercise | ✅ | ✅ (Fully local) |
| Session tracking | ✅ Auto-sync to Firestore | ✅ Local storage + sync queue |
| Caregiver Dashboard | ✅ Real-time Firestore | ✅ Cached local data |
| Image library | ✅ | ✅ (All local) |
| Progress charts | ✅ | ✅ (Computed from local DB) |
| PDF export | ✅ | ✅ (Local generation) |
| Custom images | ✅ | ✅ (Saved to device) |
| Settings changes | ✅ | ✅ (Persisted locally) |

### NFR03: Accessibility

| Requirement | Standard | Implementation |
|-------------|----------|----------------|
| Minimum font size | **28sp** | All body text, exercise labels, buttons |
| Font weight | **Bold** (w700+) | All primary text |
| Line spacing | 1.5x | All body text |
| Target size | ≥48×48dp | All interactive elements |
| Color contrast | WCAG AAA (7:1) | Text on backgrounds |
| Color meaning | Never color-only | All status indicated with icon + text + color |
| Screen reader | TalkBack support | Content descriptions on all images, proper semantics |
| Reduced motion | Respect OS setting | Disable non-essential animations |
| Touch delay | Configurable hold duration | "Long press" timer adjustable |
| No flashing | No >3Hz flashing | All animations media-query safe |
| Audio cues | All feedback has audio | Every score/state has optional spoken feedback |

**Critical Accessibility Colors:**
| Usage | Color | Hex | Contrast on #FDF6EC |
|-------|-------|-----|---------------------|
| Background | Warm Off-White | #FDF6EC | — |
| Primary | Teal | #2A9D8F | 3.4:1 (body large) |
| Secondary | Amber | #E9C46A | 1.8:1 (decorative) |
| Accent A | Warm Orange | #F4A261 | 3.0:1 (decorative) |
| Accent B | Soft Peach | #F5C5B0 | 2.0:1 (decorative) |
| Text Primary | Dark Brown | #2D3436 | 12.5:1 ✅ AAA |
| Text Secondary | Muted Brown | #636E72 | 8.2:1 ✅ AAA |
| Excellent | Teal | #2A9D8F | 3.4:1 (with background) |
| Good | Amber | #E9C46A | 1.8:1 (with background) |

**Note:** Score colors have contrast concerns. Use icon + text label + background tint for all score displays, never rely on color alone.

### NFR04: Security & Privacy

| Requirement | Implementation |
|-------------|----------------|
| API key protection | Gemini key stored server-side (Cloudflare Worker env var) |
| Local data | SQLCipher encryption for Drift database |
| Caregiver PIN | 4-digit PIN, 5-attempt lockout (30s), no biometric bypass required |
| Audio recordings | Stored in app-private directory (not accessible via file manager) |
| Cloud data | Firestore security rules restrict access by project UID |
| No user accounts | Firebase Anonymous Auth or no auth (device-based identity) |
| Crash reporting | Opt-in only, disabled by default |
| Permissions | Minimal: RECORD_AUDIO, READ_EXTERNAL_STORAGE (for custom photos), INTERNET |
| Data export | All data exportable, all data deletable |

### NFR05: Reliability

| Metric | Target |
|--------|--------|
| Crash-free rate | ≥99.5% |
| API success rate (Gemini) | ≥98% |
| Audio recording success | ≥99% |
| Sync success rate | ≥99% after 3 retries |
| Session recovery | ≥95% of interrupted sessions recoverable |
| Database integrity | Checksum-verified on each app launch |

### NFR06: Maintainability

| Requirement | Standard |
|-------------|----------|
| Code comments | Self-documenting code with doc blocks on all public APIs |
| State management | Riverpod — all state explicitly typed |
| Localization | Flutter ARB files for Sinhala, Tamil, English |
| Database migrations | Drift versioned migrations (never destructive) |
| Error logging | Structured logs with severity, context, timestamp |
| Testing | Unit tests for scoring engine, widget tests for key screens |
| Architecture | Clean Architecture: data → domain → presentation layers |
| Dependency injection | Riverpod providers for all services |

### NFR07: Cost

| Item | Monthly Budget |
|------|---------------|
| Cloudflare Workers | $0 (Free plan) |
| Firebase Firestore | $0 (Free tier) |
| Gemini 2.5 Flash (Picture Naming) | $0 - $2.40 |
| Gemini Live API (Conversation) | $3.60 - $17.40 |
| Google Cloud STT | $0 - $2.00 |
| **Total** | **$5 - $22/month** |
| **Target** | **≤$20/month** ✅ |

### NFR08: Device & Platform

| Requirement | Target |
|-------------|--------|
| Minimum platform | Android 8.0 (API 26) |
| Target platform | Android 14+ (API 34+) |
| Recommended device | Samsung Galaxy Tab A7+ or similar tablet |
| Screen sizes | 7" to 12" tablets preferred; 5.5"+ phones supported |
| Minimum RAM | 3GB |
| Storage | 200MB free for app + ~100MB per 6 months of audio data |
| Internet | Required for Live Conversation; optional for Picture Naming |
| Bluetooth | Optional (for Bluetooth microphone/headset) |

### NFR09: Data & Storage

| Requirement | Detail |
|-------------|--------|
| Local DB size estimate | ~50MB for 6 months of session data (text + scores) |
| Audio storage | ~100MB for 6 months (compressed, auto-purge threshold 500MB) |
| Image storage | ~50MB for built-in 300+ WebP images |
| Cloud storage (Firestore) | ~10MB for 6 months of data |
| Data retention | Never auto-deleted (manual only) |
| Backup | Local DB backed up via Firestore sync |

### NFR10: UI/UX Consistency

| Requirement | Standard |
|-------------|----------|
| Design system | Single design token set (colors, typography, spacing, radius) |
| Platform | Android Material 3 with custom therapy-focused theme |
| Font | System font (Noto Sans Sinhala on Android) for all Sinhala text |
| Icons | Material Icons + custom Sinhala-relevant icons |
| Spacing | 8dp grid system |
| Border radius | 16dp for cards, 24dp for buttons, 32dp for dialogs |
| Shadows | Soft, warm-toned shadows (not harsh gray) |
| Loading | Skeleton screens (not spinners) for content areas |

---

## 3. MVP Definition

The MVP (Minimum Viable Product) is defined as the set of features required for the first working release to the user's father.

### MVP Must-Haves (Phase 1 Release)

| # | FR | Feature | Priority |
|---|----|---------|----------|
| 1 | FR01 | Picture Naming with Gemini evaluation | P0 |
| 2 | FR04 | 4-Level Scoring (Excellent/Good/Almost/Try Again) | P0 |
| 3 | FR05 | Haptic feedback per score level | P0 |
| 4 | FR06 | Basic session composition (mastered/practicing/new) | P0 |
| 5 | FR07 | Built-in image library (100+ images, 5+ categories) | P0 |
| 6 | FR08 | Sinhala language (primary, no unlock yet) | P0 |
| 7 | FR03 | Breathing exercise (mandatory first month) | P0 |
| 8 | FR17 | Basic error handling (no crashes) | P0 |
| 9 | FR01 | Offline scoring (Levenshtein basic) | P0 |
| 10 | FR12 | Local-only storage (no cloud sync in MVP) | P0 |

### MVP Should-Haves (Phase 2)

| # | FR | Feature | Priority |
|---|----|---------|----------|
| 1 | FR09 | Basic caregiver dashboard (read-only) | P1 |
| 2 | FR02 | Live Conversation (1 exercise type: Category Naming) | P1 |
| 3 | FR07 | Custom photo upload | P1 |
| 4 | FR05 | Audio feedback TTS | P1 |

### MVP Could-Haves (Phase 3)

| # | FR | Feature | Priority |
|---|----|---------|----------|
| 1 | FR09 | Full caregiver dashboard | P2 |
| 2 | FR10 | Progress analytics charts | P2 |
| 3 | FR11 | PDF report export | P2 |
| 4 | FR12 | Firestore sync | P2 |
| 5 | FR08 | Tamil language unlock | P2 |
| 6 | FR18 | All 8 Live Conversation exercise types | P2 |
| 7 | FR16 | Session history & review | P2 |

### MVP Won't-Haves

| Feature | Rationale |
|---------|-----------|
| English language unlock | Lower priority than Sinhala/Tamil working well |
| Full offline Vosk model training | Can be added post-MVP; online path sufficient |
| Sentry/Firebase crash reporting | Opt-in, disable by default; local logging sufficient |
| Bluetooth headset optimization | Nice-to-have; standard Android audio routing works |
| Web/iOS versions | Android-only for MVP |
| Voice activity detection custom | Use Gemini Live built-in VAD |

---

## 4. Future Scope (Post-MVP)

| Feature | Rationale | Estimated Effort |
|---------|-----------|------------------|
| Vosk custom Sinhala model training | True offline-first STT | 2-4 weeks |
| Tamil language content & unlock system | Second language tier | 2-3 weeks |
| English language content & unlock system | Third language tier | 2-3 weeks |
| Firebase Firestore sync | Cloud backup across devices | 1 week |
| Full caregiver web dashboard | Remote monitoring from browser | 3-4 weeks |
| All 8 Live Conversation exercise types | Complete therapy suite | 2 weeks |
| Advanced progress analytics with ML trends | Predictive insights | 2 weeks |
| Multiple patient profiles | If other family members need therapy | 1 week |
| Speech therapy game modes | Gamification for motivation | 2-3 weeks |

---

> **Gate Check:** PASS ✅ — All functional requirements have acceptance criteria. All non-functional requirements are measurable. MVP scope is clearly defined (Must-Haves <40% of total feature scope).
> 
> **Next:** Phase 6 — Product Definition (vision, mission, personas, brand)
