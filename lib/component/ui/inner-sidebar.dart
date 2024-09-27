import 'package:flutter/material.dart';

import '../side-menubar.dart/side-menu-screen.dart';

class InnerSidebarWrapper extends StatelessWidget {
  const InnerSidebarWrapper(
      {super.key, required this.child, required this.sideWidget});
  final Widget child;
  final Widget sideWidget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: sideWidget,
        ),
        Expanded(child: child)
      ],
    );
  }
}
