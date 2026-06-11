import 'package:drift/drift.dart';
import 'sessions_table.dart';

/// Records from Gemini Live conversation exercises.

class LiveConversations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(Sessions, #id)();
  TextColumn get exerciseType => text()();    // e.g., 'category_naming', 'letter_fluency'
  IntColumn get durationSeconds => integer()();
  TextColumn get userTranscript => text()();
  TextColumn get aiFeedback => text()();
  RealColumn get score => real().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
