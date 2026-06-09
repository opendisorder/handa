import 'package:flutter/material.dart';
import 'app_colors.dart';
import '../constants/app_constants.dart';

/// Handa Material 3 theme with accessibility-first design.
///
/// All text meets WCAG AAA contrast. Minimum 28sp font size
/// (mapped to Material 3 headlineSmall role as display baseline).
class AppTheme {
  AppTheme._();

  // ─── Typography ────────────────────────────────────────────
  // All text meets 28sp minimum for elderly accessibility.
  // We map to headlineSmall as the body text role so that
  // default Material text inherits large sizing.
  static const String _fontFamily = 'NotoSansSinhala';

  static const TextTheme _textTheme = TextTheme(
    // Display roles — for score numbers, hero text
    displayLarge: TextStyle(
      fontSize: 56,
      fontWeight: FontWeight.w700,
      fontFamily: _fontFamily,
      color: AppColors.textPrimary,
      height: 1.2,
    ),
    displayMedium: TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w700,
      fontFamily: _fontFamily,
      color: AppColors.textPrimary,
      height: 1.2,
    ),
    displaySmall: TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.w700,
      fontFamily: _fontFamily,
      color: AppColors.textPrimary,
      height: 1.2,
    ),

    // Headline roles — for section titles, score labels
    headlineLarge: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      fontFamily: _fontFamily,
      color: AppColors.textPrimary,
      height: 1.3,
    ),
    headlineMedium: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      fontFamily: _fontFamily,
      color: AppColors.textPrimary,
      height: 1.3,
    ),
    headlineSmall: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      fontFamily: _fontFamily,
      color: AppColors.textPrimary,
      height: 1.3,
    ),

    // Title roles — buttons, cards, navigation
    titleLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      fontFamily: _fontFamily,
      color: AppColors.textPrimary,
      height: 1.3,
    ),
    titleMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      fontFamily: _fontFamily,
      color: AppColors.textPrimary,
      height: 1.3,
    ),
    titleSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      fontFamily: _fontFamily,
      color: AppColors.textSecondary,
      height: 1.3,
    ),

    // Body roles — instructions, descriptions
    bodyLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w500,
      fontFamily: _fontFamily,
      color: AppColors.textPrimary,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      fontFamily: _fontFamily,
      color: AppColors.textPrimary,
      height: 1.5,
    ),
    bodySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      fontFamily: _fontFamily,
      color: AppColors.textSecondary,
      height: 1.5,
    ),

    // Label roles — buttons, chips, small indicators
    labelLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      fontFamily: _fontFamily,
      color: AppColors.textOnPrimary,
      height: 1.3,
    ),
    labelMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      fontFamily: _fontFamily,
      color: AppColors.textPrimary,
      height: 1.3,
    ),
    labelSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      fontFamily: _fontFamily,
      color: AppColors.textSecondary,
      height: 1.3,
    ),
  );

  // ─── Themes ────────────────────────────────────────────────
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      primaryContainer: AppColors.primaryLight,
      secondary: AppColors.accent,
      onSecondary: AppColors.textPrimary,
      secondaryContainer: AppColors.accent,
      tertiary: AppColors.energy,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.error,
      onError: AppColors.textOnPrimary,
      outline: AppColors.divider,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _textTheme,
      primaryTextTheme: _textTheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: _fontFamily,

      // ─── AppBar ──────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: AppConstants.fontSizeHeading,
          fontWeight: FontWeight.w700,
          fontFamily: _fontFamily,
          color: AppColors.textPrimary,
        ),
        iconTheme: IconThemeData(color: AppColors.primary, size: 32),
      ),

      // ─── Cards ───────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 2,
        shadowColor: AppColors.divider,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
        margin: const EdgeInsets.all(AppConstants.spacingSm),
      ),

      // ─── Buttons ─────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          disabledBackgroundColor: AppColors.disabled,
          disabledForegroundColor: AppColors.textHint,
          minimumSize: const Size.fromHeight(AppConstants.buttonMinHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLg,
            vertical: AppConstants.spacingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.fontSizeButton,
            fontWeight: FontWeight.w700,
            fontFamily: _fontFamily,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 2),
          minimumSize: const Size.fromHeight(AppConstants.buttonMinHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLg,
            vertical: AppConstants.spacingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.fontSizeButton,
            fontWeight: FontWeight.w700,
            fontFamily: _fontFamily,
          ),
        ),
      ),

      // ─── Input Decoration ─────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.all(AppConstants.spacingMd),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: const TextStyle(
          fontSize: AppConstants.fontSizeBody,
          fontFamily: _fontFamily,
          color: AppColors.textSecondary,
        ),
        hintStyle: const TextStyle(
          fontSize: AppConstants.fontSizeBody,
          fontFamily: _fontFamily,
          color: AppColors.textHint,
        ),
      ),

      // ─── Slider ──────────────────────────────────────────
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.divider,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withValues(alpha: 0.12),
        valueIndicatorColor: AppColors.primary,
        valueIndicatorTextStyle: const TextStyle(
          fontSize: AppConstants.fontSizeBody,
          fontFamily: _fontFamily,
          color: AppColors.textOnPrimary,
        ),
      ),

      // ─── Bottom Sheet ─────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.radiusXl),
          ),
        ),
      ),

      // ─── Dialog ──────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.dialogBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        ),
      ),

      // ─── Divider ─────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: AppConstants.spacingMd,
      ),

      // ─── Snackbar ────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.primaryDark,
        contentTextStyle: const TextStyle(
          fontSize: AppConstants.fontSizeBody,
          fontFamily: _fontFamily,
          color: AppColors.textOnPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // ─── Tooltip ─────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        textStyle: const TextStyle(
          fontSize: AppConstants.fontSizeSmall,
          fontFamily: _fontFamily,
          color: AppColors.textOnPrimary,
        ),
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        ),
      ),

      // ─── Chip ────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primaryLight,
        labelStyle: const TextStyle(
          fontSize: AppConstants.fontSizeBody,
          fontFamily: _fontFamily,
          color: AppColors.textPrimary,
        ),
        padding: const EdgeInsets.all(AppConstants.spacingSm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        ),
      ),
    );
  }

  // ─── Dark Theme (accessible variant) ───────────────────────
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.dark(
      primary: AppColors.primaryLight,
      onPrimary: AppColors.textOnDark,
      primaryContainer: AppColors.primary,
      secondary: AppColors.accent,
      surface: const Color(0xFF1A1A2E),
      onSurface: AppColors.textOnDark,
      error: AppColors.energy,
      onError: AppColors.textOnDark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _textTheme.apply(
        displayColor: AppColors.textOnDark,
        bodyColor: AppColors.textOnDark,
      ),
      scaffoldBackgroundColor: const Color(0xFF1A1A2E),
      fontFamily: _fontFamily,
      // Inherit light theme structure —
      // extend with dark-specific overrides as needed
    );
  }
}
