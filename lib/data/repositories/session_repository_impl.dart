import 'package:drift/drift.dart';
import '../../../domain/models/attempt.dart';
import '../../../domain/models/live_conversation.dart';
import '../../../domain/models/progress_stats.dart';
import '../../../domain/models/session.dart';
import '../../../domain/repositories/session_repository.dart';
import '../../database/handa_database.dart';

/// Drift-backed implementation of SessionRepository.
class SessionRepositoryImpl implements SessionRepository {
  final HandaDatabase _db;

  SessionRepositoryImpl(this._db);

  // ─── Sessions ───────────────────────────────────────────────

  @override
  Future<int> createSession({
    required String type,
    int totalExercises = 0,
  }) async {
    return await _db.sessionDao.insert(
      SessionsCompanion(
        type: Value(type),
        totalExercises: Value(totalExercises),
      ),
    );
  }

  @override
  Future<void> completeSession(
    int sessionId, {
    required double averageScore,
    required int completedExercises,
  }) async {
    await _db.sessionDao.completeSession(
      sessionId,
      averageScore,
      completedExercises,
    );
  }

  @override
  Future<Session?> getSession(int id) async {
    final row = await _db.sessionDao.getById(id);
    return row != null ? _toSession(row) : null;
  }

  @override
  Future<Session?> getLatestSession() async {
    final row = await _db.sessionDao.getLatest();
    return row != null ? _toSession(row) : null;
  }

  @override
  Future<List<Session>> getRecentSessions({int days = 30}) async {
    final start = DateTime.now().subtract(Duration(days: days));
    final rows =
        await _db.sessionDao.getByDateRange(start, DateTime.now());
    return rows.map(_toSession).toList();
  }

  // ─── Attempts ───────────────────────────────────────────────

  @override
  Future<int> saveAttempt({
    required int sessionId,
    int? exerciseId,
    required String userResponse,
    required String expectedAnswer,
    required double scorePercentage,
    required String scoreLevel,
    int? responseTimeMs,
    bool isOffline = false,
  }) async {
    return await _db.attemptDao.insert(
      AttemptsCompanion(
        sessionId: Value(sessionId),
        exerciseId: Value(exerciseId),
        userResponse: Value(userResponse),
        expectedAnswer: Value(expectedAnswer),
        scorePercentage: Value(scorePercentage),
        scoreLevel: Value(scoreLevel),
        responseTimeMs: Value(responseTimeMs),
        isOffline: Value(isOffline),
      ),
    );
  }

  @override
  Future<List<Attempt>> getAttemptsForSession(int sessionId) async {
    final rows = await _db.attemptDao.getBySession(sessionId);
    return rows.map(_toAttempt).toList();
  }

  @override
  Future<Attempt?> getBestAttempt(int exerciseId) async {
    final row = await _db.attemptDao.getBestAttempt(exerciseId);
    return row != null ? _toAttempt(row) : null;
  }

  // ─── Live Conversations ─────────────────────────────────────

  @override
  Future<int> saveConversation({
    required int sessionId,
    required String exerciseType,
    required int durationSeconds,
    required String userTranscript,
    required String aiFeedback,
    double? score,
  }) async {
    return await _db.liveConversationDao.insert(
      LiveConversationsCompanion(
        sessionId: Value(sessionId),
        exerciseType: Value(exerciseType),
        durationSeconds: Value(durationSeconds),
        userTranscript: Value(userTranscript),
        aiFeedback: Value(aiFeedback),
        score: Value(score),
      ),
    );
  }

  // ─── Progress ───────────────────────────────────────────────

  @override
  Future<ProgressStats> getProgressStats() async {
    final sessions = await _db.sessionDao.getAll();
    final completedSessions =
        sessions.where((s) => s.completedAt != null).toList();

    final allAttempts = await _db.attemptDao.getRecent(10000);
    final overallAvg = await _db.sessionDao.getOverallAverage();

    // Count sessions this week
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    final sessionsThisWeek =
        completedSessions.where((s) => s.startedAt.isAfter(weekAgo)).length;

    // Count attempts by score level
    final Map<String, int> byLevel = {};
    for (final a in allAttempts) {
      byLevel[a.scoreLevel] = (byLevel[a.scoreLevel] ?? 0) + 1;
    }

    // Get last 30 scores for chart
    final scoreHistory = completedSessions
        .where((s) => s.averageScore != null)
        .map((s) => s.averageScore!)
        .toList();
    // Trim to last 30
    if (scoreHistory.length > 30) {
      scoreHistory.removeRange(0, scoreHistory.length - 30);
    }

    // Get breathing days
    final breathingDaysStr =
        await _db.settingsDao.get('breathing_days_completed');
    final breathingDays = int.tryParse(breathingDaysStr ?? '0') ?? 0;

    return ProgressStats(
      totalSessions: completedSessions.length,
      totalAttempts: allAttempts.length,
      overallAverageScore: overallAvg,
      sessionsThisWeek: sessionsThisWeek,
      currentStreak: _calculateStreak(completedSessions),
      attemptsByLevel: byLevel,
      recentSessions: completedSessions.reversed
          .take(10)
          .map(_toSession)
          .toList(),
      scoreHistory: scoreHistory,
      breathingDaysCompleted: breathingDays,
    );
  }

  // ─── Private Helpers ────────────────────────────────────────

  int _calculateStreak(List<DataSession> sessions) {
    if (sessions.isEmpty) return 0;

    final sorted = List<DataSession>.from(sessions)
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));

    int streak = 0;
    final today = DateTime.now();

    for (int i = 0; i < sorted.length; i++) {
      final expectedDate = today.subtract(Duration(days: i));
      final sessionDate = sorted[i].startedAt;

      if (sessionDate.year == expectedDate.year &&
          sessionDate.month == expectedDate.month &&
          sessionDate.day == expectedDate.day) {
        streak++;
      } else if (sessionDate.isBefore(
          DateTime(expectedDate.year, expectedDate.month, expectedDate.day))) {
        break; // Streak broken
      }
    }

    return streak;
  }

  // ─── Mappers ────────────────────────────────────────────────

  Session _toSession(DataSession row) => Session(
        id: row.id,
        startedAt: row.startedAt,
        completedAt: row.completedAt,
        type: row.type,
        totalExercises: row.totalExercises,
        completedExercises: row.completedExercises,
        averageScore: row.averageScore,
        isSynced: row.isSynced,
      );

  Attempt _toAttempt(DataAttempt row) => Attempt(
        id: row.id,
        sessionId: row.sessionId,
        exerciseId: row.exerciseId,
        userResponse: row.userResponse,
        expectedAnswer: row.expectedAnswer,
        scorePercentage: row.scorePercentage,
        scoreLevel: row.scoreLevel,
        responseTimeMs: row.responseTimeMs,
        isOffline: row.isOffline,
        isSynced: row.isSynced,
        createdAt: row.createdAt,
      );
}
