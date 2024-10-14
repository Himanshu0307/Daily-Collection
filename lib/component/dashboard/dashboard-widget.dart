import 'package:daily_collection/UI/Password/CreatePasswordPopup.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/SqlService.dart';

class ExpenseSummary extends StatefulWidget {
  const ExpenseSummary({super.key});

  @override
  State<ExpenseSummary> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<ExpenseSummary> {
  SQLService service = SQLService();
  var f = NumberFormat("##,##,##,##,##,###.0#", "en_US");
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: service.getDashBoardData(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  children: [
                    ElevatedButton(
                        onPressed: () {},
                        child: Text(
                            "Total Cases: ${f.format(snap.data?.totalcase ?? 0)}")),
                    // "Total Cases")),
                    ElevatedButton(
                        onPressed: () {},
                        child: Text(
                            "Active Cases: ${f.format(snap.data?.active ?? 0)}")),
                    // "Active Cases")),
                    ElevatedButton(
                        onPressed: () {},
                        child: Text(
                            "Closed Cases: ${f.format(snap.data?.closed ?? 0)}")),
                    // "Closed Cases")),
                    ElevatedButton(
                        onPressed: () {},
                        child: Text(
                            "Total Loan Amount: ${f.format(snap.data?.totalamt ?? 0)}")),
                    // "Total Loan Amount")),
                    ElevatedButton(
                        onPressed: () {},
                        child: Text(
                            "Total Agreed Amount: ${f.format(snap.data?.agreed ?? 0)}")),
                    // "Total Agreed Amount")),
                    ElevatedButton(
                        onPressed: () {},
                        child: Text(
                            "Total Received Amount: ${f.format(snap.data?.received ?? 0)}")),
                    // "Total Received Amount"))
                    ElevatedButton(
                        onPressed: () {},
                        child: Text(
                            "Total InHand Amount: ${f.format(snap.data?.inHand ?? 0)}")),
                    // "Total inHand Amount"))

                    ElevatedButton(
                        onPressed: () {
                          setState(() {});
                        },
                        child: const Text("Refresh")),
                    ElevatedButton(
                        onPressed: () {
                          showPasswordPopup(context);
                        },
                        child: const Text("ChangePassword"))
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        });
  }
}
