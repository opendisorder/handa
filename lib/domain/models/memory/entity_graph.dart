/// Entity Knowledge Graph — topics/concepts with emotional valence.
///
/// Tracks how the patient feels about specific topics (cricket=joy, money=shame)
/// so the AI can route conversation away from triggers and toward joy anchors.
library;

enum EmotionalValence {
  joy,
  shame,
  trigger,
  neutral,
  sadness,
  pride;

  bool get isAvoid => this == shame || this == trigger;
  bool get isApproach => this == joy || this == pride;
}

/// A topic or concept with its emotional profile.
class EntityNode {
  final String id;
  final String displayName;
  final EmotionalValence valence;
  final double strength; // 0.0 - 1.0, how strongly felt
  final DateTime firstSeen;
  final DateTime lastUpdated;
  final List<String> associatedTopics; // links to other entity IDs

  const EntityNode({
    required this.id,
    required this.displayName,
    this.valence = EmotionalValence.neutral,
    this.strength = 0.5,
    required this.firstSeen,
    required this.lastUpdated,
    this.associatedTopics = const [],
  });

  EntityNode copyWith({
    EmotionalValence? valence,
    double? strength,
    DateTime? lastUpdated,
    List<String>? associatedTopics,
  }) =>
      EntityNode(
        id: id,
        displayName: displayName,
        valence: valence ?? this.valence,
        strength: strength ?? this.strength,
        firstSeen: firstSeen,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        associatedTopics: associatedTopics ?? this.associatedTopics,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'displayName': displayName,
        'valence': valence.name,
        'strength': strength,
        'firstSeen': firstSeen.toIso8601String(),
        'lastUpdated': lastUpdated.toIso8601String(),
        'associatedTopics': associatedTopics,
  };

  factory EntityNode.fromJson(Map<String, dynamic> json) => EntityNode(
        id: json['id'] as String,
        displayName: json['displayName'] as String,
        valence: EmotionalValence.values.firstWhere(
          (v) => v.name == json['valence'],
          orElse: () => EmotionalValence.neutral,
        ),
        strength: (json['strength'] as num).toDouble(),
        firstSeen: DateTime.parse(json['firstSeen'] as String),
        lastUpdated: DateTime.parse(json['lastUpdated'] as String),
        associatedTopics: List<String>.from(json['associatedTopics'] ?? []),
      );
}

/// The complete entity knowledge graph.
class EntityGraph {
  final List<EntityNode> nodes;
  final DateTime lastUpdated;

  const EntityGraph({
    this.nodes = const [],
    required this.lastUpdated,
  });

  EntityGraph copyWith({
    List<EntityNode>? nodes,
    DateTime? lastUpdated,
  }) =>
      EntityGraph(
        nodes: nodes ?? this.nodes,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );

  /// Get all topics the AI should avoid.
  List<EntityNode> get avoidTopics =>
      nodes.where((n) => n.valence.isAvoid).toList();

  /// Get all joy/pride topics the AI should lean into.
  List<EntityNode> get approachTopics =>
      nodes.where((n) => n.valence.isApproach).toList();

  /// Get a node by ID.
  EntityNode? node(String id) {
    try {
      return nodes.firstWhere((n) => n.id == id);
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> toJson() => {
        'nodes': nodes.map((n) => n.toJson()).toList(),
        'lastUpdated': lastUpdated.toIso8601String(),
      };

  factory EntityGraph.fromJson(Map<String, dynamic> json) => EntityGraph(
        nodes: (json['nodes'] as List)
            .map((n) => EntityNode.fromJson(n as Map<String, dynamic>))
            .toList(),
        lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      );
}
