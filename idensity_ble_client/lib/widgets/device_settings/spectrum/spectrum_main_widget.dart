import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/adc/adc_frame.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/models/settings/adc_board_mode.dart';
import 'package:idensity_ble_client/models/settings/adc_board_settings.dart';
import 'package:idensity_ble_client/services/device_service.dart';
import 'package:idensity_ble_client/widgets/async_state_handlers/universal_async_handler.dart';
import 'package:idensity_ble_client/widgets/device_settings/spectrum/oscilloscope_chart_widget.dart';
import 'package:idensity_ble_client/widgets/device_settings/spectrum/spectrum_chart_widget.dart';
import 'package:idensity_ble_client/widgets/parameters/combobox_parameter_widget.dart';
import 'package:idensity_ble_client/widgets/parameters/ip_parameter_widget.dart';
import 'package:idensity_ble_client/widgets/parameters/text_parameter_widget.dart';
import 'package:rxdart/rxdart.dart';

class SpectrumMainWidget extends ConsumerWidget {
  const SpectrumMainWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsyncState = ref.watch(deviceServiceProvider);
    final device = ref.watch(selectedDeviceProvider);
    final serviceName = "Сервис устройств";

    return serviceAsyncState.when(
      data: (service) => _onData(device, service),
      error: (e, s) => UniversalAsyncHandler.onError(serviceName, e, s),
      loading: () => UniversalAsyncHandler.onLoading(serviceName),
    );
  }

  AdcBoardSettings _copy(AdcBoardSettings s) => AdcBoardSettings()
    ..mode = s.mode
    ..syncLevel = s.syncLevel
    ..timerSendData = s.timerSendData
    ..gain = s.gain
    ..updAddress = List.from(s.updAddress)
    ..udpPort = s.udpPort
    ..hvSv = s.hvSv
    ..peakSpectrumSv = s.peakSpectrumSv
    ..adcDataSendEnabled = s.adcDataSendEnabled;

  Widget _chartPanel(Device? device) {
    return StreamBuilder(
      stream: device?.adcFrameStream,
      builder: (context, snapshot) {
        final frame = snapshot.data;
        if (frame == null) {
          return const Center(child: Text('Ожидание данных...'));
        }
        return switch (frame.type) {
          AdcFrameType.oscilloscope => OscilloscopeChartWidget(frame: frame),
          _ => SpectrumChartWidget(frame: frame),
        };
      },
    );
  }

  Widget _onData(Device? device, DeviceService service) {
    return Scaffold(
      appBar: AppBar(title: const Text("Спектр")),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final chart = _chartPanel(device);
          final settings = _settingsPanel(device, service);
          return orientation == Orientation.portrait
              ? Column(children: [
                  Expanded(child: chart),
                  Expanded(child: settings),
                ])
              : Row(children: [
                  Expanded(child: chart),
                  Expanded(child: settings),
                ]);
        },
      ),
    );
  }

  Widget _settingsPanel(Device? device, DeviceService service) {
    return StreamBuilder(
        stream: device == null
            ? null
            : Rx.combineLatest2(
                device.settingsStream,
                device.dataStream,
                (settings, indication) => (settings, indication),
              ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
            final settings = snapshot.data!.$1;
            final indication = snapshot.data!.$2;
            final adc = settings.adcBoardSettings;
            return ListView(
              children: [
                ComboboxParameterWidget(
                  name: 'Режим АЦП',
                  value: adc.mode.index,
                  options: const ['Осциллограмма', 'Спектр'],
                  onConfirm: (value) async => service.writeAdcBoardSettings(
                    _copy(adc)..mode = AdcBoardMode.values[value],
                    device!,
                  ),
                ),
                TextParameterWidget(
                  name: 'Уровень синхронизации',
                  value: adc.syncLevel,
                  minValue: 0,
                  maxValue: 4095,
                  onConfirm: (value) async => service.writeAdcBoardSettings(
                    _copy(adc)..syncLevel = value.toInt(),
                    device!,
                  ),
                ),
                TextParameterWidget(
                  name: 'Таймер отправки данных, мс',
                  value: adc.timerSendData,
                  minValue: 100,
                  onConfirm: (value) async => service.writeAdcBoardSettings(
                    _copy(adc)..timerSendData = value.toInt(),
                    device!,
                  ),
                ),
                TextParameterWidget(
                  name: 'К-т предусиления',
                  value: adc.gain,
                  minValue: 1,
                  maxValue: 26,
                  onConfirm: (value) async => service.writeAdcBoardSettings(
                    _copy(adc)..gain = value.toInt(),
                    device!,
                  ),
                ),
                IpParameterWidget(
                  name: 'IP адрес получателя спектра',
                  octets: adc.updAddress,
                  onConfirm: (octets) async => service.writeAdcBoardSettings(
                    _copy(adc)..updAddress = octets,
                    device!,
                  ),
                ),
                TextParameterWidget(
                  name: 'Порт получателя спектра',
                  value: adc.udpPort,
                  minValue: 0,
                  maxValue: 65535,
                  onConfirm: (value) async => service.writeAdcBoardSettings(
                    _copy(adc)..udpPort = value.toInt(),
                    device!,
                  ),
                ),
                TextParameterWidget(
                  name: 'Значение высокого напряжения, В',
                  value: adc.hvSv,
                  fractionDigits: 1,
                  actualValue: indication.hv,
                  minValue: 400,
                  maxValue: 2000,
                  onConfirm: (value) async => service.writeAdcBoardSettings(
                    _copy(adc)..hvSv = value.toInt(),
                    device!,
                  ),
                ),
                TextParameterWidget(
                  name: 'Координата пика спектра',
                  value: adc.peakSpectrumSv,
                  minValue: 0,
                  maxValue: 4095,
                  onConfirm: (value) async => service.writeAdcBoardSettings(
                    _copy(adc)..peakSpectrumSv = value.toInt(),
                    device!,
                  ),
                ),
                ComboboxParameterWidget(
                  name: 'Отправка данных АЦП',
                  value: adc.adcDataSendEnabled ? 1 : 0,
                  options: const ['Выключена', 'Включена'],
                  onConfirm: (value) async => service.writeAdcBoardSettings(
                    _copy(adc)..adcDataSendEnabled = value == 1,
                    device!,
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text("Нет устройства"));
        },
      );
    
  }
}
