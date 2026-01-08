import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/widgets/drawer/main_drawer_widget.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.title, required this.child});

  final Widget child;

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.watch(appBarActionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
        iconTheme: const IconThemeData(size: 40),
        toolbarHeight: 60,
        surfaceTintColor: Colors.amber,
        actionsIconTheme: const IconThemeData(size: 40),
        actionsPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      ),
      drawer: const MainDrawerWidget(),
      
      body: SafeArea(child: child),
    );
  }
}
