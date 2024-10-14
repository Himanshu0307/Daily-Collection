import 'package:daily_collection/app/cashbook/cashbook-screen.dart';
import 'package:daily_collection/app/partner/partner-screen.dart';
import 'package:daily_collection/UI/Password/PasswordFile.dart';
import 'package:daily_collection/app/qls/qls-mainscreen.dart';
import 'package:daily_collection/UI/Start/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import 'app/customer/customer-screen.dart';
import 'app/collection/collection-screen.dart';
import 'app/summary/loan-screen.dart';
import 'app/main-screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      config: const ToastificationConfig(
        animationDuration: Duration(seconds: 2),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Loan Tracker',
        theme: ThemeData.dark(useMaterial3: true),
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
        initialRoute: "/",
      ),
    );
  }
}
