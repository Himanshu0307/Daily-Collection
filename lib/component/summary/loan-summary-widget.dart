import 'package:flutter/material.dart';

import '../../Models/SQL Entities/QuickLoanModel.dart';
import '../../Services/SqlService.dart';
import '../ui/constraint-ui.dart';

class LoanSummary extends StatefulWidget {
  const LoanSummary({super.key});

  @override
  State<LoanSummary> createState() => _LoanListState();
}

class _LoanListState extends State<LoanSummary> {
  SQLService service = SQLService();

  List<LoanModel> _items = [];

  var filter = "active";

  onFilterChange(value) {
    setState(() {
      filter = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Wrap(
          children: [
            ConstraintUI(
              child: RadioMenuButton(
                  value: 'active',
                  groupValue: filter,
                  onChanged: onFilterChange,
                  child: const Text("Active")),
            ),
            ConstraintUI(
              child: RadioMenuButton(
                  value: 'close',
                  groupValue: filter,
                  onChanged: onFilterChange,
                  child: const Text("Closed")),
            ),
            ConstraintUI(
              child: RadioMenuButton(
                  value: 'all',
                  groupValue: filter,
                  onChanged: onFilterChange,
                  child: const Text("All")),
            )
          ],
        )
      
      ],
    );
  }
}
