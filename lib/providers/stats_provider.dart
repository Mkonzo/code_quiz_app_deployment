import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_stats.dart';
import '../services/storage_service.dart';

final storageServiceProvider = Provider((ref) => StorageService());

final statsProvider = FutureProvider<UserStats>((ref) async {
  final storageService = ref.watch(storageServiceProvider);
  return await storageService.loadStats();
});

final statsNotifierProvider = NotifierProvider<StatsNotifier, UserStats>(
  StatsNotifier.new,
);

class StatsNotifier extends Notifier<UserStats> {
  @override
  UserStats build() {
    _loadStats();
    return UserStats();
  }

  Future<void> _loadStats() async {
    try {
      final storageService = ref.read(storageServiceProvider);
      final stats = await storageService.loadStats();
      state = stats;
    } catch (e) {
      // Handle error
    }
  }

  Future<void> refreshStats() async {
    await _loadStats();
  }
}