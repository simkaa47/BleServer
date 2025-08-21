import 'package:flutter/material.dart';
import 'package:idensity_ble_client/widgets/drawer/drawer_item_widget.dart';
import 'package:idensity_ble_client/widgets/routes.dart';

class MainDrawerWidget extends StatelessWidget {
  const MainDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),            
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF28BCBA),
                  const Color(0xFF28BCBA).withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [                
                  Image.asset('assets/images/konvels_logo.png')
                ],
              ),
            ),
          ),
          const DrawerItem(title: 'Главная', routeName: Routes.home),
          const DrawerItem(title: 'Настройки прибора', routeName: Routes.deviceSettings),
          const DrawerItem(title: 'Единицы измерения', routeName: Routes.measUnits),
        ],
      ),
    );
  }
}
