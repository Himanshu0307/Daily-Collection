import 'package:flutter/material.dart';

import '../../../../Models/SQL Entities/QuickLoanModel.dart';
import '../../../../component/qls/get-loan/customer-card.dart';
import '../../../../component/qls/get-loan/installement-card.dart';
import '../../../../component/qls/get-loan/loan-card.dart';

class ReportsWidget extends StatelessWidget {
  final Function onClear;
  final LoanReportIdModel info;
  const ReportsWidget({super.key, required this.info, required this.onClear});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(flex: 2, child: CustomerCard(customer: info.customerModel)),
        Expanded(
            flex: 3,
            child: LoanCard(loanModel: info.loanModel, onClear: onClear)),
        Expanded(
            flex: 2,
            child: InstallementCard(
              installementReport: info.reportModel,
            ))
      ],
    );
  }
}
