/// Relationship tree — weighted graph of patient's interpersonal connections.
///
/// Each person has an emotional weight, valence, and interaction profile.
/// The graph supports queries like "what triggers shame?" and
/// "what brings joy?" via cluster analysis.
library;

class RelationshipNode {
  final String id;
  final double importance; // 0.0 - 1.0
  final RelationshipValence valence;
  final DateTime lastUpdated;

  const RelationshipNode({
    required this.id,
    required this.importance,
    this.valence = RelationshipValence.neutral,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'importance': importance,
        'valence': valence.name,
        'lastUpdated': lastUpdated.toIso8601String(),
  };

  factory RelationshipNode.fromJson(Map<String, dynamic> json) =>
      RelationshipNode(
        id: json['id'] as String,
        importance: (json['importance'] as num).toDouble(),
        valence: RelationshipValence.values.firstWhere(
          (v) => v.name == json['valence'],
          orElse: () => RelationshipValence.neutral,
        ),
        lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      );
}

enum RelationshipValence { positive, negative, mixed, neutral }

class RelationshipEdge {
  final String from;
  final String to;
  final String relation; // e.g., 'loves_but_shamed_by'
  final double weight; // 0.0 - 1.0

  const RelationshipEdge({
    required this.from,
    required this.to,
    required this.relation,
    this.weight = 0.5,
  });

  Map<String, dynamic> toJson() => {
        'from': from,
        'to': to,
        'relation': relation,
        'weight': weight,
  };

  factory RelationshipEdge.fromJson(Map<String, dynamic> json) =>
      RelationshipEdge(
        from: json['from'] as String,
        to: json['to'] as String,
        relation: json['relation'] as String,
        weight: (json['weight'] as num).toDouble(),
      );
}

class RelationshipCluster {
  final String name;
  final List<String> nodeIds;

  const RelationshipCluster({required this.name, required this.nodeIds});

  Map<String, dynamic> toJson() => {'name': name, 'nodes': nodeIds};

  factory RelationshipCluster.fromJson(Map<String, dynamic> json) =>
      RelationshipCluster(
        name: json['name'] as String,
        nodeIds: List<String>.from(json['nodes'] as List),
      );
}

/// The full weighted graph of all patient connections.
class RelationshipGraph {
  final List<RelationshipNode> nodes;
  final List<RelationshipEdge> edges;
  final List<RelationshipCluster> clusters;
  final DateTime lastUpdated;

  const RelationshipGraph({
    this.nodes = const [],
    this.edges = const [],
    this.clusters = const [],
    required this.lastUpdated,
  });

  RelationshipGraph copyWith({
    List<RelationshipNode>? nodes,
    List<RelationshipEdge>? edges,
    List<RelationshipCluster>? clusters,
    DateTime? lastUpdated,
  }) =>
      RelationshipGraph(
        nodes: nodes ?? this.nodes,
        edges: edges ?? this.edges,
        clusters: clusters ?? this.clusters,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );

  /// Find all nodes in a cluster by name.
  List<RelationshipNode> getCluster(String name) {
    final cluster = clusters.where((c) => c.name == name).firstOrNull;
    if (cluster == null) return [];
    return nodes.where((n) => cluster.nodeIds.contains(n.id)).toList();
  }

  /// Find edges connected to a node.
  List<RelationshipEdge> edgesFor(String nodeId) =>
      edges.where((e) => e.from == nodeId || e.to == nodeId).toList();

  /// Get a node by ID.
  RelationshipNode? node(String id) {
    try {
      return nodes.firstWhere((n) => n.id == id);
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> toJson() => {
        'nodes': nodes.map((n) => n.toJson()).toList(),
        'edges': edges.map((e) => e.toJson()).toList(),
        'clusters': clusters.map((c) => c.toJson()).toList(),
        'lastUpdated': lastUpdated.toIso8601String(),
      };

  factory RelationshipGraph.fromJson(Map<String, dynamic> json) =>
      RelationshipGraph(
        nodes: (json['nodes'] as List)
            .map((n) => RelationshipNode.fromJson(n as Map<String, dynamic>))
            .toList(),
        edges: (json['edges'] as List)
            .map((e) => RelationshipEdge.fromJson(e as Map<String, dynamic>))
            .toList(),
        clusters: (json['clusters'] as List)
            .map((c) =>
                RelationshipCluster.fromJson(c as Map<String, dynamic>))
            .toList(),
        lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      );
}

/// Per-person SAYS/FEELS/DOES profile for AI strategic insight.
class RelationshipPerson {
  final String id;
  final String name;
  final double importance; // 0.0 - 1.0
  final RelationshipValence valence;

  // SAYS: Direct quotes categorized
  final List<String> positiveStatements;
  final List<String> negativeStatements;
  final List<String> hiddenStatements;

  // FEELS: Inferred emotional state
  final List<String> feels;

  // DOES: Behavioral patterns
  final List<String> behaviors;

  // Strategic insight for AI
  final List<String> insights;
  final DateTime lastUpdated;

  const RelationshipPerson({
    required this.id,
    required this.name,
    this.importance = 0.5,
    this.valence = RelationshipValence.neutral,
    this.positiveStatements = const [],
    this.negativeStatements = const [],
    this.hiddenStatements = const [],
    this.feels = const [],
    this.behaviors = const [],
    this.insights = const [],
    required this.lastUpdated,
  });

  RelationshipPerson copyWith({
    double? importance,
    RelationshipValence? valence,
    List<String>? positiveStatements,
    List<String>? negativeStatements,
    List<String>? hiddenStatements,
    List<String>? feels,
    List<String>? behaviors,
    List<String>? insights,
    DateTime? lastUpdated,
  }) =>
      RelationshipPerson(
        id: id,
        name: name,
        importance: importance ?? this.importance,
        valence: valence ?? this.valence,
        positiveStatements: positiveStatements ?? this.positiveStatements,
        negativeStatements: negativeStatements ?? this.negativeStatements,
        hiddenStatements: hiddenStatements ?? this.hiddenStatements,
        feels: feels ?? this.feels,
        behaviors: behaviors ?? this.behaviors,
        insights: insights ?? this.insights,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'importance': importance,
        'valence': valence.name,
        'says': {
          'positive': positiveStatements,
          'negative': negativeStatements,
          'hidden': hiddenStatements,
        },
        'feels': feels,
        'does': behaviors,
        'insights': insights,
        'lastUpdated': lastUpdated.toIso8601String(),
  };

  factory RelationshipPerson.fromJson(Map<String, dynamic> json) {
    final says = json['says'] as Map<String, dynamic>? ?? {};
    return RelationshipPerson(
      id: json['id'] as String,
      name: json['name'] as String,
      importance: (json['importance'] as num).toDouble(),
      valence: RelationshipValence.values.firstWhere(
        (v) => v.name == json['valence'],
        orElse: () => RelationshipValence.neutral,
      ),
      positiveStatements: List<String>.from(says['positive'] ?? []),
      negativeStatements: List<String>.from(says['negative'] ?? []),
      hiddenStatements: List<String>.from(says['hidden'] ?? []),
      feels: List<String>.from(json['feels'] ?? []),
      behaviors: List<String>.from(json['does'] ?? []),
      insights: List<String>.from(json['insights'] ?? []),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }
}
