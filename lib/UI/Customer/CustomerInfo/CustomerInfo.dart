
import 'package:daily_collection/UI/Component/CustomerSearchnew.dart';
import 'package:flutter/material.dart';
import 'package:daily_collection/Models/SQL%20Entities/QuickLoanModel.dart';

import '../../../services/SqlService.dart';

import '../../Component/TextFieldForm.dart';

class CustomerSearchReport extends StatefulWidget {
  const CustomerSearchReport({super.key});

  @override
  State<CustomerSearchReport> createState() => _CustomerSearchReportState();
}

class _CustomerSearchReportState extends State<CustomerSearchReport> {
  bool isFetching = false;
  SQLService service = SQLService();

  List<LoanModel>? _loanModelCollection;
  CustomerModel? _customerModel;
  TextEditingController name = TextEditingController();
  TextEditingController loanId = TextEditingController();

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
                              _customerModel = await showCustomerSearch(context,
                                  onChanged: service.searchCustomerForLoan,
                                  initialValue: name.text);
                              if (_customerModel == null) return;
                              if (_customerModel?.id != null) {
                                _loanModelCollection = await service
                                    .getCustomerAndLoanInfoIgnoreStatus(
                                        _customerModel!.id!);
                              }
                              if (_loanModelCollection == null ||
                                  _loanModelCollection!.isEmpty) {
                                showSnackBar(context, "No Loan Data Found");
                              } else {
                                setState(() {});
                              }
                            },
                      child: const Text("Search Customer")),
                )),
                Expanded(
                  child: ElevatedButton(
                    child: const Text("Clear"),
                    onPressed: () {
                      setState(() {
                        _customerModel = null;
                        _loanModelCollection = null;
                      });
                    },
                  ),
                )
              ],
            ),
            _customerModel == null ||
                    _loanModelCollection == null ||
                    _loanModelCollection!.isEmpty
                ? const Text("No Customer Selected")
                : Column(
                    children: [
                      CustomerInfoView(_customerModel!),
                      LoanInfoView(
                        _loanModelCollection!,
                      )
                    ],
                  )
          ],
        ),
      ),
    );
  }
}

class CustomerInfoView extends StatelessWidget {
  final CustomerModel _customerModel;

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
                initialValue: _customerModel.id.toString(),
                enabled: false,
              )),
              Expanded(
                  child: TextFieldForm(
                "Customer Name",
                initialValue: _customerModel.name,
                enabled: false,
              )),
              Expanded(
                  child: TextFieldForm(
                "Customer Mobile Number",
                initialValue: _customerModel.mobile,
                enabled: false,
              ))
            ],
          ),
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                  flex: 2,
                  child: TextFieldForm(
                    "Customer Address",
                    initialValue: _customerModel.address,
                    enabled: false,
                  )),
              Expanded(
                  child: TextFieldForm(
                "ID",
                initialValue: _customerModel.aadhar,
                enabled: false,
              )),
              Expanded(
                  child: TextFieldForm(
                "Father",
                initialValue: _customerModel.father,
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
  final List<LoanModel> loanList;

  const LoanInfoView(this.loanList, {super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ...loanList
              .map(
                (x) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Expanded(
                                  child: Text(
                                "LoanId: ${x.id?.toString() ?? ''}",
                              )),
                              Expanded(
                                  child: Text(
                                "Amount: ${x.amount?.toString() ?? ''}",
                              )),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                      "Agreed Amount: ${x.agreedAmount?.toString() ?? ''}")),
                              Expanded(
                                  flex: 2,
                                  child:
                                      Text("Start Date: ${x.startDate ?? ''}")),
                              Expanded(
                                  flex: 2,
                                  child:
                                      Text("Close Date: ${x.endDate ?? ''}")),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Expanded(
                                  child: Text(
                                "Witness: ${x.witnessName ?? ''}",
                              )),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Witness Address: ${x.witnessAddress ?? ''}",
                                  )),
                              Expanded(
                                  child: Text(
                                      "Witness Mobile: ${x.witnessMobile ?? ''}")),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Expanded(
                                  child: Text(
                                "Remark: ${x.remark ?? ''}",
                              )),
                              Expanded(
                                  child: Text(
                                "Tenure: ${x.days ?? ''}",
                              )),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                      "Installement Amount: ${x.installement ?? ''}")),
                              Expanded(
                                  flex: 2,
                                  child: Text("Status: ${x.status ?? ''}")),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
