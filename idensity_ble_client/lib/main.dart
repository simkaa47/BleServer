import 'package:flutter/material.dart';
import 'package:idensity_ble_client/widgets/bluetooth/devices/ble_devices_list_screen.dart';

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
      home: BleDevicesListScreen(),
    );
  }
}
