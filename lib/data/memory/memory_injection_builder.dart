/// Memory injection builder — compresses the Digital Brain into a
/// 200-300 word DIGITAL BRAIN SUMMARY prepended to the AI system prompt.
///
/// This is the key context mechanism: instead of loading all 10 brain region
/// files, the AI gets a compressed summary that preserves all critical context
/// while minimizing token cost.
library;

import '../../domain/models/memory/brain_region.dart';
import '../../domain/models/memory/entity_graph.dart';
import '../../domain/models/memory/relationship_graph.dart';
import '../../domain/models/memory/therapeutic_state.dart';
import '../../domain/models/memory/word_mastery.dart';

/// Compiled summary of the patient's current state for AI context.
class MemoryInjection {
  final String fullText;
  final Map<BrainRegion, String> regionSummaries;
  final int wordCount;

  const MemoryInjection({
    required this.fullText,
    required this.regionSummaries,
    required this.wordCount,
  });
}

class MemoryInjectionBuilder {
  /// Build the DIGITAL BRAIN SUMMARY from all brain data sources.
  MemoryInjection build({
    required Map<BrainRegion, BrainRegionState> brainRegions,
    required RelationshipGraph relationshipGraph,
    required List<RelationshipPerson> persons,
    required EntityGraph entityGraph,
    required WordMasteryIndex wordMastery,
    required TherapeuticState therapeuticState,
    String? todayDate,
  }) {
    final date = todayDate ?? DateTime.now().toIso8601String().split('T').first;
    final summaries = <BrainRegion, String>{};

    final buffer = StringBuffer();
    buffer.writeln('## DIGITAL BRAIN SUMMARY (Updated: $date)');
    buffer.writeln();

    // Prefrontal Cortex — Identity
    final pfc = brainRegions[BrainRegion.prefrontalCortex];
    if (pfc != null && pfc.insights.isNotEmpty) {
      final last = pfc.insights.last.text;
      summaries[BrainRegion.prefrontalCortex] = last;
      buffer.writeln('### Prefrontal Cortex');
      buffer.writeln('- $last');
      buffer.writeln();
    }

    // Amygdala — Emotions
    final amygdala = brainRegions[BrainRegion.amygdala];
    if (amygdala != null && amygdala.insights.isNotEmpty) {
      final triggerCount =
          amygdala.insights.where((i) => i.text.contains('trigger')).length;
      final hasNewTrigger = amygdala.insights.any(
        (i) => i.text.contains('NEW TRIGGER'),
      );
      final summary = StringBuffer();
      if (hasNewTrigger) {
        final newTrigger = amygdala.insights.firstWhere(
          (i) => i.text.contains('NEW TRIGGER'),
          orElse: () => amygdala.insights.last,
        );
        summary.write('NEW TRIGGER: ${newTrigger.text}');
      }
      summary.write(
        ' $triggerCount trigger patterns tracked.',
      );
      summaries[BrainRegion.amygdala] = summary.toString();
      buffer.writeln('### Amygdala');
      buffer.writeln('- Triggers tracked: $triggerCount');
      if (hasNewTrigger) {
        final newTrigger = amygdala.insights.firstWhere(
          (i) => i.text.contains('NEW TRIGGER'),
          orElse: () => amygdala.insights.last,
        );
        buffer.writeln('- ${newTrigger.text}');
      }
      buffer.writeln();
    }

    // Broca's Area — Speech
    final broca = brainRegions[BrainRegion.brocaArea];
    if (broca != null && broca.insights.isNotEmpty) {
      final masteredCount = wordMastery.mastered.length;
      final learningCount = wordMastery.learning.length;
      summaries[BrainRegion.brocaArea] =
          '$masteredCount mastered, $learningCount learning';
      buffer.writeln('### Broca\'s Area');
      buffer.writeln('- Mastered words: $masteredCount');
      buffer.writeln('- Learning: $learningCount');
      if (wordMastery.masteryRate > 0) {
        buffer.writeln(
          '- Mastery rate: ${wordMastery.masteryRate.toStringAsFixed(0)}%',
        );
      }
      buffer.writeln();
    }

    // Relationships
    final highImportance =
        relationshipGraph.nodes.where((n) => n.importance >= 0.8).toList();
    if (highImportance.isNotEmpty) {
      buffer.writeln('### Key Relationships');
      for (final node in highImportance.where((n) => n.id != 'patient')) {
        final person =
            persons.where((p) => p.id == node.id).firstOrNull;
        buffer.writeln(
          '- ${node.id} (${(node.importance * 100).toStringAsFixed(0)}%): '
          '${node.valence.name}',
        );
        if (person != null && person.insights.isNotEmpty) {
          buffer.writeln('  → ${person.insights.last}');
        }
      }
      buffer.writeln();
    }

    // Entity avoidance
    final avoid = entityGraph.avoidTopics;
    final approach = entityGraph.approachTopics;
    if (avoid.isNotEmpty || approach.isNotEmpty) {
      buffer.writeln('### Topic Guidance');
      if (avoid.isNotEmpty) {
        buffer.writeln(
          '- Avoid: ${avoid.map((e) => e.displayName).join(', ')}',
        );
      }
      if (approach.isNotEmpty) {
        buffer.writeln(
          '- Lean into: ${approach.map((e) => e.displayName).join(', ')}',
        );
      }
      buffer.writeln();
    }

    // Today's Strategy
    final focus = therapeuticState.currentFocus;
    final strategy = therapeuticState.aiStrategy;
    if (focus != null || strategy != null) {
      buffer.writeln("### Today's Strategy");
      if (focus != null) buffer.writeln('- Focus: $focus');
      if (strategy != null) buffer.writeln('- $strategy');
      buffer.writeln();
    }

    // Therapeutic state
    if (therapeuticState.goals.isNotEmpty) {
      buffer.writeln('### Goals');
      buffer.writeln('- ${therapeuticState.progressSummary}');
    }

    final fullText = buffer.toString();
    final wordCount = fullText.split(RegExp(r'\s+')).length;

    return MemoryInjection(
      fullText: fullText,
      regionSummaries: summaries,
      wordCount: wordCount,
    );
  }

  /// Build a minimal injection when data is sparse (first session).
  MemoryInjection buildMinimal({
    String? patientName,
    String? todayDate,
  }) {
    final date = todayDate ?? DateTime.now().toIso8601String().split('T').first;
    final text = '''
## DIGITAL BRAIN SUMMARY (Updated: $date)

### Prefrontal Cortex
- First session — building baseline identity profile.

### Amygdala
- First session — no trigger data yet. Observe and log.

### Broca's Area
- First session — establishing word mastery baseline.

### Today's Strategy
- Build rapport. Start with easy wins. Log everything.
''';
    return MemoryInjection(
      fullText: text.trim(),
      regionSummaries: {},
      wordCount: text.split(RegExp(r'\s+')).length,
    );
  }
}
