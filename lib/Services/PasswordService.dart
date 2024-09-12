import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'CryptoGraphic.dart';

class PasswordManager {
  static final _passwordService = PasswordManager.initService();
  factory PasswordManager() => _passwordService;
  PasswordManager.initService();
  final _storage = const FlutterSecureStorage();

  Future<bool> checkFile() async {
    return _storage.containsKey(key: 'HashPassword');
  }

  Future<bool> checkPassword(String password) async {
    String? storedPassword = await _storage.read(key: "HashPassword");

   
    var generated = CryptoGraphic.generateHex(password);
    // print("input String Hash ${generated}");
    // print("Stored String Hash ${storedPassword}");
    return generated == storedPassword;
    }

  Future<bool> setPassword(String password) async {
    try {
      var encString = CryptoGraphic.generateHex(password);
      await _storage.write(
          key: "HashPassword",
          value: encString,
          wOptions: const WindowsOptions(useBackwardCompatibility: true));
      
      return true;
    } catch (e) {
      return false;
    }
  }
}
