import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/widgets/main_page/main_page_widget.dart';
import 'package:idensity_ble_client/widgets/meas_units/meas_units_widget.dart';
import 'package:idensity_ble_client/widgets/routes.dart';
import 'package:idensity_ble_client/widgets/scanning.dart/scan_main.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
   runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Routes.scanning,
      routes:{
        Routes.scanning:(context) => const ScanMainWidget(),
        Routes.home : (context) => const MainPageWidget(),
        Routes.measUnits : (context) => const MeasUnitsWidget()
      },
      title: 'Idensity Bluetooth Client',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),     
      
    );
  }
}
