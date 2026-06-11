/// Word mastery progression tracker.
///
/// Every word the patient practices moves through:
///   learning → approximate → mastered
/// based on score criteria defined in AppConstants.
library;

import '../../../core/constants/app_constants.dart';

/// A single practice attempt for a word.
class WordAttempt {
  final String word;
  final double scorePercentage;
  final DateTime timestamp;
  final String scoreLevel;

  const WordAttempt({
    required this.word,
    required this.scorePercentage,
    required this.timestamp,
    this.scoreLevel = '',
  });

  bool get isPassing => scorePercentage >= AppConstants.masteryThreshold;
}

/// Tracks a word's progression through mastery states.
class WordProgress {
  final String word;
  final WordStatus status;
  final DateTime firstSeen;
  final DateTime lastPracticed;
  final List<WordAttempt> recentAttempts;
  final int totalAttempts;

  const WordProgress({
    required this.word,
    this.status = WordStatus.learning,
    required this.firstSeen,
    required this.lastPracticed,
    this.recentAttempts = const [],
    this.totalAttempts = 0,
  });

  WordProgress copyWith({
    WordStatus? status,
    DateTime? lastPracticed,
    List<WordAttempt>? recentAttempts,
    int? totalAttempts,
  }) =>
      WordProgress(
        word: word,
        status: status ?? this.status,
        firstSeen: firstSeen,
        lastPracticed: lastPracticed ?? this.lastPracticed,
        recentAttempts: recentAttempts ?? this.recentAttempts,
        totalAttempts: totalAttempts ?? this.totalAttempts,
      );

  /// Check if word is mastered per clinical criteria:
  /// score >= masteryThreshold on each of last N attempts.
  bool get isMastered {
    if (recentAttempts.length < AppConstants.attemptsForMastery) return false;
    return recentAttempts
        .reversed
        .take(AppConstants.attemptsForMastery)
        .every((a) => a.isPassing);
  }

  /// Highest recent score.
  double? get bestRecentScore {
    if (recentAttempts.isEmpty) return null;
    return recentAttempts.map((a) => a.scorePercentage).reduce(
          (a, b) => a > b ? a : b,
        );
  }

  /// Average of last N attempts.
  double get averageRecentScore {
    if (recentAttempts.isEmpty) return 0.0;
    final recent = recentAttempts.reversed
        .take(AppConstants.attemptsForMastery)
        .toList();
    return recent.fold(0.0, (sum, a) => sum + a.scorePercentage) /
        recent.length;
  }
}

/// Mastery state per word.
enum WordStatus { learning, approximate, mastered }

/// Complete word mastery index for the patient.
class WordMasteryIndex {
  final Map<String, WordProgress> words;
  final DateTime lastUpdated;

  const WordMasteryIndex({
    this.words = const {},
    required this.lastUpdated,
  });

  WordMasteryIndex copyWith({
    Map<String, WordProgress>? words,
    DateTime? lastUpdated,
  }) =>
      WordMasteryIndex(
        words: words ?? this.words,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );

  /// All mastered words.
  List<WordProgress> get mastered =>
      words.values.where((w) => w.isMastered).toList();

  /// Words currently in learning phase.
  List<WordProgress> get learning =>
      words.values.where((w) => !w.isMastered).toList();

  /// Mastery rate as percentage.
  double get masteryRate {
    if (words.isEmpty) return 0.0;
    return mastered.length / words.length * 100;
  }

  /// Get or create progress for a word.
  WordProgress forWord(String word) {
    return words[word.toLowerCase()] ??
        WordProgress(
          word: word.toLowerCase(),
          status: WordStatus.learning,
          firstSeen: DateTime.now(),
          lastPracticed: DateTime.now(),
        );
  }

  /// All words tracked (entries in the words map).
  List<WordProgress> get allWords => words.values.toList();

  /// Record an attempt and return updated index.
  WordMasteryIndex addAttempt(WordAttempt attempt) {
    final key = attempt.word.toLowerCase();
    final existing = words[key];
    final updatedRecent = [
      ...?existing?.recentAttempts,
      attempt,
    ].toList();

    // Keep last 10 attempts
    if (updatedRecent.length > 10) {
      updatedRecent.removeAt(0);
    }

    final updated = WordProgress(
      word: key,
      status: existing?.status ?? WordStatus.learning,
      firstSeen: existing?.firstSeen ?? attempt.timestamp,
      lastPracticed: attempt.timestamp,
      recentAttempts: updatedRecent,
      totalAttempts: (existing?.totalAttempts ?? 0) + 1,
    );

    return copyWith(
      words: {...words, key: updated},
      lastUpdated: attempt.timestamp,
    );
  }
}
