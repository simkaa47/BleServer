import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:idensity_ble_client/app_scroll_behavior.dart';
import 'package:idensity_ble_client/widgets/app_shell.dart';
import 'package:idensity_ble_client/widgets/communication/communication_tab.dart';
import 'package:idensity_ble_client/widgets/device_settings/common/common_settings_widget.dart';
import 'package:idensity_ble_client/widgets/device_settings/device_settings_main_widget.dart';
import 'package:idensity_ble_client/widgets/device_settings/device_settings_navigation_widget.dart';
import 'package:idensity_ble_client/widgets/device_settings/meas_process/fast_changes/fast_changes_parameters_widget.dart';
import 'package:idensity_ble_client/widgets/device_settings/meas_process/meas_process_parameters_widget.dart';
import 'package:idensity_ble_client/widgets/device_settings/meas_process/meas_process_settings_widget.dart';
import 'package:idensity_ble_client/widgets/device_settings/meas_process/standarization/stand_settings_widget.dart';
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
  initialLocation: Routes.home,
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
        return AppShell(title: currentTitle, child: child);
      },
      routes: [
        GoRoute(path: '/', redirect: (context, state) => Routes.home),
        GoRoute(
          path: Routes.home,
          name: "home",
          builder: (context, state) => const MainPageWidget(),
          routes: [
            GoRoute(
              path: "communication",
              builder: (context, state) => const CommunicationTab(),
            ),
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
                    ShellRoute(
                      builder:
                          (context, state, child) =>
                              MeasProcessSettingsWidget(child),
                      routes: [
                        GoRoute(
                          path: "measProcs",
                          builder:
                              (context, state) =>
                                  const MeasProcessParametersWidget(),
                        ),
                        GoRoute(
                          path: "measProcs/fastChange",
                          builder:
                              (context, state) =>
                                  const FastChangesParametersWidget(),
                        ),
                        GoRoute(
                          path: "measProcs/stands",
                          builder:
                              (context, state) =>
                                  const StandSettingsWidget(),
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
    ),
  ],
  errorBuilder: (context, state) => const MainPageWidget(),
);

final Map<String, Map<String, String>> _localizedTitles = {
  'en': {
    Routes.home: 'Главная',
    Routes.measUnits: 'Единицы измерения',
    Routes.deviceSettings: 'Настройки прибора',
    Routes.communication: "Устройства",
  },
  'ru': {
    Routes.home: 'Home',
    Routes.measUnits: 'Meas Units',
    Routes.deviceSettings: 'Device Settings',
    Routes.communication: "Devices",
  },
};

String _getTitleForName(String name, Locale locale) {
  final Map<String, String>? titles = _localizedTitles[locale.languageCode];
  if (titles != null && titles.containsKey(name)) {
    return titles[name]!;
  }
  return 'Приложение';
}
