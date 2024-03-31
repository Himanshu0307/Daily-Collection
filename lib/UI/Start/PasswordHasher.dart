import 'dart:convert';
import 'package:crypto/crypto.dart';

class HashGenerator {
  static final _hashset = HashGenerator.init();
  factory HashGenerator() => _hashset;
  HashGenerator.init();
  final String seed = "^1@D%c5*S)U!6";

  String generateHash(String input) {
    final bytes = utf8.encode("$seed$input");
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
