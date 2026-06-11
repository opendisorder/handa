import 'package:drift/drift.dart';
import '../../../domain/models/category.dart';
import '../../../domain/models/exercise.dart';
import '../../../domain/repositories/exercise_repository.dart';
import '../../../domain/models/attempt.dart';
import '../../../domain/models/session.dart';
import '../database/handa_database.dart' as db;

class ExerciseRepositoryImpl implements ExerciseRepository {
  final db.HandaDatabase _db;

  ExerciseRepositoryImpl(this._db);

  @override
  Future<List<Category>> getCategories() async {
    final rows = await _db.categoryDao.getAllActive();
    return rows.map(_toCategory).toList();
  }

  @override
  Future<Category?> getCategory(int id) async {
    final row = await _db.categoryDao.getById(id);
    return row != null ? _toCategory(row) : null;
  }

  @override
  Future<List<Exercise>> getExercises({int? categoryId}) async {
    final rows = await _db.exerciseDao.getAllActive(categoryId: categoryId);
    return rows.map(_toExercise).toList();
  }

  @override
  Future<Exercise?> getExercise(int id) async {
    final row = await _db.exerciseDao.getById(id);
    return row != null ? _toExercise(row) : null;
  }

  @override
  Future<int> saveAttempt(Attempt attempt) async {
    final companion = db.AttemptsCompanion(
      sessionId: Value(attempt.sessionId),
      exerciseId: Value(attempt.exerciseId),
      userResponse: Value(attempt.userResponse),
      expectedAnswer: Value(attempt.expectedAnswer),
      scorePercentage: Value(attempt.scorePercentage),
      scoreLevel: Value(attempt.scoreLevel),
      responseTimeMs: Value(attempt.responseTimeMs),
      isOffline: Value(attempt.isOffline),
    );
    return await _db.attemptDao.insert(companion);
  }

  @override
  Future<int> createSession(Session session) async {
    final companion = db.SessionsCompanion(
      type: Value(session.type),
      totalExercises: Value(session.totalExercises),
    );
    return await _db.sessionDao.insert(companion);
  }

  @override
  Future<void> completeSession(
    int sessionId,
    double avgScore,
    int completed,
  ) async {
    await _db.sessionDao.completeSession(sessionId, avgScore, completed);
  }

  @override
  Future<Session?> getLatestSession() async {
    final row = await _db.sessionDao.getLatest();
    return row != null ? _toSession(row) : null;
  }

  @override
  Future<List<Session>> getRecentSessions({int days = 30}) async {
    final start = DateTime.now().subtract(Duration(days: days));
    final rows = await _db.sessionDao.getByDateRange(start, DateTime.now());
    return rows.map(_toSession).toList();
  }

  Category _toCategory(db.Category row) => Category(
        id: row.id,
        nameSi: row.nameSi,
        nameTa: row.nameTa,
        nameEn: row.nameEn,
        descriptionSi: row.descriptionSi,
        descriptionTa: row.descriptionTa,
        descriptionEn: row.descriptionEn,
        icon: row.icon,
        sortOrder: row.sortOrder,
        isActive: row.isActive,
      );

  Exercise _toExercise(db.Exercise row) => Exercise(
        id: row.id,
        categoryId: row.categoryId,
        imagePath: row.imagePath,
        targetWordSi: row.targetWordSi,
        targetWordTa: row.targetWordTa,
        targetWordEn: row.targetWordEn,
        phoneticHint: row.phoneticHint,
        difficulty: row.difficulty,
        isActive: row.isActive,
      );

  Session _toSession(db.Session row) => Session(
        id: row.id,
        startedAt: row.startedAt,
        completedAt: row.completedAt,
        type: row.type,
        totalExercises: row.totalExercises,
        completedExercises: row.completedExercises,
        averageScore: row.averageScore,
        isSynced: row.isSynced,
      );
}
