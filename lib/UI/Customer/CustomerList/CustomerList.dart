import 'package:flutter/material.dart';

import '../../../services/SqlService.dart';
import '../../Component/TableComponent.dart';

class CustomerList extends StatelessWidget {
  CustomerList({super.key});
  SQLService service = SQLService();

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        FutureBuilder(
            future: service.getCustomerList(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.done) {
                if (snap.data == null || snap.data!.isEmpty) {
                  return const Text("No Data Found");
                }

                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child:
                      TableComponent(snap.data!.map((e) => e.toMap()).toList()),
                );
              }
              return const Center(child: CircularProgressIndicator());
            })
      ],
    );
  }
}
