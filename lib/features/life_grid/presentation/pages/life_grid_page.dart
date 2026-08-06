import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/cosmic_background.dart';
import '../../../countdown/providers/countdown_provider.dart';
import '../../../countdown/presentation/widgets/life_progress_bar.dart';
import '../../../countdown/presentation/widgets/life_seasons_widget.dart';
import '../widgets/weeks_grid_widget.dart';
import '../widgets/remaining_stats_widget.dart';
import '../widgets/remaining_moments_widget.dart';

class LifeGridPage extends ConsumerWidget {
  const LifeGridPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(lifeStatsProvider);

    if (stats == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.go('/home'),
                      icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
                    ),
                    Text('Жизнь в неделях', style: AppTypography.headingMedium),
                  ],
                ),
              ),
              // Grid
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      WeeksGridWidget(
                        totalWeeks: stats.totalWeeksInLife,
                        weeksLived: stats.weeksLived,
                      ),
                      const SizedBox(height: 20),
                      LifeProgressBar(stats: stats),
                      const SizedBox(height: 20),
                      LifeSeasonsWidget(stats: stats),
                      const SizedBox(height: 20),
                      RemainingMomentsWidget(stats: stats),
                      const SizedBox(height: 20),
                      RemainingStatsWidget(stats: stats),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
