# Phase 9/15 — Device Analysis

**Status:** COMPLETE ✅

## Device Matrix

| Device | Priority | Phase | Screen | Input | Constraints | Special Considerations |
|--------|----------|-------|--------|-------|-------------|----------------------|
| Desktop/Laptop (Web PWA) | P0 | Phase 1 | Large (15-27") | Keyboard + Mouse + Mic + Camera | Always plugged in, reliable internet | Best for development + initial testing |
| Tablet (iPad/Android) | P1 | Phase 4 | Medium (10-13") | Touch + Mic + Camera | Battery, portability | Natural for patient use at home |
| Phone (Android) | P1 | Phase 4 | Small (6-7") | Touch + Mic + Camera | Battery, small screen, one-handed use | Touch targets need >48px |
| Phone (iOS) | P2 | Phase 4 | Small (6-7") | Touch + Mic + Camera | App Store review, Metal vs OpenGL | Port from Android after |

## Key Decisions
- **Primary target for MVP:** Desktop/Laptop via Web PWA (fastest iteration)
- **Phase 1:** Chrome-based desktop (MediaPipe Face Mesh works well)
- **Phase 4:** Native Flutter mobile (Android first, iOS second)
- **Mobile-first responsive design** starts in Phase 1 (desktop layout scales down)
- **Touch targets:** Minimum 48x48px, 64x64px for critical actions

## Constraints That Affect Architecture
| Constraint | Impact | Mitigation |
|------------|--------|------------|
| MediaPipe requires webcam | Desktop has webcam | Browser permission flow |
| Gemini Live needs microphone | Desktop has mic | Permission flow + fallback |
| Web PWA can't access native haptics | Breathing haptic feedback | Visual breathing animation; Phase 4 adds native haptics |
| Offline = no AI | Exercises without AI | Pre-loaded exercise packs (Phase 4) |
| Variable internet quality | Latency spikes | Gemini Live handles transient drops |

**Gate:** Mobile-first design mandated (desktop primary but responsive started) ✅
