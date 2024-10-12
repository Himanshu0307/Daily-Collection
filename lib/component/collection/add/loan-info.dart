import 'package:flutter/material.dart';

import '../../../Models/SQL Entities/QuickLoanModel.dart';

class LoanInfo extends StatelessWidget {
  const LoanInfo({super.key, required this.loans});
  final List<ELoanModel> loans;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: loans.length,
      itemBuilder: (context, index) => Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              Text("LoanID: ${loans[index].id ?? "--NA--"}"),
              Text("Amount: ${loans[index].amount}"),
              Text("Remarks: ${loans[index].remark ?? "--NA--"}"),
              Text("Start Date: ${loans[index].startDate}"),
              Text("Disbursement Date: ${loans[index].disbursementDate}"),
              Text("Overdue: ${loans[index].overdue}"),
            ],
          ),
        ),
      ),
    );
  }
}
