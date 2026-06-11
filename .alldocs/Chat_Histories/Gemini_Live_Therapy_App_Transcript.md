User:

user_pasted_clipboard_long_content_as_file_Yes.Ifyourgoalisnotmerelytobuildanapp,bu.txt

Complete App Experience — Father’s Stroke Rehabilitation App.md

This is a beautifully purposeful app to build. Here’s the complete architecture combining both modes.

Complete App Architecture

Two Core Therapy Modes│├── Mode 1: Picture Naming (Gemini 2.5 Flash)│     Show image → Father speaks → Score → Feedback → Breathe → Next│└── Mode 2: Live Conversation (Gemini Live 2.5 Flash Native Audio)      AI speaks exercise → Father responds → AI tracks & coaches → Report

Mode 1 — Picture Naming (Already Discussed)

Quick summary of the stack:

Layer

Tool

Speech input

Google Speech-to-Text

Evaluation

Gemini 2.5 Flash

TTS (word playback)

Google Cloud TTS

DB

Hive / SQLite

UI

Flutter

Mode 2 — Live Conversation Exercises

This is where Gemini Live API (gemini-live-2.5-flash-native-audio) becomes essential.

How it works in Flutter

// Simplified connection flowfinal session = await GeminiLive.connect(  model: 'gemini-live-2.5-flash-native-audio',  systemPrompt: therapySystemPrompt,  language: 'si-LK', // Sinhala primary);// Stream microphone audio → Gemini// Receive Gemini audio response → speaker

The connection stays open the entire session — Gemini listens continuously, tracks answers, and responds adaptively.

The 10 Live Exercises

Exercise 1 — Category Naming

Gemini: "කරුණාකර පළතුරු 10ක් නම් කරන්න."        ("Please name 10 fruits.")Father: "ඇපල්... කෙසෙල්... අඹ..."Gemini tracks:  ✅ Valid fruits named  🔁 Repeated fruits  ⏱ Pause duration  🗣 Speech confidenceGemini: "හොඳයි. ඔබ 7ක් කිව්වා. තව 3ක් කිව හැකිද?"        ("Good. You named 7. Can you try 3 more?")

Exercise 2 — Letter Fluency

Gemini: "'ක' අකුරෙන් පටන් ගන්නා වචන කරුණාකර කියන්න."        ("Say words beginning with 'ක'.")Father: "කෙසෙල්... කඩදාසි... කාමරය..."Gemini validates each word is real and starts with 'ක'.

Exercise 3 — Memory Recall

Gemini: "මේ වචන 3 මතක තබා ගන්න:         ඇපල් — පුටුව — වතුර"         ("Remember these 3 words: Apple, Chair, Water")[2 minute breathing exercise shown on screen]Gemini: "ඔබ මතක තබාගත් වචන 3 කියන්න."        ("Tell me the 3 words you remembered.")

Exercise 4 — Object Description

Gemini: "අඹ ගැන විස්තර කරන්න."        ("Describe a mango.")Father: "කහ පාට... මිහිරි..."        ("Yellow... sweet...")Gemini evaluates semantic accuracy, not exact wording.

Exercise 5 — Daily Communication

Gemini: "ඔබට වතුර ඕනෑ නම් කුමක් කියනවාද?"        ("What would you say if you wanted water?")Father: "මට වතුර ඕනෑ."        ("I want water.")

Exercise 6 — Sentence Building

Gemini: "'ඇපල්' යන වචනය භාවිතා කර වාක්‍යයක් හදන්න."        ("Make a sentence using 'ඇපල්'.")Father: "මම ඇපල් කනවා."        ("I eat an apple.")Gemini scores: grammar + clarity + fluency

Exercise 7 — Opposites

Gemini: "උණුසුම් වල විරුද්ධ පදය කුමක්ද?"        ("What is the opposite of hot?")Father: "සීතල."        ("Cold.")

Exercise 8 — Following Instructions

Gemini: "ඔබේ නාසය ස්පර්ශ කර, ඔබේ නම කියන්න."        ("Touch your nose, then say your name.")Tests: comprehension + action + speech combined.

Exercise 9 — Breathing + Speech Control

Gemini: "දිගු හුස්මක් ගන්න."        ("Take a deep breath.")[Breathing animation: expand 4s → hold 2s → contract 4s]Gemini: "දැන් සෙමෙන් කියන්න:          ත-ර-බූ-ස"        ("Now slowly say: Wa-ter-me-lon")

Exercise 10 — Story Completion

Gemini: "පිරිමි ළමයෙකු වෙළඳපළට ගොස් මිලදී ගත්තේ..."        ("A boy went to the market and bought...")Father continues the story.Gemini evaluates language generation + creativity.

System Prompt for Gemini Live

This is the most important part. You set Gemini’s personality once at connection:

