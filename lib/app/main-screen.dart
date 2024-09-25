import 'package:flutter/material.dart';

import '../Models/MainItems.dart';
import '../Services/Cashbook.dart';
import '../Services/SqlService.dart';
import '../component/main-screen/dashboard-widget.dart';
import '../UI/MainPage/ListItemWidget.dart';
import '../component/ui/sidebar/sidebar.dart';

class MainPageScreen extends StatelessWidget {
  const MainPageScreen({super.key});
  static const routeName = "MainPage";

  @override
  Widget build(BuildContext context) {
    SQLService.initializeDb();
    CashBookService.initializeDb();
    return Scaffold(
      body: MainScreenWidget(),
    );
  }
}

class MainScreenWidget extends StatelessWidget {
  const MainScreenWidget({super.key});
  final listItem = mainItem;

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SizedBox(width: 50, child: Sidebar()),
        Expanded(flex: 5, child: DashboardWidget())
      ],
    );
  }
}
