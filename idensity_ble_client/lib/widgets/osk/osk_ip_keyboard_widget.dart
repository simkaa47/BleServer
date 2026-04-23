import 'package:flutter/material.dart';

class OskIpKeyboardWidget extends StatefulWidget {
  const OskIpKeyboardWidget({
    super.key,
    required this.name,
    required this.initialOctets,
    required this.onConfirm,
  });

  final String name;
  final List<int> initialOctets;
  final void Function(List<int>) onConfirm;

  @override
  State<OskIpKeyboardWidget> createState() => _OskIpKeyboardWidgetState();
}

class _OskIpKeyboardWidgetState extends State<OskIpKeyboardWidget> {
  late List<String> _inputs;
  int _focused = 0;

  @override
  void initState() {
    super.initState();
    _inputs = widget.initialOctets.map((o) => o.toString()).toList();
  }

  String? _errorFor(String input) {
    final n = int.tryParse(input);
    if (input.isEmpty) return 'empty';
    if (n == null || n < 0 || n > 255) return 'invalid';
    return null;
  }

  bool get _allValid => _inputs.every((s) => _errorFor(s) == null);

  void _press(String key) {
    setState(() {
      final cur = _inputs[_focused];
      switch (key) {
        case '⌫':
          if (cur.isNotEmpty) _inputs[_focused] = cur.substring(0, cur.length - 1);
        case 'C':
          _inputs[_focused] = '';
        case '✓':
          _tryConfirm();
          return;
        case '→':
          if (_focused < 3) _focused++;
        default:
          final next = cur == '0' ? key : '$cur$key';
          final n = int.tryParse(next);
          if (n != null && n <= 255) {
            _inputs[_focused] = next;
            // auto-advance when octet is full (3 digits or value forces it)
            if (next.length == 3 && _focused < 3) _focused++;
          }
      }
    });
  }

  void _tryConfirm() {
    if (!_allValid) return;
    widget.onConfirm(_inputs.map((s) => int.parse(s)).toList());
  }

  Widget _key(String label, {Color? bg, Color? fg, int flex = 1, bool invisible = false}) {
    final theme = Theme.of(context);
    if (invisible) return Expanded(flex: flex, child: const SizedBox());
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bg ?? theme.colorScheme.surfaceContainerHighest,
            foregroundColor: fg ?? theme.colorScheme.onSurface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 2,
          ),
          onPressed: () => _press(label),
          child: Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final confirmBg = _allValid ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest;
    final confirmFg = _allValid ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // IP display
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name,
                      style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < 4; i++) ...[
                        GestureDetector(
                          onTap: () => setState(() => _focused = i),
                          child: Container(
                            width: 60,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: _focused == i
                                  ? theme.colorScheme.primaryContainer
                                  : theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: _focused == i
                                    ? theme.colorScheme.primary
                                    : (_errorFor(_inputs[i]) != null
                                        ? theme.colorScheme.error
                                        : Colors.transparent),
                                width: 2,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _inputs[i].isEmpty ? '—' : _inputs[i],
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: _focused == i
                                    ? theme.colorScheme.onPrimaryContainer
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                        if (i < 3)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text('.', style: theme.textTheme.titleLarge),
                          ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(children: [_key('7'), _key('8'), _key('9'), _key('⌫', bg: theme.colorScheme.errorContainer, fg: theme.colorScheme.onErrorContainer)]),
            Row(children: [_key('4'), _key('5'), _key('6'), _key('C', bg: theme.colorScheme.secondaryContainer, fg: theme.colorScheme.onSecondaryContainer)]),
            Row(children: [_key('1'), _key('2'), _key('3'), _key('→')]),
            Row(children: [_key('', invisible: true), _key('0'), _key('', invisible: true), _key('✓', bg: confirmBg, fg: confirmFg)]),
          ],
        ),
      ),
    );
  }
}

Future<List<int>?> showOskIp(
  BuildContext context, {
  required String name,
  required List<int> initialOctets,
}) async {
  List<int>? result;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => OskIpKeyboardWidget(
      name: name,
      initialOctets: initialOctets,
      onConfirm: (octets) {
        result = octets;
        Navigator.of(context).pop();
      },
    ),
  );
  return result;
}
