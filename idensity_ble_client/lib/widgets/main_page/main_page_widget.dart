import 'package:flutter/material.dart';
import 'package:idensity_ble_client/widgets/main_page/main_drawer_widget.dart';
import 'package:idensity_ble_client/widgets/main_page/main_indication_widget.dart';

class MainPageWidget extends StatelessWidget {
  const MainPageWidget({super.key});

  @override
  Widget build(BuildContext context) {   

    return Scaffold(
      appBar: AppBar(),
      drawer: const MainDrawerWidget(),
      body: SafeArea(child: const MainIndicationWidget()),
    );
  }
}
