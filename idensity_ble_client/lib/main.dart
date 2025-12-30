import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:idensity_ble_client/app_scroll_behavior.dart';
import 'package:idensity_ble_client/widgets/device_settings/common/common_settings_widget.dart';
import 'package:idensity_ble_client/widgets/device_settings/device_settings_main_widget.dart';
import 'package:idensity_ble_client/widgets/device_settings/device_settings_navigation_widget.dart';
import 'package:idensity_ble_client/widgets/device_settings/meas_process/meas_process_settings_widget.dart';
import 'package:idensity_ble_client/widgets/drawer/main_drawer_widget.dart';
import 'package:idensity_ble_client/widgets/main_page/main_page_widget.dart';
import 'package:idensity_ble_client/widgets/meas_units/meas_units_widget.dart';
import 'package:idensity_ble_client/widgets/routes.dart';
import 'package:idensity_ble_client/widgets/scanning/scan_main.dart';

void main() {  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scrollBehavior: AppScrollBehavior(),
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
        final String currentTitle = _getTitleForName(
          state.matchedLocation,
          currentLocale,
        );
        return Scaffold(
          appBar: AppBar(title: Text(currentTitle)),
          drawer: const MainDrawerWidget(),
          body: SafeArea(child: child),
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
              builder: (context, state) => const MeasUnitsWidget(),
            ),
            ShellRoute(
              builder:
                  (context, state, child) => DeviceSettingsMainWidget(child),
              routes: [
                GoRoute(
                  path: "deviceSettings",
                  builder:
                      (context, state) =>
                          const DeviceSettingsNavigationWidget(),
                  routes: [
                    GoRoute(
                      path: "common",
                      builder: (context, state) => const CommonSettingsWidget(),
                    ),
                    GoRoute(
                      path: "measProcs",
                      builder: (context, state) => const MeasProcessSettingsWidget(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const MainPageWidget(),
);

final Map<String, Map<String, String>> _localizedTitles = {
  'en': {
    Routes.home: 'Главная',
    Routes.measUnits: 'Единицы измерения',
    Routes.deviceSettings: 'Настройки прибора',
  },
  'ru': {
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
