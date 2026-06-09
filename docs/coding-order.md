# Phase 15 — Coding Order: Handa (හඬ)

> **Project:** Handa (හඬ) — Stroke Speech Therapy Android App
> **Date:** 2026-06-09
> **Status:** COMPLETE
> **Lifecycle:** PLANNING → ACTIVE (after this phase)

---

## ⚠️ CRITICAL: Coding Order Rules

1. **Code files in the EXACT order listed below.** Do not skip ahead.
2. **Each file must compile before moving to the next.**
3. **Each component must be testable in isolation before integration.**
4. **Foundation files first. Feature files second. Polish files last.**
5. **No file should exceed 300 lines. If it does, split it.**

---

## Sprint 0: Project Scaffold (Day 1)

**Goal:** Initialize the project, install dependencies, verify build.

| Order | File | Description | Validation |
|-------|------|-------------|------------|
| 0.1 | `flutter create --org com.handa --project-name handa .` | Create Flutter project | `flutter run` on device |
| 0.2 | `pubspec.yaml` | All dependencies listed below | `flutter pub get` succeeds |
| 0.3 | `lib/main.dart` | App entry point, ProviderScope | App launches |
| 0.4 | `lib/app.dart` | MaterialApp, theme, router | App shows home screen |

### pubspec.yaml Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  # State management
  flutter_riverpod: ^2.5.0
  riverpod_annotation: ^2.3.0
  
  # Database
  drift: ^2.18.0
  sqlite3_flutter_libs: ^0.5.0
  sqlcipher_flutter_libs: ^0.6.0
  path_provider: ^2.1.0
  path: ^1.9.0
  
  # Navigation
  go_router: ^14.0.0
  
  # Networking
  http: ^1.2.0
  firebase_core: ^3.0.0
  firebase_auth: ^5.0.0
  cloud_firestore: ^5.0.0
  firebase_ai_logic: ^1.0.0
  
  # Audio
  twin_stream: ^0.3.0
  audioplayers: ^6.0.0
  just_audio: ^0.9.0
  
  # UI
  fl_chart: ^0.69.0
  cached_network_image: ^3.4.0
  lottie: ^3.0.0
  shimmer: ^3.0.0
  
  # PDF
  pdf: ^3.11.0
  printing: ^5.13.0
  
  # Localization
  intl: ^0.19.0
  flutter_localizations:
    sdk: flutter
  
  # Utilities
  uuid: ^4.0.0
  collection: ^1.18.0
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  drift_dev: ^2.18.0
  build_runner: ^2.4.0
  riverpod_generator: ^2.4.0
  mockito: ^5.4.0
  flutter_lints: ^4.0.0
