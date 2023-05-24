import 'dart:convert';

import 'package:shelf/shelf.dart';

import 'package:back_end_cuidapet/app/logger/logger.dart';
import 'package:back_end_cuidapet/app/middlewares/middlewares.dart';
import 'package:back_end_cuidapet/app/middlewares/security/security_skip_url.dart';

class SecurityMiddleware extends Middlewares {
  final Logger log;
  final skipURL = <SecuritySkipUrl>[];

  SecurityMiddleware({
    required this.log,
  });

  @override
  Future<Response> execute(Request request) async {
    if (skipURL.contains(
        SecuritySkipUrl(url: '/${request.url.path}', method: request.method))) {
      return innerHandler(request);
    }

    final authHeader = request.headers['Authorization'];

    if (authHeader == null || authHeader.isEmpty) {
      return Response.forbidden(jsonEncode({}));
    }

    final authHeaderContent = authHeader.split(' ');

    if (authHeaderContent[0] != 'Bearer') {
      return Response.forbidden(jsonEncode({}));
    }

    final authorizationToken = authHeaderContent[1];

    
  }
}
