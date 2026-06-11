import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/live_api_service.dart';

final liveApiServiceProvider = Provider<LiveApiService>((ref) {
  final service = LiveApiService();
  ref.onDispose(() => service.dispose());
  return service;
});
