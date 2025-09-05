import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/widgets/meas_units/add_edit_meas_unit_widget.dart';
import 'package:idensity_ble_client/widgets/meas_units/meas_unit_item_widget.dart';

class MeasUnitsWidget extends ConsumerWidget {
  const MeasUnitsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitsStreamValue = ref.watch(measUnitsStreamProvider);
    final serviceAsyncValue = ref.watch(measUnitServiceProvider);
    return Column(
      children: [
        IconButton(
          onPressed: () async {
            if (serviceAsyncValue.hasValue) {
              final service = serviceAsyncValue.value!;
              showModalBottomSheet(
                context: context,
                builder: (ctx) {
                  return AddEditMeasUnitWidget(
                    measUnitToSave: null,
                    onSaveMeasUnit: (unit) async {
                      await service.addMeasUnit(unit);
                    },
                  );
                },
              );
            }
          },
          icon: const Icon(Icons.add, size: 50),
        ),
        Expanded(
          child: unitsStreamValue.when(
            loading: () {
              return const Center(child: CircularProgressIndicator());
            },
            error: (err, stack) => Center(child: Text('Error: $err')),
            data: (units) {
              if (serviceAsyncValue.isLoading || serviceAsyncValue.hasError) {
                return const Center(child: CircularProgressIndicator());
              }

              final service = serviceAsyncValue.value!;

              return ListView.builder(
                itemCount: units.length,
                itemBuilder: (context, index) {
                  final unit = units[index];
                  return MeasUnitItemWidget(service: service, measUnit: unit);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
