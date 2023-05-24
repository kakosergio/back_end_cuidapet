import 'package:back_end_cuidapet/app/config/environments.dart';
import 'package:get_it/get_it.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class JwtHelper {
  
  static final String _jwtSecret = GetIt.I.get<Environments>()['JWT_SECRET'] ??
      GetIt.I.get<Environments>()['jwtSecret']!;

  static JwtClaim(String token) => verifyJwtHS256Signature(token, _jwtSecret);
}
