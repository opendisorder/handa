# Complete App Experience
## Stroke Speech Rehabilitation — Full Design Document

---

## The Philosophy Behind Every Design Decision

Before any screen or feature, the app must be built around one understanding:

> Your father is not using a game. He is doing hard, frustrating, emotionally vulnerable work every day. His brain knows what he wants to say. His mouth won't cooperate. That gap — knowing but not being able to express — is one of the most distressing experiences a person can have.

Every color, every sound, every animation, every word of feedback must say:

> "You are safe here. You are doing well. We will go at your pace."

The app should feel less like a test and more like sitting with a gentle, endlessly patient therapist.

---

## App Identity

**App Name (suggestion):**
හඬ — *Handa* (Voice / Sound in Sinhala)

**Color Palette:**
- Background: Warm off-white `#FDF6EC` — not harsh white, easier on aging eyes
- Primary: Calm teal `#2A9D8F` — used for correct answers, progress
- Accent: Warm amber `#E9C46A` — used for encouragement, almost-correct
- Error (soft): Muted rose `#E76F51` — never red, never alarming
- Text: Deep charcoal `#264653` — high contrast, never pure black

**Typography:**
- Sinhala: Noto Sans Sinhala — largest readable size (28sp minimum)
- Tamil: Noto Sans Tamil
- English: Nunito — rounded, friendly, not clinical
- All text: Bold weight throughout — stroke patients often have mild visual processing changes

**Sound Design:**
- Success chime: Soft, warm bell tone (not a game beep)
- Almost-correct: Gentle ascending tone (not a buzzer)
- Breathing guide: Ambient ocean or soft wind sound
- Background: Silence — no background music during exercises

---

## Screen 1 — App Launch

**Duration:** 3–4 seconds

The screen opens to a **warm gradient** (cream to soft teal).

A single lotus or similar calm symbol fades in gently at center.

Below it, the app name appears letter by letter:

> හඬ

Then the Sinhala tagline fades in:

> "ඔබේ හඬ නැවත සොයා ගනිමු"
> *"Let us find your voice again"*

No login. No onboarding quiz. No permissions popup at this stage.

The first time the app opens, it goes to a **one-time setup screen.**

---

## Screen 2 — First Time Setup (Once Only)

This runs only on first install.

**Step 1 — Who is using this app?**

Two large cards:

```
┌─────────────────────┐   ┌─────────────────────┐
│                     │   │                     │
│   👤 රෝගියා         │   │   👨‍⚕️ සත්කාරකයා     │
│   (Patient)         │   │   (Caregiver)       │
│                     │   │                     │
└─────────────────────┘   └─────────────────────┘
```

Patient mode = simplified UI, big everything, no distractions.
Caregiver mode = access to dashboard, settings, progress reports.

**Step 2 — Patient's Name**

Large text field:

> ඔබේ නම ලියන්න
> (Enter your name)

This name is used throughout the app for personal encouragement:

> "හොඳයි, කමල්!"
> "Well done, Kamal!"

**Step 3 — Primary Language**

Three options (pre-selected: Sinhala):

- සිංහල (Sinhala) ← default selected
- தமிழ் (Tamil)
- English

**Step 4 — Microphone Permission**

Explained warmly in Sinhala:

> "ඔබ කතා කරන විට, අපට ඔබ සුවය ලැබෙනවාද කියා බලා ගැනීමට ඔබේ හඬ ඇසීමට අවශ්‍යයි."

Then the system permission dialog appears.

**Step 5 — Quick Voice Test**

Shows a smiling face icon and says:

> "කරුණාකර 'ආයුබෝවන්' කියන්න"
> "Please say 'Ayubowan'"

App confirms microphone works.

If it fails, gives a simple troubleshooting guide.

Setup complete. The app never asks these questions again.

---

## Screen 3 — Home Screen (Patient View)

This is the most important screen. Your father sees this every day.

**Top section:**
- Time of day greeting: "සුභ උදෑසනක්, කමල්!" (Good morning, Kamal!)
- Today's streak: 🔥 5 days in a row (gentle motivation)
- Today's session status: "අද ව්‍යායාමය අවසන් කර නැත" (Today's session not yet done)

**Center — Two large therapy mode cards:**

