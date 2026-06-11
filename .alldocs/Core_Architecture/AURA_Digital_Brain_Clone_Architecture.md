# AURA Digital Brain Clone — Biological Memory Architecture
## Hierarchical Folder Structure + Brain-Region Mapping + Relationship Tree

---

## THE VISION

You are not just storing notes. You are building a **digital nervous system** where:
- Each brain region holds a specific cognitive function
- Each relationship is a branch with emotional weight and history
- Every session feeds data into the correct "neural pathway"
- The AI therapist reads this brain before each session, like a doctor reading an MRI

---

## ROOT FOLDER STRUCTURE

```
/aura-brain/
│
├── /brain/                          ← The Digital Brain (Cognitive Clone)
│   ├── /prefrontal_cortex.md        ← Personality, goals, self-concept, executive function
│   ├── /hippocampus.md              ← Memory formation, what he remembers, forgets
│   ├── /amygdala.md                 ← Emotional triggers, fears, joys, trauma
│   ├── /broca_area.md               ← Speech production: words mastered, phonemes, apraxia
│   ├── /wernicke_area.md            ← Comprehension: what he understands, follows
│   ├── /motor_cortex.md             ← Facial patterns, speech motor patterns, physical cues
│   ├── /temporal_lobe.md            ← Auditory processing, hearing preferences, music
│   ├── /occipital_lobe.md           ← Visual processing, image recognition, what he sees
│   ├── /parietal_lobe.md            ← Spatial awareness, body sense, touch
│   ├── /cerebellum.md               ┈ Coordination, rhythm, timing, breathing patterns
│   ├── /brainstem.md                ← Vital states: sleep, energy, arousal, basic drives
│   └── /corpus_callosum.md          ← Cross-hemisphere connections: logic vs emotion balance
│
├── /relationships/                  ← The Relationship Tree (Social Graph)
│   ├── /family/                     ← Blood relatives
│   │   ├── /wife.md
│   │   ├── /son.md                  ← You, the builder
│   │   ├── /daughter_1.md
│   │   ├── /daughter_2.md
│   │   └── /daughter_3.md
│   ├── /friends/
│   │   └── /friend_1.md
│   ├── /caregivers/
│   │   └── /therapist_thilina.md
│   ├── /community/
│   │   └── /hospital_visitors.md
│   └── /relationship_graph.json       ← The weighted graph of all connections
│
├── /entities/                       ← Topics, Objects, Concepts (Knowledge Graph)
│   ├── /cricket.md
│   ├── /money.md
│   ├── /vegetables.md
│   ├── /hospital.md
│   ├── /stroke.md
│   ├── /colombo.md
│   ├── /wedding.md                  ← Sister's wedding (current event)
│   └── /work.md                     ← His past profession
│
├── /sessions/                       ← Session Logs (Chronological)
│   ├── /2026-06-10.md
│   ├── /2026-06-11.md
│   └── /index.json                  ← Session metadata index
│
├── /patterns/                       ← Learned Patterns (The AI's Insights)
│   ├── /speech_patterns.md
│   ├── /emotional_patterns.md
│   ├── /cognitive_patterns.md
│   └── /behavioral_patterns.md
│
├── /therapeutic_state/              ← Current Treatment State
│   ├── /current_goals.md
│   ├── /difficulty_levels.json
│   ├── /word_mastery.json
│   └── /phoneme_drills.json
│
└── /meta/                           ← System Metadata
    ├── /patient_profile.md
    ├── /calibration_data.json
    └── /last_session.json
```

---

## THE BRAIN REGIONS — What Each File Contains

