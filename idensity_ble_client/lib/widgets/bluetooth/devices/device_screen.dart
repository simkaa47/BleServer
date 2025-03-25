import 'dart:async';
import 'dart:convert';
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
  String? _readValue;
  static const String _serviceUuid = "d973f2e0-b19e-11e2-9e96-0800200c9a66";
  static const String _characteristicWriteUuid =
      "d973f2e2-b19e-11e2-9e96-0800200c9a66";
  static const String _characteristicReadUuid =
      "d973f2e1-b19e-11e2-9e96-0800200c9a66";

  BluetoothCharacteristic? _characteristicRead;
  BluetoothCharacteristic? _characteristicWrite;

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
        log(
          'Characteristic: ${characteristic.uuid} with flags ${characteristic.properties}',
        );
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
    _characteristicWrite =
        service.characteristics
            .where(
              (characteristic) =>
                  characteristic.uuid.toString() == _characteristicWriteUuid,
            )
            .firstOrNull;
    if (_characteristicWrite == null) {
      log('Characteristic for writing is not found');
      return;
    }
    _characteristicRead =
        service.characteristics
            .where(
              (characteristic) =>
                  characteristic.uuid.toString() == _characteristicReadUuid,
            )
            .firstOrNull;
    if (_characteristicRead == null) {
      log('Characteristic for reading is not found');
      return;
    }
    log('Characteristic for reading found');
    log('Characteristic for writing found');
    final subscription = _characteristicRead?.lastValueStream.listen((value) {
      log('We have gotten a value: ${value.toString()}');
      setState(() {
        _readValue = utf8.decode(value);
        log(_readValue!);
      });
    });

    // cleanup: cancel subscription when disconnected
    widget.device.cancelWhenDisconnected(subscription!);

    // subscribe
    // Note: If a characteristic supports both **notifications** and **indications**,
    // it will default to **notifications**. This matches how CoreBluetooth works on iOS.
    await _characteristicRead?.setNotifyValue(true);
  }

  Future<void> _read() async {
    await _characteristicRead?.read();
  }

  Future<void> _send() async {
    try {
      await _characteristicWrite?.write([1, 2, 3, 3, 5]);
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
      body: Center(
        child: Column(
          children: [
            Text(widget.device.advName.toString()),
            Text(_readValue ?? ""),
          ],
        ),
      ),
    );
  }
}