```

---

## Sprint 1: Foundation (M1.1 — Days 2-4)

**Goal:** Core infrastructure — database, theme, errors, utilities.

| Order | File | Description | Depends On |
|-------|------|-------------|------------|
| 1.1 | `lib/core/constants/app_colors.dart` | Color tokens (#FDF6EC, #2A9D8F, etc.) | — |
| 1.2 | `lib/core/constants/app_dimensions.dart` | Spacing, radius, sizing constants | — |
| 1.3 | `lib/core/constants/app_durations.dart` | Animation timing constants | — |
| 1.4 | `lib/core/theme/app_typography.dart` | 28sp+ bold text styles | 1.1 |
| 1.5 | `lib/core/theme/app_theme.dart` | Full Material 3 theme | 1.1, 1.2, 1.3, 1.4 |
| 1.6 | `lib/core/errors/failures.dart` | Sealed class error hierarchy | — |
| 1.7 | `lib/core/errors/error_handler.dart` | Global error handler | 1.6 |
| 1.8 | `lib/core/utils/sinhala_normalizer.dart` | Unicode normalization | — |
| 1.9 | `lib/core/utils/audio_utils.dart` | PCM chunking, silence detection | — |
| 1.10 | **`lib/core/audio/audio_focus_controller.dart`** | Audio focus management for TTS/mic/Gemini coexistence | 1.9 |
| 1.11 | `lib/presentation/providers/lifecycle_provider.dart` | App lifecycle tracking + triggers for audio/reconnect | — |
| 1.12 | **`lib/data/database/tables/categories_table.dart`** | Category table definition | — |
| 1.13 | **`lib/data/database/tables/exercises_table.dart`** | Exercise table definition | — |
| 1.14 | **`lib/data/database/tables/sessions_table.dart`** | Session table definition | — |
| 1.15 | **`lib/data/database/tables/attempts_table.dart`** | Attempt table definition | — |
| 1.16 | **`lib/data/database/tables/live_conversations_table.dart`** | Live conversation table | — |
| 1.17 | **`lib/data/database/tables/settings_table.dart`** | Settings key-value table | — |
| 1.18 | **`lib/data/database/app_database.dart`** | DB definition + migrations | 1.12-1.17 |
| 1.19 | **`lib/data/database/daos/category_dao.dart`** | Category queries | 1.18 |
| 1.20 | **`lib/data/database/daos/exercise_dao.dart`** | Exercise queries | 1.18 |
| 1.21 | **`lib/data/database/daos/session_dao.dart`** | Session queries | 1.18 |
| 1.22 | **`lib/data/database/daos/settings_dao.dart`** | Settings queries | 1.18 |
| 1.23 | `lib/core/constants/app_strings.dart` | Sinhala/English string constants | — |

**M1.1 Validation Gate:** 
- `drift_dev` code generation runs without errors
- Database opens, migrations run, CRUD operations work
- Theme renders correctly on target device

---

## Sprint 2: Design System + UI Components (M1.2 — Days 5-7)

**Goal:** Reusable widget library and screen shells.

| Order | File | Description | Depends On |
|-------|------|-------------|------------|
| 2.1 | `lib/presentation/widgets/handa_button.dart` | Large rounded primary button | 1.5 |
| 2.2 | `lib/presentation/widgets/progress_dots.dart` | Session progress indicator | 1.1 |
| 2.3 | `lib/presentation/widgets/mic_button.dart` | Hold-to-record mic button | 1.1, 1.9 |
| 2.4 | `lib/presentation/widgets/score_badge.dart` | Animated score level badge | 1.1 |
| 2.5 | `lib/presentation/widgets/feedback_toast.dart` | Gentle inline message | 1.1 |
| 2.6 | `lib/presentation/widgets/breathing_circle.dart` | Animated expanding circle | 1.5 |
| 2.7 | `lib/presentation/widgets/waveform_visualizer.dart` | Audio amplitude visualization | — |
| 2.8 | `lib/presentation/widgets/stat_card.dart` | Dashboard stat card | 1.5 |
| 2.9 | `lib/presentation/widgets/confetti_effect.dart` | Particle celebration | — |
| 2.10 | `lib/presentation/widgets/shimmer_loading.dart` | Shimmer skeleton for loading states | 1.5 |
| 2.11 | `lib/presentation/widgets/error_retry_widget.dart` | Error state with retry button | 1.5 |
| 2.12 | `lib/presentation/router/app_router.dart` | GoRouter with all routes | — |
| 2.13 | `lib/presentation/router/route_guards.dart` | PIN guard | — |

**M1.2 Validation Gate:**
- All widgets render in isolation in test harness
- Visual review on target device
- Router navigates between placeholder screens

---

## Sprint 3: Image Library + Audio Capture (M1.3 — Days 8-10)

**Goal:** Content and input systems.

| Order | File | Description | Depends On |
|-------|------|-------------|------------|
| 3.1 | `assets/images/` | Place 100+ WebP images in 5+ category folders | — |
| 3.2 | `lib/data/models/image_model.dart` | Image data class | — |
| 3.3 | `lib/presentation/providers/image_provider.dart` | Image loading provider | 3.2 |
| 3.4 | `lib/data/datasources/platform/audio_capture_source.dart` | twin_stream wrapper | — |
| 3.5 | `lib/data/datasources/platform/haptic_feedback_source.dart` | HapticFeedback wrapper | — |
| 3.6 | `lib/data/datasources/platform/tts_source.dart` | Piper TTS wrapper | — |
| 3.7 | `lib/presentation/providers/audio_provider.dart` | Audio state management | 3.4 |

**M1.3 Validation Gate:**
- All 100+ images render in ImageCard widget
- Audio records and saves to disk
- Haptic patterns are distinguishable
- TTS speaks Sinhala phrases correctly

---

## Sprint 4: Scoring Engine + Picture Naming (M2.1 — Days 11-15)

**Goal:** Core therapy flow — the heart of the app.

| Order | File | Description | Depends On |
|-------|------|-------------|------------|
| 4.1 | `lib/core/utils/scoring_engine.dart` | Levenshtein + SinhalaNormalizer + classifier | 1.8 |
| 4.2 | `lib/domain/entities/score_level.dart` | ScoreLevel enum (Excellent/Good/Almost/TryAgain) | — |
| 4.3 | **`lib/domain/usecases/evaluate_answer.dart`** | Evaluate speech attempt | 4.1, 4.2 |
| 4.4 | `lib/data/datasources/local/audio_storage_source.dart` | Save/load recordings | — |
| 4.5 | `lib/data/datasources/remote/gemini_api_source.dart` | REST API client | — |
| 4.6 | **`lib/domain/repositories/scoring_repository.dart`** | Scoring repository interface | 4.3 |
| 4.7 | `lib/data/repositories/scoring_repository_impl.dart` | Implements scoring | 4.5, 4.4 |
| 4.8 | `lib/presentation/providers/scoring_provider.dart` | Scoring state provider | 4.7 |
| 4.9 | `lib/domain/entities/exercise.dart` | Exercise entity | — |
| 4.10 | `lib/domain/entities/session.dart` | Session entity | — |
| 4.11 | `lib/domain/entities/attempt.dart` | Attempt entity | — |
| 4.12 | **`lib/domain/usecases/compose_session.dart`** | 40/40/20 composition + ramp-up | 1.17, 1.18 |
| 4.13 | **`lib/domain/repositories/session_repository.dart`** | Session repository interface | 4.10 |
| 4.14 | `lib/data/repositories/session_repository_impl.dart` | Implements sessions | 1.19, 4.13 |
| 4.15 | `lib/presentation/providers/session_provider.dart` | Session state provider | 4.14 |
| 4.16 | **`lib/domain/usecases/track_progress.dart`** | Update progress after attempt | 4.14 |
| 4.17 | `lib/presentation/providers/exercise_provider.dart` | Exercise state provider | 4.14 |

**M2.1 Validation Gate:**
- Picture Naming flow works end-to-end (offline)
- Score correctly classified into 4 levels
- Session composition follows 40/40/20 rule
- Unit tests pass for scoring engine (all 4 levels)

---

## Sprint 5: Picture Naming UI + Session Flow (M2.2 — Days 16-21)

**Goal:** Complete patient-facing session experience.

| Order | File | Description | Depends On |
|-------|------|-------------|------------|
| 5.1 | `lib/presentation/pages/splash/splash_page.dart` | Splash screen (3s) | 2.10 |
| 5.2 | `lib/presentation/pages/home/home_page.dart` | Home screen with START button | 2.10, 4.15 |
| 5.3 | `lib/presentation/pages/session/session_intro_page.dart` | Exercise briefing | 2.10 |
| 5.4 | `lib/presentation/pages/session/breathing/breathing_page.dart` | Breathing exercise UI | 2.6, 2.10 |
| 5.5 | **`lib/presentation/pages/session/picture_naming/picture_naming_page.dart`** | Core PN screen | 2.3, 2.4, 2.2, 2.10, 4.15 |
| 5.6 | `lib/presentation/pages/session/picture_naming/score_reveal_widget.dart` | Animated score reveal | 2.4, 2.9 |
| 5.7 | `lib/presentation/pages/session/break/break_page.dart` | Rest screen (15s) | 2.10 |
| 5.8 | `lib/presentation/pages/session/session_summary/session_summary_page.dart` | End-of-session results | 2.4, 2.10, 4.15 |

**M2.2 Validation Gate:**
- Complete session flow: Home → Breathing → PN (10 items) → Break → Summary
- All animations play correctly (confetti, bounce, wobble, fade)
- Haptic feedback fires per score level
- Session data saves to Drift database
- ✅ **MILESTONE M2 COMPLETE — CORE THERAPY WORKS**

---

## Sprint 6: Live Conversation (M3.1 — Days 22-27)

**Goal:** Gemini-powered voice conversation.

| Order | File | Description | Depends On |
|-------|------|-------------|------------|
| 6.1 | `lib/data/datasources/remote/gemini_live_source.dart` | Firebase AI Logic WebSocket | 3.4 |
| 6.2 | `lib/data/datasources/remote/cloudflare_proxy_source.dart` | Worker HTTP client | — |
| 6.3 | **`lib/domain/usecases/sync_data.dart`** | Cloud sync orchestrator | — |
| 6.4 | `lib/presentation/providers/live_session_provider.dart` | Live conversation state | 6.1 |
| 6.5 | `lib/presentation/pages/session/live_conversation/live_conversation_page.dart` | Live conversation UI | 2.7, 2.10, 6.4 |
| 6.6 | `lib/presentation/pages/session/live_conversation/live_summary_page.dart` | Live session results | 2.10, 4.2 |
| 6.7 | `workers/gemini-proxy/src/index.ts` | Cloudflare Worker code | — |
| 6.8 | `workers/gemini-proxy/wrangler.toml` | Worker configuration | 6.7 |

**M3.1 Validation Gate:**
- WebSocket connection establishes with Gemini Live
- User speaks → AI hears → AI responds with audio
- Live UI shows waveform, transcript, timer
- Cloudflare Worker deployed and serving requests

---

## Sprint 7: Caregiver Dashboard (M4.1 — Days 28-34)

**Goal:** Full caregiver experience.

| Order | File | Description | Depends On |
|-------|------|-------------|------------|
| 7.1 | `lib/presentation/pages/caregiver/pin_entry/pin_entry_page.dart` | PIN screen with number pad | 2.10, 2.11 |
| 7.2 | `lib/presentation/pages/caregiver/dashboard/dashboard_page.dart` | Dashboard home with stats | 2.8, 2.10, 1.19 |
| 7.3 | `lib/presentation/pages/caregiver/sessions/session_history_page.dart` | Session list with filters | 2.10, 4.15 |
| 7.4 | `lib/presentation/pages/caregiver/sessions/session_detail_page.dart` | Session detail with replay | 2.10, 4.4 |
| 7.5 | `lib/presentation/pages/caregiver/analytics/analytics_page.dart` | Charts page container | 2.10 |
| 7.6 | `lib/presentation/pages/caregiver/analytics/score_trend_chart.dart` | Line chart (fl_chart) | 1.19 |
| 7.7 | `lib/presentation/pages/caregiver/analytics/category_radar_chart.dart` | Radar chart | 1.18 |
| 7.8 | `lib/presentation/pages/caregiver/content/content_browser_page.dart` | Image categories browser | 2.10 |
| 7.9 | `lib/presentation/pages/caregiver/content/add_photo_page.dart` | Custom photo upload | 2.10 |
| 7.10 | `lib/presentation/pages/caregiver/settings/settings_page.dart` | Settings panel | 2.10, 1.20 |
| 7.11 | `lib/presentation/pages/caregiver/export/pdf_export_page.dart` | PDF export UI | 2.10 |
| 7.12 | `lib/presentation/pages/patient_settings/patient_settings_page.dart` | Basic patient settings | 2.10 |

**M4.1 Validation Gate:**
- PIN protects caregiver access (5-attempt lockout)
- Dashboard shows real data from Drift DB
- Charts render with correct data
- Custom photo upload works end-to-end
- Settings persist across app restarts
- PDF exports correctly
- ✅ **MILESTONE M4 COMPLETE — CAREGIVER DASHBOARD WORKS**

---

## Sprint 8: Cloud Sync + Polish (M4.2 + M5 — Days 35-42)

**Goal:** Data sync, multi-language, performance optimization, release.

| Order | File | Description | Depends On |
|-------|------|-------------|------------|
| 8.1 | `lib/data/datasources/remote/firestore_source.dart` | Firestore CRUD operations | 6.3 |
| 8.2 | `lib/data/repositories/sync_repository_impl.dart` | Sync queue implementation | 8.1 |
| 8.3 | `lib/presentation/providers/sync_provider.dart` | Sync status provider | 8.2 |
| 8.4 | `lib/l10n/app_si.arb` | Sinhala localization strings | — |
| 8.5 | `lib/l10n/app_ta.arb` | Tamil localization strings | — |
| 8.6 | `lib/l10n/app_en.arb` | English localization strings | — |
| 8.7 | `lib/domain/usecases/manage_language_unlock.dart` | Language progression logic | — |

**M5 Polish Tasks (Days 38-42):**
| Order | Task | Description |
|-------|------|-------------|
| 8.8 | Performance audit | DevTools: verify 55+ fps, <16ms frames |
| 8.9 | Accessibility audit | TalkBack navigation, contrast check |
| 8.10 | Error hardening | Force errors → verify graceful handling |
| 8.11 | Sinhala content review | Native speaker verifies all strings |
| 8.12 | App icon + splash | Branded assets |
| 8.13 | APK build | `flutter build apk --release`, sign |
| 8.14 | Install test | On target device (Galaxy Tab A7+ or similar) |

---

## Complete File Manifest

### By Layer

| Layer | Files | Lines Est. |
|-------|-------|------------|
| **core/** (constants, errors, utils, theme, audio) | ~17 | ~950 |
| **data/database/** (tables, daos, database) | ~12 | ~1,200 |
| **data/datasources/** (local, remote, platform) | ~8 | ~800 |
| **data/models/** | ~6 | ~400 |
| **data/repositories/** | ~3 | ~500 |
| **domain/entities/** | ~6 | ~200 |
| **domain/usecases/** | ~5 | ~400 |
| **domain/repositories/** (interfaces) | ~5 | ~150 |
| **presentation/providers/** | ~10 | ~600 |
| **presentation/pages/** (~15 folders) | ~25 | ~3,500 |
| **presentation/widgets/** | ~10 | ~1,500 |
| **presentation/router/** | ~2 | ~200 |
| **workers/** | ~2 | ~200 |
| **l10n/** | ~3 | ~500 |
| **assets/images/** | ~100+ files | — |
| **Other** (main.dart, app.dart, pubspec.yaml) | ~3 | ~200 |
| **Total** | **~115 files** | **~10,750 lines** |

---

## Coding Rules

| Rule | Detail |
|------|--------|
| **File size limit** | No file >300 lines. Split into sub-files if needed. |
| **Test coverage** | See Appendix A.6 for exact thresholds per layer. Minimum: scoring engine ≥95%, repositories ≥80%. |
| **Compilation check** | `flutter analyze` must pass with 0 errors before each commit. |
| **Commit frequency** | At least once per sprint (every 1-3 days). |
| **Branch strategy** | Single `main` branch (personal project). Use feature toggles for incomplete features. |
| **State management** | Every mutable state → Riverpod StateNotifier or AsyncNotifier. |
| **Null safety** | All variables must be non-nullable unless explicitly required. |
| **Error handling** | Every repository method returns `Either<Failure, T>`. Every async operation has try/catch. |
| **Logging** | Every catch logs with `AppLogger.log()`. |
| **Sinhala strings** | Never hardcode Sinhala in widgets. Always use `AppStrings` or ARB. |
| **const constructors** | Every widget class must have const constructor. Every child must use const where possible. |
| **Three-state UI** | Every page MUST implement data/loading/error states (see Appendix A.8). |
| **Lifecycle cleanup** | Every page with audio must call dispose() on all controllers, subscriptions, and audio focus (see Appendix A.7). |
| **Haptic discipline** | Use haptic pattern map from Appendix A.1. Never use REJECT haptic. |
| **Animation rules** | Only animate transform and opacity (not width/height). Use spring physics for natural feel. |

---

## Appendix A: Skill-Validated Gaps & Enhancements

The following additions were identified by cross-referencing the plan against `android-mobile-dev`, `mobile-design`, and `testing-strategy` skills. These MUST be followed during implementation.

### A.1 Haptic Pattern Mapping

```
Score Level     Haptic Pattern                    VibrationEffect
─────────────   ──────────────────────────────    ─────────────────────────
Excellent       Double confirm (celebration)      EFFECT_HEAVY_CLICK → 50ms → EFFECT_CLICK
Good            Single strong click               EFFECT_CLICK
Almost          Texture tick (wobble feel)        EFFECT_TEXTURE_TICK
Try Again       Gentle single pulse (no reject)   EFFECT_TICK (single light tap)
Breathing       Rhythmic sweep (4s in / 4s hold   Custom waveform: gradual amplitude ramp up
                / 6s out)                         then hold plateau, then fade out
