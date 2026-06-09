import 'attempt.dart';
import 'session.dart';

/// Computed progress statistics for the dashboard.
///
/// Not stored directly — derived from session + attempt data.
class ProgressStats {
  final int totalSessions;
  final int totalAttempts;
  final double? overallAverageScore;
  final int sessionsThisWeek;
  final int currentStreak;
  final Map<String, int> attemptsByLevel; // score_level -> count
  final List<Session> recentSessions;
  final List<double> scoreHistory; // last 30 scores for chart
  final int breathingDaysCompleted;

  const ProgressStats({
    required this.totalSessions,
    required this.totalAttempts,
    this.overallAverageScore,
    this.sessionsThisWeek = 0,
    this.currentStreak = 0,
    this.attemptsByLevel = const {},
    this.recentSessions = const [],
    this.scoreHistory = const [],
    this.breathingDaysCompleted = 0,
  });

  int get excellentCount => attemptsByLevel['excellent'] ?? 0;
  int get goodCount => attemptsByLevel['good'] ?? 0;
  int get almostCount => attemptsByLevel['almost'] ?? 0;
  int get tryAgainCount => attemptsByLevel['try_again'] ?? 0;
  int get passingCount => excellentCount + goodCount + almostCount;

  double get passingRate =>
      totalAttempts > 0 ? (passingCount / totalAttempts) * 100 : 0;
}
