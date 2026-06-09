import 'package:drift/drift.dart';

/// Exercise categories (e.g., Animals, Food, Body Parts, etc.)
///
/// Multilingual: stores names and descriptions in all 3 supported languages.
@DataClassName('DataCategory')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nameSi => text()();        // Sinhala name
  TextColumn get nameTa => text()();        // Tamil name
  TextColumn get nameEn => text()();        // English name
  TextColumn get descriptionSi => text()();  // Sinhala description
  TextColumn get descriptionTa => text()();  // Tamil description
  TextColumn get descriptionEn => text()();  // English description
  TextColumn get icon => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
