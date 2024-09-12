import 'package:flutter/material.dart';

class ConstraintUI extends StatelessWidget {
  const ConstraintUI({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 200, child: child);
  }
}
