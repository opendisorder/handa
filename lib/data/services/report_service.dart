import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../domain/models/progress_stats.dart';
import '../../core/theme/app_colors.dart';

class ReportService {
  ReportService._();

  static Future<void> generateAndShare(
    BuildContext context,
    ProgressStats stats, {
    String userName = 'රෝගියා',
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (contextPdf) => [
          _buildHeader(stats, userName),
          pw.SizedBox(height: 24),
          _buildSummaryTable(stats),
          pw.SizedBox(height: 24),
          _buildScoreDistribution(stats),
          pw.SizedBox(height: 24),
          _buildRecentSessions(stats),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'handa_report_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  static pw.Widget _buildHeader(ProgressStats stats, String userName) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'හඬ - ප්‍රගති වාර්තාව',
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
            color: PdfColor.fromInt(AppColors.primary.toARGB32()),
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          'රෝගියා: $userName',
          style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
        ),
        pw.Text(
          'වාර්තා දිනය: ${_formatDate(DateTime.now())}',
          style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
        ),
      ],
    );
  }

  static pw.Widget _buildSummaryTable(ProgressStats stats) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'සාරාංශය',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColor.fromInt(AppColors.primary.toARGB32()),
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          columnWidths: const {0: pw.FlexColumnWidth(2), 1: pw.FlexColumnWidth(1)},
          children: [
            _tableRow('සම්පූර්ණ සැසි', '${stats.totalSessions}'),
            _tableRow('සම්පූර්ණ උත්සාහ', '${stats.totalAttempts}'),
            _tableRow('සාමාන්‍ය ලකුණු', '${stats.overallAverageScore?.toInt() ?? 0}%'),
            _tableRow('සමත් අනුපාතය', '${stats.passingRate.toInt()}%'),
            _tableRow('අඛණ්ඩ දින', '${stats.currentStreak}'),
            _tableRow('මෙම සතියේ සැසි', '${stats.sessionsThisWeek}'),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildScoreDistribution(ProgressStats stats) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'ලකුණු බෙදාහැරීම',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColor.fromInt(AppColors.primary.toARGB32()),
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          columnWidths: const {0: pw.FlexColumnWidth(2), 1: pw.FlexColumnWidth(1)},
          children: [
            _tableRow('විශිෂ්ටයි', '${stats.excellentCount}'),
            _tableRow('හොඳයි', '${stats.goodCount}'),
            _tableRow('බොහෝ දුරට', '${stats.almostCount}'),
            _tableRow('නැවත උත්සාහ', '${stats.tryAgainCount}'),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildRecentSessions(ProgressStats stats) {
    final sessions = stats.recentSessions;
    if (sessions.isEmpty) return pw.SizedBox.shrink();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'මෑත සැසි',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColor.fromInt(AppColors.primary.toARGB32()),
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          columnWidths: const {1: pw.FlexColumnWidth(1), 0: pw.FlexColumnWidth(2)},
          children: sessions.take(10).map((s) {
            return _tableRow(
              '${s.startedAt.year}-${s.startedAt.month.toString().padLeft(2, '0')}-${s.startedAt.day.toString().padLeft(2, '0')}',
              '${s.averageScore?.toInt() ?? 0}% (${s.completedExercises}/${s.totalExercises})',
            );
          }).toList(),
        ),
      ],
    );
  }

  static pw.TableRow _tableRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(label, style: const pw.TextStyle(fontSize: 12)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(value, style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          )),
        ),
      ],
    );
  }

  static String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }
}