You are a gentle, patient Sinhala speech therapist working with a stroke recovery patient. Rules:- Always speak Sinhala first- Speak slowly and clearly- Never say "wrong" — say "try again" or "almost"- Celebrate every attempt, not just correct answers- After every correct answer, guide a short breathing exercise- Track all answers silently and give a summary at the end- If the patient pauses more than 8 seconds, gently encourage them- Difficulty adapts based on performanceCurrent exercise: [EXERCISE_NAME]Expected responses: [WORD_LIST or EXERCISE_DETAILS]Session language mode: Sinhala → Tamil → English

Full Flutter Architecture

lib/├── main.dart├── modes/│   ├── picture_mode/│   │   ├── picture_screen.dart│   │   ├── speech_evaluator.dart       ← Gemini 2.5 Flash│   │   └── word_card.dart│   └── live_mode/│       ├── live_session_screen.dart    ← Gemini Live API│       ├── exercise_selector.dart│       └── session_tracker.dart├── shared/│   ├── breathing_animation.dart        ← After every correct answer│   ├── vibration_service.dart│   └── tts_service.dart├── data/│   ├── word_database.dart              ← Sinhala/Tamil/English words│   └── progress_repository.dart└── caregiver/    └── dashboard_screen.dart           ← PIN-protected for you

Session Flow (Live Mode)

Home Screen     ↓Select Exercise(Category Naming / Memory / Story / etc.)     ↓Select Language Mode(Sinhala / Mixed / Full Random)     ↓Gemini Live connects     ↓Breathing intro animation (calm the patient)     ↓Exercise begins     ↓Father speaks → Gemini listens continuously     ↓Gemini coaches in real time     ↓Breathing break mid-session (every 5 answers)     ↓Session ends → Summary shown     ↓Progress saved to database

API Cost Estimate

Model

Use

Cost

Gemini 2.5 Flash

Picture evaluation

Very low per call

Gemini Live 2.5 Flash Native Audio

Live sessions

Per minute of audio

Google Speech-to-Text

Picture mode input

Per 15-second chunk

Google Cloud TTS

Word playback

Per character

For daily personal use, the total cost would be very low — likely under $5/month.

Recommended Build Order

Week 1–2: Picture naming mode (Mode 1) with Sinhala only, breathing animation, mistake counter

Week 3: Add Tamil + English to picture mode, language progression logic

Week 4: Integrate Gemini Live for Category Naming exercise only

Week 5+: Add remaining 9 live exercises one by one, caregiver dashboard

Starting with Mode 1 means your father can begin therapy immediately while you build Mode 2 in parallel. The breathing animation after every correct answer is worth prioritizing early — it sets the calm, therapeutic tone the entire app is built around.This document covers everything from the moment the app opens to the last screen of the day. A few things worth highlighting from the deeper thinking:

The breathing exercises are load-bearing, not decorative. They appear before sessions, after every correct answer (micro), at mid-session, and at the end. For stroke patients, anxiety physically tightens the throat and jaw — making speech harder. The breathing isn’t just calming; it’s directly improving his ability to speak.

The four-outcome scoring system is clinically important. A strict pass/fail would be psychologically damaging. Aphasia patients know what they want to say — rewarding “almost” answers tells his brain the effort is valid, which maintains motivation over weeks and months.

The adaptive difficulty ratio (40% mastered / 40% practicing / 20% new) ensures every session starts with words he can already do well. This is called a “confidence anchor” — it means he never starts cold and frustrated.

The caregiver dashboard PDF export is genuinely useful if he ever sees a neurologist or speech therapist. Real progress data from weeks of daily practice is valuable clinical information.

The offline fallback matters more than it seems — if the internet drops mid-session and the app crashes or freezes, that one bad experience can make an elderly patient distrust the app entirely. Graceful offline degradation protects the therapy relationship.

The document is saved and you can reference it as you build each screen. Want me to start on any specific screen’s Flutter code, the Gemini prompts, or the database schema?Can you also think deep and explain the app experience co.plwtely as wrllI want to create Android mobile application for my father. He’s having a problem with brain stroke. Where he can’t quickly say things right? So I want to I wanted to show a picture of a vegetable of a fruit of an object. Likewise, so whenever he says that object properly, I won the application to capture that. So only if he says properly. It should have moved to the next object. And then it should count how many dame’s each.He made a mistakeThis is actually a very practical and clinically relevant app idea. What you’re describing is similar to a simplified speech therapy / aphasia rehabilitation application used for stroke recovery.

Core Goal

Your father sees an image:

🍎 Apple

He tries to say:

“Apple”

The app listens.

If pronunciation is close enough → ✅ Correct → move to next image.

If pronunciation is incorrect → ❌ Stay on same image.

Increment mistake counter.

Allow repeated attempts.

Store progress over time.

App Workflow

Exercise Session

Show Image ↓ User Speaks ↓ Speech Recognition ↓ Compare Result ↓ Correct? /Yes No ↓ ↓ Next Count Error Image Retry Same Image

Example Session

Card 1

Image:

🍌 Banana

Expected word:

banana

Father says:

