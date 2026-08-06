import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/data/user_profile_repository.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/countdown/presentation/pages/countdown_page.dart';
import '../../features/life_grid/presentation/pages/life_grid_page.dart';
import '../../features/zodiac/presentation/pages/zodiac_page.dart';
import '../../features/wishlist/presentation/pages/wishlist_page.dart';
import '../../features/birthday/presentation/pages/birthday_page.dart';
import '../../features/settings/presentation/pages/about_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final profile = ref.watch(userProfileProvider);

  return GoRouter(
    initialLocation: profile?.onboardingCompleted == true ? '/home' : '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) => const MaterialPage(
          child: OnboardingPage(),
        ),
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const CountdownPage(),
          transitionsBuilder: (context, animation, _, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/life-grid',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const LifeGridPage(),
          transitionsBuilder: (context, animation, _, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/zodiac',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const ZodiacPage(),
          transitionsBuilder: (context, animation, _, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/wishlist',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const WishlistPage(),
          transitionsBuilder: (context, animation, _, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/birthday',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const BirthdayPage(),
          transitionsBuilder: (context, animation, _, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/about',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const AboutPage(),
          transitionsBuilder: (context, animation, _, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
    ],
  );
});
