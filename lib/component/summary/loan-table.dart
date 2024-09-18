import 'package:daily_collection/data-source/loan-data-source.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class LoanTable extends StatelessWidget {
  const LoanTable({super.key, required this.data,required this.pdfkey});
  final LoanDataSource data;
  final GlobalKey<SfDataGridState> pdfkey;

  getColumnWidget(String name) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerRight,
        child: Text(
          name,
          overflow: TextOverflow.ellipsis,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      key: pdfkey,
      source: data,
      columnWidthMode: ColumnWidthMode.auto,
      columns: [
        GridColumn(columnName: 'sno', label: getColumnWidget('Sno.')),
        GridColumn(columnName: 'loanId', label: getColumnWidget('LoanId')),
        GridColumn(
            columnName: 'customerId', label: getColumnWidget('CustomerId')),
        GridColumn(
            columnName: 'customerName', label: getColumnWidget('CustomerName')),
        GridColumn(columnName: 'overdue', label: getColumnWidget('Overdue')),
        GridColumn(columnName: 'amount', label: getColumnWidget('Amount')),
        GridColumn(
            columnName: 'installement', label: getColumnWidget('Installement')),
        GridColumn(columnName: 'days', label: getColumnWidget('Days')),
        GridColumn(
            columnName: 'agreedAmount',
            label: getColumnWidget('Agreed Amount')),
        GridColumn(
            columnName: 'startDate', label: getColumnWidget('Start Date')),
        GridColumn(columnName: 'endDate', label: getColumnWidget('End Date')),
        GridColumn(
            columnName: 'disbursementDate',
            label: getColumnWidget('Disbursement Date')),
        GridColumn(columnName: 'remark', label: getColumnWidget('Remark')),
        GridColumn(
            columnName: 'witnessName', label: getColumnWidget('WitnessName')),
        GridColumn(columnName: 'status', label: getColumnWidget('Status')),
      ],
    );
  }
}
