import 'dart:io';

import 'package:daily_collection/utils/toastshow.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';

import '../../../data-source/transaction-datasource.dart';
import '../../data-source/cashflow-datasource.dart';
import '../ui/constraint-ui.dart';

class CashflowTable extends StatelessWidget {
  CashflowTable({super.key, required this.data});
  final CashflowDataSource data;
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
    var document = pdfkey.currentState!.exportToExcelWorkbook();
    final List<int> bytes = document.saveSync();
    Directory documentpath = await getApplicationDocumentsDirectory();
    // print(
    //     '${documentpath.path}\\Loan-Statement-${DateFormat("yyyy-MM-dd-hh-mm-ss").format(DateTime.now())}.xlsx');
    File('${documentpath.path}\\Cashflow-${DateFormat("yyyy-MM-dd-hh-mm-ss").format(DateTime.now())}.xlsx')
        .writeAsBytes(bytes, flush: true);
    document.dispose();
    // TODO: add Toast
    showToast("Document exported in Documents folder");
  }

  getBoldText() {
    return const TextStyle(fontWeight: FontWeight.bold);
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      key: pdfkey,
      source: data,
      columnWidthMode: ColumnWidthMode.fill,
      footerFrozenRowsCount: 1,
      // footerFrozenColumnsCount: 3,
      footer: Center(
        child: TextButton.icon(
          onPressed: onPdfSave,
          label: const Text("Export to Excel"),
          icon: const Icon(Icons.import_export),
        ),
      ),
      columns: [
        GridColumn(columnName: 'sno', label: getColumnWidget('Sno.')),
        GridColumn(
            columnName: 'date', label: getColumnWidget('Transaction Date')),
        GridColumn(columnName: 'type', label: getColumnWidget('To')),
        GridColumn(
            columnName: 'opening', label: getColumnWidget('Opening Balance')),
        GridColumn(
            columnName: 'credit', label: getColumnWidget('Credit Balance')),
        GridColumn(
            columnName: 'debit', label: getColumnWidget('Debit Balance')),
        GridColumn(
            columnName: 'closing', label: getColumnWidget('Closing Balance')),
      ],
    );
  }
}
