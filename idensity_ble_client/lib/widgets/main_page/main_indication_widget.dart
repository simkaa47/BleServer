import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/indication/indication.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/widgets/main_page/indication_item_widget.dart';
import 'package:idensity_ble_client/widgets/main_page/meas_result_widget.dart';
import 'package:idensity_ble_client/widgets/routes.dart';

class MainIndicationWidget extends ConsumerWidget {
  const MainIndicationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceService = ref.read(deviceServiceProvider);
    
    return StreamBuilder<List<Device>>(
      stream: deviceService.devicesStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          if (data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      context.go(Routes.scanning);
                    },
                    iconSize: 100,
                    icon: const Icon(Icons.add_circle_rounded),
                  ),
                  const Text("Добавьте устройство для получения данных"),
                ],
              ),
            );
          }
          return PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: deviceService.devices.length,
            itemBuilder: (context, index) {
              final device = deviceService.devices[index];
              return Container(
                alignment: Alignment.bottomCenter,
                child: StreamBuilder<IndicationData>(
                  stream: device.dataStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data!;

                      return Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: IndicationItemWidget(
                                          paramName: "ID",
                                          value: device.name,
                                          icon: Icons.perm_identity,
                                        ),
                                      ),
                                      Expanded(
                                        child: IndicationItemWidget(
                                          paramName: "T, °C, ",
                                          value: data.temperature
                                              .toStringAsFixed(1),
                                          icon: Icons.device_thermostat,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: IndicationItemWidget(
                                          paramName: "HV, В, ",
                                          value: data.hv.toStringAsFixed(1),
                                          icon: Icons.electric_bolt,
                                        ),
                                      ),
                                      Expanded(
                                        child: IndicationItemWidget(
                                          paramName: "ИНТЕНСИВНОСТЬ, ИМП/C, ",
                                          value: data.counters.toStringAsFixed(
                                            1,
                                          ),
                                          icon: Icons.monitor_heart,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Expanded(child: MeasResultWidget(data.measResults[0], device)),
                                Expanded(child: MeasResultWidget(data.measResults[1], device)),
                              ],
                            )
                          ),
                        ],
                      );
                    } else {
                      return const Text('Waiting for data...');
                    }
                  },
                ),
              );
            },
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    context.go(Routes.scanning);
                  },
                  iconSize: 100,
                  icon: const Icon(Icons.add_circle_rounded),
                ),
                const Text("Добавьте устройство для получения данных"),
              ],
            ),
          );
          ;
        }
      },
    );
  }
}
