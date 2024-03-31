import 'package:daily_collection/UI/QuickLoan/DateWiseLoan/DateWiseLoanReport.dart';
import 'package:daily_collection/UI/QuickLoan/LoanInfo/LoanReport.dart';
import 'package:daily_collection/UI/QuickLoan/NewLoan/QuickLoanScreen.dart';
import 'package:flutter/material.dart';

import '../../Models/SideItem.dart';
import '../Component/SideWidget.dart';

class QuickLoanMainScreen extends StatelessWidget {
  static const String routeName = "QuickLoanMainScreen";
  QuickLoanMainScreen({super.key});
  final PageController _controller = PageController();
  void _changeTab(int id) {
    _controller.jumpToPage(id);
  }

  List<SideItem> items = [
    SideItem("Add Loan", Icons.add),
    SideItem("Loan Information A/c Loan Id", Icons.edit_document),
    SideItem("Loan Report A/c Date", Icons.calendar_month_outlined),
    // SideItem("Loan Closure", Icons.delete)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        Expanded(flex: 1, child: SideWidget(items, _controller)),
        Expanded(
            flex: 3,
            child: PageView(
              pageSnapping: true,
              controller: _controller,
              allowImplicitScrolling: false,
              children: const [QuickLoanScreen(), LoanReport(), DateWiseLoanReport()],
            )),
      ],
    ));
  }
}
