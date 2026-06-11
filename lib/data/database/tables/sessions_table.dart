import 'package:drift/drift.dart';

/// A therapy session (collection of exercises or conversation).
///
/// Types: 'picture_naming', 'conversation', 'breathing'

class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get type => text()();
  IntColumn get totalExercises => integer().withDefault(const Constant(0))();
  IntColumn get completedExercises => integer().withDefault(const Constant(0))();
  RealColumn get averageScore => real().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
