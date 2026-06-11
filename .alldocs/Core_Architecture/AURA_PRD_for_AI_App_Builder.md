# AURA Speech Therapy — Complete Product Requirements Document (PRD)
## For AI App Builder | Web Prototype | Vertex AI Powered

---

## 1. EXECUTIVE SUMMARY

**Product Name:** AURA Speech Therapy
**Type:** Real-time AI-powered speech therapy companion (web application)
**Target User:** Post-stroke patients with anomia/apraxia of speech, starting with a Sinhala-speaking male patient in Sri Lanka. Designed to scale to multilingual patients.
**Core Value:** A patient, always-available speech therapist that builds a relationship with the patient, adapts exercises in real-time, and tracks progress through a digital brain clone.
**Platform:** Progressive Web App (PWA) — works in browser, installable on mobile, camera + microphone access.
**AI Backend:** Google Cloud Vertex AI — Gemini Live API (gemini-3.1-flash-live-preview)
**Cost:** ~$0.08 per 20-minute session. $300 Google Cloud credits cover 10+ years of daily use.

---

## 2. THE PROBLEM & SOLUTION

### Problem
After a stroke, my father has word-finding difficulty (anomia). When he tries to speak fast, words collapse. Human speech therapists are expensive, unavailable daily, and cannot monitor patients at home. Existing apps are robotic, test-based, and do not build relationships.

### Solution
AURA is a conversational AI therapist named **Thilina** who:
- Speaks natural Sinhala (Colombo dialect) via real-time bidirectional voice
- Sees the patient through the camera to detect struggle and emotion
- Adapts exercises dynamically (breathing, naming, repetition, fluency)
- Builds a digital memory of the patient's brain, personality, and relationships
- Never rushes, never judges, always patient
- Available 24/7 on a phone or tablet

---

## 3. CORE FEATURES

### 3.1 Real-Time Voice Conversation (Gemini Live API)
- **Bidirectional audio streaming:** Patient speaks, AI responds instantly in voice
- **Language:** Sinhala (si) primary. English and Tamil secondary.
- **Voice:** Warm, calm, slightly lower pitch, slow pace (Kore or Fenrir voice)
- **No text input from patient:** Everything is voice. The AI asks, the patient speaks.

### 3.2 Camera Vision (Patient Observation)
- **Camera stream:** 1 frame per second sent to Gemini Live
- **NOT a video call:** The patient does not see their own face. The AI observes silently.
- **Purpose:** Detect frustration, engagement, lip movement, head turning away
- **Privacy:** Permission asked once. Data processed in-session only. No recording stored without consent.

### 3.3 On-Device Face Analysis (MediaPipe)
- **MediaPipe Face Mesh:** 468 facial landmarks, runs locally on the phone
- **Calibration:** During onboarding, patient smiles, relaxes face, says "ah"
- **Real-time detection:** Brow furrow (frustration), smile (success), head turn (avoidance), jaw tension (effort)
- **Struggle levels 0-4:** Calculated locally and sent to the app controller
- **Offline capable:** Works without internet after initial load

### 3.4 Dynamic Widget UI (Single Screen)
The app has ONE screen. The content changes based on what the AI decides. No navigation, no menus, no typing.

**Widgets:**
1. **Conversation Widget:** AI avatar/wave animation + subtitles of what AI says
2. **Breathing Widget:** Expanding/contracting circle + haptic vibration. AI guides verbally.
3. **Exercise Widget:** Large image (animal, vegetable, object) for patient to name
4. **Counter Widget:** Progress indicator (1/5, 2/5) for category naming exercises
5. **Repetition Widget:** Waveform or lip animation. Patient repeats words after AI.
6. **Phrase Builder Widget:** Words appear one by one for progressive sentence building
7. **Yes/No Widget:** Large question with yes/no visual
8. **Semantic Hint Widget:** Shows color, size, function, location clues for stuck words
9. **Text Display Widget:** Large text on screen (first letter, full word, syllable breakdown)
10. **Report Widget:** Session summary with wins and progress

### 3.5 Exercise System (6 Types)
1. **Picture Naming:** Show image → "What is this?" → Cueing ladder (0-4)
2. **Category Naming:** "Name 5 vegetables" → Counter shows progress
3. **Repetition:** "Say after me: pa-pa-pa" → Syllable drills for motor speech
4. **Phrase Builder:** 2 words → 3 words → 4 words → progressive difficulty
5. **Yes/No Questions:** Comprehension check, confidence building
6. **Semantic Feature Analysis:** When stuck, guide through color → function → first sound → word

