import 'package:flutter/material.dart';

import '../../Models/SideItem.dart';
import '../../component/side-menubar.dart/side-menu-screen.dart';
import 'add-collection/collection-add.dart';


class CollectionScreen extends StatelessWidget {
  static const String routeName = "CollectionScreen";
  CollectionScreen({super.key});
  final PageController _controller = PageController();
  void _changeTab(int id) {
    _controller.jumpToPage(id);
  }

  final List<SideItem> items = [
    SideItem("Add Collection", Icons.add),
    SideItem("Collection Report A/c Loan ID", Icons.edit_document),
    SideItem("Collection Report A/c Date", Icons.calendar_month_outlined),
    SideItem("Transaction Report A/c Date", Icons.calendar_month_outlined),
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
              pageSnapping: false,
              controller: _controller,
              allowImplicitScrolling: false,
              children: const [
                CollectionAddWidget(),
                // CollectionReport(),
                // DateWiseCollectionReport(),
                // TransactionReportDateWise(),
              ],
            )),
      ],
    ));
  }
}
