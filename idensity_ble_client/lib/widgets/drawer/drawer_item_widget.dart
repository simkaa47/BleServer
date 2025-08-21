import 'package:flutter/material.dart';

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
      selectedTileColor: Color(0xFF28BCBA).withAlpha(80),
      selected: currentRouteName == routeName,
      onTap: () {        
        Navigator.pop(context);        
        if (currentRouteName != routeName) {
          Navigator.pushNamed(context, routeName);
        }
      },
    );
  }
}