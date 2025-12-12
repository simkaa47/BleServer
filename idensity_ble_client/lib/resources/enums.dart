import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/indication/meas_result.dart';

String getMeasMode(int deviceMode, intMeasMode) {
  final list = deviceMode == 0 ? densityMeasModes : levelmeterMeasModes;
  return getByIndexFromList(intMeasMode, list);  
}

String getMeasModeForDevice(Device device, MeasResult? measResult){
  final int measProcIndex = measResult?.measProcIndex ?? 0;
  final measMode = device.deviceSettings?.measProcesses[measProcIndex].measType ?? 0;
  final devModeIndex = device.deviceSettings?.deviceMode.index ?? 0;
  return getMeasMode(devModeIndex, measMode);

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

const List<String> calcTypes = [
  "Полином",
  "Ослабление",
  "Не задано"
];

const List<String> chartNames = [
  "Счетчик",
  "Изм. процесс 1 : Мгновенное значение ФВ",
  "Изм. процесс 1 : Усредненное значение ФВ",
  "Изм. процесс 2 : Мгновенное значение ФВ",
  "Изм. процесс 2 : Усредненное значение ФВ",
  "Температура прибора, С",
  "Изм. процесс 1 : Значение тока на аналоговом входе, mA",
  "Изм. процесс 2 : Значение тока на аналоговом входе, mA",
  "Изм. процесс 1 : Значение тока на аналоговом выходе, mA",
  "Изм. процесс 2 : Значение тока на аналоговом выходе, mA",
  "Напряжение HV, В",
];


