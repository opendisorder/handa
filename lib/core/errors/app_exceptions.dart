/// Base exception for all Handa app errors.
sealed class AppException implements Exception {
  final String message;
  final String userMessage; // Sinhala user-facing message
  final Object? originalError;
  final StackTrace? stackTrace;

  AppException({
    required this.message,
    required this.userMessage,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message';
}

// ─── Network & API Errors ────────────────────────────────────

class NetworkException extends AppException {
  NetworkException({
    required super.message,
    super.userMessage = 'අන්තර්ජාල සම්බන්ධතාවය පරීක්ෂා කරන්න',
    super.originalError,
    super.stackTrace,
  });
}

class ApiException extends AppException {
  final int? statusCode;

  ApiException({
    required super.message,
    this.statusCode,
    super.userMessage = 'සේවාදායක දෝෂයකි. පසුව නැවත උත්සාහ කරන්න',
    super.originalError,
    super.stackTrace,
  });
}

class TimeoutException extends AppException {
  TimeoutException({
    required super.message,
    super.userMessage = 'යමක් වැරදී ඇත. නැවත උත්සාහ කරන්න',
    super.originalError,
    super.stackTrace,
  });
}

class GeminiException extends AppException {
  GeminiException({
    required super.message,
    super.userMessage = 'යමක් වැරදී ඇත. නැවත උත්සාහ කරන්න',
    super.originalError,
    super.stackTrace,
  });
}

// ─── Audio Errors ────────────────────────────────────────────

class AudioPermissionException extends AppException {
  AudioPermissionException({
    super.message = 'Microphone permission denied',
    super.userMessage = 'මයික්‍රෆෝනයට ඉඩ දෙන්න',
    super.originalError,
    super.stackTrace,
  });
}

class AudioRecordingException extends AppException {
  AudioRecordingException({
    required super.message,
    super.userMessage = 'ශබ්දය පටිගත කිරීමේ දෝෂයකි',
    super.originalError,
    super.stackTrace,
  });
}

// ─── Database Errors ─────────────────────────────────────────

class DatabaseException extends AppException {
  DatabaseException({
    required super.message,
    super.userMessage = 'දත්ත ගබඩා දෝෂයකි',
    super.originalError,
    super.stackTrace,
  });
}

// ─── Scoring Errors ──────────────────────────────────────────

class ScoringException extends AppException {
  ScoringException({
    required super.message,
    super.userMessage = 'ලකුණු ගණනය කිරීමේ දෝෂයකි',
    super.originalError,
    super.stackTrace,
  });
}

// ─── PIN & Auth Errors ───────────────────────────────────────

class PinException extends AppException {
  PinException({
    required super.message,
    super.userMessage = 'PIN දෝෂයකි',
    super.originalError,
    super.stackTrace,
  });
}

class PinLockoutException extends AppException {
  PinLockoutException({
    required super.message,
    super.userMessage =
        'උත්සාහයන් ඉක්මවා ඇත. විනාඩි 15කට පසු නැවත උත්සාහ කරන්න',
    super.originalError,
    super.stackTrace,
  });
}

// ─── General Errors ──────────────────────────────────────────

class UnknownException extends AppException {
  UnknownException({
    required super.message,
    super.userMessage = 'හදිසි දෝෂයකි',
    super.originalError,
    super.stackTrace,
  });
}
