import 'package:drift/drift.dart';
import '../handa_database.dart';
import '../tables/categories_table.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoryDao extends DatabaseAccessor<HandaDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

  Future<List<Category>> getAllActive() =>
      (select(categories)
            ..where((t) => t.isActive.equals(true))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Future<Category?> getById(int id) =>
      (select(categories)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insert(CategoriesCompanion entry) =>
      into(categories).insert(entry);

  Future<bool> updateItem(CategoriesCompanion entry) =>
      update(categories).replace(entry);

  Future<int> softDelete(int id) =>
      (update(categories)..where((t) => t.id.equals(id)))
          .write(const CategoriesCompanion(isActive: Value(false)));

  Future<int> countActive() =>
      (select(categories)..where((t) => t.isActive.equals(true)))
          .map((_) => 1)
          .get()
          .then((r) => r.length);
}
