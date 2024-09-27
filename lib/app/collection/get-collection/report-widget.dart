import 'package:daily_collection/data-source/collection-datasource.dart';
import 'package:flutter/material.dart';

import '../../../Models/SQL Entities/QuickLoanModel.dart';
import '../../../services/SqlService.dart';
import '../../../UI/Component/TextFieldForm.dart';
import '../../../component/collection/get/report-table.dart';
import '../../../component/ui/constraint-ui.dart';
import '../../../component/ui/text-wrapper.dart';
import '../../../utils/toast-exception.dart';

class CollectionReport extends StatefulWidget {
  const CollectionReport({super.key});

  @override
  State<CollectionReport> createState() => _CollectionReportState();
}

class _CollectionReportState extends State<CollectionReport> {
  SQLService service = SQLService();
  late TextEditingController loanIdSearch;
  CollectionDatasource? _data;
  @override
  initState() {
    super.initState();
    loanIdSearch = TextEditingController();
  }

  @override
  dispose() {
    loanIdSearch.dispose();
    super.dispose();
  }

  void clear() {
    setState(() {
      loanIdSearch.clear();
      _data = null;
    });
  }

  onSearch() async {
    // if invalid loan id
    if (int.tryParse(loanIdSearch.text) == null) {
      throw ToastException("Invalid Loan Id");
    }

    // get loan information
    var response =
        await service.getTransactionList(int.parse(loanIdSearch.text));
    if (response["success"]) {
      setState(() {
        _data = CollectionDatasource(transaction: response["data"]);
      });
    } else {
      // TODO:Add Toast
      clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 30,
          runSpacing: 30,
          children: [
            ConstraintUI(
                child: TextFieldForm(
              "Loan Id",
              controller: loanIdSearch,
            )),
            ConstraintUI(
                child: ElevatedButton(
              onPressed: onSearch,
              child: const Text("Search"),
            )),
            ConstraintUI(
                child: ElevatedButton(
              onPressed: clear,
              child: const Text("Clear"),
            ))
          ],
        )),
        Expanded(
          flex: 4,
          child: _data == null
              ? const Center(child: BoldTextWrapper("Nothing to Display..."))
              : CollectionReportTable(
                  data: _data!,
                ),
        ),
      ],
    );
  }
}
