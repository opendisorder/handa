import 'package:http/http.dart' as http;

import 'client/api_client.dart';
import 'live_service.dart';

// Re-export key classes from the live service module.
export 'live_service.dart'
    show
        LiveCallbacks,
        LiveConnectParameters,
        LiveSession,
        LiveService,
        TimeoutException;

// Re-export all model classes.
export 'model/models.dart';

/// The primary class for interacting with the Vertex AI Gemini Live API.
///
/// Use OAuth2 Bearer token authentication (from ADC) instead of API keys.
/// All requests go through the Vertex AI endpoint (us-central1-aiplatform.googleapis.com)
/// to consume GCP credits.
///
/// Example usage:
/// ```dart
/// final genAI = GoogleGenAI(
///   accessToken: 'ya29...',
///   projectId: 'my-project',
///   location: 'us-central1',
/// );
/// ```
class GoogleGenAI {
  /// OAuth2 Bearer access token for Vertex AI authentication.
  final String accessToken;

  /// The Google Cloud project ID.
  final String projectId;

  /// The Vertex AI location/region (e.g., 'us-central1').
  final String location;

  /// Custom base URL override (for testing or alternative endpoints).
  final String? baseUrl;

  /// API version used by the live module.
  final String apiVersion;

  /// An optional custom HTTP client for making network requests.
  final http.Client? httpClient;

  /// The internal low-level client for making HTTP API requests.
  late final ApiClient _apiClient;

  /// Provides access to the live, streaming services of the API.
  late final LiveService live;

  GoogleGenAI({
    required this.accessToken,
    required this.projectId,
    required this.location,
    this.baseUrl,
    this.httpClient,
    this.apiVersion = 'v1beta1',
  }) {
    _apiClient = ApiClient(
      accessToken: accessToken,
      projectId: projectId,
      location: location,
      baseUrl: baseUrl,
      apiVersion: apiVersion,
      httpClient: httpClient,
    );

    live = LiveService(
      accessToken: accessToken,
      projectId: projectId,
      location: location,
      baseUrl: baseUrl,
      apiVersion: apiVersion,
    );
  }

  /// Releases any resources held by the client.
  void close() {
    _apiClient.close();
  }
}