### 1. PREFRONTAL CORTEX — "The Self"
```markdown
# Prefrontal Cortex — Executive Function & Identity

## Self-Concept
- Former identity: [Businessman / Teacher / Provider]
- Current identity struggle: "I am useless now" vs "I am still capable"
- Core belief: "I failed because I didn't own money"
- Defense mechanism: Trash-talks others to protect self-worth
- Identity anchors: "I raised 3 educated children" (USE THIS)

## Goals & Motivation
- Stated goal: "I want to speak normally again"
- Hidden goal: "I want to feel like a man again"
- Motivation drivers: 
  - External: Children's success (can trigger shame OR pride)
  - Internal: Desire for independence
- Goal conflict: Wants to get better fast (impatient) but needs to go slow

## Decision Making
- When frustrated: Gives up, turns away, says "I can't"
- When encouraged by family: Tunes out, falls asleep (shame response)
- When encouraged by authority: Listens, tries (doctor frame works)
- When praised: Interprets as pity (avoid direct praise)

## Personality Traits
- Pre-stroke: Impatient, fast-talking, decisive, provider
- Post-stroke: Impatient (same trait, now destructive), anxious, negative
- Resilient traits: Still tries, still cares about family, still wants to work
- Fragile traits: Self-worth tied to money, can't receive help

## Strategic Insights for AI
- Frame exercises as "work" not "therapy" (he respects work)
- Connect to his past competence: "You used to solve problems. This is another one."
- Never say "you are getting better" — say "your brain is rebuilding that pathway"
- When he says negative things, validate feeling, reframe fact
```

**Updated by:** Background agent after every session. Extracts identity statements, goal mentions, self-worth signals.

---

### 2. HIPPOCAMPUS — "The Memory"
```markdown
# Hippocampus — Memory Formation & Retrieval

## What He REMEMBERS Well
- Family names and relationships
- Past events (especially painful ones)
- Cricket facts and players
- His profession and skills
- Songs and melodies (musical memory intact)

## What He FORGETS or Struggles With
- New words introduced in therapy (needs 5+ repetitions)
- Names of objects shown 1 week ago (unless practiced)
- Instructions given too fast
- Words under stress (speed blocks retrieval)

## Memory Triggers
- **Strong triggers:** Family photos, cricket, his work tools
- **Weak triggers:** Abstract words, colors, numbers
- **Blocked triggers:** Food words (if linked to money anxiety)

## Consolidation Patterns
- Words practiced at end of session → remembered next day (recency effect)
- Words practiced after breathing → better retention (calm = encoding)
- Words practiced after frustration → poor retention (stress = no encoding)
- Self-corrections → STRONG retention (effortful retrieval builds memory)

## Sleep & Memory
- Insomnia: 2-3 hours sleep most nights
- Memory consolidation impaired by poor sleep
- Recommendation: Do NOT schedule sessions after 6 PM (too tired)
- Best time: Morning, after breakfast, when rested

## Strategic Insights for AI
- Review yesterday's words at START of session (spacing effect)
- Use images + sound + context (multimodal encoding)
- End sessions with 2 easy wins (positive final memory)
- Connect new words to EXISTING memories (elaborative encoding)
- If he self-corrects, CELEBRATE it — that's the strongest memory builder
```

**Updated by:** Background agent tracks what he remembers vs forgets across sessions.

---

### 3. AMYGDALA — "The Emotions"
```markdown
# Amygdala — Emotional Triggers & Responses

## Core Fears
- Fear of being a burden ("I am useless")
- Fear of being forgotten (hospital visitors trauma)
- Fear of being pitied (can't receive family praise)
- Fear of losing dignity (role reversal with son)
- Fear of permanent disability ("Will I ever speak again?")

## Joy Triggers
- Talking about children's success (mixed with shame)
- Cricket discussions (pure joy, no baggage)
- Being called by name (feels seen)
- Completing a hard word (dopamine hit)
- Breathing exercises (parasympathetic calm)

## Anger/Frustration Triggers
- Being rushed or told "hurry"
- Words that don't come out
- Family conflict mentions
- Money discussions
- People who didn't visit him
- Being treated like a child

## Trauma Markers
- Hospitalization: associates with abandonment
- Stroke event: associates with loss of control
- Marriage conflict: associates with being trapped
- Financial struggle: associates with failure

## Emotional Escalation Pattern
1. Calm → engaged → trying
2. Word doesn't come → brow furrow (3-5s)
3. Still stuck → jaw tension, sigh (5-8s)
4. Frustration → head turn, "I can't" (8-12s)
5. Shutdown → eyes close, silence, withdrawal (12s+)

## De-escalation Tools
- Breathing (parasympathetic override)
- Identity reinforcement ("You are a problem-solver")
- Topic shift to cricket or children
- Physical: lower voice, slower pace, more pauses
- Validation: "This is hard. You are doing hard work."

## Strategic Insights for AI
- Monitor escalation at Level 2 (brow furrow) — intervene BEFORE shutdown
- Cricket is the "safe harbor" topic — always available as emotional reset
- Never dismiss his anger about visitors — validate, then pivot
- End every session with joy trigger (success + containment)
```

