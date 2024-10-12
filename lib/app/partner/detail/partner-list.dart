import 'package:flutter/material.dart';

import '../../../Models/PartnersModel/PartnersModel.dart';
import '../../../component/ui/constraint-ui.dart';
import '../../../services/PartnerService.dart';
import '../../../UI/Component/CalendarPicker.dart';

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
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 20,
          runSpacing: 20,
          children: [
            ConstraintUI(
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
            ConstraintUI(
                child: CalendarPicker("Enter Date", (p0) => endDate = p0)),
            ConstraintUI(
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
                    })),
            ConstraintUI(
                child: ElevatedButton(
              child: const Text("Clear"),
              onPressed: () {
                setState(() {
                  _customerModel = null;
                  _list = null;
                });
              },
            )),
          ],
        ),
        if (isLoading == true)
          const Center(child: CircularProgressIndicator())
        else
          Expanded(
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
            ? CustomerInfo(
                customer: partnerReport,
              )
            : const SizedBox(),
        items != null && items!.isNotEmpty
            ? Expanded(child: ListItems(items!))
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(spacing: 20, runSpacing: 20, children: [
          Text("Partner Name: ${_customer.name}"),
          Text("Total Credited: ${_customer.totalCr}"),
          Text("Total Debited: ${_customer.totalDr}"),
          Text("Final Amount: ${_customer.finalAmount}"),
        ]),
      ),
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              runSpacing: 20,
              spacing: 20,
              children: [
                // Text("Amount: ${widget.items[index].amount} Rs.",
                //     textScaler: const TextScaler.linear(1.3)),
                Text(widget.items[index].type == "DR"
                    ? "Debited to Partner"
                    : "Partner Credited"),
                Text(
                  "Amount: ${widget.items[index].type == "DR" ? '-' : '+'} ${widget.items[index].amount.toString()} Rs.",
                  // textScaler: const TextScaler.linear(1.5)
                ),
                Text("Date: ${widget.items[index].date}"),
                Text(
                  "Remark: ${widget.items[index].remark}",
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
