import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/scan_state.dart';
import 'package:idensity_ble_client/services/ble_main_service.dart';
import 'package:idensity_ble_client/services/ble_main_service_mobile.dart';
import 'package:idensity_ble_client/services/ble_main_service_windows.dart';
import 'package:idensity_ble_client/widgets/bluetooth/devices/device_screen.dart';

class BleDevicesListScreen extends StatefulWidget {
  BleDevicesListScreen({super.key});
  final BleMainService _bleMainService =
      Platform.isAndroid ? BleMainServiceMobile() : BleMainServiceWindows();
  @override
  State<BleDevicesListScreen> createState() => _BleDevicesListScreenState();
}

class _BleDevicesListScreenState extends State<BleDevicesListScreen> {
  bool _enableScanning = false;

  @override
  void initState() {
    widget._bleMainService.setLogLevel();
    super.initState();
    widget._bleMainService.bleMainState.listen((state) {
      if (state == ScanState.on) {
        setState(() {
          _enableScanning = true;
        });
      } else {
        setState(() {
          _enableScanning = false;
        });
      }
    });
  }

  Future<void> _enableBle() async {
    if (_enableScanning) {
      await widget._bleMainService.enableBle();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Idensity Bluetooth Client')),
      floatingActionButton: FloatingActionButton(
        enableFeedback: _enableScanning,
        onPressed: _enableBle,
        child:
            _enableScanning
                ? const Icon(Icons.bluetooth_searching)
                : const Icon(Icons.bluetooth_disabled),
      ),
      body: StreamBuilder(
        stream: widget._bleMainService.bleMainState,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            final state = snapshot.data;
            if (state == ScanState.notSupported) {
              return Center(
                child: Text('Bluetooth не поддерживается на этом устройстве'),
              );
            } else if (state == ScanState.off) {
              return Center(child: Text('Bluetooth выключен'));
            } else {
              return ListView.builder(
                itemCount: widget._bleMainService.scanResults.length,
                itemBuilder: (context, index) {
                  final result = widget._bleMainService.scanResults[index];
                  return ListTile(
                    title: Text(result.device.remoteId.toString()),
                    subtitle: Text(result.advertisementData.advName),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        log("go to DeviceScreen");
                        return DeviceScreen(device: result.device);
                      }),
                    ),
                  );
                },
              );
            }
          }
          return Text('Ожидание состояния адаптера Bluetooth...');
        },
      ),
    );
  }
}
