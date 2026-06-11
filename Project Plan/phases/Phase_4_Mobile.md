# Phase 4: Mobile App & Offline Mode (Month 6)

## Goal
Transition the Flutter application from a Web PWA to a fully native mobile application (Android/iOS) with robust offline capabilities.

## Core Features
1. **Native Mobile Deployment:**
   - Compile and optimize the Flutter app for Android (primary) and iOS.
   - Integrate native haptic feedback (`vibration` package) for breathing protocols.
2. **Offline Mode:**
   - Local caching of exercise packs and static assets.
   - MediaPipe continues to run offline.
   - AI responses pause, but pre-loaded exercises can continue.
3. **Family Photo Integration:**
   - Allow caregivers to upload family photos for "Famous Faces" / Personal naming exercises.
4. **Enhanced UI/UX:**
   - Mobile-first responsiveness, large touch targets, high contrast modes.

## Technical Tasks
- [ ] Migrate Web-specific APIs to native Flutter plugins (camera, mic, haptics).
- [ ] Implement local database caching (e.g., SQLite / Isar) for offline session continuity.
- [ ] Add image upload flow for Caregivers.

## Success Metrics
- App runs smoothly on low-end Android devices.
- Exercises function correctly during simulated internet outages.
