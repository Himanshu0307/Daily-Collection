import 'package:daily_collection/utils/datetime.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../Models/SQL Entities/QuickLoanModel.dart';
import '../../../services/SqlService.dart';
import '../../../utils/toastshow.dart';
import '../../ui/constraint-ui.dart';
import '../../ui/custom-reactive-date-picker.dart';

class CollectionForm extends StatefulWidget {
  CollectionForm({super.key, required List<int> loanIds}) {
    items = loanIds
        .map((x) => DropdownMenuItem<int>(value: x, child: Text(x.toString())))
        .toList();
  }
  late List<DropdownMenuItem<int>> items;

  @override
  State<CollectionForm> createState() => _CollectionFormState();
}

class _CollectionFormState extends State<CollectionForm> {
  final SQLService service = SQLService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    form.updateValue({
      "loanId": widget.items.elementAt(0).value,
      "collectionDate": getFormattedDateFromString(DateTime.now())
    });
    // form.value=widget.items.elementAt(0).value;
  }

  final form = FormGroup({
    'loanId': FormControl<int>(
      validators: [Validators.required],
    ),
    'collectionDate': FormControl<String>(
        validators: [Validators.required],
        value: getFormattedDateFromString(DateTime.now())),
    'amount': FormControl<int>(validators: [Validators.required]),
  });

  getDefaultTextDecoration(String label, [String? placeholder]) {
    return InputDecoration(labelText: label, hintText: placeholder);
  }

  Future<void> onSaveCollection() async {
    form.markAllAsTouched();
    if (form.valid) {
      // print(form.value);
      var x = CollectionModel(
          amount: form.value["amount"] as int,
          collectionDate: form.value["collectionDate"] as String,
          loanId: form.value["loanId"] as int);
      var response = await service.saveCollection(x);
      if (response["success"]) {
        resetForm();
      }
      showToast(response["message"]);
    }
  }

  resetForm() {
    form.reset(updateParent: true, emitEvent: true, value: {
      "collectionDate": DateTime.now().toIso8601String(),
      "loanId": widget.items.elementAt(0).value,
    });
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: form,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 20,
        runSpacing: 20,
        children: [
          // name
          ConstraintUI(
            child: ReactiveDropdownField(
              formControlName: 'loanId',
              // decoration: getDefaultTextDecoration('LoanId'),
              items: widget.items,
            ),
          ),

          // mobile

          // Address

          ConstraintUI(
            child: CustomReactiveDatePicker(
              formControlName: 'collectionDate',
              label: 'Collection Date',
            ),
          ),

          ConstraintUI(
            child: ReactiveTextField(
              formControlName: 'amount',
              decoration: getDefaultTextDecoration('Amount'),
            ),
          ),
          ConstraintUI(
            child: ElevatedButton(
                onPressed: onSaveCollection, child: const Text("Save Loan")),
          ),
        ],
      ),
    );
  }
}
