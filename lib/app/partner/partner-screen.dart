import 'package:daily_collection/services/PartnerService.dart';
import 'package:daily_collection/app/partner/transaction/partner-transaction.dart';
import 'package:flutter/material.dart';

import '../../Models/SideItem.dart';
import '../../component/side-menubar.dart/side-menu-screen.dart';
import 'add/partner-add.dart';
import 'detail/partner-list.dart';
import '../../component/ui/inner-sidebar.dart';

class PartnerScreen extends StatelessWidget {
  static const String routeName = "PartnerScreen";
  PartnerScreen({super.key}) {
    PartnerService.initializeDb();
  }
  final PageController _controller = PageController();

  List<SideItem> items = [
    SideItem("Add Partner", Icons.add),
    SideItem("Partner Transaction", Icons.monetization_on),
    SideItem("Partner Details", Icons.mode),
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
                PartnerAddForm(),
                PartnerAddTransactionForm(),
                PartnerReport(),
              ],
            )));
  }
}
