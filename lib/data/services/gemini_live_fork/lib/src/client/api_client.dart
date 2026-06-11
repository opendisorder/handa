import 'dart:convert';

import 'package:http/http.dart' as http;

/// Low-level HTTP client for Vertex AI REST API calls.
///
/// Uses OAuth2 Bearer token instead of API key.
/// Endpoints are constructed for the Vertex AI platform.
class ApiClient {
  /// OAuth2 Bearer access token.
  final String accessToken;

  /// Custom base URL override.
  final String? baseUrl;

  /// The Google Cloud project ID.
  final String projectId;

  /// The Vertex AI location/region.
  final String location;

  /// The API version string (e.g., 'v1beta1').
  final String apiVersion;

  final http.Client _httpClient;

  ApiClient({
    required this.accessToken,
    required this.projectId,
    required this.location,
    this.baseUrl,
    this.apiVersion = 'v1beta1',
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  /// Constructs the full request URI for a given API path.
  ///
  /// Uses the Vertex AI endpoint with Bearer token auth.
  Uri _buildUri(String path) {
    final effectiveBaseUrl =
        baseUrl ?? 'https://$location-aiplatform.googleapis.com';
    // Vertex AI REST uses the pattern:
    // https://{location}-aiplatform.googleapis.com/{apiVersion}/projects/{projectId}/locations/{location}/{path}
    return Uri.parse(
      '$effectiveBaseUrl/$apiVersion/$path',
    );
  }

  /// Sends a POST request with OAuth2 Bearer token auth.
  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final uri = _buildUri(path);
    final response = await _httpClient.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'X-Goog-User-Project': projectId,
      },
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('API Error: ${response.statusCode} ${response.body}');
    }
  }

  /// Closes the underlying HTTP client.
  void close() {
    _httpClient.close();
  }
}
