import 'package:flutter/material.dart';
import 'package:idensity_ble_client/resources/platform.dart';
import 'package:idensity_ble_client/widgets/osk/osk_qwerty_keyboard_widget.dart';

/// Drop-in replacement for [TextField] / [TextFormField] that shows an OSK
/// on embedded Linux (DRM/kiosk) and falls back to the system keyboard elsewhere.
///
/// Usage: replace `TextField(controller: ctrl, ...)` with
/// `OskTextField(controller: ctrl, ...)` — all other parameters are the same.
class OskTextField extends StatelessWidget {
  const OskTextField({
    super.key,
    required this.controller,
    this.decoration,
    this.label,
    this.keyboardType,
    this.maxLength,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
    this.style,
    this.textInputAction,
    this.onEditingComplete,
  });

  final TextEditingController controller;
  final InputDecoration? decoration;
  final String? label;
  final TextInputType? keyboardType;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final int? maxLines;
  final TextStyle? style;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    if (!kShowOsk) {
      return TextField(
        controller: controller,
        decoration: decoration,
        keyboardType: keyboardType,
        maxLength: maxLength,
        onChanged: onChanged,
        enabled: enabled,
        maxLines: maxLines,
        style: style,
        textInputAction: textInputAction,
        onEditingComplete: onEditingComplete,
      );
    }

    // In DRM mode: show a read-only-looking field, open OSK on tap.
    return GestureDetector(
      onTap: enabled
          ? () async {
              final result = await showOskText(
                context,
                label: label ??
                    (decoration?.labelText) ??
                    (decoration?.hintText) ??
                    '',
                initialValue: controller.text,
                maxLength: maxLength,
              );
              if (result != null) {
                controller.text = result;
                onChanged?.call(result);
              }
            }
          : null,
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          decoration: decoration,
          keyboardType: keyboardType,
          maxLength: maxLength,
          enabled: enabled,
          maxLines: maxLines,
          style: style,
          // Do not wire onChanged/onEditingComplete — updates go through OSK.
        ),
      ),
    );
  }
}

/// Drop-in replacement for [TextFormField] with OSK support.
class OskFormField extends FormField<String> {
  OskFormField({
    super.key,
    required TextEditingController controller,
    InputDecoration? decoration,
    String? label,
    int? maxLength,
    ValueChanged<String>? onChanged,
    super.validator,
    super.enabled = true,
    int? maxLines = 1,
    TextStyle? style,
  }) : super(
          initialValue: controller.text,
          builder: (field) {
            return OskTextField(
              controller: controller,
              decoration: (decoration ?? const InputDecoration()).copyWith(
                errorText: field.errorText,
              ),
              label: label,
              maxLength: maxLength,
              onChanged: (v) {
                field.didChange(v);
                onChanged?.call(v);
              },
              enabled: field.widget.enabled,
              maxLines: maxLines,
              style: style,
            );
          },
        );
}
