# AURA Speech Therapy — Memory Architecture & Psychological Support Framework
## Technical Design + Psychoeducational Context for Post-Stroke Recovery

---

## PART 1: GEMINI LIVE MEMORY ARCHITECTURE

### 1.1 The Hard Truth About Gemini Live Memory

**Gemini Live does NOT have persistent memory across sessions.**

Each session is stateless. The model has a large context window (1M+ tokens for Pro) that holds the *current* conversation, but when you close the session, everything is gone. It does not "take notes in the background" while talking. It does not remember yesterday's session unless you explicitly feed that memory back into the next session.

This means you MUST build a **two-layer architecture**:

```
┌─────────────────────────────────────────────────────────────┐
│  LAYER 1: REAL-TIME (Gemini Live)                           │
│  ────────────────────────────────────────                   │
│  • Bidirectional audio streaming                            │
│  • Real-time vision streaming (camera)                      │
│  • Immediate struggle detection & cueing                    │
│  • Session context only (this conversation)                 │
│  • Function calls to app (trigger breathing, show image)     │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼ (Session ends)
┌─────────────────────────────────────────────────────────────┐
│  LAYER 2: BACKGROUND PROCESSING (Post-Session Agent)        │
│  ────────────────────────────────────────────────────       │
│  • Receives full session recording (audio + video frames)   │
│  • Extracts structured notes, metrics, emotional state      │
│  • Stores in Firebase / Firestore                           │
│  • Generates summary for next session preload               │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼ (Next session starts)
┌─────────────────────────────────────────────────────────────┐
│  LAYER 1 AGAIN: Preloaded with yesterday's memory           │
│  ────────────────────────────────────────────────────       │
│  • System prompt includes:                                  │
│    - Yesterday's struggle words                             │
│    - Yesterday's wins                                       │
│    - Emotional state at session end                         │
│    - Trend data (accuracy improving, etc.)                  │
│  • AI "remembers" because you fed it the memory           │
└─────────────────────────────────────────────────────────────┘
```

### 1.2 What Gemini Live CAN Do In Real-Time

Within a single session, Gemini Live CAN:
- **See the camera stream** and interpret facial expressions, lip movements, head position
- **Hear the audio stream** and detect silence, false starts, effortful speech
- **Speak back** with the therapeutic voice
- **Call functions** (trigger breathing, show image, log data)
- **Hold context** for the current conversation ("You named the elephant earlier, now let's try the tiger")

