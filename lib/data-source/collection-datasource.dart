import 'package:daily_collection/utils/toastshow.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../Models/SQL Entities/QuickLoanModel.dart';
import '../services/SqlService.dart';

class CollectionDatasource extends DataGridSource {
  final SQLService _service = SQLService();

  deleteCollection(row) async {
    var response =
        await _service.deleteCollection(row.getCells()[3].value as int);
    showToast(response["message"]);
    dataGridRows.remove(row);
    notifyListeners();
  }

  CollectionDatasource(
      {required List<ListItemModel> transaction,
      this.showDeleteButton = false}) {
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
            columnName: 'total', value: dataGridRow.totalPaidAmounttillDate),
       
      ]);
    }).toList();
  }

  var col = [
    "sno",
    "id",
    "amount",
  ];

  List<DataGridRow> dataGridRows = [];
  final bool showDeleteButton;

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      ...row.getCells().map<Widget>((dataGridCell) {
        return Container(
            // alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              dataGridCell.value.toString(),
              overflow: TextOverflow.ellipsis,
            ));
      }),
      ActionChip.elevated(
          label: const Icon(Icons.delete),
          onPressed: showDeleteButton && row.getCells()[1].value == "CR"
              ? () => deleteCollection(row)
              : null)
    ]);
  }
}
