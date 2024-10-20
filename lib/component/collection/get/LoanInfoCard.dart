import 'package:flutter/material.dart';

import '../../../Models/SQL Entities/QuickLoanModel.dart';
import '../../ui/constraint-ui.dart';

class Loaninfocard extends StatelessWidget {
  const Loaninfocard({super.key, required this.data});
  final LoanReportIdModel? data;
  @override
  Widget build(BuildContext context) {
    return data == null
        ? const Text("No Information Available")
        : Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 20,
                runSpacing: 30,
                children: [
                  ConstraintUI(
                      child: Text("Customer Id: ${data!.customerModel.id}")),
                  ConstraintUI(
                      child:
                          Text("Customer Name: ${data!.customerModel.name}")),
                  ConstraintUI(
                      child: Text(
                          "Customer Father Name: ${data!.customerModel.father}")),
                  ConstraintUI(
                      child: Text(
                          "Customer Document ID : ${data!.customerModel.aadhar}")),
                  ConstraintUI(child: Text("Loan ID : ${data!.loanModel.id}")),
                  ConstraintUI(
                      child: Text("Loan Amount : ${data!.loanModel.amount}")),
                  ConstraintUI(
                      child: Text(
                          "Loan Agreed Amount : ${data!.loanModel.agreedAmount}")),
                  ConstraintUI(
                      child: Text(
                          "Loan Disbursement Date : ${data!.loanModel.disbursementDate}")),
                  ConstraintUI(
                      child: Text(
                          "Loan Start Date : ${data!.loanModel.startDate}")),
                  ConstraintUI(
                      child:
                          Text("Loan Close Date : ${data!.loanModel.endDate}")),
                  ConstraintUI(
                      child: Text(
                          "Status : ${data!.loanModel.status ? "Active" : "Closed"}")),
                  ConstraintUI(
                      child: Text(
                          "Remaining Amount : ${data!.reportModel!.remaining.toString()}")),
                  ConstraintUI(
                      child: Text(
                          "Received Amount : ${data!.reportModel!.received.toString()}")),
                  ConstraintUI(
                      child: Text(
                          "Overdue : ${data!.reportModel!.overdue.toString()}")),
                  ConstraintUI(
                      child: Text(
                          "Last Installement Received : ${data!.reportModel!.lastCollection.toString()}")),
                ],
              ),
            ),
          );
  }
}
