import 'dart:io';

import 'package:flutter/material.dart';
import 'package:idensity_ble_client/services/ble_main_service.dart';
import 'package:idensity_ble_client/services/ble_main_service_mobile.dart';
import 'package:idensity_ble_client/services/ble_main_service_windows.dart';
import 'package:idensity_ble_client/services/ble_main_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Idensity Bluetooth Client',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key});
  final BleMainService _bleMainService =
      Platform.isAndroid ? BleMainServiceMobile() : BleMainServiceWindows();
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    widget._bleMainService.setLogLevel();
    super.initState();
  }

  Future<void> _enableBle() async {
    // first, check if bluetooth is supported by your hardware
    // Note: The platform is initialized on the first call to any FlutterBluePlus method.
    await widget._bleMainService.enableBle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Idensity Bluetooth Client'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _enableBle),
      body: StreamBuilder(
        stream: widget._bleMainService.bleMainState,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            final state = snapshot.data;
            if (state == BleMainState.notSupported) {
              return Center(
                child: Text('Bluetooth не поддерживается на этом устройстве'),
              );
            } else if (state == BleMainState.off) {
              return Center(child: Text('Bluetooth выключен'));
            } else {
              return ListView.builder(
                itemCount: widget._bleMainService.scanResults.length,
                itemBuilder: (context, index) {
                  final result = widget._bleMainService.scanResults[index];
                  return ListTile(
                    title: Text(result.device.remoteId.toString()),
                    subtitle: Text(result.advertisementData.advName),
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
