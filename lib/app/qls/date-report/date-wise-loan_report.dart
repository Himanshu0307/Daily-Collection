import 'package:daily_collection/Models/SQL%20Entities/QuickLoanModel.dart';
import 'package:daily_collection/UI/Component/CalendarPicker.dart';
import 'package:flutter/material.dart';
import 'package:daily_collection/Services/SqlService.dart';

import '../../../component/qls/date-report/date-report-table.dart';
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
    print(response);
    if (response["success"]) {
      var data = response["data"];
      setState(() {
        _dataSource = DbLoanDataSource(loans: data);
      });
    } else {
      // TODO: Add Toast
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
            child: Row(
          children: [
            Expanded(
                child: CalendarPicker(
                    "Enter Start Date", (p0) => start.text = p0)),
            Expanded(
                child:
                    CalendarPicker("Enter End Date", (p0) => close.text = p0)),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: searchLoanDetail, child: const Text("Search")),
            )),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: const Text("Clear"),
                onPressed: () {
                  setState(() {
                    _dataSource = null;
                  });
                },
              ),
            ))
          ],
        )),
        Expanded(
            flex: 4,
            child: _dataSource == null
                ? const Text("No Data to Display")
                : DateWiseLoanTable(
                    data: _dataSource!,
                  )),
      ],
    );
  }
}
