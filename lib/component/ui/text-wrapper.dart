import 'package:flutter/material.dart';

class BoldTextWrapper extends StatelessWidget {
  const BoldTextWrapper(this.text, {super.key, this.size = 30});
  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: size, fontWeight: FontWeight.w900),
    );
  }
}
