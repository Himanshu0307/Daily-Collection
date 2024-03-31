import 'package:daily_collection/Models/SQL%20Entities/QuickLoanModel.dart';
import 'package:daily_collection/UI/Component/CalendarPicker.dart';
import 'package:flutter/material.dart';
import 'package:daily_collection/Services/SqlService.dart';


class DateWiseLoanReport extends StatefulWidget {
  const DateWiseLoanReport({super.key});

  @override
  State<DateWiseLoanReport> createState() => _DateWiseLoanReportState();
}

class _DateWiseLoanReportState extends State<DateWiseLoanReport> {
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

  Future<List<DateWiseCollectionReportModel>?> searchCollectionDetail(
      String? startDate, String? closeDate) async {
    if (startDate == null || closeDate == null) return null;
    return await service.getLoanReportBwDates(startDate, closeDate);
  }

  showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
                  child: const Text("Search"),
                  onPressed: () async {
                    searchCollectionDetail(start.text, close.text).then(
                        (value) => value == null
                            ? showSnackBar(context, "No Data Found")
                            : setState(() => _list = value));
                  }),
            )),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: const Text("Clear"),
                onPressed: () {
                  setState(() {
                    _list = null;
                  });
                },
              ),
            ))
          ],
        )),
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
        return Card(
          child: ListTile(
            leading: Text("Loan Id: ${items[index].loanId} ",
                textScaler: const TextScaler.linear(1.3)),
            title: Text("${items[index].name}(${items[index].cid})"),
            trailing: Text("${items[index].amount} Rs.",
                textScaler: const TextScaler.linear(1.5)),
            subtitle: Text(items[index].collectionDate),
          ),
        );
      },
    );
  }
}
