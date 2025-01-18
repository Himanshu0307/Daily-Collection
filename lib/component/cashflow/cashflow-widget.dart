import 'dart:developer';

import 'package:flutter/material.dart';

import '../../Models/SQL Entities/QuickLoanModel.dart';
import '../../UI/Component/CalendarPicker.dart';
import '../../UI/Component/TextFieldForm.dart';
import '../../data-source/cashflow-datasource.dart';
import '../../data-source/transaction-datasource.dart';
import '../../services/SqlService.dart';
import '../../utils/toastshow.dart';
import '../collection/transaction/transaction-table.dart';
import '../ui/constraint-ui.dart';
import 'cashflow-table.dart';

class CashflowWidget extends StatefulWidget {
  const CashflowWidget({super.key});

  @override
  State<CashflowWidget> createState() => _CashflowWidgetState();
}

class _CashflowWidgetState extends State<CashflowWidget> {
  SQLService service = SQLService();
  late TextEditingController start;
  late TextEditingController close;
  late TextEditingController initialClosing;
  bool isLoading = false;
  double initial = 0.0;

  Map<String, Map<String, Map<String, dynamic>>>? _list;

  @override
  initState() {
    super.initState();
    start = TextEditingController();
    close = TextEditingController();
    initialClosing = TextEditingController(text: "0.0");
  }

  @override
  dispose() {
    start.dispose();
    close.dispose();
    initialClosing.dispose();
    super.dispose();
  }

  Future<List<DateWiseTransactionReportModel>?> searchCollectionDetail(
      String? startDate, String? closeDate) async {
    setState(() {
      isLoading = true;
    });

    if (startDate == null || closeDate == null) return null;
    var response = await service.getCashflowReportBwDates(startDate, closeDate);
    if (response["success"]) {
      setState(() {
        initialClosing.text = "0.0";

        _list = formatData(response["data"]);
        isLoading = false;
      });
    } else {
      setState(() {
        initialClosing.text = "0.0";
        isLoading = false;
        _list = null;
      });
      showToast(response["message"]);
    }
    initial = 0.0;
  }

// format the data in given format
  formatData(List<DateWiseTransactionReportModel> list) {
    Map<String, Map<String, Map<String, dynamic>>> fdata = {};
    double opening = 0.0;
    for (var e in list) {
      // if entry is not there
      if (!fdata.containsKey(e.date)) {
        // Add date key
        fdata[e.date] = {
          e.to: {
            'opening': opening,
            // (e.type == 'CR' ? 'Credit' : 'Debit'): e.amount
          }
        };
      }
      if (!fdata[e.date]!.containsKey(e.to)) {
        fdata[e.date] = {
          e.to: {
            'opening': opening,
            // (e.type == 'CR' ? 'Credit' : 'Debit'): e.amount
          }
        };
      }

      // if credit then add in balance
      if (e.type == 'CR') {
        opening += e.amount;
      }
      // else subtract from balance
      else {
        opening -= e.amount;
      }

      if (e.type == 'CR') {
        fdata[e.date]![e.to]!['credit'] = e.amount;
      } else if (e.type == 'DR') {
        fdata[e.date]![e.to]!['debit'] = e.amount;
      }
      fdata[e.date]![e.to]!['closing'] = opening;
    }
    return fdata;

    // log(fdata.toString());
  }

// recalculate
  recalculate() {
    if (initialClosing.text.isEmpty ||
        double.tryParse(initialClosing.text) == null) {
      showToast("Invalid Value in intial Closing value");
      return;
    }
    // set Loading BAr
    setState(() {
      isLoading = true;
    });

    log(initial.toString());
    initial = double.parse(initialClosing.text) - initial;
    // log(initial.toString());

    // recalculate
    _list?.forEach((k1, v1) {
      v1.forEach((k2, v2) {
        v2['opening'] += initial;
        v2['closing'] += initial;
      });
    });

    initial = double.parse(initialClosing.text);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
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
                  initialClosing.text = "0.0";
                  initial = 0.0;
                  _list = null;
                });
              },
            )),
            ConstraintUI(
                child: TextField(
              controller: initialClosing,
              decoration:
                  const InputDecoration(label: Text("Last Closing Balance")),
              enabled: _list != null,
            )),
            ConstraintUI(
                child: ElevatedButton(
              onPressed: _list == null ? null : recalculate,
              child: const Text("Recalculate"),
            )),
          ],
        ),
        Expanded(
            flex: 7,
            child: _list == null || _list!.isEmpty
                ? const Text("No Data to Display")
                : isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : CashflowTable(
                        data: CashflowDataSource(transaction: _list!),
                      )),
      ],
    );
  }
}