```
┌──────────────────────────────────┐
│  🖼️  පින්තූර නාම                  │
│     Picture Naming               │
│                                  │
│  "පින්තූරය බලා නම කියන්න"        │
│  See the picture, say the name   │
│                                  │
│         [ පටන් ගනිමු ]           │
│           Start                  │
└──────────────────────────────────┘

┌──────────────────────────────────┐
│  🗣️  සංවාද ව්‍යායාම               │
│     Conversation Practice        │
│                                  │
│  "AI වෛද්‍යවරයා සමඟ කතා කරන්න"  │
│  Talk with the AI therapist      │
│                                  │
│         [ පටන් ගනිමු ]           │
│           Start                  │
└──────────────────────────────────┘
```

**Bottom section:**
- Yesterday's score (simple, not overwhelming): ⭐ 78% — "හොඳ කාර්ය සාධනයක්!"
- Small breathing exercise button for anytime use

---

## Mode 1 — Picture Naming: Complete Flow

### 1.1 Category Selection Screen

Large grid of category cards with illustrations:

```
🍎 පළතුරු        🥕 එළවළු
   Fruits           Vegetables

🏠 නිවසේ        👨‍👩‍👧 පවුල
   Home Objects     Family

🚶 ක්‍රියා        🌍 ස්ථාන
   Actions          Places
```

Each card shows a count:
> "20 වචන" (20 words)

And a mastery indicator:
> ⭐⭐⭐ (3 stars = mastered)

At the bottom, a language toggle:
```
[ සිංහල ]  [ தமிழ் ]  [ English ]  [ මිශ්‍ර ]
```

For early sessions: only Sinhala cards are bright. Tamil and English cards are slightly dimmed with a lock icon until Level 2 is unlocked.

---

### 1.2 Pre-Session Breathing Screen

Before EVERY session — without exception — a 30-second calm breathing screen appears.

This is not skippable in the first month. (Caregiver can change this in settings.)

Screen shows:

A large soft circle. Warm teal color.

```
         ○
    ○         ○         ← circle slowly expands
         ○

  හුස්ම ගන්න...
  Breathe in...
  (4 seconds)
```

Then:

```
  [circle at full size, holds]

  තබා ගන්න...
  Hold...
  (2 seconds)
```

Then:

```
         ●
    ●         ●         ← circle slowly contracts
         ●

  හුස්ම පිට කරන්න...
  Breathe out...
  (4 seconds)
```

This repeats 3 times.

Soft ambient sound plays — gentle ocean waves or wind chimes.

After 3 cycles, a warm message:

> "ඔබ සූදානම්. අපි පටන් ගනිමු."
> "You are ready. Let's begin."

Then the first card loads.

---

### 1.3 The Exercise Card — Normal State

The card takes up 85% of the screen. Nothing else competes for attention.

```
┌────────────────────────────────────────┐
│                                        │
│         [Progress: Card 3/20]          │
│         ████░░░░░░░░░░░  15%           │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │                                  │  │
│  │                                  │  │
│  │          🍌                      │  │
│  │    [Large vibrant image]         │  │
│  │                                  │  │
│  │                                  │  │
│  └──────────────────────────────────┘  │
│                                        │
│           කෙසෙල්                       │
│         (large text)                   │
│                                        │
│    🔊                    🎙️            │
│  [Hear it]          [Say it]           │
│                                        │
└────────────────────────────────────────┘
```

**🔊 Hear It button:**
Tap → app speaks the word in a calm, clear voice in the selected language.
Can be tapped unlimited times. No judgment.

**🎙️ Say It button:**
Tap → button turns red, pulsing slowly:

```
  🔴 ● ● ●  ←  gentle pulse animation

  ඔබේ හඬ ඇසෙනවා...
  Listening...
```

Father speaks. App listens for up to 10 seconds. If silence for 5 seconds, a gentle prompt:

> "සෙමෙන් කතා කළ හැකිය."
> "Take your time."

---

### 1.4 Answer Evaluation — Four Outcomes

**Outcome A: Excellent (90–100% match)**

Immediate response (< 0.5 seconds):

1. Card flashes soft green glow
2. Large animated ✅ appears with a gentle bounce
3. Phone gives a **warm, single vibration** (200ms)
4. Chime sound plays — soft and warm, not a game beep
5. Animated stars scatter across the screen briefly