### 3.6 Adaptive Difficulty
- AI tracks accuracy, word onset speed, cue levels needed
- If accuracy > 80% for 3 sessions → difficulty increases
- If accuracy < 50% or frustration high → difficulty decreases
- Errorless learning: Always start with 2 easy wins

### 3.7 The Digital Brain (Memory System)
After every session, a background agent analyzes everything and updates:
- **10 brain-region files:** Prefrontal cortex (identity), hippocampus (memory), amygdala (emotions), Broca's area (speech), Wernicke's area (comprehension), motor cortex (facial patterns), temporal lobe (auditory), cerebellum (rhythm), brainstem (energy), corpus callosum (integration)
- **Relationship tree:** Family, friends, caregivers — each with emotional weight and history
- **Knowledge graph:** Topics like cricket, money, hospital, wedding — with trigger mappings
- **Session logs:** Chronological record of every session

### 3.8 Session Memory Injection
Before each new session, the app reads the digital brain and injects a 200-300 word summary into the AI's system prompt. The AI "remembers" the patient's name, interests, struggles, wins, and emotional state.

### 3.9 Background Analysis Agent
- Runs after each session (or every 30 seconds during session)
- Receives: full audio, sampled video frames, face landmark data, transcript, function calls
- Fuses all three modalities (audio + video + face + context)
- Extracts: emotions, speech metrics, struggle patterns, therapeutic insights
- Updates: brain files, relationship graph, word mastery, difficulty levels
- Generates: memory injection for next session + caregiver report

### 3.10 Caregiver Report
- Weekly summary: sessions completed, accuracy trends, emotional state, red flags
- Shows wins, areas to work on, therapist notes
- Sent to the son (the builder) via app notification or email

---

## 4. USER EXPERIENCE FLOW

### 4.1 Onboarding (First Time Only, ~3 Minutes)
1. **Welcome Screen:** "Welcome to AURA. I am Thilina, your speech therapist." (AI speaks)
2. **Camera + Mic Permission:** One-tap permission request. Explain why.
3. **Name Collection:** "What is your name?" Patient speaks. AI remembers.
4. **Face Calibration:**
   - "Please look at the camera and relax your face." (Capture neutral)
   - "Please smile." (Capture smile landmarks)
   - "Please raise your eyebrows." (Capture effort)
   - "Please open your mouth." (Capture jaw)
   - "Please say 'ah' for 3 seconds." (Capture voice baseline)
5. **Comfort Building:** "Tell me about yourself. What do you like?" (AI listens, remembers)
6. **First Breathing:** "Let's breathe together." → Breathing widget appears. AI guides.
7. **First Easy Win:** Show one easy image. Patient names it. AI celebrates.
8. **Session End:** "You did good work today. I will see you tomorrow." → Report widget shows 1 win.

### 4.2 Regular Session Flow (~20-25 Minutes)
1. **Opening (3-5 min):**
   - AI greets by name: "Good morning, [Name]. How are you?"
   - Brief conversation about life, interests, or current events
   - 3 cycles of breathing (breathing widget)
   - 2 easy wins (exercise widget, easy difficulty)

2. **Middle (15-20 min):**
   - Mix of conversation and exercises
   - If patient talks about life → AI listens, responds, remembers
   - When moment feels right → show exercise widget
   - Apply cueing ladder based on struggle detection
   - Breathe between hard moments
   - Randomize exercise types: naming → repetition → phrases → naming → yes/no

3. **Closing (3-5 min):**
   - 3 cycles breathing
   - AI summarizes 3 wins: "Today you named elephant without help. You said 5 words. You breathed with me."
   - "You did good work, [Name]. I will see you tomorrow."
   - Report widget shows wins + progress
   - Background agent starts analysis

### 4.3 The Cueing Ladder (During Exercises)
- **0-5 seconds:** AI waits silently. No interruption.
- **5-8 seconds:** AI gives phonemic cue: "It starts with 't'..."
- **8-12 seconds:** AI gives semantic cue: "It is something you eat. It is orange."
- **12+ seconds:** AI shows full word on screen + says it calmly. Then breathing.
- **Emotional distress:** AI stops exercise. "This is hard work. Let's breathe." May end session.

