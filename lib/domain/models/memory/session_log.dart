/// Session log model — stores structured session transcripts and analysis.
library;

import 'brain_region.dart';
import 'entity_graph.dart';

/// A single recorded session with analysis data.
class SessionLog {
  final String id; // format: YYYY-MM-DD-N
  final DateTime startedAt;
  final DateTime? completedAt;
  final String type; // 'picture_naming' | 'conversation' | 'breathing' | 'mixed'
  final SessionSummary summary;
  final List<String> transcript;
  final List<StruggleEvent> struggleEvents;
  final List<String> wins;
  final List<String> flags; // red flags or new triggers
  final String? aiNotes;

  const SessionLog({
    required this.id,
    required this.startedAt,
    this.completedAt,
    required this.type,
    required this.summary,
    this.transcript = const [],
    this.struggleEvents = const [],
    this.wins = const [],
    this.flags = const [],
    this.aiNotes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'startedAt': startedAt.toIso8601String(),
        if (completedAt != null) 'completedAt': completedAt!.toIso8601String(),
        'type': type,
        'summary': summary.toJson(),
        'wins': wins,
        'flags': flags,
        if (aiNotes != null) 'aiNotes': aiNotes,
  };

  Duration get duration {
    final end = completedAt ?? DateTime.now();
    return end.difference(startedAt);
  }
}

/// Summary analysis of a session.
class SessionSummary {
  final int totalWordsPracticed;
  final int masteredWords;
  final int approximateWords;
  final int strugglingWords;
  final int frustrationEvents;
  final int breathingCyclesCompleted;
  final double? overallScore;
  final String? emotionalState; // summary from amygdala analysis
  final List<TriggerMention> triggersMentioned;

  const SessionSummary({
    this.totalWordsPracticed = 0,
    this.masteredWords = 0,
    this.approximateWords = 0,
    this.strugglingWords = 0,
    this.frustrationEvents = 0,
    this.breathingCyclesCompleted = 0,
    this.overallScore,
    this.emotionalState,
    this.triggersMentioned = const [],
  });

  Map<String, dynamic> toJson() => {
        'totalWordsPracticed': totalWordsPracticed,
        'masteredWords': masteredWords,
        'approximateWords': approximateWords,
        'strugglingWords': strugglingWords,
        'frustrationEvents': frustrationEvents,
        'breathingCyclesCompleted': breathingCyclesCompleted,
        if (overallScore != null) 'overallScore': overallScore,
        if (emotionalState != null) 'emotionalState': emotionalState,
      };
}

/// A timestamped struggle event during a session.
class StruggleEvent {
  final DateTime timestamp;
  final int level; // 0-4 (MediaPipe struggle level)
  final String? context; // what exercise or topic was active

  const StruggleEvent({
    required this.timestamp,
    required this.level,
    this.context,
  });
}

/// A topic trigger mentioned during session.
class TriggerMention {
  final String entityId;
  final EmotionalValence valence;
  final String context;

  const TriggerMention({
    required this.entityId,
    required this.valence,
    required this.context,
  });

}
