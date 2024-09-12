import 'package:daily_collection/Models/SQL%20Entities/QuickLoanModel.dart';
import 'package:flutter/material.dart';

import '../../../Services/SqlService.dart';
import '../../Component/TableComponent.dart';

class LoanList extends StatefulWidget {
  const LoanList({super.key});

  @override
  State<LoanList> createState() => _LoanListState();
}

class _LoanListState extends State<LoanList> {
  SQLService service = SQLService();

  List<LoanModel> _items = [];

  var filter = "Active";

  List<LoanModel> get getFilteredData {
    if (filter == "Closed") {
      return _items.where((element) => element.status == "Closed").toList();
    }
    if (filter == "Active") {
      return _items.where((element) => element.status == "Active").toList();
    }
    return _items;
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        FutureBuilder(
            future: service.getLoanList(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.done) {
                if (snap.data == null || snap.data!.isEmpty) {
                  return const Center(child: Text("No Data found"));
                }
                _items = snap.data!;
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Flex(
                    direction: Axis.vertical,
                    children: [
                      Expanded(
                        flex: 1,
                        child: DropdownButton(
                            borderRadius: BorderRadius.circular(50),
                            isDense: true,
                            isExpanded: true,
                            padding: const EdgeInsets.all(8),
                            elevation: 5,
                            itemHeight: null,
                            value: filter,
                            items: const [
                              DropdownMenuItem(
                                value: "All",
                                child: Text("All"),
                              ),
                              DropdownMenuItem(
                                value: "Active",
                                child: Text("Active"),
                              ),
                              DropdownMenuItem(
                                value: "Closed",
                                child: Text("Closed"),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                filter = value!;
                              });
                            }),
                      ),
                      // Expanded(
                      //   flex: 10,
                      //   child: TableComponent(getFilteredData
                      //       .map((e) => e.toTableJson())
                      //       .toList()),
                      // ),
                    ],
                  ),
                );
              }
              // return Card(child: TableComponent(snap.data));
              return const Center(child: CircularProgressIndicator());
            })
      ],
    );
  }
}
