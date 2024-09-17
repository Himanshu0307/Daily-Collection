import 'package:daily_collection/data-source/loan-data-source.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';


class LoanTable extends StatelessWidget {
  const LoanTable({super.key,required this.data});
  final LoanDataSource data;

  getColumnWidget(String name){
    return Container(
                padding:const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerRight,
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                ));
  }

  @override
  Widget build(BuildContext context) {
    return  SfDataGrid(
      source: data,
      columns: [
        GridColumn(columnName: 'sn', label: getColumnWidget('Sno.')),
        GridColumn(columnName: 'loanId', label: getColumnWidget('LoanId')),
        GridColumn(columnName: 'customerId', label: getColumnWidget('LoanId')),
        GridColumn(columnName: 'customerName', label: getColumnWidget('LoanId')),
        GridColumn(columnName: 'overdue', label: getColumnWidget('Sno.')),
        GridColumn(columnName: 'amount', label: getColumnWidget('Sno.')),
        GridColumn(columnName: 'installement', label: getColumnWidget('Sno.')),
        GridColumn(columnName: 'days', label: getColumnWidget('Sno.')),
        GridColumn(columnName: 'agreedAmount', label: getColumnWidget('Sno.')),
        GridColumn(columnName: 'startDate', label: getColumnWidget('Sno.')),
        GridColumn(columnName: 'endDate', label: getColumnWidget('Sno.')),
        GridColumn(columnName: 'disbursementDate', label: getColumnWidget('Sno.')),
        GridColumn(columnName: 'remark', label: getColumnWidget('Sno.')),
        GridColumn(columnName: 'witnessName', label: getColumnWidget('Sno.')),
        GridColumn(columnName: 'status', label: getColumnWidget('Sno.')),
      ],
    );
  }
}