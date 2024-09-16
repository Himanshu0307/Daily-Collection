import 'package:daily_collection/component/ui/text-wrapper.dart';
import 'package:flutter/material.dart';

import '../../../Models/SQL Entities/QuickLoanModel.dart';
import '../../ui/constraint-ui.dart';

class InstallementCard extends StatelessWidget {
  final InstallementReportModel? installementReport;

  const InstallementCard({super.key, this.installementReport});
  @override
  Widget build(BuildContext context) {
    // FIX: last installement coming wrong
    if (installementReport == null) {
      return const BoldTextWrapper("No Installement received");
    } else {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
            ConstraintUI(
                child: Text(
                    "Remaining Amount: ${installementReport!.remaining.toString()}")),
            ConstraintUI(
                child: Text(
                    "Last Installement Received: ${installementReport!.lastCollection}")),
            ConstraintUI(
                child: Text(
                    "Amount Received: ${installementReport!.received.toString()}")),
            ConstraintUI(
                child: Text(
                    "Overdue Amount: ${installementReport!.overdue.toString()}")),
          ]),
        ),
      );
    }
  }
}
