import 'package:flutter/material.dart';
import 'package:daily_collection/UI/Component/RadioButton.dart';

import 'QuickLoanAddNewCustomer.dart';
import 'QuickLoanAddForm.dart';

class QuickLoanScreen extends StatefulWidget {
  const QuickLoanScreen({super.key});
  static const routeName = "QuickLoan";

  @override
  State<QuickLoanScreen> createState() => _QuickLoanScreenState();
}

class _QuickLoanScreenState extends State<QuickLoanScreen> {
  String groupValue = "New";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QuickLoan"),
      ),
      body: Column(
        children: [
          Expanded(
              child: Row(
            children: [
              RadioComponent(
                text: "New Customer",
                onChanged: (changedValue) {
                  setState(() {
                    groupValue = changedValue;
                  });
                },
                value: "New",
                groupValue: groupValue,
              ),
              RadioComponent(
                  text: "Existing  Customer",
                  onChanged: (changedValue) {
                    setState(() {
                      groupValue = changedValue;
                    });
                  },
                  groupValue: groupValue,
                  value: "Existing"),
            ],
          )),
          Expanded(
              flex: 6,
              child: groupValue == "New"
                  ? const QuickLoanAddForm()
                  : const QuickLoanAddExistingCustomer())
        ],
      ),
    );
  }
}
