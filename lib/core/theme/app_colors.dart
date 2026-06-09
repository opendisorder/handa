import 'package:flutter/material.dart';

/// Handa warm color system — zero red, zero negative connotations.
///
/// Design rationale:
/// - Off-white #FDF6EC as primary background (warm, paper-like)
/// - Teal #2A9D8F as primary action color (calm, medical, trustworthy)
/// - Amber #E9C46A as accent (warmth, encouragement)
/// - Warm orange #F4A261 for energy (never red — no "wrong" feeling)
/// - Soft peach #F5C5B0 for gentle highlights
class AppColors {
  AppColors._();

  // ─── Core Brand ────────────────────────────────────────────
  static const Color background = Color(0xFFFDF6EC);
  static const Color surface = Color(0xFFFFFBF4);
  static const Color primary = Color(0xFF2A9D8F);
  static const Color primaryDark = Color(0xFF1F7A6F);
  static const Color primaryLight = Color(0xFF4DB6AC);
  static const Color accent = Color(0xFFE9C46A);
  static const Color accentDark = Color(0xFFD4A843);
  static const Color energy = Color(0xFFF4A261);
  static const Color energyDark = Color(0xFFE07B3A);
  static const Color softPeach = Color(0xFFF5C5B0);

  // ─── Text ──────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color textHint = Color(0xFFB2BEC3);

  // ─── Surfaces ──────────────────────────────────────────────
  static const Color cardBackground = Color(0xFFFFFBF4);
  static const Color dialogBackground = Color(0xFFFFFBF4);
  static const Color divider = Color(0xFFE8E0D8);
  static const Color disabled = Color(0xFFB2BEC3);
  static const Color shimmer = Color(0xFFE8E0D8);

  // ─── Score Colors (no red) ─────────────────────────────────
  static const Color scoreExcellent = Color(0xFF2A9D8F); // teal
  static const Color scoreGood = Color(0xFF4DB6AC); // light teal
  static const Color scoreAlmost = Color(0xFFE9C46A); // amber
  static const Color scoreTryAgain = Color(0xFFF4A261); // warm orange

  // ─── Status ────────────────────────────────────────────────
  static const Color success = Color(0xFF2A9D8F);
  static const Color warning = Color(0xFFE9C46A);
  static const Color info = Color(0xFF4DB6AC);
  static const Color error = Color(0xFFF4A261); // warm orange, never red

  // ─── Breathing Exercise ────────────────────────────────────
  static const Color inhale = Color(0xFF4DB6AC);
  static const Color hold = Color(0xFFE9C46A);
  static const Color exhale = Color(0xFFF4A261);

  // ─── Caregiver Dashboard ───────────────────────────────────
  static const Color chartLine = Color(0xFF2A9D8F);
  static const Color chartFill = Color(0x332A9D8F);
  static const Color chartGrid = Color(0xFFE8E0D8);

  // ─── Gradient helpers ──────────────────────────────────────
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFDF6EC), Color(0xFFFFFBF4)],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2A9D8F), Color(0xFF4DB6AC)],
  );

  static const LinearGradient scoreExcellentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2A9D8F), Color(0xFF4DB6AC)],
  );

  static const LinearGradient scoreGoodGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4DB6AC), Color(0xFF80CBC4)],
  );

  static const LinearGradient scoreAlmostGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE9C46A), Color(0xFFF0D78C)],
  );

  static const LinearGradient scoreTryAgainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF4A261), Color(0xFFF7C59F)],
  );
}
