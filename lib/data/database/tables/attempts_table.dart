import 'package:drift/drift.dart';
import 'sessions_table.dart';
import 'exercises_table.dart';

/// Individual attempt records per exercise.
///
/// Stores the user's spoken response, expected answer,
/// calculated score, and metadata for offline/online tracking.
@DataClassName('DataAttempt')
class Attempts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(Sessions, #id)();
  IntColumn get exerciseId => integer().references(Exercises, #id).nullable()();
  TextColumn get userResponse => text()();
  TextColumn get expectedAnswer => text()();
  RealColumn get scorePercentage => real()();
  TextColumn get scoreLevel => text()(); // 'excellent'|'good'|'almost'|'try_again'
  IntColumn get responseTimeMs => integer().nullable()();
  BoolColumn get isOffline => boolean().withDefault(const Constant(false))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