Encouragement message (rotates, personal):

> "අපූරුයි, කමල්!" — "Wonderful, Kamal!"
> "ඔය වගේ!" — "Exactly like that!"
> "ඔබ දිනෙන් දින හොඳ වෙනවා!" — "You are getting better every day!"

Then **breathing micro-break** (10 seconds, not the full 30):

```
  ○ → ● → ○   (one breath cycle)
  
  හොඳ වැඩක්. හුස්මක් ගන්න.
  "Good work. Take a breath."
```

Then next card slides in from the right.

---

**Outcome B: Good (75–89% match)**

1. Card flashes warm amber glow
2. Animated 👍 appears
3. Short double vibration (tap-tap)
4. Encouraging tone plays

Message:

> "ඉතා ළඟට ආවා! නැවත එක වතාවක් උත්සාහ කරන්නද?"
> "Very close! Want to try one more time?"

Two buttons appear:

```
[ 🔄 නැවත උත්සාහ කරන්න ]   [ ⏭ ඊළඟ ]
   Try Again                    Next
```

Father chooses. No pressure.

If he picks Try Again → card resets. Hear It button pulses once to encourage him to listen again first.

If he picks Next → card is marked as "needs more practice" in the database and moves on.

---

**Outcome C: Almost (60–74% match)**

1. No harsh flash — just a gentle amber border
2. Animated hand gesture 🤏 (almost!)
3. Very gentle single short vibration (100ms)

Message:

> "ආසන්නයි! ලොකු ආශ්වාසයක් ගෙන, නැවත උත්සාහ කරන්න."
> "Almost! Take a big breath and try again."

Automatically replays the word once through the speaker at slower speed.

Father tries again. This attempt is not counted as a mistake if he gets it on the second try.

---

**Outcome D: Try Again (< 60% match)**

This is the most sensitive state. It must never feel like failure.

1. No flash, no harsh sound
2. Gentle grey border pulses once
3. Phone gives two very soft vibrations (tap... tap)
4. Warm message appears:

> "ගැටළුවක් නෑ. දිගටම කරමු."
> "No problem. Let's keep going."

Options shown:

```
[ 🔊 නැවත ඇසෙන්න ]   [ 🐢 සෙමෙන් ඇසෙන්න ]   [ ⏭ මඟ හරිනවා ]
   Hear Again           Hear Slowly               Skip
```

**Hear Slowly** plays the word broken into syllables with a pause:

> "කෙ...සෙ...ල්"

Then father tries again.

**Skip** marks the card as "difficult" — it will appear again later in the session and also in the next session. No mistake count shown on screen in the moment (only in caregiver dashboard).

---

### 1.5 Mid-Session Break (Every 10 Cards)

After every 10 cards, the session automatically pauses.

A calm transition screen:

```
  ✨ ඔබ 10ක් සම්පූර්ණ කළා!
     You completed 10!

  දෙකක් හොඳින් කළා:
  You did well with:
     🍎 ඇපල් ✅
     🍇 ද්‍රාක්ෂා ✅

  ටිකක් විවෙක ගනිමු.
  Let's rest a little.
```

Then a full 30-second breathing exercise (the same as the pre-session one).

After the break, a gentle message:

> "ඉතා හොඳයි. ඉදිරියට යමු."
> "Very good. Let us continue."

---

### 1.6 Session Complete Screen

After all cards in the session:

Animated confetti (soft, not overwhelming)

```
  🎉 ව්‍යායාමය අවසන්!
     Session Complete!

  ━━━━━━━━━━━━━━━━━━━━
  
  ✅ නිවැරදි:     16/20
  ⭐ විශිෂ්ට:      8
  👍 හොඳ:         5
  🔄 නැවත කළ:    3
  ⏭ මඟ හැරුණු:   1

  ━━━━━━━━━━━━━━━━━━━━

  ගෙවී ගිය සතියට වඩා
  ඔබ 12% වැඩිදියුණු වී ඇත!
  You improved 12% from last week!

  ━━━━━━━━━━━━━━━━━━━━

  🏆  අද වඩාත් හොඳ:
      Best today:
      🥦 බ්‍රොකොලි ✅ 3/3

  🎯  වැඩ කළ යුතු:
      Needs practice:
      🍉 ත්‍රිකෝල ← try tomorrow

  ━━━━━━━━━━━━━━━━━━━━
  
  [ 🏠 නිවසට ]    [ 🗣️ සංවාද ව්‍යායාම ]
     Home           Conversation Mode
```

