import 'dart:io';

import 'package:daily_collection/Models/SQL%20Entities/QuickLoanModel.dart';
import 'package:daily_collection/UI/Component/CalendarPicker.dart';
import 'package:flutter/material.dart';
import 'package:daily_collection/services/SqlService.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';

import '../../../component/qls/date-report/date-report-table.dart';
import '../../../component/ui/constraint-ui.dart';
import '../../../data-source/dbwiseLoanData.dart';

class DateWiseLoanReport extends StatefulWidget {
  const DateWiseLoanReport({super.key});

  @override
  State<DateWiseLoanReport> createState() => _DateWiseLoanReportState();
}

class _DateWiseLoanReportState extends State<DateWiseLoanReport> {
  SQLService service = SQLService();
  late TextEditingController start;
  late TextEditingController close;
  DbLoanDataSource? _dataSource;
  final GlobalKey<SfDataGridState> pdfkey = GlobalKey<SfDataGridState>();

  @override
  initState() {
    super.initState();
    start = TextEditingController();
    close = TextEditingController();
  }

  @override
  dispose() {
    start.dispose();
    close.dispose();
    super.dispose();
  }

  searchLoanDetail() async {
    if (start.text.isEmpty || close.text.isEmpty) return null;
    var response = await service.getLoanReportBwDates(start.text, close.text);

    if (response["success"]) {
      var data = response["data"];
      setState(() {
        _dataSource = DbLoanDataSource(loans: data);
      });
    } else {
      // TODO: Add Toast
    }
  }

   onPdfSave() async {
    var document = pdfkey.currentState!.exportToExcelWorkbook();
    final List<int> bytes = document.saveSync();
    Directory documentpath = await getApplicationDocumentsDirectory();
    // print(
    //     '${documentpath.path}\\Loan-Statement-${DateFormat("yyyy-MM-dd-hh-mm-ss").format(DateTime.now())}.xlsx');
    File('${documentpath.path}\\Disbursement-Report-${DateFormat("yyyy-MM-dd-hh-mm-ss").format(DateTime.now())}.xlsx')
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
          spacing: 20,
          runSpacing: 20,
          crossAxisAlignment: WrapCrossAlignment.center,
          clipBehavior: Clip.hardEdge,
          children: [
            ConstraintUI(
                child: CalendarPicker(
                    "Enter Start Date", (p0) => start.text = p0)),
            ConstraintUI(
                child:
                    CalendarPicker("Enter End Date", (p0) => close.text = p0)),
            ConstraintUI(
                child: ElevatedButton(
                    onPressed: searchLoanDetail, child: const Text("Search"))),
            ConstraintUI(
                child: ElevatedButton(
              child: const Text("Clear"),
              onPressed: () {
                setState(() {
                  _dataSource = null;
                });
              },
            )),
            ConstraintUI(
                child: _dataSource == null
                    ? Container()
                    : ElevatedButton.icon(
                        icon: const Icon(Icons.import_export),
                        onPressed: onPdfSave,
                        label: const Text("Export to excel")))
          ],
        ),
        Expanded(
            flex: 3,
            child: _dataSource == null
                ? const Text("No Data to Display")
                : DateWiseLoanTable(
                    data: _dataSource!,
                    pdfkey:pdfkey
                  )),
      ],
    );
  }
}
