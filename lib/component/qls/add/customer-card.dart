import 'package:flutter/material.dart';

import '../../../Models/SQL Entities/QuickLoanModel.dart';
import '../../ui/constraint-ui.dart';

class QLSCustomerCard extends StatelessWidget {
  const QLSCustomerCard({
    super.key,
    required this.model,
  });

  final CustomerModel model;

  getTextStyle() {
    return const TextStyle(fontWeight: FontWeight.w600, fontSize: 15);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          direction: Axis.horizontal,
          spacing: 20,
          runSpacing: 20,
          children: [
            // id
            ConstraintUI(
              child: Text(
                "CUSTOMERID: ${model.id ?? "INFO NOT AVAILABLE"}",
                style: getTextStyle(),
              ),
            ),
            // name
            ConstraintUI(
              child: Text(
                "NAME: ${model.name}",
                style: getTextStyle(),
              ),
            ),

            // mobile
            ConstraintUI(
              child: Text("MOBILE: ${model.mobile}", style: getTextStyle()),
            ),

            // Address
            ConstraintUI(
              child: Text("ADDRESS: ${model.address}", style: getTextStyle()),
            ),
            // Address
            ConstraintUI(
              child: Text("DOCUMENT NUMBER: ${model.aadhar}",
                  style: getTextStyle()),
            ),
            // Address
            ConstraintUI(
              child:
                  Text("FATHER'S NAME: ${model.father}", style: getTextStyle()),
            ),
          ],
        ),
      ),
    );
  }
}
