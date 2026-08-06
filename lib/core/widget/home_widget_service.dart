import 'package:home_widget/home_widget.dart';
import '../../shared/data/user_profile_repository.dart';

/// Синхронизация данных с виджетом на главном экране iOS (WidgetKit).
///
/// Виджет сам считает дни до дня рождения из даты рождения — сюда мы
/// только пишем "сырые" данные профиля в общий App Group storage и
/// просим систему перерисовать виджет.
class HomeWidgetService {
  static const _appGroupId = 'group.com.example.mybirthdayApp.widget';
  static const _iosWidgetName = 'BirthdayWidget';

  static Future<void> init() async {
    await HomeWidget.setAppGroupId(_appGroupId);
  }

  static Future<void> syncProfile(UserProfile? profile) async {
    await HomeWidget.saveWidgetData<bool>('has_profile', profile != null);
    if (profile != null) {
      await HomeWidget.saveWidgetData<int>('birth_day', profile.birthDate.day);
      await HomeWidget.saveWidgetData<int>('birth_month', profile.birthDate.month);
      await HomeWidget.saveWidgetData<int>('birth_year', profile.birthDate.year);
      await HomeWidget.saveWidgetData<String>('user_name', profile.name ?? '');
    }
    await HomeWidget.updateWidget(iOSName: _iosWidgetName);
  }
}
