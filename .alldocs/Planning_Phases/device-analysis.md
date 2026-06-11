# Phase 9 — Device Analysis: Handa (හඬ)

> **Project:** Handa (හඬ) — Stroke Speech Therapy Android App
> **Date:** 2026-06-09
> **Status:** COMPLETE

---

## Target Device Matrix

| Device Type | Priority | Screen Size | Input | Key Constraints | Special Considerations |
|-------------|----------|-------------|-------|-----------------|----------------------|
| **Android Tablet (7-12")** | 🥇 P0 | 1024×600 to 2560×1600 | Touch + optional BT keyboard | Varies widely by manufacturer | Primary target — Samsung Galaxy Tab A7+ and similar |
| **Android Phone (5.5-6.9")** | 🥈 P1 | 1080×2400 typical | Touch | Smaller screen = larger font constraints | Portrait mode only; landscape optional |
| **Chromebook / foldable** | 🥉 P2 | Variable | Touch + keyboard | Fragmented screen sizes | Future consideration |
| **iOS** | ❌ Out of scope | — | — | — | Not planned for MVP |

---

## Android Version Distribution

| Android Version | API Level | Target | Notes |
|----------------|-----------|--------|-------|
| Android 8.0 (Oreo) | 26 | Minimum | ~95% of active devices covered |
| Android 10+ (Q) | 29+ | Target | Modern haptic APIs, edge-to-edge |
| Android 14+ (Upside Down Cake) | 34+ | Optimize | Predictive back gesture, better large screen |

**Decision:** `minSdkVersion = 26` (Android 8.0), `targetSdkVersion = 34` (Android 14)

---

## Hardware Requirements

### Minimum Specs
| Component | Minimum | Recommended | Rationale |
|-----------|---------|-------------|-----------|
| **RAM** | 3GB | 4GB+ | Flutter + Drift + audio processing |
| **Storage** | 1GB free | 4GB+ | App (~200MB) + images (~50MB) + audio recordings |
| **CPU** | 4 cores @ 1.8GHz | 8 cores @ 2.0GHz+ | Real-time audio processing, Vosk inference |
| **Microphone** | Required | Noise-cancelling | Speech recognition accuracy |
| **Speaker** | Required | Front-facing | Clear audio feedback |
| **Vibrator** | Required | Linear actuator | Haptic feedback patterns |
| **Internet** | Optional (Wi-Fi + Cellular) | — | Only needed for Live Conversation + sync |

### Android Permissions
| Permission | Required For | Rationale |
|------------|-------------|-----------|
| `RECORD_AUDIO` | Speech recording | Core feature — must request at runtime |
| `INTERNET` | Gemini API, Firebase | Network features |
| `ACCESS_NETWORK_STATE` | Offline detection | Sync status indicator |
| `READ_EXTERNAL_STORAGE` / `READ_MEDIA_IMAGES` | Custom photo uploads | Caregiver feature (API 33+) |
| `CAMERA` (optional) | Take photo for custom image | Caregiver feature |
| `VIBRATE` | Haptic feedback | Must be explicitly requested in manifest |
| `POST_NOTIFICATIONS` (API 33+) | Sync reminders | Optional, caregiver opt-in |

---

## Screen Size Adaptation Strategy

| Element | Phone (≤6.5") | Tablet (7-12") | Implementation |
|---------|---------------|----------------|----------------|
| **Exercise image** | 60% screen width | 50% screen width | `LayoutBuilder` with breakpoints |
| **START button** | 80% width, 56dp height | 70% width, 64dp height | Responsive via fraction |
| **Score badge** | 180×180dp | 240×240dp | Scaled with `MediaQuery` |
| **Breathing circle** | 200dp diameter | 300dp diameter | `FractionalSizedBox` |
| **Session progress dots** | 8dp diameter | 12dp diameter | Scaled |
| **Font (body)** | 28sp (minimum) | 32sp (tablet) | Theme override per breakpoint |
| **Font (heading)** | 36sp | 42sp | Theme override |
| **Grid (content browser)** | 2 columns | 3-4 columns | `SliverGrid` with `maxCrossAxisExtent` |

### Breakpoints
```dart
class AppBreakpoints {
  static const double phone = 0;
  static const double tablet = 600;  // sw600dp
  static const double largeTablet = 840;  // sw840dp
  
  static bool isTablet(BuildContext context) =>
    MediaQuery.of(context).size.shortestSide >= tablet;
}
```

---

## Performance Considerations by Device Tier

| Scenario | Low-end (3GB) | Mid-range (4-6GB) | High-end (8GB+) |
|----------|---------------|-------------------|-----------------|
| **App cold start** | ≤4s | ≤3s | ≤2s |
| **Image loading** | ≤800ms | ≤500ms | ≤300ms |
| **Animation frame rate** | 30fps (reduce effects) | 55fps | 60fps |
| **Audio processing** | Chunk size: 200ms | Chunk size: 150ms | Chunk size: 100ms |
| **Drift query (1000 records)** | ≤150ms | ≤100ms | ≤50ms |
| **Breathing animation** | Simplified (no gradient) | Full | Full + particle effects |
| **Confetti animation** | Reduced particle count (10) | Normal (25) | Full (50) |

**Adaptation Strategy:** Detect device tier at startup → adjust animation complexity and audio buffer sizes accordingly.

```dart
DeviceTier _detectDeviceTier() {
  final totalMemory = PlatformDispatcher.instance.maxMemory; // approximate
  final cpuCores = PlatformDispatcher.instance.numberOfProcessors;
  
  if (totalMemory < 3 * 1024 * 1024 * 1024) return DeviceTier.low;
  if (totalMemory < 6 * 1024 * 1024 * 1024) return DeviceTier.mid;
  return DeviceTier.high;
}
```

---

## Input Method Considerations

| Input Type | Support | Notes |
|------------|---------|-------|
| **Touch** | ✅ Primary | All interactions via touch |
| **Voice** | ✅ Primary | Core feature — hold mic button to speak |
| **Keyboard (physical)** | ⚠️ Partial | Only for caregiver dashboard text entry |
| **Mouse/trackpad** | ⚠️ Partial | Tablet + keyboard accessory |
| **Stylus** | ⚠️ Not optimized | Works but no special support |
| **Switch/accessibility** | ⚠️ Basic | TalkBack navigation, no custom switch support |

---

## Audio Hardware Considerations

| Scenario | Challenge | Mitigation |
|----------|-----------|------------|
| **Noisy environment** | STT accuracy drops | Noise suppression pre-processing |
| **Bluetooth headset** | Mic lock, audio routing | Standard Android BT support |
| **Phone call during recording** | Audio focus loss | Pause recording, resume after call |
| **Multiple apps using mic** | Android mic lock | `twin_stream` handles this |
| **Speaker vs earpiece** | TTS output routing | Route to speaker for elderly user |
| **Hearing aid compatibility** | Audio clarity | Minimum volume level lock |

---

> **Gate Check:** PASS ✅ — Primary target (Android tablet) has full design coverage. minSdkVersion (26) covers ~95% of active devices. All hardware requirements documented. Low-end device adaptation strategy defined.
>
> **Next:** Phase 10 — Dependency Mapping
