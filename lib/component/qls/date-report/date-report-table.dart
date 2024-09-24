import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../data-source/dbwiseLoanData.dart';

class DateWiseLoanTable extends StatelessWidget {
  DateWiseLoanTable({super.key, required this.data}) {
    total = data.dataGridRows
        .fold(0.0, (init, value) => init + value.getCells()[4].value);
  }
  final DbLoanDataSource data;
  var total;
  // final GlobalKey<SfDataGridState> pdfkey;

  getColumnWidget(String name) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerRight,
        child: Text(
          name,
          overflow: TextOverflow.ellipsis,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      // key: pdfkey,
      source: data,
      columnWidthMode: ColumnWidthMode.fill,
      footerFrozenRowsCount: 1,
      footer: Center(
          child: Text(
        "Total Disbursement Amount: Rs. $total ",
        style: const TextStyle(fontWeight: FontWeight.bold),
      )),
      columns: [
        GridColumn(columnName: 'sno', label: getColumnWidget('Sno.')),
        GridColumn(columnName: 'loanId', label: getColumnWidget('LoanId')),
        GridColumn(
            columnName: 'customerId', label: getColumnWidget('CustomerId')),
        GridColumn(
            columnName: 'customerName', label: getColumnWidget('CustomerName')),
        GridColumn(columnName: 'amount', label: getColumnWidget('Amount')),
        GridColumn(
            columnName: 'startDate', label: getColumnWidget('Start Date')),
        GridColumn(
            columnName: 'disbursementDate',
            label: getColumnWidget('Disbursement Date')),
      ],
    );
  }
}
