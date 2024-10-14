import 'package:flutter/material.dart';

getNavBar() {
  return AppBar(
    forceMaterialTransparency: true,
    actions: const [
      Icon(Icons.supervised_user_circle_rounded),
      SizedBox(
        width: 5,
      ),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "DINESH KUMAR SHARMA",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      )
    ],
    automaticallyImplyLeading: false,
  );
}