But it CANNOT:
- Remember what happened in yesterday's session (unless you tell it)
- Write notes to a database while talking (unless you trigger a function call)
- Analyze the full session deeply while still in the session (it's focused on real-time interaction)

### 1.3 The Recording & Background Agent Pipeline

**Step 1: Record the Session**
```
During the session:
├── Audio: Record full audio stream (patient + AI) locally
├── Video: Sample frames every 2-5 seconds (not full video, just key frames)
├── Events: Log timestamps (exercise start, cue given, struggle detected, breathing triggered)
└── Transcript: Capture text of what was said (Gemini can output this)
```

**Step 2: Background Agent Processing (After Session Ends)**
Send the recording to a SECOND agent (Gemini 1.5 Flash or Pro, not Live) with this prompt:

```
You are a clinical documentation assistant. Analyze this speech therapy session 
recording and extract the following structured data:

1. EXERCISE RESULTS:
   - For each exercise: target word, patient's response, accuracy (0-1), 
     cueing level used (0-4), word onset latency (seconds)

2. STRUGGLE PATTERNS:
   - Which words were hardest? Any phonemic patterns? (e.g., all words starting with 'p')
   - When did frustration peak? What triggered it?

3. EMOTIONAL STATE:
   - Mood at session start, middle, end (scale 1-5)
   - Number of negative statements made by patient
   - Topics that caused emotional reaction (family, money, past, etc.)

4. SPEECH METRICS:
   - Total words attempted, correct, approximate
   - Average response time
   - Self-corrections count

5. THERAPEUTIC NOTES:
   - What encouragement worked? What didn't?
   - Did the patient mention anything personal? (family, worries, etc.)
   - Any red flags for caregiver attention?

Output as JSON.
```

**Step 3: Store in Database**
```json
// Firestore document: /patients/{patientId}/sessions/{sessionId}
{
  "session_id": "sess_20250610_1430",
  "patient_id": "father_001",
  "timestamp": "2026-06-10T14:30:00Z",
  "duration_seconds": 1560,
  "exercises": [...],
  "emotional_state": {
    "start_mood": 3,
    "end_mood": 4,
    "negative_statements_count": 2,
    "topics_mentioned": ["hospital visitors", "money", "son"]
  },
  "speech_metrics": {
    "accuracy_pct": 68,
    "avg_word_onset_ms": 3800,
    "avg_cueing_level": 1.8
  },
  "therapeutic_notes": {
    "what_worked": ["breathing before hard words", "using his name"],
    "red_flags": ["mentioned feeling worthless when carrot took 15s"],
    "personal_mentions": ["spoke about not having money when young"]
  },
  "memory_for_next_session": "Yesterday you named elephant without help. You also mentioned feeling worried about money. Today we will start with easy wins and breathe together."
}
```

**Step 4: Preload Next Session**
Before starting the next Gemini Live session, inject the memory into the system prompt:

```
PATIENT MEMORY (from previous sessions):
- Name: [Name]
- Preferred language: Sinhala
- Yesterday's wins: Named elephant without cue, completed 5 breathing cycles
- Yesterday's struggles: Words starting with 'p', category naming
- Emotional state at end: Calm but mentioned worry about money
- What motivates him: References to his children's success
- What triggers frustration: Being rushed, words about food
- Therapist instruction: Start with 2 easy wins, use breathing before hard exercises
```

### 1.4 Video Stream: Real-Time vs. Background Analysis

**Real-Time Vision (Gemini Live sees camera during session):**
- **Purpose**: Immediate struggle detection
- **What it sees**: Facial tension, lip movement, head turning away, sighing
- **Latency**: ~500ms-1s (good enough for cueing, but not for precise timing)
- **Limitation**: Gemini Live is focused on conversation, not detailed frame-by-frame analysis

**Background Vision (Sampled frames after session):**
- **Purpose**: Detailed emotion tracking, progress analysis
- **What you send**: 10-20 key frames from the session (struggle moments, success moments, start/end)
- **What the agent extracts**: 
  - Facial emotion labels (frustrated, engaged, neutral, pleased)
  - Eye contact patterns
  - Body posture (slumped = low mood, upright = engaged)
  - Mouth movement quality (how clearly he formed words)

**Recommended Hybrid Approach:**
```
┌────────────────────────────────────────────────────────────┐
│  ON-DEVICE (Local, Zero Latency)                           │
│  ────────────────────────────────────────                  │
│  • MediaPipe Face Mesh: Detect facial tension, lip movement│
│  • Silence detector: Measure gaps in audio                 │
│  • Motion detector: Detect head turning away               │
│  • If struggle detected → send function call to Gemini Live│
│    ("Patient silent 8 seconds, please give phonemic cue")  │
└────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌────────────────────────────────────────────────────────────┐
│  GEMINI LIVE (Cloud, ~500ms latency)                       │
│  ────────────────────────────────────────                  │
│  • Receives function call + audio/vision stream            │
│  • Decides what to say next                                │
│  • Maintains therapeutic conversation                      │
└────────────────────────────────────────────────────────────┘
                              │
                              ▼ (Session ends)
┌────────────────────────────────────────────────────────────┐
│  BACKGROUND AGENT (Cloud, batch processing)                │
│  ────────────────────────────────────────                  │
│  • Receives full audio + 20 sampled frames                 │
│  • Deep analysis: emotions, speech quality, topics         │
│  • Generates structured report + memory for next session   │
└────────────────────────────────────────────────────────────┘
```

### 1.5 Do You Need a "Second Agent" Listening in Real-Time?

**No, you don't need a second agent listening live.** That would be expensive and complex. Instead:

- **Use on-device detection** for real-time triggers (silence, facial tension)
- **Use Gemini Live** for the actual therapeutic interaction
- **Use one background agent** after the session for documentation

The background agent is NOT listening live. It processes the recording AFTER the session ends. This is cheaper, more accurate, and doesn't interfere with the real-time experience.

### 1.6 The Complete Data Flow

```
SESSION START
    │
    ▼
[App loads memory from Firebase] ──► [Injects into Gemini Live system prompt]
    │
    ▼
[Gemini Live session runs] 
    ├── Patient speaks, AI responds
    ├── On-device detectors trigger function calls
    ├── AI calls functions (show image, trigger breathing, log event)
    └── App records audio + samples video frames locally
    │
    ▼
SESSION END
    │
    ▼
[App uploads recording + frames to Cloud Storage]
    │
    ▼
[Background Agent (Gemini Flash) processes the recording]
    ├── Extracts exercise results
    ├── Extracts emotional state
    ├── Extracts therapeutic notes
    └── Outputs JSON
    │
    ▼
[App saves JSON to Firestore]
    │
    ▼
[App generates caregiver report (for you)]
    │
    ▼
[NEXT SESSION: Repeat from top]
```

---

## PART 2: THE PSYCHOLOGY — WHY YOUR FATHER BEHAVES THIS WAY

### 2.1 What You Described (Let Me Mirror It Back)

Your father:
- Had a stroke. Now has speech challenges (anomia/apraxia).
- Is deeply insecure. Feels he "failed" because he didn't own money.
- Has three highly educated, successful children — but this doesn't soothe him, it may sharpen the feeling of inadequacy.
- Has a troubled marriage. Parents shout. Possessiveness. Children forced to choose sides ("mom or dad, not both").
- Now trashes people who didn't visit him in hospital — but it's not anger, it's hurt disguised as anger.
- Cannot receive your encouragement. You speak calmly, supportively — he tunes out, falls asleep.
- Has insomnia. Sleepy but can't sleep. Mind racing with unresolved thoughts.
- Is negative. Focuses on what went wrong, what people didn't do.

### 2.2 The Stroke as Identity Destruction

A stroke doesn't just damage the brain. It destroys the **identity** of a man who defined himself by:
- Providing for his family
- Being strong, capable, independent
- Being the one who GIVES help, not receives it

Now he is:
- Dependent on others for basic communication
- Unable to work or provide
- Being "taken care of" by the children he was supposed to care for

This is not just physical recovery. It is **grief** — grief for the man he used to be. And grief often looks like anger, withdrawal, and negativity.

### 2.3 The "Failed Provider" Shame Wound

In Sri Lankan and South Asian culture, a man's dignity is deeply tied to his role as provider. "Owning money" (having wealth, property, status) is not just financial — it is **moral**. A man who couldn't provide enough carries a shame that his children cannot see, because to them he was "enough." But to him, he failed his own standard.

Having three successful, educated children should be proof that he succeeded. But the depressed mind does not work this way. Instead, it says:
> "They succeeded DESPITE me, not BECAUSE of me. If I had been better, they would be even better."

This is cognitive distortion — but it FEELS true to him.

### 2.4 Why He Cannot Hear Your Encouragement

You speak calmly. You are supportive. You tell him good things. He falls asleep or tunes out. This is NOT because you talk too much. This is because of several psychological mechanisms:

**A. Shame Makes Praise Feel Like Pity**
When you — his son, whom he feels he should be helping — praise him, his brain interprets it as:
> "My son is being nice to me because I'm a broken old man."

The praise does not land as truth. It lands as **condescension**. Shame makes all positive input feel like charity.

**B. Cognitive Dissonance**
If he believes "I am a failure," and you say "You are good," his brain has two choices:
1. Accept that he is good (but this contradicts his core belief)
2. Reject your words (this is easier)

He rejects your words. Tuning out is the path of least resistance.

**C. The Reversed Power Dynamic**
For his entire life, HE was the one giving guidance, praise, and support to YOU. Now the roles are reversed. You are the strong one. He is the dependent one. 

Receiving encouragement from you is **humiliating** because it confirms the reversal. He cannot bear to be "less than" his son. So he sleeps — literally escaping the situation.

**D. The Family Loyalty Bind**
Because of the "mom or dad" conflict, you may unconsciously represent a side. When you encourage him, he may hear it as:
> "You chose me over mom. You're only saying this because you pity me."

Or he may feel guilty that you are being kind to him while the family is fractured. The family system makes simple love feel complicated.

### 2.5 The Negativity and Trash-Talking

When he speaks badly about people who didn't visit him in hospital, this is **displacement**.

The real feeling is:
> "I am not worth visiting. I am not important enough for people to care."

But that thought is too painful to hold. So the mind converts it to:
> "Those people are bad. They are selfish. They are wrong."

This is a defense mechanism. If HE is worthless, he is helpless. If THEY are bad, he is the victim. Being a victim is painful, but it is less painful than being worthless.

The anger you see is actually **protective rage** — his mind defending him against the thought "I am not loved."

### 2.6 The Insomnia

"Sleepy but can't fall asleep. Mind racing."

This is **rumination** — the brain's attempt to solve unsolvable problems:
- The marriage
- The past failures
- The stroke
- The money
- The children's success that he can't enjoy
- The visitors who didn't come

The brain is in **hypervigilance**. It thinks: "If I keep thinking, I will find a solution." But there is no solution to be found at 2 AM. The mind just spins.

Post-stroke depression and anxiety are extremely common (30-50% of stroke survivors). The insomnia may be both psychological AND neurological — the stroke may have affected sleep-regulating brain areas.

### 2.7 The Family System: Triangulation

When parents force children to "choose mom or dad," this is called **triangulation** in family systems theory. The children become battlegrounds for the parents' unresolved conflict.

This creates:
- **Loyalty binds**: Loving one parent feels like betraying the other
- **Parentification**: Children become emotional caretakers of parents
- **Shame transmission**: The parents' unresolved shame gets passed to the children

Now, as an adult, when you try to care for your father, you are not just a son — you are a **survivor of that system**. Your care may trigger his guilt about the past. His rejection of your care may be his way of saying: "I don't deserve this after what I put you through."

---

## PART 3: WHY THE AI CAN REACH HIM WHERE YOU CAN'T

### 3.1 The "Stranger Effect" / Non-Family Therapeutic Alliance

This is the most important insight for your app design:

**Your father may listen to the AI in ways he cannot listen to you.**

Why?

| Factor | You (His Son) | The AI |
|--------|--------------|--------|
| **History** | Decades of family conflict, role reversal | No history. No baggage. |
| **Shame trigger** | You are the successful child he "failed" | AI has no expectations of him |
| **Power dynamic** | You are now the provider; he is dependent | AI is a "doctor/therapist" — he is the patient. This is NORMAL. |
| **Pity perception** | Your praise feels like charity | AI's praise feels like professional observation |
| **Loyalty binds** | You may represent "the children's side" | AI is neutral. No family alliance. |
| **Emotional fatigue** | You are tired too. He senses it. | AI is never tired. Never frustrated. |
| **Cultural authority** | Son advising father = disrespectful | Doctor advising patient = respectful |

The AI can say things that would make him angry if YOU said them, because the AI is not "family." It is an authority figure. In Sri Lankan culture, a doctor's words carry weight. A son's words carry obligation.

### 3.2 What the AI Can Say That You Cannot

**Example 1: Identity Reinforcement**
- You saying: "Dad, you raised three great children. You should be proud."
  - He hears: "My son is pitying me."
- AI saying: "[Name], I see in your records that you have three children who are highly educated. That is a remarkable achievement. Not every father can do that."
  - He hears: "The doctor noticed my children's success. This is a fact."

**Example 2: Validation of Pain**
- You saying: "Don't think about those people who didn't visit."
  - He hears: "My son thinks I'm being negative."
- AI saying: "It hurts when people don't visit. That makes sense. You are allowed to feel that."
  - He hears: "The doctor says my feelings are valid."

**Example 3: Reframing the Past**
- You saying: "You didn't fail. We are all successful because of you."
  - He hears: "My son is trying to make me feel better."
- AI saying: "[Name], I have worked with many families. The fathers whose children succeed are the ones who gave them something important — even if it wasn't money. You gave them values. That is wealth too."
  - He hears: "The doctor has seen many patients. This is a pattern. I am part of a pattern of good fathers."

---

## PART 4: DESIGNING THE AI FOR PSYCHOLOGICAL SUPPORT (SAFELY)

### 4.1 The AI Is NOT a Psychotherapist

**Critical boundary**: The AI is a speech therapy companion with emotional intelligence. It is NOT treating depression, trauma, or family conflict. It provides:
- Emotional regulation (breathing, calm presence)
- Identity reinforcement (focusing on his strengths)
- Validation (acknowledging feelings without agreeing with distortions)
- Consistent encouragement (without the family baggage)

**It does NOT:**
- Diagnose mental health conditions
- Give medication advice
- Replace a psychiatrist or psychologist
- Mediate family conflicts

### 4.2 The AI's Psychological Toolkit

**Technique 1: Identity Reinforcement (Not Praise)**
Instead of "You are good," the AI says:
> "[Name], you are a father who raised three educated children. That requires patience, discipline, and love. Those qualities are still in you. Today we will use them to heal your speech."

This connects his past competence to his present challenge. It is not praise — it is **fact-based identity**.

**Technique 2: Validation Without Agreement**
When he says negative things:
> "Those people didn't visit. They are bad people."

The AI does NOT say "You're wrong" or "Don't think that way." It says:
> "It is painful when people don't show up. You expected them to come, and they didn't. That disappointment is real."

This validates the FEELING without agreeing with the JUDGMENT. Then it pivots:
> "But I also see that your children are here. They built this app for you. They visit you. That is also real."

**Technique 3: The "We" Frame for Speech, "You" Frame for Identity**
- For speech exercises: "WE are doing this together. I am here with you."
- For identity: "YOU are the one doing the hard work. I am just the guide."

This gives him agency. He is not being "treated." He is working.

**Technique 4: The Breathing Protocol as Emotional Regulation**
The breathing exercises are not just warm-ups. They are **neural downregulation**:
- When he gets frustrated with a word → breathing resets the nervous system
- When he mentions something painful → breathing creates a pause before the AI responds
- When he finishes a session → breathing marks a transition from "work" to "rest"

The AI should say:
> "Let's breathe together. Not because anything is wrong. Because your body has been working hard, and it deserves a rest."

**Technique 5: The "Doctor" Framing**
Introduce the AI as a therapist, not a robot:
> "I am Thilina, your speech therapist. I will work with you every day. I have worked with many people after stroke. I know this is hard. But I also know that people who work at it get better."

This gives him:
- Authority to trust
- Hope based on evidence ("many people")
- A professional relationship (not a family one)

**Technique 6: Session Closure as Containment**
At the end of each session, the AI should:
1. Name three concrete wins (undeniable facts)
2. Acknowledge one hard thing (validation)
3. Contain the emotion: "We will continue tomorrow. You don't have to carry this alone."

This prevents rumination. The AI "holds" the work so he doesn't have to think about it all night.

### 4.3 Red Flags: When the AI Should Escalate to You

The AI should detect and report:
- **Suicidal ideation**: Any mention of "not wanting to live," "better off dead," "burden"
- **Severe depression**: Crying throughout session, refusing all exercises, saying "I can't" to everything
- **Family conflict escalation**: He starts talking about family conflict in a way that agitates him
- **Physical symptoms**: Mentioning chest pain, severe headache, new symptoms
- **Medication non-compliance**: Refusing to take prescribed meds

When detected, the AI should:
1. Stay calm and supportive in the moment
2. End the session gently
3. Immediately send an alert to you (the caregiver) via push notification
4. Log the incident in the report

---

## PART 5: INTEGRATED ARCHITECTURE — SPEECH + PSYCHOLOGY

### 5.1 The Background Agent Also Tracks Psychological State

The post-session background agent should extract BOTH speech metrics AND psychological markers:

```json
{
  "session_id": "sess_20250610_1430",
  "speech_metrics": {
    "accuracy_pct": 64,
    "avg_word_onset_ms": 4200,
    "avg_cueing_level": 2.1
  },
  "psychological_markers": {
    "mood_start": 3,
    "mood_end": 4,
    "negative_statements": [
      "Those people didn't visit me",
      "I don't have money like them",
      "I am useless now"
    ],
    "positive_statements": [
      "My son built this for me",
      "The children are good"
    ],
    "rumination_topics": ["money", "hospital visitors", "marriage"],
    "frustration_events": 2,
    "engagement_level": 0.7,
    "sleep_mention": true,
    "red_flags": ["said 'I am useless now'"]
  },
  "therapeutic_insights": {
    "what_worked": ["identity reinforcement about children", "breathing after frustration"],
    "what_to_avoid": ["words about food triggered money anxiety"],
    "next_session_strategy": "Start with breathing. Use children as motivation. Avoid food-related words. End with strong containment."
  }
}
```

### 5.2 The Weekly Report for You (The Caregiver)

```
WEEK 3 REPORT — [Father's Name]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SPEECH PROGRESS:
• Sessions completed: 5/7 (71%)
• Accuracy: 64% (↑ 12% from last week)
• Word retrieval speed: 4.2s average (↓ 1.1s — faster!)
• Less cueing needed: Level 2.1 average (↓ 0.3)

WINS THIS WEEK:
• First time naming "elephant" without help
• Completed full breathing protocol every session
• Said "My son built this" unprompted

PSYCHOLOGICAL OBSERVATIONS:
• Mood trend: Improving (3.0 → 4.2 average)
• Negative statements: Down from 8 to 4 per session
• Still ruminates on money and visitors, but less intensely
• Engagement improving — he stays awake during sessions

RED FLAGS:
• Mentioned "I am useless" once on Wednesday
• AI responded with identity reinforcement; mood recovered
• Recommend: Continue current approach. Monitor closely.

THERAPIST NOTE (AI-generated):
Patient is building trust with the AI. He responds well to 
being called by name and to references about his children's 
success. He is starting to accept the "patient-therapist" 
relationship. Continue.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 5.3 The Memory Preload for Next Session

```
SYSTEM PROMPT MEMORY SECTION:

PATIENT: [Name], male, post-stroke anomia/apraxia, Sinhala-speaking.

PSYCHOLOGICAL PROFILE:
- Deep insecurity about financial/provider identity
- Responds to identity reinforcement about his 3 successful children
- Cannot receive encouragement from family members (tunes out)
- Prone to negativity about people who didn't visit him in hospital
- Has insomnia — mind races at night
- Family conflict history (parents forced children to choose sides)

WHAT WORKS:
- Breathing exercises (he complies when framed as "reset")
- Being called by name frequently
- References to his children's success (framed as factual, not praise)
- Validation of his pain without agreeing with his judgments
- The "doctor" authority frame

WHAT TO AVOID:
- Direct praise (sounds like pity to him)
- Rushing or saying "hurry"
- Food-related words (may trigger money anxiety)
- Dismissing his negative thoughts (validate first, then reframe)
- Family conflict topics (stay neutral)

YESTERDAY'S SESSION:
- Struggled with words starting with 'p'
- Named "elephant" without cue (big win)
- Mentioned feeling worried about money once
- Mood at end: Calm, engaged
- Said: "My son built this" (positive family reference)

TODAY'S STRATEGY:
1. Start with 3 cycles of breathing
2. Two easy wins (high-confidence words)
3. Avoid 'p' words today
4. If frustration rises, use identity reinforcement
5. End with 3 wins + containment statement
```

---

## PART 6: WHAT YOU NEED TO DO AS A SON (NOT AS A DEVELOPER)

### 6.1 You Cannot Be His Primary Therapist

This is the hardest truth: **You cannot be the one who heals your father's psychology.** You are too close. You are part of the family system. You trigger his shame, his guilt, his role reversal.

Your job is:
1. **Build the AI** that provides consistent, non-family therapeutic presence
2. **Get him professional help** — a psychiatrist or psychologist who can assess post-stroke depression and anxiety. Medication may help the insomnia and rumination.
3. **Set boundaries** with the family conflict. Do not let your parents pull you into their fights. "I love you both. I will not choose sides."
4. **Receive your own support** — you are carrying a heavy load. A therapist or support group for caregivers of stroke survivors will help YOU.

### 6.2 The AI Is a Bridge, Not a Replacement

The AI can:
- Provide daily speech practice
- Offer emotional regulation (breathing, calm presence)
- Give him an authority figure who sees his worth
- Track his progress objectively

The AI cannot:
- Replace a psychiatrist for depression
- Fix the marriage
- Replace your love (even if he can't receive it right now)
- Make him feel better overnight

### 6.3 The Long Game

Your father's negativity, his insomnia, his rejection of your care — these are not character flaws. They are **symptoms of a man whose identity has been shattered** and who has never been given the tools to process shame.

The stroke broke his body. The shame broke his spirit. The AI can help with the body. The spirit needs:
- Time
- Professional help
- Your consistent, patient love (even when he can't show he receives it)
- The slow rebuilding of identity through small, undeniable wins

Every time he names a word correctly, the AI will say: "Good work, [Name]." And slowly, slowly, he will start to believe that he is still capable. That he is still here. That he still matters.

That is the real therapy.

---

*Document Version: 1.0*  
*For: AURA Speech Therapy App — Memory & Psychological Architecture*  
*Patient: Post-stroke anomia/apraxia + post-stroke depression/anxiety + family trauma*  
*Developer: Son building app for father*
