import 'package:flutter/material.dart';

class TableComponent extends StatelessWidget {
  final List<Map<String, Object?>>? list;
  const TableComponent(
    this.list, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (list!.isEmpty) return const SizedBox();
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Table(
            border: TableBorder.all(
                width: 1,
                color: Colors.black54,
                borderRadius: BorderRadius.circular(5)),
            textBaseline: TextBaseline.alphabetic,
            children: [
              TableRow(children: [
                ...list![0]
                    .keys
                    .toList()
                    .map((e) => Text(
                          e,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ))
                    .toList()
              ]),
              ...list!
                  .map((element) => TableRow(children: [
                        ...element.values
                            .toList()
                            .map((e) => Text(
                                  e.toString(),
                                  textAlign: TextAlign.center,
                                ))
                            .toList()
                      ]))
                  .toList()
            ],
          ),
        ),
      ),
    );
  }
}
