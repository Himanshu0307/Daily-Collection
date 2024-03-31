import 'package:daily_collection/Models/PartnersModel/PartnersModel.dart';
import 'package:daily_collection/Models/PostResponse.dart';
import 'package:daily_collection/UI/Component/AutoCompleteWidget.dart';
import 'package:daily_collection/UI/Component/CalendarPicker.dart';
import 'package:daily_collection/UI/Component/DropdownWIdget.dart';
import 'package:flutter/material.dart';

import '../../../Services/PartnerService.dart';
import '../../Component/TextFieldForm.dart';

class PartnerAddTransactionForm extends StatefulWidget {
  const PartnerAddTransactionForm({super.key});

  @override
  State<PartnerAddTransactionForm> createState() =>
      _PartnerAddTransactionFormState();
}

class _PartnerAddTransactionFormState extends State<PartnerAddTransactionForm> {
  bool isFetching = false;
  PartnerService service = PartnerService();
  List<PartnerModel>? names;

  late TextEditingController partnerId;
  late TextEditingController amount;
  late TextEditingController date;
  late TextEditingController type;
  late TextEditingController remark;
  late int selectedValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    partnerId = TextEditingController();
    amount = TextEditingController();
    date = TextEditingController();
    type = TextEditingController();
    remark = TextEditingController();
    getNameOfExistingUser();
  }

  @override
  dispose() {
    partnerId.dispose();
    amount.dispose();
    date.dispose();
    type.dispose();
    remark.dispose();
    super.dispose();
  }

  Future<PostResponse?> saveCash() async {
    if (!formstate.currentState!.validate()) return null;
    PartnerTransaction cash = PartnerTransaction(
        amount: double.parse(amount.text),
        date: date.text,
        type: type.text,
        remark: remark.text,
        partnerId: selectedValue);

    return await service.savePartnerTransaction(cash);
  }

  void getNameOfExistingUser() {
    service.getPartnersName().then((value) => setState(() {
          names = value;
          if (names != null && names!.isNotEmpty)
            selectedValue = names![0].id ?? 0;
        }));
  }

  clear() {
    formstate.currentState!.reset();
    partnerId.clear();
    amount.clear();
    // date.clear();
    // type.clear();
    remark.clear();
    setState(() {});
  }

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  void showSnackBar(String content, BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return names == null || names!.isEmpty
        ? const Text("No partner found")
        : Form(
            key: formstate,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flex(
                      direction: Axis.horizontal,
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
                              items: names!
                                  .map((e) => DropdownMenuItem(
                                      value: e.id, child: Text(e.name)))
                                  .toList(),
                              enableFeedback: false,
                              value: selectedValue,
                              // icon: Icon(Icons.arrow_downward),
                              onChanged: (value) {
                                setState(() {
                                  selectedValue = value!;
                                });
                              }),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextFieldForm("Amount",
                              controller: amount,
                              required: true,
                              type: TextInputType.number),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child:
                                CalendarPicker("Date", (p0) => date.text = p0)),
                        Expanded(
                          child: DropdownWidget(
                              const ["CR", "DR"], (e) => type.text = e),
                        ),
                      ],
                    ),
                    TextFieldForm(
                      "remark",
                      controller: remark,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  saveCash()
                                      .then((value) => value != null
                                          ? value.success
                                              ? showSnackBar(value.msg, context)
                                              : showSnackBar(
                                                  value.error, context)
                                          : showSnackBar("Error", context))
                                      .then((_) => clear());
                                },
                                child: const Text("Add Entry")),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: clear, child: const Text("Clear")),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
