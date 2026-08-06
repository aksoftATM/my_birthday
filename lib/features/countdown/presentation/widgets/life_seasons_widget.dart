import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../domain/life_calculator_service.dart';

class LifeSeasonsWidget extends StatelessWidget {
  final LifeStats stats;

  const LifeSeasonsWidget({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('СЕЗОН ЖИЗНИ', style: AppTypography.labelLarge),
          const SizedBox(height: 16),
          Row(
            children: [
              _SeasonIndicator(
                label: 'Весна',
                icon: '🌱',
                color: AppColors.springColor,
                isActive: stats.lifeSeason == LifeSeason.spring,
                range: '0–25%',
              ),
              _SeasonIndicator(
                label: 'Лето',
                icon: '☀️',
                color: AppColors.summerColor,
                isActive: stats.lifeSeason == LifeSeason.summer,
                range: '25–50%',
              ),
              _SeasonIndicator(
                label: 'Осень',
                icon: '🍂',
                color: AppColors.autumnColor,
                isActive: stats.lifeSeason == LifeSeason.autumn,
                range: '50–75%',
              ),
              _SeasonIndicator(
                label: 'Зима',
                icon: '❄️',
                color: AppColors.winterColor,
                isActive: stats.lifeSeason == LifeSeason.winter,
                range: '75–100%',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SeasonIndicator extends StatelessWidget {
  final String label;
  final String icon;
  final Color color;
  final bool isActive;
  final String range;

  const _SeasonIndicator({
    required this.label,
    required this.icon,
    required this.color,
    required this.isActive,
    required this.range,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: isActive ? color.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isActive
              ? Border.all(color: color.withValues(alpha: 0.4))
              : null,
        ),
        child: Column(
          children: [
            Text(icon, style: TextStyle(fontSize: isActive ? 24 : 18)),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: isActive ? color : AppColors.textTertiary,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
            Text(
              range,
              style: AppTypography.labelSmall.copyWith(fontSize: 8),
            ),
          ],
        ),
      ),
    );
  }
}
