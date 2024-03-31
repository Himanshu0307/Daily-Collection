import 'package:flutter/material.dart';

Future<T> showCustomerSearch<T>(BuildContext context,
    {String label = "Enter Customer Name", Function? onChanged,String? initialValue}) async {
  var result = await Navigator.of(context).push(
    MaterialPageRoute(
        builder: (context) => CustomerSearch(
              title: label,
              onChanged: onChanged,
              initialValue:initialValue ,
            )),
  );
  return result;
}

class CustomerSearch extends StatefulWidget {
  const CustomerSearch(
      {super.key,
      required this.title,
      required this.onChanged,
      this.initialValue});
  final String title;
  final Function? onChanged;
  final String? initialValue;

  @override
  State<CustomerSearch> createState() => _CustomerSearchState();
}

class _CustomerSearchState extends State<CustomerSearch> {
  late TextEditingController searchController;
  List? _searchItems;

  @override
  initState() {
    super.initState();
    searchController = TextEditingController();
    searchController.addListener(onChangedListener);
    searchController.text = widget.initialValue ?? "";
  }

  onChangedListener() {
    // setState(() {
    if (widget.onChanged != null) {
      (widget.onChanged!(searchController.text) as Future).then((value) => {
            setState(() {
              _searchItems = value;
            })
          });
    }
    // });
  }

  @override
  void dispose() {
    searchController.removeListener(onChangedListener);
    searchController.dispose();
    super.dispose();
  }

  close(BuildContext context, dynamic obj) {
    Navigator.of(context).pop(obj);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Expanded(
            flex: 7,
            child: TextFormField(
              decoration: InputDecoration(hintText: widget.title),
              controller: searchController,
            ),
          ),
          if (searchController.text.isNotEmpty)
            Expanded(
              child: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  onChangedListener();
                },
              ),
            ),
          Expanded(
            child: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                searchController.clear();
              },
            ),
          )
        ]),
      ),
      body: _searchItems == null || _searchItems!.isEmpty
          ? const Center(
              child: Text("No Data to Display"),
            )
          : ListView.builder(
              itemCount: _searchItems?.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => {close(context, _searchItems![index])},
                  child: ListTile(
                    leading: Text(
                        "Customer Id: ${_searchItems?[index].id.toString()}" ??
                            "No Id available"),
                    title:
                        Text(_searchItems?[index].name ?? "No Name Available"),
                    subtitle: Text(_searchItems?[index].mobile ?? "XXXXXXXXXX"),
                    trailing: Text(_searchItems?[index].father ??
                        _searchItems?[index].father ??
                        "No Information Availabe"),
                  ),
                );
              },
            ),
    );
  }
}