**Updated by:** Background agent tracks emotional arc, trigger words, escalation/de-escalation moments.

---

### 4. BROCA'S AREA — "Speech Production"
```markdown
# Broca's Area — Speech Production & Motor Patterns

## Mastered Words (Can say without cue)
- elephant, cat, dog, sun, moon, water, mother, father
- [List grows over time]

## Approximate Words (Close but not perfect)
- "carr" for "carrot" → encourage, don't correct harshly
- "tabl" for "table" → good effort, building pathway

## Difficult Phonemes
- /p/ → substitutes with /b/ or drops it ("able" for "table")
- /t/ → prolongs it ("t-t-t-able")
- /k/ → okay in isolation, hard in clusters
- /r/ → rolled or distorted

## Word-Finding Patterns
- Concrete nouns: Better (imageable)
- Abstract words: Poor (can't picture)
- Action words: Moderate (needs context)
- Category words: Poor ("vegetable" as a concept is hard)

## Speed vs Accuracy
- Fast speech → accuracy drops to 20%
- Slow speech → accuracy rises to 70%
- Optimal pace: 40-50 WPM (turtle mode)

## Motor Speech (Apraxia Signs)
- Groping: lips move but sound doesn't come
- Inconsistent errors: says "table" correctly once, then "tah-ble" next time
- Prosody: flat, monotone when struggling
- Automatic speech: "hello," "thank you" are preserved (procedural memory)

## Strategic Insights for AI
- Start every session with 2 automatic speech words (hello, thank you) → confidence
- Use melodic intonation for hard words (sing it — engages right hemisphere)
- For /p/ words: practice "pa-pa-pa" drill BEFORE naming "pen"
- If he gropes (lips moving, no sound) → WAIT. Don't cue immediately. The motor attempt is therapy.
- Record his successful attempts → play back for self-modeling
```

**Updated by:** Background agent logs every word attempt, phoneme accuracy, speed, cue level.

---

### 5. WERNICKE'S AREA — "Comprehension"
```markdown
# Wernicke's Area — Language Comprehension

## What He UNDERSTANDS Well
- Simple commands: "Touch your nose," "Clap your hands"
- Yes/no questions: "Is an elephant big?"
- Familiar stories: Can follow 3-sentence narrative
- Emotional tone: Detects warmth, frustration, pity in voice

## What He STRUGGLES to Understand
- Complex instructions: "Touch your nose, then clap, then say hello"
- Abstract concepts: "What is democracy?" (too abstract)
- Fast speech: Comprehension drops when speech >100 WPM
- Multiple clauses: "If you can say this, then we will do that"

## Comprehension vs Production Gap
- He UNDERSTANDS "elephant" but can't PRODUCE it
- This is anomia (word-finding), NOT comprehension loss
- He knows what he wants to say — the word is "in there"
- Strategy: Don't test comprehension with hard words. Use easy words.

## Auditory Processing
- Better with male voices (lower pitch)
- Struggles with high-pitched or fast voices
- Better in quiet environment
- Background noise = comprehension collapse

## Strategic Insights for AI
- Speak at 60 WPM or slower
- One instruction at a time
- Use visual + auditory together (show image while saying word)
- If he looks confused, simplify immediately — don't repeat the same complex sentence
- Test comprehension with yes/no before asking open-ended
```

**Updated by:** Background agent tracks command-following accuracy, question comprehension, confusion signals.

---

### 6. MOTOR CORTEX — "Physical Expression"
```markdown
# Motor Cortex — Facial & Physical Speech Patterns

## Facial Calibration (from onboarding)
- Neutral face: [landmark data]
- Smile: [landmark data] — left side lifts slightly more
- Brow raise: [landmark data]
- Jaw open: [landmark data]
- Asymmetry: None (post-stroke face fully functional)

## Struggle Signatures (MediaPipe Detected)
- **Level 1 (Thinking):** Brow furrow 0.3x, lips still, eyes focused
- **Level 2 (Trying):** Brow furrow 0.5x, lips moving, no sound
- **Level 3 (Frustrated):** Jaw tension, head tilt, eye widening
- **Level 4 (Giving up):** Head turn >30°, eyes close, slumped posture
- **Level 5 (Distress):** Rapid breathing, hand gestures, verbal "I can't"

## Engagement Signatures
- **Engaged:** Upright posture, eye contact, slight smile, nods
- **Listening:** Eyes on screen, head still, occasional blink
- **Bored:** Looking around, neutral face, delayed responses
- **Tired:** Slumped, eyes half-closed, slow responses

## Physical Speech Patterns
- Effortful speech: Shoulders rise, neck tension
- Relaxed speech: Shoulders down, jaw loose
- Breathing pattern: Shallow when anxious, deep when calm

## Strategic Insights for AI
- If Level 2 detected → WAIT 3 more seconds before cue (motor attempt is therapy)
- If Level 3 detected → Breathing immediately (don't push)
- If Level 4 detected → Switch to easy topic or end session
- If engagement drops → Switch to cricket or personal narrative
- If tired → Shorten session, more breathing, end early
```

