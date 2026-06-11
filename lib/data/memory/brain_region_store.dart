/// In-memory store for brain region state.
///
/// In Phase 1, this uses local JSON serialization. In Phase 2+,
/// this can be backed by Firestore for cloud persistence.
///
/// The background agent reads all regions, analyzes sessions,
/// and appends new insights with timestamps.
library;

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/models/memory/brain_region.dart';

class BrainRegionStore {
  final FlutterSecureStorage _storage;
  static const _prefix = 'brain_region_';

  BrainRegionStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Load state for a single brain region.
  Future<BrainRegionState> load(BrainRegion region) async {
    final json = await _storage.read(key: '$_prefix${region.id}');
    if (json == null) {
      return BrainRegionState(
        region: region,
        insights: [],
        lastUpdated: DateTime.now(),
      );
    }
    return BrainRegionState.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  /// Save state for a brain region.
  Future<void> save(BrainRegionState state) async {
    await _storage.write(
      key: '$_prefix${state.region.id}',
      value: jsonEncode(state.toJson()),
    );
  }

  /// Append a new insight to a brain region and save.
  Future<void> appendInsight(
    BrainRegion region,
    BrainRegionInsight insight,
  ) async {
    final state = await load(region);
    final updated = state.copyWith(
      insights: [...state.insights, insight],
      lastUpdated: insight.timestamp,
    );
    await save(updated);
  }

  /// Load all 10 brain regions.
  Future<Map<BrainRegion, BrainRegionState>> loadAll() async {
    final result = <BrainRegion, BrainRegionState>{};
    for (final region in BrainRegion.values) {
      result[region] = await load(region);
    }
    return result;
  }

  /// Load specific set of regions by type for targeted analysis.
  Future<Map<BrainRegion, BrainRegionState>> loadByTypes(
    List<BrainRegion> regions,
  ) async {
    final result = <BrainRegion, BrainRegionState>{};
    for (final region in regions) {
      result[region] = await load(region);
    }
    return result;
  }

  /// Get the amygdala state (emotional triggers).
  Future<BrainRegionState> get amygdala => load(BrainRegion.amygdala);

  /// Get the broca area state (speech production).
  Future<BrainRegionState> get brocaArea => load(BrainRegion.brocaArea);

  /// Delete all brain region data (for reset).
  Future<void> clear() async {
    for (final region in BrainRegion.values) {
      await _storage.delete(key: '$_prefix${region.id}');
    }
  }
}
