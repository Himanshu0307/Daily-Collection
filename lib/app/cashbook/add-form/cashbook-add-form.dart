import 'package:daily_collection/Models/CashbookEntity/CashbookEntity.dart';
import 'package:daily_collection/Models/PostResponse.dart';
import 'package:daily_collection/services/Cashbook.dart';
import 'package:daily_collection/component/ui/autocomplete.dart';
import 'package:daily_collection/UI/Component/CalendarPicker.dart';
import 'package:daily_collection/UI/Component/DropdownWIdget.dart';
import 'package:flutter/material.dart';

import '../../../UI/Component/TextFieldForm.dart';

class CashBookAddForm extends StatefulWidget {
  const CashBookAddForm({super.key});

  @override
  State<CashBookAddForm> createState() => _CashBookAddFormState();
}

class _CashBookAddFormState extends State<CashBookAddForm> {
  bool isFetching = false;
  CashBookService service = CashBookService();
  List<String>? names;

  late TextEditingController name;
  late TextEditingController amount;
  late TextEditingController date;
  late TextEditingController type;
  late TextEditingController remark;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = TextEditingController();
    amount = TextEditingController();
    date = TextEditingController();
    type = TextEditingController();
    remark = TextEditingController();
    getNameOfExistingUser();
  }

  @override
  dispose() {
    name.dispose();
    amount.dispose();
    date.dispose();
    type.dispose();
    remark.dispose();
    super.dispose();
  }

  Future<PostResponse?> saveCash() async {
    if (!formstate.currentState!.validate()) return null;
    CashbookModel cash = CashbookModel();
    cash.name = name.text;
    cash.amount = int.tryParse(amount.text) ?? 0;
    cash.date = date.text;
    cash.type = type.text;
    cash.remark = remark.text;
    return await service.saveCash(cash);
  }

  void getNameOfExistingUser() {
    service
        .getSuggestionListOfNames()
        .then((value) => setState(() => names = value));
  }

  clear() {
    formstate.currentState!.reset();
    name.clear();
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
    return Form(
      key: formstate,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Wrap(
            children: [
              Expanded(
                flex: 1,
                child: AutoCompleteWidget(
                  names ?? [],
                  onSelected: null,
                  controller: name,
                ),
              ),
              Expanded(
                flex: 1,
                child: TextFieldForm("Amount",
                    controller: amount,
                    required: true,
                    type: TextInputType.number),
              ),
              Expanded(
                  child: CalendarPicker("Date", (p0) => date.text = p0)),
              Expanded(
                child: DropdownWidget(
                    const ["CR", "DR"], (e) => type.text = e),
              ),
              TextFieldForm(
                "remark",
                controller: remark,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        saveCash()
                            .then((value) => value != null
                                ? value.success
                                    ? showSnackBar(value.msg, context)
                                    : showSnackBar(value.error, context)
                                : showSnackBar("Error", context))
                            .then((_) => clear())
                            .whenComplete(
                                () => getNameOfExistingUser());
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
