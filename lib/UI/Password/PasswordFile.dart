import 'dart:ui';
import 'package:daily_collection/Services/PasswordService.dart';
import 'package:daily_collection/app/main-screen.dart';
import 'package:flutter/material.dart';

class PasswordScreen extends StatefulWidget {
  static const routeName = "/PasswordScreen";

  const PasswordScreen({super.key});
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final PasswordManager _passwordManager = PasswordManager();
  String? _password;
  bool _showError = false;
  bool _isLoading = false;
  bool _obscureText = true;

  @override
  initState() {
    super.initState();
    _passwordManager.checkFile().then((value) => !value
        ? Navigator.of(context).pushNamed(MainPageScreen.routeName)
        : null);
  }

  _validatePassword(String password, BuildContext context) {
    setState(() {
      _isLoading = true;
      _showError = false; // Show loading indicator
    });
    _passwordManager.checkPassword(password).then((value) {
      value
          ? Navigator.of(context).pushNamed(MainPageScreen.routeName)
          : setState(() {
              _showError = true;
            });
    }).whenComplete(() => setState(() {
          _isLoading = false; // Hide loading indicator
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: AlertDialog(
        backgroundColor: Colors.transparent, // For blur effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        content: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Enter password to proceed:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10.0),
                TextField(
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    errorText: _showError ? 'Invalid password' : null,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  onChanged: (value) => _password = value,
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        _validatePassword(_password!, context);
                      },
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
