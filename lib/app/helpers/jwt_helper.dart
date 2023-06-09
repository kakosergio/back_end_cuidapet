import 'package:back_end_cuidapet/app/config/environments.dart';
import 'package:get_it/get_it.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

abstract class JwtHelper {
  static final Environments _environments = GetIt.I.get<Environments>();
  static final String _jwtSecret =
      _environments['JWT_SECRET'] ?? _environments['jwtSecret']!;

  static String generateJWT(int userId, int? supplierId) {
    final claimSet = JwtClaim(
        issuer: 'cuidapet',
        subject: userId.toString(),
        expiry: DateTime.now().add(Duration(days: 1)),
        notBefore: DateTime.now(),
        issuedAt: DateTime.now(),
        otherClaims: <String, dynamic>{'supplier': supplierId},
        maxAge: const Duration(days: 1));
    return 'Bearer ${issueJwtHS256(claimSet, _jwtSecret)}';
  }

  static JwtClaim getClaims(String token) =>
      verifyJwtHS256Signature(token, _jwtSecret);

  static String refreshToken(String accessToken) {
    final claimSet = JwtClaim(
      issuer: accessToken,
      subject: 'RefreshToken',
      expiry: DateTime.now().add(Duration(days: 20)),
      notBefore: DateTime.now().add(Duration(hours: 12)),
      issuedAt: DateTime.now(),
    );
    return 'Bearer ${issueJwtHS256(claimSet, _jwtSecret)}';
  }
}
