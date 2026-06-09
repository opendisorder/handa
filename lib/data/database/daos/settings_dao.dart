import 'package:drift/drift.dart';
import '../handa_database.dart';
import '../tables/settings_table.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [AppSettings])
class SettingsDao extends DatabaseAccessor<HandaDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.db);

  /// Get a setting value by key.
  Future<String?> get(String key) =>
      (select(appSettings)..where((t) => t.key.equals(key)))
          .getSingleOrNull()
          .then((r) => r?.value);

  /// Get a setting as int.
  Future<int?> getInt(String key) =>
      get(key).then((v) => v != null ? int.tryParse(v) : null);

  /// Get a setting as bool.
  Future<bool?> getBool(String key) =>
      get(key).then((v) => v != null ? (v == 'true') : null);

  /// Set a setting value.
  Future<int> set(String key, String value) =>
      into(appSettings).insertOnConflictUpdate(
        AppSettingsCompanion(
          key: Value(key),
          value: Value(value),
          updatedAt: Value(DateTime.now()),
        ),
      );

  /// Get all settings as a map.
  Future<Map<String, String>> getAll() => select(appSettings)
      .get()
      .then((rows) => {for (final r in rows) r.key: r.value});

  /// Delete a setting.
  Future<int> delete(String key) =>
      (delete(appSettings)..where((t) => t.key.equals(key))).go();
}
