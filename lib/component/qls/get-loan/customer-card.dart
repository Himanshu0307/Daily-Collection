import 'package:daily_collection/component/ui/constraint-ui.dart';
import 'package:flutter/material.dart';

import '../../../Models/SQL Entities/QuickLoanModel.dart';

class CustomerCard extends StatelessWidget {
  final CustomerModel _customer;

  const CustomerCard({super.key, required customer}) : _customer = customer;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(spacing: 20, runSpacing: 20, children: [
          ConstraintUI(child: Text("Customer Id: ${_customer.id}")),
          ConstraintUI(child: Text("Customer Name: ${_customer.name}")),
          ConstraintUI(child: Text("Mobile: ${_customer.mobile}")),
          ConstraintUI(child: Text("ID: ${_customer.aadhar ?? ""}")),
          ConstraintUI(child: Text("Father: ${_customer.aadhar ?? ""}")),
        ]),
      ),
    );
  }
}
