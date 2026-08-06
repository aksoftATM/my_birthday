import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_extensions.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../countdown/domain/life_calculator_service.dart';

class RemainingStatsWidget extends StatelessWidget {
  final LifeStats stats;

  const RemainingStatsWidget({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final nf = NumberFormat('#,###', 'ru_RU');
    final percentRemaining = (1 - stats.lifeProgressPercent) * 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ОСТАЛОСЬ ЖИТЬ', style: AppTypography.labelLarge),
        const SizedBox(height: 12),

        // Точная разбивка: годы / месяцы / недели / дни
        GlassCard(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _BreakdownUnit(
                      value: stats.remainingYearsPart,
                      label: _pluralRu(stats.remainingYearsPart, 'год', 'года', 'лет'),
                      color: AppColors.accentPurple,
                    ),
                  ),
                  _UnitDivider(),
                  Expanded(
                    child: _BreakdownUnit(
                      value: stats.remainingMonthsPart,
                      label: _pluralRu(stats.remainingMonthsPart, 'месяц', 'месяца', 'месяцев'),
                      color: AppColors.accentIndigo,
                    ),
                  ),
                  _UnitDivider(),
                  Expanded(
                    child: _BreakdownUnit(
                      value: stats.remainingWeeksPart,
                      label: _pluralRu(stats.remainingWeeksPart, 'неделя', 'недели', 'недель'),
                      color: AppColors.accentPink,
                    ),
                  ),
                  _UnitDivider(),
                  Expanded(
                    child: _BreakdownUnit(
                      value: stats.remainingDaysPart,
                      label: _pluralRu(stats.remainingDaysPart, 'день', 'дня', 'дней'),
                      color: AppColors.accentPurple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(height: 1, color: AppColors.borderSubtle),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.flag_outlined, size: 14, color: AppColors.textTertiary),
                      const SizedBox(width: 6),
                      Text(
                        '≈ ${stats.deathDate.formattedRu} · на ${stats.lifeExpectancyYears} лет',
                        style: AppTypography.labelSmall,
                      ),
                    ],
                  ),
                  Text(
                    '${percentRemaining.toStringAsFixed(1)}% впереди',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.accentPurple,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Text('В ЦИФРАХ', style: AppTypography.labelLarge),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Дней осталось',
                value: nf.format(stats.daysRemaining),
                color: AppColors.accentPurple,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _StatCard(
                label: 'Недель осталось',
                value: nf.format(stats.weeksRemaining),
                color: AppColors.accentIndigo,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Недель прожито',
                value: nf.format(stats.weeksLived),
                color: AppColors.accentPink,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _StatCard(
                label: 'Лет осталось',
                value: '${stats.yearsRemaining}',
                color: AppColors.accentPurple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _pluralRu(int n, String one, String few, String many) {
    final mod10 = n % 10;
    final mod100 = n % 100;
    if (mod100 >= 11 && mod100 <= 14) return many;
    if (mod10 == 1) return one;
    if (mod10 >= 2 && mod10 <= 4) return few;
    return many;
  }
}

class _BreakdownUnit extends StatelessWidget {
  final int value;
  final String label;
  final Color color;

  const _BreakdownUnit({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: AppTypography.displayMedium.copyWith(color: color, fontSize: 34),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTypography.labelSmall,
        ),
      ],
    );
  }
}

class _UnitDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: AppColors.borderSubtle,
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppTypography.headingLarge.copyWith(color: color)),
          const SizedBox(height: 4),
          Text(label, style: AppTypography.labelSmall),
        ],
      ),
    );
  }
}
