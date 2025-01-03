import 'package:flutter/material.dart';
import '../../Models/SideItem.dart';
import '../../component/side-menubar.dart/side-menu-screen.dart';
import '../../component/ui/inner-sidebar.dart';
import 'add-form/cashbook-add-form.dart';
import 'view-cashbook/cashbook-list.dart';

class CashBookScreen extends StatelessWidget {
  static const String routeName = "CashBookScreen";
  CashBookScreen({super.key});
  final PageController _controller = PageController();
  void _changeTab(int id) {
    _controller.jumpToPage(id);
  }

  List<SideItem> items = [
    SideItem("Add Entry", Icons.add),
    SideItem("View Entry", Icons.mode),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: InnerSidebarWrapper(
            sideWidget: SideWidget(items, _controller),
            child: PageView(
              controller: _controller,
              allowImplicitScrolling: false,
              children: const [CashBookAddForm(), CashbookList()],
            )));
    ;
  }
}
