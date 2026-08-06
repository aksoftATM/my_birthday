import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_extensions.dart';
import '../../../../shared/data/user_profile_repository.dart';
import '../../../../shared/widgets/cosmic_background.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../domain/life_calculator_service.dart';
import '../../providers/countdown_provider.dart';

/// Главный экран в формате вертикальной ленты историй (как в TikTok):
/// свайп вверх/вниз между тремя карточками — до ДР, прожито, осталось жить.
class CountdownPage extends ConsumerStatefulWidget {
  const CountdownPage({super.key});

  @override
  ConsumerState<CountdownPage> createState() => _CountdownPageState();
}

class _CountdownPageState extends ConsumerState<CountdownPage> {
  final _pageController = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(lifeStatsProvider);
    final profile = ref.watch(userProfileProvider);

    if (stats == null || profile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (stats.isBirthdayToday) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go('/birthday');
      });
    }

    return Scaffold(
      body: CosmicBackground(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              onPageChanged: (i) => setState(() => _page = i),
              children: [
                _CountdownStoryCard(stats: stats),
                _LivedStoryCard(stats: stats, profile: profile),
                _RemainingStoryCard(stats: stats),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _NavMenu(
                    onLifeGrid: () => context.go('/life-grid'),
                    onZodiac: () => context.go('/zodiac'),
                    onWishlist: () => context.go('/wishlist'),
                    onAbout: () => context.go('/about'),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              right: 10,
              child: Center(child: _PageDots(count: 3, current: _page)),
            ),
          ],
        ),
      ),
    );
  }
}

// MARK: - Story cards

const _pageGradients = [
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF060610), Color(0xFF1C0F2B)],
  ),
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF050A14), Color(0xFF0E1730)],
  ),
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F0714), Color(0xFF2A0C1E)],
  ),
];

class _StoryCard extends StatelessWidget {
  final Widget child;
  final Gradient gradient;

  const _StoryCard({required this.child, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 72, 16, 36),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: const Color(0x1FFFFFFF)),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CountdownStoryCard extends StatelessWidget {
  final LifeStats stats;

  const _CountdownStoryCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    return _StoryCard(
      gradient: _pageGradients[0],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Eyebrow(icon: CupertinoIcons.gift, text: 'ДО ДНЯ РОЖДЕНИЯ', color: AppColors.accentPurple),
          const SizedBox(height: 20),
          GradientText(
            '${stats.daysUntilBirthday}',
            style: AppTypography.displayLarge.copyWith(fontSize: 104),
          ),
          Text(
            _daysWord(stats.daysUntilBirthday),
            style: AppTypography.headingLarge.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _BigTimeUnit(value: stats.hoursUntilBirthday % 24, label: 'часов'),
              const SizedBox(width: 22),
              _BigTimeUnit(value: stats.minutesUntilBirthday % 60, label: 'минут'),
              const SizedBox(width: 22),
              _BigTimeUnit(value: stats.secondsUntilBirthday % 60, label: 'секунд'),
            ],
          ),
          const SizedBox(height: 44),
          const _SwipeHint(),
        ],
      ),
    );
  }

  String _daysWord(int n) {
    final mod10 = n % 10;
    final mod100 = n % 100;
    if (mod100 >= 11 && mod100 <= 14) return 'дней';
    if (mod10 == 1) return 'день';
    if (mod10 >= 2 && mod10 <= 4) return 'дня';
    return 'дней';
  }
}

class _LivedStoryCard extends StatelessWidget {
  final LifeStats stats;
  final UserProfile profile;

  const _LivedStoryCard({required this.stats, required this.profile});

