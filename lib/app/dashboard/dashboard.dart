import 'package:flutter/material.dart';

import '../../component/dashboard/dashboard-widget.dart';
import '../../component/dashboard/navbar.dart';
import '../../component/dashboard/transaction.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getNavBar(),
      body: Wrap(
        spacing: 20,
        runSpacing: 20,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(width: 450, child: Transactions()),
          const SizedBox(width: 350, child: ExpenseSummary()),
        ],
      ),
    );
  }
}
