import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../Models/SQL Entities/QuickLoanModel.dart';

class CollectionDatasource extends DataGridSource {
  CollectionDatasource({required List<ListItemModel> transaction}) {
    int index = 0;
    dataGridRows = transaction.map<DataGridRow>((dataGridRow) {
      index += 1;
      return DataGridRow(cells: [
        DataGridCell(columnName: "sno", value: index),
        DataGridCell<String>(columnName: 'type', value: dataGridRow.type),
        DataGridCell<int>(columnName: 'amount', value: dataGridRow.amount),
        DataGridCell<int>(columnName: 'id', value: dataGridRow.id),
        DataGridCell<String>(
            columnName: 'date', value: dataGridRow.collectionDate),
        DataGridCell<int>(
            columnName: 'pending', value: dataGridRow.totalPaidAmounttillDate),
      ]);
    }).toList();
  }

  var col = [
    "sno",
    "id",
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
          // alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ));
    }).toList());
  }
}
