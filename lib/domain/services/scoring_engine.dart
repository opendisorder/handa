import '../../core/constants/app_constants.dart';
import '../../core/utils/levenshtein.dart';
import '../../domain/models/attempt.dart';

/// Scoring engine for picture-naming exercises.
///
/// Two modes:
/// 1. Online: score from Gemini API evaluation response
/// 2. Offline: Levenshtein similarity fallback
class ScoringEngine {
  /// Calculate score from transcribed user speech vs expected answer.
  ///
  /// [userResponse] is the STT-transcribed text.
  /// [expectedAnswer] is the correct target word.
  /// [geminiScore] is optional — if provided, it takes precedence.
  static ScoreResult evaluate({
    required String userResponse,
    required String expectedAnswer,
    double? geminiScore,
    int? responseTimeMs,
  }) {
    if (geminiScore != null) {
      return ScoreResult(
        scorePercentage: geminiScore.clamp(0, 100),
        scoreLevel: ScoreLevel.fromPercentage(geminiScore.clamp(0, 100)),
        method: 'online',
        responseTimeMs: responseTimeMs,
      );
    }

    // Offline: Levenshtein distance
    final similarity = LevenshteinDistance.similarity(
      userResponse.trim().toLowerCase(),
      expectedAnswer.trim().toLowerCase(),
    );

    return ScoreResult(
      scorePercentage: similarity,
      scoreLevel: ScoreLevel.fromPercentage(similarity),
      method: 'offline',
      responseTimeMs: responseTimeMs,
    );
  }

  /// Determine if an exercise is mastered based on recent attempts.
  static bool isMastered(List<Attempt> attempts) {
    if (attempts.length < AppConstants.attemptsForMastery) return false;
    final recent = attempts.take(AppConstants.attemptsForMastery).toList();
    return recent.every((a) => a.scorePercentage >= AppConstants.masteryThreshold);
  }

  /// Get Sinhala encouragement phrase based on score level.
  static String encouragementPhrase(String scoreLevel) {
    switch (scoreLevel) {
      case 'excellent':
        return 'විශිෂ්ටයි! ඔබට පුදුමාකාර කුසලතා තියෙනවා!';
      case 'good':
        return 'හොඳයි! ඔබ හොඳින් ඉගෙන ගන්නවා!';
      case 'almost':
        return 'බොහෝ දුරට හරි! තව ටිකක් උත්සාහ කරමු!';
      case 'try_again':
        return 'කරදරයක් නෑ, නැවත උත්සාහ කරමු!';
      default:
        return 'ඉදිරියට යමු!';
    }
  }

  /// Get Sinhala encouragement for breathing exercise completion.
  static String breathingEncouragement(int daysCompleted) {
    if (daysCompleted >= 30) return 'දින 30ක් සම්පූර්ණ! විශිෂ්ටයි! ඔබේ හුස්ම පාලනය වර්ධනය වී ඇත!';
    if (daysCompleted >= 21) return 'සති 3ක්! ඉතා හොඳ ප්‍රගතියක්!';
    if (daysCompleted >= 14) return 'සති 2ක්! දිගටම කරගෙන යන්න!';
    if (daysCompleted >= 7) return 'සති 1ක්! හොඳ ආරම්භයක්!';
    return 'හොඳයි! හුස්ම අභ්‍යාස දිගටම කරන්න!';
  }
}

/// Result of a single scoring evaluation.
class ScoreResult {
  final double scorePercentage;
  final ScoreLevel scoreLevel;
  final String method; // 'online' | 'offline'
  final int? responseTimeMs;

  const ScoreResult({
    required this.scorePercentage,
    required this.scoreLevel,
    required this.method,
    this.responseTimeMs,
  });

  /// Serialized score level string for database storage.
  String get levelString {
    switch (scoreLevel) {
      case ScoreLevel.excellent: return 'excellent';
      case ScoreLevel.good: return 'good';
      case ScoreLevel.almost: return 'almost';
      case ScoreLevel.tryAgain: return 'try_again';
    }
  }
}
