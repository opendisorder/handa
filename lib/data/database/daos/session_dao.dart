import 'package:drift/drift.dart';
import '../handa_database.dart';
import '../tables/sessions_table.dart';

part 'session_dao.g.dart';

@DriftAccessor(tables: [Sessions])
class SessionDao extends DatabaseAccessor<HandaDatabase>
    with _$SessionDaoMixin {
  SessionDao(super.db);

  Future<List<Session>> getAll() =>
      (select(sessions)..orderBy([(t) => OrderingTerm.desc(t.startedAt)])).get();

  Future<Session?> getById(int id) =>
      (select(sessions)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Session>> getByType(String type) =>
      (select(sessions)
            ..where((t) => t.type.equals(type))
            ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
          .get();

  Future<Session?> getLatest() =>
      (select(sessions)..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
          .getSingleOrNull();

  Future<List<Session>> getByDateRange(DateTime start, DateTime end) =>
      (select(sessions)
            ..where((t) => t.startedAt.isBetweenValues(start, end))
            ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
          .get();

  Future<int> insert(SessionsCompanion entry) =>
      into(sessions).insert(entry);

  Future<bool> updateItem(SessionsCompanion entry) =>
      update(sessions).replace(entry);

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

  Future<int> count() =>
      select(sessions).map((_) => 1).get().then((r) => r.length);

  Future<int> countRecent(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return (select(sessions)..where((t) => t.startedAt.isBiggerThanValue(cutoff)))
        .map((_) => 1)
        .get()
        .then((r) => r.length);
  }
}
