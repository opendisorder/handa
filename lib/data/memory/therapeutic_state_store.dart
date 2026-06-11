/// Therapeutic state store — persists goals, difficulty, and strategy.
library;

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/models/memory/therapeutic_state.dart';

class TherapeuticStateStore {
  final FlutterSecureStorage _storage;
  static const _key = 'therapeutic_state';

  TherapeuticStateStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Save therapeutic state.
  Future<void> save(TherapeuticState state) async {
    final data = {
      'goals': state.goals.map((g) => g.toJson()).toList(),
      'currentFocus': state.currentFocus,
      'aiStrategy': state.aiStrategy,
      'lastUpdated': state.lastUpdated.toIso8601String(),
    };
    await _storage.write(key: _key, value: jsonEncode(data));
  }

  /// Load therapeutic state.
  Future<TherapeuticState> load() async {
    final json = await _storage.read(key: _key);
    if (json == null) {
      return TherapeuticState(
        difficultyLevels: DifficultyLevels(lastUpdated: DateTime.now()),
        lastUpdated: DateTime.now(),
      );
    }
    final data = jsonDecode(json) as Map<String, dynamic>;
    return TherapeuticState(
      goals: (data['goals'] as List?)
              ?.map((g) => TherapyGoal.fromJson(g as Map<String, dynamic>))
              .toList() ??
          [],
      difficultyLevels: DifficultyLevels(lastUpdated: DateTime.now()),
      currentFocus: data['currentFocus'] as String?,
      aiStrategy: data['aiStrategy'] as String?,
      lastUpdated: DateTime.parse(data['lastUpdated'] as String),
    );
  }

  /// Add a new goal.
  Future<void> addGoal(TherapyGoal goal) async {
    final state = await load();
    await save(state.copyWith(
      goals: [...state.goals, goal],
      lastUpdated: DateTime.now(),
    ));
  }

  /// Update goal progress.
  Future<void> updateGoalProgress(String goalId, double progress) async {
    final state = await load();
    final updated = state.goals.map((g) {
      if (g.id == goalId) return g.copyWith(progress: progress);
      return g;
    }).toList();
    await save(state.copyWith(
      goals: updated,
      lastUpdated: DateTime.now(),
    ));
  }

  /// Set current focus for next session.
  Future<void> setCurrentFocus(String focus) async {
    final state = await load();
    await save(state.copyWith(
      currentFocus: focus,
      lastUpdated: DateTime.now(),
    ));
  }

  /// Clear all state.
  Future<void> clear() async {
    await _storage.delete(key: _key);
  }
}
