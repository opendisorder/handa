import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/models/progress_stats.dart';
import '../../providers/database_provider.dart';
import '../../providers/digital_brain_providers.dart';
import '../../../data/services/report_service.dart';

final _caregiverStatsProvider = FutureProvider<ProgressStats?>((ref) async {
  final repo = ref.watch(sessionRepositoryProvider);
  return repo.getProgressStats();
});

class CaregiverDashboardScreen extends ConsumerStatefulWidget {
  const CaregiverDashboardScreen({super.key});

  @override
  ConsumerState<CaregiverDashboardScreen> createState() =>
      _CaregiverDashboardScreenState();
}

class _CaregiverDashboardScreenState
    extends ConsumerState<CaregiverDashboardScreen> {
  bool _authenticated = false;
  bool _locked = false;
  int _attempts = 0;
  final _pinController = TextEditingController();
  static const _correctPin = '1234'; // default caregiver PIN

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _checkPin() {
    if (_locked) return;
    if (_pinController.text == _correctPin) {
      setState(() => _authenticated = true);
      _pinController.clear();
    } else {
      _attempts++;
      if (_attempts >= AppConstants.maxPinAttempts) {
        setState(() => _locked = true);
        Future.delayed(const Duration(minutes: 1), () {
          if (mounted) setState(() => _locked = false);
        });
      } else {
        _pinController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('වැරදි PIN. ${AppConstants.maxPinAttempts - _attempts} උත්සාහ ඉතිරි')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_authenticated) {
      return _buildPinGate(context);
    }
    return _buildDashboard(context);
  }

  Widget _buildPinGate(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('පවුලේ අයගේ දර්ශනය')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _locked ? Icons.lock_outline : Icons.lock_open,
                size: 64,
                color: _locked ? AppColors.scoreTryAgain : AppColors.primary,
              ),
              const SizedBox(height: 24),
              Text(
                _locked ? 'බොහෝ උත්සාහ කර ඇත' : 'PIN ඇතුළත් කරන්න',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _locked
                    ? 'කරුණාකර මිනිත්තු 1කට පසු නැවත උත්සාහ කරන්න'
                    : 'රැකබලා ගන්නා තැනැත්තාගේ PIN එක ඇතුළත් කරන්න',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _pinController,
                  textAlign: TextAlign.center,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: AppConstants.pinLength,
                  style: Theme.of(context).textTheme.headlineLarge,
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '•' * AppConstants.pinLength,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (v) {
                    if (v.length == AppConstants.pinLength) _checkPin();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context) {
    final statsAsync = ref.watch(_caregiverStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('පවුලේ අයගේ දර්ශනය'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'වාර්තාව බාගන්න',
            onPressed: () => _generateReport(context),
          ),
          TextButton(
            onPressed: () => setState(() => _authenticated = false),
            child: const Text('පිටවන්න'),
          ),
        ],
      ),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('දත්ත පූරණය කිරීමේ දෝෂයකි')),
        data: (stats) => stats == null || stats.totalSessions == 0
            ? _buildEmpty(context)
            : _buildContent(context, stats),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return const Center(
      child: Text('තවම ප්‍රමාණවත් දත්ත නැත'),
    );
  }

  Widget _buildContent(BuildContext context, ProgressStats stats) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderCards(context, stats),
          const SizedBox(height: AppConstants.spacingLg),
          _buildLineChart(context, stats),
          const SizedBox(height: AppConstants.spacingLg),
          _buildDistributionPie(context, stats),
          const SizedBox(height: AppConstants.spacingLg),
          _buildRecentSessions(context, stats),
          const SizedBox(height: AppConstants.spacingLg),
          _buildWeeklyReportCard(context),
        ],
      ),
    );
  }

  Widget _buildHeaderCards(BuildContext context, ProgressStats stats) {
    return Column(
      children: [
        Row(
          children: [
            _bigCard(context, 'සම්පූර්ණ සැසි', '${stats.totalSessions}', Icons.checklist, AppColors.primary),
            const SizedBox(width: 12),
            _bigCard(context, 'අඛණ්ඩ දින', '${stats.currentStreak}', Icons.local_fire_department, AppColors.energy),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _bigCard(context, 'සාමාන්‍ය ලකුණු', '${stats.overallAverageScore?.toInt() ?? 0}%', Icons.trending_up, AppColors.accent),
            const SizedBox(width: 12),
            _bigCard(context, 'සමත් අනුපාතය', '${stats.passingRate.toInt()}%', Icons.emoji_events, AppColors.success),
          ],
        ),
      ],
    );
  }

  Widget _bigCard(BuildContext context, String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(value, style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: color)),
              Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLineChart(BuildContext context, ProgressStats stats) {
    final history = stats.scoreHistory;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ලකුණු ප්‍රවණතාව', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            if (history.length < 2)
              SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    'ප්‍රස්ථාරයට ප්‍රමාණවත් දත්ත නැත',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: 100,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 25,
                      getDrawingHorizontalLine: (v) => FlLine(
                        color: AppColors.chartGrid,
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          getTitlesWidget: (v, _) => Text('${v.toInt()}', style: const TextStyle(fontSize: 10)),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 24,
                          interval: max(1, (history.length / 5).ceil()).toDouble(),
                          getTitlesWidget: (v, _) {
                            final idx = v.toInt();
                            if (idx >= 0 && idx < history.length) {
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
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(history.length, (i) => FlSpot(i.toDouble(), history[i])),
                        isCurved: true,
                        color: AppColors.chartLine,
                        barWidth: 3,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
                            radius: 4,
                            color: AppColors.chartLine,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          ),
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.chartFill,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionPie(BuildContext context, ProgressStats stats) {
    final total = stats.totalAttempts;
    if (total == 0) return const SizedBox.shrink();
    final sections = [
      if (stats.excellentCount > 0)
        PieChartSectionData(
          value: stats.excellentCount.toDouble(),
          color: AppColors.scoreExcellent,
          title: '${(stats.excellentCount / total * 100).toInt()}%',
          radius: 40,
          titleStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      if (stats.goodCount > 0)
        PieChartSectionData(
          value: stats.goodCount.toDouble(),
          color: AppColors.scoreGood,
          title: '${(stats.goodCount / total * 100).toInt()}%',
          radius: 40,
          titleStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      if (stats.almostCount > 0)
        PieChartSectionData(
          value: stats.almostCount.toDouble(),
          color: AppColors.scoreAlmost,
          title: '${(stats.almostCount / total * 100).toInt()}%',
          radius: 40,
          titleStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      if (stats.tryAgainCount > 0)
        PieChartSectionData(
          value: stats.tryAgainCount.toDouble(),
          color: AppColors.scoreTryAgain,
          title: '${(stats.tryAgainCount / total * 100).toInt()}%',
          radius: 40,
          titleStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ලකුණු බෙදාහැරීම', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(PieChartData(
                      sections: sections,
                      centerSpaceRadius: 30,
                      sectionsSpace: 2,
                    )),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _legendDot('විශිෂ්ටයි', AppColors.scoreExcellent),
                      const SizedBox(height: 8),
                      _legendDot('හොඳයි', AppColors.scoreGood),
                      const SizedBox(height: 8),
                      _legendDot('බොහෝ දුරට', AppColors.scoreAlmost),
                      const SizedBox(height: 8),
                      _legendDot('නැවත උත්සාහ', AppColors.scoreTryAgain),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendDot(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildRecentSessions(BuildContext context, ProgressStats stats) {
    final sessions = stats.recentSessions;
    if (sessions.isEmpty) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('මෑත සැසි', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ...sessions.take(5).map((s) => ListTile(
                  dense: true,
                  title: Text(s.type == 'picture_naming' ? 'පින්තූර නම් කිරීම' : s.type),
                  subtitle: Text(_formatDate(s.startedAt)),
                  trailing: Text('${s.averageScore?.toInt() ?? 0}%', style: TextStyle(color: AppColors.primary)),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyReportCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.assignment, color: AppColors.primary),
                const SizedBox(width: 8),
                Text('සතිපතා වාර්තාව', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'පසුගිය දින 7 සඳහා සවිස්තරාත්මක වාර්තාවක් උත්පාදනය කරන්න. '
              'සැසි දත්ත, වචන ප්‍රගතිය, සහ සායනික තීක්ෂණ ඇතුළත් වේ.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _generateWeeklyReport(context),
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('සතිපතා වාර්තාව බාගන්න'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  Future<void> _generateReport(BuildContext context) async {
    final repo = ref.read(sessionRepositoryProvider);
    final stats = await repo.getProgressStats();
    if (!mounted) return;
    await ReportService.generateAndShare(
      context,
      stats,
      userName: 'රෝගියා',
    );
  }

  Future<void> _generateWeeklyReport(BuildContext context) async {
    try {
      final service = ref.read(caregiverReportServiceProvider);
      if (!mounted) return;
      await service.shareWeeklyReport();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('වාර්තාව උත්පාදනය කිරීමේ දෝෂයකි: $e')),
        );
      }
    }
  }
}
