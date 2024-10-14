import 'package:daily_collection/app/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

import '../Models/MainItems.dart';
import '../services/Cashbook.dart';
import '../services/SqlService.dart';
import '../component/ui/sidebar/sidebar.dart';

class MainPageScreen extends StatelessWidget {
  const MainPageScreen({super.key});
  static const routeName = "MainPage";

  @override
  Widget build(BuildContext context) {
    SQLService.initializeDb();
    CashBookService.initializeDb();
    return const Scaffold(
      
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
        SizedBox(width: 150, child: Sidebar()),
        Expanded(flex: 5, child: Dashboard())
      ],
    );
  }
}
