/// Relationship updater — adjusts relationship weights ±0.05 per session
/// based on sentiment analysis of how the patient talked about each person.
///
/// This is Step 4 of the 7-step background agent protocol.
library;

import '../../domain/models/memory/relationship_graph.dart';
import '../../domain/models/memory/session_log.dart';
import '../memory/relationship_store.dart';

class RelationshipUpdater {
  final RelationshipStore _store;
  static const double _weightDelta = 0.05;
  static const int _reclusterInterval = 5;

  int _sessionCount = 0;

  RelationshipUpdater(this._store);

  /// Analyze a session transcript for relationship sentiment and adjust weights.
  Future<void> processSession(SessionLog log) async {
    _sessionCount++;
    final graph = await _store.loadGraph();
    final persons = await _store.loadAllPersons();
    var updatedGraph = graph;

    // Check for relationship mentions in flags/wins
    for (final flag in log.flags) {
      for (final node in graph.nodes) {
        if (flag.toLowerCase().contains(node.id.toLowerCase())) {
          // Negative mention → decrease weight
          updatedGraph = _adjustWeight(
            updatedGraph,
            node.id,
            -_weightDelta,
          );
        }
      }
    }

    for (final win in log.wins) {
      for (final node in graph.nodes) {
        if (win.toLowerCase().contains(node.id.toLowerCase())) {
          // Positive mention → increase weight
          updatedGraph = _adjustWeight(
            updatedGraph,
            node.id,
            _weightDelta,
          );
        }
      }
    }

    // Update person profiles with new insights if any
    final updatedPersons = <RelationshipPerson>[];
    for (final person in persons) {
      final mentions = _findMentions(log, person);
      if (mentions != null) {
        final updated = person.copyWith(
          positiveStatements: mentions.positive.isNotEmpty
              ? [...person.positiveStatements, ...mentions.positive]
              : person.positiveStatements,
          negativeStatements: mentions.negative.isNotEmpty
              ? [...person.negativeStatements, ...mentions.negative]
              : person.negativeStatements,
          lastUpdated: log.startedAt,
        );
        updatedPersons.add(updated);
      } else {
        updatedPersons.add(person);
      }
    }

    // Re-cluster every N sessions
    if (_sessionCount % _reclusterInterval == 0) {
      updatedGraph = _recluster(updatedGraph);
    }

    updatedGraph = updatedGraph.copyWith(lastUpdated: DateTime.now());
    await _store.saveGraph(updatedGraph);

    for (final person in updatedPersons) {
      await _store.savePerson(person);
    }
  }

  RelationshipGraph _adjustWeight(
    RelationshipGraph graph,
    String nodeId,
    double delta,
  ) {
    final updatedNodes = graph.nodes.map((n) {
      if (n.id == nodeId) {
        final newImportance =
            (n.importance + delta).clamp(0.0, 1.0);
        return RelationshipNode(
          id: n.id,
          importance: newImportance,
          valence: n.valence,
          lastUpdated: DateTime.now(),
        );
      }
      return n;
    }).toList();

    return graph.copyWith(nodes: updatedNodes);
  }

  _MentionResult? _findMentions(SessionLog log, RelationshipPerson person) {
    final positive = <String>[];
    final negative = <String>[];

    // Search through wins for positive mentions
    for (final win in log.wins) {
      if (win.toLowerCase().contains(person.name.toLowerCase())) {
        positive.add(win);
      }
    }

    // Search through flags for negative mentions
    for (final flag in log.flags) {
      if (flag.toLowerCase().contains(person.name.toLowerCase())) {
        negative.add(flag);
      }
    }

    if (positive.isEmpty && negative.isEmpty) return null;
    return _MentionResult(positive: positive, negative: negative);
  }

  RelationshipGraph _recluster(RelationshipGraph graph) {
    // Simple clustering based on valence + importance
    final painNodes = graph.nodes
        .where(
          (n) =>
              n.valence == RelationshipValence.negative ||
              n.valence == RelationshipValence.mixed,
        )
        .map((n) => n.id)
        .toList();

    final joyNodes = graph.nodes
        .where((n) => n.valence == RelationshipValence.positive)
        .map((n) => n.id)
        .toList();

    return graph.copyWith(
      clusters: [
        if (painNodes.isNotEmpty)
          RelationshipCluster(name: 'Pain', nodeIds: painNodes),
        if (joyNodes.isNotEmpty)
          RelationshipCluster(name: 'Joy', nodeIds: joyNodes),
      ],
    );
  }
}

class _MentionResult {
  final List<String> positive;
  final List<String> negative;
  const _MentionResult({this.positive = const [], this.negative = const []});
}
