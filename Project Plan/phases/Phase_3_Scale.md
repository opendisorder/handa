# Phase 3: Multi-Patient Scale (Month 3)

## Goal
Expand the platform from a single hardcoded patient to support multiple patients, and introduce dynamic difficulty adjustment.

## Core Features
1. **Therapist Dashboard:**
   - Web interface for human therapists or caregivers to review patient progress.
   - View generated reports, adjust AI settings, and review recorded "wins".
2. **Adaptive Difficulty:**
   - Algorithm to automatically increase difficulty if accuracy > 80% over 3 sessions.
   - Decrease difficulty if accuracy < 50% or frustration levels are consistently high.
3. **Expanded Exercise Types:**
   - Add Repetition (syllable drilling), Phrase Builder, Yes/No, and Category Naming widgets.
4. **Patient Profiles:**
   - Authentication and personalized data silos in Firebase.

## Technical Tasks
- [ ] Build Therapist Dashboard UI.
- [ ] Implement Firebase Auth for Caregivers and Patients.
- [ ] Code the adaptive difficulty logic into the state manager.
- [ ] Develop remaining widgets (`RepetitionWidget`, `PhraseBuilderWidget`, `SemanticHintWidget`).

## Success Metrics
- Platform supports multiple isolated patient profiles.
- Difficulty engine successfully scales up/down without human intervention.
