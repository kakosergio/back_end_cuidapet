import 'dart:io';

import 'package:back_end_cuidapet/app/config/app_config.dart';
import 'package:back_end_cuidapet/app/middlewares/cors/cors_middleware.dart';
import 'package:back_end_cuidapet/app/middlewares/default_content_type/default_content_type.dart';
import 'package:back_end_cuidapet/app/middlewares/security/security_middleware.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Calling AppConfig
  final router = Router();
  final appConfig = AppConfig();
  await appConfig.loadAppConfig(router);
  final getIt = GetIt.I;

  // Configure a pipeline that logs requests.
  final handler = Pipeline()
      .addMiddleware(CorsMiddleware())
      .addMiddleware(DefaultContentType())
      .addMiddleware(SecurityMiddleware(log: getIt.get()))
      .addMiddleware(logRequests())
      .addHandler(router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
