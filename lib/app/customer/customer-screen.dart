import 'package:flutter/material.dart';

import '../../Models/SideItem.dart';
import '../../component/side-menubar.dart/side-menu-screen.dart';

import '../../component/ui/inner-sidebar.dart';
import 'add-customer/customer-add-widget.dart';
import 'customer-info/customer-report-widget.dart';
import 'view-customer/view-customer-widget.dart';

class CustomerScreen extends StatelessWidget {
  static const String routeName = "CustomerScreen";
  CustomerScreen({super.key});
  final PageController _controller = PageController();
  void _changeTab(int id) {
    _controller.jumpToPage(id);
  }

  List<SideItem> items = [
    SideItem("Add", Icons.add),
    SideItem("View", Icons.edit_document),
    SideItem("Report", Icons.search),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: InnerSidebarWrapper(
            sideWidget: SideWidget(items, _controller),
            child: PageView(
              controller: _controller,
              allowImplicitScrolling: false,
              children: [
                CustomerAddWidget(),
                const ViewCustomerWidget(),
                CustomerReportWidget()
              ],
            )));
  }
}
