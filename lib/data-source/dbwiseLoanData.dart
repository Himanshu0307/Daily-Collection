import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../Models/SQL Entities/QuickLoanModel.dart';

class DbLoanDataSource extends DataGridSource {
  DbLoanDataSource({required List<DateWiseCollectionReportModel> loans}) {
    int index = 0;
    dataGridRows = loans.map<DataGridRow>((dataGridRow) {
      index += 1;
      return DataGridRow(cells: [
        DataGridCell(columnName: "sno", value: index),
        DataGridCell<int>(columnName: 'loanId', value: dataGridRow.loanId),
        DataGridCell<int>(
            columnName: 'customerId', value: dataGridRow.customerId),
        DataGridCell<String>(
            columnName: 'customerName', value: dataGridRow.customerName),
        DataGridCell<int>(columnName: 'amount', value: dataGridRow.amount),
      DataGridCell<String>(
            columnName: 'startDate', value: dataGridRow.startDate),
        DataGridCell<String>(
            columnName: 'disbursementDate',
            value: dataGridRow.disbursementDate),
       
      ]);
    }).toList();
  }

  var col = [
    "sno",
    "loanId",
    "customerId",
    "amount",
  ];

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: (col.contains(dataGridCell.columnName))
              ? Alignment.centerRight
              : Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ));
    }).toList());
  }
}
