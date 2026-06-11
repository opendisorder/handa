/// Tool call handler service — processes Gemini function calls from the
/// Live API and routes them to the appropriate business logic.
///
/// Handles: log_exercise, end_session, update_patient_state, show_* widgets.
library;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:gemini_live_fork/gemini_live.dart';

import '../../domain/models/memory/session_log.dart';
import '../memory/session_log_store.dart';
import 'background_agent_orchestrator.dart';
import 'live_api_service.dart';

/// Result of processing a tool call. The caller should send this back
/// via [LiveApiService.sendToolResponse].
class ToolCallResult {
  final String id;
  final String name;
  final Map<String, dynamic> response;

  const ToolCallResult({
    required this.id,
    required this.name,
    required this.response,
  });
}

/// Processes Gemini function calls and routes them to the appropriate
/// business logic, including the background agent.
class ToolCallHandlerService {
  final BackgroundAgentOrchestrator orchestrator;
  final SessionLogStore sessionLogStore;
  final LiveApiService liveApiService;

  /// Callback for UI-side effects (e.g., show breathing widget).
  final void Function(String functionName, Map<String, dynamic> args)? onUiAction;

  /// Accumulated exercise data for the current session.
  final List<Map<String, dynamic>> _exerciseLog = [];

  ToolCallHandlerService({
    required this.orchestrator,
    required this.sessionLogStore,
    required this.liveApiService,
    this.onUiAction,
  });

  List<Map<String, dynamic>> get exerciseLog => List.unmodifiable(_exerciseLog);

  /// Process incoming tool calls from the Gemini Live server.
  ///
  /// Returns a list of [ToolCallResult] that the caller should send back
  /// to the model via [LiveApiService.sendToolResponse].
  List<ToolCallResult> handleToolCall(LiveServerToolCall toolCall) {
    if (toolCall.functionCalls == null) return [];

    final results = <ToolCallResult>[];

    for (final fc in toolCall.functionCalls!) {
      final id = fc.id;
      final name = fc.name;
      final args = fc.args ?? {};

      if (id == null || name == null) continue;

      try {
        final result = _dispatch(name, args);
        results.add(ToolCallResult(
          id: id,
          name: name,
          response: result,
        ));
      } catch (e, stack) {
        debugPrint('[ToolCallHandler] Error handling $name: $e\n$stack');
        results.add(ToolCallResult(
          id: id,
          name: name,
          response: {'error': e.toString()},
        ));
      }
    }

    return results;
  }

  Map<String, dynamic> _dispatch(String name, Map<String, dynamic> args) {
    switch (name) {
      case 'log_exercise':
        return _handleLogExercise(args);
      case 'end_session':
        return _handleEndSession(args);
      case 'update_patient_state':
        return _handleUpdateState(args);
      case 'show_breathing_widget':
      case 'show_exercise_widget':
      case 'show_conversation_widget':
      case 'show_text_on_screen':
      case 'play_sound':
        onUiAction?.call(name, args);
        return {'status': 'ok'};
      case 'teammate_search':
        return {'results': []}; // placeholder — integrate with knowledge base
      case 'graph_memory_search':
        return {'results': []}; // placeholder — integrate with entity graph
      case 'web_search':
        return {'results': []}; // placeholder
      default:
        debugPrint('[ToolCallHandler] Unknown function: $name');
        return {'status': 'unknown_function'};
    }
  }

  Map<String, dynamic> _handleLogExercise(Map<String, dynamic> args) {
    _exerciseLog.add(args);

    final targetWord = args['target_word'] as String?;
    final accuracy = args['accuracy'] as num?;
    final emotion = args['emotion'] as String?;
    final struggle = args['struggle_detected'] as bool? ?? false;

    if (targetWord != null && accuracy != null) {
      // Fire-and-forget: record word attempt in background agent
      unawaited(orchestrator.recordWordAttempt(
        word: targetWord,
        scorePercentage: (accuracy as num).toDouble().clamp(0.0, 100.0),
        scoreLevel: _scoreLevel(accuracy.toDouble()),
      ));

      if (struggle) {
        unawaited(orchestrator.flagTrigger(
          'struggle_$targetWord',
          DateTime.now(),
        ));
      }
    }

    return {'logged': true, 'entries': _exerciseLog.length};
  }

  Map<String, dynamic> _handleEndSession(Map<String, dynamic> args) {
    final wins = <String>[];
    if (args['summary_wins'] is List) {
      wins.addAll((args['summary_wins'] as List).cast<String>());
    }

    // Build session log from accumulated exercise data
    final now = DateTime.now();
    final dateStr = now.toIso8601String().split('T').first;
    final mastered = _exerciseLog
        .where((e) => ((e['accuracy'] as num?)?.toDouble() ?? 0) >= 70)
        .length;
    final struggling = _exerciseLog
        .where((e) => ((e['accuracy'] as num?)?.toDouble() ?? 0) < 60)
        .length;

    final sessionLog = SessionLog(
      id: '${dateStr}_${now.millisecondsSinceEpoch}',
      startedAt: now.subtract(const Duration(minutes: 15)),
      completedAt: now,
      type: 'mixed',
      summary: SessionSummary(
        totalWordsPracticed: _exerciseLog.length,
        masteredWords: mastered,
        approximateWords: _exerciseLog.length - mastered - struggling,
        strugglingWords: struggling,
        frustrationEvents: _exerciseLog
            .where((e) => e['struggle_detected'] == true)
            .length,
        breathingCyclesCompleted: 0,
        overallScore: _exerciseLog.isNotEmpty
            ? _exerciseLog
                    .map((e) => (e['accuracy'] as num?)?.toDouble() ?? 0)
                    .reduce((a, b) => a + b) /
                _exerciseLog.length
            : null,
        emotionalState: null,
      ),
      wins: wins,
      flags: _exerciseLog
          .where((e) => e['struggle_detected'] == true)
          .map((e) => 'struggle_${e['target_word'] ?? 'unknown'}')
          .toList(),
    );

    // Fire-and-forget: run the 7-step background agent protocol
    unawaited(_runBackgroundAgent(sessionLog));

    return {'status': 'session_ended'};
  }

  Future<void> _runBackgroundAgent(SessionLog log) async {
    // Save session log
    await sessionLogStore.save(log);

    // Run 7-step protocol
    await orchestrator.processSession(log);

    // Disconnect after processing
    await liveApiService.disconnect();
  }

  Map<String, dynamic> _handleUpdateState(Map<String, dynamic> args) {
    final state = args['state'] as String?;
    final trigger = args['trigger'] as String?;

    if (trigger != null) {
      unawaited(orchestrator.flagTrigger(trigger, DateTime.now()));
    }
    if (state == 'frustrated' || state == 'overwhelmed' || state == 'avoidant') {
      unawaited(orchestrator.flagTrigger(
        'emotional_state_$state',
        DateTime.now(),
      ));
    }

    return {'updated': true, 'state': state};
  }

  String _scoreLevel(double score) {
    if (score >= 90) return 'excellent';
    if (score >= 75) return 'good';
    if (score >= 60) return 'almost';
    return 'try_again';
  }

  /// Reset exercise log for a new session.
  void reset() {
    _exerciseLog.clear();
  }
}