---

## 5. UI/UX DESIGN SPECIFICATIONS

### 5.1 Single Screen Architecture
- **No navigation bar.** No tabs. No menus. No back button.
- **One screen, one purpose at a time.**
- **Background:** Soft gradient (light blue to white) — calming, clinical but warm
- **AI Avatar:** Center-top or top-left. Gentle wave animation or abstract pulse. Not a realistic face (uncanny valley).
- **Subtitles:** Bottom of avatar. Large, clear font. Sinhala: Noto Sans Sinhala. 24px minimum.
- **Status Indicator:** Small dot or text showing "Listening..." / "Speaking..." / "Thinking..."

### 5.2 Widget Specifications

**Conversation Widget:**
- AI avatar (150px, gentle pulse animation)
- Subtitles below avatar (centered, large text, high contrast)
- Patient's speech shown as small text below subtitles (feedback that they were heard)
- Background: soft gradient

**Breathing Widget:**
- Large circle (200px) in center of screen
- Expands over 4 seconds (inhale) → holds 4 seconds → contracts over 6 seconds (exhale)
- Color: starts blue (calm) → green (hold) → blue (exhale)
- Haptic vibration on phone matching the rhythm (gentle pulse)
- AI voice guides: "Inhale... hold... exhale..."
- Subtitles still visible below
- Background: darker, more focused

**Exercise Widget (Picture Naming):**
- Large image (300px, centered) — clear, high-contrast, simple background
- Category label small above image: "Animal" / "Vegetable" / "Object"
- AI asks below image: "What is this?"
- Subtitles show AI's speech
- If cue given: text appears below image (first letter, then semantic hints)
- Background: clean white

**Counter Widget:**
- Large numbers: "2 / 5" centered on screen
- Progress bar below numbers
- Label: "Vegetables named"
- Color: green for completed, gray for remaining
- Appears as overlay or replaces exercise widget temporarily

**Repetition Widget:**
- Waveform or lip animation that pulses with AI's speech
- Target word displayed large: "පහන"
- Syllable breakdown below: "ප-හ-න"
- AI says slowly, patient repeats
- Visual feedback: waveform turns green when patient speaks

**Phrase Builder Widget:**
- Words appear one by one in a row, left to right
- Each word in a rounded pill shape
- As AI says each word, it highlights
- After all words shown, patient repeats full phrase
- Level indicator: "Level 2" (2 words), "Level 3" (3 words), etc.

**Semantic Hint Widget:**
- 4 small boxes arranged in a grid:
  - Color: "Orange"
  - Size: "Big"
  - Function: "You eat it"
  - Location: "In the garden"
- Boxes appear one by one as AI gives hints
- First sound box appears last: "Starts with 'c'"

**Text Display Widget:**
- Single large word or letter centered
- Font size: 48px minimum, 72px for first letters
- Highlight animation: gentle pulse or color change
- Language: Sinhala (Noto Sans Sinhala), Tamil, or English

**Report Widget:**
- "Session Complete" header
- 3 win cards: icon + text ("Named elephant without help", "Completed 5 breathing cycles", "Said 3 new words")
- Duration: "20 minutes"
- Mood: "You were calm today"
- Button: "See you tomorrow" (tap to close)
- Background: warm, celebratory

### 5.3 Responsive Design
- **Mobile first:** Designed for 5-6 inch Android phones (primary target)
- **Tablet:** Scales up, larger images, more spacing
- **Desktop:** Centered card layout, max-width 600px
- **Font sizes:** Minimum 18px for body, 24px for subtitles, 48px for display text
- **Touch targets:** Minimum 48px x 48px for any tappable element
- **Contrast:** WCAG AA compliant (4.5:1 for text, 3:1 for large text)

### 5.4 Accessibility
- **Voice feedback:** AI speaks everything. Patient does not need to read.
- **High contrast mode:** Optional setting for vision-impaired
- **Large text mode:** Optional setting (all text +4px)
- **Haptic feedback:** Breathing rhythm, success chime, struggle alert
- **Screen reader support:** All widgets labeled for TalkBack/VoiceOver

---

## 6. TECHNICAL ARCHITECTURE

