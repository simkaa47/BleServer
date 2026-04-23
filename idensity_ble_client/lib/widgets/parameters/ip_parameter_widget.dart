import 'package:flutter/material.dart';
import 'package:idensity_ble_client/resources/platform.dart';
import 'package:idensity_ble_client/widgets/osk/osk_ip_keyboard_widget.dart';

class IpParameterWidget extends StatelessWidget {
  const IpParameterWidget({
    super.key,
    required this.name,
    required this.octets,
    required this.onConfirm,
  });

  final String name;
  final List<int> octets;
  final Future<void> Function(List<int>) onConfirm;

  String? _validate(String input) {
    final parts = input.split('.');
    if (parts.length != 4) return 'Введите 4 октета (например 192.168.1.1)';
    for (final part in parts) {
      final n = int.tryParse(part);
      if (n == null || n < 0 || n > 255) return 'Каждый октет должен быть от 0 до 255';
    }
    return null;
  }

  Future<void> _showDialog(BuildContext context) async {
    final controller = TextEditingController(text: octets.join('.'));
    String? dialogError;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(name),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "0.0.0.0", errorText: dialogError),
            onChanged: (_) => setState(() => dialogError = null),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Отмена")),
            TextButton(
              onPressed: () {
                final err = _validate(controller.text);
                if (err != null) {
                  setState(() => dialogError = err);
                } else {
                  Navigator.pop(ctx, true);
                }
              },
              child: const Text("OK"),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      final parts = controller.text.split('.').map((s) => int.parse(s)).toList();
      await onConfirm(parts);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Text(octets.join('.')),
        onTap: () async {
          if (kShowOsk) {
            final result = await showOskIp(context, name: name, initialOctets: octets);
            if (result != null) await onConfirm(result);
          } else {
            await _showDialog(context);
          }
        },
      ),
    );
  }
}
