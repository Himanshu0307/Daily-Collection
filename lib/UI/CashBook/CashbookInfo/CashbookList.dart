import 'package:daily_collection/Models/CashbookEntity/CashbookEntity.dart';
import 'package:daily_collection/Services/Cashbook.dart';
import 'package:daily_collection/UI/Component/CalendarPicker.dart';
import 'package:daily_collection/UI/Component/TableComponent.dart';
import 'package:flutter/material.dart';

import '../../Component/AutoCompleteWidget.dart';

class CashbookList extends StatefulWidget {
  const CashbookList({super.key});

  @override
  State<CashbookList> createState() => _CashbookListState();
}

class _CashbookListState extends State<CashbookList> {
  CashBookService service = CashBookService();
  late TextEditingController start;
  late TextEditingController close;
  late TextEditingController name;
  List<CashbookModel>? _list;
  List<String>? names = [];

  @override
  initState() {
    super.initState();
    start = TextEditingController();
    close = TextEditingController();
    name = TextEditingController();
    getNameOfExistingUser();
  }

  @override
  dispose() {
    start.dispose();
    close.dispose();
    name.dispose();
    super.dispose();
  }

  Future<List<CashbookModel>?> searchCollectionDetail(
      String? startDate, String? closeDate, String? name) async {
    if (startDate == null || closeDate == null) return null;
    return await service.getAllCash(startDate, closeDate, name);
  }

  void getNameOfExistingUser() {
    service
        .getSuggestionListOfNames()
        .then((value) => setState(() => names = value));
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
                child: AutoCompleteWidget(
              names ?? [],
              controller: name,
              onSelected: null,
            )),
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
                    searchCollectionDetail(start.text, close.text, name.text)
                        .then((value) => value == null
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
        _list != null && _list!.isNotEmpty
            ? Expanded(
                child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "Total DR: ${_list!.fold(0, (previousValue, element) => element.type == "DR" ? previousValue + element.amount : previousValue)}"),
                    Text(
                        "Total CR: ${_list!.fold(0, (previousValue, element) => element.type == "CR" ? previousValue + element.amount : previousValue)}")
                  ],
                ),
              ))
            : const SizedBox(),
        Expanded(
          flex: 7,
          child: _list == null || _list!.isEmpty
              ? const Text("No Data to Display")
              : TableComponent(_list!.map((e) => e.toMap()).toList()),
        )
      ],
    );
  }
}