Button tap      Light tick                        KEYBOARD_TAP
Session start   Confirm pulse                     EFFECT_CONFIRM
Session end     Completion pattern                Double confirm → 200ms pause → confirm
```

**Rules:**
- `Try Again` must NEVER use `REJECT` haptic — therapy is encouraging, not punishing
- Respect `Settings.System.HAPTIC_FEEDBACK_ENABLED` — check before vibrating
- All custom waveforms fall back to simple `oneShot(50)` on API < 26 (though min is 26)

### A.2 Audio Focus Management

Handa uses **3 audio subsystems simultaneously**: TTS (Piper), Mic capture (twin_stream), and Gemini Live output. Audio focus conflicts WILL occur.

**Architecture:**

```
┌─────────────────────────────────────────────────────┐
│                 AudioFocusController                 │
├─────────────────────────────────────────────────────┤
│  Types:                                              │
│  ├── TTS (Piper)              → AUDIOFOCUS_GAIN_TRANSIENT        │
│  ├── Mic Capture (twin_stream) → AUDIOFOCUS_GAIN_TRANSIENT        │
│  ├── Gemini Live Output       → AUDIOFOCUS_GAIN                  │
│  └── Breathing Guide          → AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK│
│                                                      │
│  Ducking Rules:                                       │
│  ├── TTS + Mic → TTS plays → mic pauses → TTS done  │
│  │              → mic resumes (sequential, not concurrent)
│  ├── Breathing + Any → Breathing ducks, other pauses │
│  └── Gemini Live → Gains full focus, all others pause│
└─────────────────────────────────────────────────────┘
```

**Implementation:** Add `lib/core/audio/audio_focus_controller.dart` on Sprint 1 (insert after 1.9).
Every audio operation MUST request/release focus through this controller.

### A.3 TalkBack Accessibility Patterns

Every interactive screen must use these Flutter semantics patterns:

```dart
// Pattern 1: Merge descendants for score cards
Card(
  semantics: Semantics(
    mergeDescendants: true,
    label: 'Exercise: Apple. Score: Excellent. Score 95 percent',
    hint: 'Double tap to hear pronunciation again',
  ),
  child: Column(children: [image, label, scoreBadge])
)

