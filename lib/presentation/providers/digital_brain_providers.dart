import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/background_agent/brain_region_updater.dart';
import '../../data/background_agent/entity_updater.dart';
import '../../data/background_agent/relationship_updater.dart';
import '../../data/memory/brain_region_store.dart';
import '../../data/memory/entity_store.dart';
import '../../data/memory/memory_injection_builder.dart';
import '../../data/memory/pattern_repository_store.dart';
import '../../data/memory/relationship_store.dart';
import '../../data/memory/session_log_store.dart';
import '../../data/memory/therapeutic_state_store.dart';
import '../../data/memory/word_mastery_store.dart';
import '../../data/services/background_agent_orchestrator.dart';
import '../../data/services/caregiver_report_service.dart';
import '../../data/services/digital_brain_service.dart';

/// Store providers (lazy singletons).
final brainRegionStoreProvider = Provider<BrainRegionStore>((ref) {
  return BrainRegionStore();
});

final relationshipStoreProvider = Provider<RelationshipStore>((ref) {
  return RelationshipStore();
});

final entityStoreProvider = Provider<EntityStore>((ref) {
  return EntityStore();
});

final wordMasteryStoreProvider = Provider<WordMasteryStore>((ref) {
  return WordMasteryStore();
});

final therapeuticStateStoreProvider = Provider<TherapeuticStateStore>((ref) {
  return TherapeuticStateStore();
});

final sessionLogStoreProvider = Provider<SessionLogStore>((ref) {
  return SessionLogStore();
});

final patternRepositoryStoreProvider = Provider<PatternRepositoryStore>((ref) {
  return PatternRepositoryStore();
});

/// Digital Brain Service — high-level coordinator.
final digitalBrainServiceProvider = Provider<DigitalBrainService>((ref) {
  return DigitalBrainService(
    brainRegionStore: ref.read(brainRegionStoreProvider),
    relationshipStore: ref.read(relationshipStoreProvider),
    entityStore: ref.read(entityStoreProvider),
    wordMasteryStore: ref.read(wordMasteryStoreProvider),
    therapeuticStateStore: ref.read(therapeuticStateStoreProvider),
    patternRepositoryStore: ref.read(patternRepositoryStoreProvider),
  );
});

/// Memory injection builder.
final memoryInjectionBuilderProvider = Provider<MemoryInjectionBuilder>((ref) {
  return MemoryInjectionBuilder();
});

/// Background agent updaters.
final brainRegionUpdaterProvider = Provider<BrainRegionUpdater>((ref) {
  return BrainRegionUpdater(ref.read(brainRegionStoreProvider));
});

final relationshipUpdaterProvider = Provider<RelationshipUpdater>((ref) {
  return RelationshipUpdater(ref.read(relationshipStoreProvider));
});

final entityUpdaterProvider = Provider<EntityUpdater>((ref) {
  return EntityUpdater(ref.read(entityStoreProvider));
});

/// Background Agent Orchestrator — runs the 7-step post-session protocol.
final backgroundAgentOrchestratorProvider =
    Provider<BackgroundAgentOrchestrator>((ref) {
  return BackgroundAgentOrchestrator(
    brainRegionUpdater: ref.read(brainRegionUpdaterProvider),
    relationshipUpdater: ref.read(relationshipUpdaterProvider),
    entityUpdater: ref.read(entityUpdaterProvider),
    brainRegionStore: ref.read(brainRegionStoreProvider),
    relationshipStore: ref.read(relationshipStoreProvider),
    entityStore: ref.read(entityStoreProvider),
    wordMasteryStore: ref.read(wordMasteryStoreProvider),
    sessionLogStore: ref.read(sessionLogStoreProvider),
      digitalBrainService: ref.read(digitalBrainServiceProvider),
    );
  });

/// Caregiver Report Service — weekly PDF generation.
final caregiverReportServiceProvider = Provider<CaregiverReportService>((ref) {
  return CaregiverReportService(
    sessionLogStore: ref.read(sessionLogStoreProvider),
    wordMasteryStore: ref.read(wordMasteryStoreProvider),
    brainRegionStore: ref.read(brainRegionStoreProvider),
  );
});
