import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/data/user_profile_repository.dart';
import '../../../../shared/widgets/cosmic_background.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../countdown/providers/countdown_provider.dart';

class BirthdayPage extends ConsumerStatefulWidget {
  const BirthdayPage({super.key});

  @override
  ConsumerState<BirthdayPage> createState() => _BirthdayPageState();
}

class _BirthdayPageState extends ConsumerState<BirthdayPage> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 10),
    );
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);
    final stats = ref.watch(lifeStatsProvider);

    return Scaffold(
      body: CosmicBackground(
        child: Stack(
          children: [
            // Confetti
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                maxBlastForce: 30,
                minBlastForce: 10,
                numberOfParticles: 30,
                gravity: 0.1,
                colors: const [
                  AppColors.accentPurple,
                  AppColors.accentIndigo,
                  AppColors.accentPink,
                  Color(0xFFFBBF24),
                  Color(0xFF34D399),
                ],
              ),
            ),
            // Content
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🎂', style: TextStyle(fontSize: 72)),
                      const SizedBox(height: 24),
                      GradientText(
                        'С днём рождения!',
                        style: AppTypography.displayMedium,
                        textAlign: TextAlign.center,
                      ),
                      if (profile?.name != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          profile!.name!,
                          style: AppTypography.headingLarge.copyWith(
                            color: AppColors.accentPurple,
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      if (stats != null) ...[
                        Text(
                          'Тебе исполнилось',
                          style: AppTypography.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        GradientText(
                          '${stats.ageYears}',
                          style: AppTypography.displayLarge,
                        ),
                        Text(
                          _yearsWord(stats.ageYears),
                          style: AppTypography.headingMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                      const SizedBox(height: 40),
                      // Button to go to main screen
                      GestureDetector(
                        onTap: () => context.go('/home'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 40,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.ctaGradient,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            'Открыть подарок 🎁',
                            style: AppTypography.bodyLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _yearsWord(int n) {
    final mod10 = n % 10;
    final mod100 = n % 100;
    if (mod100 >= 11 && mod100 <= 14) return 'лет';
    if (mod10 == 1) return 'год';
    if (mod10 >= 2 && mod10 <= 4) return 'года';
    return 'лет';
  }
}
