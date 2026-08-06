import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/notifications/notification_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../features/onboarding/providers/onboarding_provider.dart';
import '../../features/wishlist/providers/wishlist_providers.dart';
import '../data/user_profile_repository.dart';

/// Диалог подтверждения + сам выход из профиля, чтобы можно было
/// завести другого человека. Используется и в меню на главном экране,
/// и на экране «О приложении».
Future<void> confirmLogout(BuildContext context, WidgetRef ref) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF1a1a2e),
      title: Text('Сменить пользователя?', style: AppTypography.headingMedium),
      content: Text(
        'Текущий профиль и вишлист будут удалены с устройства, '
        'чтобы можно было ввести данные другого человека.',
        style: AppTypography.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('Отмена', style: AppTypography.bodyLarge),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            'Выйти',
            style: AppTypography.bodyLarge.copyWith(color: AppColors.accentPink),
          ),
        ),
      ],
    ),
  );

  if (confirmed != true || !context.mounted) return;

  await ref.read(wishlistProvider.notifier).clear();
  await NotificationService.cancelAll();
  ref.read(onboardingProvider.notifier).reset();
  await ref.read(userProfileProvider.notifier).logout();

  if (context.mounted) {
    context.go('/onboarding');
  }
}
