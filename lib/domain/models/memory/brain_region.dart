/// Biologically-mapped brain region tracking for aphasia/apraxia patients.
///
/// Each region tracks a specific dimension of patient state, updated
/// post-session by the background agent.
library;

/// The 10 brain regions of the Digital Brain.
enum BrainRegion {
  prefrontalCortex(
    'prefrontal_cortex',
    'Personality, identity, goals, self-concept',
  ),
  hippocampus(
    'hippocampus',
    'Memory formation, recall accuracy, forgetting patterns',
  ),
  amygdala(
    'amygdala',
    'Fears, joys, triggers, trauma, emotional patterns',
  ),
  brocaArea(
    'broca_area',
    'Speech production: word mastery, phonemes, apraxia',
  ),
  wernickeArea(
    'wernicke_area',
    'Comprehension: what patient understands and follows',
  ),
  motorCortex(
    'motor_cortex',
    'Facial patterns, struggle signatures, engagement',
  ),
  temporalLobe(
    'temporal_lobe',
    'Auditory processing, music, associative memory',
  ),
  cerebellum(
    'cerebellum',
    'Rhythm, breathing coordination, timing',
  ),
  brainstem(
    'brainstem',
    'Sleep, energy, arousal, best session times',
  ),
  corpusCallosum(
    'corpus_callosum',
    'Logic-emotion balance, integration patterns',
  );

  final String id;
  final String description;
  const BrainRegion(this.id, this.description);

  static BrainRegion fromId(String id) =>
      BrainRegion.values.firstWhere((r) => r.id == id);
}

/// A timestamped insight for any brain region.
class BrainRegionInsight {
  final String text;
  final DateTime timestamp;
  final String? source; // e.g., 'session_2026-06-10'

  const BrainRegionInsight({
    required this.text,
    required this.timestamp,
    this.source,
  });

  Map<String, dynamic> toJson() => {
        'text': text,
        'timestamp': timestamp.toIso8601String(),
        if (source != null) 'source': source,
  };

  factory BrainRegionInsight.fromJson(Map<String, dynamic> json) =>
      BrainRegionInsight(
        text: json['text'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        source: json['source'] as String?,
      );
}

/// Complete state for one brain region.
class BrainRegionState {
  final BrainRegion region;
  final List<BrainRegionInsight> insights;
  final DateTime lastUpdated;
  final Map<String, dynamic>? metrics; // region-specific metrics

  const BrainRegionState({
    required this.region,
    required this.insights,
    required this.lastUpdated,
    this.metrics,
  });

  BrainRegionState copyWith({
    List<BrainRegionInsight>? insights,
    DateTime? lastUpdated,
    Map<String, dynamic>? metrics,
  }) =>
      BrainRegionState(
        region: region,
        insights: insights ?? this.insights,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        metrics: metrics ?? this.metrics,
      );

  Map<String, dynamic> toJson() => {
        'region': region.id,
        'insights': insights.map((i) => i.toJson()).toList(),
        'lastUpdated': lastUpdated.toIso8601String(),
        if (metrics != null) 'metrics': metrics,
  };

  factory BrainRegionState.fromJson(Map<String, dynamic> json) =>
      BrainRegionState(
        region: BrainRegion.fromId(json['region'] as String),
        insights: (json['insights'] as List)
            .map((i) => BrainRegionInsight.fromJson(i as Map<String, dynamic>))
            .toList(),
        lastUpdated: DateTime.parse(json['lastUpdated'] as String),
        metrics: json['metrics'] as Map<String, dynamic>?,
      );
}

/// Word mastery — tracks progression from learning → approximate → mastered.
enum WordStatus { learning, approximate, mastered }

/// Phoneme tracking — which phonemes are difficult and what substitution occurs.
class PhonemeInfo {
  final String phoneme;
  final String? substitutedWith;
  final double accuracy; // 0.0 - 1.0
  final DateTime lastPracticed;

  const PhonemeInfo({
    required this.phoneme,
    this.substitutedWith,
    this.accuracy = 0.0,
    required this.lastPracticed,
  });

  Map<String, dynamic> toJson() => {
        'phoneme': phoneme,
        if (substitutedWith != null) 'substitutedWith': substitutedWith,
        'accuracy': accuracy,
        'lastPracticed': lastPracticed.toIso8601String(),
  };
}

/// Region-specific metrics for Broca's Area (speech production).
class BrocaMetrics {
  final Map<String, WordStatus> wordMastery;
  final List<PhonemeInfo> phonemes;
  final double? optimalWpmMin;
  final double? optimalWpmMax;
  final double speedAccuracyTradeoff; // 0.0 - 1.0

  const BrocaMetrics({
    this.wordMastery = const {},
    this.phonemes = const [],
    this.optimalWpmMin,
    this.optimalWpmMax,
    this.speedAccuracyTradeoff = 0.5,
  });
}

/// Region-specific metrics for Amygdala (emotional triggers).
class AmygdalaMetrics {
  final List<EmotionalTrigger> triggers;
  final List<String> joyAnchors;
  final List<String> deEscalationTools;

  const AmygdalaMetrics({
    this.triggers = const [],
    this.joyAnchors = const [],
    this.deEscalationTools = const [],
  });
}

/// An emotional trigger with its strength and first-seen date.
class EmotionalTrigger {
  final String description;
  final double strength; // 0.0 - 1.0
  final DateTime firstSeen;
  final DateTime? lastTriggered;

  const EmotionalTrigger({
    required this.description,
    this.strength = 0.5,
    required this.firstSeen,
    this.lastTriggered,
  });
}
