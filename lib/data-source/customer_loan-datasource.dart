import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../Models/SQL Entities/QuickLoanModel.dart';

class CustomerLoanDataSource extends DataGridSource {
  CustomerLoanDataSource({required List<CustomerLoanReportModel> transaction}) {
    int index = 0;
    dataGridRows = transaction.map<DataGridRow>((dataGridRow) {
      index += 1;
      return DataGridRow(cells: [
        DataGridCell(columnName: "sno", value: index),
        DataGridCell<int>(columnName: 'id', value: dataGridRow.id),
        DataGridCell<int>(columnName: 'cid', value: dataGridRow.cid),
        DataGridCell<String>(
            columnName: 'customerName', value: dataGridRow.customerName),
        DataGridCell<String>(columnName: 'mobile', value: dataGridRow.mobile),
        DataGridCell<double>(columnName: 'amount', value: dataGridRow.amount),
        DataGridCell<double>(
            columnName: 'agreedAmount', value: dataGridRow.agreedAmount),
        DataGridCell<int>(
            columnName: 'installement', value: dataGridRow.installment),
        DataGridCell<String>(
            columnName: 'startDate', value: dataGridRow.startDate),
        DataGridCell<String>(columnName: 'endDate', value: dataGridRow.endDate),
        DataGridCell<String>(columnName: 'remark', value: dataGridRow.remark),
        DataGridCell<String>(
            columnName: 'status',
            value: dataGridRow.status == 1 ? 'Active' : 'Closed'),
        DataGridCell<double>(
            columnName: 'received', value: dataGridRow.received),
        DataGridCell<double>(columnName: 'overdue', value: dataGridRow.overdue),
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
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ));
    }).toList());
  }
}
