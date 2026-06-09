import 'package:drift/drift.dart';
import '../handa_database.dart';
import '../tables/sessions_table.dart';

part 'session_dao.g.dart';

@DriftAccessor(tables: [Sessions])
class SessionDao extends DatabaseAccessor<HandaDatabase>
    with _$SessionDaoMixin {
  SessionDao(super.db);

  /// Get all sessions ordered by most recent first.
  Future<List<Session>> getAll() =>
      (select(sessions)..addOrderBy(OrderingTerm.desc(sessions.startedAt)))
          .get();

  /// Get a single session by ID.
  Future<Session?> getById(int id) =>
      (select(sessions)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Get sessions by type.
  Future<List<Session>> getByType(String type) =>
      (select(sessions)
            ..where((t) => t.type.equals(type))
            ..addOrderBy(OrderingTerm.desc(sessions.startedAt)))
          .get();

  /// Get the most recent session.
  Future<Session?> getLatest() =>
      (select(sessions)..addOrderBy(OrderingTerm.desc(sessions.startedAt)))
          .getSingleOrNull();

  /// Get sessions within a date range.
  Future<List<Session>> getByDateRange(DateTime start, DateTime end) =>
      (select(sessions)
            ..where((t) => t.startedAt.isBetweenValues(start, end))
            ..addOrderBy(OrderingTerm.desc(sessions.startedAt)))
          .get();

  /// Insert a new session, returning the ID.
  Future<int> insert(SessionsCompanion entry) =>
      into(sessions).insert(entry);

  /// Update session (e.g., set completedAt and score).
  Future<bool> update(SessionsCompanion entry) =>
      update(sessions).replace(entry);

  /// Mark session as completed with final score.
  Future<int> completeSession(
    int sessionId,
    double averageScore,
    int completedCount,
  ) =>
      (update(sessions)..where((t) => t.id.equals(sessionId))).write(
        SessionsCompanion(
          completedAt: Value(DateTime.now()),
          averageScore: Value(averageScore),
          completedExercises: Value(completedCount),
        ),
      );

  /// Get average score across all completed sessions.
  Future<double?> getOverallAverage() =>
      ((select(sessions)
                ..where((t) => t.completedAt.isNotNull())
                ..where((t) => t.averageScore.isNotNull()))
            .map((s) => s.averageScore)
            .get())
          .then((scores) {
        if (scores.isEmpty) return null;
        return scores.fold<double>(0, (a, b) => a + b!) / scores.length;
      });

  /// Count total sessions.
  Future<int> count() =>
      select(sessions).map((_) => 1).get().then((r) => r.length);

  /// Count sessions in last N days.
  Future<int> countRecent(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return       (select(sessions)..where((t) => t.startedAt.isBiggerThanValue(cutoff)))
        .map((_) => 1)
        .get()
        .then((r) => r.length);
  }
}
