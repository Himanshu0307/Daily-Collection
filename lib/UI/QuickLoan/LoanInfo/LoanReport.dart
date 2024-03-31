import 'package:daily_collection/Models/SQL%20Entities/QuickLoanModel.dart';
import 'package:flutter/material.dart';
import 'package:daily_collection/Services/SqlService.dart';
import 'package:daily_collection/UI/Component/TextFieldForm.dart';

class LoanReport extends StatefulWidget {
  const LoanReport({super.key});

  @override
  State<LoanReport> createState() => _LoanReportState();
}

class _LoanReportState extends State<LoanReport> {
  SQLService service = SQLService();
  late TextEditingController loanIdSearch;
  LoanModel? _loanModel;
  InstallementReportModel? _installementReportModel;

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
      _loanModel = null;
    });
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
                    service
                        .getLoanModelFromLoanId(int.tryParse(loanIdSearch.text))
                        .then((value) {
                      if (value == null) {
                        showSnackBar(context, "No Data Found");
                      } else {
                        _loanModel = value;
                        service
                            .getInstallementCard(
                                int.tryParse(loanIdSearch.text))
                            .then((value1) => setState(() {
                                  // print(_installementReportModel);
                                  _installementReportModel = value1;
                                }));
                      }
                    });
                    // if (result == null) {
                    //   showSnackBar(context, "No Data Found");
                    // } else {
                    //   _installementReportModel = await service
                    //       .getInstallementCard(int.tryParse(loanIdSearch.text));
                    //   setState(() {});
                    // }
                  }),
            )),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: clear,
                child: const Text("Clear"),
              ),
            ))
          ],
        )),
        Expanded(
          flex: 4,
          child: _loanModel == null
              ? const Text("No Data to Display")
              : Reports(
                  loanModel: _loanModel,
                  installementReportModel: _installementReportModel,
                  onClear: clear),
        ),
      ],
    );
  }
}

class Reports extends StatelessWidget {
  final LoanModel? loanModel;
  final Function onClear;
  final InstallementReportModel? installementReportModel;

  const Reports(
      {super.key,
      required this.loanModel,
      required this.onClear,
      required this.installementReportModel});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        loanModel?.customer != null
            ? Expanded(child: CustomerInfo(customer: loanModel!.customer))
            : const SizedBox(),
        loanModel != null
            ? Expanded(
                flex: 2,
                child: LoanInfo(loanModel: loanModel!, onClear: onClear))
            : const SizedBox(),
        installementReportModel != null
            ? Expanded(
                child: InstallementReport(
                installementReport: installementReportModel!,
              ))
            : const SizedBox(),
      ],
    );
  }
}

class InstallementReport extends StatelessWidget {
  final InstallementReportModel installementReport;

  const InstallementReport({super.key, required this.installementReport});
  @override
  Widget build(BuildContext context) {
    // print(installementReport.lastCollection);
    return Card(
      child: Flex(direction: Axis.horizontal, children: [
        Expanded(
            child: Text(
                "Remaining Amount: ${installementReport.remaining.toString()}")),
        Expanded(
            child: Text(
                "Last Installement Received: ${installementReport.lastCollection}")),
        Expanded(
            child: Text(
                "Amount Received: ${installementReport.received.toString()}")),
        Expanded(
            child: Text(
                "Overdue Amount: ${installementReport.overdue.toString()}")),
      ]),
    );
  }
}

class LoanInfo extends StatelessWidget {
  final LoanModel loanModel;
  final Function onClear;

  const LoanInfo({
    super.key,
    required this.loanModel,
    required this.onClear,
  });

  showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flex(direction: Axis.horizontal, children: [
            Expanded(child: Text("LoanId: ${loanModel.id}")),
            Expanded(flex: 2, child: Text("Amount: ${loanModel.amount}")),
            Expanded(
                flex: 2,
                child: Text("Loan Start Date: ${loanModel.startDate}")),
            Expanded(
                flex: 2, child: Text("Loan close Date: ${loanModel.endDate}")),
            Expanded(
                flex: 2,
                child: Text("Agreement Amount: ${loanModel.agreedAmount}")),
          ]),
          Flex(direction: Axis.horizontal, children: [
            Expanded(child: Text("Witness: ${loanModel.witnessName ?? ""}")),
            Expanded(
                flex: 2,
                child:
                    Text("Witness Address: ${loanModel.witnessAddress ?? ""}")),
            Expanded(
                child:
                    Text("Witness Mobile: ${loanModel.witnessMobile ?? ""}")),
          ]),
          Flex(direction: Axis.horizontal, children: [
            Expanded(
                child: Text(
                    "Installement Amount: ${loanModel.installement ?? ""}")),
            Expanded(child: Text("Loan Tenure: ${loanModel.days ?? ""}")),
            Expanded(child: Text("Status: ${loanModel.status ?? ""}")),
            Expanded(
                child: ElevatedButton.icon(
                    onPressed: loanModel.status == "Closed"
                        ? null
                        : () {
                            var service = SQLService();
                            service
                                .deleteLoan(loanModel.id)
                                .then((value) => value.success
                                    ? showSnackBar(context, value.msg)
                                    : showSnackBar(context, value.error))
                                .whenComplete(() => onClear());
                          },
                    icon: const Icon(Icons.delete),
                    label: const Text("Delete Loan"))),
          ]),
        ],
      ),
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
        Expanded(child: Text("father: ${_customer.aadhar ?? ""}")),
      ]),
    );
  }
}
