import 'package:flutter/material.dart';

import '../../../Models/PostResponse.dart';
import '../../../Models/SQL Entities/QuickLoanModel.dart';
import '../../../services/SqlService.dart';
import '../../../component/collection/add/info-widget.dart';
import '../../../component/customer/customer-search.dart';
import '../../../component/ui/text-wrapper.dart';

class CollectionAddWidget extends StatefulWidget {
  const CollectionAddWidget({super.key});

  @override
  State<CollectionAddWidget> createState() => _CollectionAddWidgetState();
}

class _CollectionAddWidgetState extends State<CollectionAddWidget> {
  final SQLService service = SQLService();
  TransactionReportModel? info;
  Future<PostResponse> saveCollection(CollectionModel collectionModel) async {
    var response = await service.saveCollection(collectionModel);
    return response;
  }

  onCustomerSelect(customer) async {
    if (customer == null) {
      info = null;
    }
    if (customer != null) {
      List<ELoanModel> listLoan = await fetchLoanDetails(customer);

      info = TransactionReportModel()
        ..customerModel = customer
        ..loanModel = listLoan;
    }
    setState(() {});
  }

  Future<List<ELoanModel>> fetchLoanDetails(customer) async {
    var response = await service.getActiveLoanListFromCid(customer.id);
    if (response["success"]) {
      return (response["data"] as List<Map<String, Object?>>)
          .map<ELoanModel>((x) => ELoanModel.fromJson(x))
          .toList();
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomerSearchField(onSelected: onCustomerSelect),
        const SizedBox(
          height: 20,
        ),
        Expanded(
            child: info == null
                ? const BoldTextWrapper("Select a customer")
                : InfoWidget(details: info!))
      ],
    );
  }
}
