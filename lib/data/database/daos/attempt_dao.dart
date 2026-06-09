import 'package:drift/drift.dart';
import '../handa_database.dart';
import '../tables/attempts_table.dart';

part 'attempt_dao.g.dart';

@DriftAccessor(tables: [Attempts])
class AttemptDao extends DatabaseAccessor<HandaDatabase>
    with _$AttemptDaoMixin {
  AttemptDao(super.db);

  /// Get all attempts for a session.
  Future<List<Attempt>> getBySession(int sessionId) =>
      (select(attempts)
            ..where((t) => t.sessionId.equals(sessionId))
            ..addOrderBy(OrderingTerm.asc(attempts.createdAt)))
          .get();

  /// Get all attempts for a specific exercise.
  Future<List<Attempt>> getByExercise(int exerciseId) =>
      (select(attempts)
            ..where((t) => t.exerciseId.equals(exerciseId))
            ..addOrderBy(OrderingTerm.desc(attempts.createdAt)))
          .get();

  /// Get recent attempts (last N).
  Future<List<Attempt>> getRecent(int limit) =>
      (select(attempts)
            ..addOrderBy(OrderingTerm.desc(attempts.createdAt))
            ..limit(limit))
          .get();

  /// Get attempts by score level.
  Future<List<Attempt>> getByScoreLevel(String level) =>
      (select(attempts)
            ..where((t) => t.scoreLevel.equals(level))
            ..addOrderBy(OrderingTerm.desc(attempts.createdAt)))
          .get();

  /// Insert a new attempt, returning the ID.
  Future<int> insert(AttemptsCompanion entry) =>
      into(attempts).insert(entry);

  /// Get the best score for an exercise.
  Future<Attempt?> getBestAttempt(int exerciseId) =>
      (select(attempts)
            ..where((t) => t.exerciseId.equals(exerciseId))
            ..addOrderBy(OrderingTerm.desc(attempts.scorePercentage)))
          .getSingleOrNull();

  /// Get attempts count for an exercise.
  Future<int> countByExercise(int exerciseId) =>
      (select(attempts)..where((t) => t.exerciseId.equals(exerciseId)))
          .map((_) => 1)
          .get()
          .then((r) => r.length);

  /// Get attempts in date range.
  Future<List<Attempt>> getByDateRange(DateTime start, DateTime end) =>
      (select(attempts)
            ..where((t) => t.createdAt.isBetweenValues(start, end))
            ..addOrderBy(OrderingTerm.desc(attempts.createdAt)))
          .get();

  /// Delete all attempts for a session.
  Future<int> deleteBySession(int sessionId) =>
      (delete(attempts)..where((t) => t.sessionId.equals(sessionId))).go();
}
