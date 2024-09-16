import 'package:flutter/material.dart';

import '../../../Models/SQL Entities/QuickLoanModel.dart';
import '../../../Services/SqlService.dart';
import '../../../utils/toast-exception.dart';
import '../../ui/constraint-ui.dart';

class LoanCard extends StatelessWidget {
  final LoanModel loanModel;
  final Function onClear;

  const LoanCard({
    super.key,
    required this.loanModel,
    required this.onClear,
  });

  onDeleteLoan() async {
    var service = SQLService();
    var response = await service.deleteLoan(loanModel.id!);
    onClear();
    // TODO: Add Toast
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            ConstraintUI(child: Text("LoanId: ${loanModel.id}")),
            ConstraintUI(child: Text("Amount: ${loanModel.amount}")),
            ConstraintUI(
                child: Text("Loan Start Date: ${loanModel.startDate}")),
            ConstraintUI(child: Text("Loan close Date: ${loanModel.endDate}")),
            ConstraintUI(
                child: Text("Agreement Amount: ${loanModel.agreedAmount}")),
            ConstraintUI(
                child: Text("Witness: ${loanModel.witnessName ?? ""}")),
            ConstraintUI(
                child:
                    Text("Witness Address: ${loanModel.witnessAddress ?? ""}")),
            ConstraintUI(
                child:
                    Text("Witness Mobile: ${loanModel.witnessMobile ?? ""}")),
            ConstraintUI(
                child: Text(
                    "Installement Amount: ${loanModel.installement ?? ""}")),
            ConstraintUI(child: Text("Loan Tenure: ${loanModel.days ?? ""}")),
            // TODO: Add Delete functionality
            ConstraintUI(child: Text("Status: ${loanModel.status ?? ""}")),
            ConstraintUI(
                child: ElevatedButton.icon(
                    onPressed:
                        loanModel.status == "Closed" ? null : onDeleteLoan,
                    icon: const Icon(Icons.delete),
                    label: const Text("Delete Loan"))),
          ],
        ),
      ),
    );
  }
}
