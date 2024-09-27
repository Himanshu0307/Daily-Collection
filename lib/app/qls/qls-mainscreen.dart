import 'package:daily_collection/app/qls/date-report/date-wise-loan_report.dart';
import 'package:daily_collection/app/qls/get-loan/loan-report.dart';
import 'package:daily_collection/app/qls/add-loan/quickloan-screen.dart';
import 'package:flutter/material.dart';

import '../../Models/SideItem.dart';
import '../../component/side-menubar.dart/side-menu-screen.dart';
import '../../component/ui/inner-sidebar.dart';

class QuickLoanMainScreen extends StatelessWidget {
  static const String routeName = "QuickLoanMainScreen";
  QuickLoanMainScreen({super.key});
  final PageController _controller = PageController();
  void _changeTab(int id) {
    _controller.jumpToPage(id);
  }

  List<SideItem> items = [
    SideItem("New Loan", Icons.add),
    SideItem("Loan Report", Icons.edit_document),
    SideItem("Disbursement Report", Icons.calendar_month_outlined),
    // SideItem("Loan Closure", Icons.delete)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: InnerSidebarWrapper(
      sideWidget: SideWidget(items, _controller),
      child: PageView(
        pageSnapping: true,
        controller: _controller,
        allowImplicitScrolling: false,
        children: const [QuickLoanScreen(), LoanReport(), DateWiseLoanReport()],
      ),
    ));
  }
}
