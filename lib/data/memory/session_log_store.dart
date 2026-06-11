/// Session log store — persists session transcripts and analysis to local storage.
library;

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/models/memory/session_log.dart';

class SessionLogStore {
  final FlutterSecureStorage _storage;
  static const _prefix = 'session_log_';
  static const _indexKey = 'session_log_index';

  SessionLogStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Save a session log.
  Future<void> save(SessionLog log) async {
    await _storage.write(
      key: '$_prefix${log.id}',
      value: jsonEncode(log.toJson()),
    );
    // Update index
    final index = await _getIndex();
    if (!index.contains(log.id)) {
      index.add(log.id);
      await _storage.write(key: _indexKey, value: jsonEncode(index));
    }
  }

  /// Load a specific session log.
  Future<SessionLog?> load(String id) async {
    final json = await _storage.read(key: '$_prefix$id');
    if (json == null) return null;
    final data = jsonDecode(json) as Map<String, dynamic>;
    return SessionLog(
      id: data['id'] as String,
      startedAt: DateTime.parse(data['startedAt'] as String),
      completedAt: data['completedAt'] != null
          ? DateTime.parse(data['completedAt'] as String)
          : null,
      type: data['type'] as String,
      summary: _parseSummary(data['summary'] as Map<String, dynamic>),
      wins: List<String>.from(data['wins'] ?? []),
      flags: List<String>.from(data['flags'] ?? []),
      aiNotes: data['aiNotes'] as String?,
    );
  }

  /// Load all session logs, newest first.
  Future<List<SessionLog>> loadAll() async {
    final index = await _getIndex();
    final sessions = <SessionLog>[];
    for (final id in index.reversed) {
      final log = await load(id);
      if (log != null) sessions.add(log);
    }
    return sessions;
  }

  /// Get the most recent session log.
  Future<SessionLog?> get latest async {
    final index = await _getIndex();
    if (index.isEmpty) return null;
    return load(index.last);
  }

  /// Load sessions within a date range.
  Future<List<SessionLog>> loadByDateRange({
    required DateTime start,
    required DateTime end,
  }) async {
    final all = await loadAll();
    return all
        .where((s) => s.startedAt.isAfter(start) && s.startedAt.isBefore(end))
        .toList();
  }

  /// Delete old session logs beyond retention period.
  Future<void> prune({int retentionDays = 90}) async {
    final cutoff = DateTime.now().subtract(Duration(days: retentionDays));
    final index = await _getIndex();
    final toRemove = <String>[];
    for (final id in index) {
      final log = await load(id);
      if (log != null && log.startedAt.isBefore(cutoff)) {
        await _storage.delete(key: '$_prefix$id');
        toRemove.add(id);
      }
    }
    if (toRemove.isNotEmpty) {
      final updated = index.where((id) => !toRemove.contains(id)).toList();
      await _storage.write(key: _indexKey, value: jsonEncode(updated));
    }
  }

  Future<List<String>> _getIndex() async {
    final json = await _storage.read(key: _indexKey);
    if (json == null) return [];
    return List<String>.from(jsonDecode(json) as List);
  }

  SessionSummary _parseSummary(Map<String, dynamic> data) => SessionSummary(
        totalWordsPracticed: (data['totalWordsPracticed'] as num?)?.toInt() ?? 0,
        masteredWords: (data['masteredWords'] as num?)?.toInt() ?? 0,
        approximateWords: (data['approximateWords'] as num?)?.toInt() ?? 0,
        strugglingWords: (data['strugglingWords'] as num?)?.toInt() ?? 0,
        frustrationEvents: (data['frustrationEvents'] as num?)?.toInt() ?? 0,
        breathingCyclesCompleted:
            (data['breathingCyclesCompleted'] as num?)?.toInt() ?? 0,
        overallScore: (data['overallScore'] as num?)?.toDouble(),
        emotionalState: data['emotionalState'] as String?,
      );

  /// Clear all session logs.
  Future<void> clear() async {
    final index = await _getIndex();
    for (final id in index) {
      await _storage.delete(key: '$_prefix$id');
    }
    await _storage.delete(key: _indexKey);
  }
}
