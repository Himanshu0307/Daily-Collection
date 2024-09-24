import 'package:flutter/material.dart';

import '../../../Models/SQL Entities/QuickLoanModel.dart';

class LoanInfo extends StatelessWidget {
  const LoanInfo({super.key, required this.loans});
  final List<LoanModel> loans;

  @override
  Widget build(BuildContext context) {
    
    return ListView.builder(
      itemCount: loans.length,
      itemBuilder: (context, index) => ListTile(
        dense: true,
        leading: Text(loans[index].id?.toString() ?? "NA"),
        title: Text(loans[index].amount.toString()),
        subtitle: Text(loans[index].remark.toString()),
        trailing: Text(loans[index].startDate),
      ),
    );
  }
}