  @override
  Widget build(BuildContext context) {
    final nf = NumberFormat('#,###', 'ru_RU');
    return _StoryCard(
      gradient: _pageGradients[1],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Eyebrow(icon: CupertinoIcons.sparkles, text: 'ПРОЖИТО', color: AppColors.accentIndigo),
          const SizedBox(height: 16),
          Text(
            profile.name != null ? '${profile.name}, тебе' : 'Тебе',
            style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
          ),
          GradientText(
            '${stats.ageYears}',
            style: AppTypography.displayLarge.copyWith(fontSize: 104),
            gradient: const LinearGradient(
              colors: [AppColors.accentIndigo, AppColors.accentPurple],
            ),
          ),
          Text('лет', style: AppTypography.headingLarge.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 36),
          Row(
            children: [
              Expanded(
                child: _StatPill(
                  value: nf.format(stats.ageInDays),
                  label: 'дней прожито',
                  color: AppColors.accentIndigo,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatPill(
                  value: nf.format(stats.minutesLived),
                  label: 'минут прожито',
                  color: AppColors.accentPink,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RemainingStoryCard extends StatelessWidget {
  final LifeStats stats;

  const _RemainingStoryCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    final nf = NumberFormat('#,###', 'ru_RU');
    return _StoryCard(
      gradient: _pageGradients[2],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Eyebrow(icon: CupertinoIcons.hourglass, text: 'ОСТАЛОСЬ ЖИТЬ', color: AppColors.accentPink),
          const SizedBox(height: 16),
          GradientText(
            '${stats.yearsRemaining}',
            style: AppTypography.displayLarge.copyWith(fontSize: 104),
            gradient: const LinearGradient(
              colors: [AppColors.accentPink, AppColors.accentPurple],
            ),
          ),
          Text('лет', style: AppTypography.headingLarge.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 36),
          Row(
            children: [
              Expanded(
                child: _StatPill(
                  value: nf.format(stats.daysRemaining),
                  label: 'дней осталось',
                  color: AppColors.accentPurple,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatPill(
                  value: nf.format(stats.minutesRemaining),
                  label: 'минут осталось',
                  color: AppColors.accentIndigo,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '≈ ${stats.deathDate.formattedRu}',
            style: AppTypography.labelSmall,
          ),
        ],
      ),
    );
  }
}

// MARK: - Shared pieces

class _Eyebrow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _Eyebrow({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 6),
        Text(text, style: AppTypography.labelLarge.copyWith(color: color)),
      ],
    );
  }
}

class _BigTimeUnit extends StatelessWidget {
  final int value;
  final String label;

  const _BigTimeUnit({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString().padLeft(2, '0'),
          style: AppTypography.displayMedium.copyWith(fontSize: 32),
        ),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.labelSmall),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatPill({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0x14FFFFFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x1FFFFFFF)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.headingMedium.copyWith(color: color, fontSize: 21),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(label, style: AppTypography.labelSmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _SwipeHint extends StatelessWidget {
  const _SwipeHint();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(CupertinoIcons.chevron_up, size: 16, color: AppColors.textTertiary)
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .moveY(begin: 0, end: -6, duration: 700.ms, curve: Curves.easeInOut),
        const SizedBox(height: 4),
        Text('Смахни вверх', style: AppTypography.labelSmall),
      ],
    );
  }
}

/// Вертикальные точки-индикатор страниц — справа по центру, как скроллбар.
class _PageDots extends StatelessWidget {
  final int count;
  final int current;

  const _PageDots({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(vertical: 4),
          width: 4,
          height: active ? 20 : 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: active ? AppColors.accentPurple : AppColors.borderSubtle,
          ),
        );
      }),
    );
  }
}

// MARK: - Nav menu

class _NavMenu extends StatelessWidget {
  final VoidCallback onLifeGrid;
  final VoidCallback onZodiac;
  final VoidCallback onWishlist;
  final VoidCallback onAbout;

  const _NavMenu({
    required this.onLifeGrid,
    required this.onZodiac,
    required this.onWishlist,
    required this.onAbout,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.menu, color: AppColors.textPrimary),
      color: const Color(0xFF1a1a2e),
      onSelected: (value) {
        switch (value) {
          case 'grid':
            onLifeGrid();
          case 'zodiac':
            onZodiac();
          case 'wishlist':
            onWishlist();
          case 'about':
            onAbout();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'grid',
          child: Row(
            children: [
              const Icon(Icons.grid_on, size: 18, color: AppColors.accentPurple),
              const SizedBox(width: 8),
              Text('Жизнь в неделях', style: AppTypography.bodyLarge),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'zodiac',
          child: Row(
            children: [
              const Icon(Icons.star, size: 18, color: AppColors.accentIndigo),
              const SizedBox(width: 8),
              Text('Знак зодиака', style: AppTypography.bodyLarge),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'wishlist',
          child: Row(
            children: [
              const Icon(Icons.card_giftcard, size: 18, color: AppColors.accentPink),
              const SizedBox(width: 8),
              Text('Вишлист', style: AppTypography.bodyLarge),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'about',
          child: Row(
            children: [
              const Icon(Icons.info_outline, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text('О приложении', style: AppTypography.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }
}
