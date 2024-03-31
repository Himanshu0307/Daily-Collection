
import 'dart:convert';

import 'package:crypto/crypto.dart';

class CryptoGraphic {


  
  static String? generateHex(String password) {
    var salt = '^7999*4445%0009@!';
     final bytes = utf8.encode("$salt${password}111111");
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
