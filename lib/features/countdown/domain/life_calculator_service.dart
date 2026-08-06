enum LifeSeason {
  spring, // 0-25%
  summer, // 25-50%
  autumn, // 50-75%
  winter, // 75-100%
}

class LifeStats {
  // До следующего ДР
  final int secondsUntilBirthday;
  final int minutesUntilBirthday;
  final int hoursUntilBirthday;
  final int daysUntilBirthday;

  // Прожитое
  final int ageYears;
  final int ageInDays;
  final int ageInWeeks;
  final int minutesLived;
  final double percentOfYearPassed;

  // Жизнь целиком
  final int totalWeeksInLife;
  final int weeksLived;
  final int weeksRemaining;
  final int daysRemaining;
  final int minutesRemaining;
  final int yearsRemaining;

  // Точная календарная разбивка оставшегося времени (лет + мес + нед + дн)
  final int remainingYearsPart;
  final int remainingMonthsPart;
  final int remainingWeeksPart;
  final int remainingDaysPart;
  final DateTime deathDate;
  final int lifeExpectancyYears;

  // Оставшиеся моменты
  final int saturdaysRemaining;
  final int summerEveningsRemaining;
  final int newYearsRemaining;
  final int secondsOfLifeRemaining;

  // Сезон жизни
  final LifeSeason lifeSeason;
  final double lifeProgressPercent;

  // День рождения сегодня?
  final bool isBirthdayToday;

  const LifeStats({
    required this.secondsUntilBirthday,
    required this.minutesUntilBirthday,
    required this.hoursUntilBirthday,
    required this.daysUntilBirthday,
    required this.ageYears,
    required this.ageInDays,
    required this.ageInWeeks,
    required this.minutesLived,
    required this.percentOfYearPassed,
    required this.totalWeeksInLife,
    required this.weeksLived,
    required this.weeksRemaining,
    required this.daysRemaining,
    required this.minutesRemaining,
    required this.yearsRemaining,
    required this.remainingYearsPart,
    required this.remainingMonthsPart,
    required this.remainingWeeksPart,
    required this.remainingDaysPart,
    required this.deathDate,
    required this.lifeExpectancyYears,
    required this.saturdaysRemaining,
    required this.summerEveningsRemaining,
    required this.newYearsRemaining,
    required this.secondsOfLifeRemaining,
    required this.lifeSeason,
    required this.lifeProgressPercent,
    required this.isBirthdayToday,
  });
}

class LifeCalculatorService {
  final DateTime birthDate;
  final int lifeExpectancyYears;

  const LifeCalculatorService({
    required this.birthDate,
    required this.lifeExpectancyYears,
  });

