import 'package:daily_collection/services/PartnerService.dart';
import 'package:daily_collection/UI/Partner/AddTransaction/PartnerTransaction.dart';
import 'package:flutter/material.dart';

import '../../Models/SideItem.dart';
import '../../component/side-menubar.dart/side-menu-screen.dart';
import 'PartnerAdd/PartnerAddForm.dart';
import 'PartnerList/PartnerList.dart';

class PartnerScreen extends StatelessWidget {
  static const String routeName = "PartnerScreen";
  PartnerScreen({super.key}) {
    PartnerService.initializeDb();
  }
  final PageController _controller = PageController();

  List<SideItem> items = [
    SideItem("Add Partner", Icons.add),
    SideItem("Add Partner Transaction", Icons.add),
    SideItem("Partner Details", Icons.mode),
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
              children: const [
                PartnerAddForm(),
                PartnerAddTransactionForm(),
                PartnerReport(),
              ],
            )),
      ],
    ));
  }
}
