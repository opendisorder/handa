import 'package:drift/drift.dart';

/// Tracks sync status per record for Firestore replication.
@DataClassName('DataSyncLog')
class SyncLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityName => text()();
  IntColumn get recordId => integer()();
  TextColumn get action => text()();  // 'insert' | 'update' | 'delete'
  DateTimeColumn get syncedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get status => text().withDefault(const Constant('pending'))(); // 'pending' | 'synced' | 'failed'
}