banana

Result:

Match = 98%

Move next.

Card 2

Image:

🥕 Carrot

Father says:

carot

Result:

Match = 70%

Threshold:

85%

Output:

Mistakes: 1 Try Again

Stay on carrot.

Data To Store

Each object should contain:

{ “id”: 1, “image”: “apple.png”, “word”: “apple”, “category”: “fruits” }

Statistics Dashboard

Store:

{ “date”: “2026-06-09”, “total_words”: 50, “correct”: 40, “mistakes”: 10 }

Progress Tracking

For every word:

{ “word”: “banana”, “attempts”: 12, “correct”: 9, “mistakes”: 3 }

Then you’ll know:

Which words are difficult

Which words improved

Which words need more practice

Categories

You can organize exercises into:

Fruits

🍎 Apple

🍌 Banana

🍇 Grapes

🍉 Watermelon

Vegetables

🥕 Carrot

🥔 Potato

🧅 Onion

🍅 Tomato

Household Objects

🪑 Chair

🚪 Door

🛏 Bed

📱 Phone

Family

👨 Father

👩 Mother

👦 Son

👧 Daughter

Daily Activities

🚶 Walk

🍽 Eat

💧 Drink

😴 Sleep

Better Than Normal Speech Recognition

Aphasia and stroke patients often produce partially correct speech.

Instead of exact matching:

apple == apple

Use similarity scoring:

apple appel aple

Calculate:

Similarity Score

Examples:

95% = Correct 90% = Correct 84% = Retry

This makes the app much more forgiving.

Features Worth Adding

Replay Button

Press speaker icon.

App says:

“Apple”

Father hears the correct pronunciation.

Slow Pronunciation

Ap…ple

Helpful for stroke rehabilitation.

Syllable Mode

Instead of:

Watermelon

Teach:

Wa Ter Melon

Then combine.

Caregiver Dashboard

You can see:

Today’s score

Weekly score

Improvement %

Hardest words

Custom Family Photos

Instead of generic images:

Show:

Actual wife

Actual son

Actual house

This can improve engagement and real-world communication practice.

Technology Stack

For Android:

Frontend

Flutter (recommended) or

React Native

Speech Recognition

Google’s Android Speech Recognition

Offline speech recognition model:

Vosk Speech Recognition

Local Database

SQLite

Hive (Flutter)

Progress Charts

FL Chart (Flutter)

Advanced Version (Much Better)

Instead of checking only the recognized word:

Use an AI speech assessment model.

The app analyzes:

Pronunciation accuracy

Missing syllables

Speaking speed

Speech clarity

Then gives:

Apple Pronunciation: 78% Clarity: 82% Speed: Slow

This is closer to professional speech therapy software.

Recommended MVP (Version 1)

Start simple:

100 images.

One expected word per image.

Speech-to-text.

Similarity matching.

Correct → next card.

Wrong → retry.

Mistake counter.

Daily progress tracking.

This can be built in Flutter in a relatively short time and would already provide meaningful speech practice for a stroke survivor.It should be sinhala because of his 1st language and difficulty level next tamil and English randomly and after every right I need to have animation and vibration laptop feedback for breath in and out so he will be calmThat changes the design significantly, and it can actually make the rehabilitation experience much more effective for your father.

Therapy Goals

Your app would be combining:

Speech rehabilitation (stroke recovery)

Language rehabilitation (Sinhala → Tamil → English)

Memory stimulation

Attention training

Anxiety reduction through guided breathing

Positive reinforcement

Recommended Flow

Screen 1

Show:

🍎 (Apple image)

Text:

ඇපල්

Voice:

“මේ මොකක්ද?” (“What is this?”)

Father says:

ඇපල්

Recognition checks pronunciation.

Correct Answer

Immediately:

✅ Green glow

✅ Gentle vibration

✅ Pleasant success sound

✅ Encouraging message

හොඳයි!

(“Good!”)

Then:

Breathing Animation

A circle expands.

හුස්ම ගන්න…

(Breathe in)

4 seconds

Circle contracts.

හුස්ම පිට කරන්න…

(Breathe out)

4 seconds

Only then move to the next card.

This prevents rushing and helps keep stress low.

Language Progression

Instead of random languages from the start, I would recommend progressive difficulty.

Level 1

Sinhala only

අඹ කෙසෙල් අල

Level 2

Sinhala + Tamil

අඹ மாம்பழம்

Level 3

Sinhala + English

අඹ Mango

Level 4

Mixed Random

Card 1:

අඹ

Card 2:

Mango

Card 3:

மாம்பழம்

Card 4:

අඹ

This becomes a cognitive exercise as well.

Categories

Fruits

🍎 🍌 🍉

Vegetables

🥕 🥔 🧅

Family Members

👨 👩 👦

Household Objects

🚪 🪑 📺

Actions

🚶 Walking

🍽 Eating

😴 Sleeping

These are often useful for stroke patients because they reinforce everyday communication.

