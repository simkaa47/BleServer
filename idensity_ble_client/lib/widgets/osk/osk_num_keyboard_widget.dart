import 'package:flutter/material.dart';

/// Numeric on-screen keyboard for embedded Linux (DRM/kiosk mode).
///
/// Shows a numpad bottom sheet. Returns the confirmed [num] value via [onConfirm].
/// For integer fields, the decimal point and ± keys are hidden.
class OskNumKeyboardWidget extends StatefulWidget {
  const OskNumKeyboardWidget({
    super.key,
    required this.name,
    required this.initialValue,
    this.minValue,
    this.maxValue,
    required this.isInteger,
    required this.onConfirm,
    this.fractionDigits,
  });

  final String name;
  final num initialValue;
  final num? minValue;
  final num? maxValue;
  final bool isInteger;
  final void Function(num value) onConfirm;
  final int? fractionDigits;

  @override
  State<OskNumKeyboardWidget> createState() => _OskNumKeyboardWidgetState();
}

class _OskNumKeyboardWidgetState extends State<OskNumKeyboardWidget> {
  late String _input;
  String? _error;

  @override
  void initState() {
    super.initState();
    _input = widget.fractionDigits != null
        ? widget.initialValue.toStringAsFixed(widget.fractionDigits!)
        : widget.initialValue.toString();
    _validate(_input);
  }

  void _validate(String input) {
    final num? number = num.tryParse(input);
    if (input.isEmpty || input == '-' || number == null) {
      _error = 'Введите число';
      return;
    }
    final min = widget.minValue ?? double.negativeInfinity;
    final max = widget.maxValue ?? double.infinity;
    if (number < min || number > max) {
      _error = 'Диапазон: $min – $max';
      return;
    }
    _error = null;
  }

  void _press(String key) {
    setState(() {
      switch (key) {
        case '⌫':
          if (_input.isNotEmpty) _input = _input.substring(0, _input.length - 1);
        case 'C':
          _input = '';
        case '±':
          _input = _input.startsWith('-') ? _input.substring(1) : '-$_input';
        case '.':
          if (!_input.contains('.')) _input = '$_input.';
        case '00':
          if (_input.isEmpty || _input == '0') {
            _input = '0';
          } else {
            _input = '${_input}00';
          }
        case '✓':
          _tryConfirm();
          return;
        default:
          if (_input == '0') {
            _input = key;
          } else {
            _input = '$_input$key';
          }
      }
      _validate(_input);
    });
  }

  void _tryConfirm() {
    _validate(_input);
    if (_error != null) {
      setState(() {});
      return;
    }
    final num? value = num.tryParse(_input);
    if (value != null) {
      widget.onConfirm(widget.isInteger ? value.toInt() : value.toDouble());
    }
  }

  Widget _key(
    String label, {
    Color? bg,
    Color? fg,
    int flex = 1,
    bool invisible = false,
  }) {
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
    final confirmBg = _error == null ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest;
    final confirmFg = _error == null ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border.all(
                  color: _error != null ? theme.colorScheme.error : theme.colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name,
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: theme.colorScheme.primary)),
                  const SizedBox(height: 4),
                  Text(
                    _input.isEmpty ? '—' : _input,
                    style: theme.textTheme.headlineSmall,
                  ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(_error!,
                          style: TextStyle(
                              color: theme.colorScheme.error, fontSize: 12)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Row 1: 7 8 9 ⌫
            Row(children: [
              _key('7'), _key('8'), _key('9'),
              _key('⌫',
                  bg: theme.colorScheme.errorContainer,
                  fg: theme.colorScheme.onErrorContainer),
            ]),
            // Row 2: 4 5 6 C
            Row(children: [
              _key('4'), _key('5'), _key('6'),
              _key('C',
                  bg: theme.colorScheme.secondaryContainer,
                  fg: theme.colorScheme.onSecondaryContainer),
            ]),
            // Row 3: 1 2 3 ±(or blank)
            Row(children: [
              _key('1'), _key('2'), _key('3'),
              widget.isInteger ? _key('', invisible: true) : _key('±'),
            ]),
            // Row 4: .(or 00) 0 00(or blank) ✓
            Row(children: [
              widget.isInteger ? _key('00') : _key('.'),
              _key('0'),
              widget.isInteger ? _key('', invisible: true) : _key('00'),
              _key('✓', bg: confirmBg, fg: confirmFg),
            ]),
          ],
        ),
      ),
    );
  }
}

/// Shows the numeric OSK as a modal bottom sheet.
/// Returns the confirmed value, or null if dismissed.
Future<num?> showOskNum(
  BuildContext context, {
  required String name,
  required num initialValue,
  num? minValue,
  num? maxValue,
  bool isInteger = false,
  int? fractionDigits,
}) async {
  num? result;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => OskNumKeyboardWidget(
      name: name,
      initialValue: initialValue,
      minValue: minValue,
      maxValue: maxValue,
      isInteger: isInteger,
      fractionDigits: fractionDigits,
      onConfirm: (v) {
        result = v;
        Navigator.of(context).pop();
      },
    ),
  );
  return result;
}
