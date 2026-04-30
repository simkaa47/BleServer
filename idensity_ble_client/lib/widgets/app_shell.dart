import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/widgets/drawer/main_drawer_widget.dart';
import 'package:idensity_ble_client/widgets/routes.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.title, required this.child});

  final Widget child;
  final String title;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell>
    with SingleTickerProviderStateMixin {
  RouterDelegate<Object>? _routerDelegate;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routerDelegate?.removeListener(_onRouteChanged);
    _routerDelegate = GoRouter.of(context).routerDelegate;
    _routerDelegate!.addListener(_onRouteChanged);
  }

  @override
  void dispose() {
    _routerDelegate?.removeListener(_onRouteChanged);
    _pulseController.dispose();
    super.dispose();
  }

  void _onRouteChanged() {
    ref.read(appBarActionsProvider.notifier).state = [];
  }

  @override
  Widget build(BuildContext context) {
    final actions = ref.watch(appBarActionsProvider);
    final hasErrors = ref.watch(diagnosticAllActiveEventsProvider).whenOrNull(
          data: (events) => events.isNotEmpty,
        ) ??
        false;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (hasErrors) _DiagnosticWarningButton(animation: _pulseAnimation),
          ...actions,
        ],
        iconTheme: const IconThemeData(size: 40),
        toolbarHeight: 60,
        surfaceTintColor: Colors.amber,
        actionsIconTheme: const IconThemeData(size: 40),
        actionsPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      ),
      drawer: const MainDrawerWidget(),
      body: SafeArea(child: widget.child),
    );
  }
}

class _DiagnosticWarningButton extends StatelessWidget {
  const _DiagnosticWarningButton({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Ошибки диагностики',
      onPressed: () => context.go(Routes.diagnostic),
      icon: FadeTransition(
        opacity: animation,
        child: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
          size: 36,
        ),
      ),
    );
  }
}
