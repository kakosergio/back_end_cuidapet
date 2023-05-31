import 'dart:convert';

import 'package:crypto/crypto.dart';

class Sha256HashGenerator {

  static String generate(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }
}