// Pattern 2: Custom actions for audio playback
Semantics(
  customActions: [
    CustomAccessibilityAction(
      label: 'Play pronunciation',
      onTap: () => tts.speak('Apple'),
    ),
    CustomAccessibilityAction(
      label: 'Repeat instruction',
      onTap: () => tts.speak('Name what you see in the picture'),
    ),
  ],
  child: /* widget */
)

// Pattern 3: State descriptions for dynamic updates
Semantics(
  liveRegion: true, // Announce changes immediately
  stateDescription: 'Score updated to Excellent. ${score} percent',
  child: scoreBadgeWidget,
)

// Pattern 4: Screen announcement on page enter
// Each page must announce its purpose on first build:
Semantics(
  label: 'Picture Naming Exercise. Say what you see in the image.',
)
```

**Mandatory:** Every screen has a `Semantics(mergeDescendants: true)` wrapper on the root that provides a concise screen-level description.

### A.4 Flutter Performance Checklist

**Add to Coding Rules (all sprints):**

```
┌─────────────────────────────────────────────────────────────────┐
│                    FLUTTER PERFORMANCE CHECKLIST                 │
├─────────────────────────────────────────────────────────────────┤
│ EVERY WIDGET:                                                    │
│ □ const constructor (if no runtime args)                         │
│ □ const on child widgets where possible                          │
│ □ Minimal setState scope (use ValueListenableBuilder / Riverpod) │
│                                                                  │
│ EVERY LIST:                                                      │
│ □ ListView.builder (NEVER ListView(children:[...]))              │
│ □ itemExtent provided for fixed-height items                     │
│ □ Image cache size limits set                                    │
│                                                                  │
│ EVERY ANIMATION:                                                 │
│ □ Prefer AnimatedWidget over manual AnimationController          │
│ □ Avoid Opacity widget → use FadeTransition                      │
│ □ Use TickerProviderStateMixin for AnimationController           │
│ □ Only animate transform/opacity (NOT width/height)              │
│ □ Spring: damping 10-20, stiffness 100-200 for natural feel      │
│                                                                  │
│ BEFORE RELEASE:                                                  │
│ □ All dispose() methods implemented                              │
│ □ No print() / debugPrint() in production                        │
│ □ DevTools performance overlay checked (55+ fps)                 │
│ □ Tested in profile mode (not debug mode)                        │
│ □ const widget rebuilds verified (DevTools track widget rebuilds)│
└─────────────────────────────────────────────────────────────────┘
```

### A.5 Animation Best Practices (for Handa)

| Animation | Technique | Duration | Easing | Notes |
|-----------|-----------|----------|--------|-------|
| Breathing circle | CustomPainter + AnimationController | 4s in / 4s hold / 6s out | Curves.easeInOut | Use spring for inhale-exhale transitions |
| Confetti celebration | Particle system + staggered AnimationController | 2000ms | Curves.easeOut | ~30 particles, randomized positions |
| Score badge reveal | ScaleTransition (0→1) + fade | 400ms | spring(damping:12, stiffness:150) | Bouncy but settles quickly |
| Score badge color | TweenAnimationBuilder<Color> | 300ms | Curves.easeOut | Smooth color transition between levels |
| Mic button pulse | AnimationController + transform scale | 1000ms loop | Curves.easeInOut | Subtle 1.0→1.05 breathing pulse |
| Page transitions | SlideTransition (bottom→up) | 300ms | Curves.fastOutSlowIn | Consistent left-to-right for Sinhala RTL |
| Waveform visualizer | CustomPainter with recorded buffer data | Real-time | N/A | Updated per audio callback (~50ms) |

### A.6 Testing Strategy (Refined)

**Ratios & Thresholds:**

| Layer | Type | Coverage Target | Framework |
|-------|------|-----------------|-----------|
| Scoring engine | Unit | **≥95%** (critical) | `flutter_test` |
| Domain entities | Unit | **≥90%** | `flutter_test` |
| Repository impl | Unit | **≥80%** | `mockito` + `flutter_test` |
| Providers | Unit | **≥80%** | `flutter_test` + `riverpod_test` |
| DAOs (Drift) | Integration | **≥85%** | Drift test utils + in-memory DB |
| Pages | Widget | **≥70%** | `flutter_test` + `WidgetTester` |
| Full session flow | Integration | **1 smoke test** | `integration_test` |
| CSV reports | Unit | **≥90%** | `flutter_test` |

**Test naming (AAA pattern):**
```dart
describe("ScoringEngine", () => {
  describe("classifyScore", () => {
    it("should return Excellent when levenshtein >= 0.9");
    it("should return Good when levenshtein >= 0.75 and < 0.9");
    it("should return Almost when levenshtein >= 0.6 and < 0.75");
    it("should return TryAgain when levenshtein < 0.6");
    it("should handle empty input string gracefully");
    it("should normalize Sinhala unicode before comparison");
  });
});
```

**Integration test file:** `integration_test/session_flow_test.dart` — Sprint 8 (add after 8.7).

### A.7 Lifecycle Awareness

Every page that captures audio MUST implement:

```dart
@override
void dispose() {
  audioController.stop();
  audioController.dispose();
  ttsManager.stop();
  focusManager.abandonFocus();
  streamSubscription.cancel();
  super.dispose();
}
```

**Add lifecycle provider:** `lib/presentation/providers/lifecycle_provider.dart` on Sprint 1.
This provider tracks app lifecycle state (resumed/paused/stopped) and triggers:
- **onPause:** Stop audio capture, release mic, pause TTS
- **onResume:** Re-initialize audio system, re-request audio focus
- **onStop:** Save session state immediately, release all resources

**Platform-specific:** Android must handle `ActivityResultLauncher` for mic permission re-request if revoked.

### A.8 Three-State UI Requirement

**Every screen MUST implement these 3 states:**

```dart
// Pattern for every page
class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(myProvider);

    return asyncData.when(
      data: (data) => _buildContent(context, data),
      loading: () => const ShimmerLoading(),  // ← NOT a spinner, use shimmer
      error: (err, stack) => ErrorRetryWidget(
        message: 'Could not load exercises',
        onRetry: () => ref.invalidate(myProvider),
      ),
    );
  }
}
```

**Added to source inventory:**
- `lib/presentation/widgets/shimmer_loading.dart` — Add to Sprint 2 (after 2.9)
- `lib/presentation/widgets/error_retry_widget.dart` — Add to Sprint 2 (after shimmer_loading)
- Every page file listed in Sprints 2-8 MUST follow this pattern

### A.9 Color & Typography Constraints (Platform-Validated)

From Material Design 3 type scale (platform-android.md):

| Our Token | Material Role | Size | Weight | 
|-----------|---------------|------|--------|
| `displayLarge` | Hero / splash | 57sp | Bold |
| `headlineLarge` | Page title (e.g. "අද සැසිය") | 32sp | Bold |
| `headlineMedium` | Section header | **28sp (min)** | Bold |
| `titleLarge` | Exercise prompt | 22sp | Bold |
| `bodyLarge` | Button text, feedback | 16sp | Bold |
| `bodyMedium` | Secondary text, stats | 14sp | Medium |

**Constraint:** NEVER use weight below `Medium` (500). Handa is an accessibility-first app for low-vision elderly users.

### A.10 Platform + Framework Decision Validation

Re-validating the architecture decision using `mobile-design` skill's decision tree:

```
NODE: WHAT ARE YOU BUILDING?
  ├── Deep native features + single platform focus → Android only
  │   └── Kotlin + Jetpack Compose? 
  │       → NO. Flutter is superior because:
  │         (a) Sinhala text: Flutter's own HarfBuzz engine renders 
  │             Sinhala conjuncts identically on ALL Android versions.
  │             Platform text engine varies by OEM/manufacturer.
  │         (b) Offline TTS: dart:ffi → ONNX runtime directly.
  │             Kotlin would need JNI wrapping same C++.
  │         (c) Single-patient app doesn't need platform-native APIs
  │             that Flutter can't cover. All requirements (audio,
  │             haptics, camera, file I/O) have mature Flutter packages.
  │
  ├── OTA updates needed? → Not for personal project
  ├── Web version needed? → Not planned
  └── Result: ✅ FLUTTER CONFIRMED (Verdict unchanged)
