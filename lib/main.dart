import 'package:daily_collection/UI/CashBook/CashbookScreen.dart';
import 'package:daily_collection/UI/Partner/PartnerScreen.dart';
import 'package:daily_collection/UI/Password/PasswordFile.dart';
import 'package:daily_collection/UI/QuickLoan/QuickLoanMainScreen.dart';
import 'package:daily_collection/UI/Start/MainPage.dart';
import 'package:flutter/material.dart';

import 'UI/Collection/CollectionScreen.dart';
import 'UI/Customer/CustomerScreen.dart';
import 'UI/Loan/LoanScreen.dart';
import 'UI/MainPage/MainPageScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        SecurityPage.route: (context) => const SecurityPage(),
        "/": (context) => const PasswordScreen(),
        QuickLoanMainScreen.routeName: (context) => QuickLoanMainScreen(),
        CustomerScreen.routeName: (context) => CustomerScreen(),
        LoanScreen.routeName: (context) => LoanScreen(),
        MainPageScreen.routeName: (context) => const MainPageScreen(),
        CashBookScreen.routeName: (context) => CashBookScreen(),
        CollectionScreen.routeName: (context) => CollectionScreen(),
        PartnerScreen.routeName: (context) => PartnerScreen()
      },
      initialRoute: MainPageScreen.routeName,
    );
  }
}
