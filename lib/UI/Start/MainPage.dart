import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:platform_device_id_v3/platform_device_id.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'PasswordHasher.dart';

class SecurityPage extends StatelessWidget {
  static const route = "/SecurityPage";
  final String unauthorizedMessage =
      "You are not Authorized to use this application";
  final String onSuccessRoute;
  const SecurityPage({Key? key, this.onSuccessRoute = "/"}) : super(key: key);

  Future<bool> _checkAuthorization(BuildContext context) async {
    Directory appDir = await getApplicationSupportDirectory();
    String filePath = p.join(appDir.path, "license.txt");
    try {
      final file = File(filePath);
      if (await file.exists()) {
        var storedHexString = await file.readAsString();
        var platform = await PlatformDeviceId.getDeviceId ?? "";
        var hash = HashGenerator();
        var encrString = hash.generateHash(platform.trim());
        if (storedHexString == encrString) {
          return true;
        }
        return false;
      } else {
        log('Authorization file not found.');
        return false;
      }
    } catch (error) {
      log('Authorization file not found.');
      return false;
    }
  }

  showTimer(BuildContext context) {
    _checkAuthorization(context).then((value) => {
          value
              ? Navigator.of(context).pushNamed(onSuccessRoute)
              : showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) => AlertDialog(
                        title: const Text('Unauthorized'),
                        content: Text(unauthorizedMessage),
                        actions: [
                          TextButton(
                            onPressed: () => exit(0),
                            child: const Text('OK'),
                          ),
                        ],
                      ))
        });
  }

  @override
  Widget build(BuildContext context) {
    showTimer(context);

    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurpleAccent, Colors.deepPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Daily Collection",
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.0),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
            SizedBox(height: 10.0),
            Text(
              "Initializing application...",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
