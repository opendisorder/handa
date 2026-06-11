/// Function declarations for Gemini Live API tool calls.
///
/// These declare the available functions the model can call during speech
/// therapy sessions. The model uses them to log exercises, end sessions,
/// update patient state, trigger UI widgets, and search for content.
library;

import 'package:gemini_live_fork/gemini_live.dart';

/// Returns function declarations for exercise / speech therapy sessions.
List<FunctionDeclaration> exerciseFunctionDeclarations() {
  return [
    FunctionDeclaration(
      name: 'log_exercise',
      description:
          'Log the result of a single speech exercise attempt. Call this '
          'after the patient attempts a word and you have evaluated their '
          'speech accuracy.',
      parameters: {
        'type': 'object',
        'properties': {
          'target_word': {
            'type': 'string',
            'description': 'The Sinhala word the patient was asked to say.',
          },
          'accuracy': {
            'type': 'number',
            'description':
                'Speech accuracy score as a percentage (0–100). 90+ is '
                'excellent, 75+ is good, 60+ is almost correct.',
          },
          'emotion': {
            'type': 'string',
            'description':
                'Patient emotion during this attempt (e.g., confident, hesitant, frustrated).',
            'enum': ['confident', 'hesitant', 'frustrated', 'neutral', 'happy'],
          },
          'struggle_detected': {
            'type': 'boolean',
            'description':
                'Whether the patient showed visible signs of struggle or '
                'frustration with this word.',
          },
        },
        'required': ['target_word', 'accuracy'],
      },
    ),
    FunctionDeclaration(
      name: 'end_session',
      description:
          'End the current speech therapy session. Call this when the '
          'patient indicates they want to stop, or after you have completed '
          'the planned exercises. Summarize wins and progress.',
      parameters: {
        'type': 'object',
        'properties': {
          'summary_wins': {
            'type': 'array',
            'items': {'type': 'string'},
            'description':
                'List of positive achievements during this session (e.g., '
                '"mastered the /b/ sound", "improved breath support").',
          },
        },
      },
    ),
    FunctionDeclaration(
      name: 'update_patient_state',
      description:
          'Update the patient emotional/energy state during the session. '
          'Call this when the patient demonstrates a significant change in '
          'state (frustrated, tired, energized, etc.).',
      parameters: {
        'type': 'object',
        'properties': {
          'state': {
            'type': 'string',
            'description': 'The patient current state.',
            'enum': [
              'focused',
              'frustrated',
              'tired',
              'energized',
              'overwhelmed',
              'avoidant',
              'distracted',
            ],
          },
          'trigger': {
            'type': 'string',
            'description':
                'Optional trigger description of what caused this state change.',
          },
        },
        'required': ['state'],
      },
    ),
    // UI-side effects (handled locally, no backend processing needed)
    FunctionDeclaration(
      name: 'show_breathing_widget',
      description:
          'Show the guided breathing exercise widget. Call this when the '
          'patient is frustrated, anxious, or needs to calm down before '
          'continuing.',
      parameters: {
        'type': 'object',
        'properties': {
          'cycles': {
            'type': 'integer',
            'description': 'Number of breathing cycles (default 3).',
          },
        },
      },
    ),
    FunctionDeclaration(
      name: 'show_text_on_screen',
      description:
          'Display a text message on screen. Use this to show the target '
          'word in Sinhala script so the patient can see it.',
      parameters: {
        'type': 'object',
        'properties': {
          'text': {
            'type': 'string',
            'description': 'The Sinhala text to display.',
          },
          'subtitle': {
            'type': 'string',
            'description': 'Optional English translation or subtitle.',
          },
        },
        'required': ['text'],
      },
    ),
    FunctionDeclaration(
      name: 'play_sound',
      description:
          'Play a sound effect for positive reinforcement (celebration) or '
          'to signal a transition.',
      parameters: {
        'type': 'object',
        'properties': {
          'sound': {
            'type': 'string',
            'enum': ['celebration', 'correct', 'transition', 'gentle_chime'],
            'description': 'The sound effect to play.',
          },
        },
        'required': ['sound'],
      },
    ),
  ];
}
