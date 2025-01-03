import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';

import '../../../data-source/transaction-datasource.dart';
import '../../ui/constraint-ui.dart';

class TransactionTable extends StatelessWidget {
  TransactionTable(
      {super.key, required this.data, required Map<String, Object?> summary}) {
    cr = summary["cr"] as double? ?? 0.0;
    dr = summary["dr"] as double? ?? 0.0;
  }
  final TransactionDatasource data;
  double dr = 0.0;
  double cr = 0.0;
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
    File('${documentpath.path}\\Transaction-${DateFormat("yyyy-MM-dd-hh-mm-ss").format(DateTime.now())}.xlsx')
        .writeAsBytes(bytes, flush: true);
    document.dispose();
    // TODO: add Toast
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
      footer: Wrap(
        spacing: 20,
        runSpacing: 20,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            "TOTAL DR: $dr",
            style: getBoldText(),
          ),
          Text(
            "TOTAL CR: $cr",
            style: getBoldText(),
          ),
          ConstraintUI(
            child: TextButton.icon(
              onPressed: onPdfSave,
              label: const Text("Export to Excel"),
              icon: const Icon(Icons.import_export),
            ),
          ),
        ],
      ),
      columns: [
        GridColumn(columnName: 'sno', label: getColumnWidget('Sno.')),
        GridColumn(columnName: 'type', label: getColumnWidget('CR/DR')),
        GridColumn(columnName: 'to', label: getColumnWidget('To')),
        GridColumn(columnName: 'amount', label: getColumnWidget('Amount')),
        GridColumn(
            columnName: 'date', label: getColumnWidget('Transaction Date')),
      ],
    );
  }
}
