import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../countdown/domain/life_calculator_service.dart';

class RemainingMomentsWidget extends StatelessWidget {
  final LifeStats stats;

  const RemainingMomentsWidget({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ОСТАВШИЕСЯ МОМЕНТЫ', style: AppTypography.labelLarge),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MomentCard(
                icon: '🌅',
                value: '${stats.saturdaysRemaining}',
                label: 'суббот',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MomentCard(
                icon: '☀️',
                value: '${stats.summerEveningsRemaining}',
                label: 'летних вечеров',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _MomentCard(
                icon: '🎆',
                value: '${stats.newYearsRemaining}',
                label: 'новых годов',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MomentCard(
                icon: '⏱️',
                value: _formatLargeNumber(stats.secondsOfLifeRemaining),
                label: 'секунд жизни',
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatLargeNumber(int n) {
    if (n >= 1000000000) return '${(n / 1000000000).toStringAsFixed(1)}B';
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(0)}K';
    return '$n';
  }
}

class _MomentCard extends StatelessWidget {
  final String icon;
  final String value;
  final String label;

  const _MomentCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 8),
          Text(value, style: AppTypography.headingMedium),
          const SizedBox(height: 2),
          Text(label, style: AppTypography.labelSmall),
        ],
      ),
    );
  }
}
