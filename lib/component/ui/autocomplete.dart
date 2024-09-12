import 'package:flutter/material.dart';

class AutoCompleteWidget extends StatelessWidget {
  const AutoCompleteWidget(this._suggestionList,
      {super.key, required this.onSelected, this.controller});
  final Function(String)? onSelected;
  final List<String> _suggestionList;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      fieldViewBuilder: (ctx, controller, focusN, onsubmit) => TextFormField(
        decoration: const InputDecoration(hintText: "Enter Name"),
        focusNode: focusN,
        controller: controller,
        onEditingComplete: onsubmit,
      ),
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