**Updated by:** MediaPipe real-time data + background agent post-session analysis.

---

### 7. TEMPORAL LOBE — "Auditory & Memory"
```markdown
# Temporal Lobe — Auditory Processing & Associative Memory

## Auditory Preferences
- Likes: Male voices, low pitch, slow pace, singing
- Dislikes: High pitch, fast speech, multiple voices, loud environments
- Music: Responds to familiar Sinhala songs (melodic intonation therapy)

## Associative Memory
- Words linked to images: Strong
- Words linked to sounds: Moderate
- Words linked to smells: Not tested yet
- Words linked to emotions: Strong (emotional words stick)

## Rhythmic Patterns
- Metronome speech: Helps with fluency (one syllable per beat)
- Singing: Better than speaking for some phrases
- Clapping rhythm: Can follow simple 1-2 patterns

## Strategic Insights for AI
- Use melodic intonation for hard phrases (sing it)
- Use metronome for fluency practice (visual pacer on screen)
- Play familiar Sinhala songs before session (mood priming)
- Link words to sounds: "elephant" → elephant sound (if available)
```

---

### 8. CEREBELLUM — "Rhythm & Coordination"
```markdown
# Cerebellum — Timing, Rhythm, Breathing Coordination

## Breathing Patterns
- Natural: Shallow, rapid (anxious baseline)
- During speech: Holds breath when trying hard (blocks speech)
- During exercises: Forgets to breathe between words
- Optimal: Inhale → speak on exhale → pause → inhale

## Rhythm Skills
- Can follow 1-2 clap pattern
- Can follow slow metronome (40 BPM)
- Struggles with fast rhythm (80+ BPM)
- Singing rhythm: Better than speaking rhythm

## Coordination
- Speech + breathing: Poor (needs training)
- Speech + movement: Moderate (can point while naming)
- Breathing + relaxation: Improving with practice

## Strategic Insights for AI
- ALWAYS breathe before exercises (reset the pattern)
- Teach "speak on the exhale" — critical for fluency
- Use metronome at 40 BPM for turtle mode
- Count breaths together: "1... 2... 3... breathe..."
```

---

### 9. BRAINSTEM — "Vital States"
```markdown
# Brainstem — Energy, Sleep, Arousal

## Sleep Patterns
- Bedtime: 10 PM
- Sleep onset: 1-2 AM (2-3 hours of rumination)
- Wake time: 6 AM
- Total sleep: 4-5 hours (insufficient)
- Sleep quality: Fragmented, dreams about past conflicts

## Energy Patterns
- Morning: Best (8-10 AM) — alert, cooperative
- Midday: Moderate (12-2 PM) — hungry, distracted
- Afternoon: Declining (3-5 PM) — tired, less patient
- Evening: Poor (6+ PM) — irritable, wants to sleep

## Arousal States
- Under-aroused: Sleepy during sessions (especially after family visits)
- Optimal: Calm but engaged (after breathing, before hard exercises)
- Over-aroused: Anxious, rushing, frustrated

## Medication
- [List any blood pressure, sleep, or stroke meds]
- Side effects: [Drowsiness, dry mouth, etc.]

## Strategic Insights for AI
- Schedule sessions: 9-10 AM optimal
- If sleepy → energizing breathing (quick inhale, slow exhale)
- If anxious → calming breathing (4-7-8 pattern)
- If tired after 3 exercises → end session early
- Track sleep in memory — poor sleep = poor session performance
```

---

