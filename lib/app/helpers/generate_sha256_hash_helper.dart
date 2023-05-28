import 'dart:convert';

import 'package:crypto/crypto.dart';

class GenerateSha256HashHelper {
  final String? password;

  GenerateSha256HashHelper({
    required this.password,
  });

  String call() {
    final bytes = utf8.encode(password ?? '');
    return sha256.convert(bytes).toString();
  }
}
