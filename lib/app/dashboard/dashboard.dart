import 'package:flutter/material.dart';

import '../../component/dashboard/transaction.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        SizedBox(width: 450, child: Transactions()),
      ],
    );
  }
}