Then a final calm breathing exercise and a warm farewell:

> "ඔබ අද ඉතා හොඳ වැඩක් කළා, කමල්."
> "You did great work today, Kamal."

---

## Mode 2 — Live Conversation: Complete Flow

### 2.1 Exercise Selection Screen

```
┌─────────────────────────────────────────┐
│   🗣️  සංවාද ව්‍යායාම                    │
│       Conversation Exercises            │
│                                         │
│  ┌───────────────┐  ┌───────────────┐   │
│  │ 🍎 Category   │  │ 🔤 Letter     │   │
│  │   Naming      │  │  Fluency      │   │
│  │               │  │               │   │
│  │ "10 fruits"   │  │ Words with ක  │   │
│  └───────────────┘  └───────────────┘   │
│                                         │
│  ┌───────────────┐  ┌───────────────┐   │
│  │ 🧠 Memory     │  │ 📝 Describe   │   │
│  │   Recall      │  │   Objects     │   │
│  └───────────────┘  └───────────────┘   │
│                                         │
│  ┌───────────────┐  ┌───────────────┐   │
│  │ 💬 Daily      │  │ 🔄 Opposites  │   │
│  │   Sentences   │  │               │   │
│  └───────────────┘  └───────────────┘   │
│                                         │
│  ┌───────────────┐  ┌───────────────┐   │
│  │ 📖 Story      │  │ 🌬️ Breathing  │   │
│  │  Completion   │  │  + Speech     │   │
│  └───────────────┘  └───────────────┘   │
└─────────────────────────────────────────┘
```

Each card shows:
- Exercise name in Sinhala + English
- Estimated duration: "~5 minutes"
- Last played: "2 days ago"
- Last score: "7/10 ⭐"

---

### 2.2 Connecting to Gemini Live

Tapping any exercise shows a connecting screen:

```
     ○ ○ ○  (gentle pulsing dots)

  AI වෛද්‍යවරයා සම්බන්ධ කරනවා...
  Connecting to AI therapist...
```

While connecting (1–2 seconds), Gemini is being initialized with the full therapy system prompt including:
- Father's name
- Current language level
- Today's exercise
- His recent performance history
- Encouragement style

Once connected:

```
  ✅ සම්බන්ධ විය!
     Connected!

  AI වෛද්‍යවරයා ඔබ සමඟ කතා
  කිරීමට සූදානම්.
  The AI therapist is ready
  to speak with you.

  [ ▶ පටන් ගන්න ]
     Begin
```

---

### 2.3 Live Session Screen

The live session screen is intentionally minimal:

```
┌──────────────────────────────────────┐
│  🗣️ Category Naming         [⏹ End]  │
│                                      │
│                                      │
│         [ AI speaking indicator ]    │
│                                      │
│    ╔══════════════════════════════╗  │
│    ║                              ║  │
│    ║   "කරුණාකර පළතුරු 10ක්       ║  │
│    ║    නම් කරන්න."               ║  │
│    ║                              ║  │
│    ║   Please name 10 fruits.     ║  │
│    ╚══════════════════════════════╝  │
│                                      │
│    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━    │
│                                      │
│    ✅ ඇපල්      ✅ කෙසෙල්            │
│    ✅ අඹ        ✅ ස්ට්‍රෝබෙරි       │
│    ✅ ද්‍රාක්ෂා  🔄 ?               │
│                                      │
│    5 / 10 named                      │
│                                      │
│    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━    │
│                                      │
│         🎙️  (pulsing = listening)    │
│                                      │
└──────────────────────────────────────┘
```

The screen shows:
- What Gemini said (as subtitle text)
- Live count of valid answers
- Each correct answer appearing as a checkmark tile
- Microphone status indicator

When Gemini is speaking: the microphone icon dims. When father speaks: it pulses.

---

### 2.4 Real-Time Behavior During Live Session

**Father pauses for 5+ seconds:**
Gemini gently: "ගත කාලය නෑ. ඔබට හිතා ගත හැකිය." ("No rush. You can think.")

