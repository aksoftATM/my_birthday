import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_links.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/utils/logout_flow.dart';

class AboutPage extends ConsumerStatefulWidget {
  const AboutPage({super.key});

  @override
  ConsumerState<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends ConsumerState<AboutPage> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() => _version = '${info.version} (${info.buildNumber})');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.go('/home'),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                  ),
                  Text('О приложении', style: AppTypography.headingMedium),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                children: [
                  Text('BirthDay OS', style: AppTypography.headingMedium),
                  const SizedBox(height: 4),
                  Text(
                    _version.isEmpty ? 'Версия…' : 'Версия $_version',
                    style: AppTypography.bodyMedium,
                  ),
                  const SizedBox(height: 28),
                  Text('ДАННЫЕ', style: AppTypography.labelLarge),
                  const SizedBox(height: 10),
                  Text(
                    'Имя, дата рождения и вишлист хранятся только на этом '
                    'устройстве. Приложение не отправляет данные на сервер '
                    'и не собирает аналитику.',
                    style: AppTypography.bodyMedium,
                  ),
                  const SizedBox(height: 28),
                  _GroupedList(
                    children: [
                      _AboutRow(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Политика конфиденциальности',
                        onTap: () => _openPrivacyPolicy(context),
                      ),
                      _AboutRow(
                        icon: Icons.logout,
                        title: 'Сменить пользователя',
                        titleColor: AppColors.accentPink,
                        showDivider: false,
                        onTap: () => confirmLogout(context, ref),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openPrivacyPolicy(BuildContext context) async {
    final uri = Uri.parse(AppLinks.privacyPolicyUrl);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось открыть ссылку')),
      );
    }
  }
}

/// Сгруппированный список в духе нативных настроек iOS: тонкая обводка,
/// без «стеклянных» карточек и фона со звёздами.
class _GroupedList extends StatelessWidget {
  final List<Widget> children;

  const _GroupedList({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _AboutRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? titleColor;
  final bool showDivider;
  final VoidCallback onTap;

  const _AboutRow({
    required this.icon,
    required this.title,
    this.titleColor,
    this.showDivider = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, size: 18, color: titleColor ?? AppColors.accentPurple),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.bodyLarge.copyWith(color: titleColor),
                  ),
                ),
                const Icon(Icons.chevron_right, size: 18, color: AppColors.textTertiary),
              ],
            ),
          ),
          if (showDivider)
            const Divider(height: 1, color: AppColors.borderSubtle, indent: 16),
        ],
      ),
    );
  }
}
