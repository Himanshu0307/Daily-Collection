import 'package:flutter/material.dart';
import 'package:daily_collection/Models/SQL%20Entities/QuickLoanModel.dart';

import '../../../services/SqlService.dart';
import '../../Component/TextFieldForm.dart';

class CustomerAddWidgetForm extends StatefulWidget {
  const CustomerAddWidgetForm({super.key});

  @override
  State<CustomerAddWidgetForm> createState() => _CustomerAddWidgetFormState();
}

class _CustomerAddWidgetFormState extends State<CustomerAddWidgetForm> {
  bool isFetching = false;
  SQLService service = SQLService();

  late TextEditingController id;
  late TextEditingController name;
  late TextEditingController mobile;
  late TextEditingController address;
  late TextEditingController aadhar;
  late TextEditingController father;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id = TextEditingController();
    name = TextEditingController();
    mobile = TextEditingController();
    address = TextEditingController();
    aadhar = TextEditingController();
    father = TextEditingController();
  }

  @override
  dispose() {
    id.dispose();
    name.dispose();
    mobile.dispose();
    address.dispose();
    aadhar.dispose();
    father.dispose();
    super.dispose();
  }

  Future<void> SaveCustomer(Function(String msg) showSnackBar) async {
    if (!formstate.currentState!.validate()) return;
    // CustomerModel customerModel = CustomerModel();

    // customerModel.name = name.text.toUpperCase();
    // customerModel.mobile = mobile.text;
    // customerModel.address = address.text;
    // customerModel.aadhar = aadhar.text;
    // customerModel.father = father.text;
    // var status = await service.saveCustomer(customerModel);
    //   if (status.success) {
    //     showSnackBar(status.msg);
    //     formstate.currentState!.reset();
    //   } else if (status.success == false) showSnackBar(status.error);
  }

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    void showSnackBar(String content) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(content),
        duration: const Duration(seconds: 2),
      ));
    }

    return Form(
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
                    child: TextFieldForm(
                      "Customer Name",
                      controller: name,
                      required: true,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextFieldForm("Mobile Number",
                        controller: mobile,
                        required: true,
                        type: TextInputType.phone),
                  ),
                ],
              ),
              TextFieldForm(
                "Address",
                controller: address,
              ),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: TextFieldForm(
                      "ID",
                      controller: aadhar,
                    ),
                  ),
                  Expanded(
                    child: TextFieldForm(
                      "Father's Name",
                      controller: father,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: isFetching
                              ? null
                              : () {
                                  SaveCustomer(showSnackBar);
                                },
                          child: const Text("Add Customer")),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: isFetching
                              ? null
                              : () {
                                  formstate.currentState!.reset();
                                },
                          child: const Text("Clear")),
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
