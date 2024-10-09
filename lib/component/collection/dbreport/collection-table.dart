import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';

import '../../../data-source/customer_loan-datasource.dart';
import '../../../data-source/dbwise-collection-datasource.dart';

class DbCollectionTable extends StatelessWidget {
  DbCollectionTable({super.key, required this.data});

  final DbCollectionDatasource data;
  final GlobalKey<SfDataGridState> pdfkey = GlobalKey<SfDataGridState>();

  getColumnWidget(String name) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        alignment: Alignment.topLeft,
        child: Text(
          name,
          overflow: TextOverflow.ellipsis,
        ));
  }

  onPdfSave() async {
    var document = pdfkey.currentState!.exportToExcelWorkbook();
    final List<int> bytes = document.saveSync();
    Directory documentpath = await getApplicationDocumentsDirectory();
    // print(
    //     '${documentpath.path}\\Loan-Statement-${DateFormat("yyyy-MM-dd-hh-mm-ss").format(DateTime.now())}.xlsx');
    File('${documentpath.path}\\DwCollection-Report-${DateFormat("yyyy-MM-dd-hh-mm-ss").format(DateTime.now())}.xlsx')
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
        GridColumn(columnName: 'loanId', label: getColumnWidget('LoanId')),
        GridColumn(
            columnName: 'customerId', label: getColumnWidget('Customer Id')),
        GridColumn(
            columnName: 'customerName',
            label: getColumnWidget('Customer Name')),
        GridColumn(columnName: 'amount', label: getColumnWidget('Amount')),
        GridColumn(
            columnName: 'collectionDate',
            label: getColumnWidget('Collection Date')),
      ],
    );
  }
}
