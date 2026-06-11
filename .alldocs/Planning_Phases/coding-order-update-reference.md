# Phase 15 — Coding Order Update: Reference Implementation Insights

> **Project:** Handa (හඬ) — Stroke Speech Therapy Android App
> **Date:** 2026-06-10
> **Status:** COMPLETE
> **Base document:** `docs/coding-order.md`

---

## Sprint Revisions

### Sprint 6 (Gemini Live) — Revised & Expanded

The reference implementation reveals we need **3 new modules** before the Live API integration is complete:

| New Order | File | Description | Depends On | Source |
|-----------|------|-------------|-----------|--------|
| 6.1 | `lib/core/utils/audio_utils.dart` | PCM encode/decode, Float32↔Int16, base64 blob creation | — | `audioUtils.ts` |
| 6.2 | `lib/core/network/vertex_ai_auth.dart` | (UNCHANGED) ADC OAuth2 token acquisition & refresh | — | — |
| 6.3 | `lib/data/services/live_session_controller.dart` | Single controller: audio I/O pipeline, function call handler, transcription accumulator, widget routing | 6.1, 6.2, LiveApiService, thilina_prompt | `useGeminiLive.ts` |
| 6.4 | `lib/data/services/audio_output_controller.dart` | Sequential audio queue with interruption | 6.1 | `useGeminiLive.ts` lines 163-191 |
| 6.5 | `lib/data/datasources/remote/gemini_live_client.dart` | (UNCHANGED) Custom Vertex AI Bidi WebSocket client | 6.2 | — |
| 6.6 | `lib/presentation/providers/session_state_provider.dart` | Riverpod provider wrapping LiveSessionController | 6.3 | — |
| 6.7 | `lib/presentation/widgets/live/conversation_widget.dart` | Conversation screen: avatar, subtitles, user transcript | 6.6 | `ConversationWidget.tsx` |
| 6.8 | `lib/presentation/widgets/live/breathing_widget.dart` | Breathing animation: circle, cycle counter, phase labels | 6.6 | `BreathingWidget.tsx` |
| 6.9 | `lib/presentation/widgets/live/exercise_widget.dart` | Image naming: pill badge, image container, transcript box | 6.6 | `ExerciseWidget.tsx` |
| 6.10 | `lib/presentation/widgets/live/report_widget.dart` | Session report: award icon, wins list, close button | 6.6 | `ReportWidget.tsx` |
| 6.11 | `lib/presentation/pages/session/live_conversation/live_conversation_page.dart` | Page shell wrapping the widget router | 6.6-6.10 | `App.tsx` |
| 6.12 | `workers/gemini-proxy/` | (UNCHANGED) Cloudflare Worker | — | — |

### New Sprint 6.5 (Proposed): Widget & Controller Tests

Since the reference gives us exact UI patterns, we should add a test sprint:

| Order | File | Description | Depends On |
|-------|------|-------------|-----------|
| 6.13 | `test/unit/audio_utils_test.dart` | Test PCM encode/decode round-trip | 6.1 |
| 6.14 | `test/unit/audio_output_controller_test.dart` | Test sequential queue + interruption | 6.4 |
| 6.15 | `test/unit/live_session_controller_test.dart` | Test function call routing, transcription accumulation | 6.3 |
| 6.16 | `test/widget/live_widgets_test.dart` | Widget rendering + state changes | 6.7-6.10 |

---

## Widget Implementation Details (Translation from Reference)

### ConversationWidget (from ConversationWidget.tsx)

**Reference pattern:**
```tsx
// Animated pulse ring around avatar
<div className="relative">
  <div className="w-48 h-48 rounded-full bg-blue-100 ...">
    <div className="w-32 h-32 rounded-full bg-blue-500 animate-pulse" />
  </div>
  <div className="absolute inset-0 rounded-full border-4 border-blue-200 animate-ping" />
</div>

// Subtitles
<p className="text-3xl md:text-4xl font-medium">{subtitles || "..."}</p>

// User feedback with 3-dot idle animation
{userTranscript ? (
  <p className="text-lg italic">"{userTranscript}"</p>
) : (
  <div className="flex space-x-1">
    <div className="w-2 h-2 animate-bounce" style={{ animationDelay: '0ms' }} />
    <div className="w-2 h-2 animate-bounce" style={{ animationDelay: '150ms' }} />
    <div className="w-2 h-2 animate-bounce" style={{ animationDelay: '300ms' }} />
  </div>
)}
```

