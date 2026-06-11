/// Brain region updater — appends timestamped insights to brain region
/// documents after each session analysis.
///
/// This is Step 3 of the 7-step background agent protocol.
library;

import '../../domain/models/memory/brain_region.dart';
import '../../domain/models/memory/session_log.dart';
import '../memory/brain_region_store.dart';

class BrainRegionUpdater {
  final BrainRegionStore _store;

  BrainRegionUpdater(this._store);

  /// Analyze a session and append insights to relevant brain regions.
  Future<void> processSession(SessionLog log) async {
    final date = log.startedAt.toIso8601String().split('T').first;

    // Amygdala — emotional triggers
    if (log.flags.isNotEmpty || log.summary.emotionalState != null) {
      final emotionalState = log.summary.emotionalState;
      if (emotionalState != null) {
        await _store.appendInsight(
          BrainRegion.amygdala,
          BrainRegionInsight(
            text: emotionalState,
            timestamp: log.startedAt,
            source: 'session_$date',
          ),
        );
      }
      for (final flag in log.flags) {
        await _store.appendInsight(
          BrainRegion.amygdala,
          BrainRegionInsight(
            text: 'NEW TRIGGER: $flag',
            timestamp: log.startedAt,
            source: 'session_$date',
          ),
        );
      }
    }

    // Broca's Area — speech performance
    final summary = log.summary;
    if (summary.totalWordsPracticed > 0) {
      final insight = StringBuffer()
        ..write(
          'Session: ${summary.totalWordsPracticed} words practiced, '
          '${summary.masteredWords} mastered, '
          '${summary.approximateWords} approximate, '
          '${summary.strugglingWords} struggling.',
        );
      if (summary.overallScore != null) {
        insight.write(' Overall score: ${summary.overallScore!.toStringAsFixed(0)}%');
      }
      await _store.appendInsight(
        BrainRegion.brocaArea,
        BrainRegionInsight(
          text: insight.toString(),
          timestamp: log.startedAt,
          source: 'session_$date',
        ),
      );
    }

    // Frustration → Motor Cortex
    if (summary.frustrationEvents > 0) {
      await _store.appendInsight(
        BrainRegion.motorCortex,
        BrainRegionInsight(
          text:
              '$date: ${summary.frustrationEvents} frustration events detected.',
          timestamp: log.startedAt,
          source: 'session_$date',
        ),
      );
    }

    // Breathing → Cerebellum
    if (summary.breathingCyclesCompleted > 0) {
      await _store.appendInsight(
        BrainRegion.cerebellum,
        BrainRegionInsight(
          text: '$date: ${summary.breathingCyclesCompleted} breathing cycles completed.',
          timestamp: log.startedAt,
          source: 'session_$date',
        ),
      );
    }

    // Wins → Prefrontal Cortex (identity reinforcement)
    if (log.wins.isNotEmpty) {
      await _store.appendInsight(
        BrainRegion.prefrontalCortex,
        BrainRegionInsight(
          text: 'Session wins: ${log.wins.join(", ")}.',
          timestamp: log.startedAt,
          source: 'session_$date',
        ),
      );
    }
  }

  /// Update identity/self-concept insight.
  Future<void> updateIdentity(String insight) async {
    await _store.appendInsight(
      BrainRegion.prefrontalCortex,
      BrainRegionInsight(
        text: insight,
        timestamp: DateTime.now(),
      ),
    );
  }

  /// Log a comprehension observation.
  Future<void> updateComprehension(String observation) async {
    await _store.appendInsight(
      BrainRegion.wernickeArea,
      BrainRegionInsight(
        text: observation,
        timestamp: DateTime.now(),
      ),
    );
  }

  /// Log energy/arousal observation.
  Future<void> updateArousal(String observation) async {
    await _store.appendInsight(
      BrainRegion.brainstem,
      BrainRegionInsight(
        text: observation,
        timestamp: DateTime.now(),
      ),
    );
  }

  /// Log logic-emotion balance observation.
  Future<void> updateIntegration(String observation) async {
    await _store.appendInsight(
      BrainRegion.corpusCallosum,
      BrainRegionInsight(
        text: observation,
        timestamp: DateTime.now(),
      ),
    );
  }
}
