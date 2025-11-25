import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/stats_service.dart';

final statsServiceProvider = Provider<StatsService>((ref) {
  return StatsService();
});

final statsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final service = ref.watch(statsServiceProvider);
  return await service.getOverview();
});