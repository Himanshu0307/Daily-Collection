import 'package:flutter/material.dart';

import '../../Models/SideItem.dart';
import '../Component/SideWidget.dart';
import 'CustomerAdd/CustomerAddScreen.dart';
import 'CustomerInfo/CustomerInfo.dart';
import 'CustomerList/CustomerList.dart';

class CustomerScreen extends StatelessWidget {
  static const String routeName = "CustomerScreen";
  CustomerScreen({super.key});
  final PageController _controller = PageController();
  void _changeTab(int id) {
    _controller.jumpToPage(id);
  }

  List<SideItem> items = [
    SideItem("Add Customer", Icons.add),
    SideItem("View Customer", Icons.edit_document),
    SideItem("Customer Search", Icons.search),
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
              controller: _controller,
              allowImplicitScrolling: false,
              children: [
                const CustomerAddWidgetForm(),
                CustomerList(),
                const CustomerSearchReport()
              ],
            )),
      ],
    ));
  }
}
