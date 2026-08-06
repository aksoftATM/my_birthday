abstract final class FamousBirthdays {
  /// Возвращает список знаменитостей, родившихся в указанную дату (месяц + день)
  static List<FamousPerson> getByDate(DateTime date) {
    final key = '${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return _data[key] ?? [];
  }

  static final Map<String, List<FamousPerson>> _data = {
    '01-01': [FamousPerson('Тим Кук', 1960, 'CEO Apple')],
    '01-08': [FamousPerson('Элвис Пресли', 1935, 'Музыкант')],
    '01-09': [FamousPerson('Кейт Миддлтон', 1982, 'Принцесса')],
    '01-17': [FamousPerson('Мухаммед Али', 1942, 'Боксёр')],
    '01-27': [FamousPerson('Моцарт', 1756, 'Композитор')],
    '01-29': [FamousPerson('Опра Уинфри', 1954, 'Телеведущая')],
    '02-05': [FamousPerson('Криштиану Роналду', 1985, 'Футболист')],
    '02-11': [FamousPerson('Томас Эдисон', 1847, 'Изобретатель')],
    '02-15': [FamousPerson('Галилео Галилей', 1564, 'Учёный')],
    '02-17': [FamousPerson('Майкл Джордан', 1963, 'Баскетболист')],
    '03-14': [FamousPerson('Альберт Эйнштейн', 1879, 'Физик')],
    '03-20': [FamousPerson('Спайк Ли', 1957, 'Режиссёр')],
    '03-26': [FamousPerson('Ларри Пейдж', 1973, 'Сооснователь Google')],
    '03-28': [FamousPerson('Леди Гага', 1986, 'Музыкант')],
    '03-30': [FamousPerson('Винсент ван Гог', 1853, 'Художник')],
    '04-04': [FamousPerson('Роберт Дауни мл.', 1965, 'Актёр')],
    '04-15': [FamousPerson('Леонардо да Винчи', 1452, 'Художник/Учёный')],
    '04-23': [FamousPerson('Шекспир', 1564, 'Писатель')],
    '05-04': [FamousPerson('Одри Хепберн', 1929, 'Актриса')],
    '05-14': [FamousPerson('Марк Цукерберг', 1984, 'CEO Meta')],
    '05-21': [FamousPerson('Нотч (Маркус Перссон)', 1979, 'Создатель Minecraft')],
    '06-22': [FamousPerson('Илон Маск', 1971, 'Предприниматель')],
    '06-28': [FamousPerson('Илон Маск', 1971, 'Предприниматель')],
    '07-06': [FamousPerson('Далай Лама XIV', 1935, 'Духовный лидер')],
    '07-10': [FamousPerson('Никола Тесла', 1856, 'Изобретатель')],
    '07-26': [FamousPerson('Мик Джаггер', 1943, 'Музыкант')],
    '07-30': [FamousPerson('Арнольд Шварценеггер', 1947, 'Актёр/Политик')],
    '08-04': [FamousPerson('Барак Обама', 1961, 'Президент США')],
    '08-15': [FamousPerson('Наполеон Бонапарт', 1769, 'Император')],
    '09-05': [FamousPerson('Фредди Меркьюри', 1946, 'Музыкант')],
    '09-09': [FamousPerson('Лев Толстой', 1828, 'Писатель')],
    '10-05': [FamousPerson('Стив Джобс', 1955, 'Сооснователь Apple')],
    '10-09': [FamousPerson('Джон Леннон', 1940, 'Музыкант')],
    '10-28': [FamousPerson('Билл Гейтс', 1955, 'Сооснователь Microsoft')],
    '11-10': [FamousPerson('Мартин Лютер', 1483, 'Реформатор')],
    '11-20': [FamousPerson('Джо Байден', 1942, 'Президент США')],
    '12-05': [FamousPerson('Уолт Дисней', 1901, 'Аниматор/Предприниматель')],
    '12-18': [FamousPerson('Стивен Спилберг', 1946, 'Режиссёр')],
    '12-25': [FamousPerson('Исаак Ньютон', 1642, 'Учёный')],
  };
}

class FamousPerson {
  final String name;
  final int birthYear;
  final String title;

  const FamousPerson(this.name, this.birthYear, this.title);
}
