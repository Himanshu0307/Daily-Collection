import 'package:daily_collection/Models/SQL%20Entities/QuickLoanModel.dart';
import 'package:flutter/material.dart';
import 'package:daily_collection/Services/SqlService.dart';
import 'package:daily_collection/UI/Component/TextFieldForm.dart';

import '../../../Models/ListItem.dart';

class CollectionReport extends StatefulWidget {
  const CollectionReport({super.key});

  @override
  State<CollectionReport> createState() => _CollectionReportState();
}

class _CollectionReportState extends State<CollectionReport> {
  SQLService service = SQLService();
  late TextEditingController loanIdSearch;
  LoanModel? _loanModel;
  InstallementReportModel? _installementReportModel;
  // CustomerModel? _customerModel;
  List<ListItemModel>? _list;

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

  Future<List<ListItemModel>?> searchCollectionDetail(int? loanId) async {
    if (loanId == null) return null;
    return await service.getTransactionList(loanId);
  }

  showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Row(
          children: [
            Expanded(
                child: TextFieldForm(
              "Loan Id",
              controller: loanIdSearch,
            )),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  child: const Text("Search"),
                  onPressed: () async {
                    var result = await searchCollectionDetail(
                        int.tryParse(loanIdSearch.text));
                    if (result == null || result.isEmpty) {
                      showSnackBar(context, "No Data Found");
                    } else {
                      _loanModel = await service.getLoanModelFromLoanId(
                          int.tryParse(loanIdSearch.text));
                      _installementReportModel = await service
                          .getInstallementCard(int.tryParse(loanIdSearch.text));
                      setState(() {
                        _list = result;
                      });
                    }
                  }),
            )),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: const Text("Clear"),
                onPressed: () {
                  setState(() {
                    loanIdSearch.clear();
                    _list = null;
                  });
                },
              ),
            ))
          ],
        )),
        Expanded(
          flex: 4,
          child: _list == null || _list!.isEmpty
              ? const Text("No Data to Display")
              : Reports(
                  loanModel: _loanModel,
                  items: _list,
                  installementReportModel: _installementReportModel,
                  service: service,
                ),
        ),
      ],
    );
  }
}

class Reports extends StatelessWidget {
  final LoanModel? loanModel;
  final InstallementReportModel? installementReportModel;
  final List<ListItemModel>? items;
  final SQLService service;

  const Reports(
      {super.key,
      required this.loanModel,
      required this.items,
      required this.service,
      required this.installementReportModel});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // loanModel?.customer != null
        //     ? Expanded(child: CustomerInfo(customer: loanModel!.customer))
        //     : const SizedBox(),
        // loanModel != null
        //     ? Expanded(child: LoanInfo(loanModel: loanModel!))
        //     : const SizedBox(),
        // installementReportModel != null
        //     ? Expanded(
        //         child: InstallementReport(
        //         installementReport: installementReportModel!,
        //       ))
        //     : const SizedBox(),
        // items != null
        //     ? Expanded(
        //         flex: 5,
        //         child: ListItems(
        //           items!,
        //           service: service,
        //           isClosed: loanModel?.status == 'Closed' ?? true,
        //         ))
        //     : const SizedBox()
      ],
    );
  }
}

class InstallementReport extends StatelessWidget {
  final InstallementReportModel installementReport;

  const InstallementReport({super.key, required this.installementReport});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Flex(direction: Axis.horizontal, children: [
        Expanded(
            child: Text(
                "Remaining Amount: ${installementReport.remaining.toString()}")),
        Expanded(
            flex: 2,
            child: Text(
                "Last Installement Received: ${installementReport.lastCollection}")),
        Expanded(
            child: Text("Amount Received: ${installementReport.received}")),
        Expanded(child: Text("Overdue Amount: ${installementReport.overdue}")),
      ]),
    );
  }
}

class LoanInfo extends StatelessWidget {
  final LoanModel loanModel;

  const LoanInfo({super.key, required this.loanModel});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Flex(direction: Axis.horizontal, children: [
        Expanded(child: Text("LoanId: ${loanModel.id}")),
        Expanded(flex: 2, child: Text("Amount: ${loanModel.amount}")),
        Expanded(
            flex: 2, child: Text("Loan Start Date: ${loanModel.startDate}")),
        Expanded(flex: 2, child: Text("Loan close Date: ${loanModel.endDate}")),
        Expanded(
            flex: 2,
            child: Text("Agreement Amount: ${loanModel.agreedAmount}")),
      ]),
    );
  }
}

class CustomerInfo extends StatelessWidget {
  final CustomerModel _customer;

  const CustomerInfo({super.key, required customer}) : _customer = customer;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Flex(direction: Axis.horizontal, children: [
        Expanded(child: Text("Customer Id: ${_customer.id}")),
        Expanded(child: Text("Customer Name: ${_customer.name}")),
        Expanded(child: Text("Mobile: ${_customer.mobile}")),
        Expanded(child: Text("ID: ${_customer.aadhar ?? ""}")),
      ]),
    );
  }
}

class ListItems extends StatefulWidget {
  const ListItems(this.items,
      {super.key, required this.isClosed, required this.service});
  final bool isClosed;
  final SQLService service;
  final List<ListItemModel> items;

  @override
  State<ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Text(
                "Total Credit Balance: ${widget.items[index].totalPaidAmounttillDate} Rs.",
                textScaler: const TextScaler.linear(1.3)),
            title: Text(widget.items[index].type == "DR"
                ? "Debited to Customer"
                : "Customer Paid"),
            trailing: SizedBox(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                      "${widget.items[index].type == "DR" ? '-' : '+'} ${widget.items[index].amount.toString()} Rs.",
                      textScaler: const TextScaler.linear(1.5)),
                  ElevatedButton.icon(
                      onPressed: widget.isClosed ||
                              widget.items[index].type == "DR"
                          ? null
                          : () {
                              if (widget.items[index].id != null) {
                                widget.service
                                    .deleteCollection(widget.items[index].id)
                                    .then((value) {
                                  if (value.success == true) {
                                    showSnackBar(context, value.msg);
                                    setState(() {
                                      widget.items.remove(widget.items[index]);
                                    });
                                  } else {
                                    showSnackBar(context, value.error);
                                  }
                                });
                              }
                            },
                      icon: const Icon(Icons.delete),
                      label: const Text("Delete"))
                ],
              ),
            ),
            subtitle: Text(widget.items[index].collectionDate!),
          ),
        );
      },
    );
  }
}
