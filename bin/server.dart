import 'dart:io';

import 'package:back_end_cuidapet/app/config/app_config.dart';
import 'package:back_end_cuidapet/controller.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Calling AppConfig
  final appConfig = AppConfig();
  appConfig.loadAppConfig();
  final router = Router();

  router.mount('/helloController/', Controller().router);

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
