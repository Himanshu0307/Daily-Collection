import 'package:flutter/material.dart';

import '../../../Models/SQL Entities/QuickLoanModel.dart';
import '../../../services/SqlService.dart';
import '../../../UI/Component/TextFieldForm.dart';
import '../../../component/ui/constraint-ui.dart';
import '../../../component/ui/text-wrapper.dart';
import '[id]/report-widget.dart';
import '../../../utils/toast-exception.dart';

class LoanReport extends StatefulWidget {
  const LoanReport({super.key});

  @override
  State<LoanReport> createState() => _LoanReportState();
}

class _LoanReportState extends State<LoanReport> {
  SQLService service = SQLService();
  late TextEditingController loanIdSearch;
  LoanReportIdModel? _loanInfo;

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
      _loanInfo = null;
    });
  }

  onSearch() async {
    // if invalid loan id
    if (int.tryParse(loanIdSearch.text) == null) {
      throw ToastException("Invalid Loan Id");
    }

    // get loan information
    var response =
        await service.getLoanReportFromId(int.parse(loanIdSearch.text));
    if (response["success"]) {
      setState(() {
        _loanInfo = response["data"];
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
        Wrap(
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
        ),
        Expanded(
          flex: 4,
          child: _loanInfo == null
              ? const Center(child: BoldTextWrapper("Nothing to Display..."))
              : ReportsWidget(
                  info: _loanInfo!,
                  onClear: clear,
                ),
        ),
      ],
    );
  }
}
