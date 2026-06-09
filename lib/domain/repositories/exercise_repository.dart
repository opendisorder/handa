import '../models/category.dart';
import '../models/exercise.dart';
import '../models/attempt.dart';
import '../models/session.dart';
import '../models/live_conversation.dart';

/// Repository for exercise data (categories + exercises).
abstract class ExerciseRepository {
  // ─── Categories ──────────────────────────────────────────
  Future<List<Category>> getCategories();
  Future<Category?> getCategory(int id);

  // ─── Exercises ───────────────────────────────────────────
  Future<List<Exercise>> getExercises({int? categoryId});
  Future<Exercise?> getExercise(int id);

  // ─── Attempts ────────────────────────────────────────────
  Future<int> saveAttempt(Attempt attempt);

  // ─── Sessions ────────────────────────────────────────────
  Future<int> createSession(Session session);
  Future<void> completeSession(int sessionId, double avgScore, int completed);
  Future<Session?> getLatestSession();
  Future<List<Session>> getRecentSessions({int days = 30});
}
