import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Provides OAuth2 access tokens from Application Default Credentials (ADC).
///
/// In development, tokens are obtained by running the `gcloud` CLI.
/// The token is auto-refreshed every [refreshInterval] (default 45 minutes)
/// since ADC tokens expire after 1 hour.
///
/// For production on mobile devices, use [BackendTokenProvider] instead
/// (which fetches tokens from a secure proxy endpoint).
class AdcTokenProvider {
  /// How often to refresh the token (45 min < 1 hour expiry).
  static const Duration _defaultRefreshInterval = Duration(minutes: 45);

  final Duration refreshInterval;
  final String Function()? _tokenOverride;

  String? _cachedToken;
  Timer? _refreshTimer;
  DateTime? _lastFetch;
  bool _isDisposed = false;

  /// Creates an [AdcTokenProvider].
  ///
  /// If [tokenOverride] is provided, it's used directly (useful for testing
  /// or when a token is obtained externally). Otherwise, the `gcloud` CLI
  /// is used to fetch the token.
  AdcTokenProvider({
    this.refreshInterval = _defaultRefreshInterval,
    String Function()? tokenOverride,
  }) : _tokenOverride = tokenOverride;

  /// Returns the current access token, fetching a fresh one if needed.
  Future<String> getToken() async {
    if (_isDisposed) {
      throw StateError('AdcTokenProvider has been disposed');
    }

    // If a token override is provided, use it directly.
    if (_tokenOverride != null) {
      return _tokenOverride!();
    }

    // Return cached token if still fresh.
    if (_cachedToken != null && _lastFetch != null) {
      final elapsed = DateTime.now().difference(_lastFetch!);
      if (elapsed < refreshInterval) {
        return _cachedToken!;
      }
    }

    // Fetch a new token.
    await _fetchToken();
    return _cachedToken!;
  }

  /// Fetches a fresh token from `gcloud auth application-default print-access-token`.
  Future<void> _fetchToken() async {
    try {
      if (kIsWeb) {
        throw UnsupportedError(
          'AdcTokenProvider does not support web. '
          'Use a backend proxy for token exchange on web.',
        );
      }

      final result = await Process.run(
        'gcloud',
        ['auth', 'application-default', 'print-access-token'],
        runInShell: true,
      );

      if (result.exitCode != 0) {
        throw Exception(
          'Failed to fetch ADC token: ${result.stderr}',
        );
      }

      _cachedToken = (result.stdout as String).trim();
      _lastFetch = DateTime.now();
      debugPrint('[AdcTokenProvider] Token refreshed (${_cachedToken?.length ?? 0} chars)');
    } catch (e) {
      debugPrint('[AdcTokenProvider] Error fetching token: $e');
      rethrow;
    }
  }

  /// Starts the auto-refresh timer.
  ///
  /// Call this once when the app initializes. The timer will periodically
  /// refresh the token in the background.
  void startAutoRefresh() {
    if (_tokenOverride != null) return; // No refresh needed for overrides.
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(refreshInterval, (_) async {
      try {
        await _fetchToken();
      } catch (e) {
        debugPrint('[AdcTokenProvider] Auto-refresh failed: $e');
      }
    });
  }

  /// Stops the auto-refresh timer.
  void stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  /// Returns whether a token is currently cached.
  bool get hasToken => _cachedToken != null;

  /// Clears the cached token.
  void clearToken() {
    _cachedToken = null;
    _lastFetch = null;
  }

  /// Disposes the provider, stopping timers and clearing state.
  void dispose() {
    _isDisposed = true;
    stopAutoRefresh();
    _cachedToken = null;
    _lastFetch = null;
  }
}

/// Token provider that fetches tokens from a backend proxy endpoint.
///
/// Suitable for production use on mobile devices where `gcloud` CLI is
/// not available. The backend should use its own ADC to generate short-lived
/// tokens and return them as JSON: `{"accessToken": "..."}`.
class BackendTokenProvider {
  final String tokenEndpoint;
  final Map<String, String> Function()? headersProvider;
  static const Duration _defaultRefreshInterval = Duration(minutes: 30);

  final Duration refreshInterval;
  final http.Client _client;

  String? _cachedToken;
  Timer? _refreshTimer;
  DateTime? _lastFetch;
  bool _isDisposed = false;

  BackendTokenProvider({
    required this.tokenEndpoint,
    this.headersProvider,
    this.refreshInterval = _defaultRefreshInterval,
    http.Client? httpClient,
  }) : _client = httpClient ?? http.Client();

  /// Returns the current access token, fetching a fresh one if needed.
  Future<String> getToken() async {
    if (_isDisposed) {
      throw StateError('BackendTokenProvider has been disposed');
    }

    if (_cachedToken != null && _lastFetch != null) {
      final elapsed = DateTime.now().difference(_lastFetch!);
      if (elapsed < refreshInterval) {
        return _cachedToken!;
      }
    }

    await _fetchToken();
    return _cachedToken!;
  }

  Future<void> _fetchToken() async {
    try {
      final headers = <String, String>{
        'Content-Type': 'application/json',
        ...?headersProvider?.call(),
      };

      final response = await _client
          .get(Uri.parse(tokenEndpoint), headers: headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception(
          'Token endpoint returned ${response.statusCode}: ${response.body}',
        );
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      _cachedToken = body['accessToken'] as String?;
      if (_cachedToken == null) {
        throw Exception('Token endpoint returned no accessToken field');
      }
      _lastFetch = DateTime.now();
      debugPrint('[BackendTokenProvider] Token refreshed');
    } catch (e) {
      debugPrint('[BackendTokenProvider] Error fetching token: $e');
      rethrow;
    }
  }

  void startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(refreshInterval, (_) async {
      try {
        await _fetchToken();
      } catch (e) {
        debugPrint('[BackendTokenProvider] Auto-refresh failed: $e');
      }
    });
  }

  void stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  bool get hasToken => _cachedToken != null;

  void dispose() {
    _isDisposed = true;
    stopAutoRefresh();
    _cachedToken = null;
    _lastFetch = null;
    _client.close();
  }
}
