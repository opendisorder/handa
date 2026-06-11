/// Word mastery store — persists per-word progression data.
library;

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/models/memory/word_mastery.dart';

class WordMasteryStore {
  final FlutterSecureStorage _storage;
  static const _key = 'word_mastery_index';

  WordMasteryStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Save the full word mastery index.
  Future<void> save(WordMasteryIndex index) async {
    final data = {
      'words': index.words.map((word, progress) => MapEntry(word, {
            'word': progress.word,
            'status': progress.status.name,
            'firstSeen': progress.firstSeen.toIso8601String(),
            'lastPracticed': progress.lastPracticed.toIso8601String(),
            'totalAttempts': progress.totalAttempts,
            'recentAttempts': progress.recentAttempts
                .map((a) => {
                      'word': a.word,
                      'scorePercentage': a.scorePercentage,
                      'timestamp': a.timestamp.toIso8601String(),
                      'scoreLevel': a.scoreLevel,
                    })
                .toList(),
          })),
      'lastUpdated': index.lastUpdated.toIso8601String(),
    };
    await _storage.write(key: _key, value: jsonEncode(data));
  }

  /// Load the word mastery index.
  Future<WordMasteryIndex> load() async {
    final json = await _storage.read(key: _key);
    if (json == null) {
      return WordMasteryIndex(lastUpdated: DateTime.now());
    }
    final data = jsonDecode(json) as Map<String, dynamic>;
    final words = <String, WordProgress>{};
    if (data['words'] != null) {
      (data['words'] as Map<String, dynamic>).forEach((word, prog) {
        final p = prog as Map<String, dynamic>;
        words[word] = WordProgress(
          word: p['word'] as String,
          status: WordStatus.values.firstWhere(
            (s) => s.name == p['status'],
            orElse: () => WordStatus.learning,
          ),
          firstSeen: DateTime.parse(p['firstSeen'] as String),
          lastPracticed: DateTime.parse(p['lastPracticed'] as String),
          totalAttempts: (p['totalAttempts'] as num).toInt(),
          recentAttempts: (p['recentAttempts'] as List)
              .map((a) => WordAttempt(
                    word: a['word'] as String,
                    scorePercentage: (a['scorePercentage'] as num).toDouble(),
                    timestamp: DateTime.parse(a['timestamp'] as String),
                    scoreLevel: a['scoreLevel'] as String? ?? '',
                  ))
              .toList(),
        );
      });
    }
    return WordMasteryIndex(
      words: words,
      lastUpdated: DateTime.parse(data['lastUpdated'] as String),
    );
  }

  /// Record a new word attempt and update mastery.
  Future<WordProgress> recordAttempt(WordAttempt attempt) async {
    final index = await load();
    final word = attempt.word.toLowerCase();
    final existing = index.forWord(word);
    final updatedRecent = [
      ...existing.recentAttempts,
      attempt,
    ].reversed
        .take(10) // keep last 10 attempts max
        .toList()
        .reversed
        .toList();

    // Determine new status
    WordStatus newStatus = existing.status;
    if (existing.isMastered || _checkMastered(updatedRecent)) {
      newStatus = WordStatus.mastered;
    } else if (updatedRecent.length >= 3 &&
        updatedRecent.reversed
                .take(3)
                .every((a) => a.scorePercentage >= 50.0)) {
      newStatus = WordStatus.approximate;
    }

    final updated = existing.copyWith(
      status: newStatus,
      lastPracticed: attempt.timestamp,
      recentAttempts: updatedRecent,
      totalAttempts: existing.totalAttempts + 1,
    );

    final updatedWords = Map<String, WordProgress>.from(index.words);
    updatedWords[word] = updated;
    await save(index.copyWith(
      words: updatedWords,
      lastUpdated: attempt.timestamp,
    ));
    return updated;
  }

  bool _checkMastered(List<WordAttempt> attempts) {
    if (attempts.length < 3) return false;
    return attempts.reversed
        .take(3)
        .every((a) => a.scorePercentage >= 70.0);
  }

  /// Get progress for a specific word.
  Future<WordProgress> getWord(String word) async {
    final index = await load();
    return index.forWord(word);
  }

  /// Get all mastered words.
  Future<List<WordProgress>> getMastered() async {
    final index = await load();
    return index.mastered;
  }

  /// Clear all word data.
  Future<void> clear() async {
    await _storage.delete(key: _key);
  }
}
