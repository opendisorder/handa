/// Digital Brain Service — high-level coordinator for loading all brain data
/// stores and generating the memory injection block for the AI system prompt.
///
/// Usage:
/// ```dart
/// final service = DigitalBrainService();
/// final memoryBlock = await service.buildMemoryBlock();
/// final prompt = thilinaSystemPrompt(memoryBlock: memoryBlock);
/// ```
library;

import '../memory/brain_region_store.dart';
import '../memory/entity_store.dart';
import '../memory/memory_injection_builder.dart';
import '../memory/pattern_repository_store.dart';
import '../memory/relationship_store.dart';
import '../memory/therapeutic_state_store.dart';
import '../memory/word_mastery_store.dart';

class DigitalBrainService {
  final BrainRegionStore brainRegionStore;
  final RelationshipStore relationshipStore;
  final EntityStore entityStore;
  final WordMasteryStore wordMasteryStore;
  final TherapeuticStateStore therapeuticStateStore;
  final PatternRepositoryStore patternRepositoryStore;
  final MemoryInjectionBuilder injectionBuilder;

  DigitalBrainService({
    BrainRegionStore? brainRegionStore,
    RelationshipStore? relationshipStore,
    EntityStore? entityStore,
    WordMasteryStore? wordMasteryStore,
    TherapeuticStateStore? therapeuticStateStore,
    PatternRepositoryStore? patternRepositoryStore,
    MemoryInjectionBuilder? injectionBuilder,
  })  : brainRegionStore = brainRegionStore ?? BrainRegionStore(),
        relationshipStore = relationshipStore ?? RelationshipStore(),
        entityStore = entityStore ?? EntityStore(),
        wordMasteryStore = wordMasteryStore ?? WordMasteryStore(),
        therapeuticStateStore =
            therapeuticStateStore ?? TherapeuticStateStore(),
        patternRepositoryStore =
            patternRepositoryStore ?? PatternRepositoryStore(),
        injectionBuilder = injectionBuilder ?? MemoryInjectionBuilder();

  /// Build the full memory block for the system prompt.
  ///
  /// Returns the DIGITAL BRAIN SUMMARY text (≤300 words) to prepend
  /// as the `memoryBlock` parameter of [thilinaSystemPrompt].
  /// Returns an empty string if no data exists yet (first session).
  Future<String> buildMemoryBlock() async {
    try {
      final brainRegions = await brainRegionStore.loadAll();
      final relationshipGraph = await relationshipStore.loadGraph();
      final persons = await relationshipStore.loadAllPersons();
      final entityGraph = await entityStore.load();
      final wordMastery = await wordMasteryStore.load();
      final therapeuticState = await therapeuticStateStore.load();

      // Check if this is the first session (no data)
      final hasData = brainRegions.values
              .any((r) => r.insights.isNotEmpty) ||
          wordMastery.allWords.isNotEmpty ||
          entityGraph.nodes.length > 1; // >1 because root node always exists

      if (!hasData) {
        return '';
      }

      final injection = injectionBuilder.build(
        brainRegions: brainRegions,
        relationshipGraph: relationshipGraph,
        persons: persons,
        entityGraph: entityGraph,
        wordMastery: wordMastery,
        therapeuticState: therapeuticState,
      );

      return injection.fullText;
    } catch (e) {
      // Gracefully degrade — no memory block on error
      return '';
    }
  }

  /// Get all brain data as a map for debugging or export.
  Future<Map<String, dynamic>> exportAllData() async {
    return {
      'brainRegions': await brainRegionStore.loadAll(),
      'relationshipGraph': await relationshipStore.loadGraph(),
      'persons': await relationshipStore.loadAllPersons(),
      'entityGraph': await entityStore.load(),
      'wordMastery': await wordMasteryStore.load(),
      'therapeuticState': await therapeuticStateStore.load(),
      'patternRepository': await patternRepositoryStore.load(),
    };
  }

  /// Clear all digital brain data (for testing or reset).
  Future<void> clearAll() async {
    await brainRegionStore.clear();
    await relationshipStore.clear();
    await entityStore.clear();
    await wordMasteryStore.clear();
    await therapeuticStateStore.clear();
    await patternRepositoryStore.clear();
  }
}
