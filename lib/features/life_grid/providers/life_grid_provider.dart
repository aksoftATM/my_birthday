import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../countdown/providers/countdown_provider.dart';
import '../../countdown/domain/life_calculator_service.dart';

// Реэкспорт — life grid использует те же LifeStats из countdown
final lifeGridStatsProvider = Provider<LifeStats?>((ref) {
  return ref.watch(lifeStatsProvider);
});
