import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';

import '../../../data-source/collection-datasource.dart';

class CollectionReportTable extends StatelessWidget {
  CollectionReportTable({super.key, required this.data});
  final CollectionDatasource data;
  final GlobalKey<SfDataGridState> pdfkey = GlobalKey<SfDataGridState>();

  getColumnWidget(String name) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        // alignment: Alignment.centerRight,
        child: Text(
          name,
          overflow: TextOverflow.ellipsis,
        ));
  }

  onPdfSave() async {
    var document = pdfkey.currentState!.exportToExcelWorkbook(
      excludeColumns: ["action"],
    );
    final List<int> bytes = document.saveSync();
    Directory documentpath = await getApplicationDocumentsDirectory();
    // print(
    //     '${documentpath.path}\\Loan-Statement-${DateFormat("yyyy-MM-dd-hh-mm-ss").format(DateTime.now())}.xlsx');
    File('${documentpath.path}\\Collection-${DateFormat("yyyy-MM-dd-hh-mm-ss").format(DateTime.now())}.xlsx')
        .writeAsBytes(bytes, flush: true);
    document.dispose();
    // TODO: add Toast
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      key: pdfkey,
      source: data,
      columnWidthMode: ColumnWidthMode.fill,
      footerFrozenRowsCount: 1,
      footer: TextButton.icon(
        onPressed: onPdfSave,
        label: const Text("Export to Excel"),
        icon: const Icon(Icons.import_export),
      ),
      columns: [
        GridColumn(columnName: 'sno', label: getColumnWidget('Sno.')),
        GridColumn(columnName: 'type', label: getColumnWidget('CR/DR')),
        GridColumn(columnName: 'amount', label: getColumnWidget('Amount')),
        GridColumn(columnName: 'id', label: getColumnWidget('TransactionId')),
        GridColumn(
            columnName: 'date', label: getColumnWidget('Transaction Date')),
        GridColumn(
            columnName: 'total',
            label: getColumnWidget('Collection Till Date')),
        GridColumn(columnName: 'action', label: getColumnWidget('Action')),
      ],
    );
  }
}
