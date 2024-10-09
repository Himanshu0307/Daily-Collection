import 'package:daily_collection/Models/SQL%20Entities/QuickLoanModel.dart';
import 'package:daily_collection/UI/Component/CalendarPicker.dart';
import 'package:daily_collection/component/collection/dbreport/collection-table.dart';
import 'package:daily_collection/component/ui/text-wrapper.dart';
import 'package:flutter/material.dart';
import 'package:daily_collection/services/SqlService.dart';

import '../../../component/ui/constraint-ui.dart';
import '../../../data-source/dbwise-collection-datasource.dart';

class DateWiseCollectionReport extends StatefulWidget {
  const DateWiseCollectionReport({super.key});

  @override
  State<DateWiseCollectionReport> createState() =>
      _DateWiseCollectionReportState();
}

class _DateWiseCollectionReportState extends State<DateWiseCollectionReport> {
  SQLService service = SQLService();
  late TextEditingController start;
  late TextEditingController close;
  DbCollectionDatasource? _list;

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

  void searchCollectionDetail(String? startDate, String? closeDate) async {
    if (startDate == null || closeDate == null) return null;
    var response =
        await service.getCollectionReportBwDates(startDate, closeDate);
    if (response["success"]) {
      _list = DbCollectionDatasource(
          list: response["data"]! as List<DateWiseCollectionReportModel>);
    }
    setState(() {});
  }

  onClear() {
    setState(() {
      _list = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 20,
          runSpacing: 20,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ConstraintUI(
                child: CalendarPicker(
                    "Enter Start Date", (p0) => start.text = p0)),
            ConstraintUI(
                child:
                    CalendarPicker("Enter End Date", (p0) => close.text = p0)),
            ConstraintUI(
                child: ElevatedButton(
                    child: const Text("Search"),
                    onPressed: () =>
                        searchCollectionDetail(start.text, close.text))),
            ConstraintUI(
                child: ElevatedButton(
                    onPressed: onClear, child: const Text("Clear")))
          ],
        ),
        _list == null
            ? const BoldTextWrapper("Select a Date ")
            : Expanded(child: DbCollectionTable(data: _list!))
      ],
    );
  }
}
