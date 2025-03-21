import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key, required this.device});

  final BluetoothDevice device;

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  static const String _serviceUuid = "12345678-1234-5678-1234-56789abcdef0";
  static const String _characteristicUuid =
      "12345678-1234-5678-1234-56789abcdef1";

  BluetoothCharacteristic? _characteristic;

  StreamSubscription<BluetoothConnectionState>? _stateSubscription;

  @override
  void initState() {
    log("Init state");
    _connect();
    _stateSubscription = widget.device.connectionState.listen((state) {
      if (state == BluetoothConnectionState.disconnected) {
        _connect();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    widget.device.disconnect();
    super.dispose();
  }

  Future<void> _connect() async {
    await widget.device.connect();
    List<BluetoothService> services = await widget.device.discoverServices();
    services.forEach((service) {
      log('Service: ${service.uuid}');
      service.characteristics.forEach((characteristic) {
        log('Characteristic: ${characteristic.uuid}');
      });
    });
    final service =
        services
            .where((service) => service.uuid.toString() == _serviceUuid)
            .firstOrNull;
    if (service == null) {
      log('Service not found');
      return;
    }
    _characteristic =
        service.characteristics
            .where(
              (characteristic) =>
                  characteristic.uuid.toString() == _characteristicUuid,
            )
            .firstOrNull;
    if (_characteristic == null) {
      log('Characteristic not found');
      return;
    }
    log('Characteristic found');
    final subscription = _characteristic?.onValueReceived.listen((value) {
      log('We have gotten a value: ${value.toString()}');
    });

    // cleanup: cancel subscription when disconnected
    widget.device.cancelWhenDisconnected(subscription!);

    // subscribe
    // Note: If a characteristic supports both **notifications** and **indications**,
    // it will default to **notifications**. This matches how CoreBluetooth works on iOS.
    //await _characteristic?.setNotifyValue(true);
  }

  Future<void> _read() async {
    await _characteristic?.read();
  }

  Future<void> _send() async {
    try {
      _characteristic?.setNotifyValue(true);
      await _characteristic?.write([1, 2, 3, 3, 5]);
    } catch (e) {
      log(e.toString());
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _read,
            child: const Icon(Icons.read_more),
          ),
          SizedBox(width: 10),
          FloatingActionButton(onPressed: _send, child: const Icon(Icons.send)),
        ],
      ),

      appBar: AppBar(title: const Text('Idensity Bluetooth Client')),
      body: Center(child: Text(widget.device.advName.toString())),
    );
  }
}