**Father says something unclear:**
Gemini: "කරුණාකර නැවත කියන්නද? ඔබ කීවේ..." ("Could you say that again?")

**Father says a repeated fruit:**
Gemini: "ඇපල් ඔබ කලින් කීවා. වෙනත් ගෙඩියක් තිබේද?" ("You already said apple. Can you think of another one?")

**Father says a vegetable instead of fruit:**
Gemini: "ඒ ගෙඩියක් — ඒකෙ ළමයා, ඔය එළවළු. පළතුරු ගේ..." ("That one — carrot — is a vegetable. Try with fruits...") ← gentle, not harsh

**Father reaches 7/10:**
Gemini pauses the session: "ඉතා හොඳයි! ඔබ 7ක් කිව්වා. ටිකක් හුස්ම ගනිමු." ("Very well! You named 7. Let us breathe a little.")

Breathing animation appears on screen for one cycle (12 seconds).

Then: "ඔබ තවත් 3ක් සිතා ගත හැකිද?" ("Can you think of 3 more?")

---

### 2.5 Memory Recall Exercise — Special UI

This exercise has a unique screen because of the delay period.

**Phase 1 — Learning:**
```
  🧠 මෙම වචන 3 මතක තබා ගන්න:
     Remember these 3 words:

  ┌──────────┐ ┌──────────┐ ┌──────────┐
  │          │ │          │ │          │
  │  🍎       │ │  🪑       │ │  💧       │
  │  ඇපල්    │ │  පුටුව   │ │  වතුර    │
  │          │ │          │ │          │
  └──────────┘ └──────────┘ └──────────┘

  Gemini reads them aloud slowly.
  Cards shown for 15 seconds.
```

**Phase 2 — Break (2 minutes):**
Cards disappear. Screen shows:

```
  ⏱ 2:00 → 1:59 → 1:58...

  (Breathing exercise runs during this time)

  "ඒ වචන ඔබේ මනසේ තබා ගන්න."
  "Keep those words in your mind."
```

During the 2-minute wait, the app can offer a simple, unrelated activity (optional): "සුළු ශ්වාස ව්‍යායාමයක් කරමුද?" ("Shall we do a small breathing exercise?")

**Phase 3 — Recall:**
Timer ends. Screen clears completely — no hints.

Gemini asks: "ඔබ මතක තබාගත් වචන 3 කියන්න." ("Tell me the 3 words you remembered.")

As father says each word, a checkmark appears:

```
  ✅ ඇපල්
  ✅ වතුර
  ❓ ... (waiting)
```

If he gets 2/3: "ඉතා හොඳයි! 2ක් නිවැරදියි. තෙවැන්න?"
If he gets 3/3: Full success animation + "ඔබේ මතකය ශක්තිමත්ව ඇත!"

---

### 2.6 Live Session End Screen

```
  ✨ ව්‍යායාමය අවසන්!
     Exercise Complete!

  ━━━━━━━━━━━━━━━━━━━━

  Category Naming

  ✅ නිවැරදි: 8 / 10
  ⏱ කාලය: 4 min 32 sec
  🗣️ Fluency: Good
  🧠 Recall speed: Moderate

  ━━━━━━━━━━━━━━━━━━━━

  AI වෛද්‍යවරයාගේ සටහන:
  AI Therapist Note:

  "ඔබ ඉතා හොඳ කාර්ය සාධනයක් දැක්වූවා.
  ත්‍රිකෝල සහ අන්නාසි ටිකක් ගෙනෙන්නට
  ඔබට අමාරු විය. ඒ ගෙඩි හෙට ප්‍රගුණ
  කරමු."

  "You performed very well.
  Watermelon and pineapple were slightly 
  harder. Let's practice those tomorrow."

  ━━━━━━━━━━━━━━━━━━━━

  [ 🏠 නිවසට ]   [ 🔄 නැවත ]
```

---

## Adaptive Difficulty System

The app tracks performance silently and adapts automatically.

**Word Mastery Levels:**

| Status | Criteria | What Happens |
|---|---|---|
| 🔴 New | Never practiced | Shown every session |
| 🟡 Learning | <5 attempts | Shown every session |
| 🟠 Practicing | 50–74% accuracy | Shown every session |
| 🟢 Good | 75–89% accuracy | Shown every other session |
| ⭐ Mastered | 90%+ across 5 sessions | Shown weekly, then retired |

