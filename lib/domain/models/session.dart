/// Domain model for a therapy session.
class Session {
  final int id;
  final DateTime startedAt;
  final DateTime? completedAt;
  final String type; // 'picture_naming' | 'conversation' | 'breathing'
  final int totalExercises;
  final int completedExercises;
  final double? averageScore;
  final bool isSynced;

  const Session({
    required this.id,
    required this.startedAt,
    this.completedAt,
    required this.type,
    this.totalExercises = 0,
    this.completedExercises = 0,
    this.averageScore,
    this.isSynced = false,
  });

  bool get isCompleted => completedAt != null;
  Duration get duration {
    final end = completedAt ?? DateTime.now();
    return end.difference(startedAt);
  }
}
