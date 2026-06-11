/// Pattern repository store — persists cross-session pattern analysis.
library;

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/models/memory/pattern_repo.dart';

class PatternRepositoryStore {
  final FlutterSecureStorage _storage;
  static const _key = 'pattern_repository';

  PatternRepositoryStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Save the pattern repository.
  Future<void> save(PatternRepository repo) async {
    final data = {
      'speech': {
        'speedTrend': _trendToJson(repo.speech.speedTrend),
        'accuracyTrend': _trendToJson(repo.speech.accuracyTrend),
        'mostDifficultPhonemes': repo.speech.mostDifficultPhonemes,
      },
      'emotional': {
        'triggerFrequency': _trendToJson(repo.emotional.triggerFrequency),
        'joyAnchorEffectiveness': repo.emotional.joyAnchorEffectiveness,
        'effectiveDeEscalations': repo.emotional.effectiveDeEscalations,
        'failedDeEscalations': repo.emotional.failedDeEscalations,
      },
      'cognitive': {
        'comprehensionScore': _trendToJson(repo.cognitive.comprehensionScore),
        'attentionSpan': _trendToJson(repo.cognitive.attentionSpan),
        'recallAccuracy': _trendToJson(repo.cognitive.recallAccuracy),
      },
      'behavioral': {
        'defenseMechanismFrequency': repo.behavioral.defenseMechanismFrequency,
        'cooperationScore': _trendToJson(repo.behavioral.cooperationScore),
        'commonResistances': repo.behavioral.commonResistances,
      },
      'lastUpdated': repo.lastUpdated.toIso8601String(),
    };
    await _storage.write(key: _key, value: jsonEncode(data));
  }

  /// Load the pattern repository.
  Future<PatternRepository> load() async {
    final json = await _storage.read(key: _key);
    if (json == null) {
      return PatternRepository(
        speech: SpeechPatterns(
          speedTrend: PatternTrend(name: 'speed'),
          accuracyTrend: PatternTrend(name: 'accuracy'),
        ),
        emotional: EmotionalPatterns(
          triggerFrequency: PatternTrend(name: 'trigger_frequency'),
        ),
        cognitive: CognitivePatterns(
          comprehensionScore: PatternTrend(name: 'comprehension'),
          attentionSpan: PatternTrend(name: 'attention'),
          recallAccuracy: PatternTrend(name: 'recall'),
        ),
        behavioral: BehavioralPatterns(
          cooperationScore: PatternTrend(name: 'cooperation'),
        ),
        lastUpdated: DateTime.now(),
      );
    }
    final data = jsonDecode(json) as Map<String, dynamic>;
    return PatternRepository(
      speech: SpeechPatterns(
        speedTrend: _trendFromJson(data['speech']['speedTrend']),
        accuracyTrend: _trendFromJson(data['speech']['accuracyTrend']),
        mostDifficultPhonemes: Map<String, double>.from(
          (data['speech']['mostDifficultPhonemes'] as Map? ?? {}).map(
            (k, v) => MapEntry(k as String, (v as num).toDouble()),
          ),
        ),
      ),
      emotional: EmotionalPatterns(
        triggerFrequency:
            _trendFromJson(data['emotional']['triggerFrequency']),
        joyAnchorEffectiveness: Map<String, double>.from(
          (data['emotional']['joyAnchorEffectiveness'] as Map? ?? {}).map(
            (k, v) => MapEntry(k as String, (v as num).toDouble()),
          ),
        ),
        effectiveDeEscalations:
            List<String>.from(data['emotional']['effectiveDeEscalations'] ?? []),
        failedDeEscalations:
            List<String>.from(data['emotional']['failedDeEscalations'] ?? []),
      ),
      cognitive: CognitivePatterns(
        comprehensionScore:
            _trendFromJson(data['cognitive']['comprehensionScore']),
        attentionSpan: _trendFromJson(data['cognitive']['attentionSpan']),
        recallAccuracy: _trendFromJson(data['cognitive']['recallAccuracy']),
      ),
      behavioral: BehavioralPatterns(
        defenseMechanismFrequency: Map<String, int>.from(
          (data['behavioral']['defenseMechanismFrequency'] as Map? ?? {}).map(
            (k, v) => MapEntry(k as String, (v as num).toInt()),
          ),
        ),
        cooperationScore:
            _trendFromJson(data['behavioral']['cooperationScore']),
        commonResistances:
            List<String>.from(data['behavioral']['commonResistances'] ?? []),
      ),
      lastUpdated: DateTime.parse(data['lastUpdated'] as String),
    );
  }

  Map<String, dynamic> _trendToJson(PatternTrend trend) => {
        'name': trend.name,
        'points': trend.points
            .map((p) => {
                  'timestamp': p.timestamp.toIso8601String(),
                  'value': p.value,
                  if (p.label != null) 'label': p.label,
                })
            .toList(),
        if (trend.slope != null) 'slope': trend.slope,
        if (trend.insight != null) 'insight': trend.insight,
  };

  PatternTrend _trendFromJson(Map<String, dynamic>? data) {
    if (data == null) return PatternTrend(name: 'unknown');
    return PatternTrend(
      name: data['name'] as String? ?? 'unknown',
      points: (data['points'] as List?)
              ?.map((p) {
                final map = p as Map<String, dynamic>;
                return PatternPoint(
                  timestamp: DateTime.parse(map['timestamp'] as String),
                  value: (map['value'] as num).toDouble(),
                  label: map['label'] as String?,
                );
              })
              .toList() ??
          [],
      slope: (data['slope'] as num?)?.toDouble(),
      insight: data['insight'] as String?,
    );
  }

  /// Clear all pattern data.
  Future<void> clear() async {
    await _storage.delete(key: _key);
  }
}
