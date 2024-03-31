import 'package:daily_collection/Models/SQL%20Entities/QuickLoanModel.dart';
import 'package:daily_collection/Services/SqlService.dart';
import 'package:flutter/material.dart';

Future<CustomerModel?> showCustomerSearchScreen(
    BuildContext context, String? name) async {
  return await showSearch<CustomerModel?>(
      query: name,
      context: context,
      delegate:
          CustomerSearchDelegate(searchFieldLabel: "Enter Customer Name"));
}

class CustomerSearchDelegate extends SearchDelegate<CustomerModel?> {
  List<CustomerModel>? items;
  SQLService service = SQLService();
  String? searchText;

  Future searchSQl() async {
    items = await service.searchCustomerForLoan(query);
    return null;
  }

  CustomerSearchDelegate(
      {super.searchFieldLabel,
      super.searchFieldStyle,
      super.searchFieldDecorationTheme,
      super.keyboardType,
      super.textInputAction,
      this.searchText}) {
    if (searchText != null && searchText!.isNotEmpty) {
      query = searchText!;
      searchSQl();
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      query.isNotEmpty
          ? IconButton(
              onPressed: () {
                searchSQl().then((value) => showResults(context));
              },
              icon: const Icon(Icons.search))
          : const SizedBox(),
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  // @override
  // Widget? buildFlexibleSpace(BuildContext context) {
  //   // TODO: implement buildFlexibleSpace
  //   return AppBar(
  //     title: TextFormField(
  //       onSaved: (newValue) {
  //         if (newValue == null) {
  //           return;
  //         }
  //         query = newValue!;
  //         searchSQl();
  //       },
  //     ),
  //   );
  // }

  @override
  Widget buildResults(BuildContext context) {
    if (items == null || items!.isEmpty)
      return const Text("No data to display");
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox();
  }
}
