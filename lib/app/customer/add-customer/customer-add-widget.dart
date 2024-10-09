import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../Models/PostResponse.dart';
import '../../../services/SqlService.dart';
import '../../../utils/datetime.dart';
import '../../../component/ui/constraint-ui.dart';
import '../../../component/ui/custom-reactive-date-picker.dart';

class CustomerAddWidget extends StatelessWidget {
  final SQLService service = SQLService();
  final form = FormGroup({
    'name': FormControl<String>(validators: [Validators.required]),
    'mobile': FormControl<String>(validators: [
      Validators.required,
      Validators.number(allowNegatives: false)
    ]),
    'address': FormControl<String>(validators: [Validators.required]),
    'aadhar': FormControl<String>(validators: [Validators.required]),
    'father': FormControl<String>(),
  });

  CustomerAddWidget({super.key});

// save a loan
  Future<void> onSaveLoan() async {
    form.markAllAsTouched();
    if (form.valid) {
      var response = await service.saveCustomer(form.value);
      if (response["success"]) {
        form.reset(updateParent: false);
      }
    }
  }

  getDefaultTextDecoration(String label, [String? placeholder]) {
    return InputDecoration(labelText: label, hintText: placeholder);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ReactiveForm(
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
                    child: ReactiveTextField(
                      formControlName: 'name',
                      decoration: getDefaultTextDecoration('Name'),
                    ),
                  ),

                  // mobile
                  ConstraintUI(
                    child: ReactiveTextField(
                      formControlName: 'mobile',
                      decoration: getDefaultTextDecoration('Mobile'),
                    ),
                  ),

                  // Address
                  ConstraintUI(
                    child: ReactiveTextField(
                      formControlName: 'address',
                      decoration: getDefaultTextDecoration('Address'),
                    ),
                  ),
                  // Address
                  ConstraintUI(
                    child: ReactiveTextField(
                      formControlName: 'aadhar',
                      decoration: getDefaultTextDecoration('Document Number'),
                    ),
                  ),
                  // Address
                  ConstraintUI(
                    child: ReactiveTextField(
                      formControlName: 'father',
                      decoration: getDefaultTextDecoration('Father'),
                    ),
                  ),

                  ConstraintUI(
                    child: ElevatedButton(
                        onPressed: onSaveLoan, child: const Text("Save Loan")),
                  ),
                  ConstraintUI(
                    child: ElevatedButton(
                        onPressed: () => {
                              form.reset(
                                updateParent: true,
                                emitEvent: true,
                              )
                            },
                        child: const Text("Clear")),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
