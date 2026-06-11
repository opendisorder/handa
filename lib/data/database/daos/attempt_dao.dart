import 'package:drift/drift.dart';
import '../handa_database.dart';
import '../tables/attempts_table.dart';

part 'attempt_dao.g.dart';

@DriftAccessor(tables: [Attempts])
class AttemptDao extends DatabaseAccessor<HandaDatabase>
    with _$AttemptDaoMixin {
  AttemptDao(super.db);

  Future<List<Attempt>> getBySession(int sessionId) =>
      (select(attempts)
            ..where((t) => t.sessionId.equals(sessionId))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  Future<List<Attempt>> getByExercise(int exerciseId) =>
      (select(attempts)
            ..where((t) => t.exerciseId.equals(exerciseId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<List<Attempt>> getRecent(int limit) =>
      (select(attempts)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(limit))
          .get();

  Future<List<Attempt>> getByScoreLevel(String level) =>
      (select(attempts)
            ..where((t) => t.scoreLevel.equals(level))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<int> insert(AttemptsCompanion entry) =>
      into(attempts).insert(entry);

  Future<Attempt?> getBestAttempt(int exerciseId) =>
      (select(attempts)
            ..where((t) => t.exerciseId.equals(exerciseId))
            ..orderBy([(t) => OrderingTerm.desc(t.scorePercentage)]))
          .getSingleOrNull();

  Future<int> countByExercise(int exerciseId) =>
      (select(attempts)..where((t) => t.exerciseId.equals(exerciseId)))
          .map((_) => 1)
          .get()
          .then((r) => r.length);

  Future<List<Attempt>> getByDateRange(DateTime start, DateTime end) =>
      (select(attempts)
            ..where((t) => t.createdAt.isBetweenValues(start, end))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<int> deleteBySession(int sessionId) =>
      (delete(attempts)..where((t) => t.sessionId.equals(sessionId))).go();
}
