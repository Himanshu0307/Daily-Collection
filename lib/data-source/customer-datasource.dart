import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../Models/SQL Entities/QuickLoanModel.dart';

class CustomerDatasource extends DataGridSource {
  CustomerDatasource({required List<CustomerModel> transaction}) {
    int index = 0;
    dataGridRows = transaction.map<DataGridRow>((dataGridRow) {
      index += 1;
      return DataGridRow(cells: [
        DataGridCell(columnName: "sno", value: index),
        DataGridCell<int>(columnName: 'id', value: dataGridRow.id),
        DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
        DataGridCell<String>(columnName: 'mobile', value: dataGridRow.mobile),
        DataGridCell<String>(columnName: 'aadhar', value: dataGridRow.aadhar),
        DataGridCell<String>(columnName: 'address', value: dataGridRow.address),
        DataGridCell<String>(columnName: 'father', value: dataGridRow.father),
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
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.visible,
          ));
    }).toList());
  }
}
