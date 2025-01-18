import 'package:daily_collection/app/cashbook/cashbook-screen.dart';
import 'package:daily_collection/app/partner/partner-screen.dart';
import 'package:daily_collection/app/qls/qls-mainscreen.dart';
import 'package:flutter/material.dart';

import '../app/cashflow/cashflow-screen.dart';
import '../app/customer/customer-screen.dart';
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
  MainItems(Icons.list, "Loan Summary", LoanScreen.routeName),
  MainItems(Icons.currency_rupee, "Cashflow Summary", CashflowScreen.routeName),
  MainItems(Icons.monetization_on, "Collection", CollectionScreen.routeName),
  MainItems(Icons.book, "Cashbook", CashBookScreen.routeName),
  MainItems(Icons.handshake, "Partner", PartnerScreen.routeName)
];
