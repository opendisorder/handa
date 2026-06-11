/// Pattern repository — cross-session pattern analysis across 4 dimensions.
///
/// The background agent analyzes sessions and extracts trends in:
/// - Speech patterns (phoneme difficulty, speed, accuracy)
/// - Emotional patterns (trigger frequency, joy anchor effectiveness)
/// - Cognitive patterns (comprehension, recall, attention)
/// - Behavioral patterns (defense mechanisms, cooperation)
library;

/// A single observed data point in a pattern.
class PatternPoint {
  final DateTime timestamp;
  final double value;
  final String? label;

  const PatternPoint({
    required this.timestamp,
    required this.value,
    this.label,
  });
}

/// A trend across multiple sessions.
class PatternTrend {
  final String name;
  final List<PatternPoint> points;
  final double? slope; // positive = improving, negative = declining
  final String? insight;

  const PatternTrend({
    required this.name,
    this.points = const [],
    this.slope,
    this.insight,
  });
}

/// Speech pattern dimension.
class SpeechPatterns {
  final List<PatternTrend> phonemeAccuracy; // per-phoneme accuracy over time
  final PatternTrend speedTrend; // WPM over time
  final PatternTrend accuracyTrend; // overall accuracy over time
  final Map<String, double> mostDifficultPhonemes; // phoneme → avg difficulty

  const SpeechPatterns({
    this.phonemeAccuracy = const [],
    required this.speedTrend,
    required this.accuracyTrend,
    this.mostDifficultPhonemes = const {},
  });
}

/// Emotional pattern dimension.
class EmotionalPatterns {
  final PatternTrend triggerFrequency; // triggers per session over time
  final Map<String, double> joyAnchorEffectiveness; // anchor → success rate
  final List<String> effectiveDeEscalations; // what worked
  final List<String> failedDeEscalations; // what didn't

  const EmotionalPatterns({
    required this.triggerFrequency,
    this.joyAnchorEffectiveness = const {},
    this.effectiveDeEscalations = const [],
    this.failedDeEscalations = const [],
  });
}

/// Cognitive pattern dimension.
class CognitivePatterns {
  final PatternTrend comprehensionScore;
  final PatternTrend attentionSpan; // minutes of focus before fatigue
  final PatternTrend recallAccuracy;

  const CognitivePatterns({
    required this.comprehensionScore,
    required this.attentionSpan,
    required this.recallAccuracy,
  });
}

/// Behavioral pattern dimension.
class BehavioralPatterns {
  final Map<String, int> defenseMechanismFrequency; // mechanism → count
  final PatternTrend cooperationScore;
  final List<String> commonResistances;

  const BehavioralPatterns({
    this.defenseMechanismFrequency = const {},
    required this.cooperationScore,
    this.commonResistances = const [],
  });
}

/// Complete pattern repository — all 4 dimensions.
class PatternRepository {
  final SpeechPatterns speech;
  final EmotionalPatterns emotional;
  final CognitivePatterns cognitive;
  final BehavioralPatterns behavioral;
  final DateTime lastUpdated;

  const PatternRepository({
    required this.speech,
    required this.emotional,
    required this.cognitive,
    required this.behavioral,
    required this.lastUpdated,
  });
}
