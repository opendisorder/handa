/// Struggle detection service — infers patient difficulty from behavioral signals.
///
/// Level | Cue | Description
/// ------|-----|------------
/// 0 | None | Immediate response, strong match
/// 1 | Subtle | Delayed response (>5s) or partial match
/// 2 | Moderate | Long delay (>10s) or poor match
/// 3 | Significant | Very long delay (>15s) or no match
/// 4 | Severe | Multiple failed cues, disengaged
///
/// Designed to work WITHOUT camera/MediaPipe — uses data the app already collects.
/// Can be upgraded later with actual face mesh video analysis.
library;

import '../models/attempt.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/levenshtein.dart';

/// Inferred struggle level based on available behavioral signals.
enum StruggleLevel {
  none(0, 'No struggle'),
  subtle(1, 'Minor delay or hesitation'),
  moderate(2, 'Significant difficulty'),
  significant(3, 'High struggle'),
  severe(4, 'Extreme difficulty, disengagement');

  final int level;
  final String description;
  const StruggleLevel(this.level, this.description);

  bool get needsCueEscalation => level >= 2;
  bool get needsBreak => level >= 4;
}

/// Result of a struggle assessment for a single exercise attempt.
class StruggleAssessment {
  final StruggleLevel level;
  final int responseTimeMs;
  final double speechSimilarity;
  final int cueLevelUsed;
  final String? suggestedAction;

  const StruggleAssessment({
    required this.level,
    required this.responseTimeMs,
    required this.speechSimilarity,
    required this.cueLevelUsed,
    this.suggestedAction,
  });
}

/// Analyzes available signals to estimate patient struggle level.
///
/// Uses three signals:
/// 1. **Response time** — how long before the patient started speaking
/// 2. **Speech similarity** — Levenshtein distance from expected answer
/// 3. **Cue history** — how many cue levels have already been used
class StruggleDetectionService {
  /// Detect struggle level from available signals.
  ///
  /// [responseTimeMs] — milliseconds between therapist asking and patient responding.
  /// [transcribedSpeech] — what the speech-to-text returned.
  /// [expectedAnswer] — the target word.
  /// [cueLevelUsed] — which cue level was active (0-3).
  /// [recentAttempts] — last few attempts for pattern detection.
  StruggleLevel detect({
    required int responseTimeMs,
    required String transcribedSpeech,
    required String expectedAnswer,
    int cueLevelUsed = 0,
    List<Attempt> recentAttempts = const [],
  }) {
    // 1. Score the speech similarity
    final similarity = LevenshteinDistance.similarity(
      transcribedSpeech.trim().toLowerCase(),
      expectedAnswer.trim().toLowerCase(),
    );

    // 2. Score the response time
    final responseScore = _responseTimeScore(responseTimeMs);

    // 3. Score recent pattern
    final patternScore = _patternScore(recentAttempts);

    // 4. Combine signals (higher = more struggling)
    final combined = (responseScore * 0.35 + // 35% weight
            (100 - similarity) * 0.35 + // 35% weight
            patternScore * 0.3) // 30% weight
        .clamp(0, 100);

    // 5. Map to struggle level
    return _toLevel(combined.toDouble(), cueLevelUsed);
  }

  /// Quick assessment when we only have response time.
  StruggleLevel quickFromDelay(int responseTimeMs) {
    if (responseTimeMs < 3000) return StruggleLevel.none;
    if (responseTimeMs < 7000) return StruggleLevel.subtle;
    if (responseTimeMs < 12000) return StruggleLevel.moderate;
    if (responseTimeMs < 18000) return StruggleLevel.significant;
    return StruggleLevel.severe;
  }

  /// Score response time: 0 = fast, 100 = extremely slow.
  double _responseTimeScore(int ms) {
    if (ms < 2000) return 0;
    if (ms < 5000) return 25;
    if (ms < 10000) return 50;
    if (ms < 15000) return 75;
    return 100;
  }

  /// Score recent attempt pattern: 0 = improving, 100 = declining.
  double _patternScore(List<Attempt> attempts) {
    if (attempts.length < 2) return 0;
    // Take most recent 3 attempts
    final recent = attempts.take(3).toList();
    if (recent.length < 2) return 0;

    // Check if trend is declining
    bool declining = true;
    for (int i = 0; i < recent.length - 1; i++) {
      if (recent[i].scorePercentage <= recent[i + 1].scorePercentage) {
        declining = false;
        break;
      }
    }
    if (declining) return 80;

    // Check if all scores are low
    final allLow = recent.every((a) => a.scorePercentage < AppConstants.almostThreshold);
    if (allLow) return 60;

    return 20;
  }

  StruggleLevel _toLevel(double combined, int cueLevelUsed) {
    // Higher cue levels reduce the signal threshold (patient already needs help)
    final threshold = 20.0 - (cueLevelUsed * 3.0).clamp(0, 9);
    if (combined < threshold) return StruggleLevel.none;
    if (combined < threshold + 20) return StruggleLevel.subtle;
    if (combined < threshold + 40) return StruggleLevel.moderate;
    if (combined < threshold + 60) return StruggleLevel.significant;
    return StruggleLevel.severe;
  }
}
