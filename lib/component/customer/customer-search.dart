import 'package:daily_collection/Models/SQL%20Entities/QuickLoanModel.dart';
import 'package:daily_collection/services/SqlService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CustomerSearchField extends StatelessWidget {
  CustomerSearchField({super.key, required this.onSelected});
  final bool allowAnonymousSearch = true;
  final Function(CustomerModel?) onSelected;
  final SQLService _service = SQLService();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: TypeAheadField<CustomerModel>(
            hideOnSelect: true,
            controller: _controller,
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text("${suggestion.name}(${suggestion.id})"),
              );
            },
            onSelected: onSelected,
            suggestionsCallback: (String? pattern) async {
              if (pattern == null || pattern.isEmpty) {
                return [];
              }
              return await _service.getCustomerSuggestion(pattern);
            },
            debounceDuration: const Duration(seconds: 1),
          ),
        ),
        Expanded(
            child: ElevatedButton(
                onPressed: () {
                  _controller.clear();
                  onSelected(null);
                },
                child: const Text("Clear")))
      ],
    );
  }
}
