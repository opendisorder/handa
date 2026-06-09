import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/remote/gemini_api_client.dart';

/// Gemini API client singleton.
final geminiApiClientProvider = Provider<GeminiApiClient>((ref) {
  final client = GeminiApiClient();
  ref.onDispose(() => client.dispose());
  return client;
});

/// Provider for Gemini health check status.
final geminiHealthProvider = FutureProvider<bool>((ref) async {
  final client = ref.watch(geminiApiClientProvider);
  return client.healthCheck();
});

/// Slow notification provider for Gemini model info.
///
/// Tells the user which model is being used (shown in debug/settings).
final geminiModelInfoProvider = Provider<String>((ref) {
  return 'Gemini 2.5 Flash';
});
