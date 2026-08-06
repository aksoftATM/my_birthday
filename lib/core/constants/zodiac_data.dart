class ZodiacSign {
  final String name;
  final String nameRu;
  final String symbol;
  final String element;
  final String elementRu;
  final DateTime startDate;
  final DateTime endDate;
  final String description;

  const ZodiacSign({
    required this.name,
    required this.nameRu,
    required this.symbol,
    required this.element,
    required this.elementRu,
    required this.startDate,
    required this.endDate,
    required this.description,
  });
}

abstract final class ZodiacData {
  static final List<ZodiacSign> signs = [
    ZodiacSign(
      name: 'Aries',
      nameRu: 'Овен',
      symbol: '♈',
      element: 'Fire',
      elementRu: 'Огонь',
      startDate: DateTime(2000, 3, 21),
      endDate: DateTime(2000, 4, 19),
      description: 'Энергичный лидер, полный страсти и решимости.',
    ),
    ZodiacSign(
      name: 'Taurus',
      nameRu: 'Телец',
      symbol: '♉',
      element: 'Earth',
      elementRu: 'Земля',
      startDate: DateTime(2000, 4, 20),
      endDate: DateTime(2000, 5, 20),
      description: 'Надёжный и терпеливый, ценит комфорт и стабильность.',
    ),
    ZodiacSign(
      name: 'Gemini',
      nameRu: 'Близнецы',
      symbol: '♊',
      element: 'Air',
      elementRu: 'Воздух',
      startDate: DateTime(2000, 5, 21),
      endDate: DateTime(2000, 6, 20),
      description: 'Любознательный и общительный, мастер коммуникации.',
    ),
    ZodiacSign(
      name: 'Cancer',
      nameRu: 'Рак',
      symbol: '♋',
      element: 'Water',
      elementRu: 'Вода',
      startDate: DateTime(2000, 6, 21),
      endDate: DateTime(2000, 7, 22),
      description: 'Заботливый и интуитивный, глубоко привязан к дому.',
    ),
    ZodiacSign(
      name: 'Leo',
      nameRu: 'Лев',
      symbol: '♌',
      element: 'Fire',
      elementRu: 'Огонь',
      startDate: DateTime(2000, 7, 23),
      endDate: DateTime(2000, 8, 22),
      description: 'Творческий и великодушный, прирождённый артист.',
    ),
    ZodiacSign(
      name: 'Virgo',
      nameRu: 'Дева',
      symbol: '♍',
      element: 'Earth',
      elementRu: 'Земля',
      startDate: DateTime(2000, 8, 23),
      endDate: DateTime(2000, 9, 22),
      description: 'Аналитичный и практичный, стремится к совершенству.',
    ),
    ZodiacSign(
      name: 'Libra',
      nameRu: 'Весы',
      symbol: '♎',
      element: 'Air',
      elementRu: 'Воздух',
      startDate: DateTime(2000, 9, 23),
      endDate: DateTime(2000, 10, 22),
      description: 'Дипломатичный и справедливый, ищет гармонию.',
    ),
    ZodiacSign(
      name: 'Scorpio',
      nameRu: 'Скорпион',
      symbol: '♏',
      element: 'Water',
      elementRu: 'Вода',
      startDate: DateTime(2000, 10, 23),
      endDate: DateTime(2000, 11, 21),
      description: 'Страстный и решительный, обладает магнетизмом.',
    ),
    ZodiacSign(
      name: 'Sagittarius',
      nameRu: 'Стрелец',
      symbol: '♐',
      element: 'Fire',
      elementRu: 'Огонь',
      startDate: DateTime(2000, 11, 22),
      endDate: DateTime(2000, 12, 21),
      description: 'Оптимистичный путешественник, любит свободу.',
    ),
    ZodiacSign(
      name: 'Capricorn',
      nameRu: 'Козерог',
      symbol: '♑',
      element: 'Earth',
      elementRu: 'Земля',
      startDate: DateTime(2000, 12, 22),
      endDate: DateTime(2000, 1, 19),
      description: 'Амбициозный и дисциплинированный, строит будущее.',
    ),
    ZodiacSign(
      name: 'Aquarius',
      nameRu: 'Водолей',
      symbol: '♒',
      element: 'Air',
      elementRu: 'Воздух',
      startDate: DateTime(2000, 1, 20),
      endDate: DateTime(2000, 2, 18),
      description: 'Прогрессивный визионер, мыслит нестандартно.',
    ),
    ZodiacSign(
      name: 'Pisces',
      nameRu: 'Рыбы',
      symbol: '♓',
      element: 'Water',
      elementRu: 'Вода',
      startDate: DateTime(2000, 2, 19),
      endDate: DateTime(2000, 3, 20),
      description: 'Мечтательный и сострадательный, живёт в мире эмоций.',
    ),
  ];

  static ZodiacSign getSign(DateTime birthDate) {
    final month = birthDate.month;
    final day = birthDate.day;

    // Козерог перекрывает границу года
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
      return signs.firstWhere((s) => s.name == 'Capricorn');
    }
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      return signs.firstWhere((s) => s.name == 'Aquarius');
    }
    if ((month == 2 && day >= 19) || (month == 3 && day <= 20)) {
      return signs.firstWhere((s) => s.name == 'Pisces');
    }
    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
      return signs.firstWhere((s) => s.name == 'Aries');
    }
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
      return signs.firstWhere((s) => s.name == 'Taurus');
    }
    if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
      return signs.firstWhere((s) => s.name == 'Gemini');
    }
    if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
      return signs.firstWhere((s) => s.name == 'Cancer');
    }
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
      return signs.firstWhere((s) => s.name == 'Leo');
    }
    if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
      return signs.firstWhere((s) => s.name == 'Virgo');
    }
    if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
      return signs.firstWhere((s) => s.name == 'Libra');
    }
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      return signs.firstWhere((s) => s.name == 'Scorpio');
    }
    return signs.firstWhere((s) => s.name == 'Sagittarius');
  }
}
