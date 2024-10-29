import 'dart:developer';

import 'package:daily_collection/Models/SQL%20Entities/QuickLoanModel.dart';
import 'package:daily_collection/services/SqlService.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:toastification/toastification.dart';

import '../../../../../utils/datetime.dart';
import '../../../utils/toastshow.dart';
import '../../ui/constraint-ui.dart';
import '../../ui/custom-reactive-date-picker.dart';
import 'customer-card.dart';

class QLSExistingCustomerForm extends StatefulWidget {
  const QLSExistingCustomerForm({super.key, required this.model});

  final CustomerModel model;

  @override
  State<QLSExistingCustomerForm> createState() =>
      _QLSExistingCustomerFormState();
}

class _QLSExistingCustomerFormState extends State<QLSExistingCustomerForm> {
  final SQLService _service = SQLService();

  @override
  Widget build(BuildContext context) {
    final form = FormGroup({
      'cid': FormControl<int>(value: widget.model.id),
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

    // save a loan
    Future<Null> onSaveLoan() async {
      form.markAllAsTouched();
      if (form.valid) {
        // log(form.value.toString());
        var response = await _service.saveExistingCustomerLoan(form.value);
        if (response["success"]) {
          form.reset(updateParent: false, emitEvent: true, value: {
            "cid": widget.model.id,
            "disbursementDate": DateTime.now().toString(),
            "startDate": DateTime.now().add(const Duration(days: 1)).toString()
          });
          showToast(response["message"]);
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

        form.controls["endDate"]!.updateValue(
            getFormattedDateFromString(endDate),
            emitEvent: true,
            updateParent: true);
      }
    }

    form.focus("witnessName");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: ReactiveForm(
          formGroup: form,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                QLSCustomerCard(model: widget.model),
                Wrap(
                  direction: Axis.horizontal,
                  spacing: 20,
                  runSpacing: 20,
                  children: [
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
                        decoration:
                            getDefaultTextDecoration('Agreement Amount'),
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
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: onSaveLoan, child: const Text("Save Loan")),
                )
              ],
            ),
          )),
    );
  }
}
