import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final String routeName;

  const DrawerItem({
    super.key,
    required this.title,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {    
    final currentRouteName = ModalRoute.of(context)?.settings.name;

    return ListTile(
      title: Text(title),
      selectedTileColor: const Color(0xFF28BCBA).withAlpha(80),
      selected: currentRouteName == routeName,
      onTap: () {                        
        if (currentRouteName != routeName) {
           Navigator.of(context).pop();
          context.go(routeName);
        }
      },
    );
  }
}