import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/meas_units/meas_unit.dart';
import 'package:idensity_ble_client/resources/enums.dart';
import 'package:idensity_ble_client/services/meas_units/meas_unit_service.dart';
import 'package:idensity_ble_client/widgets/meas_units/add_edit_meas_unit_widget.dart';

class MeasUnitItemWidget extends StatelessWidget {
  const MeasUnitItemWidget({
    super.key,
    required this.service,
    required this.measUnit,
  });

  final MeasUnitService service;
  final MeasUnit measUnit;

  static Widget getFormula(String text, {double fontSize=32}) {
    final list = text.split('^').where((s) => s.isNotEmpty).toList();
    return RichText(
      text: TextSpan(
        style:  TextStyle(fontSize: fontSize, color: Colors.black),
        children: <InlineSpan>[
          for (int i = 1; i <= list.length; i++) ...[
            // Добавляем проверку, чтобы не добавлять смещение для первого элемента
            if (i % 2 == 0)
              WidgetSpan(
                child: Transform.translate(
                  offset: const Offset(0.0, -10.0), // Смещаем вверх
                  child: Text(
                    list[i - 1],
                    style:  TextStyle(fontSize: fontSize/1.5, color: Colors.black),
                  ),
                ),
              ),
            if (i % 2 == 1)
              TextSpan(
                text: list[i - 1],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
          ],
        ],
      ),
    );
  }

  void onError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Ошибка удаления из базы данных!',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: getFormula(measUnit.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("К = ${measUnit.coeff}"),
            Text("Смещение = ${measUnit.offset}"),
            Text(
              "Тип прибора = ${getByIndexFromList(measUnit.deviceMode.index, devicesTypes)}",
            ),
            Text(
              "Тип измерения = ${getMeasMode(measUnit.deviceMode.index, measUnit.measMode)}",
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!measUnit.userCantDelete)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  try {
                    var result = await service.deleteMeasUnit(measUnit);
                    if (result) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 3),
                            content: Text(
                              'Единица измерения "${measUnit.name}" удалена!',
                            ),
                            action: SnackBarAction(label: "Отменить", onPressed: () async{
                              await service.addMeasUnit(measUnit);
                            },),
                          ),
                        );
                      }
                    } else {
                      if (context.mounted) onError(context);
                    }
                  } catch (e) {
                    if (context.mounted) onError(context);
                  }
                },
              ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return AddEditMeasUnitWidget(
                      measUnitToSave: measUnit,
                      onSaveMeasUnit: (unit) async {
                        await service.editMeasUnit(unit);
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
