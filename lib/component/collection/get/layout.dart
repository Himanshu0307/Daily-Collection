import 'package:flutter/material.dart';

import '../../../Models/SQL Entities/QuickLoanModel.dart';
import '../../../data-source/collection-datasource.dart';
import 'LoanInfoCard.dart';
import 'report-table.dart';

class CollectionLayout extends StatelessWidget {
  const CollectionLayout({super.key, required this.data, required this.card});
  final CollectionDatasource? data;
  final LoanReportIdModel? card;
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Loaninfocard(
          data: card,
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: CollectionReportTable(
            data: data!,
          ),
        )
      ],
    );
  }
}
