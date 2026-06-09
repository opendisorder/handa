import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';
import '../../core/errors/app_exceptions.dart';

/// Gemini API configuration for picture-naming evaluation.
///
/// Uses gemini-2.5-flash via REST for cost efficiency.
/// The API key is stored server-side in the Cloudflare Worker.
class GeminiApiClient {
  final http.Client _http;
  final String _baseUrl;

  GeminiApiClient({
    http.Client? httpClient,
    String? baseUrl,
  }) : _http = httpClient ?? http.Client(),
       _baseUrl = baseUrl ?? AppConstants.cloudflareWorkerUrl;

  /// Evaluate a user's spoken response against the expected word.
  ///
  /// Sends audio transcription + expected answer to the Cloudflare Worker,
  /// which proxies the request to Gemini 2.5 Flash.
  Future<GeminiEvaluationResponse> evaluatePictureNaming({
    required String userResponse,
    required String expectedAnswer,
    required String languageCode,
  }) async {
    try {
      final response = await _http
          .post(
            Uri.parse('$_baseUrl/api/evaluate'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'user_response': userResponse,
              'expected_answer': expectedAnswer,
              'language': languageCode,
            }),
          )
          .timeout(AppConstants.apiTimeout);

      if (response.statusCode != 200) {
        throw ApiException(
          message: 'Gemini API returned ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return GeminiEvaluationResponse(
        score: (body['score'] as num).toDouble(),
        feedback: body['feedback'] as String?,
        isCorrect: body['is_correct'] as bool? ?? false,
        confidence: (body['confidence'] as num?)?.toDouble(),
      );
    } on http.ClientException catch (e) {
      throw NetworkException(
        message: 'Network error: ${e.message}',
        originalError: e,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException(
        message: 'Unexpected Gemini API error',
        originalError: e,
      );
    }
  }

  /// Health check for the Cloudflare Worker proxy.
  Future<bool> healthCheck() async {
    try {
      final response = await _http
          .get(Uri.parse('$_baseUrl/health'))
          .timeout(const Duration(seconds: 10));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  void dispose() => _http.close();
}

/// Gemini evaluation response.
class GeminiEvaluationResponse {
  final double score;
  final String? feedback;
  final bool isCorrect;
  final double? confidence;

  const GeminiEvaluationResponse({
    required this.score,
    this.feedback,
    required this.isCorrect,
    this.confidence,
  });
}
