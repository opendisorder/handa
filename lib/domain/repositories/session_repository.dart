import '../models/attempt.dart';
import '../models/live_conversation.dart';
import '../models/progress_stats.dart';
import '../models/session.dart';

/// Repository for session, attempt, and progress data.
abstract class SessionRepository {
  // ─── Sessions ────────────────────────────────────────────
  Future<int> createSession({
    required String type,
    int totalExercises = 0,
  });
  Future<void> completeSession(
    int sessionId, {
    required double averageScore,
    required int completedExercises,
  });
  Future<Session?> getSession(int id);
  Future<Session?> getLatestSession();
  Future<List<Session>> getRecentSessions({int days = 30});

  // ─── Attempts ────────────────────────────────────────────
  Future<int> saveAttempt({
    required int sessionId,
    int? exerciseId,
    required String userResponse,
    required String expectedAnswer,
    required double scorePercentage,
    required String scoreLevel,
    int? responseTimeMs,
    bool isOffline = false,
  });
  Future<List<Attempt>> getAttemptsForSession(int sessionId);
  Future<Attempt?> getBestAttempt(int exerciseId);

  // ─── Live Conversations ──────────────────────────────────
  Future<int> saveConversation({
    required int sessionId,
    required String exerciseType,
    required int durationSeconds,
    required String userTranscript,
    required String aiFeedback,
    double? score,
  });

  // ─── Progress ────────────────────────────────────────────
  Future<ProgressStats> getProgressStats();
}
