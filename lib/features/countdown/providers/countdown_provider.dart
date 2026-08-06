import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/data/user_profile_repository.dart';
import '../domain/life_calculator_service.dart';

final lifeStatsProvider = StateNotifierProvider<LifeStatsNotifier, LifeStats?>((ref) {
  final profile = ref.watch(userProfileProvider);
  return LifeStatsNotifier(profile);
});

class LifeStatsNotifier extends StateNotifier<LifeStats?> {
  Timer? _timer;
  final UserProfile? _profile;

  LifeStatsNotifier(this._profile) : super(null) {
    if (_profile != null) {
      _recalculate();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _recalculate());
    }
  }

  void _recalculate() {
    if (_profile == null) return;
    final calc = LifeCalculatorService(
      birthDate: _profile.birthDate,
      lifeExpectancyYears: _profile.lifeExpectancyYears,
    );
    state = calc.calculate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
