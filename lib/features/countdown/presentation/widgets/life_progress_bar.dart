import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../domain/life_calculator_service.dart';

class LifeProgressBar extends StatelessWidget {
  final LifeStats stats;

  const LifeProgressBar({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ПРОГРЕСС ЖИЗНИ', style: AppTypography.labelLarge),
              Text(
                '${(stats.lifeProgressPercent * 100).toStringAsFixed(1)}%',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.accentPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 10,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.borderSubtle,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: stats.lifeProgressPercent,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.progressGradient,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${stats.weeksLived} нед. прожито',
                style: AppTypography.labelSmall,
              ),
              Text(
                '${stats.weeksRemaining} нед. осталось',
                style: AppTypography.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
