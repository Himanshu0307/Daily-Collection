import 'package:flutter/material.dart';

import '../../component/cashflow/cashflow-widget.dart';

class CashflowScreen extends StatelessWidget {
  const CashflowScreen({super.key});
  static const String routeName = "Cashflow";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Cash Flow Summary"),
        ),
        body: const CashflowWidget());
  }
}
