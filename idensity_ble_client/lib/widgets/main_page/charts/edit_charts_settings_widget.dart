import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/charts/chart_settings.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/services/charts/charts_settings_service.dart';
import 'package:idensity_ble_client/widgets/main_page/charts/add_edit_chart_settings_item_widget.dart';
import 'package:idensity_ble_client/widgets/main_page/charts/chart_settings_item.dart';

class EditChartsSettingsWidget extends ConsumerWidget {
  const EditChartsSettingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartServiceAsyncValue = ref.read(chartSettingsServiceProvider);
    final chartSettingsStream = ref.watch(chartSettingsStreamProvider);
    final deviceService = ref.watch(deviceServiceProvider);

    final mainContentWinget = chartSettingsStream.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (error, stackTrace) => Center(
            child: Text(
              'Ошибка загрузки списка: $error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      data: (chartSettingsList) {
        if (!chartServiceAsyncValue.hasValue) {
          return const Center(child: Text('Ожидание настроек сервиса...'));
        }
        if (chartSettingsList.isEmpty) {
          return const Center(child: Text('Список настроек пуст.'));
        }
        // Если все загружено и есть данные: выводим список
        return ListView.builder(
          itemCount: chartSettingsList.length,
          itemBuilder: (context, index) {
            final setting = chartSettingsList[index];
            return Dismissible(
              background: _getBackground(DismissDirection.startToEnd),
              secondaryBackground: _getBackground(DismissDirection.endToStart),
              key: ValueKey(chartSettingsList[index]),
              child: ChartSettingsItem(
                settingsService: chartServiceAsyncValue.value!,
                settings: setting,
                deviceService: deviceService,
              ),
              onDismissed: (direction) async {
                await deleteSettings(
                  context,
                  chartServiceAsyncValue.value!,
                  chartSettingsList[index],
                );
              },
            );
          },
        );
      },
    );

    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(20.0),
          child: IconButton(
            onPressed: () async {
              if (chartServiceAsyncValue.hasValue) {
                final service = chartServiceAsyncValue.value!;
                showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return AddEditChartSettingsItemWidget(
                      deviceNames:
                          deviceService.devices.map((d) => d.name).toList(),
                      onSave: (s) async {
                        await service.addSettings(s);
                      },
                    );
                  },
                );
              }
            },
            icon: const Icon(Icons.add, size: 50),
          ),
        ),
        Expanded(flex: 1, child: Container(child: mainContentWinget)),

        Container(
          padding: const EdgeInsets.all(20.0),
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Закрыть"),
          ),
        ),
      ],
    );
  }

  Future<void> deleteSettings(
    BuildContext context,
    ChartsSettingsService service,
    ChartSettings settings,
  ) async {
    try {
      await service.deleteSettings(settings);
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            persist: false,
            content: const Text("Данные удалены"),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: "Отменить",
              onPressed: () async {
                await service.addSettings(settings);
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("Ошибка  - $e"),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Widget _getBackground(DismissDirection direction) {
    return Container(
      color: Colors.red,      
      alignment: direction == DismissDirection.startToEnd ?  Alignment.centerLeft : Alignment.centerRight,
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: const Icon(Icons.delete, color: Colors.white, size: 30),
    );
  }
}
