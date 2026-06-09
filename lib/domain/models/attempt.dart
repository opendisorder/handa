/// Domain model for an individual exercise attempt.
class Attempt {
  final int id;
  final int sessionId;
  final int? exerciseId;
  final String userResponse;
  final String expectedAnswer;
  final double scorePercentage;
  final String scoreLevel; // 'excellent' | 'good' | 'almost' | 'try_again'
  final int? responseTimeMs;
  final bool isOffline;
  final bool isSynced;
  final DateTime createdAt;

  const Attempt({
    required this.id,
    required this.sessionId,
    this.exerciseId,
    required this.userResponse,
    required this.expectedAnswer,
    required this.scorePercentage,
    required this.scoreLevel,
    this.responseTimeMs,
    this.isOffline = false,
    this.isSynced = false,
    required this.createdAt,
  });

  bool get isExcellent => scoreLevel == 'excellent';
  bool get isGood => scoreLevel == 'good';
  bool get isAlmost => scoreLevel == 'almost';
  bool get isTryAgain => scoreLevel == 'try_again';
  bool get isPassing => !isTryAgain;
}