Mistake Tracking

For each item:

{ “word”: “කෙසෙල්”, “attempts”: 20, “correct”: 15, “mistakes”: 5 }

The app can identify difficult words automatically.

Daily Report

Example:

Today’s Session

Correct: 45 Mistakes: 12

Best Category: Fruits

Needs Practice: Household Objects

Average Accuracy: 79%

Caregiver Mode

You could have a hidden caregiver screen protected by PIN.

It shows:

Weekly improvement

Speech accuracy trend

Difficult words

Session duration

Number of completed exercises

This helps track recovery over months.

Important Stroke-Recovery Features

Large UI

Very large buttons.

Very large images.

Minimal clutter.

High Contrast

Dark text.

Bright images.

Simple backgrounds.

Voice Playback

Tap speaker.

App says the word in Sinhala.

Useful if reading is difficult.

Offline Mode

I strongly recommend offline speech recognition.

Many elderly users become frustrated if internet issues interrupt therapy.

A good option is:

Vosk Speech Recognition

combined with Sinhala speech models if available, or a custom pronunciation-checking layer.

One Improvement I’d Add

Don’t only check “correct or incorrect.”

Use 4 levels:

Excellent (90-100%) Good (75-89%) Almost (60-74%) Try Again (<60%)

For stroke rehabilitation, rewarding partial success is often more motivating than a strict pass/fail system.

A particularly strong version of this app would feel less like a test and more like a calm therapy companion: large picture → speak → positive feedback → breathing animation → next picture → progress tracking. That combination targets speech, memory, language, and emotional regulation in a single daily exercise.I want to use Gemini api so research and tell me which model and everythingFor your father’s rehabilitation app, I would not use a single Gemini model for everything.

The best architecture is:

Layer 1 — Speech Recognition (Critical)

Use:

Google Cloud Speech-to-Text

Reason:

Designed specifically for speech recognition.

Lower latency than sending every audio clip through Gemini.

Better for short words like fruits, vegetables, household objects.

Supports multilingual speech recognition.

Layer 2 — AI Evaluation

Use:

Google AI Studio

Model: Gemini 2.5 Flash

Gemini can analyze audio, transcribe speech, detect language, and understand pronunciation context from audio input.

For example:

Expected:

කෙසෙල්

Recognized:

කෙසෙල්

Gemini prompt:

You are a speech therapist.

Expected word: කෙසෙල් Recognized speech: කෙසෙල්

Return:

{ score: 0-100, correct: true/false, feedback: “” }

My Recommended Stack

MVP Version

Speech Recognition

Google Speech-to-Text

AI Logic

Gemini 2.5 Flash

Mobile

Flutter

Database

Hive

Analytics

SQLite

Text To Speech

Android TTS

or

Google Cloud Text-to-Speech

If You Want Real-Time Listening

Suppose your father says:

ඇපල්

and you want feedback immediately while speaking.

Use:

Gemini Live API

Model:

gemini-live-2.5-flash-native-audio

This model is Google’s native audio conversation model and supports real-time audio interactions, emotion-aware dialogue, and audio streaming.

However:

For a rehabilitation app, I would still choose Speech-to-Text + Gemini rather than Live API because:

Simpler

Cheaper

More stable

Easier to score pronunciation

Sinhala-Specific Design

The biggest challenge is not Gemini.

The biggest challenge is:

Sinhala Aphasia Recognition

Stroke patients often say:

ඇප…

instead of

ඇපල්

or

අපල්

instead of

ඇපල්

A normal speech recognizer marks this wrong.

You need a custom scoring system:

Expected: ඇපල් Actual: අපල්

Similarity: 85%

Then:

Good attempt

instead of:

Wrong

This is extremely important psychologically.

Therapy AI Prompt

I would actually make Gemini behave like a speech therapist.

Prompt:

You are a stroke rehabilitation speech therapist.

Expected language: Sinhala

Expected word: කෙසෙල්

Recognized speech: 

Evaluate:

Pronunciation similarity (0-100)

Is it understandable?

Is it close enough to count as success?

Give one short encouraging response.

Return JSON only.

Gemini 2.5 Flash is ideal for this workload because it is fast, multimodal, and inexpensive compared with Pro models.

My Production Recommendation

For Version 1:

Flutter ↓ Speech-to-Text ↓ Gemini 2.5 Flash ↓ Scoring Engine ↓ Animation ↓ Vibration ↓ Breathing Exercise ↓ Next Card

For Version 2:

Flutter ↓ Gemini Live Native Audio ↓ Real-time coaching ↓ Emotion detection ↓ Adaptive difficulty

One feature I would strongly add for stroke recovery is an adaptive difficulty engine.

If he gets “Apple” right 10 times in a row:

Apple → mastered

The app automatically introduces:

Pineapple Watermelon Pomegranate

And later:

“මට වතුර ඕන” (I want water)

“මට බඩගිනියි” (I am hungry)

