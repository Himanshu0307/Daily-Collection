import 'dart:developer';
import 'dart:io';

import 'package:daily_collection/component/ui/text-wrapper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';

import '../../../component/customer/view/customer-table.dart';
import '../../../data-source/customer-datasource.dart';
import '../../../services/SqlService.dart';

class ViewCustomerWidget extends StatefulWidget {
  const ViewCustomerWidget({super.key});

  @override
  State<ViewCustomerWidget> createState() => _ViewCustomerWidgetState();
}

class _ViewCustomerWidgetState extends State<ViewCustomerWidget> {
  final SQLService service = SQLService();

 

  fetchData() async {
    // print("response");
    var response = await service.getCustomerList();
    // print("response1sd");
    if (response["success"]) {
      var datasource = CustomerDatasource(transaction: response["data"]);
      return Future.value(datasource);
    }
    if (response["success"] == false) {
      return Future.error(Exception(response["message"]));
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchData(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            if (snap.data == null) {
              return const Text("No Data Found");
            }

            return CustomerTable(
              data: snap.data as CustomerDatasource,
             
            );
          }
          if (snap.hasError) {
            return BoldTextWrapper(snap.error.toString());
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
