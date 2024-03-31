import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarPicker extends StatefulWidget {
  final bool required;

  const CalendarPicker(
    this.title,
    this.onDateChanged, {
    this.required = false,
    super.key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.disabled = false,
  });
  final bool disabled;
  final String title;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function(String)? onDateChanged;

  @override
  State<CalendarPicker> createState() => _CalendarPickerState();
}

class _CalendarPickerState extends State<CalendarPicker> {
  late TextEditingController controller;
  Future<DateTime?> showDatePickerPop(BuildContext context) async {
    return await showDatePicker(
        context: context,
        firstDate: widget.firstDate ?? DateTime(1999),
        lastDate: widget.lastDate ?? DateTime(3000),
        initialDate: widget.initialDate ?? DateTime.now());
  }

  @override
  void initState() {
    // TODO: implement initState
    controller = TextEditingController(
        text: DateFormat("yyyy-MM-dd").format(DateTime.now()));
    if (widget.onDateChanged != null) widget.onDateChanged!(controller.text);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 4,
            child: TextFormField(
              autovalidateMode: AutovalidateMode.always,
              validator: (value) {
                if (required == true && (value == null || value.isEmpty)) {
                  return "*Required";
                }
                try {
                  DateFormat("yyyy-MM-dd").parseStrict(value!);
                } catch (_) {
                  return "Date should be in YYYY-MM-DD format";
                }
                return null;
              },
              onChanged: (e) {
                if (DateFormat("yyyy-MM-dd").tryParse(e) != null) {
                  e = DateFormat("yyyy-MM-dd")
                      .format(DateFormat("yyyy-MM-dd").parse(e));
                } else {
                  e = "";
                }
                if (widget.onDateChanged != null) widget.onDateChanged!(e);
              },
              enabled: !widget.disabled,
              controller: controller,
              decoration: InputDecoration(labelText: widget.title),
            ),
          ),
          Expanded(
            child: IconButton(
                onPressed: widget.disabled
                    ? null
                    : () async {
                        var datepicked = await showDatePickerPop(context);
                        if (datepicked != null) {
                          setState(() {
                            controller.text =
                                DateFormat('yyyy-MM-dd').format(datepicked);
                            if (widget.onDateChanged != null) {
                              widget.onDateChanged!(controller.text);
                            }
                          });
                        }
                      },
                icon: const Icon(Icons.calendar_today_outlined)),
          )
        ],
      ),
    );
  }
}
