import 'package:drift/drift.dart';
import 'categories_table.dart';

/// Individual picture-naming exercises.
///
/// Each exercise has a target word in 3 languages plus
/// a reference image stored locally in WebP format.

class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  TextColumn get imagePath => text()();
  TextColumn get targetWordSi => text()();
  TextColumn get targetWordTa => text()();
  TextColumn get targetWordEn => text()();
  TextColumn get phoneticHint => text().nullable()();
  IntColumn get difficulty => integer().withDefault(const Constant(1))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
