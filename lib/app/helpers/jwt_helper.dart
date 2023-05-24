import 'package:back_end_cuidapet/app/config/environments.dart';
import 'package:get_it/get_it.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

abstract class JwtHelper {
  static final Environments _environments = GetIt.I.get<Environments>();
  static final String _jwtSecret =
      _environments['JWT_SECRET'] ?? _environments['jwtSecret']!;

  static JwtClaim getClaims(String token) =>
      verifyJwtHS256Signature(token, _jwtSecret);
}
