import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
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
            return ChartSettingsItem(
              settingsService: chartServiceAsyncValue.value!,
              settings: setting,
              deviceService: deviceService,
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
}
