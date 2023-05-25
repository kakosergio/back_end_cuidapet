import 'dart:convert';

import 'package:back_end_cuidapet/app/helpers/jwt_helper.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:shelf/shelf.dart';

import 'package:back_end_cuidapet/app/logger/logger.dart';
import 'package:back_end_cuidapet/app/middlewares/middlewares.dart';
import 'package:back_end_cuidapet/app/middlewares/security/security_skip_url.dart';

// SecurityMiddleware recebe, através de sua função [execute] o Request do header anterior
// e faz, em resumo, a verificação do token, a descriptografia, recupera os claims,
// pega a informação de userId, token e supplier e repassa para o [header] da requisição,
// para ser utilizado posteriormente. 
class SecurityMiddleware extends Middlewares {
  final Logger log;
  final skipURL = <SecuritySkipUrl>[];

  SecurityMiddleware({
    required this.log,
  });

  @override
  Future<Response> execute(Request request) async {
    try {
      if (skipURL.contains(SecuritySkipUrl(
          url: '/${request.url.path}', method: request.method))) {
        return innerHandler(request);
      }

      final authHeader = request.headers['Authorization'];

      if (authHeader == null || authHeader.isEmpty) {
        throw JwtException.invalidToken;
      }

      final authHeaderContent = authHeader.split(' ');

      if (authHeaderContent[0] != 'Bearer') {
        throw JwtException.invalidToken;
      }

      final authorizationToken = authHeaderContent[1];
      final claims = JwtHelper.getClaims(authorizationToken);

      if (request.url.path != 'auth/refresh') {
        claims.validate();
      }

      final claimsMap = claims.toJson();

      final userId = claimsMap['sub'];
      final supplier = claimsMap['supplier'];

      if (userId == null) {
        throw JwtException.invalidToken;
      }

      final securityHeader = {
        'user': userId,
        'access_token': authorizationToken,
        'supplier': supplier
      };

      return innerHandler(request.change(headers: securityHeader));
    } on JwtException catch (e, s) {
      log.error('Error when validating JWT token', e, s);
      return Response.forbidden(jsonEncode({}));
    } catch (e, s) {
      log.error('Internal server error', e, s);
      return Response.forbidden(jsonEncode({}));
    }
  }
}
