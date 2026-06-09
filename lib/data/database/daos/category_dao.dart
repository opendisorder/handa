import 'package:drift/drift.dart';
import '../handa_database.dart';
import '../tables/categories_table.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoryDao extends DatabaseAccessor<HandaDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

  /// Get all active categories ordered by sort_order.
  Future<List<Category>> getAllActive() => select(categories)
        .addOrderBy(
          OrderingTerm.asc(categories.sortOrder),
        )
      ..where((t) => t.isActive.equals(true))
      .get();

  /// Get a single category by ID.
  Future<Category?> getById(int id) =>
      (select(categories)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Insert a new category.
  Future<int> insert(CategoriesCompanion entry) =>
      into(categories).insert(entry);

  /// Update an existing category.
  Future<bool> update(CategoriesCompanion entry) =>
      update(categories).replace(entry);

  /// Soft-delete by setting isActive = false.
  Future<int> softDelete(int id) =>
      (update(categories)..where((t) => t.id.equals(id)))
          .write(const CategoriesCompanion(isActive: Value(false)));

  /// Count active categories.
  Future<int> countActive() =>
      (select(categories)..where((t) => t.isActive.equals(true)))
          .map((_) => 1)
          .get()
          .then((r) => r.length);
}
