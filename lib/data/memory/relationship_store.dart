/// Relationship store — persists the weighted graph + per-person profiles.
library;

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/models/memory/relationship_graph.dart';

class RelationshipStore {
  final FlutterSecureStorage _storage;
  static const _graphKey = 'relationship_graph';
  static const _personPrefix = 'relationship_person_';

  RelationshipStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Save the full relationship graph.
  Future<void> saveGraph(RelationshipGraph graph) async {
    await _storage.write(key: _graphKey, value: jsonEncode(graph.toJson()));
  }

  /// Load the full relationship graph.
  Future<RelationshipGraph> loadGraph() async {
    final json = await _storage.read(key: _graphKey);
    if (json == null) {
      return RelationshipGraph(lastUpdated: DateTime.now());
    }
    return RelationshipGraph.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  /// Save a per-person profile.
  Future<void> savePerson(RelationshipPerson person) async {
    await _storage.write(
      key: '$_personPrefix${person.id}',
      value: jsonEncode(person.toJson()),
    );
  }

  /// Load a per-person profile.
  Future<RelationshipPerson?> loadPerson(String id) async {
    final json = await _storage.read(key: '$_personPrefix$id');
    if (json == null) return null;
    return RelationshipPerson.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  /// Load all person profiles.
  Future<List<RelationshipPerson>> loadAllPersons() async {
    final graph = await loadGraph();
    final persons = <RelationshipPerson>[];
    for (final node in graph.nodes) {
      final person = await loadPerson(node.id);
      if (person != null) persons.add(person);
    }
    return persons;
  }

  /// Delete all relationship data (for reset).
  Future<void> clear() async {
    await _storage.delete(key: _graphKey);
    final graph = await loadGraph();
    for (final node in graph.nodes) {
      await _storage.delete(key: '$_personPrefix${node.id}');
    }
  }
}
