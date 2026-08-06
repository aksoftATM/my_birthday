import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/cosmic_background.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../data/repositories/wishlist_repository.dart';

class WishlistPage extends ConsumerWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishes = ref.watch(wishlistProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.go('/home'),
                      icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
                    ),
                    Text('Вишлист', style: AppTypography.headingMedium),
                    const Spacer(),
                    IconButton(
                      onPressed: () => _showAddDialog(context, ref),
                      icon: const Icon(Icons.add_circle_outline, color: AppColors.accentPurple),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: wishes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('🎁', style: TextStyle(fontSize: 48)),
                            const SizedBox(height: 12),
                            Text(
                              'Вишлист пуст',
                              style: AppTypography.headingMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Добавь подарки, о которых мечтаешь',
                              style: AppTypography.bodyMedium,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: wishes.length,
                        itemBuilder: (context, index) {
                          final wish = wishes[index];
                          return Dismissible(
                            key: Key(wish.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(Icons.delete, color: AppColors.accentPink),
                            ),
                            onDismissed: (_) {
                              ref.read(wishlistProvider.notifier).delete(wish.id);
                            },
                            child: GlassCard(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => ref
                                        .read(wishlistProvider.notifier)
                                        .togglePurchased(wish.id),
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: wish.isPurchased
                                              ? AppColors.accentPurple
                                              : AppColors.borderSubtle,
                                          width: 2,
                                        ),
                                        color: wish.isPurchased
                                            ? AppColors.accentPurple
                                            : Colors.transparent,
                                      ),
                                      child: wish.isPurchased
                                          ? const Icon(Icons.check, color: Colors.white, size: 16)
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          wish.title,
                                          style: AppTypography.bodyLarge.copyWith(
                                            decoration: wish.isPurchased
                                                ? TextDecoration.lineThrough
                                                : null,
                                          ),
                                        ),
                                        if (wish.url != null)
                                          Text(
                                            wish.url!,
                                            style: AppTypography.labelSmall.copyWith(
                                              color: AppColors.accentIndigo,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Новое желание', style: AppTypography.headingMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              style: AppTypography.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Название',
                hintStyle: AppTypography.bodyMedium,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.borderSubtle),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.accentPurple),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: urlController,
              style: AppTypography.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Ссылка (необязательно)',
                hintStyle: AppTypography.bodyMedium,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.borderSubtle),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.accentPurple),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена', style: AppTypography.bodyLarge),
          ),
          TextButton(
            onPressed: () {
              final title = titleController.text.trim();
              if (title.isNotEmpty) {
                final url = urlController.text.trim();
                ref.read(wishlistProvider.notifier).add(
                      title,
                      url: url.isEmpty ? null : url,
                    );
                Navigator.pop(context);
              }
            },
            child: Text(
              'Добавить',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.accentPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
