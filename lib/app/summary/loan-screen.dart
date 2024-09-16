import 'package:flutter/material.dart';

import '../../component/summary/loan-summary-widget.dart';

class LoanScreen extends StatelessWidget {
  static const String routeName = "LoanScreen";
  const LoanScreen({super.key});
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Loan Summary"),
        ),
        body: const LoanSummary());
  }
}
