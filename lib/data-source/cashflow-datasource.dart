import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CashflowDataSource extends DataGridSource {
  CashflowDataSource(
      {required Map<String, Map<String, Map<String, dynamic>>> transaction}) {
    int index = 0;
    transaction.forEach((key, value) {
      value.forEach((k1, v1) {
        index += 1;
        dataGridRows.add(DataGridRow(cells: [
          DataGridCell<int>(columnName: "sno", value: index),
        DataGridCell<String>(columnName: 'date', value: key),
        DataGridCell<String>(columnName: 'type', value:k1 ),
        DataGridCell<double>(columnName: 'opening', value: v1['opening']),
        DataGridCell<double>(columnName: 'credit', value: v1['credit']??0.0),
        DataGridCell<double>(columnName: 'debit', value: v1['debit']??0.0),
        DataGridCell<double>(columnName: 'closing', value: v1['closing']),
        ]));
      });
    });
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
