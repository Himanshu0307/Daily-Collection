
import 'package:flutter/material.dart';
import 'package:daily_collection/Models/SQL%20Entities/QuickLoanModel.dart';

import '../../../Models/PostResponse.dart';
import '../../../Services/SqlService.dart';
import '../../Component/DropdownWIdget.dart';
import '../../Component/TextFieldForm.dart';

class LoanClosureWidget extends StatefulWidget {
  const LoanClosureWidget({super.key});

  @override
  State<LoanClosureWidget> createState() => _LoanClosureWidgetState();
}

class _LoanClosureWidgetState extends State<LoanClosureWidget> {
  bool isFetching = false;
  SQLService service = SQLService();

  List<LoanModel>? _loanModelCollection;
  TextEditingController name = TextEditingController();
  TextEditingController loanId = TextEditingController();

  Future<List<LoanModel>?> searchCustomer() async {
    if (name.text.isEmpty) return null;
    return await service.getCustomerAndLoanInfo(name.text);
  }

  Future<PostResponse> closeLoan(int loanId) async {
    var response = await service.CloseLoan(loanId);
    return response;
  }

  void clearData() {
    setState(() {
      _loanModelCollection = null;
      name.clear();
      loanId.clear();
    });
  }

  void showSnackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  flex: 1,
                  child: TextFieldForm(
                    "Customer Name",
                    controller: name,
                    required: true,
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: isFetching
                          ? null
                          : () async {
                              _loanModelCollection = await searchCustomer();
                              if (_loanModelCollection == null ||
                                  _loanModelCollection!.isEmpty) {
                                showSnackBar(context,
                                    "No Customer Data found with Active Loan");
                              } else {
                                setState(() {});
                              }
                            },
                      child: const Text("Search Customer")),
                ))
              ],
            ),
            _loanModelCollection == null || _loanModelCollection!.isEmpty
                ? const Text("No Customer Selected")
                : Column(
                    children: [
                      CustomerInfoView(_loanModelCollection![0].customer),
                      LoanInfoView(_loanModelCollection, clearData, closeLoan)
                    ],
                  )
          ],
        ),
      ),
    );
  }
}

class CustomerInfoView extends StatelessWidget {
  final CustomerModel? _customerModel;

  const CustomerInfoView(this._customerModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                  child: TextFieldForm(
                "Customer Id",
                initialValue: _customerModel?.id.toString(),
                enabled: false,
              )),
              Expanded(
                  child: TextFieldForm(
                "Customer Name",
                initialValue: _customerModel?.name,
                enabled: false,
              )),
              Expanded(
                  child: TextFieldForm(
                "Customer Mobile Number",
                initialValue: _customerModel?.mobile,
                enabled: false,
              ))
            ],
          ),
        ],
      ),
    );
  }
}

class LoanInfoView extends StatelessWidget {
  final List<LoanModel>? loanList;
  final Function onClear;
  final Function(int) onDelete;

  int? requestLoanId;
  late List<int?> dropdownData;

  LoanInfoView(this.loanList, this.onClear, this.onDelete, {super.key}) {
    dropdownData = loanList!.map((e) => e.id).toList();
    requestLoanId = dropdownData[0];
  }

  void showSnackbar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(content)));
  }

  showConfirmDialog(BuildContext context, int? loanId) {
    if (loanId == null) return;
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
                content: Text("Are you sure you want to Close Loan : $loanId"),
                title: const Text("Loan Closure"),
                actions: [
                  ElevatedButton(
                    onPressed: () async {
                      var response = await onDelete(loanId);
                      Navigator.pop(context);
                      showSnackbar(
                          context,
                          (response as PostResponse).success
                              ? response.msg
                              : response.error);
                    },
                    child: const Text("Delete"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel"),
                  )
                ]));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ...loanList!
              .map(
                (x) => Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                        child: TextFieldForm(
                      "LoanId",
                      initialValue: x.id?.toString(),
                      enabled: false,
                    )),
                    Expanded(
                        child: TextFieldForm(
                      "Amount",
                      initialValue: x.amount?.toString(),
                      enabled: false,
                    )),
                    Expanded(
                        flex: 2,
                        child: TextFieldForm(
                          "Agreed Amount",
                          initialValue: x.agreedAmount?.toString(),
                          enabled: false,
                        )),
                    Expanded(
                        flex: 2,
                        child: TextFieldForm(
                          "Start Date",
                          initialValue: x.startDate,
                          enabled: false,
                        )),
                    Expanded(
                        flex: 2,
                        child: TextFieldForm(
                          "Close Date",
                          initialValue: x.endDate,
                          enabled: false,
                        )),
                  ],
                ),
              )
              .toList(),
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: DropdownWidget(dropdownData, (e) => requestLoanId = e),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () =>
                          showConfirmDialog(context, requestLoanId),
                      child: const Text("Delete")),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () => onClear(), child: const Text("Clear")),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
