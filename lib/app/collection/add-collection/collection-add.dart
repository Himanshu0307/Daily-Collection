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
      List<LoanModel> listLoan = await fetchLoanDetails(customer);
      info = TransactionReportModel()
        ..customerModel = customer
        ..loanModel = listLoan;
    }
    setState(() {});
  }

  fetchLoanDetails(customer) async {
    var response = await service.getActiveLoanListFromCid(customer.id);
    if (response["success"]) {
      return (response["data"] as List<Map<String, Object?>>)
          .map<LoanModel>((x) => LoanModel.fromJson(x))
          .toList();
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(child: CustomerSearchField(onSelected: onCustomerSelect)),
            if (info == null)
              const Expanded(
                  flex: 3, child: BoldTextWrapper("Select a customer"))
            else
              Expanded(flex: 3, child: InfoWidget(details: info!))
          ],
        ));
  }
}

// // ignore: must_be_immutable
// class LoanInfoView extends StatelessWidget {
//   final List<LoanModel> loanList;
//   final Function onClear;
//   final Function(CollectionModel) onSave;

//   CollectionModel request = CollectionModel();
//   late List<int?> dropdownData;

//   LoanInfoView(this.loanList, this.onClear, this.onSave, {super.key}) {
//     dropdownData = loanList.map((e) => e.id).toList();
//     // request.loanId = dropdownData[0];
//   }

//   void showSnackbar(BuildContext context, String content) {
//     ScaffoldMessenger.of(context).clearSnackBars();
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(content)));
//   }

//   GlobalKey<FormState> state = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           ...loanList
//               .map(
//                 (x) => Flex(
//                   direction: Axis.horizontal,
//                   children: [
//                     Expanded(
//                         child: TextFieldForm(
//                       "LoanId",
//                       initialValue: x.id?.toString(),
//                       enabled: false,
//                     )),
//                     Expanded(
//                         child: TextFieldForm(
//                       "Amount",
//                       initialValue: x.amount?.toString(),
//                       enabled: false,
//                     )),
//                     Expanded(
//                         child: TextFieldForm(
//                       "Agreed Amount",
//                       initialValue: x.agreedAmount?.toString(),
//                       enabled: false,
//                     )),
//                     Expanded(
//                         flex: 2,
//                         child: TextFieldForm(
//                           "Start Date",
//                           initialValue: x.startDate,
//                           enabled: false,
//                         )),
//                     Expanded(
//                         flex: 2,
//                         child: TextFieldForm(
//                           "Close Date",
//                           initialValue: x.endDate,
//                           enabled: false,
//                         )),
//                     Expanded(
//                         child: TextFieldForm(
//                       "Overdue",
//                       // initialValue:?? x.overdue.toString(),
//                       enabled: false,
//                     )),
//                   ],
//                 ),
//               )
//               .toList(),
//           Form(
//             key: state,
//             child: Flex(
//               direction: Axis.horizontal,
//               children: [
//                 Expanded(
//                   child:
//                       DropdownWidget(dropdownData, (e) => request.loanId = e),
//                 ),
//                 Expanded(
//                     flex: 2,
//                     child: TextFieldForm(
//                       "Collection Amount",
//                       validator: (value) {
//                         if (int.tryParse(value) == null) {
//                           // print(value);
//                           return "Enter Valid Amount";
//                         }
//                         return null;
//                       },
//                       required: true,
//                       onChanged: (value) =>
//                           request.amount = int.tryParse(value),
//                     )),
//                 Expanded(
//                     flex: 2,
//                     child: CalendarPicker(
//                       required: true,
//                       "Collection Date",
//                       (value) => request.collectionDate = value,
//                     )),
//               ],
//             ),
//           ),
//           Flex(
//             direction: Axis.horizontal,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ElevatedButton(
//                     onPressed: () async {
//                       if (!state.currentState!.validate()) {
//                         return;
//                       }

//                       PostResponse response = await onSave(request);
//                       if (response.success) {
//                         showSnackbar(context, response.msg);
//                         onClear();
//                       } else {
//                         showSnackbar(context, response.error);
//                       }
//                     },
//                     child: const Text("Save")),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ElevatedButton(
//                     onPressed: () => onClear(), child: const Text("Clear")),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