Moving from single words → phrases → full daily communication is often where the greatest practical benefit appears for stroke survivors.And live api for asking him to name 10 fruits or veg or likewise without images and other exercises as wellFor that use case, the Gemini Live API becomes much more valuable because you’re moving beyond simple pronunciation checking into interactive cognitive and speech therapy.

Your app could have two distinct modes:

Mode 1: Picture Naming Therapy

Goal:

Visual recognition

Word retrieval

Pronunciation practice

Example:

Show 🍎

Expected:

“ඇපල්”

The system checks correctness and pronunciation.

For this mode, standard speech recognition + Gemini evaluation is usually enough.

Mode 2: Conversational Therapy (Gemini Live)

Goal:

Word recall

Category fluency

Memory

Language switching

Sentence formation

Example:

AI says:

“Please name 10 fruits.”

Father answers:

“Apple, banana, mango…”

Gemini listens continuously and tracks:

Total valid fruits

Repeated fruits

Incorrect answers

Pauses

Speech confidence

Then responds:

“Good. You named 8 fruits. Can you think of two more?”

Stroke Rehabilitation Exercises Gemini Live Can Run

Category Naming

AI:

“Name 10 vegetables.”

AI tracks:

Unique answers

Response speed

Accuracy

This is a common neuropsychological exercise.

Letter Fluency

AI:

“Tell me words beginning with ‘ක’.”

Examples:

කෙසෙල්

කඩදාසි

කමිසය

Gemini can verify them.

Memory Recall

AI:

“Remember these words:

Apple Chair Water”

After 2 minutes:

“Can you tell me the three words?”

This trains working memory.

Object Description

AI:

“Describe a mango.”

Expected:

“Yellow fruit.”

“Sweet.”

“Has a seed.”

Gemini evaluates semantic understanding rather than exact wording.

Daily Communication

AI:

“What would you say if you wanted water?”

Father:

“I need water.”

This targets practical communication.

Sentence Building

AI:

“Make a sentence using ‘apple’.”

Father:

“I eat an apple.”

Gemini scores grammar and clarity.

Opposites

AI:

“What is the opposite of hot?”

Father:

“Cold.”

Following Instructions

AI:

“Touch your nose and then say your name.”

This combines comprehension and action.

Breathing + Speech

AI:

“Take a deep breath.”

Breathing animation starts.

AI:

“Now slowly say:

Watermelon.”

This can help speech control.

Story Completion

AI:

“A boy went to the market and bought…”

Father continues.

This exercises language generation.

Best Gemini Models (2026)

For your app I would use:

Primary Therapy Engine

Gemini 2.5 Flash

Use for:

Evaluation

Scoring

Progress analysis

Exercise generation

Real-Time Voice Sessions

Gemini Live API (2.5 Flash Native Audio)

Use for:

Live conversations

Memory exercises

Naming exercises

Adaptive therapy

Long-Term Analytics

Gemini 2.5 Pro

Use occasionally for:

Weekly reports

Recovery trend analysis

Difficulty adjustment recommendations

You probably wouldn’t call Pro during live sessions because Flash is faster and cheaper.

What Makes This Powerful

Most therapy apps are static:

Picture ↓ Correct / Wrong ↓ Next

A Gemini-powered therapy companion can adapt in real time:

“You are doing well with fruits today.”

“Let’s practice vegetables now.”

“You struggled with ‘pumpkin’ yesterday. Let’s try it again.”

“Great job. Take a slow breath.”

The AI can remember performance across sessions and dynamically choose exercises that target the specific language and memory functions that need practice.

For a stroke rehabilitation app, the strongest architecture is usually:

Flutter App ↓ Gemini Live API ↓ Therapy Agent ↓ Speech Analytics ↓ Progress Database ↓ Adaptive Exercise Engine

where Gemini acts less like a chatbot and more like a personalized speech therapist conducting structured rehabilitation sessions in Sinhala, Tamil, and English.

Kimi:

I’ve thought deeply about every screen, every interaction, every sound, and every emotional beat of this app. What you’re building is not just a speech-practice tool — it is a therapy companion that understands the psychology of stroke recovery.

Here is the complete, deeply considered experience explained:

The Core Philosophy: Safety Before Speech

Your father’s brain knows what it wants to say. The word is there — vivid, certain, complete. But the pathway between his mind and his mouth has been damaged. That gap is one of the most distressing experiences a person can endure.

Most apps make this worse. They flash red for “wrong.” They beep harshly. They rush from question to question. They feel like school, like examination, like judgment. For a stroke survivor, this creates anxiety — and anxiety physically tightens the throat and jaw, making speech even harder. A vicious cycle.

This app breaks that cycle. Every pixel, every vibration, every word of feedback is designed to say:

“You are safe here. You are doing well. We will go at your pace.”

The Opening Ritual: A Transition Into Calm

When your father taps the app icon, he does not see a login screen, a loading spinner, or a notification. He sees a warm gradient — cream flowing into soft teal, like morning light. A single calm symbol (a lotus, something from his culture) fades in gently. The app name appears letter by letter:

