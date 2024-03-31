import 'package:flutter/material.dart';

class RadioComponent extends StatelessWidget {
  final String text;
  final dynamic value;
  final dynamic groupValue;

  const RadioComponent(
      {super.key,
      this.value,
      this.groupValue,
      required this.text,
      required this.onChanged});

  final Function(dynamic) onChanged;

  @override
  Widget build(BuildContext context) {
    return RadioMenuButton(
        toggleable: false,
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        child: Text(text));
  }
}
