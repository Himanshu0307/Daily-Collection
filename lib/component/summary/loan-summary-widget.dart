import 'dart:io';

import 'package:daily_collection/component/summary/loan-table.dart';
import 'package:daily_collection/component/ui/text-wrapper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';

import '../../Models/SQL Entities/QuickLoanModel.dart';
import '../../Services/SqlService.dart';
import '../../data-source/loan-data-source.dart';
import '../ui/constraint-ui.dart';

class LoanSummary extends StatefulWidget {
  const LoanSummary({super.key});

  @override
  State<LoanSummary> createState() => _LoanListState();
}

class _LoanListState extends State<LoanSummary> {
  SQLService service = SQLService();
  var filter = "active";
  final GlobalKey<SfDataGridState> pdfkey = GlobalKey<SfDataGridState>();

  onFilterChange(value) {
    setState(() {
      filter = value;
    });
  }

  // fetch data from db

  fetchData(status) async {
    Map<String, Object?> data = await service.getLoanListfromStatus(status);
    // print(data);
    //  convert to Model
    List<LoanReportModel> listrows =
        (data["data"] as List<Map<String, Object?>>)
            .map<LoanReportModel>((x) => LoanReportModel.fromJson(x))
            .toList();
    return Future.value(LoanDataSource(loans: listrows));
  }

  onPdfSave() async {
    var document = pdfkey.currentState!.exportToExcelWorkbook();
    final List<int> bytes = document.saveSync();
    Directory documentpath = await getApplicationDocumentsDirectory();
    // print(
    //     '${documentpath.path}\\Loan-Statement-${DateFormat("yyyy-MM-dd-hh-mm-ss").format(DateTime.now())}.xlsx');
    File('${documentpath.path}\\Loan-Statement-${DateFormat("yyyy-MM-dd-hh-mm-ss").format(DateTime.now())}.xlsx')
        .writeAsBytes(bytes, flush: true);
    document.dispose();
    // TODO: add Toast
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Wrap(
          children: [
            ConstraintUI(
              child: RadioMenuButton(
                  value: 'active',
                  groupValue: filter,
                  onChanged: onFilterChange,
                  child: const Text("Active")),
            ),
            ConstraintUI(
              child: RadioMenuButton(
                  value: 'close',
                  groupValue: filter,
                  onChanged: onFilterChange,
                  child: const Text("Closed")),
            ),
            ConstraintUI(
              child: RadioMenuButton(
                  value: 'all',
                  groupValue: filter,
                  onChanged: onFilterChange,
                  child: const Text("All")),
            ),
            ConstraintUI(
                child: TextButton.icon(
                    label: const Text("Export to Excel"),
                    onPressed: onPdfSave,
                    icon: const Icon(Icons.edit_document)))
          ],
        ),
        Expanded(
          flex: 4,
          child: FutureBuilder(
              future: fetchData(filter),
              builder: (context, fdata) {
                if (fdata.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (fdata.connectionState == ConnectionState.done) {
                  // return Container();
                  return LoanTable(
                      pdfkey: pdfkey, data: fdata.data as LoanDataSource);
                }
                if (fdata.hasError) {
                  print(fdata.error);
                  return const BoldTextWrapper(
                      "Something went wrong while getting data");
                }

                return const SizedBox();
              }),
        )
      ],
    );
  }
}
