import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/indication/indication.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/services/device_service.dart';
import 'package:idensity_ble_client/widgets/async_state_handlers/universal_async_handler.dart';
import 'package:idensity_ble_client/widgets/main_page/indication_item_widget.dart';
import 'package:idensity_ble_client/widgets/main_page/meas_result_widget.dart';
import 'package:idensity_ble_client/widgets/routes.dart';

class MainIndicationWidget extends ConsumerWidget {
  const MainIndicationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceServiceAsyncState = ref.watch(deviceServiceProvider);
    final serviceName = "Сервис устройств";

    return deviceServiceAsyncState.when(
      data: (service) => _onHasDeviceService(service),
      error: (e, s) => UniversalAsyncHandler.onError(serviceName, e, s),
      loading: () => UniversalAsyncHandler.onLoading(serviceName),
    );
  }

  Widget _onHasDeviceService(DeviceService deviceService) {
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
                            flex: 2,
                            child: Column(
                              children: [
                                
                                Expanded(                                  
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap:
                                              () =>
                                                  deviceService.switchMeasState(
                                                    !data.isMeasuringState,
                                                    device,
                                                  ),
                                          child: Container(
                                            margin: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color:
                                                  data.isMeasuringState
                                                      ? Colors.green.shade300
                                                      : const Color.fromARGB(
                                                        255,
                                                        216,
                                                        214,
                                                        210,
                                                      ),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Text(
                                                  data.isMeasuringState
                                                      ? 'ВЫКЛЮЧИТЬ\nИЗМЕРЕНИЯ'
                                                      : 'ВКЛЮЧИТЬ\nИЗМЕРЕНИЯ',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
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
                          Builder(
                            builder: (context) {
                              final activeResults =
                                  data.measResults
                                      .where((r) => r.isActive)
                                      .toList();
                              if (activeResults.isEmpty)
                                return const SizedBox.shrink();
                              return Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children:
                                            activeResults
                                                .map(
                                                  (r) => Expanded(
                                                    child: MeasResultWidget(
                                                      r,
                                                      device,
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8, top: 2),
                              child: StreamBuilder<bool>(
                                stream: device.connectionStream,
                                initialData: device.isConnected,
                                builder: (context, snapshot) {
                                  final connected = snapshot.data ?? false;
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: connected ? Colors.green : Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        device.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
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
