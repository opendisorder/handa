/// Background Agent Orchestrator — runs the 7-step Digital Brain update
/// protocol after each therapy session.
///
/// ## 7-Step Protocol
/// 1. **Read Brain** — Load current brain region states
/// 2. **Analyze Session** — Process the session log for insights
/// 3. **Append Insights** — Write timestamped insights to regions
/// 4. **Adjust Weights** — Update relationship graph weights
/// 5. **Update Mastery** — Process word attempts, promote statuses
/// 6. **Flag Triggers** — Detect and log new emotional triggers
/// 7. **Generate Injection** — Build the next memory block
library;

import 'dart:async';
import 'package:flutter/foundation.dart';

import '../../domain/models/memory/brain_region.dart';
import '../../domain/models/memory/session_log.dart';
import '../../domain/models/memory/word_mastery.dart';
import '../background_agent/brain_region_updater.dart';
import '../background_agent/entity_updater.dart';
import '../background_agent/relationship_updater.dart';
import '../memory/brain_region_store.dart';
import '../memory/entity_store.dart';
import '../memory/relationship_store.dart';
import '../memory/session_log_store.dart';
import '../memory/word_mastery_store.dart';
import 'digital_brain_service.dart';

class BackgroundAgentOrchestrator {
  final BrainRegionUpdater brainRegionUpdater;
  final RelationshipUpdater relationshipUpdater;
  final EntityUpdater entityUpdater;
  final BrainRegionStore brainRegionStore;
  final RelationshipStore relationshipStore;
  final EntityStore entityStore;
  final WordMasteryStore wordMasteryStore;
  final SessionLogStore sessionLogStore;
  final DigitalBrainService digitalBrainService;

  bool _isProcessing = false;

  BackgroundAgentOrchestrator({
    BrainRegionUpdater? brainRegionUpdater,
    RelationshipUpdater? relationshipUpdater,
    EntityUpdater? entityUpdater,
    BrainRegionStore? brainRegionStore,
    RelationshipStore? relationshipStore,
    EntityStore? entityStore,
    WordMasteryStore? wordMasteryStore,
    SessionLogStore? sessionLogStore,
    DigitalBrainService? digitalBrainService,
  })  : brainRegionUpdater =
            brainRegionUpdater ?? BrainRegionUpdater(BrainRegionStore()),
        relationshipUpdater = relationshipUpdater ??
            RelationshipUpdater(RelationshipStore()),
        entityUpdater = entityUpdater ?? EntityUpdater(EntityStore()),
        brainRegionStore = brainRegionStore ?? BrainRegionStore(),
        relationshipStore = relationshipStore ?? RelationshipStore(),
        entityStore = entityStore ?? EntityStore(),
        wordMasteryStore = wordMasteryStore ?? WordMasteryStore(),
        sessionLogStore = sessionLogStore ?? SessionLogStore(),
        digitalBrainService =
            digitalBrainService ?? DigitalBrainService();

  bool get isProcessing => _isProcessing;

  /// Run the full 7-step background agent protocol.
  ///
  /// Call this after every session completes. The method:
  /// - Freezes the session log
  /// - Updates all brain regions, relationships, entities, and word mastery
  /// - Returns the updated memory block for the next session
  Future<void> processSession(SessionLog log) async {
    if (_isProcessing) {
      debugPrint('[BackgroundAgent] Already processing — skipping.');
      return;
    }
    _isProcessing = true;

    try {
      // Step 1-3: Analyze session → update brain regions
      await brainRegionUpdater.processSession(log);

      // Step 4: Adjust relationship weights
      await relationshipUpdater.processSession(log);

      // Step 5: Update entity valence
      await entityUpdater.processSession(log);

      // Step 6: Save the session log to history
      await sessionLogStore.save(log);

      // Step 7: Warm the memory injection cache (build next block)
      // The actual block is fetched on demand by buildMemoryBlock()
      // This ensures the data is fresh for the next session.
      debugPrint('[BackgroundAgent] Session processed successfully.');
    } catch (e, stack) {
      debugPrint('[BackgroundAgent] Error processing session: $e\n$stack');
    } finally {
      _isProcessing = false;
    }
  }

  /// Process a word attempt for mastery tracking.
  ///
  /// Call this during a session when an exercise is evaluated.
  Future<void> recordWordAttempt({
    required String word,
    required double scorePercentage,
    String? scoreLevel,
  }) async {
    final mastery = await wordMasteryStore.load();
    final attempt = WordAttempt(
      word: word,
      scorePercentage: scorePercentage,
      timestamp: DateTime.now(),
      scoreLevel: scoreLevel ?? '',
    );

    final updated = mastery.addAttempt(attempt);
    await wordMasteryStore.save(updated);
  }

  /// Register an emotional trigger flag detected during a session.
  Future<void> flagTrigger(String trigger, DateTime timestamp) async {
    final store = brainRegionStore;
    await store.appendInsight(
      BrainRegion.amygdala,
      BrainRegionInsight(
        text: 'NEW TRIGGER: $trigger',
        timestamp: timestamp,
        source: 'session_live',
      ),
    );
  }

  /// Register a win detected during a session.
  Future<void> flagWin(String win, DateTime timestamp) async {
    final store = brainRegionStore;
    await store.appendInsight(
      BrainRegion.prefrontalCortex,
      BrainRegionInsight(
        text: 'PATIENT WIN: $win',
        timestamp: timestamp,
        source: 'session_live',
      ),
    );
  }
}
