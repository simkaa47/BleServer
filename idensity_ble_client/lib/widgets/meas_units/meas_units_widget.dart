import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/meas_units/meas_unit.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/services/meas_units/meas_unit_service.dart';
import 'package:idensity_ble_client/widgets/meas_units/add_edit_meas_unit_widget.dart';
import 'package:idensity_ble_client/widgets/meas_units/meas_unit_item_widget.dart';

class MeasUnitsWidget extends ConsumerStatefulWidget {
  const MeasUnitsWidget({super.key});

  @override
  ConsumerState<MeasUnitsWidget> createState() => _MeasUnitsWidgetState();
}

class _MeasUnitsWidgetState extends ConsumerState<MeasUnitsWidget> {
  
  @override
  void initState() {
    super.initState();

    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      ref.read(appBarActionsProvider.notifier).state = [
        IconButton(         
          icon: const Icon(Icons.add),
          onPressed: _onAddPressed,
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final unitsStreamValue = ref.watch(measUnitsStreamProvider);
    final serviceAsyncValue = ref.watch(measUnitServiceProvider);

    return _body(unitsStreamValue, serviceAsyncValue);
  }

  Widget _body(
    AsyncValue<List<MeasUnit>> unitsStreamValue,
    AsyncValue<MeasUnitService> serviceAsyncValue,
  ) {
    return Column(
      children: [
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

  void _onAddPressed() async {
    final serviceAsync = ref.read(measUnitServiceProvider);
    if (!serviceAsync.hasValue) return;
    final service = serviceAsync.value!;
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      builder: (_) => AddEditMeasUnitWidget(
        measUnitToSave: null,
        onSaveMeasUnit: service.addMeasUnit,
      ),
    );
  }
}
