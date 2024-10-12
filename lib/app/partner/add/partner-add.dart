import 'package:daily_collection/Models/PartnersModel/PartnersModel.dart';
import 'package:daily_collection/Models/PostResponse.dart';
import 'package:daily_collection/services/PartnerService.dart';
import 'package:flutter/material.dart';

import '../../../component/ui/constraint-ui.dart';
import '../../../UI/Component/TextFieldForm.dart';

class PartnerAddForm extends StatefulWidget {
  const PartnerAddForm({super.key});

  @override
  State<PartnerAddForm> createState() => _PartnerAddFormState();
}

class _PartnerAddFormState extends State<PartnerAddForm> {
  bool isFetching = false;
  PartnerService service = PartnerService();

  late TextEditingController name;
  late TextEditingController percentage;

  @override
  void initState() {
    super.initState();
    name = TextEditingController();
    percentage = TextEditingController();
  }

  @override
  dispose() {
    name.dispose();
    percentage.dispose();
    super.dispose();
  }

  Future<PostResponse?> saveCash() async {
    if (!formstate.currentState!.validate()) return null;
    return service
        .savePartners(PartnerModel(name.text, double.parse(percentage.text)));
  }

  clear() {
    formstate.currentState!.reset();
    name.clear();
    percentage.clear();

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
      child: Wrap(
        runSpacing: 20,
        spacing: 20,
        children: [
          ConstraintUI(
            child: TextFieldForm(
              "Name",
              controller: name,
              required: true,
            ),
          ),
          ConstraintUI(
            child: TextFieldForm(
              "Percentage",
              controller: percentage,
              required: true,
            ),
          ),
          ConstraintUI(
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
                        .then((_) => clear());
                  },
                  child: const Text("Add Partner")),
            ),
          ),
          ConstraintUI(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  ElevatedButton(onPressed: clear, child: const Text("Clear")),
            ),
          ),
        ],
      ),
    );
  }
}
