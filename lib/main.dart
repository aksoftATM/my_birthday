import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/notifications/notification_service.dart';
import 'core/widget/home_widget_service.dart';
import 'shared/data/user_profile_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Тёмная тема для системного UI
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
    ),
  );

  final prefs = await SharedPreferences.getInstance();
  await NotificationService.init();

  // Виджет на главном экране iOS: инициализация App Group + актуальные
  // данные на случай, если профиль сохранён в прошлых запусках.
  await HomeWidgetService.init();
  await HomeWidgetService.syncProfile(UserProfileRepository(prefs).getProfile());

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const BirthDayApp(),
    ),
  );
}

class BirthDayApp extends ConsumerWidget {
  const BirthDayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'BirthDay OS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: router,
    );
  }
}
