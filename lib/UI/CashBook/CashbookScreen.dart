import 'package:daily_collection/UI/CashBook/CashbookAdd/CashbookAddForm.dart';
import 'package:daily_collection/UI/CashBook/CashbookInfo/CashbookList.dart';
import 'package:flutter/material.dart';

import '../../Models/SideItem.dart';
import '../../component/side-menubar.dart/side-menu-screen.dart';

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
        body: Row(
      children: [
        Expanded(flex: 1, child: SideWidget(items, _controller)),
        Expanded(
            flex: 3,
            child: PageView(
              controller: _controller,
              allowImplicitScrolling: false,
              children: const [CashBookAddForm(), CashbookList()],
            )),
      ],
    ));
  }
}
