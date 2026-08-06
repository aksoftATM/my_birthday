import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/notifications/notification_service.dart';
import '../../../../shared/data/user_profile_repository.dart';
import '../../../../shared/widgets/cosmic_background.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../providers/onboarding_provider.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: switch (state.currentStep) {
                0 => _NameStep(key: const ValueKey(0)),
                1 => _BirthdayStep(key: const ValueKey(1)),
                _ => _LifeExpectancyStep(key: const ValueKey(2)),
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _NameStep extends ConsumerStatefulWidget {
  const _NameStep({super.key});

  @override
  ConsumerState<_NameStep> createState() => _NameStepState();
}

class _NameStepState extends ConsumerState<_NameStep> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GradientText('Привет!', style: AppTypography.displayMedium),
        const SizedBox(height: 12),
        Text(
          'Как тебя зовут?',
          style: AppTypography.bodyLarge,
        ),
        const SizedBox(height: 32),
        TextField(
          controller: _controller,
          style: AppTypography.headingMedium,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: 'Имя (необязательно)',
            hintStyle: AppTypography.bodyMedium,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.borderSubtle),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.borderSubtle),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.accentPurple),
            ),
            filled: true,
            fillColor: AppColors.backgroundCard,
          ),
        ),
        const SizedBox(height: 40),
        _CTAButton(
          label: 'Продолжить',
          onPressed: () {
            final name = _controller.text.trim();
            ref.read(onboardingProvider.notifier).setName(
                  name.isEmpty ? null : name,
                );
            ref.read(onboardingProvider.notifier).nextStep();
          },
        ),
      ],
    );
  }
}

class _BirthdayStep extends ConsumerStatefulWidget {
  const _BirthdayStep({super.key});

  @override
  ConsumerState<_BirthdayStep> createState() => _BirthdayStepState();
}

class _BirthdayStepState extends ConsumerState<_BirthdayStep> {
  DateTime _selected = DateTime(2000, 1, 1);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GradientText('Дата рождения', style: AppTypography.headingLarge),
        const SizedBox(height: 8),
        Text(
          'Когда ты появился на свет?',
          style: AppTypography.bodyMedium,
        ),
        const SizedBox(height: 24),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: DateTime(2000, 1, 1),
            minimumDate: DateTime(1920),
            maximumDate: DateTime.now(),
            onDateTimeChanged: (date) => _selected = date,
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () =>
                  ref.read(onboardingProvider.notifier).prevStep(),
              child: Text('Назад', style: AppTypography.bodyLarge),
            ),
            const SizedBox(width: 16),
            _CTAButton(
              label: 'Продолжить',
              onPressed: () {
                ref.read(onboardingProvider.notifier).setBirthDate(_selected);
                ref.read(onboardingProvider.notifier).nextStep();
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _LifeExpectancyStep extends ConsumerStatefulWidget {
  const _LifeExpectancyStep({super.key});

  @override
  ConsumerState<_LifeExpectancyStep> createState() =>
      _LifeExpectancyStepState();
}

class _LifeExpectancyStepState extends ConsumerState<_LifeExpectancyStep> {
  double _years = 80;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GradientText('Ожидаемый возраст', style: AppTypography.headingLarge),
        const SizedBox(height: 8),
        Text(
          'До скольки лет ты хочешь дожить?',
          style: AppTypography.bodyMedium,
        ),
        const SizedBox(height: 32),
        GradientText(
          '${_years.round()}',
          style: AppTypography.displayLarge,
        ),
        const SizedBox(height: 8),
        Text('лет', style: AppTypography.labelLarge),
        const SizedBox(height: 24),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.accentPurple,
            inactiveTrackColor: AppColors.borderSubtle,
            thumbColor: AppColors.accentPurple,
          ),
          child: Slider(
            value: _years,
            min: 50,
            max: 120,
            divisions: 70,
            onChanged: (v) => setState(() => _years = v),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () =>
                  ref.read(onboardingProvider.notifier).prevStep(),
              child: Text('Назад', style: AppTypography.bodyLarge),
            ),
            const SizedBox(width: 16),
            _CTAButton(
              label: 'Начать',
              onPressed: () => _complete(context, ref),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _complete(BuildContext context, WidgetRef ref) async {
    final state = ref.read(onboardingProvider);
    final profile = UserProfile(
      name: state.name,
      birthDate: state.birthDate!,
      lifeExpectancyYears: _years.round(),
      onboardingCompleted: true,
    );
    await ref.read(userProfileProvider.notifier).saveProfile(profile);

    // Планируем уведомления
    await NotificationService.requestPermissions();
    await NotificationService.scheduleBirthdayMilestones(profile.birthDate);

    if (context.mounted) {
      context.go('/home');
    }
  }
}

class _CTAButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _CTAButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.ctaGradient,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          label,
          style: AppTypography.bodyLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