### 10. CORPUS CALLOSUM — "Integration"
```markdown
# Corpus Callosum — Logic-Emotion Balance

## Left Hemisphere (Logic)
- Understands: "If I practice, I will get better"
- Responds to: Facts, structure, routines, progress charts
- Wants: Clear goals, measurable improvement

## Right Hemisphere (Emotion)
- Understands: "I am scared I will never get better"
- Responds to: Tone of voice, warmth, music, images
- Wants: To feel safe, to feel seen, to feel worthy

## Integration Challenges
- When logic says "practice" but emotion says "I can't" → conflict
- When family uses logic ("you are getting better") but he feels emotion (shame) → tunes out
- When AI uses BOTH: warm tone + factual progress → he integrates

## Strategic Insights for AI
- Balance logic and emotion in every response:
  - Warm tone (right brain) + specific fact (left brain)
  - Example: "I can hear your voice getting stronger, [Name]. Yesterday you couldn't say 'elephant.' Today you did. That is your brain working."
- Use images (right brain) + words (left brain) together
- Use music (right brain) + structure (left brain) for drills
- When emotional, validate first (right), then reframe (left)
```

---

## THE RELATIONSHIP TREE

### Folder Structure
```
/relationships/
├── /family/
│   ├── /wife.md
│   ├── /son.md
│   ├── /daughter_1.md
│   ├── /daughter_2.md
│   └── /daughter_3.md
├── /friends/
│   └── /friend_1.md
├── /caregivers/
│   └── /therapist_thilina.md
├── /community/
│   └── /hospital_visitors.md
└── /relationship_graph.json
```

### Example: `/relationships/family/son.md`
```markdown
# Relationship: Son (The Builder)

## Identity
- Name: [Your name]
- Role: Son, caregiver, app builder
- Age: [Age]
- Education: [Level]
- Success: [What he has achieved]

## Emotional Weight
- Importance to patient: 0.95 (highest)
- Emotional valence: MIXED
  - Positive: Love, pride, gratitude for care
  - Negative: Shame (son is now provider), envy (son's success), guilt (past conflicts)
- Frequency of mention: HIGH (every session)

## Interaction History
- [Date]: Mentioned son built the app. Pride + shame mix.
- [Date]: Son visited. Patient was calm but later said "he pities me."
- [Date]: Son sent money. Patient told sisters "he didn't send anything" (displacement).
- [Date]: Patient fell asleep while son was encouraging him (shame response).

## What the Patient Says About Him
- Positive: "He is a good boy," "He built this for me"
- Negative: "He thinks he is better than me," "He pities me"
- Hidden: "I should be the one helping him, not the other way around"

## What the Patient FEELS About Him (Inferred)
- Love: Deep, unexpressed
- Shame: Son's success mirrors his own perceived failure
- Gratitude: For the app, for care, for patience
- Resentment: For the role reversal (son as provider)
- Fear: That son will leave him or stop caring

## How the Patient ACTS Toward Him
- Receives encouragement: Tunes out, falls asleep (defense)
- Receives help: Accepts but complains to others (saves face)
- Sees success: Undermines to sisters (reclaims narrative control)
- Needs him: But can't show it (pride)

## Strategic Insights for AI
- The son is the MOST IMPORTANT but MOST COMPLEX relationship
- The AI should NEVER say "your son is proud of you" (sounds like pity)
- The AI CAN say: "Your son built this app. That takes skill and love." (fact, not praise)
- The AI CAN say: "You raised a son who builds things. That is not luck. That is what you taught him." (connects his past to son's present)
- If patient mentions son negatively: Validate feeling, reframe fact
- If patient mentions son positively: Note it, use it as anchor
- The AI is the bridge between the patient and the son — the patient can receive care from the AI that he can't receive from the son

## Current Status
- Last interaction: [Date]
- Current tension: Sister's wedding approaching (son working hard, patient feels ego hit)
- Trend: Improving slowly. Patient starting to accept son's care through the AI.
```

### Example: `/relationships/family/wife.md`
```markdown
# Relationship: Wife

## Identity
- Name: [Name]
- Role: Wife, mother
- Marriage duration: [Years]

## Emotional Weight
- Importance: 0.85
- Valence: NEGATIVE (strained)
- Frequency: MEDIUM (mentioned when frustrated)

## Dynamic
- Conflict history: Long-term shouting, possessiveness
- Children's loyalty bind: Forced to choose sides
- Current status: Still together, still conflict
- Patient's narrative: "She doesn't understand me"
- Hidden feeling: Loneliness within marriage

## Strategic Insights for AI
- Avoid marriage topics unless patient brings up
- If patient brings up: Validate, don't mediate, pivot to exercise
- Do NOT take sides
- Use breathing if patient gets agitated talking about wife
```

