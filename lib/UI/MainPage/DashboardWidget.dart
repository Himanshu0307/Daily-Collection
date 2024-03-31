import 'package:daily_collection/UI/Password/CreatePasswordPopup.dart';
import 'package:flutter/material.dart';

import '../../Services/SqlService.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  SQLService service = SQLService();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: service.getDashBoardData(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            // if (snap.data == null) return SizedBox();
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 6,
                      mainAxisSpacing: 50,
                      crossAxisSpacing: 30),
                  children: [
                    ElevatedButton(
                        onPressed: () {},
                        child: Text("Total Cases: ${snap.data?.totalcase}")),
                    // "Total Cases")),
                    ElevatedButton(
                        onPressed: () {},
                        child: Text("Active Cases: ${snap.data?.active}")),
                    // "Active Cases")),
                    ElevatedButton(
                        onPressed: () {},
                        child: Text("Closed Cases: ${snap.data?.closed}")),
                    // "Closed Cases")),
                    ElevatedButton(
                        onPressed: () {},
                        child:
                            Text("Total Loan Amount: ${snap.data?.totalamt}")),
                    // "Total Loan Amount")),
                    ElevatedButton(
                        onPressed: () {},
                        child:
                            Text("Total Agreed Amount: ${snap.data?.agreed}")),
                    // "Total Agreed Amount")),
                    ElevatedButton(
                        onPressed: () {},
                        child: Text(
                            "Total Received Amount: ${snap.data?.received}")),
                    // "Total Received Amount"))

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
