import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/widgets/drawer/main_drawer_widget.dart';

class MeasUnitsWidget extends ConsumerWidget {
  const MeasUnitsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("ЕДИНИЦЫ ИЗМЕРЕНИЯ"),),
      drawer: const MainDrawerWidget(),
      body: SafeArea(
        child: const Text("ЕИ")
      ),
    );
  }
}