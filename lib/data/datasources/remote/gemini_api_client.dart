import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exceptions.dart';

/// Client for Gemini REST API calls (scoring, conversation).
///
/// Migrated from API key auth to Vertex AI OAuth2 Bearer token.
/// Uses the Vertex AI REST endpoint with `generateContent` instead
/// of the old `?key=` API key approach.
class GeminiApiClient {
  final http.Client _http;
  final String _apiKey; // Kept as fallback, but OAuth2 is preferred.

  /// OAuth2 Bearer access token for Vertex AI auth.
  /// If null, falls back to API key auth (legacy).
  final String? _accessToken;

  GeminiApiClient({
    http.Client? httpClient,
    String? apiKey,
    String? accessToken,
  })  : _http = httpClient ?? http.Client(),
      _apiKey = apiKey ?? AppConstants.geminiApiKey,
      _accessToken = accessToken;

  /// Builds headers with OAuth2 Bearer token or API key fallback.
  Map<String, String> _buildHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (_accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
      headers['X-Goog-User-Project'] = AppConstants.gcpProjectId;
    }

    return headers;
  }

  /// Builds the Vertex AI REST endpoint URL.
  Uri _buildVertexUrl({required bool stream}) {
    final model = AppConstants.scoringModel;
    final method = stream ? 'streamGenerateContent' : 'generateContent';
    return Uri.parse(
      'https://${AppConstants.gcpLocation}-aiplatform.googleapis.com/'
      'v1beta1/projects/${AppConstants.gcpProjectId}/'
      'locations/${AppConstants.gcpLocation}/'
      'publishers/google/models/$model:$method',
    );
  }

  /// Builds the legacy Gemini API URL (fallback when no token).
  Uri _buildLegacyUrl({required bool stream}) {
    final model = AppConstants.geminiModel;
    final method = stream ? 'streamGenerateContent' : 'generateContent';
    return Uri.parse(
      '${AppConstants.geminiApiBaseUrl}/models/$model:$method?key=$_apiKey',
    );
  }

  /// Chooses the URL based on available auth.
  Uri _buildUrl({required bool stream}) {
    if (_accessToken != null) {
      return _buildVertexUrl(stream: stream);
    }
    return _buildLegacyUrl(stream: stream);
  }

  Future<GeminiEvaluationResponse> evaluatePictureNaming({
    required String userResponse,
    required String expectedAnswer,
    required String languageCode,
  }) async {
    final prompt = _buildEvaluationPrompt(
      userResponse, expectedAnswer, languageCode,
    );
    try {
      final response = await _http
          .post(
            _buildUrl(stream: false),
            headers: _buildHeaders(),
            body: jsonEncode({
              'contents': [
                {
                  'parts': [
                    {'text': prompt},
                  ],
                },
              ],
              'generationConfig': {
                'temperature': 0.2,
                'maxOutputTokens': 200,
              },
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

      // Vertex AI uses 'candidates[].content.parts[].text'
      // same structure as Gemini API — compatible response format.
      final text = body['candidates']?[0]?['content']?['parts']?[0]?['text']
          as String? ?? '';
      return _parseEvaluationResponse(text);
    } on http.ClientException catch (e) {
      throw NetworkException(
        message: 'Network error: ${e.message}', originalError: e,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException(
        message: 'Unexpected Gemini API error', originalError: e,
      );
    }
  }

  String _buildEvaluationPrompt(
    String userResponse,
    String expectedAnswer,
    String languageCode,
  ) {
    return '''You are a speech rehabilitation evaluator. Evaluate the user's spoken response.

Expected answer: "$expectedAnswer"
User said: "$userResponse"
Language: ${languageCode == 'si' ? 'Sinhala' : languageCode == 'ta' ? 'Tamil' : 'English'}

Respond ONLY with a JSON object:
{
  "score": <0-100 number based on pronunciation similarity>,
  "is_correct": <true/false>,
  "confidence": <0.0-1.0>,
  "feedback": "<short encouraging message in the user's language>"
}

Be generous - this is speech therapy. If the user's response is close, give partial credit.''';
  }

  GeminiEvaluationResponse _parseEvaluationResponse(String text) {
    try {
      final cleaned = text
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();
      final json = jsonDecode(cleaned) as Map<String, dynamic>;
      return GeminiEvaluationResponse(
        score: (json['score'] as num?)?.toDouble() ?? 0.0,
        feedback: json['feedback'] as String?,
        isCorrect: json['is_correct'] as bool? ?? false,
        confidence: (json['confidence'] as num?)?.toDouble(),
      );
    } catch (_) {
      return GeminiEvaluationResponse(
        score: 0.0,
        isCorrect: false,
        feedback: 'Could not evaluate',
      );
    }
  }

  Future<Stream<String>> liveConversation({
    required String languageCode,
    required String userMessage,
  }) async {
    final prompt = _buildConversationPrompt(languageCode);
    try {
      final response = await _http
          .post(
            _buildUrl(stream: true),
            headers: _buildHeaders(),
            body: jsonEncode({
              'contents': [
                {
                  'parts': [
                    {'text': prompt},
                    {'text': userMessage},
                  ],
                },
              ],
              'generationConfig': {
                'temperature': 0.7,
                'maxOutputTokens': 512,
              },
            }),
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode != 200) {
        throw ApiException(
          message: 'Conversation API returned ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }

      // Vertex AI SSE format uses the same `data: {...}` lines as Gemini API.
      final lines = response.body.split('\n');
      return Stream.fromIterable(
        lines
            .where((l) => l.startsWith('data: ') && l != 'data: [DONE]')
            .map((l) {
              try {
                final data =
                    jsonDecode(l.substring(6)) as Map<String, dynamic>;
                return data['candidates']?[0]?['content']?['parts']?[0]?['text']
                    as String? ?? '';
              } catch (_) {
                return '';
              }
            })
            .where((t) => t.isNotEmpty),
      );
    } on http.ClientException catch (e) {
      throw NetworkException(
        message: 'Network error: ${e.message}', originalError: e,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException(
        message: 'Unexpected conversation error', originalError: e,
      );
    }
  }

  String _buildConversationPrompt(String languageCode) {
    final lang = languageCode == 'si'
        ? 'Sinhala'
        : languageCode == 'ta'
            ? 'Tamil'
            : 'English';
    return '''You are a friendly speech therapy conversation partner. 
The user is recovering from a stroke and practicing $lang speech.
Rules:
- Speak clearly and slowly
- Use simple vocabulary and short sentences
- Ask one question at a time
- Be encouraging and patient
- If you don't understand, gently ask them to repeat
- Never say "wrong" or "incorrect"
- Topics: family, weather, food, hobbies, daily routine
Respond in $lang.''';
  }

  Future<bool> healthCheck() async {
    try {
      final response = await _http
          .get(Uri.parse(
            'https://${AppConstants.gcpLocation}-aiplatform.googleapis.com/'
            'v1beta1/projects/${AppConstants.gcpProjectId}/'
            'locations/${AppConstants.gcpLocation}/'
            'publishers/google/models/${AppConstants.scoringModel}',
          ))
          .timeout(const Duration(seconds: 10));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  void dispose() => _http.close();
}

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
