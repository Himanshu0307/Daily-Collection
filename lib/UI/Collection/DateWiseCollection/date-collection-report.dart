import 'package:daily_collection/Models/SQL%20Entities/QuickLoanModel.dart';
import 'package:daily_collection/UI/Component/CalendarPicker.dart';
import 'package:flutter/material.dart';
import 'package:daily_collection/services/SqlService.dart';

import '../../../component/ui/constraint-ui.dart';

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

  List<DateWiseCollectionReportModel>? _list;

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
      print(response["data"]);
    }
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
        Expanded(
            flex: 4,
            child: _list == null || _list!.isEmpty
                ? const Text("No Data to Display")
                : ListItems(_list!)),
      ],
    );
  }
}

class ListItems extends StatelessWidget {
  const ListItems(this.items, {super.key});

  final List<DateWiseCollectionReportModel> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        // return Card(
        //   child: ListTile(
        //     leading: Text("Loan Id: ${items[index].loanId} ",
        //         textScaler: const TextScaler.linear(1.3)),
        //     title: Text("${items[index].name}(${items[index].cid})"),
        //     trailing: Text("${items[index].amount} Rs.",
        //         textScaler: const TextScaler.linear(1.5)),
        //     subtitle: Text(items[index].collectionDate),
        //   ),
        // );
        return Container();
      },
    );
  }
}
