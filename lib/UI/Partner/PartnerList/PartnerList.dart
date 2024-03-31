import 'package:daily_collection/Models/PartnersModel/PartnersModel.dart';
import 'package:daily_collection/Models/SQL%20Entities/QuickLoanModel.dart';
import 'package:flutter/material.dart';
import 'package:daily_collection/Services/SqlService.dart';
import 'package:daily_collection/UI/Component/TextFieldForm.dart';

import '../../../Models/ListItem.dart';
import '../../../Services/PartnerService.dart';
import '../../Component/CalendarPicker.dart';

class PartnerReport extends StatefulWidget {
  const PartnerReport({super.key});

  @override
  State<PartnerReport> createState() => _PartnerReportState();
}

class _PartnerReportState extends State<PartnerReport> {
  PartnerService service = PartnerService();
  int selectedValue = 0;
  List<PartnerModel>? names;
  bool isLoading = false;
  late String endDate;

  PartnersReport? _customerModel;
  List<PartnerTransaction>? _list;
  void getNameOfExistingUser() {
    service.getPartnersName().then((value) => setState(() {
          names = value;
          if (names != null && names!.isNotEmpty)
            selectedValue = names![0].id ?? 0;
        }));
  }

  @override
  initState() {
    super.initState();
    getNameOfExistingUser();
  }

  @override
  dispose() {
    super.dispose();
  }

  Future<PartnersReport?> searchPartnerDetail(
      int? partnerId, String date) async {
    if (partnerId == null) return null;
    return await service.getPartnerReport(partnerId, date);
  }

  showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (names == null) return Text("No Partner Found");
    return Column(
      children: [
        Expanded(
            child: Row(
          children: [
            Expanded(
              child: DropdownButton(
                  borderRadius: BorderRadius.circular(50),
                  isDense: true,
                  isExpanded: true,
                  padding: const EdgeInsets.all(8),
                  elevation: 5,
                  itemHeight: null,
                  items: names!
                      .map((e) =>
                          DropdownMenuItem(value: e.id, child: Text(e.name)))
                      .toList(),
                  enableFeedback: false,
                  value: selectedValue,
                  // icon: Icon(Icons.arrow_downward),
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value!;
                      _list = null;
                      _customerModel = null;
                    });
                  }),
            ),
            Expanded(child: CalendarPicker("Enter Date", (p0) => endDate = p0)),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  child: const Text("Search"),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    var result =
                        await searchPartnerDetail(selectedValue, endDate);
                    if (result == null) {
                      showSnackBar(context, "No Data Found");
                    } else {
                      var tran = service
                          .getPartnerTransactions(selectedValue, endDate)
                          .then((x) {
                        setState(() {
                          _list = x;
                          _customerModel = result;
                        });
                      }).whenComplete(() => setState(() {
                                isLoading = false;
                              }));
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
                    _list = null;
                  });
                },
              ),
            ))
          ],
        )),
        if (isLoading == true)
          const Center(child: CircularProgressIndicator())
        else
          Expanded(
            flex: 4,
            child: Reports(
              items: _list,
              partnerReport: _customerModel,
            ),
          ),
      ],
    );
  }
}

class Reports extends StatelessWidget {
  final PartnersReport? partnerReport;
  final List<PartnerTransaction>? items;

  const Reports({
    super.key,
    required this.items,
    required this.partnerReport,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        partnerReport != null
            ? Expanded(
                child: CustomerInfo(
                customer: partnerReport,
              ))
            : const SizedBox(),
        items != null && items!.isNotEmpty
            ? Expanded(flex: 5, child: ListItems(items!))
            : const SizedBox()
      ],
    );
  }
}

class CustomerInfo extends StatelessWidget {
  final PartnersReport _customer;

  const CustomerInfo({super.key, required customer}) : _customer = customer;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Flex(direction: Axis.horizontal, children: [
        Expanded(child: Text("Partner Name: ${_customer.name}")),
        Expanded(child: Text("Total Credited: ${_customer.totalCr}")),
        Expanded(child: Text("Total Debited: ${_customer.totalDr}")),
        Expanded(child: Text("final Amount: ${_customer.finalAmount}")),
      ]),
    );
  }
}

class ListItems extends StatefulWidget {
  const ListItems(this.items, {super.key});
  final List<PartnerTransaction> items;

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
            leading: Text("Amount: ${widget.items[index].amount} Rs.",
                textScaler: const TextScaler.linear(1.3)),
            title: Text(widget.items[index].type == "DR"
                ? "Debited to Partner"
                : "Partner Credited"),
            trailing: SizedBox(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                      "${widget.items[index].type == "DR" ? '-' : '+'} ${widget.items[index].amount.toString()} Rs.",
                      textScaler: const TextScaler.linear(1.5)),
                  Text("Remark: ${widget.items[index].remark}")
                ],
              ),
            ),
            subtitle: Text(widget.items[index].date),
          ),
        );
      },
    );
  }
}
