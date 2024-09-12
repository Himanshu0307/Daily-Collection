import 'package:daily_collection/component/ui/constraint-ui.dart';
import 'package:flutter/material.dart';
import 'package:daily_collection/UI/Component/RadioButton.dart';
import 'existing-loan/qls-existing-customer-loan.dart';
import 'qls-new-customer.dart';

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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Wrap(
            direction: Axis.horizontal,
            children: [
              ConstraintUI(
                child: RadioComponent(
                  text: "New Customer",
                  onChanged: (changedValue) {
                    setState(() {
                      groupValue = changedValue;
                    });
                  },
                  value: "New",
                  groupValue: groupValue,
                ),
              ),
              ConstraintUI(
                child: RadioComponent(
                    text: "Existing  Customer",
                    onChanged: (changedValue) {
                      setState(() {
                        groupValue = changedValue;
                      });
                    },
                    groupValue: groupValue,
                    value: "Existing"),
              ),
            ],
          )),
          Expanded(
              flex: 6,
              child: groupValue == "New"
                  ? QLSNewLoanForm()
                  : const QLSExistingCustomerLoanAdd())
        ],
      ),
    );
  }
}
