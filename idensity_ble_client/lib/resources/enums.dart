String getMeasMode(int deviceMode, intMeasMode) {
  final list = deviceMode == 0 ? densityMeasModes : levelmeterMeasModes;
  return getByIndexFromList(intMeasMode, list);  
}

String getByIndexFromList(int index, List<String> list) {
  if (index >= list.length) {
    return "Вне диапазона";
  }
  return list[index];
}

const List<String> devicesTypes = ["Плотномер", "Уровнемер"];
const List<String> densityMeasModes = [
  "Плотность",
  "Массовая концентрация фазы 1",
  "Массовая концентрация фазы 2",
  "Относительная концентрация фазы 1",
  "Относительная концентрация фазы 2",
  "Отношение фазы 1 к фазе 2",
  "Отношение фазы 2 к фазе 1",
];

const List<String> levelmeterMeasModes = [
  "Длина",
  "Заполнение - доля",
  "Обьем",
  "Скорость заполнения",
];