**Session Composition (automatic):**
- 40% mastered words (confidence building)
- 40% practicing words (core work)
- 20% new words (growth)

This ratio ensures father always feels capable while still being gently stretched.

**Language Unlock:**

| Level | Unlock Condition |
|---|---|
| Sinhala only | Default |
| + Tamil | 70% Sinhala accuracy for 3 days |
| + English | 70% Tamil accuracy for 3 days |
| Full random mix | Caregiver can enable manually |

---

## Caregiver Dashboard

Accessed via PIN from the home screen (small icon in corner, not prominent).

### Weekly Overview
```
  Week of June 3–9, 2026

  📅 Sessions completed: 5/7 days
  ⏱ Total therapy time: 1hr 42min
  🎯 Overall accuracy: 76%
  📈 Improvement from last week: +8%
```

### Word Performance Table
```
  Word         Attempts  Accuracy  Trend
  ─────────────────────────────────────
  ඇපල්           24        92%      ↑
  කෙසෙල්         18        88%      ↑
  ත්‍රිකෝල       12        58%      →
  බ්‍රොකොලි       9        44%      ↓
```

### Live Exercise History
```
  Date        Exercise           Score  Duration
  ──────────────────────────────────────────────
  Jun 9       Category Naming    8/10   4:32
  Jun 8       Memory Recall      2/3    6:10
  Jun 7       Story Completion   Good   5:44
```

### Export Report (Monthly)
Can generate a PDF summary that can be shared with a real speech therapist or neurologist — showing recovery trends over weeks and months.

---

## Offline Mode

Everything except the Gemini Live API works fully offline.

| Feature | Offline? |
|---|---|
| Picture Naming (basic mode) | ✅ Yes |
| Local speech recognition (Vosk) | ✅ Yes |
| Breathing exercises | ✅ Yes |
| Progress tracking | ✅ Yes |
| Word playback (TTS) | ✅ Yes (cached) |
| Gemini AI evaluation | ❌ No |
| Gemini Live sessions | ❌ No |

When offline, the app automatically switches to a simpler scoring mode and shows a gentle note:

> "ඉන්ටර්නෙට් සම්බන්ධතාවයක් නොමැත. ව්‍යායාම ගබ්සා කෙරෙනු ඇත."
> "No internet connection. Exercises will be saved."

---

## A Full Day in Father's Experience

**7:30 AM — App opens**

Good morning greeting. Yesterday's streak shown. Gentle animation.

**7:31 AM — Breathing intro (30 seconds)**

Three breath cycles. Calm sound. Mind settles.

**7:32 AM — Picture naming begins**

20 cards. Fruits category. Sinhala. Big images. Warm feedback.

Each correct answer: chime, vibration, encouragement.

Mid-session break at card 10. Another breathing exercise.

**7:48 AM — Session complete**

Score shown. Improvement noted. Words that need work identified.

A warm message:

> "ඔබ අද 16ක් නිවැරදිව කිව්වා. ඊයේ 14යි. ඔබ වැඩිදියුණු වෙනවා!"
> "You got 16 right today. Yesterday it was 14. You are improving!"

**7:49 AM — Optional: Conversation mode**

He taps Category Naming.

Gemini: "කරුණාකර එළවළු 10ක් නම් කරන්න."

He names 7. Gemini coaches gently. Gets to 9. Breathing break. Gets 10th. Full celebration.

**7:56 AM — Done for the morning**

Total session time: ~26 minutes.

No frustration. No confusion. Calm throughout.

---

## What Makes This Different from Other Apps

Most rehabilitation apps are:
- Built for therapists, not patients
- Clinically accurate but emotionally cold
- Static — same exercise every day
- English-only
- Confusing UI

This app is built around one idea:

> Every interaction should leave your father feeling more capable than before it started — not less.

The breathing exercises are not a feature. They are the emotional foundation of the entire experience. They give him a moment to reset after a difficult word, to celebrate after a correct one, and to stay calm throughout.

The AI is not a judge. It is a companion.

The progress tracking is not to measure failure. It is to show him — and you — that he is getting better, even on the days when it does not feel that way.

---

*This document covers the complete patient experience, caregiver experience, adaptive systems, and clinical design philosophy for the rehabilitation app.*