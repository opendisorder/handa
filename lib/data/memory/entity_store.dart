/// Entity store — persists the entity knowledge graph with emotional valence.
library;

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/models/memory/entity_graph.dart';

class EntityStore {
  final FlutterSecureStorage _storage;
  static const _key = 'entity_graph';

  EntityStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Save the entity graph.
  Future<void> save(EntityGraph graph) async {
    await _storage.write(key: _key, value: jsonEncode(graph.toJson()));
  }

  /// Load the entity graph.
  Future<EntityGraph> load() async {
    final json = await _storage.read(key: _key);
    if (json == null) {
      return EntityGraph(lastUpdated: DateTime.now());
    }
    return EntityGraph.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  /// Upsert a single entity node.
  Future<void> upsertNode(EntityNode node) async {
    final graph = await load();
    final existing = graph.nodes.indexWhere((n) => n.id == node.id);
    final updatedNodes = [...graph.nodes];
    if (existing >= 0) {
      updatedNodes[existing] = node;
    } else {
      updatedNodes.add(node);
    }
    await save(graph.copyWith(
      nodes: updatedNodes,
      lastUpdated: DateTime.now(),
    ));
  }

  /// Get all topics the AI should avoid.
  Future<List<EntityNode>> getAvoidTopics() async {
    final graph = await load();
    return graph.avoidTopics;
  }

  /// Get all joy/pride topics.
  Future<List<EntityNode>> getApproachTopics() async {
    final graph = await load();
    return graph.approachTopics;
  }

  /// Clear all entity data.
  Future<void> clear() async {
    await _storage.delete(key: _key);
  }
}
