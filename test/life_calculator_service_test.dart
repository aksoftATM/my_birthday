import 'package:flutter_test/flutter_test.dart';
import 'package:mybirthday_app/features/countdown/domain/life_calculator_service.dart';

void main() {
  group('LifeCalculatorService', () {
    test('calculates age correctly', () {
      final calc = LifeCalculatorService(
        birthDate: DateTime(1990, 6, 15),
        lifeExpectancyYears: 80,
      );
      final stats = calc.calculate(DateTime(2025, 3, 19));
      expect(stats.ageYears, 34);
    });

    test('calculates age before birthday in current year', () {
      final calc = LifeCalculatorService(
        birthDate: DateTime(1990, 12, 25),
        lifeExpectancyYears: 80,
      );
      final stats = calc.calculate(DateTime(2025, 3, 19));
      expect(stats.ageYears, 34); // 25 Dec not yet reached
    });

    test('calculates days until birthday', () {
      final calc = LifeCalculatorService(
        birthDate: DateTime(1990, 6, 15),
        lifeExpectancyYears: 80,
      );
      final stats = calc.calculate(DateTime(2025, 3, 19));
      // June 15 - March 19 = 88 days
      expect(stats.daysUntilBirthday, 88);
    });

    test('detects birthday today', () {
      final calc = LifeCalculatorService(
        birthDate: DateTime(1990, 3, 19),
        lifeExpectancyYears: 80,
      );
      final stats = calc.calculate(DateTime(2025, 3, 19));
      expect(stats.isBirthdayToday, true);
      expect(stats.ageYears, 35);
    });

    test('calculates weeks correctly', () {
      final calc = LifeCalculatorService(
        birthDate: DateTime(2000, 1, 1),
        lifeExpectancyYears: 80,
      );
      final stats = calc.calculate(DateTime(2025, 1, 1));
      expect(stats.ageInWeeks, 1304); // ~25 years * 52.14
      expect(stats.totalWeeksInLife, 4160); // 80 * 52
    });

    test('life season spring for young person', () {
      final calc = LifeCalculatorService(
        birthDate: DateTime(2005, 5, 1),
        lifeExpectancyYears: 80,
      );
      final stats = calc.calculate(DateTime(2025, 3, 19));
      expect(stats.lifeSeason, LifeSeason.spring);
    });

    test('life season summer for middle-aged person', () {
      final calc = LifeCalculatorService(
        birthDate: DateTime(1985, 5, 1),
        lifeExpectancyYears: 80,
      );
      final stats = calc.calculate(DateTime(2025, 3, 19));
      expect(stats.lifeSeason, LifeSeason.summer);
    });

    test('life season autumn', () {
      final calc = LifeCalculatorService(
        birthDate: DateTime(1975, 5, 1),
        lifeExpectancyYears: 80,
      );
      final stats = calc.calculate(DateTime(2025, 3, 19));
      expect(stats.lifeSeason, LifeSeason.autumn);
    });

    test('life season winter for elderly', () {
      final calc = LifeCalculatorService(
        birthDate: DateTime(1940, 5, 1),
        lifeExpectancyYears: 80,
      );
      final stats = calc.calculate(DateTime(2025, 3, 19));
      expect(stats.lifeSeason, LifeSeason.winter);
    });

    test('handles exceeding life expectancy gracefully', () {
      final calc = LifeCalculatorService(
        birthDate: DateTime(1930, 1, 1),
        lifeExpectancyYears: 80,
      );
      final stats = calc.calculate(DateTime(2025, 3, 19));
      expect(stats.weeksRemaining, 0);
      expect(stats.daysRemaining, 0);
      expect(stats.lifeProgressPercent, 1.0);
      expect(stats.lifeSeason, LifeSeason.winter);
    });

    test('remaining moments are calculated', () {
      final calc = LifeCalculatorService(
        birthDate: DateTime(2000, 1, 1),
        lifeExpectancyYears: 80,
      );
      final stats = calc.calculate(DateTime(2025, 1, 1));
      expect(stats.yearsRemaining, 55);
      expect(stats.newYearsRemaining, 55);
      expect(stats.saturdaysRemaining, greaterThan(0));
      expect(stats.summerEveningsRemaining, 55 * 90);
    });

    test('life progress percent is within bounds', () {
      final calc = LifeCalculatorService(
        birthDate: DateTime(2000, 1, 1),
        lifeExpectancyYears: 80,
      );
      final stats = calc.calculate(DateTime(2025, 1, 1));
      expect(stats.lifeProgressPercent, greaterThanOrEqualTo(0.0));
      expect(stats.lifeProgressPercent, lessThanOrEqualTo(1.0));
      // 25/80 = 0.3125
      expect(stats.lifeProgressPercent, closeTo(0.3125, 0.01));
    });
  });
}
