import 'package:flutter/material.dart';

class TextFieldForm extends StatelessWidget {
  final bool required;
  final bool enabled;
  final String text;
  final TextInputType type;
  final TextEditingController? controller;
  final Function(String value)? onChanged;
  final FocusNode? focusNode;
  final Function(dynamic value)? validator;

  final String? initialValue;

  const TextFieldForm(this.text,
      {super.key,
      this.enabled = true,
      this.required = false,
      this.type = TextInputType.name,
      this.onChanged,
      this.focusNode,
      this.controller,
      this.initialValue,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        enabled: enabled,
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(labelText: text),
        keyboardType: type,
        validator: (value) {
          if (required && (value == null || value.isEmpty)) return "*Required";
          if (validator != null) return validator!(value);
          return null;
        },
      ),
    );
  }
}
