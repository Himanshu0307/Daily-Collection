import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';

import '../../../data-source/customer_loan-datasource.dart';

class CustomerReport extends StatelessWidget {
  CustomerReport({super.key, required this.data});

  final CustomerLoanDataSource data;
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
    File('${documentpath.path}\\Customer-Report-${DateFormat("yyyy-MM-dd-hh-mm-ss").format(DateTime.now())}.xlsx')
        .writeAsBytes(bytes, flush: true);
    document.dispose();
    // TODO: add Toast
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      key: pdfkey,
      source: data,
      columnWidthMode: ColumnWidthMode.auto,
      footerFrozenRowsCount: 1,
      footer: TextButton.icon(
        onPressed: onPdfSave,
        label: const Text("Export to Excel"),
        icon: const Icon(Icons.import_export),
      ),
      columns: [
        GridColumn(columnName: 'sno', label: getColumnWidget('Sno.')),
        GridColumn(columnName: 'id', label: getColumnWidget('LoanId')),
        GridColumn(columnName: 'cid', label: getColumnWidget('Customer Id')),
        GridColumn(
            columnName: 'customerName',
            label: getColumnWidget('Customer Name')),
        GridColumn(columnName: 'mobile', label: getColumnWidget('Mobile')),
        GridColumn(columnName: 'amount', label: getColumnWidget('Amount')),
        GridColumn(
            columnName: 'agreedAmount',
            label: getColumnWidget('Agreed Amount')),
        GridColumn(
            columnName: 'installement', label: getColumnWidget('Installement')),
        GridColumn(
            columnName: 'startDate', label: getColumnWidget('Start Date')),
        GridColumn(
            columnName: 'endDate', label: getColumnWidget('Loan Ending Date')),
        GridColumn(columnName: 'remark', label: getColumnWidget('Remark')),
        GridColumn(columnName: 'status', label: getColumnWidget('Loan Status')),
        GridColumn(
            columnName: 'received', label: getColumnWidget('Received Amount')),
        GridColumn(columnName: 'overdue', label: getColumnWidget('Overdue')),
      ],
    );
  }
}
