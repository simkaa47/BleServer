import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/charts/curve_data.dart';
import 'package:idensity_ble_client/widgets/meas_units/meas_unit_item_widget.dart';


class CurveIndicator extends StatelessWidget {
  final CurveData curve;

  const CurveIndicator({super.key, required this.curve});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: curve.rightAxis ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!curve.rightAxis) _getColorIndicator(curve),
        Text('${curve.deviceName} - ${curve.curveName}'),
        if(curve.measUnit!=null)
        const Text(', '),
        if(curve.measUnit!=null)
          MeasUnitItemWidget.getFormula(curve.measUnit!.name, fontSize: 14),
        if (curve.rightAxis) _getColorIndicator(curve),
      ],
    );
  }

  Widget _getColorIndicator(CurveData curve) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: CircleAvatar(backgroundColor: curve.color, maxRadius: 10),
    );
  } 

}
