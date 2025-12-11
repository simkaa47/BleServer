import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/widgets/main_page/charts/chart_settings_item.dart';

class EditChartsSettingsWidget extends ConsumerWidget {
  const EditChartsSettingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartServiceAsyncValue = ref.read(chartSettingsServiceProvider);
    final chartSettingsStream = ref.watch(chartSettingsStreamProvider);

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
              service: chartServiceAsyncValue.value!,
              settings: setting,
            );
          },
        );
      },
    );

    return Column(
      children: <Widget>[
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