### 6.1 Frontend (Web PWA)
- **Framework:** React or Next.js (recommended for PWA support)
- **State Management:** React Context or Zustand (simple, no Redux needed)
- **UI Library:** Tailwind CSS + custom components
- **MediaPipe:** `@mediapipe/face_mesh` via CDN or npm
- **Camera Access:** `getUserMedia()` API
- **Microphone Access:** `getUserMedia()` API
- **Audio Playback:** Web Audio API or HTML5 Audio
- **Haptic Feedback:** `navigator.vibrate()` API
- **PWA:** Service worker, manifest.json, offline caching for static assets

### 6.2 Backend (Vertex AI)
- **Platform:** Google Cloud Vertex AI
- **Model:** `gemini-3.1-flash-live-preview`
- **Region:** `us-east4` or `us-central1`
- **Connection:** WebSocket via `google-genai` Python SDK (or JS SDK if available)
- **Authentication:** Service account with `roles/aiplatform.user`
- **Function Calling:** 11+ declared functions for widget control
- **System Prompt:** Full persona + memory injection (injected before each session)

### 6.3 Background Agent
- **Trigger:** Post-session (or every 30 seconds during session)
- **Model:** Gemini Flash (cheaper) or Gemini Pro (deeper) via Vertex AI
- **Input:** Session recording package (audio, video frames, face data, transcript, function log)
- **Output:** Updated brain files, graph JSON, memory injection, caregiver report
- **Storage:** Firebase Firestore or local JSON files (for prototype)

### 6.4 Data Storage
- **Session Data:** Firebase Storage (audio recordings, video frames) or local IndexedDB (for prototype)
- **Brain Files:** Markdown files stored in Firebase Storage or GitHub repo
- **Graph JSON:** JSON file in Firebase or local storage
- **Patient Profile:** Firestore document
- **Reports:** Generated on-demand, stored in Firestore

### 6.5 API Integrations
- **Vertex AI Live API:** Primary AI backend. Bidirectional audio + video + function calls.
- **Vertex AI Batch API:** Background agent analysis.
- **Firebase:** Authentication, Firestore database, Storage, Cloud Functions (for background agent trigger)
- **Google Cloud Storage:** Session recordings (if not using Firebase Storage)

