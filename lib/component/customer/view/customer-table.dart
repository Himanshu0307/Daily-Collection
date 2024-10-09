import 'dart:io';

import 'package:daily_collection/data-source/loan-data-source.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';

import '../../../data-source/customer-datasource.dart';

class CustomerTable extends StatelessWidget {
  CustomerTable({super.key, required this.data});
  final CustomerDatasource data;
  final GlobalKey<SfDataGridState> pdfkey = GlobalKey<SfDataGridState>();

  getColumnWidget(String name) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerRight,
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
    File('${documentpath.path}\\Customer-list-${DateFormat("yyyy-MM-dd-hh-mm-ss").format(DateTime.now())}.xlsx')
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
        GridColumn(columnName: 'id', label: getColumnWidget('CustomerId')),
        GridColumn(columnName: 'name', label: getColumnWidget('Customer Name')),
        GridColumn(columnName: 'mobile', label: getColumnWidget('Mobile')),
        GridColumn(columnName: 'aadhar', label: getColumnWidget('DocumentId')),
        GridColumn(columnName: 'address', label: getColumnWidget('Address')),
        GridColumn(columnName: 'father', label: getColumnWidget('Father Name')),
      ],
    );
  }
}
