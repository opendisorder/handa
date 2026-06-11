/// Caregiver weekly report — generates a PDF summary of the patient's therapy week.
///
/// Consolidates session logs, word mastery progress, brain region insights,
/// and struggle patterns into a single printable report.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/models/memory/session_log.dart';
import '../../domain/models/memory/word_mastery.dart';
import '../../domain/models/memory/brain_region.dart';
import '../memory/session_log_store.dart';
import '../memory/word_mastery_store.dart';
import '../memory/brain_region_store.dart';

/// A summary snapshot for one day of therapy.
class _DaySummary {
  final DateTime date;
  final int sessionCount;
  final int exercisesCompleted;
  final double avgScore;
  final int cuesUsed;
  final String? note;

  const _DaySummary({
    required this.date,
    required this.sessionCount,
    required this.exercisesCompleted,
    required this.avgScore,
    required this.cuesUsed,
    this.note,
  });
}

/// Generates a caregiver-friendly weekly PDF report.
class CaregiverReportService {
  final SessionLogStore _sessionLogStore;
  final WordMasteryStore _wordMasteryStore;
  final BrainRegionStore _brainRegionStore;

  CaregiverReportService({
    required SessionLogStore sessionLogStore,
    required WordMasteryStore wordMasteryStore,
    required BrainRegionStore brainRegionStore,
  })  : _sessionLogStore = sessionLogStore,
        _wordMasteryStore = wordMasteryStore,
        _brainRegionStore = brainRegionStore;

  /// Generate a weekly report PDF and return the file bytes.
  ///
  /// [endDate] defaults to today. The report covers the 7 days prior.
  Future<Uint8List> generateWeeklyReport({DateTime? endDate}) async {
    final end = endDate ?? DateTime.now();
    final start = end.subtract(const Duration(days: 7));

    // Gather data
    final sessions =
        await _sessionLogStore.loadByDateRange(start: start, end: end);
    final wordMastery = await _wordMasteryStore.load();
    final regions = await _brainRegionStore.loadAll();

    final daySummaries = _buildDaySummaries(sessions, start, end);
    final (mastered, learning, total) = _countWords(wordMastery);
    final topInsights = _getTopInsights(regions);

    return _buildPdf(
      weekStart: start,
      weekEnd: end,
      daySummaries: daySummaries,
      mastered: mastered,
      learning: learning,
      totalWords: total,
      totalSessions: sessions.length,
      topInsights: topInsights,
    );
  }

