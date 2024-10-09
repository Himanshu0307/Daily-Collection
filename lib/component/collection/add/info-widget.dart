import 'package:daily_collection/component/collection/add/loan-info.dart';
import 'package:daily_collection/component/ui/text-wrapper.dart';
import 'package:flutter/material.dart';

import '../../../Models/SQL Entities/QuickLoanModel.dart';
import '../../qls/get-loan/customer-card.dart';
import 'collection-form.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({super.key, required this.details});
  final TransactionReportModel details;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 20,
      spacing: 20,
      children: [
        CustomerCard(
          customer: details.customerModel,
        ),
        if (details.loanModel.isEmpty)
          const BoldTextWrapper("No Active loan Found")
        else
          Column(
            children: [
              LoanInfo(loans: details.loanModel),
              CollectionForm(
                  loanIds: details.loanModel.map((x) => x.id!).toList())
            ],
          )
      ],
    );
  }
}