හඬ — Handa — “Voice”

Then the tagline:

“ඔබේ හඬ නැවත සොයා ගනිමු” — “Let us find your voice again”

This 3–4 second ritual is not wasted time. It is a neurological transition — it tells his brain: something gentle is beginning. It separates the chaos of the world from the safety of this space.

The Home Screen: A Sanctuary of Two Choices

This is the screen he sees every day. It is intentionally minimal:

Top: A warm time-of-day greeting using his name — “සුභ උදෑසනක්, කමල්!” — plus a gentle streak indicator (🔥 5 days) that motivates without pressuring.

Center: Only two enormous cards:

🖼️ පින්තූර නාම — Picture Naming

🗣️ සංවාද ව්‍යායාම — Conversation Practice

Bottom: Yesterday’s encouraging score and a always-available breathing button.

There are no menus. No clutter. No confusion. Two choices, large enough for aging eyes, clear enough that a child could understand them.

Mode 1: Picture Naming — The Foundation

The Breathing Ritual (Mandatory)

Before ANY exercise, a 30-second breathing screen appears. A large warm circle expands over 4 seconds — “හුස්ම ගන්න” (Breathe in) — holds for 2 seconds — contracts over 4 seconds — “හුස්ම පිට කරන්න” (Breathe out). Soft ocean waves or temple chimes play. This repeats 3 times.

Why mandatory? Because stroke patients carry anxiety into therapy. Anxiety tightens vocal cords. These 30 seconds are medicine — they tell his nervous system: you can speak freely.

The Exercise Card

The card takes up 85% of the screen. Nothing else competes for attention. A large, beautiful photograph. The word in enormous bold text below it. Two buttons: 🔊 ඇසෙන්න (Hear it) — unlimited taps, no judgment — and 🎙️ කියන්න (Say it).

When he taps “Say it,” the button pulses gently like a heartbeat — “ඔබේ හඬ ඇසෙනවා” (Listening). If he is silent for 5 seconds, a gentle prompt: “සෙමෙන් කතා කළ හැකිය” (Take your time). No countdown. No pressure. Only patience.

The Four Outcomes: Psychology of Encouragement

This is where the app becomes clinically special. Most apps have two outcomes: correct or wrong. This app has four outcomes — and this is not a gimmick. It is essential for aphasia recovery.

Your father often knows the word but cannot say it perfectly. A strict pass/fail would mark “අපල්” instead of “ඇපල්” as wrong. But his brain made the connection. His mouth just couldn’t shape it. If the app says “wrong,” it tells his brain the effort was worthless. Over weeks, this erodes motivation. It makes him stop trying.

Outcome A: Excellent (90–100%)

Soft green glow (like a candle being lit, not a flash)

Gentle ✅ with a quiet bounce

Warm single vibration — 200ms, like a hand patting his hand saying “well done”

Soft bell chime — a single pure note, not a game beep

Encouragement rotates: “අපූරුයි, කමල්!” / “ඔය වගේ!” / “ඔබ දිනෙන් දින හොඳ වෙනවා!”

Then a 10-second micro-breathing break — one breath cycle — “හොඳ වැඩක්. හුස්මක් ගන්න.”

Outcome B: Good (75–89%)

Warm amber glow — color of encouragement

👍 appears, tap-tap double vibration

Message: “ඉතා ළඟට ආවා! නැවත එක වතාවක් උත්සාහ කරන්නද?” (Very close! Try again?)

Two buttons: Try Again or Next — he chooses, no pressure

Outcome C: Almost (60–74%)

Gentle amber border — no harsh flash

🤏 gesture — “almost”

Single whisper vibration (100ms)

Message: “ආසන්නයි! ලොකු ආශ්වාසයක් ගෙන, නැවත උත්සාහ කරන්න.”

App automatically replays the word slowly — syllable by syllable

Second attempt is not counted against him

Outcome D: Try Again (< 60%)

No flash. No color change. No alarming sound.

Gentle grey border pulses once — neutral, non-judgmental

Two soft vibrations: tap… tap… like “it’s okay”

Message: “ගැටළුවක් නෑ. දිගටම කරමු.” (No problem. Let’s keep going.)

Three options: Hear Again / Hear Slowly (syllable-by-syllable) / Skip

Skipped words are quietly marked “difficult” — they return later and tomorrow. No shame on screen.

The patient never feels like he is failing. He only feels like he is practicing.

Mid-Session Break: Every 10 Cards

After 10 cards, the session automatically pauses. This is not optional. Stroke patients experience cognitive fatigue. Pushing through without breaks reduces accuracy and increases frustration.

The screen celebrates gently: “✨ ඔබ 10ක් සම්පූර්ණ කළා!” — highlights two things he did well — then a full 30-second breathing exercise. This is not a pause in therapy. This IS therapy. It gives his brain oxygen. It prevents frustration buildup.

