import 'package:daily_collection/Services/Cashbook.dart';
import 'package:flutter/material.dart';

class AutoCompleteWidget extends StatelessWidget {
  AutoCompleteWidget(this._suggestionList,
      {super.key, required this.onSelected, this.controller});
  Function(String)? onSelected;
  final List<String> _suggestionList;
  final TextEditingController? controller;
  final CashBookService service = CashBookService();

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      fieldViewBuilder: (ctx, controller, focusN, onsubmit) => TextFormField(
        decoration: const InputDecoration(hintText: "Enter Name"),
        focusNode: focusN,
        controller: controller,
        onEditingComplete: onsubmit,
      ),
      // optionsViewBuilder: (context, onSelected, options) => SizedBox(
      //   height: 200,
      //   child: ListView.builder(
      //     itemBuilder: (context, ind) => Card(
      //       child: Text(options.elementAt(ind)),
      //     ),
      //     itemCount: options.length,
      //   ),
      // ),
      // initialValue: value,
      optionsBuilder: (textEditingValue) {
        controller?.text = textEditingValue.text;
        if (textEditingValue.text == '') return const Iterable<String>.empty();

        // return
        return _suggestionList.where((item) =>
            item.startsWith(textEditingValue.text.trim().toUpperCase()));
      },
      onSelected: onSelected,
    );
  }
}