```

---

## ⚡ Quick Start

```bash
# 1. Create Flutter project
cd /home/jay/Desktop/Workspace/Therapy
flutter create --org com.handa --project-name handa .

# 2. Install dependencies
# Edit pubspec.yaml with all dependencies above
flutter pub get

# 3. Run build_runner (Drift + Riverpod code generation)
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Verify it compiles
flutter analyze

# 5. Start Sprint 1 (Foundation - Database)
# Follow the order above, starting from 1.1
```

---

## Release Criteria

Before APK can be built and shared:

- [ ] Sprint 1-6 (M1-M2) complete: Core Picture Naming + Breathing works
- [ ] **Scoring engine unit tests ≥95%** (all 4 levels, edge cases, empty input)
- [ ] `flutter analyze` has 0 errors, 0 warnings
- [ ] App launches and completes a full session on target device
- [ ] No crashes during 30-minute continuous use test
- [ ] **Performance overlay confirms 55+ fps** during session flow
- [ ] **All dispose() methods verified** (no memory leaks in DevTools)
- [ ] **TalkBack navigation tested** on target device
- [ ] **WCAG AAA contrast verified** for all text/background pairs
- [ ] **Error handling forced** (kill network mid-session → graceful error toast shown)
- [ ] **Audio focus conflict tested** (incoming call during session → pause, resume correctly)
- [ ] **Sinhala text rendering verified** on target device (not emulator — OEM text engines differ)
- [ ] All Sinhala strings verified by native speaker
- [ ] **const constructor compliance** checked via DevTools widget rebuild tracker

---

> **✅ ALL 15 PHASES COMPLETE**
>
> **Lifecycle:** PLANNING → **ACTIVE** (ready for implementation)
>
> **Total planning artifacts:** 15 documents in `docs/`
>
> **Next step:** Switch to coding mode and begin Sprint 1 (Foundation).
>
> **CLI for mode switch:**
> `opencode-tools_agent_set_mode(mode="general")`
