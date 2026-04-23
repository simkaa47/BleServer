import 'package:flutter/material.dart';

/// Full QWERTY on-screen keyboard for embedded Linux (DRM/kiosk mode).
///
/// Shows a text bottom sheet. Returns the confirmed [String] value via [onConfirm].
class OskQwertyKeyboardWidget extends StatefulWidget {
  const OskQwertyKeyboardWidget({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onConfirm,
    this.maxLength,
  });

  final String label;
  final String initialValue;
  final void Function(String value) onConfirm;
  final int? maxLength;

  @override
  State<OskQwertyKeyboardWidget> createState() => _OskQwertyKeyboardWidgetState();
}

enum _OskLayer { letters, numbers }

class _OskQwertyKeyboardWidgetState extends State<OskQwertyKeyboardWidget> {
  late String _input;
  bool _caps = false;
  bool _capsLock = false;
  _OskLayer _layer = _OskLayer.letters;

  static const _row1 = ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'];
  static const _row2 = ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'];
  static const _row3 = ['z', 'x', 'c', 'v', 'b', 'n', 'm'];
  static const _numRow1 = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
  static const _numRow2 = ['-', '/', ':', ';', '(', ')', '₽', '&', '@', '"'];
  static const _numRow3 = ['.', ',', '?', '!', "'", '_', '+', '='];

  @override
  void initState() {
    super.initState();
    _input = widget.initialValue;
  }

  bool get _shift => _caps || _capsLock;

  String _applyShift(String ch) => _shift ? ch.toUpperCase() : ch;

  void _pressChar(String ch) {
    if (widget.maxLength != null && _input.length >= widget.maxLength!) return;
    setState(() {
      _input += _applyShift(ch);
      if (_caps && !_capsLock) _caps = false;
    });
  }

  void _pressBackspace() {
    if (_input.isEmpty) return;
    setState(() => _input = _input.substring(0, _input.length - 1));
  }

  void _pressCaps() {
    setState(() {
      if (_capsLock) {
        _caps = false;
        _capsLock = false;
      } else if (_caps) {
        _capsLock = true;
      } else {
        _caps = true;
      }
    });
  }

  void _pressConfirm() {
    widget.onConfirm(_input);
  }

  Widget _charKey(String ch, {double fontSize = 16}) {
    final theme = Theme.of(context);
    final label = _layer == _OskLayer.letters ? _applyShift(ch) : ch;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            foregroundColor: theme.colorScheme.onSurface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            padding: const EdgeInsets.symmetric(vertical: 12),
            elevation: 1,
            minimumSize: Size.zero,
          ),
          onPressed: () => _pressChar(ch),
          child: Text(label, style: TextStyle(fontSize: fontSize)),
        ),
      ),
    );
  }

  Widget _actionKey(
    String label,
    VoidCallback onTap, {
    Color? bg,
    Color? fg,
    int flex = 2,
    double fontSize = 14,
  }) {
    final theme = Theme.of(context);
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bg ?? theme.colorScheme.secondaryContainer,
            foregroundColor: fg ?? theme.colorScheme.onSecondaryContainer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            padding: const EdgeInsets.symmetric(vertical: 12),
            elevation: 1,
            minimumSize: Size.zero,
          ),
          onPressed: onTap,
          child: Text(label, style: TextStyle(fontSize: fontSize)),
        ),
      ),
    );
  }

  List<Widget> _buildRow(List<String> chars) =>
      chars.map((ch) => _charKey(ch)).toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final row1 = _layer == _OskLayer.letters ? _row1 : _numRow1;
    final row2 = _layer == _OskLayer.letters ? _row2 : _numRow2;
    final row3 = _layer == _OskLayer.letters ? _row3 : _numRow3;

    final capsColor = _capsLock
        ? theme.colorScheme.primary
        : _caps
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.secondaryContainer;
    final capsFg = _capsLock
        ? theme.colorScheme.onPrimary
        : _caps
            ? theme.colorScheme.onPrimaryContainer
            : theme.colorScheme.onSecondaryContainer;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.label,
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: theme.colorScheme.primary)),
                  const SizedBox(height: 4),
                  Text(
                    _input.isEmpty ? '—' : _input,
                    style: theme.textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Rows
            Row(children: _buildRow(row1)),
            Row(children: [
              const Expanded(flex: 1, child: SizedBox()),
              ..._buildRow(row2),
              const Expanded(flex: 1, child: SizedBox()),
            ]),
            Row(children: [
              if (_layer == _OskLayer.letters)
                _actionKey(
                  _capsLock ? '⇪' : '⇧',
                  _pressCaps,
                  bg: capsColor,
                  fg: capsFg,
                  flex: 2,
                ),
              ..._buildRow(row3),
              _actionKey(
                '⌫',
                _pressBackspace,
                bg: theme.colorScheme.errorContainer,
                fg: theme.colorScheme.onErrorContainer,
                flex: 2,
              ),
            ]),
            // Bottom row
            Row(children: [
              _actionKey(
                _layer == _OskLayer.letters ? '123' : 'АБВ',
                () => setState(() => _layer = _layer == _OskLayer.letters
                    ? _OskLayer.numbers
                    : _OskLayer.letters),
                flex: 2,
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      foregroundColor: theme.colorScheme.onSurface,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 1,
                    ),
                    onPressed: () => _pressChar(' '),
                    child: const Text('пробел', style: TextStyle(fontSize: 14)),
                  ),
                ),
              ),
              _actionKey(
                '✓',
                _pressConfirm,
                bg: theme.colorScheme.primary,
                fg: theme.colorScheme.onPrimary,
                flex: 2,
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

/// Shows the QWERTY OSK as a modal bottom sheet.
/// Returns the confirmed string, or null if dismissed.
Future<String?> showOskText(
  BuildContext context, {
  required String label,
  String initialValue = '',
  int? maxLength,
}) async {
  String? result;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => OskQwertyKeyboardWidget(
      label: label,
      initialValue: initialValue,
      maxLength: maxLength,
      onConfirm: (v) {
        result = v;
        Navigator.of(context).pop();
      },
    ),
  );
  return result;
}
