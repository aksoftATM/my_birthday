import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../domain/life_calculator_service.dart';
import 'package:intl/intl.dart';

class TimeUnitsGrid extends StatelessWidget {
  final LifeStats stats;

  const TimeUnitsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final nf = NumberFormat('#,###', 'ru_RU');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ПРОЖИТО', style: AppTypography.labelLarge),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatTile(
                value: nf.format(stats.ageInDays),
                label: 'дней',
                color: AppColors.accentPurple,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _StatTile(
                value: nf.format(stats.ageInWeeks),
                label: 'недель',
                color: AppColors.accentIndigo,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _StatTile(
                value: '${(stats.percentOfYearPassed * 100).toStringAsFixed(1)}%',
                label: 'год',
                color: AppColors.accentPink,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatTile({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.headingMedium.copyWith(color: color),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppTypography.labelSmall),
        ],
      ),
    );
  }
}
