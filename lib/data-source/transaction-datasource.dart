import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../Models/SQL Entities/QuickLoanModel.dart';

class TransactionDatasource extends DataGridSource {
  TransactionDatasource(
      {required List<DateWiseTransactionReportModel> transaction}) {
    int index = 0;
    dataGridRows = transaction.map<DataGridRow>((dataGridRow) {
      index += 1;
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: "sno", value: index),
        DataGridCell<String>(columnName: 'type', value: dataGridRow.type),
        DataGridCell<String>(columnName: 'to', value: dataGridRow.to),
        DataGridCell<double>(columnName: 'amount', value: dataGridRow.amount),
        DataGridCell<String>(columnName: 'date', value: dataGridRow.date),
      ]);
    }).toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          // alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ));
    }).toList());
  }
}
