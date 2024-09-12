import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomReactiveDatePicker extends StatelessWidget {
  CustomReactiveDatePicker(
      {super.key,
      this.disabled = false,
      this.firstDate,
      required this.formControlName,
      required this.label,
      this.required = true,
      this.onChange,
      this.lastDate});
  final String formControlName;
  final bool disabled;
  final DateTime? firstDate;
  final String label;
  final DateTime? lastDate;
  final bool required;
  final _controller = TextEditingController();
  final Function? onChange;

  getFormatedDate(String time) {
    return DateFormat("yyyy-MM-dd").format(DateTime.parse(time));
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveDatePicker(
        formControlName: formControlName,
        builder: (BuildContext context,
            ReactiveDatePickerDelegate<dynamic> delegate, Widget? child) {
          // set initial value
          if (delegate.value != null) {
            _controller.text = getFormatedDate(delegate.value.toString());
          }

          // Event for setting value in TextField if selected from Picker
          delegate.control.valueChanges.listen((newValue) {
            if (newValue == null) {
              _controller.text = "";
              _controller.clear();
              return;
            }

            _controller.text = getFormatedDate(newValue);
            onChange?.call(null);
          });

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 4,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (!delegate.control.touched) {
                        return null;
                      }
                      if (required == true &&
                          (value == null || value.isEmpty)) {
                        delegate.control
                            .setErrors({'required': 'Date Field is Required'});
                        return "*Required";
                      }
                      if (value == null) {
                        return null;
                      }
                      try {
                        DateFormat("yyyy-MM-dd").parseStrict(value);
                      } catch (_) {
                        delegate.control.setErrors(
                            {'format': 'Date should be in YYYY-MM-DD format'});
                        return "Date should be in YYYY-MM-DD format";
                      }
                      return null;
                    },
                    onChanged: (e) {
                      if (DateTime.tryParse(e) != null) {
                        delegate.control.patchValue(e);
                        onChange?.call();
                      }
                    },
                    controller: _controller,
                    enabled: !disabled,
                    decoration: InputDecoration(labelText: label),
                  ),
                ),
                Expanded(
                  child: IconButton(
                      onPressed: disabled ? null : delegate.showPicker,
                      icon: const Icon(Icons.calendar_today_outlined)),
                )
              ],
            ),
          );
        },
        firstDate: firstDate ?? DateTime(1999),
        lastDate: lastDate ?? DateTime(2099));
  }
}
