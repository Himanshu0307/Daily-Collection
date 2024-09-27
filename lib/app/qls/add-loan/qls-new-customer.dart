import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../Models/PostResponse.dart';
import '../../../services/SqlService.dart';
import '../../../utils/datetime.dart';
import '../../../component/ui/constraint-ui.dart';
import '../../../component/ui/custom-reactive-date-picker.dart';

class QLSNewLoanForm extends StatelessWidget {
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
    'witnessName': FormControl<String>(),
    'witnessMobile': FormControl<String>(),
    'witnessAddress': FormControl<String>(),
    'amount': FormControl<int>(validators: [
      Validators.required,
      Validators.number(allowNegatives: false)
    ]),
    'installement': FormControl<int>(validators: [
      Validators.required,
      Validators.number(allowNegatives: false)
    ]),
    'days': FormControl<int>(validators: [
      Validators.required,
      Validators.number(allowNegatives: false)
    ]),
    'agreedAmount': FormControl<int>(validators: [
      Validators.required,
      Validators.number(allowNegatives: false)
    ]),
    'startDate': FormControl<String>(validators: [
      Validators.required,
    ], value: DateTime.now().add(const Duration(days: 1)).toString()),
    'endDate': FormControl<String>(validators: [
      Validators.required,
    ], value: null),
    'disbursementDate': FormControl<String>(validators: [
      Validators.required,
    ], value: DateTime.now().toString()),
    'remark': FormControl<String>(),
  });

  QLSNewLoanForm({super.key});

// save a loan
  Future<void> onSaveLoan() async {
    form.markAllAsTouched();
    if (form.valid) {
      var response = await service.saveNewLoan(form.value);
      if (response["success"]) {
        form.reset(updateParent: false);
      }
    }
  }

  getDefaultTextDecoration(String label, [String? placeholder]) {
    return InputDecoration(labelText: label, hintText: placeholder);
  }

  onAmountCalculation(_) {
    final days = form.controls["days"]!;
    final installement = form.controls["installement"]!;
    if (days.value != null && installement.value != null) {
      form.controls["agreedAmount"]!.updateValue(
          (days.value as int) * (installement.value as int),
          emitEvent: true,
          updateParent: true);
    }
  }

  onDaysChange(_) {
    final startDate = form.controls["startDate"]!;
    final control = form.controls["days"]!;
    if (control.value != null && startDate.value != null) {
      int days = control.value as int;
      final endDate = getDateObjectFromString(startDate.value.toString())
          .add(Duration(days: days - 1));

      form.controls["endDate"]!.updateValue(getFormattedDateFromString(endDate),
          emitEvent: true, updateParent: true);
    }
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
                  // Address
                  ConstraintUI(
                    child: ReactiveTextField(
                      formControlName: 'witnessName',
                      decoration: getDefaultTextDecoration('Witness Name'),
                    ),
                  ),
                  // Address
                  ConstraintUI(
                    child: ReactiveTextField(
                      formControlName: 'witnessMobile',
                      decoration: getDefaultTextDecoration('Witness Mobile'),
                    ),
                  ),
                  // Address
                  ConstraintUI(
                    child: ReactiveTextField(
                      formControlName: 'witnessAddress',
                      decoration: getDefaultTextDecoration('Witness Address'),
                    ),
                  ),
                  ConstraintUI(
                    child: ReactiveTextField(
                      formControlName: 'amount',
                      decoration: getDefaultTextDecoration('Amount'),
                    ),
                  ),
                  ConstraintUI(
                    child: ReactiveTextField(
                      formControlName: 'installement',
                      decoration:
                          getDefaultTextDecoration('Installement Amount'),
                      onChanged: onAmountCalculation,
                    ),
                  ),
                  ConstraintUI(
                    child: ReactiveTextField(
                      formControlName: 'days',
                      decoration: getDefaultTextDecoration('Days'),
                      onChanged: (_) {
                        onDaysChange(_);
                        onAmountCalculation(_);
                      },
                    ),
                  ),
                  ConstraintUI(
                    child: ReactiveTextField(
                      formControlName: 'agreedAmount',
                      decoration: getDefaultTextDecoration('Agreement Amount'),
                    ),
                  ),
                  ConstraintUI(
                    child: CustomReactiveDatePicker(
                      formControlName: 'disbursementDate',
                      label: 'Disbursement Date',
                    ),
                  ),

                  // Start  Date
                  ConstraintUI(
                    child: CustomReactiveDatePicker(
                      formControlName: 'startDate',
                      label: 'Loan Start Date',
                      onChange: onDaysChange,
                    ),
                  ),

                  //  Close Date
                  ConstraintUI(
                    child: CustomReactiveDatePicker(
                      formControlName: 'endDate',
                      label: 'Loan Ending Date',
                    ),
                  ),

                  ConstraintUI(
                    child: ReactiveTextField(
                      formControlName: 'remark',
                      decoration: getDefaultTextDecoration('Remark'),
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
