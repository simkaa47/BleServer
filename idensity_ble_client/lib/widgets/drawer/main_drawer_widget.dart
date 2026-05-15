import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/providers/theme_provider.dart';
import 'package:idensity_ble_client/widgets/drawer/drawer_item_widget.dart';
import 'package:idensity_ble_client/widgets/routes.dart';

class MainDrawerWidget extends ConsumerWidget {
  const MainDrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);
    final cs = Theme.of(context).colorScheme;

    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DrawerHeader(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          cs.primary,
                          cs.primary.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Image.asset('assets/images/konvels_logo.png')],
                      ),
                    ),
                  ),
                  const DrawerItem(title: 'Главная', routeName: Routes.home),
                  const DrawerItem(
                    title: 'Настройки прибора',
                    routeName: Routes.deviceSettings,
                  ),
                  const DrawerItem(
                    title: 'Единицы измерения',
                    routeName: Routes.measUnits,
                  ),
                  const DrawerItem(
                    title: 'Устройства',
                    routeName: Routes.communication,
                  ),
                  const DrawerItem(
                    title: 'История измерений',
                    routeName: Routes.archive,
                  ),
                  const DrawerItem(title: 'Диагностика', routeName: Routes.diagnostic),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.light_mode),
                    color: !isDark ? cs.primary : cs.onSurfaceVariant,
                    onPressed: () {
                      ref.read(themeModeProvider.notifier).state =
                          ThemeMode.light;
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.dark_mode),
                    color: isDark ? cs.primary : cs.onSurfaceVariant,
                    onPressed: () {
                      ref.read(themeModeProvider.notifier).state =
                          ThemeMode.dark;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