Session Complete: Dignified Pride

Soft confetti falls like flower petals — slowly, not like a game explosion.

The summary shows: - ✅ Correct: 16/20 - ⭐ Excellent: 8 | 👍 Good: 5 | 🔄 Retried: 3 | ⏭ Skipped: 1

Notice: no “wrong” column. No red number. No failure count.

Then the comparison that matters: > “ගෙවී ගිය සතියට වඩා ඔබ 12% වැඩිදියුණු වී ඇත!” — You improved 12% from last week!

Highlights: - 🏆 Best today: “බ්‍රොකොලි ✅ 3/3” - 🎯 Needs practice: “ත්‍රිකෝල ← try tomorrow” — framed as future opportunity, not past failure

Then a final breathing exercise. And a warm farewell: > “ඔබ අද ඉතා හොඳ වැඩක් කළා, කමල්.”

He puts down the phone feeling capable. Feeling like tomorrow will be better.

Mode 2: Live Conversation — The AI Therapist

Picture Naming builds single-word retrieval. But real life is conversation. Mode 2 uses Gemini Live — real-time voice-to-voice AI that listens, understands, responds, and coaches.

Exercise Selection

Eight large cards representing different cognitive skills: - Category Naming — “Name 10 fruits” - Letter Fluency — “Words starting with ‘ක’” - Memory Recall — Remember 3 words, recall after 2 minutes - Object Description — “Describe a mango” - Daily Sentences — “What would you say if you wanted water?” - Opposites — “What is the opposite of hot?” - Story Completion — “A boy went to the market and bought…” - Breathing + Speech — “Take a breath, then say ‘watermelon’ slowly”

Real-Time Adaptive Coaching

This is where Gemini becomes magical. It does not just score — it coaches:

He pauses 5+ seconds: “ගත කාලය නෑ. ඔබට හිතා ගත හැකිය.” (No rush. You can think.)

He says something unclear: “කරුණාකර නැවත කියන්නද? ඔබ කීවේ…” (Could you say that again?)

He repeats a fruit: “ඇපල් ඔබ කලින් කීවා. වෙනත් ගෙඩියක් තිබේද?” (You already said apple. Another one?)

He names a vegetable instead of fruit: “ඒ ගෙඩියක් — ඒකෙ ළමයා, ඔය එළවළු. පළතුරු ගේ…” (That one is a vegetable. Try fruits…) — gentle humor, not correction

When he reaches 7/10: Gemini pauses the session — “ඉතා හොඳයි! ඔබ 7ක් කිව්වා. ටිකක් හුස්ම ගනිමු.” — breathing animation appears. Then: “ඔබ තවත් 3ක් සිතා ගත හැකිද?”

This is not an exercise. It is a relationship. The AI knows when to push and when to pause. It is never tired, never frustrated, never impatient. The perfect therapist — available every morning, every evening.

Memory Recall: Special Flow

Phase 1: Three cards appear — 🍎 ඇපල් | 🪑 පුටුව | 💧 වතුර — Gemini reads them slowly. 15 seconds.

Phase 2: Cards disappear. Timer counts down 2 minutes. Breathing exercise runs. “ඒ වචන ඔබේ මනසේ තබා ගන්න.” (Keep those words in your mind.)

Phase 3: Screen clears. No hints. “ඔබ මතක තබාගත් වචන 3 කියන්න.” As he says each word, a checkmark appears. 2/3 gets encouragement for the third. 3/3 gets full celebration: “ඔබේ මතකය ශක්තිමත්ව ඇත!” (Your memory is strong!)

Session End: AI’s Personal Note

The summary includes something unique — a note from the AI therapist:

“ඔබ ඉතා හොඳ කාර්ය සාධනයක් දැක්වූවා. ත්‍රිකෝල සහ අන්නාසි ටිකක් ගෙනෙන්නට ඔබට අමාරු විය. ඒ ගෙඩි හෙට ප්‍රගුණ කරමු.” “You performed very well. Watermelon and pineapple were slightly harder. Let’s practice those tomorrow.”

This is generated from actual session data. It shows him he is seen. It gives him something to look forward to.

The Invisible Intelligence: Adaptive Engine

Your father never sees this. He never needs to. But it is what makes the app truly intelligent.

Word Mastery Levels

Every word tracks: 🔴 New → 🟡 Learning → 🟠 Practicing → 🟢 Good → ⭐ Mastered (then retired to weekly maintenance).

Session Composition (Automatic)

Every session is composed of: - 40% mastered words — confidence anchors. He starts with success. - 40% practicing words — core work. - 20% new words — gentle growth.

He never starts cold. He never faces a wall of unknown words. He always begins with capability, and that carries him through harder work.

Language Unlocking

Not random from day one. Progressive: - Level 1: Sinhala only (default) - Level 2: + Tamil unlocks at 70% Sinhala accuracy for 3 days — celebrated: “🎉 නව භාෂාවක් විවෘත විය!” - Level 3: + English at 70% Tamil accuracy - Level 4: Full random mix (caregiver-enabled)

