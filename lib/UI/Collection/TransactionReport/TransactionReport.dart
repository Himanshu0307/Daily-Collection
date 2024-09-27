import 'package:daily_collection/Models/SQL%20Entities/QuickLoanModel.dart';
import 'package:daily_collection/UI/Component/CalendarPicker.dart';
import 'package:flutter/material.dart';
import 'package:daily_collection/services/SqlService.dart';

class TransactionReportDateWise extends StatefulWidget {
  const TransactionReportDateWise({super.key});

  @override
  State<TransactionReportDateWise> createState() =>
      _TransactionReportDateWiseState();
}

class _TransactionReportDateWiseState extends State<TransactionReportDateWise> {
  SQLService service = SQLService();
  late TextEditingController start;
  late TextEditingController close;

  List<DateWiseTransactionReportModel>? _list;

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

  Future<List<DateWiseTransactionReportModel>?> searchCollectionDetail(
      String? startDate, String? closeDate) async {
    if (startDate == null || closeDate == null) return null;
    return await service.getTransactionReportBwDates(startDate, closeDate);
  }

  showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  calculateTotal() {
    if (_list != null && _list!.isNotEmpty) {
      double cr = 0.0;
      double dr = 0.0;
      _list!.forEach((element) {
        if (element.type == "DR") {
          dr += element.amount;
        } else {
          cr += element.amount;
        }
      });
      return {"cr": cr, "dr": dr};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                    child: CalendarPicker(
                        "Enter Start Date", (p0) => start.text = p0)),
                Expanded(
                    child: CalendarPicker(
                        "Enter End Date", (p0) => close.text = p0)),
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
            child: _list == null || _list!.isEmpty
                ? const Text("")
                : Summary(summary: calculateTotal())),
        Expanded(
            flex: 7,
            child: _list == null || _list!.isEmpty
                ? const Text("No Data to Display")
                : ListItems(_list!)),
      ],
    );
  }
}

class Summary extends StatelessWidget {
  const Summary({super.key, required this.summary});
  final Map<String, double> summary;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Total CR: ${summary["cr"].toString()}"),
          Text("Total DR: ${summary["dr"].toString()}")
        ],
      ),
    );
  }
}

class ListItems extends StatelessWidget {
  const ListItems(this.items, {super.key});

  final List<DateWiseTransactionReportModel> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Text(items[index].type,
                textScaler: const TextScaler.linear(1.3)),
            title: Text(items[index].to),
            trailing: Text("${items[index].amount} Rs.",
                textScaler: const TextScaler.linear(1.5)),
            subtitle: Text(items[index].date),
          ),
        );
      },
    );
  }
}
