import 'package:flutter/material.dart';

import '../../Models/SideItem.dart';
import '../../component/side-menubar.dart/side-menu-screen.dart';
import '../../component/ui/inner-sidebar.dart';
import 'add-collection/collection-add.dart';
import 'date-report/datewise-collection-report.dart';
import 'get-collection/report-widget.dart';

class CollectionScreen extends StatelessWidget {
  static const String routeName = "CollectionScreen";
  CollectionScreen({super.key});
  final PageController _controller = PageController();
  void _changeTab(int id) {
    _controller.jumpToPage(id);
  }

  final List<SideItem> items = [
    SideItem("Deposite", Icons.add),
    SideItem("Collection Report", Icons.edit_document),
    SideItem("Total Collection Report", Icons.calendar_month_outlined),
    SideItem("DR/CR Report", Icons.preview),
    // SideItem("Loan Closure", Icons.delete)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: InnerSidebarWrapper(
            sideWidget: SideWidget(items, _controller),
            child: PageView(
              pageSnapping: false,
              controller: _controller,
              allowImplicitScrolling: false,
              children: const [
                CollectionAddWidget(),
                CollectionReport(),
                DateWiseCollectionReport(),
                // TransactionReportDateWise(),
              ],
            )));
  }
}
