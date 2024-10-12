import 'package:daily_collection/Models/SQL%20Entities/QuickLoanModel.dart';
import 'package:daily_collection/services/SqlService.dart';
import 'package:daily_collection/component/customer/customer-search.dart';
import 'package:daily_collection/component/ui/autocomplete.dart';
import 'package:daily_collection/utils/object-wrapper.dart';
import 'package:flutter/material.dart';

import '../../../../component/qls/add/qls-existing-form.dart';

class QLSExistingCustomerLoanAdd extends StatefulWidget {
  const QLSExistingCustomerLoanAdd({super.key});

  @override
  State<QLSExistingCustomerLoanAdd> createState() =>
      _QLSExistingCustomerLoanAddState();
}

class _QLSExistingCustomerLoanAddState
    extends State<QLSExistingCustomerLoanAdd> {
  CustomerModel? customer;
  SQLService service = SQLService();

// if customer is  selected then re render UI
  void onCustomerSelected(CustomerModel? selectedValue) {
    setState(() {
      customer = selectedValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        CustomerSearchField(
          onSelected: onCustomerSelected,
        ),
        Expanded(
            flex: 5,
            child: customer != null
                ? QLSExistingCustomerForm(model: customer!)
                : const Text(
                    "NO CUSTOMER SELECTED 🤦‍♂️",
                    style: TextStyle(fontSize: 30),
                  ))
      ],
    );
  }
}
