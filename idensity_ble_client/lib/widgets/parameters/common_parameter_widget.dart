import 'package:flutter/material.dart';

class CommonParameterWidget extends StatelessWidget {
  const CommonParameterWidget({
    super.key,
    required this.name,
    required this.value,
    required this.onConfirm,
  });

  final String name;
  final String value;
  final void Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    return Card(child: ListTile(title: Text(name), subtitle: Text(value)));
  }
}