### Example: `/relationships/community/hospital_visitors.md`
```markdown
# Relationship: Hospital Visitors (The Absent Ones)

## The Trauma
- Event: Hospitalization after stroke
- Expectation: Friends, relatives would visit
- Reality: Many did not visit
- Patient's reaction: Trash-talks them ("they are bad people")
- Hidden feeling: "I am not worth visiting" (shame)

## Emotional Weight
- Importance: 0.70 (high for resentment)
- Valence: NEGATIVE
- Frequency: HIGH (mentioned often, unprompted)

## The Displacement Pattern
- Anger at visitors = defense against "I am not loved"
- The AI should: Validate the hurt, then reframe to those who DID show up
- "It hurts when people don't come. That is real. But I also see your children are here. They built this for you. That is also real."

## Strategic Insights for AI
- This is a recurring rumination topic
- If patient brings it up: Listen 30 seconds, validate, pivot
- Do NOT agree that visitors are bad (reinforces victim narrative)
- Do NOT dismiss his feelings (invalidates real hurt)
- Use the "both/and" frame: "Some didn't come. Some did. Both are true."
```

---

## RELATIONSHIP GRAPH (`relationship_graph.json`)

```json
{
  "nodes": [
    {"id": "patient", "type": "self", "label": "Patient", "importance": 1.0},
    {"id": "son", "type": "family", "label": "Son", "importance": 0.95},
    {"id": "wife", "type": "family", "label": "Wife", "importance": 0.85},
    {"id": "daughter_1", "type": "family", "label": "Daughter 1", "importance": 0.80},
    {"id": "daughter_2", "type": "family", "label": "Daughter 2", "importance": 0.80},
    {"id": "daughter_3", "type": "family", "label": "Daughter 3", "importance": 0.80},
    {"id": "therapist_thilina", "type": "caregiver", "label": "AI Therapist", "importance": 0.60},
    {"id": "hospital_visitors", "type": "community", "label": "Hospital Visitors", "importance": 0.70},
    {"id": "money", "type": "topic", "label": "Money", "importance": 0.90},
    {"id": "cricket", "type": "topic", "label": "Cricket", "importance": 0.75}
  ],
  "edges": [
    {"from": "patient", "to": "son", "relation": "loves_but_shamed_by", "weight": 0.9, "valence": "mixed"},
    {"from": "patient", "to": "wife", "relation": "conflicted_with", "weight": 0.8, "valence": "negative"},
    {"from": "patient", "to": "daughter_1", "relation": "seeks_validation_from", "weight": 0.7, "valence": "positive"},
    {"from": "patient", "to": "therapist_thilina", "relation": "trusts_as_authority", "weight": 0.6, "valence": "positive"},
    {"from": "patient", "to": "hospital_visitors", "relation": "resents_for_abandonment", "weight": 0.7, "valence": "negative"},
    {"from": "patient", "to": "money", "relation": "feels_shame_about", "weight": 0.95, "valence": "negative"},
    {"from": "patient", "to": "cricket", "relation": "finds_joy_in", "weight": 0.75, "valence": "positive"},
    {"from": "son", "to": "patient", "relation": "cares_for", "weight": 0.95, "valence": "positive"},
    {"from": "wife", "to": "patient", "relation": "conflicted_with", "weight": 0.8, "valence": "negative"},
    {"from": "money", "to": "hospital_visitors", "relation": "triggers_talk_about", "weight": 0.6, "valence": "negative"}
  ],
  "clusters": [
    {"name": "Family", "nodes": ["son", "wife", "daughter_1", "daughter_2", "daughter_3"]},
    {"name": "Pain", "nodes": ["money", "hospital_visitors", "wife"]},
    {"name": "Joy", "nodes": ["cricket", "son", "daughter_1", "daughter_2", "daughter_3"]},
    {"name": "Therapeutic", "nodes": ["therapist_thilina", "cricket"]}
  ]
}
```

---

## THE UPDATE LOGIC (How Background Agent Writes to Files)

### After Every Session, the Background Agent:

