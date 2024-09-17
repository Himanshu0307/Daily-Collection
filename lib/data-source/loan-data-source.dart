import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../Models/SQL Entities/QuickLoanModel.dart';

class LoanDataSource extends DataGridSource {
  LoanDataSource({required List<LoanReportModel> employees}) {
    dataGridRows = employees
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'sn', value: dataGridRow.sn),
              DataGridCell<String>(
                  columnName: 'loanId', value: dataGridRow.loanId),
              DataGridCell<String>(
                  columnName: 'customerId', value: dataGridRow.customerId),
              DataGridCell<String>(
                  columnName: 'customerName', value: dataGridRow.customerName),
              DataGridCell<String>(
                  columnName: 'overdue', value: dataGridRow.overdue),
              DataGridCell<String>(
                  columnName: 'amount', value: dataGridRow.amount),
              DataGridCell<String>(
                  columnName: 'installement', value: dataGridRow.installement),
              DataGridCell<String>(columnName: 'days', value: dataGridRow.days),
              DataGridCell<String>(
                  columnName: 'agreedAmount', value: dataGridRow.agreedAmount),
              DataGridCell<String>(
                  columnName: 'startDate', value: dataGridRow.startDate),
              DataGridCell<String>(
                  columnName: 'endDate', value: dataGridRow.endDate),
              DataGridCell<String>(
                  columnName: 'disbursementDate',
                  value: dataGridRow.disbursementDate),
              DataGridCell<String>(
                  columnName: 'remark', value: dataGridRow.remark),
              DataGridCell<String>(
                  columnName: 'witnessName', value: dataGridRow.witnessName),
              DataGridCell<String>(
                  columnName: 'status', value: dataGridRow.status),
            ]))
        .toList();
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