**Flutter translation:**
```dart
class ConversationWidget extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionStateProvider);
    return Column(
      children: [
        // Avatar with pulse ring
        Stack(
          alignment: Alignment.center,
          children: [
            AnimatedContainer(...), // ping ring
            CircleAvatar(radius: 96, child: ...), // avatar
          ],
        ),
        // Subtitles
        Text(state.subtitles, style: headlineLarge, textAlign: center),
        // User feedback / idle dots
        state.userTranscript.isNotEmpty
          ? Text('"${state.userTranscript}"')
          : ThreeDotBounceAnimation(),
      ],
    );
  }
}
```

### BreathingWidget (from BreathingWidget.tsx)

**Reference timing:** inhale(4s) → hold(4s) → exhale(6s) = 14s per cycle

**Reference pattern:**
```tsx
const [phase, setPhase] = useState<'inhale'|'hold'|'exhale'>('inhale');
const [cycleCount, setCycleCount] = useState(0);

// Phase transitions via setTimeout chains
setPhase('inhale');
setTimeout(() => setPhase('hold'), 4000);
setTimeout(() => setPhase('exhale'), 8000);
setTimeout(() => setCycleCount(c => c + 1), 14000);

// Circle scaling
const classes = phase === 'inhale' ? 'scale-150 bg-blue-400 transition-all duration-[4000ms]' :
                phase === 'hold' ? 'scale-150 bg-green-400 transition-colors duration-500' :
                'scale-100 bg-blue-200 transition-all duration-[6000ms]';
```

**Flutter translation:**
```dart
enum BreathPhase { inhale, hold, exhale }

class BreathingWidget extends StatefulWidget {
  final int cycles;
  // Use AnimationController with Tween<double>(begin: 1.0, end: 1.5)
  // inhale: 4s scale up, hold: 4s hold at 1.5, exhale: 6s scale down
}
```

---

## New File Manifest Additions

| File | Est. Lines | Source |
|------|-----------|--------|
| `lib/core/utils/audio_utils.dart` | 50 | `audioUtils.ts` |
| `lib/data/services/live_session_controller.dart` | 300 | `useGeminiLive.ts` |
| `lib/data/services/audio_output_controller.dart` | 80 | `useGeminiLive.ts` lines 163-191 |
| `lib/presentation/providers/session_state_provider.dart` | 60 | Riverpod wrapper |
| `lib/presentation/widgets/live/conversation_widget.dart` | 80 | `ConversationWidget.tsx` |
| `lib/presentation/widgets/live/breathing_widget.dart` | 100 | `BreathingWidget.tsx` |
| `lib/presentation/widgets/live/exercise_widget.dart` | 80 | `ExerciseWidget.tsx` |
| `lib/presentation/widgets/live/report_widget.dart` | 70 | `ReportWidget.tsx` |
| `test/unit/audio_utils_test.dart` | 40 | New |
| `test/unit/audio_output_controller_test.dart` | 60 | New |
| `test/unit/live_session_controller_test.dart` | 100 | New |
| `test/widget/live_widgets_test.dart` | 80 | New |

**Total new lines from reference:** ~1,100 lines added to the existing ~10,750 line plan.

---

## Updated Quick Start with Reference Priority

```bash
# PRIORITY ORDER based on reference analysis:

# 1. First — Fix transcription config (blocker)
#    Change {} from {languageCodes: [...]} in live_api_service.dart
#    Test immediately

# 2. Next — AudioUtils (no deps, foundation for all audio)
#    lib/core/utils/audio_utils.dart

# 3. Next — AudioOutputController (sequential queue)
#    lib/data/services/audio_output_controller.dart

# 4. Next — LiveSessionController (single controller)
#    lib/data/services/live_session_controller.dart

# 5. Next — Widget implementations (translation from reference)
#    ConversationWidget → BreathingWidget → ExerciseWidget → ReportWidget

# 6. Then — Everything else from original coding-order.md
```

## Validation

| Item | Status | Detail |
|------|--------|--------|
| Sprint 6 expanded to 12 files + 4 tests | ✅ UPDATE | New LiveSessionController, AudioUtils, AudioOutputController, 4 widgets |
| 3 new architecture modules | ✅ NEW | AudioUtils, AudioOutputController, LiveSessionController |
| 4 widget translations | ✅ NEW | Conversation, Breathing, Exercise, Report |
| ~1,100 new lines | ✅ NEW | Total estimate from reference translation |
| 4 test files | ✅ NEW | Audio utils, output controller, session controller, widget tests |
