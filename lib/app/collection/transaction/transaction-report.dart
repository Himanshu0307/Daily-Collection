import 'package:daily_collection/Models/SQL%20Entities/QuickLoanModel.dart';
import 'package:daily_collection/UI/Component/CalendarPicker.dart';
import 'package:flutter/material.dart';
import 'package:daily_collection/services/SqlService.dart';

import '../../../component/collection/transaction/transaction-table.dart';
import '../../../component/ui/constraint-ui.dart';
import '../../../data-source/transaction-datasource.dart';
import '../../../utils/toastshow.dart';

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
    var response =
        await service.getTransactionReportBwDates(startDate, closeDate);
    if (response["success"]) {
      setState(() {
        _list = response["data"];
      });
    } else {
      setState(() {
        _list=null;
      });
      showToast(response["message"]);
    }
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
                    onPressed: () async {
                      searchCollectionDetail(start.text, close.text);
                    })),
            ConstraintUI(
                child: ElevatedButton(
              child: const Text("Clear"),
              onPressed: () {
                setState(() {
                  _list = null;
                });
              },
            )),
          ],
        ),
        Expanded(
            flex: 7,
            child: _list == null || _list!.isEmpty
                ? const Text("No Data to Display")
                : TransactionTable(
                    data: TransactionDatasource(transaction: _list!),
                    summary: calculateTotal(),
                  )),
      ],
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