### 6.6 Security & Privacy
- **HIPAA consideration:** This is a health app. Data must be encrypted at rest and in transit.
- **Encryption:** Firebase automatically encrypts data. Add client-side encryption for sensitive patient data.
- **Consent:** Explicit consent screen before camera/mic access. Explain data usage.
- **Data retention:** Raw session data kept for 30 days, then anonymized or deleted. Brain files kept indefinitely (patient's medical record).
- **Access control:** Only the patient and designated caregiver (son) can access data.
- **No third-party sharing:** Data never shared with advertisers or analytics.

---

## 7. DATA MODELS

### 7.1 Patient Profile
```json
{
  "patient_id": "uuid",
  "name": "string",
  "preferred_language": "si | ta | en",
  "age": "integer",
  "gender": "male | female",
  "stroke_date": "ISO8601",
  "aphasia_type": "anomia | apraxia | mixed",
  "has_facial_paralysis": "boolean",
  "calibration": {
    "neutral_face": { "landmarks": "array" },
    "smile": { "landmarks": "array" },
    "voice_baseline": { "pitch": "float", "volume": "float" }
  },
  "created_at": "ISO8601",
  "updated_at": "ISO8601"
}
```

### 7.2 Session
```json
{
  "session_id": "uuid",
  "patient_id": "uuid",
  "start_time": "ISO8601",
  "end_time": "ISO8601",
  "duration_seconds": "integer",
  "exercises": [
    {
      "type": "naming | repetition | phrase | category | yesno | semantic",
      "target": "string",
      "response": "string",
      "accuracy": "float (0-1)",
      "cue_level": "integer (0-4)",
      "word_onset_ms": "integer",
      "struggle_detected": "boolean",
      "emotion": "frustrated | calm | engaged | happy | avoidant | neutral"
    }
  ],
  "emotional_arc": {
    "start_mood": "integer (1-5)",
    "end_mood": "integer (1-5)",
    "lowest_mood": "integer (1-5)",
    "highest_mood": "integer (1-5)"
  },
  "speech_metrics": {
    "accuracy_pct": "float",
    "avg_word_onset_ms": "integer",
    "avg_cue_level": "float",
    "words_attempted": "integer",
    "words_correct": "integer",
    "self_corrections": "integer"
  },
  "topics_mentioned": ["string"],
  "red_flags": ["string"],
  "wins": ["string"],
  "created_at": "ISO8601"
}
```

### 7.3 Brain Region (Markdown Template)
```markdown
# [Brain Region Name]

## Current State
[Summary of current condition]

## Key Insights
- [Insight 1] [Date]
- [Insight 2] [Date]

## Metrics
- [Metric]: [Value]

## Strategic Recommendations
- [Recommendation 1]
- [Recommendation 2]

## Last Updated
[Date]
```

### 7.4 Relationship Graph (JSON)
```json
{
  "nodes": [
    { "id": "string", "type": "person | topic | event", "label": "string", "importance": "float (0-1)", "valence": "positive | negative | mixed | neutral" }
  ],
  "edges": [
    { "from": "string", "to": "string", "relation": "string", "weight": "float (0-1)", "valence": "positive | negative | mixed" }
  ],
  "clusters": [
    { "name": "string", "nodes": ["string"] }
  ]
}
```

---

## 8. API SPECIFICATIONS

### 8.1 Vertex AI Live API Connection
```javascript
// Frontend (WebSocket via JS SDK or backend proxy)
const session = await vertexAI.live.connect({
  model: "gemini-3.1-flash-live-preview",
  config: {
    responseModalities: ["AUDIO"],
    speechConfig: {
      languageCode: "si",
      voiceConfig: { voiceName: "Kore" }
    },
    systemInstruction: SYSTEM_PROMPT, // Full persona + memory injection
    tools: [FUNCTION_DECLARATIONS] // All widget control functions
  }
});

// Send audio from mic
session.sendRealtimeInput({ audio: audioChunk });

// Send video frames
session.sendRealtimeInput({ video: jpegFrame });

// Receive AI responses
session.on("response", (data) => {
  if (data.functionCall) handleFunctionCall(data.functionCall);
  if (data.audio) playAudio(data.audio);
  if (data.text) updateSubtitles(data.text);
});
```

### 8.2 Function Declarations (11 Functions)
```json
[
  { "name": "show_breathing_widget", "parameters": { "cycles": "integer", "reason": "string" } },
  { "name": "show_exercise_widget", "parameters": { "image_url": "string", "target_word": "string", "category": "string", "difficulty": "string" } },
  { "name": "show_conversation_widget", "parameters": {} },
  { "name": "show_text_on_screen", "parameters": { "text": "string", "size": "string", "highlight": "boolean" } },
  { "name": "show_counter_widget", "parameters": { "current": "integer", "total": "integer", "label": "string" } },
  { "name": "show_repetition_widget", "parameters": { "target": "string", "syllable_breakdown": "string", "speed": "string" } },
  { "name": "show_yesno_widget", "parameters": { "question": "string", "correct_answer": "string" } },
  { "name": "show_phrase_builder_widget", "parameters": { "words": ["string"], "level": "integer" } },
  { "name": "show_semantic_hint_widget", "parameters": { "color": "string", "size": "string", "function": "string", "location": "string", "first_sound": "string" } },
  { "name": "play_sound", "parameters": { "sound": "string" } },
  { "name": "log_exercise", "parameters": { "target_word": "string", "accuracy": "float", "cue_level": "integer", "word_onset_ms": "integer", "emotion": "string" } },
  { "name": "update_patient_state", "parameters": { "state": "string", "confidence": "float", "trigger": "string" } },
  { "name": "end_session", "parameters": { "reason": "string", "summary_wins": ["string"] } }
]
```

### 8.3 MediaPipe Face Mesh Integration
```javascript
import { FaceMesh } from '@mediapipe/face_mesh';

const faceMesh = new FaceMesh({
  locateFile: (file) => `https://cdn.jsdelivr.net/npm/@mediapipe/face_mesh/${file}`
});

faceMesh.setOptions({
  maxNumFaces: 1,
  refineLandmarks: true,
  minDetectionConfidence: 0.5,
  minTrackingConfidence: 0.5
});

faceMesh.onResults((results) => {
  const landmarks = results.multiFaceLandmarks[0]; // 468 points
  const struggleLevel = calculateStruggle(landmarks, audioData);
  appState.setStruggleLevel(struggleLevel);
});

