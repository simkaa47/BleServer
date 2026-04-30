import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/diagnostic/device_event.dart';
import 'package:idensity_ble_client/models/indication/indication.dart';
import 'package:idensity_ble_client/services/diagnostic/diagnostic_service.dart';
import 'package:rxdart/rxdart.dart';

class DiagnosticServiceImpl implements DiagnosticService {
  final Map<Device, List<DeviceEvent>> _events = {};
  final Map<Device, BehaviorSubject<List<DeviceEvent>>> _controllers = {};
  final _allActiveController = BehaviorSubject<List<ActiveEvent>>.seeded([]);

  @override
  Stream<List<ActiveEvent>> get allActiveEventsStream => _allActiveController.stream;

  @override
  void registerDevice(Device device) {
    final events = [
      DeviceEvent(id: 'connection', description: 'Нет связи с устройством'),
      DeviceEvent(id: 'adc_board', description: 'Нет связи с платой АЦП'),
      DeviceEvent(id: 'hv_board', description: 'Нет связи с платой высокого напряжения'),
      DeviceEvent(id: 'ai_0', description: 'Нет связи с аналоговым входом 1'),
      DeviceEvent(id: 'ai_1', description: 'Нет связи с аналоговым входом 2'),
      DeviceEvent(id: 'ao_0', description: 'Нет связи с аналоговым выходом 1'),
      DeviceEvent(id: 'ao_1', description: 'Нет связи с аналоговым выходом 2'),
    ];
    _events[device] = events;
    _controllers[device] = BehaviorSubject.seeded(List.from(events));
  }

  @override
  void unregisterDevice(Device device) {
    _controllers.remove(device)?.close();
    _events.remove(device);
    _emitAllActive();
  }

  @override
  void check(Device device, IndicationData indication) {
    final events = _events[device];
    if (events == null) return;

    _update(events, 'adc_board', !indication.adcBoardConnectState);
    _update(events, 'hv_board', !indication.hvBoardTelemetry.boardConnectingState);
    for (var i = 0; i < indication.analogInputIndications.length; i++) {
      _update(events, 'ai_$i', !indication.analogInputIndications[i].commState);
    }
    for (var i = 0; i < indication.analogOutputIndications.length; i++) {
      _update(events, 'ao_$i', !indication.analogOutputIndications[i].commState);
    }

    _emit(device, events);
  }

  @override
  void updateConnectionEvent(Device device, bool connected) {
    final events = _events[device];
    if (events == null) return;
    _update(events, 'connection', !connected);
    _emit(device, events);
  }

  @override
  Stream<List<DeviceEvent>> eventsStreamFor(Device device) =>
      _controllers[device]?.stream ?? const Stream.empty();

  @override
  List<DeviceEvent> eventsFor(Device device) =>
      List.from(_events[device] ?? []);

  void _emit(Device device, List<DeviceEvent> events) {
    _controllers[device]?.add(List.from(events));
    _emitAllActive();
  }

  void _emitAllActive() {
    final active = _events.entries
        .expand((entry) => entry.value
            .where((e) => e.isActive)
            .map((e) => (deviceName: entry.key.name, event: e)))
        .toList()
      ..sort((a, b) => b.event.lastActiveTime.compareTo(a.event.lastActiveTime));
    _allActiveController.add(active);
  }

  void _update(List<DeviceEvent> events, String id, bool isError) {
    final event = events.firstWhere((e) => e.id == id);
    if (isError) {
      event.activate();
    } else {
      event.disactivate();
    }
  }
}
