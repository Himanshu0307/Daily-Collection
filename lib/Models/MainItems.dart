import 'package:daily_collection/UI/CashBook/CashbookScreen.dart';
import 'package:daily_collection/UI/Partner/PartnerScreen.dart';
import 'package:daily_collection/UI/QuickLoan/QuickLoanMainScreen.dart';
import 'package:flutter/material.dart';

import '../UI/Collection/CollectionScreen.dart';
import '../UI/Customer/CustomerScreen.dart';
import '../app/collection/collection-screen.dart';
import '../app/summary/loan-screen.dart';

class MainItems {
  final IconData icon;
  final String name;
  final String route;
  final String? subtitle;
  MainItems(this.icon, this.name, this.route, {this.subtitle});
}

final List<MainItems> mainItem = [
  MainItems(Icons.money, "Quick Loan", QuickLoanMainScreen.routeName),
  MainItems(Icons.supervised_user_circle_rounded, "Customer",
      CustomerScreen.routeName),
  MainItems(Icons.list, "Loan View", LoanScreen.routeName),
  MainItems(Icons.supervised_user_circle_outlined, "Collection",
      CollectionScreen.routeName),
  MainItems(Icons.book, "Cashbook", CashBookScreen.routeName),
  MainItems(Icons.book, "Partner", PartnerScreen.routeName)
];
