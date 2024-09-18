import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../Models/SQL Entities/QuickLoanModel.dart';

class LoanDataSource extends DataGridSource {
  LoanDataSource({required List<LoanReportModel> loans}) {
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
        DataGridCell<double>(columnName: 'overdue', value: dataGridRow.overdue),
        DataGridCell<int>(columnName: 'amount', value: dataGridRow.amount),
        DataGridCell<int>(
            columnName: 'installement', value: dataGridRow.installement),
        DataGridCell<int>(columnName: 'days', value: dataGridRow.days),
        DataGridCell<int>(
            columnName: 'agreedAmount', value: dataGridRow.agreedAmount),
        DataGridCell<String>(
            columnName: 'startDate', value: dataGridRow.startDate),
        DataGridCell<String>(columnName: 'endDate', value: dataGridRow.endDate),
        DataGridCell<String>(
            columnName: 'disbursementDate',
            value: dataGridRow.disbursementDate),
        DataGridCell<String>(columnName: 'remark', value: dataGridRow.remark),
        DataGridCell<String>(
            columnName: 'witnessName', value: dataGridRow.witnessName),
        DataGridCell<bool>(columnName: 'status', value: dataGridRow.status),
      ]);
    }).toList();
  }

  var col = [
    "sno",
    "loanId",
    "customerId",
    "overdue",
    "amount",
    "installement",
    "days",
    "agreedAmount"
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
