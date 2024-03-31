import 'package:flutter/material.dart';

import '../../Models/SideItem.dart';
import 'LoanList/LoanList.dart';

class LoanScreen extends StatelessWidget {
  static const String routeName = "LoanScreen";
  LoanScreen({super.key});
  final PageController _controller = PageController();
  void _changeTab(int id) {
    _controller.jumpToPage(id);
  }

  List<SideItem> items = [SideItem("View Loan", Icons.view_agenda)];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Loan Information"),
        ),
        body: const LoanList());
  }
}
