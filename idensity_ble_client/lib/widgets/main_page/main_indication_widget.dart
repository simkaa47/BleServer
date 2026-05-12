// lib/widgets/main_page/main_indication_widget.dart
// Rewritten to match the mock:
//  - 2x2 grid: [ON/OFF button | T°C] / [HV | INTENSIVITY]
//  - ON/OFF is a FilledButton with primary/error colour, NOT a plain coloured Container
//  - tiles use the rewritten IndicationItemWidget
//  - bottom: meas results stack (one per active result)
//  - footer: connection dot + device name in muted colour

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
    const serviceName = "Сервис устройств";

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
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _EmptyDevicesPlaceholder();
        }
        return PageView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: deviceService.devices.length,
          itemBuilder: (context, index) {
            final device = deviceService.devices[index];
            return StreamBuilder<IndicationData>(
              stream: device.dataStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: Text('Waiting for data...'));
                }
                final data = snapshot.data!;
                final activeResults =
                    data.measResults.where((r) => r.isActive).toList();

                return Column(
                  children: [
                    // ─── Tiles (2x2) ─────────────────────────────
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: _MeasToggleTile(
                                    on: data.isMeasuringState,
                                    onTap: () => deviceService.switchMeasState(
                                      !data.isMeasuringState,
                                      device,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: IndicationItemWidget(
                                    paramName: "T, °C",
                                    value: data.temperature.toStringAsFixed(1),
                                    icon: Icons.device_thermostat,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: IndicationItemWidget(
                                    paramName: "HV, В",
                                    value: data.hv.toStringAsFixed(1),
                                    icon: Icons.electric_bolt,
                                  ),
                                ),
                                Expanded(
                                  child: IndicationItemWidget(
                                    paramName: "ИНТЕНСИВНОСТЬ, ИМП/C",
                                    value: data.counters.toStringAsFixed(1),
                                    icon: Icons.monitor_heart,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ─── Meas result(s) ──────────────────────────
                    if (activeResults.isNotEmpty)
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: activeResults
                              .map((r) => Expanded(
                                  child: MeasResultWidget(r, device)))
                              .toList(),
                        ),
                      ),

                    // ─── Footer: connection status ───────────────
                    _ConnectionFooter(device: device),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

// ─── ON/OFF measurement tile ────────────────────────────────
class _MeasToggleTile extends StatelessWidget {
  const _MeasToggleTile({required this.on, required this.onTap});
  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // ON → measurement running → button SAYS "ВЫКЛЮЧИТЬ" → use error tone.
    // OFF → measurement idle    → button SAYS "ВКЛЮЧИТЬ"  → use primary tone.
    final bg = on ? cs.errorContainer : cs.primaryContainer;
    final fg = on ? cs.onErrorContainer : cs.onPrimaryContainer;
    final icon = on ? Icons.stop_circle : Icons.play_circle;
    final label = on ? 'ВЫКЛЮЧИТЬ\nИЗМЕРЕНИЯ' : 'ВКЛЮЧИТЬ\nИЗМЕРЕНИЯ';

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: cs.outline),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: fg, size: 22),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: fg,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Footer ──────────────────────────────────────────────────
class _ConnectionFooter extends StatelessWidget {
  const _ConnectionFooter({required this.device});
  final Device device;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 12, top: 4, bottom: 4),
        child: StreamBuilder<bool>(
          stream: device.connectionStream,
          initialData: device.isConnected,
          builder: (context, snapshot) {
            final connected = snapshot.data ?? false;
            final dotColor = connected ? const Color(0xFF26A269) : cs.error;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration:
                      BoxDecoration(color: dotColor, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text(
                  device.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─── Empty placeholder ──────────────────────────────────────
class _EmptyDevicesPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => context.go(Routes.scanning),
            iconSize: 100,
            color: cs.primary,
            icon: const Icon(Icons.add_circle_rounded),
          ),
          const SizedBox(height: 8),
          Text(
            "Добавьте устройство для получения данных",
            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
