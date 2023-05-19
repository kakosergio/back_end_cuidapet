import 'package:dotenv/dotenv.dart';

class Environments {
  DotEnv? _dotEnv;

  String? param(String paramName) {
    return _dotEnv?[paramName];
  }

  void loadEnvs() {
    _dotEnv = DotEnv(includePlatformEnvironment: true)..load();
  }

  String? operator [](String paramName) => param(paramName);
}
