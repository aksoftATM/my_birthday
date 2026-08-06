import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(settings);
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  static Future<void> requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  static Future<void> scheduleBirthdayMilestones(DateTime birthDate) async {
    await _plugin.cancelAll();

    final now = DateTime.now();
    var nextBirthday = DateTime(now.year, birthDate.month, birthDate.day);
    if (nextBirthday.isBefore(now)) {
      nextBirthday = DateTime(now.year + 1, birthDate.month, birthDate.day);
    }

    // За 100 дней до ДР
    final d100 = nextBirthday.subtract(const Duration(days: 100));
    if (d100.isAfter(now)) {
      await _schedule(
        id: 1,
        date: d100,
        title: 'BirthDay OS',
        body: 'До твоего дня рождения 100 дней 🎂',
      );
    }

    // За 30 дней до ДР
    final d30 = nextBirthday.subtract(const Duration(days: 30));
    if (d30.isAfter(now)) {
      await _schedule(
        id: 2,
        date: d30,
        title: 'BirthDay OS',
        body: 'Месяц до праздника! Обновил вишлист?',
      );
    }

    // За 7 дней до ДР
    final d7 = nextBirthday.subtract(const Duration(days: 7));
    if (d7.isAfter(now)) {
      await _schedule(
        id: 3,
        date: d7,
        title: 'BirthDay OS',
        body: 'Неделя до твоего дня рождения 🎉',
      );
    }

    // В день ДР в 9:00
    final bdMorning = DateTime(
      nextBirthday.year,
      nextBirthday.month,
      nextBirthday.day,
      9,
    );
    if (bdMorning.isAfter(now)) {
      await _schedule(
        id: 4,
        date: bdMorning,
        title: 'С днём рождения! 🎂',
        body: 'Поздравляем! Загляни в BirthDay OS за сюрпризом!',
      );
    }

    // Milestone: 10,000 дней жизни
    final tenThousandDays = birthDate.add(const Duration(days: 10000));
    if (tenThousandDays.isAfter(now)) {
      await _schedule(
        id: 5,
        date: tenThousandDays,
        title: 'BirthDay OS',
        body: 'Тебе исполнилось 10 000 дней!',
      );
    }

    // Milestone: 1,000 недель жизни
    final thousandWeeks = birthDate.add(const Duration(days: 7000));
    if (thousandWeeks.isAfter(now)) {
      await _schedule(
        id: 6,
        date: thousandWeeks,
        title: 'BirthDay OS',
        body: 'Тысяча недель позади 🌟',
      );
    }
  }

  static Future<void> _schedule({
    required int id,
    required DateTime date,
    required String title,
    required String body,
  }) async {
    final scheduledDate = tz.TZDateTime.from(date, tz.local);
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'birthday_milestones',
          'Birthday Milestones',
          channelDescription: 'Уведомления о днях рождения и milestone-ах',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
