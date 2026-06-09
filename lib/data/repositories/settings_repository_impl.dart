import '../../../domain/repositories/settings_repository.dart';
import '../../database/handa_database.dart';

/// Drift-backed implementation of SettingsRepository.
class SettingsRepositoryImpl implements SettingsRepository {
  final HandaDatabase _db;

  SettingsRepositoryImpl(this._db);

  @override
  Future<String?> getString(String key) => _db.settingsDao.get(key);

  @override
  Future<int?> getInt(String key) => _db.settingsDao.getInt(key);

  @override
  Future<bool?> getBool(String key) => _db.settingsDao.getBool(key);

  @override
  Future<void> setString(String key, String value) =>
      _db.settingsDao.set(key, value);

  @override
  Future<void> setInt(String key, int value) =>
      _db.settingsDao.set(key, value.toString());

  @override
  Future<void> setBool(String key, bool value) =>
      _db.settingsDao.set(key, value.toString());

  @override
  Future<Map<String, String>> getAll() => _db.settingsDao.getAll();
}
