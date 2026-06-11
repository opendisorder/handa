import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Extension on BuildContext for quick theme access.
extension ThemeExtensions on BuildContext {
  /// Whether the device is a tablet (>= 600dp width).
  bool get isTablet => MediaQuery.of(this).size.shortestSide >= 600;

  /// Safe area top padding.
  double get topPadding => MediaQuery.of(this).padding.top;

  /// Safe area bottom padding.
  double get bottomPadding => MediaQuery.of(this).padding.bottom;

  /// Maximum content width (caps at 800dp on tablets).
  double get maxContentWidth =>
      MediaQuery.of(this).size.width > 800 ? 800 : MediaQuery.of(this).size.width;
}

/// Haptic vibration patterns for score feedback.
///
/// Maps to the 4-tier scoring system with distinct patterns.
/// Never uses REJECT haptic pattern.
class HapticPatterns {
  /// Excellent: short double-tap (success)
  static Future<void> excellent() async {
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
  }

  /// Good: single medium tap
  static Future<void> good() async {
    await HapticFeedback.mediumImpact();
  }

  /// Almost: single light tap
  static Future<void> almost() async {
    await HapticFeedback.lightImpact();
  }

  /// Try Again: gentle pulse (never REJECT)
  static Future<void> tryAgain() async {
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.selectionClick();
  }

  /// Play haptic based on score level string.
  static Future<void> forScoreLevel(String level) async {
    switch (level) {
      case 'excellent': return excellent();
      case 'good': return good();
      case 'almost': return almost();
      case 'try_again': return tryAgain();
    }
  }

  /// Breathing exercise haptic guide.
  static Future<void> breathingPhase(String phase) async {
    switch (phase) {
      case 'inhale':
        await HapticFeedback.lightImpact();
        break;
      case 'hold':
        await HapticFeedback.selectionClick();
        break;
      case 'exhale':
        await HapticFeedback.mediumImpact();
        break;
    }
  }
}
