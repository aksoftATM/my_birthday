import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingState {
  final String? name;
  final DateTime? birthDate;
  final int lifeExpectancy;
  final int currentStep; // 0, 1, 2

  const OnboardingState({
    this.name,
    this.birthDate,
    this.lifeExpectancy = 80,
    this.currentStep = 0,
  });

  OnboardingState copyWith({
    String? name,
    DateTime? birthDate,
    int? lifeExpectancy,
    int? currentStep,
  }) {
    return OnboardingState(
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      lifeExpectancy: lifeExpectancy ?? this.lifeExpectancy,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier();
});

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(const OnboardingState());

  void setName(String? name) => state = state.copyWith(name: name);

  void setBirthDate(DateTime date) => state = state.copyWith(birthDate: date);

  void setLifeExpectancy(int years) =>
      state = state.copyWith(lifeExpectancy: years);

  void nextStep() => state = state.copyWith(currentStep: state.currentStep + 1);

  void prevStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  /// Сброс формы онбординга, например перед вводом данных другого человека.
  void reset() => state = const OnboardingState();
}
