/// Current therapeutic state — goals, difficulty levels, treatment plan.
///
/// The background agent updates this after every session to track
/// progress toward speech therapy goals.
library;

/// A therapeutic goal with progress tracking.
class TherapyGoal {
  final String id;
  final String description;
  final GoalStatus status;
  final DateTime createdAt;
  final DateTime? targetDate;
  final double progress; // 0.0 - 1.0
  final String? notes;

  const TherapyGoal({
    required this.id,
    required this.description,
    this.status = GoalStatus.active,
    required this.createdAt,
    this.targetDate,
    this.progress = 0.0,
    this.notes,
  });

  TherapyGoal copyWith({
    GoalStatus? status,
    double? progress,
    String? notes,
  }) =>
      TherapyGoal(
        id: id,
        description: description,
        status: status ?? this.status,
        createdAt: createdAt,
        targetDate: targetDate,
        progress: progress ?? this.progress,
        notes: notes ?? this.notes,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
        if (targetDate != null) 'targetDate': targetDate!.toIso8601String(),
        'progress': progress,
        if (notes != null) 'notes': notes,
  };

  factory TherapyGoal.fromJson(Map<String, dynamic> json) => TherapyGoal(
        id: json['id'] as String,
        description: json['description'] as String,
        status: GoalStatus.values.firstWhere(
          (s) => s.name == json['status'],
          orElse: () => GoalStatus.active,
        ),
        createdAt: DateTime.parse(json['createdAt'] as String),
        targetDate: json['targetDate'] != null
            ? DateTime.parse(json['targetDate'] as String)
            : null,
        progress: (json['progress'] as num).toDouble(),
        notes: json['notes'] as String?,
      );
}

enum GoalStatus { active, completed, paused, abandoned }

/// Difficulty levels for different exercise types.
class DifficultyLevels {
  final Map<String, double> exerciseDifficulty; // exercise_type → 0.0-1.0
  final Map<String, double> wordDifficulty; // word → 0.0-1.0
  final DateTime lastUpdated;

  const DifficultyLevels({
    this.exerciseDifficulty = const {},
    this.wordDifficulty = const {},
    required this.lastUpdated,
  });
}

/// Complete therapeutic state snapshot.
class TherapeuticState {
  final List<TherapyGoal> goals;
  final DifficultyLevels difficultyLevels;
  final String? currentFocus; // what the current session should focus on
  final String? aiStrategy; // high-level strategy for the AI persona
  final DateTime lastUpdated;

  const TherapeuticState({
    this.goals = const [],
    required this.difficultyLevels,
    this.currentFocus,
    this.aiStrategy,
    required this.lastUpdated,
  });

  TherapeuticState copyWith({
    List<TherapyGoal>? goals,
    DifficultyLevels? difficultyLevels,
    String? currentFocus,
    String? aiStrategy,
    DateTime? lastUpdated,
  }) =>
      TherapeuticState(
        goals: goals ?? this.goals,
        difficultyLevels: difficultyLevels ?? this.difficultyLevels,
        currentFocus: currentFocus ?? this.currentFocus,
        aiStrategy: aiStrategy ?? this.aiStrategy,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );

  /// Active goals progress summary.
  String get progressSummary {
    final active = goals.where((g) => g.status == GoalStatus.active).toList();
    if (active.isEmpty) return 'No active goals.';
    final avg =
        active.fold(0.0, (sum, g) => sum + g.progress) / active.length;
    return '${active.length} active goals, avg progress: ${(avg * 100).toStringAsFixed(0)}%';
  }
}
