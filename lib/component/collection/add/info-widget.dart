import 'package:daily_collection/component/collection/add/loan-info.dart';
import 'package:daily_collection/component/ui/text-wrapper.dart';
import 'package:flutter/material.dart';

import '../../../Models/SQL Entities/QuickLoanModel.dart';
import '../../qls/get-loan/customer-card.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({super.key, required this.details});
  final TransactionReportModel details;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: CustomerCard(
          customer: details.customerModel,
        )),
        if (details.loanModel.isEmpty)
          const BoldTextWrapper("No Active loan Found")
        else
          Expanded(flex: 3, child: LoanInfo(loans: details.loanModel))
      ],
    );
  }
}