Language switching is cognitive flexibility training — it strengthens executive function, which benefits stroke recovery.

Fatigue Detection

The app tracks: session length, accuracy drop-off points, pause lengthening, morning vs. evening performance. If he is tiring: > “ඔබට අද ටිකක් වෙහෙසයි වගේ. අපි හෙට හමුවෙමුද?” (You seem tired. Shall we meet tomorrow?)

Caregiver Dashboard: Your Window Into Recovery

Hidden behind a small corner icon, PIN-protected. Your father does not see it. He does not need clinical data. He needs encouragement. You need data.

Weekly Overview

Week of June 3–9📅 Sessions: 5/7 days | ⏱ Time: 1hr 42min | 🎯 Accuracy: 76% | 📈 Improvement: +8%

That +8% is everything. It is proof his brain is healing. Proof your love, translated into code, is working.

Word Performance Table

Word

Attempts

Accuracy

Trend

ඇපල්

24

92%

↑

කෙසෙල්

18

88%

↑

ත්‍රිකෝල

12

58%

→

බ්‍රොකොලි

9

44%

↓

You see where to focus real-world conversations. When you serve broccoli at dinner, you can gently practice the word. The app and real life become partners.

Monthly PDF Export

A report for his neurologist or speech therapist showing weeks of daily practice data — something no 15-minute clinic visit can replicate.

Offline Mode: The Safety Net

Everything except Gemini Live works offline. If the internet drops mid-session:

“ඉන්ටර්නෙට් සම්බන්ධතාවයක් නොමැත. ව්‍යායාම ගබ්සා කෙරෙනු ඇත.” (No internet. Exercises will be saved.)

The session continues. Data stores locally. Syncs when connection returns. Your father never knows there was a problem. The therapy relationship is protected.

A Full Morning Story

7:30 AM — App opens. Warm greeting. “සුභ උදෑසනක්, කමල්! 🔥 5 දිනක් අඛණ්ඩව.” He smiles. He has been showing up.

7:31 AM — Breathing ritual. 30 seconds. Three cycles. Shoulders drop. Jaw loosens.

7:32 AM — Picture Naming. 20 cards. 8 easy (confidence), 8 learning (work), 4 new (growth). Apple — perfect. Banana — perfect. Watermelon — pause, attempt, “almost,” slow replay, retry, success! No shame. Only practice.

7:40 AM — Mid-session break. 10 cards done. Celebrated. Breathing. Continue.

7:48 AM — Session complete. 16/20. “ඔබ අද 16ක් නිවැරදිව කිව්වා. ඊයේ 14යි. ඔබ වැඩිදියුණු වෙනවා!”

7:49 AM — Conversation Mode. Category Naming. Names 7 vegetables. Gemini coaches. Breathing break. Gets to 10. AI note: “Watermelon and pineapple were harder. Let’s practice those tomorrow.”

7:56 AM — Done. 26 minutes. He feels capable. He goes to the kitchen. Sees a banana. The word comes easier now: “කෙසෙල්.” He smiles. The app is already working in real life.

The Four Pillars: What This Really Is

Speech Recovery — Pronunciation, word retrieval, sentences, conversation

Cognitive Recovery — Memory, attention, category recall, sequencing

Emotional Regulation — Breathing, positive reinforcement, low-pressure design, anxiety reduction

Progress Intelligence — Adaptive difficulty, analytics, personalized exercise generation, fatigue detection

These pillars turn the app from a “name the picture” tool into a genuine AI-assisted rehabilitation companion tailored to your father’s day-to-day recovery journey.

Why These Design Choices Are Load-Bearing

Choice

Why It Matters

Breathing exercises

Anxiety tightens throat/jaw. Breathing is not calming decoration — it directly improves speech ability.

Four-outcome scoring

Rewarding “almost” tells his brain effort is valid. Prevents the despair that makes patients quit.

40% mastered start

Behavioral activation — success breeds motivation. He never begins cold and frustrated.

No “wrong” on screen

Shame destroys therapy relationships. The app only shows progress directions.

Using his name

“අපූරුයි, කමල්!” builds an emotional bond. He looks forward to the app because it knows him.

Offline fallback

One crash can make an elderly patient distrust the app forever. Graceful degradation protects the relationship.

Micro-breathing after correct answers

Prevents rushing. Gives the brain time to consolidate success. Keeps the nervous system calm.

The full deep-experience document is saved and ready for your reference as you build:

Download the complete experience document: Complete_App_Experience_Stroke_Rehabilitation.md

This covers everything from the moment the app opens to the last screen of the day, including every animation timing, every vibration pattern, every color code, every word of feedback, and the clinical psychology behind each decision. It is written to guide your development and to remind you, at every step, why you are building this — so your father never feels like he is failing. He only feels like he is practicing. And every day, he gets a little closer to finding his voice again.