import 'package:daily_collection/Services/Cashbook.dart';
import 'package:flutter/material.dart';

import '../../Models/MainItems.dart';
import '../../Services/SqlService.dart';
import 'DashboardWidget.dart';
import 'ListItemWidget.dart';

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
  MainScreenWidget({super.key});
  final listItem = mainItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 4,
                    mainAxisSpacing: 60,
                    crossAxisSpacing: 30),
                children: [
                  ...listItem.map((e) => ListItemWidget(e)),
                ],
              ),
            ),
          ),
        ),
        const Expanded(child: DashboardWidget())
      ],
    );
  }
}
