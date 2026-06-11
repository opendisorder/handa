/// Entity updater — updates emotional valence of topics based on
/// session analysis.
///
/// This is part of Step 6 in the 7-step background agent protocol.
/// Flags new triggers or changes in topic emotional patterns.
library;

import '../../domain/models/memory/entity_graph.dart';
import '../../domain/models/memory/session_log.dart';
import '../memory/entity_store.dart';

class EntityUpdater {
  final EntityStore _store;

  EntityUpdater(this._store);

  /// Analyze session for entity mentions and update valences.
  Future<void> processSession(SessionLog log) async {
    final graph = await _store.load();
    var updatedGraph = graph;
    final now = log.startedAt;

    // Process flags as potential new triggers
    for (final flag in log.flags) {
      final entityId = flag.toLowerCase().replaceAll(' ', '_');
      final existing = updatedGraph.node(entityId);

      if (existing == null) {
        // New entity detected
        updatedGraph = updatedGraph.copyWith(
          nodes: [
            ...updatedGraph.nodes,
            EntityNode(
              id: entityId,
              displayName: flag,
              valence: EmotionalValence.trigger,
              strength: 0.6,
              firstSeen: now,
              lastUpdated: now,
            ),
          ],
          lastUpdated: now,
        );
      } else if (existing.valence != EmotionalValence.trigger) {
        // Strengthen the trigger association
        updatedGraph = updatedGraph.copyWith(
          nodes: updatedGraph.nodes.map((n) {
            if (n.id == entityId) {
              return n.copyWith(
                valence: EmotionalValence.trigger,
                strength: (n.strength + 0.1).clamp(0.0, 1.0),
                lastUpdated: now,
              );
            }
            return n;
          }).toList(),
          lastUpdated: now,
        );
      }
    }

    // Process wins as potential joy anchors
    for (final win in log.wins) {
      final entityId = win.toLowerCase().replaceAll(' ', '_');
      final existing = updatedGraph.node(entityId);

      if (existing == null) {
        updatedGraph = updatedGraph.copyWith(
          nodes: [
            ...updatedGraph.nodes,
            EntityNode(
              id: entityId,
              displayName: win,
              valence: EmotionalValence.joy,
              strength: 0.7,
              firstSeen: now,
              lastUpdated: now,
            ),
          ],
          lastUpdated: now,
        );
      } else if (existing.valence == EmotionalValence.joy) {
        // Reinforce joy anchor
        updatedGraph = updatedGraph.copyWith(
          nodes: updatedGraph.nodes.map((n) {
            if (n.id == entityId) {
              return n.copyWith(
                strength: (n.strength + 0.05).clamp(0.0, 1.0),
                lastUpdated: now,
              );
            }
            return n;
          }).toList(),
          lastUpdated: now,
        );
      }
    }

    await _store.save(updatedGraph);
  }

  /// Manually add or update an entity.
  Future<void> upsertEntity(EntityNode node) async {
    await _store.upsertNode(node);
  }

  /// Flag a topic for avoidance by the AI.
  Future<void> flagForAvoidance(String topicId) async {
    final graph = await _store.load();
    final existing = graph.node(topicId);
    if (existing != null) {
      await _store.upsertNode(existing.copyWith(
        valence: EmotionalValence.trigger,
        lastUpdated: DateTime.now(),
      ));
    }
  }
}
