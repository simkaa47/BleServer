import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';

class DrawerItem extends ConsumerWidget {
  final String title;
  final String routeName;

  const DrawerItem({
    super.key,
    required this.title,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {    
    final currentRouteName = GoRouter.of(context).state.matchedLocation;   

    return ListTile(
      title: Text(title),
      selectedTileColor: const Color(0xFF28BCBA).withAlpha(80),
      selected: currentRouteName == routeName || (routeName != "/home" && currentRouteName.startsWith(routeName)),
      onTap: () {                        
        if (currentRouteName != routeName) {
         ref.read(appBarActionsProvider.notifier).state = [];
          if(Navigator.canPop(context)){
              Navigator.of(context).pop();
          }          
          context.go(routeName);
        }
      },
    );
  }
}