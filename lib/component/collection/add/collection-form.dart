import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../services/SqlService.dart';
import '../../ui/constraint-ui.dart';
import '../../ui/custom-reactive-date-picker.dart';

class CollectionForm extends StatelessWidget {

   final SQLService service = SQLService();


   CollectionForm({super.key,required List<int> loanIds}){
      items=loanIds.map((x)=>DropdownMenuItem<int>(value: x,child: Text(x.toString()))).toList();
  }
  late List<DropdownMenuItem<int>> items;

   final form = FormGroup({
    'loanId': FormControl<int>(validators: [Validators.required]),
    'collectionDate': FormControl<String>(validators: [Validators.required]),
    'amount': FormControl<int>(validators: [Validators.required]),
  });


  getDefaultTextDecoration(String label, [String? placeholder]) {
    return InputDecoration(labelText: label, hintText: placeholder);
  }

  Future<void> onSaveCollection() async {
    form.markAllAsTouched();
    if (form.valid) {
      // var response = await service.saveNewLoan(form.value);
      // if (response["success"]) {
      //   form.reset(updateParent: false);
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return  ReactiveForm(
        formGroup: form,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Wrap(
                direction: Axis.horizontal,
                spacing: 20,
                runSpacing: 20,
                children: [
                  // name
                  ConstraintUI(
                    child: ReactiveDropdownField(
                      formControlName: 'loanId',
                      // decoration: getDefaultTextDecoration('LoanId'),
                      items: items,
                    ),
                  ),

                  // mobile
                 

                  // Address
                 
                  ConstraintUI(
                    child: CustomReactiveDatePicker(
                      formControlName: 'collectionDate',
                      label: 'Disbursement Date',
                    ),
                  ),

             
                  ConstraintUI(
                    child: ReactiveTextField(
                      formControlName: 'amount',
                      decoration: getDefaultTextDecoration('Remark'),
                    ),
                  ),
                  ConstraintUI(
                    child: ElevatedButton(
                        onPressed: onSaveCollection, child: const Text("Save Loan")),
                  ),
                  
                ],
              ),
            ],
          ),
        ),
      );
  }
}