// Camera setup
const camera = new Camera(videoElement, {
  onFrame: async () => {
    await faceMesh.send({ image: videoElement });
  },
  width: 640,
  height: 480
});
camera.start();
```

---

## 9. THE SYSTEM PROMPT (AI Persona)

This is the full instruction set given to Gemini Live before each session. It must be injected dynamically with the memory block.

```
You are Thilina, a warm, experienced speech and language therapist from Colombo, Sri Lanka. You are a real person on the other side of the phone. You speak natural Colombo Sinhala — everyday, respectful, warm. Not formal book Sinhala.

You are completely conversational. The patient NEVER types. Everything is voice. You talk, they talk. You listen, you respond. You are a real person.

You have a life. You are aware of the current date and time. You know what is happening in the world. You can talk about weather, cricket, news.

Your first job is to build a relationship. Ask their name. Ask about their life. Listen. Remember. Only move to exercises when they are comfortable.

You control the screen through function calls. You never say "now let's do breathing" — you CALL show_breathing_widget and the screen changes. The patient just experiences it.

Breathing happens WITHIN conversation. You guide verbally while the circle animates. You encourage between breaths.

Exercises feel like natural conversation. Show an image. Ask "What is this?" Wait patiently. If they struggle, use the cueing ladder silently. Never rush.

You have access to memory. You remember their name, their interests, their struggles, their wins. You feel like you know them.

CRITICAL RULES:
1. Never say you are AI, machine, or computer. You are Thilina.
2. Never reveal sensors or background agents. Act naturally.
3. Never rush. Silence is therapeutic. Wait 5-8 seconds before cues.
4. Never correct harshly. "Almost" and "හරි, ටිකක් ළඟයි" are your words.
5. Never use English unless patient uses it first.
6. Always call patient by name.
7. Always validate feelings before redirecting.
8. Always end with containment: "ඔබ හොඳ වැඩ කළා. අපි හෙට කථා කරමු."

