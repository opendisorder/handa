import 'package:drift/drift.dart';
import '../handa_database.dart';
import '../tables/settings_table.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [AppSettings])
class SettingsDao extends DatabaseAccessor<HandaDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.db);

  Future<String?> get(String key) =>
      (select(appSettings)..where((t) => t.key.equals(key)))
          .getSingleOrNull()
          .then((r) => r?.value);

  Future<int?> getInt(String key) =>
      get(key).then((v) => v != null ? int.tryParse(v) : null);

  Future<bool?> getBool(String key) =>
      get(key).then((v) => v != null ? (v == 'true') : null);

  Future<int> set(String key, String value) =>
      into(appSettings).insertOnConflictUpdate(
        AppSettingsCompanion(
          key: Value(key),
          value: Value(value),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<Map<String, String>> getAll() => select(appSettings)
      .get()
      .then((rows) => {for (final r in rows) r.key: r.value});

  Future<int> deleteByKey(String key) =>
      (delete(appSettings)..where((t) => t.key.equals(key))).go();
}
