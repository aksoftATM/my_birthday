import '../../../core/constants/zodiac_data.dart';
import '../../../core/constants/famous_birthdays.dart';

class ZodiacInfo {
  final ZodiacSign sign;
  final List<FamousPerson> sameDayFamous;

  const ZodiacInfo({required this.sign, required this.sameDayFamous});
}

class ZodiacService {
  ZodiacInfo getInfo(DateTime birthDate) {
    return ZodiacInfo(
      sign: ZodiacData.getSign(birthDate),
      sameDayFamous: FamousBirthdays.getByDate(birthDate),
    );
  }
}
