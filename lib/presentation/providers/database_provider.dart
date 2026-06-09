import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/handa_database.dart';
import '../../data/repositories/exercise_repository_impl.dart';
import '../../data/repositories/session_repository_impl.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../../domain/repositories/session_repository.dart';
import '../../domain/repositories/settings_repository.dart';

/// Database singleton provider.
final databaseProvider = Provider<HandaDatabase>((ref) {
  final db = HandaDatabase();
  ref.onDispose(() => db.close());
  return db;
});

/// Repository providers.
final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ExerciseRepositoryImpl(db);
});

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return SessionRepositoryImpl(db);
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return SettingsRepositoryImpl(db);
});
