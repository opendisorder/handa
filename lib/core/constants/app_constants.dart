/// App-wide constants for Handa (හඬ)
class AppConstants {
  AppConstants._();

  // ─── App Info ───────────────────────────────────────────────
  static const String appName = 'Handa';
  static const String appNameSinhala = 'හඬ';
  static const String appTagline = 'ඔබේ හඬ නැවත සොයා ගන්න';
  static const String appTaglineEn = 'Find your voice again';
  static const String packageName = 'com.handa.handa';
  static const String version = '1.0.0';

  // ─── Scoring Thresholds ────────────────────────────────────
  static const double excellentThreshold = 90.0;
  static const double goodThreshold = 75.0;
  static const double almostThreshold = 60.0;

  // ─── Session Rules ─────────────────────────────────────────
  static const double masteredRatio = 0.4;
  static const double practicingRatio = 0.4;
  static const double newRatio = 0.2;
  static const double newRatioFirstWeek = 0.8;
  static const double practicingRatioFirstWeek = 0.2;

  // ─── Mastery Requirements ──────────────────────────────────
  static const double masteryThreshold = 70.0;
  static const int attemptsForMastery = 3;

  // ─── Breathing Exercise ────────────────────────────────────
  static const int breathInhaleSeconds = 4;
  static const int breathHoldSeconds = 4;
  static const int breathExhaleSeconds = 6;
  static const int breathMandatoryDays = 30;
  static const int breathCyclesPerSession = 5;

  // ─── Live Conversation ────────────────────────────────────
  static const int liveMaxDurationMinutes = 5;

  // ─── Caregiver Dashboard ──────────────────────────────────
  static const int pinLength = 4;
  static const int maxPinAttempts = 5;
  static const int pinLockoutMinutes = 15;

  // ─── Font Sizes (minimum 28sp for accessibility) ──────────
  static const double fontSizeTitle = 32.0;
  static const double fontSizeHeading = 28.0;
  static const double fontSizeBody = 28.0;
  static const double fontSizeSmall = 24.0;
  static const double fontSizeButton = 28.0;
  static const double fontSizeScore = 48.0;

  // ─── Spacing ───────────────────────────────────────────────
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // ─── Border Radius ─────────────────────────────────────────
  static const double radiusSm = 8.0;
  static const double radiusMd = 16.0;
  static const double radiusLg = 24.0;
  static const double radiusXl = 32.0;

  // ─── Sizing ────────────────────────────────────────────────
  static const double tabletBreakpoint = 600.0;
  static const double maxContentWidth = 800.0;
  static const double buttonMinHeight = 56.0;
  static const double touchTargetMin = 48.0;
  static const double scoreCircleSize = 120.0;
  static const double imageCardMaxHeight = 300.0;

  // ─── Animation ─────────────────────────────────────────────
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animNormal = Duration(milliseconds: 350);
  static const Duration animSlow = Duration(milliseconds: 600);
  static const Duration animPageTransition = Duration(milliseconds: 300);

  // ─── Audio ─────────────────────────────────────────────────
  static const int sampleRate = 44100;
  static const int audioBitRate = 128000;

  // ─── Vertex AI (Live API - OAuth2 Bearer Token) ─────────────
  static const String gcpProjectId = 'biz-studio-1779528000';
  static const String gcpLocation = 'us-central1';
  static const String liveApiModel = 'gemini-live-2.5-flash-native-audio';
  static const String scoringModel = 'gemini-3.1-flash-lite-preview';

  // ─── Gemini REST API (Legacy - being migrated to Vertex AI) ─
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  static const String geminiApiKey =
      'AIzaSyAoFNLv00RmHoJOmtzrQgIoEash3-CaEdI';
  static const String geminiApiBaseUrl =
      'https://generativelanguage.googleapis.com/v1beta';
  static const String geminiModel = 'gemini-2.5-flash-001';

  // ─── Database ──────────────────────────────────────────────
  static const String dbName = 'handa.db';
  static const int dbVersion = 1;

  // ─── Offline ───────────────────────────────────────────────
  static const int syncBatchSize = 50;
  static const Duration syncInterval = Duration(minutes: 15);
}

/// Score level enum matching the four-tier grading system
enum ScoreLevel {
  excellent,
  good,
  almost,
  tryAgain;

  bool get isPassing => this != tryAgain;
  bool get isMastered => this == excellent || this == good;

  static ScoreLevel fromPercentage(double percentage) {
    if (percentage >= AppConstants.excellentThreshold) return excellent;
    if (percentage >= AppConstants.goodThreshold) return good;
    if (percentage >= AppConstants.almostThreshold) return almost;
    return tryAgain;
  }
}

/// Supported languages
enum AppLanguage {
  sinhala('si', 'සිංහල'),
  tamil('ta', 'தமிழ்'),
  english('en', 'English');

  final String code;
  final String displayName;
  const AppLanguage(this.code, this.displayName);
}
