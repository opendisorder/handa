import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/models/progress_stats.dart';
import '../../../domain/models/memory/brain_region.dart';
import '../../../domain/models/memory/word_mastery.dart';
import '../../../domain/models/memory/relationship_graph.dart';
import '../../../data/memory/brain_region_store.dart';
import '../../../data/memory/word_mastery_store.dart';
import '../../../data/memory/relationship_store.dart';
import '../../providers/database_provider.dart';
import '../../providers/digital_brain_providers.dart';

final _progressStatsProvider = FutureProvider<ProgressStats?>((ref) async {
  final repo = ref.watch(sessionRepositoryProvider);
  return repo.getProgressStats();
});

/// Loads all 10 brain region states for the Digital Brain dashboard.
final _brainRegionsProvider = FutureProvider<List<BrainRegionState>>((ref) async {
  final store = ref.watch(brainRegionStoreProvider);
  final results = await Future.wait(
    BrainRegion.values.map((r) => store.load(r)),
  );
  return results.toList();
});

/// Loads the word mastery index.
final _wordMasteryProvider = FutureProvider<WordMasteryIndex?>((ref) async {
  final store = ref.watch(wordMasteryStoreProvider);
  return store.load();
});

/// Loads the relationship graph.
final _relationshipGraphProvider = FutureProvider<RelationshipGraph?>((ref) async {
  final store = ref.watch(relationshipStoreProvider);
  return store.loadGraph();
});

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(_progressStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('ප්‍රගතිය'),
      ),
      body: SafeArea(
        child: statsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => _buildEmptyState(context),
          data: (stats) => stats == null || stats.totalSessions == 0
              ? _buildEmptyState(context)
              : _buildDashboard(context, ref, stats),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart_rounded, size: 80, color: AppColors.disabled),
            const SizedBox(height: 16),
            Text(
              'තවම දත්ත නැත',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'ප්‍රගතිය බැලීමට අභ්‍යාස සැසියක් ආරම්භ කරන්න',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.go(AppRoutes.session),
              child: const Text('සැසිය ආරම්භ කරන්න'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, WidgetRef ref, ProgressStats stats) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryRow(context, stats),
          const SizedBox(height: AppConstants.spacingLg),
          _buildBarChart(context, stats),
          const SizedBox(height: AppConstants.spacingLg),
          _buildScoreDistribution(context, stats),
          const SizedBox(height: AppConstants.spacingLg),
          _buildStatsCard(context, stats),
          const SizedBox(height: AppConstants.spacingLg),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => context.go(AppRoutes.caregiverDashboard),
              icon: const Icon(Icons.health_and_safety),
              label: const Text('පවුලේ අයගේ දර්ශනය'),
            ),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          _buildDigitalBrainSection(context, ref),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, ProgressStats stats) {
    return Row(
      children: [
        _summaryCard(context, 'සැසි', '${stats.totalSessions}', AppColors.primary),
        const SizedBox(width: 12),
        _summaryCard(context, 'අඛණ්ඩව', '${stats.currentStreak}', AppColors.energy),
        const SizedBox(width: 12),
        _summaryCard(context, 'සාමාන්‍ය', '${stats.overallAverageScore?.toInt() ?? 0}%', AppColors.accent),
      ],
    );
  }

  Widget _summaryCard(BuildContext context, String label, String value, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Column(
            children: [
              Text(value, style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: color)),
              const SizedBox(height: 4),
              Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart(BuildContext context, ProgressStats stats) {
    final history = stats.scoreHistory;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ලකුණු ප්‍රස්ථාරය', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            if (history.isEmpty)
              SizedBox(
                height: 160,
                child: Center(
                  child: Text(
                    'තවම ප්‍රමාණවත් දත්ත නැත',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                height: 160,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 100,
                    barGroups: List.generate(history.length, (i) {
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: history[i].clamp(0, 100),
                            color: AppColors.primary,
                            width: 12,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                          ),
                        ],
                      );
                    }),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true, reservedSize: 32, getTitlesWidget: (v, _) {
                          if (v == 0 || v == 50 || v == 100) {
                            return Text('${v.toInt()}', style: const TextStyle(fontSize: 10));
                          }
                          return const SizedBox.shrink();
                        }),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: history.length > 1,
                          reservedSize: 24,
                          getTitlesWidget: (v, _) {
                            final idx = v.toInt();
                            if (idx >= 0 && idx < history.length && idx % 5 == 0) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text('${idx + 1}', style: const TextStyle(fontSize: 10)),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 50,
                      getDrawingHorizontalLine: (v) => FlLine(
                        color: AppColors.chartGrid,
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreDistribution(BuildContext context, ProgressStats stats) {
    final total = stats.totalAttempts;
    if (total == 0) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ලකුණු බෙදාහැරීම', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _levelRow(context, 'විශිෂ්ටයි', stats.excellentCount, total, AppColors.scoreExcellent),
            const SizedBox(height: 8),
            _levelRow(context, 'හොඳයි', stats.goodCount, total, AppColors.scoreGood),
            const SizedBox(height: 8),
            _levelRow(context, 'බොහෝ දුරට', stats.almostCount, total, AppColors.scoreAlmost),
            const SizedBox(height: 8),
            _levelRow(context, 'නැවත උත්සාහ', stats.tryAgainCount, total, AppColors.scoreTryAgain),
          ],
        ),
      ),
    );
  }

  Widget _levelRow(BuildContext context, String label, int count, int total, Color color) {
    final ratio = total > 0 ? count / total : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyLarge),
            Text('$count', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: color)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            backgroundColor: AppColors.disabled.withValues(alpha: 0.2),
            color: color,
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard(BuildContext context, ProgressStats stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('සංඛ්‍යා ලේඛන', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _statRow(context, 'සම්පූර්ණ සැසි', '${stats.totalSessions}'),
            const Divider(),
            _statRow(context, 'සම්පූර්ණ උත්සාහ', '${stats.totalAttempts}'),
            const Divider(),
            _statRow(context, 'සමත් අනුපාතය', '${stats.passingRate.toInt()}%'),
            const Divider(),
            _statRow(context, 'මෙම සතියේ සැසි', '${stats.sessionsThisWeek}'),
            const Divider(),
            _statRow(context, 'අඛණ්ඩ දින', '${stats.currentStreak}'),
            const Divider(),
            _statRow(context, 'හුස්ම අභ්‍යාස දින', '${stats.breathingDaysCompleted}'),
          ],
        ),
      ),
    );
  }

  Widget _statRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primary)),
        ],
      ),
    );
  }

  // ─── Digital Brain Dashboard Section ──────────────────────────────────────

  Widget _buildDigitalBrainSection(BuildContext context, WidgetRef ref) {
    final regionsAsync = ref.watch(_brainRegionsProvider);
    final masteryAsync = ref.watch(_wordMasteryProvider);
    final relAsync = ref.watch(_relationshipGraphProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ඩිජිටල් මොළය',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'ඔබගේ ප්‍රගතියේ සම්පූර්ණ චිත්‍රය',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppConstants.spacingMd),

        // Brain Regions Grid
        regionsAsync.when(
          loading: () => const Center(child: Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(strokeWidth: 2),
          )),
          error: (e, _) => const SizedBox.shrink(),
          data: (regions) => _buildBrainRegionGrid(context, regions),
        ),

        const SizedBox(height: AppConstants.spacingMd),

        // Word Mastery + Relationship row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: masteryAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (e, _) => const SizedBox.shrink(),
                data: (index) => index != null
                    ? _buildMasteryCard(context, index)
                    : const SizedBox.shrink(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: relAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (e, _) => const SizedBox.shrink(),
                data: (graph) => graph != null && graph.nodes.isNotEmpty
                    ? _buildRelationshipCard(context, graph)
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBrainRegionGrid(BuildContext context, List<BrainRegionState> regions) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'මොළ කලාප 10',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: regions.map((state) {
                final insightCount = state.insights.length;
                final color = _regionColor(state.region, insightCount);
                return Tooltip(
                  message: '${state.region.description}\n'
                      'අවසන් යාවත්කාලීන: ${_formatDate(state.lastUpdated)}\n'
                      'තොරතුරු: $insightCount',
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 72,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: color.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: color.withValues(alpha: 0.4),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _regionShortName(state.region),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMasteryCard(BuildContext context, WordMasteryIndex index) {
    final mastered = index.mastered.length;
    final learning = index.learning.length;
    final total = index.words.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'වචන ප්‍රගතිය',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            if (total == 0)
              Text(
                'තවම වචන නැත',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              )
            else ...[
              _masteryDot(context, 'ප්‍රගුණ කළා', mastered, total, AppColors.scoreExcellent),
              const SizedBox(height: 8),
              _masteryDot(context, 'ඉගෙන ගන්නවා', learning, total, AppColors.scoreAlmost),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'සම්පූර්ණ: $total',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${index.masteryRate.toInt()}%',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRelationshipCard(BuildContext context, RelationshipGraph graph) {
    // Show top 3 relationships by importance
    final top = graph.nodes
        .toList()
      ..sort((a, b) => b.importance.compareTo(a.importance));
    final topNodes = top.take(3).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'සබඳතා',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            if (topNodes.isEmpty)
              Text(
                'තවම සබඳතා නැත',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              )
            else
              ...topNodes.map((node) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      _valenceIcon(node.valence),
                      size: 16,
                      color: _valenceColor(node.valence),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        node.id,
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${(node.importance * 100).toInt()}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              )),
            if (graph.clusters.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'කාණ්ඩ: ${graph.clusters.map((c) => c.name).join(', ')}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _masteryDot(BuildContext context, String label, int count, int total, Color color) {
    final ratio = total > 0 ? count / total : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text(label, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            Text('$count', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: ratio,
            backgroundColor: AppColors.disabled.withValues(alpha: 0.2),
            color: color,
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  Color _regionColor(BrainRegion region, int insightCount) {
    if (insightCount >= 5) return AppColors.scoreExcellent;
    if (insightCount >= 2) return AppColors.scoreGood;
    if (insightCount >= 1) return AppColors.scoreAlmost;
    return AppColors.disabled;
  }

  String _regionShortName(BrainRegion region) {
    switch (region) {
      case BrainRegion.prefrontalCortex: return 'PFC';
      case BrainRegion.hippocampus: return 'Hipp';
      case BrainRegion.amygdala: return 'Amyg';
      case BrainRegion.brocaArea: return 'Broca';
      case BrainRegion.wernickeArea: return 'Wern';
      case BrainRegion.motorCortex: return 'Motor';
      case BrainRegion.temporalLobe: return 'Temp';
      case BrainRegion.cerebellum: return 'Cereb';
      case BrainRegion.brainstem: return 'Brain';
      case BrainRegion.corpusCallosum: return 'Corp';
    }
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}';
  }

  IconData _valenceIcon(RelationshipValence valence) {
    switch (valence) {
      case RelationshipValence.positive: return Icons.favorite;
      case RelationshipValence.negative: return Icons.warning_amber;
      case RelationshipValence.mixed: return Icons.sync;
      case RelationshipValence.neutral: return Icons.circle_outlined;
    }
  }

  Color _valenceColor(RelationshipValence valence) {
    switch (valence) {
      case RelationshipValence.positive: return AppColors.scoreExcellent;
      case RelationshipValence.negative: return AppColors.scoreTryAgain;
      case RelationshipValence.mixed: return AppColors.scoreAlmost;
      case RelationshipValence.neutral: return AppColors.textSecondary;
    }
  }
}
