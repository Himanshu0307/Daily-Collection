
import 'package:flutter/material.dart';

class DropdownWidget extends StatefulWidget {
  final List<dynamic> item;
  final Function(dynamic e)? onChanged;

  const DropdownWidget(this.item, this.onChanged, {super.key});

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  late var selectedValue = widget.item[0];
  @override
  void initState() {
    super.initState();
    if (widget.onChanged != null) {
      widget.onChanged!(selectedValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        borderRadius: BorderRadius.circular(50),
        isDense: true,
        isExpanded: true,
        padding: const EdgeInsets.all(8),
        elevation: 5,
        itemHeight: null,
        items: widget.item
            .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
            .toList(),
        enableFeedback: false,
        value: selectedValue,
        // icon: Icon(Icons.arrow_downward),
        onChanged: (value) {
          setState(() {
            selectedValue = value;
            if (widget.onChanged != null) widget.onChanged!(value);
          });
        });
  }
}
