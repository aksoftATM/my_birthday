const _ruMonthsGenitive = [
  'января',
  'февраля',
  'марта',
  'апреля',
  'мая',
  'июня',
  'июля',
  'августа',
  'сентября',
  'октября',
  'ноября',
  'декабря',
];

extension DateTimeExtensions on DateTime {
  /// Например: "14 марта 2074"
  String get formattedRu => '$day ${_ruMonthsGenitive[month - 1]} $year';


  bool get isBirthdayToday {
    final now = DateTime.now();
    return month == now.month && day == now.day;
  }

  DateTime get nextBirthday {
    final now = DateTime.now();
    var next = DateTime(now.year, month, day);
    if (next.isBefore(now) || next.isAtSameMomentAs(now)) {
      // Если ДР уже прошёл в этом году (или сегодня), следующий — в следующем
      // Но если сегодня ДР — считаем до следующего года
      if (isBirthdayToday) {
        next = DateTime(now.year + 1, month, day);
      } else {
        next = DateTime(now.year + 1, month, day);
      }
    }
    return next;
  }

  int get daysUntilNextBirthday {
    final next = nextBirthday;
    final now = DateTime.now();
    return DateTime(next.year, next.month, next.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  int get currentAge {
    final now = DateTime.now();
    int age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }
}
