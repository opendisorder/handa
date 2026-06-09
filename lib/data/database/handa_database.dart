import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables/categories_table.dart';
import 'tables/exercises_table.dart';
import 'tables/sessions_table.dart';
import 'tables/attempts_table.dart';
import 'tables/live_conversations_table.dart';
import 'tables/settings_table.dart';
import 'tables/sync_log_table.dart';
import 'daos/category_dao.dart';
import 'daos/exercise_dao.dart';
import 'daos/session_dao.dart';
import 'daos/attempt_dao.dart';
import 'daos/live_conversation_dao.dart';
import 'daos/settings_dao.dart';

part 'handa_database.g.dart';

/// Handa's central SQLite database using Drift.
///
/// 7 tables + DAO mixins for Clean Architecture data layer.
@DriftDatabase(
  tables: [
    Categories,
    Exercises,
    Sessions,
    Attempts,
    LiveConversations,
    AppSettings,
    SyncLog,
  ],
  daos: [
    CategoryDao,
    ExerciseDao,
    SessionDao,
    AttemptDao,
    LiveConversationDao,
    SettingsDao,
  ],
)
class HandaDatabase extends _$HandaDatabase {
  HandaDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          // Seed default settings
          await batch((b) {
            b.insertAll(
              appSettings,
              [
                AppSettingsCompanion.insert(
                  key: 'language',
                  value: 'si',
                ),
                AppSettingsCompanion.insert(
                  key: 'tts_enabled',
                  value: 'true',
                ),
                AppSettingsCompanion.insert(
                  key: 'haptic_enabled',
                  value: 'true',
                ),
                AppSettingsCompanion.insert(
                  key: 'breathing_reminder',
                  value: 'true',
                ),
                AppSettingsCompanion.insert(
                  key: 'caregiver_pin',
                  value: '',
                ),
                AppSettingsCompanion.insert(
                  key: 'caregiver_pin_attempts',
                  value: '0',
                ),
                AppSettingsCompanion.insert(
                  key: 'caregiver_pin_locked_until',
                  value: '',
                ),
                AppSettingsCompanion.insert(
                  key: 'first_run_complete',
                  value: 'false',
                ),
                AppSettingsCompanion.insert(
                  key: 'breathing_days_completed',
                  value: '0',
                ),
                AppSettingsCompanion.insert(
                  key: 'current_language_progress',
                  value: 'si',
                ),
              ],
            );
          });
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'handa.db'));
    return NativeDatabase(file);
  });
}
