import 'package:flutter/material.dart';

class SizedInputBox extends StatelessWidget {
  final double width;

  final bool required;

  final TextInputType type;

  final String text;

  const SizedInputBox(this.text,
      {this.width = 0.5,
      super.key,
      this.required = false,
      this.type = TextInputType.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        height: MediaQuery.of(context).size.width * width,
        child: TextFormField(
          decoration: InputDecoration(hintText: text),
          keyboardType: type,
          validator: (value) {
            if (value == null || value.isEmpty) return "*Required";
            return null;
          },
        ),
      ),
    );
  }
}
