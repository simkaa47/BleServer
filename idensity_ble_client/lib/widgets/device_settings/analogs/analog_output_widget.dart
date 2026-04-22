import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/settings/analog_out_meas_type.dart';
import 'package:idensity_ble_client/models/settings/analog_output_mode.dart';
import 'package:idensity_ble_client/models/settings/analog_output_settings.dart';
import 'package:idensity_ble_client/services/device_service.dart';
import 'package:idensity_ble_client/widgets/device_settings/analogs/analog_indication_widget.dart';
import 'package:idensity_ble_client/widgets/parameters/combobox_parameter_widget.dart';
import 'package:idensity_ble_client/widgets/parameters/text_parameter_widget.dart';
import 'package:rxdart/rxdart.dart';

class AnalogOutputWidget extends StatelessWidget {
  const AnalogOutputWidget({
    super.key,
    required this.device,
    required this.deviceService,
    required this.outputIndex,
  });

  final Device device;
  final DeviceService deviceService;
  final int outputIndex;

  AnalogOutputSettings _copy(AnalogOutputSettings s) => AnalogOutputSettings()
    ..isActive = s.isActive
    ..mode = s.mode
    ..measProcessNum = s.measProcessNum
    ..analogOutMeasType = s.analogOutMeasType
    ..minValue = s.minValue
    ..maxValue = s.maxValue
    ..minCurrent = s.minCurrent
    ..maxCurrent = s.maxCurrent
    ..testValue = s.testValue;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Rx.combineLatest2(
        device.settingsStream,
        device.dataStream,
        (settings, indication) => (settings, indication),
      ),
      builder: (context, snapshot) {
        final data = snapshot.data;
        final settings = data?.$1.analogOutputSettings[outputIndex];
        final indication = data?.$2.analogOutputIndications[outputIndex];

        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Аналоговый выход ${outputIndex + 1}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  trailing: settings != null
                      ? Switch(
                          value: settings.isActive,
                          onChanged: (value) => deviceService.writeAnalogOutputSettings(
                            _copy(settings)..isActive = value,
                            outputIndex,
                            device,
                          ),
                        )
                      : null,
                ),
                if (indication != null)
                  AnalogIndicationWidget(
                    indication: indication,
                    current: indication.current,
                  ),
                if (settings != null) ...[
                  ComboboxParameterWidget(
                    showCard: false,
                    name: 'Режим',
                    value: settings.mode.index,
                    options: const ['Тестовое значение', 'Измеренное значение'],
                    onConfirm: (value) async => deviceService.writeAnalogOutputSettings(
                      _copy(settings)..mode = AnalogOutputMode.values[value],
                      outputIndex,
                      device,
                    ),
                  ),
                  ComboboxParameterWidget(
                    showCard: false,
                    name: 'Номер изм. процесса',
                    value: settings.measProcessNum,
                    options: List.generate(
                      device.deviceSettings?.measProcesses.length ?? 1,
                      (i) => 'Процесс ${i + 1}',
                    ),
                    onConfirm: (value) async => deviceService.writeAnalogOutputSettings(
                      _copy(settings)..measProcessNum = value,
                      outputIndex,
                      device,
                    ),
                  ),
                  ComboboxParameterWidget(
                    showCard: false,
                    name: 'Тип величины',
                    value: settings.analogOutMeasType.index,
                    options: const ['Мгновенное', 'Усредненное', 'Счетчик'],
                    onConfirm: (value) async => deviceService.writeAnalogOutputSettings(
                      _copy(settings)..analogOutMeasType = AnalogOutMeasType.values[value],
                      outputIndex,
                      device,
                    ),
                  ),
                  TextParameterWidget(
                    showCard: false,
                    name: 'Мин. физ. величина',
                    value: settings.minValue,
                    onConfirm: (value) async => deviceService.writeAnalogOutputSettings(
                      _copy(settings)..minValue = value.toDouble(),
                      outputIndex,
                      device,
                    ),
                  ),
                  TextParameterWidget(
                    showCard: false,
                    name: 'Макс. физ. величина',
                    value: settings.maxValue,
                    onConfirm: (value) async => deviceService.writeAnalogOutputSettings(
                      _copy(settings)..maxValue = value.toDouble(),
                      outputIndex,
                      device,
                    ),
                  ),
                  TextParameterWidget(
                    showCard: false,
                    name: 'Мин. ток, мА',
                    value: settings.minCurrent,
                    minValue: 0,
                    maxValue: 20,
                    onConfirm: (value) async => deviceService.writeAnalogOutputSettings(
                      _copy(settings)..minCurrent = value.toDouble(),
                      outputIndex,
                      device,
                    ),
                  ),
                  TextParameterWidget(
                    showCard: false,
                    name: 'Макс. ток, мА',
                    value: settings.maxCurrent,
                    minValue: 0,
                    maxValue: 20,
                    onConfirm: (value) async => deviceService.writeAnalogOutputSettings(
                      _copy(settings)..maxCurrent = value.toDouble(),
                      outputIndex,
                      device,
                    ),
                  ),
                  if (settings.mode == AnalogOutputMode.testValue)
                    TextParameterWidget(
                      showCard: false,
                      name: 'Тестовое значение',
                      value: settings.testValue,
                      minValue: 0,
                      maxValue: 20,
                      onConfirm: (value) async {
                        await deviceService.writeAnalogOutputSettings(
                          _copy(settings)..testValue = value.toDouble(),
                          outputIndex,
                          device,
                        );
                        await deviceService.sendAnalogTestValue(outputIndex, device);
                      },
                    ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
