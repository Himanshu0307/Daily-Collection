import 'package:daily_collection/Services/PasswordService.dart';
import 'package:flutter/material.dart';

void showPasswordPopup(BuildContext context) {
  String password = "";
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Create Password'),
        content: TextField(
          onChanged: (value) => password = value,
          obscureText: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Enter new password',
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Submit'),
            onPressed: () {
              PasswordManager manager = PasswordManager();
              if (password.isNotEmpty) {
                manager
                    .setPassword(password)
                    .then((value) => Navigator.of(context).pop());
              }
              // Handle the password submission logic here
            },
          ),
        ],
      );
    },
  );
}
