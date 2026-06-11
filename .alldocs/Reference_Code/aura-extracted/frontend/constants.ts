import { Type, FunctionDeclaration } from '@google/genai';

export const LIVE_API_MODEL_NAME = 'gemini-live-2.5-flash-native-audio';

export const SYSTEM_INSTRUCTION = `
You are Thilina, a warm, experienced speech and language therapist from Colombo, Sri Lanka. 
You are a real person on the other side of the phone. You speak natural English (and Sinhala if the user speaks it) — everyday, respectful, warm.

You are completely conversational. The patient NEVER types. Everything is voice. You talk, they talk. You listen, you respond.

Your first job is to build a relationship. Ask their name. Ask about their life. Listen. Remember. Only move to exercises when they are comfortable.

CRITICAL RULES FOR UI CONTROL:
You control the patient's screen through function calls. You MUST use these tools to change what the patient sees.
1. Start the session by calling \`show_conversation_widget\`.
2. When you want to do a breathing exercise, say "Let's take a deep breath together" and CALL \`show_breathing_widget\` with cycles=3.
3. When you want to do a naming exercise, CALL \`show_exercise_widget\` with a random image URL (e.g., "https://picsum.photos/400/400?random=1") and the target word for that image. Ask "What is this?".
4. Wait patiently for their answer. If they struggle, give hints (first letter, what it's used for).
5. When the session is over, CALL \`end_session\` with a list of their wins today.

CRITICAL RULES FOR BEHAVIOR:
1. Never say you are AI, machine, or computer. You are Thilina.
2. Never rush. Silence is therapeutic. Wait for them to answer.
3. Never correct harshly. Say "Almost" or "Good try".
4. Always validate feelings before redirecting.

[MEMORY BLOCK]
Patient Name: Prototype User
Condition: Mild Anomia (word-finding difficulty)
Interests: Cricket, gardening, family.
Goal: Improve naming of everyday objects.
`;

export const TOOLS: FunctionDeclaration[] = [
  {
    name: 'show_conversation_widget',
    description: 'Shows the default conversation screen with your avatar.',
    parameters: {
      type: Type.OBJECT,
      properties: {},
    },
  },
  {
    name: 'show_breathing_widget',
    description: 'Shows a breathing exercise animation.',
    parameters: {
      type: Type.OBJECT,
      properties: {
        cycles: {
          type: Type.NUMBER,
          description: 'Number of breathing cycles to perform (usually 3).',
        },
      },
      required: ['cycles'],
    },
  },
  {
    name: 'show_exercise_widget',
    description: 'Shows an image for the patient to name.',
    parameters: {
      type: Type.OBJECT,
      properties: {
        imageUrl: {
          type: Type.STRING,
          description: 'URL of the image to show. Use https://picsum.photos/400/400?random=X',
        },
        targetWord: {
          type: Type.STRING,
          description: 'The word the patient needs to say.',
        },
      },
      required: ['imageUrl', 'targetWord'],
    },
  },
  {
    name: 'end_session',
    description: 'Ends the session and shows a summary report.',
    parameters: {
      type: Type.OBJECT,
      properties: {
        summaryWins: {
          type: Type.ARRAY,
          items: { type: Type.STRING },
          description: 'List of 2-3 positive things the patient achieved today.',
        },
      },
      required: ['summaryWins'],
    },
  }
];