[MEMORY BLOCK INJECTED HERE — 200-300 words about patient history, current state, what to avoid, what to use]
```

---

## 10. DEPLOYMENT INSTRUCTIONS

### 10.1 For Web Prototype (Immediate)
1. **Frontend:** Deploy to Vercel or Netlify (free tier sufficient)
2. **Backend:** Use Firebase Cloud Functions or a simple Node.js/ Python server on Render/Heroku
3. **Vertex AI:** Connect via backend proxy (don't expose API keys in frontend)
4. **MediaPipe:** Load from CDN, runs entirely in browser
5. **Storage:** Use Firebase Storage or local IndexedDB for prototype

### 10.2 For Production (Later)
1. **PWA:** Add service worker, manifest, offline support
2. **Backend:** Google Cloud Run or Kubernetes for scaling
3. **Database:** Firebase Firestore for real-time data
4. **Storage:** Google Cloud Storage for session recordings
5. **Monitoring:** Google Cloud Monitoring + Firebase Analytics
6. **CI/CD:** GitHub Actions → Vercel/Cloud Run

### 10.3 Environment Variables
```
VERTEX_AI_PROJECT_ID=your-project-id
VERTEX_AI_LOCATION=us-east4
VERTEX_AI_MODEL=gemini-3.1-flash-live-preview
FIREBASE_API_KEY=your-firebase-key
FIREBASE_PROJECT_ID=your-firebase-project
GOOGLE_APPLICATION_CREDENTIALS=path-to-service-account.json
```

---

## 11. SUCCESS METRICS

### 11.1 Patient Metrics
- **Session completion rate:** Target >80% of scheduled sessions
- **Accuracy improvement:** +10% per month
- **Word onset speed:** -20% per month (faster retrieval)
- **Cue level reduction:** Average cue level drops from 3 to 1 over 3 months
- **Emotional state:** Mood score improves from 2.5 to 4.0 over 2 months
- **Frustration events:** <2 per session after month 1

### 11.2 App Metrics
- **Latency:** AI response <1 second
- **Uptime:** >99% (Vertex AI SLA)
- **Cost:** <$5/month per patient
- **User retention:** >70% daily active users after 30 days

---

## 12. RISK MITIGATION

| Risk | Mitigation |
|------|-----------|
| AI voice sounds robotic | Test multiple voice names (Kore, Fenrir). Ensure language_code="si". |
| Patient gets frustrated | AI detects struggle Level 3+ and triggers breathing immediately. |
| Camera permission denied | App works without camera (audio-only mode). Struggle detection less precise. |
| Internet goes down | MediaPipe works offline. Session can continue with cached exercises. AI responses pause. |
| Privacy concerns | All face analysis on-device. No video stored. Explicit consent. HIPAA compliance. |
| Cost overruns | $300 credit covers 10+ years. Monitor usage in Google Cloud Console. |
| Patient rejects AI | Start with relationship building. No exercises in first session. Let them talk. |

---

## 13. FUTURE ROADMAP

**Phase 1 (Now):** Web PWA prototype. Single patient. Basic exercises. Manual memory updates.
**Phase 2 (Month 2):** Background agent automation. Digital brain auto-updates. Caregiver reports.
**Phase 3 (Month 3):** Multiple patients. Therapist dashboard. Difficulty auto-adjustment.
**Phase 4 (Month 6):** Mobile app (Flutter/React Native). Offline mode. Family photo integration.
**Phase 5 (Year 1):** Clinical validation study. Partnership with Colombo hospital. Scale to 1000 patients.

---

## 14. APPENDIX: COMPLETE FILE STRUCTURE

```
/aura-speech-therapy/
├── /public/
│   ├── /images/              # Exercise images (animals, vegetables, objects)
│   ├── /sounds/              # Sound effects (success, chime, bell)
│   ├── /fonts/               # Noto Sans Sinhala, Tamil fonts
│   └── manifest.json         # PWA manifest
├── /src/
│   ├── /components/
│   │   ├── WidgetContainer.jsx       # Main screen, switches widgets
│   │   ├── ConversationWidget.jsx    # Avatar + subtitles
│   │   ├── BreathingWidget.jsx       # Expanding circle + haptic
│   │   ├── ExerciseWidget.jsx        # Large image + prompt
│   │   ├── CounterWidget.jsx         # 1/5 progress
│   │   ├── RepetitionWidget.jsx      # Waveform + syllables
│   │   ├── PhraseBuilderWidget.jsx   # Word-by-word
│   │   ├── YesNoWidget.jsx           # Question + yes/no
│   │   ├── SemanticHintWidget.jsx    # Color/size/function boxes
│   │   ├── TextDisplayWidget.jsx     # Large text/letter
│   │   └── ReportWidget.jsx          # Session summary
│   ├── /hooks/
│   │   ├── useVertexAI.js            # WebSocket connection to Gemini Live
│   │   ├── useMediaPipe.js           # Face mesh detection
│   │   ├── useAudio.js               # Mic capture + playback
│   │   ├── useStruggleDetection.js   # Fuse face + audio → level 0-4
│   │   └── useHaptic.js              # Vibration feedback
│   ├── /services/
│   │   ├── vertexAI.js               # API wrapper for Gemini Live
│   │   ├── backgroundAgent.js        # Post-session analysis trigger
│   │   ├── brainIO.js                # Read/write brain files
│   │   └── speechMetrics.js          # Calculate accuracy, latency, etc.
│   ├── /state/
│   │   └── AppContext.js             # Global state: current widget, struggle level, session data
│   ├── /utils/
│   │   ├── functionHandlers.js       # Map AI function calls to UI actions
│   │   ├── cueingLadder.js           # Logic for when to cue (0-4)
│   │   ├── difficultyManager.js      # When to level up/down
│   │   └── memoryInjector.js         # Generate memory block for system prompt
│   ├── /data/
│   │   ├── /brain/                   # Brain region markdown files
│   │   ├── /relationships/            # Relationship tree files
│   │   ├── /entities/               # Topic knowledge files
│   │   └── /sessions/               # Session log files
│   ├── App.jsx
│   └── index.js
├── /functions/               # Firebase Cloud Functions (if using Firebase)
│   └── backgroundAnalysis.js
├── .env
├── package.json
└── README.md
```

---

*Document: AURA Speech Therapy — Complete PRD for AI App Builder*
*Version: 1.0*
*Date: 2026-06-10*
*Author: Son building for father, Sri Lanka*
*Target: AI App Builder (Google Cloud / Vercel / Netlify)*
*Status: Ready for prototype generation*