  LifeStats calculate([DateTime? now]) {
    final currentTime = now ?? DateTime.now();

    // Возраст
    int ageYears = currentTime.year - birthDate.year;
    if (currentTime.month < birthDate.month ||
        (currentTime.month == birthDate.month &&
            currentTime.day < birthDate.day)) {
      ageYears--;
    }
    if (ageYears < 0) ageYears = 0;

    final ageInDays = currentTime.difference(birthDate).inDays;
    final ageInWeeks = ageInDays ~/ 7;
    final minutesLived = currentTime.difference(birthDate).inMinutes;

    // День рождения сегодня?
    final isBirthdayToday = currentTime.month == birthDate.month &&
        currentTime.day == birthDate.day;

    // Следующий день рождения
    var nextBirthday = DateTime(
      currentTime.year,
      birthDate.month,
      birthDate.day,
    );
    if (nextBirthday.isBefore(currentTime) ||
        nextBirthday.isAtSameMomentAs(currentTime)) {
      nextBirthday = DateTime(
        currentTime.year + 1,
        birthDate.month,
        birthDate.day,
      );
    }
    // Если сегодня ДР, отсчёт до следующего года
    if (isBirthdayToday) {
      nextBirthday = DateTime(
        currentTime.year + 1,
        birthDate.month,
        birthDate.day,
      );
    }

    final untilBirthday = nextBirthday.difference(currentTime);
    final secondsUntilBirthday = untilBirthday.inSeconds;
    final minutesUntilBirthday = untilBirthday.inMinutes;
    final hoursUntilBirthday = untilBirthday.inHours;
    final daysUntilBirthday = untilBirthday.inDays;

    // Процент текущего года жизни (от последнего ДР до следующего)
    final lastBirthday = DateTime(
      isBirthdayToday ? currentTime.year : currentTime.year,
      birthDate.month,
      birthDate.day,
    );
    final lastBdAdjusted = lastBirthday.isAfter(currentTime)
        ? DateTime(currentTime.year - 1, birthDate.month, birthDate.day)
        : lastBirthday;
    final totalDaysInYear =
        nextBirthday.difference(lastBdAdjusted).inDays;
    final daysPassed = currentTime.difference(lastBdAdjusted).inDays;
    final percentOfYearPassed =
        totalDaysInYear > 0 ? daysPassed / totalDaysInYear : 0.0;

    // Жизнь целиком
    final totalWeeksInLife = lifeExpectancyYears * 52;
    final weeksLived = ageInWeeks;
    final weeksRemaining = (totalWeeksInLife - weeksLived).clamp(0, totalWeeksInLife);

    final deathDate = DateTime(
      birthDate.year + lifeExpectancyYears,
      birthDate.month,
      birthDate.day,
    );
    final daysRemaining = deathDate.difference(currentTime).inDays.clamp(0, lifeExpectancyYears * 366);
    final minutesRemaining = deathDate
        .difference(currentTime)
        .inMinutes
        .clamp(0, lifeExpectancyYears * 366 * 24 * 60);
    final yearsRemaining = (lifeExpectancyYears - ageYears).clamp(0, lifeExpectancyYears);

    // Точная календарная разбивка: сколько лет, месяцев, недель и дней
    // осталось до deathDate (аналогично тому, как считается возраст).
    int remYears = deathDate.year - currentTime.year;
    int remMonths = deathDate.month - currentTime.month;
    int remDaysPart = deathDate.day - currentTime.day;
    if (remDaysPart < 0) {
      remMonths -= 1;
      // Число дней в месяце, предшествующем месяцу смерти
      remDaysPart += DateTime(deathDate.year, deathDate.month, 0).day;
    }
    if (remMonths < 0) {
      remYears -= 1;
      remMonths += 12;
    }
    if (remYears < 0) remYears = 0;
    if (remMonths < 0) remMonths = 0;
    if (remDaysPart < 0) remDaysPart = 0;
    final remainingWeeksPart = remDaysPart ~/ 7;
    final remainingDaysPart = remDaysPart % 7;

    // Оставшиеся моменты
    final saturdaysRemaining = weeksRemaining;
    final summerEveningsRemaining = yearsRemaining * 90;
    final newYearsRemaining = yearsRemaining;
    final secondsOfLifeRemaining = daysRemaining * 86400;

    // Сезон жизни
    final lifeProgressPercent =
        lifeExpectancyYears > 0 ? (ageYears / lifeExpectancyYears).clamp(0.0, 1.0) : 0.0;

    final LifeSeason lifeSeason;
    if (lifeProgressPercent < 0.25) {
      lifeSeason = LifeSeason.spring;
    } else if (lifeProgressPercent < 0.50) {
      lifeSeason = LifeSeason.summer;
    } else if (lifeProgressPercent < 0.75) {
      lifeSeason = LifeSeason.autumn;
    } else {
      lifeSeason = LifeSeason.winter;
    }

    return LifeStats(
      secondsUntilBirthday: secondsUntilBirthday,
      minutesUntilBirthday: minutesUntilBirthday,
      hoursUntilBirthday: hoursUntilBirthday,
      daysUntilBirthday: daysUntilBirthday,
      ageYears: ageYears,
      ageInDays: ageInDays,
      ageInWeeks: ageInWeeks,
      minutesLived: minutesLived,
      percentOfYearPassed: percentOfYearPassed.clamp(0.0, 1.0),
      totalWeeksInLife: totalWeeksInLife,
      weeksLived: weeksLived,
      weeksRemaining: weeksRemaining,
      daysRemaining: daysRemaining,
      minutesRemaining: minutesRemaining,
      yearsRemaining: yearsRemaining,
      remainingYearsPart: remYears,
      remainingMonthsPart: remMonths,
      remainingWeeksPart: remainingWeeksPart,
      remainingDaysPart: remainingDaysPart,
      deathDate: deathDate,
      lifeExpectancyYears: lifeExpectancyYears,
      saturdaysRemaining: saturdaysRemaining,
      summerEveningsRemaining: summerEveningsRemaining,
      newYearsRemaining: newYearsRemaining,
      secondsOfLifeRemaining: secondsOfLifeRemaining,
      lifeSeason: lifeSeason,
      lifeProgressPercent: lifeProgressPercent,
      isBirthdayToday: isBirthdayToday,
    );
  }
}
