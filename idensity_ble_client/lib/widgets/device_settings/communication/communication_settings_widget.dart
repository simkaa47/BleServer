import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/models/settings/serial_port_mode.dart';
import 'package:idensity_ble_client/models/settings/serial_settings.dart';
import 'package:idensity_ble_client/models/settings/tcp_settings.dart';
import 'package:idensity_ble_client/services/device_service.dart';
import 'package:idensity_ble_client/widgets/async_state_handlers/universal_async_handler.dart';
import 'package:idensity_ble_client/widgets/parameters/combobox_parameter_widget.dart';
import 'package:idensity_ble_client/widgets/parameters/ip_parameter_widget.dart';
import 'package:idensity_ble_client/widgets/parameters/text_parameter_widget.dart';

const _knownBaudrates = [2400, 4800, 9600, 19200, 38400, 57600, 115200];

class CommunicationSettingsWidget extends ConsumerWidget {
  const CommunicationSettingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final device = ref.watch(selectedDeviceProvider);
    final deviceServiceAsyncState = ref.watch(deviceServiceProvider);

    return deviceServiceAsyncState.when(
      data: (service) => _onData(device, service),
      error: (e, s) => UniversalAsyncHandler.onError("Сервис устройств", e, s),
      loading: () => UniversalAsyncHandler.onLoading("Сервис устройств"),
    );
  }

  Widget _onData(Device? device, DeviceService deviceService) {
    if (device == null) return const Scaffold(body: Center(child: Text("Ожидание данных")));

    return StreamBuilder(
      stream: device.settingsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
          final settings = snapshot.data;
          if (settings != null) {
            return _buildContent(settings.modbusId, settings.ethernetSettings, settings.serialSettings, deviceService, device);
          }
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  TcpSettings _tcpCopy(TcpSettings t) => TcpSettings()
    ..address = List.from(t.address)
    ..mask = List.from(t.mask)
    ..gateway = List.from(t.gateway)
    ..macAddress = List.from(t.macAddress);

  SerialSettings _serialCopy(SerialSettings s) => SerialSettings()
    ..baudrate = s.baudrate
    ..mode = s.mode;

  Widget _buildContent(int modbusId, TcpSettings tcp, SerialSettings serial, DeviceService deviceService, Device device) {
    return Scaffold(
      appBar: AppBar(title: const Text("Настройки связи")),
      body: ListView(
        children: [
          TextParameterWidget(
            name: 'Modbus ID',
            value: modbusId,
            minValue: 1,
            maxValue: 247,
            onConfirm: (value) async => deviceService.writeModbusId(value.toInt(), device),
          ),
          const _SectionHeader("Ethernet"),
          IpParameterWidget(
            name: "IP адрес",
            octets: tcp.address,
            onConfirm: (o) => deviceService.writeTcpSettings(_tcpCopy(tcp)..address = o, device),
          ),
          IpParameterWidget(
            name: "Маска",
            octets: tcp.mask,
            onConfirm: (o) => deviceService.writeTcpSettings(_tcpCopy(tcp)..mask = o, device),
          ),
          IpParameterWidget(
            name: "Шлюз",
            octets: tcp.gateway,
            onConfirm: (o) => deviceService.writeTcpSettings(_tcpCopy(tcp)..gateway = o, device),
          ),
          const _SectionHeader("Последовательный порт"),
          ComboboxParameterWidget(
            name: "Скорость, бод",
            value: _knownBaudrates.indexOf(serial.baudrate).clamp(0, _knownBaudrates.length - 1),
            options: _knownBaudrates.map((b) => b.toString()).toList(),
            onConfirm: (index) async {
              await deviceService.writeSerialSettings(
                _serialCopy(serial)..baudrate = _knownBaudrates[index],
                device,
              );
            },
          ),
          ComboboxParameterWidget(
            name: "Режим",
            value: serial.mode.index,
            options: const ["RS-485", "RS-232"],
            onConfirm: (value) async {
              await deviceService.writeSerialSettings(
                _serialCopy(serial)..mode = SerialPortMode.values[value],
                device,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey)),
    );
  }
}

