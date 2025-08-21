import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:idensity_ble_client/widgets/device_settings/device_settings_main_widget.dart';
import 'package:idensity_ble_client/widgets/drawer/main_drawer_widget.dart';
import 'package:idensity_ble_client/widgets/main_page/main_page_widget.dart';
import 'package:idensity_ble_client/widgets/meas_units/meas_units_widget.dart';
import 'package:idensity_ble_client/widgets/routes.dart';
import 'package:idensity_ble_client/widgets/scanning/scan_main.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Idensity Bluetooth Client',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}

final _router = GoRouter(
  initialLocation: Routes.scanning,
  routes: [
    GoRoute(
      path: Routes.scanning,
      builder: (context, state) => const ScanMainWidget(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        final Locale currentLocale = Localizations.localeOf(context);
        final String currentTitle = _getTitleForName(state.matchedLocation, currentLocale);
        return Scaffold(
          appBar: AppBar(title: Text(currentTitle)),
          drawer: const MainDrawerWidget(),
          body: child,
        );
      },
      routes: [
        GoRoute(path: '/', redirect: (context, state) => Routes.home),
        GoRoute(
          path: Routes.home,
          name: "home",
          builder: (context, state) => const MainPageWidget(),
          routes: [
            GoRoute(
              path: "measUnits",
              name: "measUnits",
              builder: (context, state) => const MeasUnitsWidget(),
            ),
            GoRoute(
              path: "deviceSettings",
              name: "deviceSettings",
              builder: (context, state) => const DeviceSettingsMainWidget(),
            ),
          ],
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const MainPageWidget(),
);


final Map<String, Map<String, String>> _localizedTitles  = {
  'ru': {
    Routes.home: 'Главная',
    Routes.measUnits: 'Единицы измерения',
    Routes.deviceSettings: 'Настройки прибора',
  },
  'en': {
    Routes.home: 'Home',
    Routes.measUnits: 'Meas Units',
    Routes.deviceSettings: 'Device Settings',
  },
};

String _getTitleForName(String name, Locale locale) {
  final Map<String, String>? titles = _localizedTitles[locale.languageCode];
  if (titles != null && titles.containsKey(name)) {
    return titles[name]!;
  }
  return 'Приложение'; 
}


