import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../data-source/collection-datasource.dart';

class CollectionReportTable extends StatelessWidget {
  const CollectionReportTable({super.key, required this.data});
  final CollectionDatasource data;
  // final GlobalKey<SfDataGridState> pdfkey;

  getColumnWidget(String name) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        // alignment: Alignment.centerRight,
        child: Text(
          name,
          overflow: TextOverflow.ellipsis,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      // key: pdfkey,
      source: data,
      columnWidthMode: ColumnWidthMode.fill,

      columns: [
        GridColumn(columnName: 'sno', label: getColumnWidget('Sno.')),
        GridColumn(columnName: 'type', label: getColumnWidget('CR/DR')),
        GridColumn(columnName: 'amount', label: getColumnWidget('Amount')),
        GridColumn(columnName: 'id', label: getColumnWidget('TransactionId')),
        GridColumn(
            columnName: 'date', label: getColumnWidget('Transaction Date')),
        GridColumn(
            columnName: 'pending', label: getColumnWidget('Collection Till Date')),
      ],
    );
  }
}
