import 'package:daily_collection/UI/CashBook/CashbookScreen.dart';
import 'package:daily_collection/UI/Partner/PartnerScreen.dart';
import 'package:daily_collection/app/qls/qls-mainscreen.dart';
import 'package:flutter/material.dart';

import '../UI/Customer/CustomerScreen.dart';
import '../app/collection/collection-screen.dart';
import '../app/summary/loan-screen.dart';

class MainItems {
  final IconData icon;
  final String name;
  final String route;
  final String? subtitle;
  const MainItems(this.icon, this.name, this.route, {this.subtitle});
}

const List<MainItems> mainItem = [
  MainItems(Icons.money, "Quick Loan", QuickLoanMainScreen.routeName),
  MainItems(Icons.supervised_user_circle_rounded, "Customer",
      CustomerScreen.routeName),
  MainItems(Icons.list, "Loan View", LoanScreen.routeName),
  MainItems(Icons.monetization_on, "Collection", CollectionScreen.routeName),
  MainItems(Icons.book, "Cashbook", CashBookScreen.routeName),
  MainItems(Icons.handshake, "Partner", PartnerScreen.routeName)
];