  /// Save the report to a temp file and trigger a share sheet.
  Future<void> shareWeeklyReport({DateTime? endDate}) async {
    final pdfBytes = await generateWeeklyReport(endDate: endDate);
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/handa_weekly_report_${DateFormat('yyyyMMdd').format(endDate ?? DateTime.now())}.pdf',
    );
    await file.writeAsBytes(pdfBytes);
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Handa Weekly Therapy Report',
    );
  }

  // ── Private helpers ────────────────────────────────────────

  List<_DaySummary> _buildDaySummaries(
    List<SessionLog> sessions,
    DateTime start,
    DateTime end,
  ) {
    final summaries = <_DaySummary>[];
    for (int i = 0; i < 7; i++) {
      final day = start.add(Duration(days: i));
      final daySessions = sessions.where((s) =>
          s.startedAt.year == day.year &&
          s.startedAt.month == day.month &&
          s.startedAt.day == day.day).toList();

      if (daySessions.isEmpty) {
        summaries.add(_DaySummary(
          date: day,
          sessionCount: 0,
          exercisesCompleted: 0,
          avgScore: 0,
          cuesUsed: 0,
          note: 'No sessions',
        ));
      } else {
        final totalEx = daySessions.fold<int>(
            0, (s, log) => s + log.summary.totalWordsPracticed);
        final totalScore = daySessions.fold<double>(
            0.0,
            (s, log) =>
                s + (log.summary.overallScore ?? 0.0));
        final cues = daySessions.fold<int>(
            0, (s, log) => s + log.struggleEvents.length);
        summaries.add(_DaySummary(
          date: day,
          sessionCount: daySessions.length,
          exercisesCompleted: totalEx,
          avgScore: daySessions.isNotEmpty ? totalScore / daySessions.length : 0,
          cuesUsed: cues,
        ));
      }
    }
    return summaries;
  }

  (int mastered, int learning, int total) _countWords(
      WordMasteryIndex? index) {
    if (index == null) return (0, 0, 0);
    int mastered = 0;
    int learning = 0;
    for (final word in index.words.values) {
      if (word.isMastered) {
        mastered++;
      } else {
        learning++;
      }
    }
    return (mastered, learning, index.words.length);
  }

  List<String> _getTopInsights(
      Map<BrainRegion, BrainRegionState> regions) {
    final insights = <String>[];
    for (final entry in regions.entries) {
      final state = entry.value;
      if (state.insights.isNotEmpty) {
        insights
            .add('${entry.key.id}: ${state.insights.last.text}');
      }
    }
    return insights.take(5).toList();
  }

  Future<Uint8List> _buildPdf({
    required DateTime weekStart,
    required DateTime weekEnd,
    required List<_DaySummary> daySummaries,
    required int mastered,
    required int learning,
    required int totalWords,
    required int totalSessions,
    required List<String> topInsights,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (ctx) => [
          // ── Header ────────────────────────────────────────
          pw.Header(
            level: 0,
            child: pw.Text('Handa Weekly Therapy Report',
                style:
                    pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Paragraph(
            text: 'Report Period: ${DateFormat('MMM d, yyyy').format(weekStart)} — '
                '${DateFormat('MMM d, yyyy').format(weekEnd)}',
            style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 16),

          // ── Overview ───────────────────────────────────────
          pw.Header(level: 1, text: 'Overview'),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _statBox('Sessions', '$totalSessions'),
              _statBox('Exercises',
                  '${daySummaries.fold(0, (s, d) => s + d.exercisesCompleted)}'),
              _statBox('Avg Score',
                  '${daySummaries.where((d) => d.sessionCount > 0).fold<double>(0.0, (s, d) => s + d.avgScore) ~/ (daySummaries.where((d) => d.sessionCount > 0).length).clamp(1, 999)}%'),
            ],
          ),
          pw.SizedBox(height: 16),

          // ── Daily Breakdown ────────────────────────────────
          pw.Header(level: 1, text: 'Daily Activity'),
          pw.TableHelper.fromTextArray(
            headerStyle:
                pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            cellStyle: pw.TextStyle(fontSize: 10),
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.center,
              2: pw.Alignment.center,
              3: pw.Alignment.center,
              4: pw.Alignment.center,
            },
            data: <List<String>>[
              ['Day', 'Sessions', 'Exercises', 'Avg Score', 'Cue Escalations'],
              ...daySummaries.map((d) => [
                DateFormat('EEE, MMM d').format(d.date),
                '${d.sessionCount}',
                '${d.exercisesCompleted}',
                d.sessionCount > 0 ? '${d.avgScore.toStringAsFixed(0)}%' : '—',
                '${d.cuesUsed}',
              ]),
            ],
          ),
          pw.SizedBox(height: 16),

          // ── Word Mastery ───────────────────────────────────
          pw.Header(level: 1, text: 'Word Mastery'),
          pw.Text(
              '$mastered mastered  ·  $learning in progress  ·  $totalWords total'),
          if (totalWords > 0) ...[
            pw.SizedBox(height: 8),
            pw.Container(
              height: 20,
              alignment: pw.Alignment.centerLeft,
              child: pw.Row(children: [
                pw.Container(
                  width: (mastered / totalWords) * 400,
                  color: PdfColors.green600,
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                      '${(mastered / totalWords * 100).toStringAsFixed(0)}%',
                      style: const pw.TextStyle(
                          color: PdfColors.white, fontSize: 9)),
                ),
                pw.Container(
                  width: (learning / totalWords) * 400,
                  color: PdfColors.orange600,
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                      '${(learning / totalWords * 100).toStringAsFixed(0)}%',
                      style: const pw.TextStyle(
                          color: PdfColors.white, fontSize: 9)),
                ),
              ]),
            ),
          ],
          pw.SizedBox(height: 16),

          // ── Brain Insights ─────────────────────────────────
          if (topInsights.isNotEmpty) ...[
            pw.Header(level: 1, text: 'Clinical Insights'),
            ...topInsights.map(
                (i) => pw.Bullet(text: i, style: pw.TextStyle(fontSize: 10))),
            pw.SizedBox(height: 16),
          ],

          // ── Cueing History ─────────────────────────────────
          pw.Header(level: 1, text: 'Cueing Ladder Usage'),
          pw.Text(
            'Total cue escalations this week: ${daySummaries.fold(0, (s, d) => s + d.cuesUsed)}',
            style: pw.TextStyle(fontSize: 10),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Levels: L0=Free Recall · L1=Phonetic · L2=Syllables · L3=Full Model',
            style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
          pw.SizedBox(height: 16),

          // ── Footer ─────────────────────────────────────────
          pw.Divider(),
          pw.Text(
            'Generated by Handa (හඬ) Speech Therapy App',
            style: pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
          ),
          pw.Text(
            'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}',
            style: pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _statBox(String label, String value) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        children: [
          pw.Text(value,
              style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue800)),
          pw.SizedBox(height: 4),
          pw.Text(label, style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
        ],
      ),
    );
  }
}
