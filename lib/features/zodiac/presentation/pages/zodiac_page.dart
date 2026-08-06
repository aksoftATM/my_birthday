import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/data/user_profile_repository.dart';
import '../../../../shared/widgets/cosmic_background.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../domain/zodiac_service.dart';

class ZodiacPage extends ConsumerWidget {
  const ZodiacPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final zodiac = ZodiacService().getInfo(profile.birthDate);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.go('/home'),
                        icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
                      ),
                      Text('Знак зодиака', style: AppTypography.headingMedium),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Zodiac symbol
                GlassCard(
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  child: Column(
                    children: [
                      Text(
                        zodiac.sign.symbol,
                        style: const TextStyle(fontSize: 72),
                      ),
                      const SizedBox(height: 12),
                      GradientText(
                        zodiac.sign.nameRu,
                        style: AppTypography.displayMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        zodiac.sign.name,
                        style: AppTypography.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.accentPurple.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${zodiac.sign.elementRu} • ${zodiac.sign.element}',
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.accentPurple,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        zodiac.sign.description,
                        style: AppTypography.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Famous people
                if (zodiac.sameDayFamous.isNotEmpty) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ЗНАМЕНИТОСТИ С ТВОИМ ДНЁМ РОЖДЕНИЯ',
                        style: AppTypography.labelLarge,
                      ),
                      const SizedBox(height: 12),
                      ...zodiac.sameDayFamous.map((person) => GlassCard(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.ctaGradient,
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  child: Center(
                                    child: Text(
                                      person.name[0],
                                      style: AppTypography.headingMedium.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(person.name, style: AppTypography.bodyLarge),
                                      Text(
                                        '${person.title} • ${person.birthYear}',
                                        style: AppTypography.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ] else
                  GlassCard(
                    child: Text(
                      'Пока нет данных о знаменитостях с таким днём рождения',
                      style: AppTypography.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
