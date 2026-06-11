import 'package:drift/drift.dart';
import '../handa_database.dart';
import '../tables/exercises_table.dart';

part 'exercise_dao.g.dart';

@DriftAccessor(tables: [Exercises])
class ExerciseDao extends DatabaseAccessor<HandaDatabase>
    with _$ExerciseDaoMixin {
  ExerciseDao(super.db);

  Future<List<Exercise>> getAllActive({int? categoryId}) {
    final query = select(exercises)..where((t) => t.isActive.equals(true));
    if (categoryId != null) {
      query.where((t) => t.categoryId.equals(categoryId));
    }
    return query.get();
  }

  Future<Exercise?> getById(int id) =>
      (select(exercises)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Exercise>> getByDifficulty(int level) =>
      (select(exercises)
            ..where((t) => t.difficulty.equals(level))
            ..where((t) => t.isActive.equals(true)))
          .get();

  Future<int> insert(ExercisesCompanion entry) =>
      into(exercises).insert(entry);

  Future<bool> updateItem(ExercisesCompanion entry) =>
      update(exercises).replace(entry);

  Future<int> softDelete(int id) =>
      (update(exercises)..where((t) => t.id.equals(id)))
          .write(const ExercisesCompanion(isActive: Value(false)));

  Future<int> countByCategory(int categoryId) =>
      (select(exercises)
            ..where((t) => t.categoryId.equals(categoryId))
            ..where((t) => t.isActive.equals(true)))
          .map((_) => 1)
          .get()
          .then((r) => r.length);
}
