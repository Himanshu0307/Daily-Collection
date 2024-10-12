import 'dart:developer';

import 'package:daily_collection/component/ui/text-wrapper.dart';
import 'package:daily_collection/services/SqlService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../Models/SQL Entities/QuickLoanModel.dart';
import '../../../component/customer/customer-search.dart';
import '../../../component/customer/report/customer-report.dart';
import '../../../data-source/customer_loan-datasource.dart';

class CustomerReportWidget extends StatefulWidget {
  const CustomerReportWidget({super.key});

  @override
  State<CustomerReportWidget> createState() => _CustomerReportWidgetState();
}

class _CustomerReportWidgetState extends State<CustomerReportWidget> {
  CustomerLoanDataSource? _datasource;
  final SQLService _service = SQLService();

  onCustomerSearch(customer) async {
    if (customer != null) {
      var response = await _service.getLoanListFromCid(customer.id);
      log(response.toString());
      if (response["success"]) {
        List<CustomerLoanReportModel> report =
            (response["data"] as List<Map<String, dynamic>>)
                .map((x) => CustomerLoanReportModel.fromJson(x))
                .toList();
        _datasource = CustomerLoanDataSource(transaction: report);
      }
    } else {
      _datasource = null;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 20,
      spacing: 20,
      children: [
        CustomerSearchField(onSelected: onCustomerSearch),
        _datasource == null
            ? const Center(child: BoldTextWrapper("Select a customer"))
            : CustomerReport(
                data: _datasource!,
              )
      ],
    );
  }
}
