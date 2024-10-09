import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../Models/SQL Entities/QuickLoanModel.dart';

class DbCollectionDatasource extends DataGridSource {
  DbCollectionDatasource({required List<DateWiseCollectionReportModel> list}) {
    int index = 0;
    dataGridRows = list.map<DataGridRow>((dataGridRow) {
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
            columnName: 'collectionDate', value: dataGridRow.collectionDate),
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
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ));
    }).toList());
  }
}
