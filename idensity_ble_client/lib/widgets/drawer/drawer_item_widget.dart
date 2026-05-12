import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final String routeName;

  const DrawerItem({super.key, required this.title, required this.routeName});

  @override
  Widget build(BuildContext context) {
    final currentRouteName = GoRouter.of(context).state.matchedLocation;

    return ListTile(
      title: Text(title),
      dense: false,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 22),
      selectedTileColor: Theme.of(
        context,
      ).colorScheme.primary.withValues(alpha: 0.15),
      selectedColor: Theme.of(context).colorScheme.onSurface,
      selected:
          currentRouteName == routeName ||
          (routeName != "/home" && currentRouteName.startsWith(routeName)),
      onTap: () {
        if (currentRouteName != routeName) {
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }
          context.go(routeName);
        }
      },
    );
  }
}