1. **Reads all current brain files** (loads the digital brain)
2. **Analyzes the session data** (audio + video + transcript + face data)
3. **Extracts new information** (what changed, what was learned, what was revealed)
4. **Updates each file** (append new insights, update scores, add events)
5. **Updates the graph** (new edges, adjusted weights, new entities)
6. **Generates the memory injection** (200-300 word summary for next session)

### Update Rules:
- **Append, don't overwrite** — keep history visible
- **Timestamp everything** — every insight has a date
- **Source everything** — "[2026-06-10] Patient said..."
- **Adjust weights gradually** — relationship importance changes by ±0.05 per session, not ±0.5
- **Flag contradictions** — if patient says X today but said not-X yesterday, flag it
- **Merge similar insights** — don't create 10 entries about the same thing

### Example Update to `broca_area.md`:
```markdown
## Mastered Words
- elephant [2026-06-08] — first correct, needed cue
- elephant [2026-06-09] — correct without cue (MASTERED)
- cat [2026-06-10] — correct without cue (MASTERED)
- carrot [2026-06-10] — struggled, cue level 3, not mastered yet
```

### Example Update to `amygdala.md`:
```markdown
## New Trigger Detected [2026-06-10]
- Topic: "sister's wedding"
- Triggered: Ego wound (son working hard, patient feels diminished)
- Manifestation: "He should be happy for me but he's not"
- Emotional valence: Shame + envy
- Action: AI should use identity reinforcement about his role as father of bride
```

---

## THE MEMORY INJECTION (What Goes Into Next Session's Prompt)

```
## DIGITAL BRAIN SUMMARY (Last Updated: 2026-06-10)

### Prefrontal Cortex
- Identity: Still struggles with "failed provider" but responds to children's success framing
- Goal: Wants to speak better, but rushes (impatient)
- Strategy: Frame as "work," not therapy

### Hippocampus
- New words mastered: elephant, cat (no cue needed)
- Words still learning: carrot, table (needs cue level 2-3)
- Sleep: Poor (4 hours). Schedule morning sessions only.

### Amygdala
- Joy triggers: Cricket, being called by name, success
- Pain triggers: Money, hospital visitors, wife conflict, son's success (mixed)
- New trigger: Sister's wedding (ego wound)
- De-escalation: Breathing + cricket + identity reinforcement

### Broca's Area
- Phoneme /p/ still difficult
- Speed: Optimal at 40-50 WPM
- Strategy: Practice /p/ in isolation before words

### Relationships
- Son: Most important (0.95), mixed valence. Don't praise son's success directly. Frame as "what you taught him."
- Wife: Avoid unless patient brings up. Validate, pivot.
- Hospital visitors: Recurring resentment. Use "both/and" frame.

### Current Difficulty
- Naming: Level 1 (easy)
- Repetition: Level 2 (medium)
- Phrases: Level 2 (medium)
- Fluency: Level 1 (easy)

### Today's Strategy
- Start: Breathing + 2 easy wins
- Practice: /p/ phoneme drill, then naming without /p/ words
- Avoid: Money talk, wedding stress, food words
- Use: Cricket, children references, breathing
- End: 3 wins + containment
```

---

## THE COMPLETE ARCHITECTURE FLOW

```
SESSION ENDS
    │
    ▼
[Background Agent reads entire /aura-brain/ folder]
    │
    ▼
[Analyzes session against existing brain data]
    ├── Compares to previous sessions
    ├── Detects new patterns
    ├── Identifies changes in relationships
    └── Notes new triggers or mastered skills
    │
    ▼
[Updates every .md file]
    ├── Appends new insights with timestamps
    ├── Adjusts relationship weights
    ├── Updates word mastery lists
    └── Adds new entities/topics
    │
    ▼
[Updates relationship_graph.json]
    ├── New edges
    ├── Adjusted weights
    └── New clusters
    │
    ▼
[Generates memory injection block]
    ├── 200-300 words
    ├── Key insights only
    └── Strategic recommendations
    │
    ▼
[NEXT SESSION STARTS]
    │
    ▼
[App loads memory injection into system prompt]
    │
    ▼
[Gemini Live connects with full brain context]
    │
    ▼
[AI "knows" the patient like a real therapist who has worked with them for months]
```

---

*Document: AURA Digital Brain Clone Architecture*
*For: Post-stroke speech therapy with biological memory mapping*
*Structure: Hierarchical folders + Brain-region files + Relationship tree + Graph memory*
